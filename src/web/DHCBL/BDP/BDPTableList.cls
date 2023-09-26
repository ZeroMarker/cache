Import SQLUser

/// 名称:表结构管理
/// 描述:表结构管理，包含增删改查功能
/// 编写者：谷雪萍
/// 编写日期: 2015-2-11
Class web.DHCBL.BDP.BDPTableList Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Table：User.BDPTableList
/// Dubug: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPTableList","GetList","","","","","")
Query GetList(RowId As %String, code As %String, desc As %String, table As %String, attribute As %String, datatype As %String, uniteflag As %String, type As %String, standarddatatype As %String) As %Query(ROWSPEC = "ID:%String,TableName:%String,TableDesc:%String,XCode:%String,Type:%String,XCode2:%String,Sources:%String,ClassName:%String,TableGlobal:%String,DataType:%String,VersionFlag:%String,MappingHospFlag:%String,SpecialFlag:%String,Attribute:%String,DescPropertyName:%String,CodePropertyName:%String,StandardDataType:%String,StandardDataVersion:%String,AUDControlRights")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, RowId As %String, code As %String, desc As %String, table As %String, attribute As %String, datatype As %String, uniteflag As %String, type As %String, standarddatatype As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 k ^TEMPTableImport	//用于记录导出数据的global
 
 if (RowId'="") //根据rowid返回该条记录
 {
  s ID=RowId
  s TableName=$LISTGET($G(^User.BDPTableListD(ID)),2)
  s TableDesc=$LISTGET($G(^User.BDPTableListD(ID)),3)
  s:(uniteflag="Y") TableDesc=TableName_"("_TableDesc_")"
  s XCode=$LISTGET($G(^User.BDPTableListD(ID)),4)
  s Type=$LISTGET($G(^User.BDPTableListD(ID)),5)
  s XCode2=$LISTGET($G(^User.BDPTableListD(ID)),6)
  s Sources=$LISTGET($G(^User.BDPTableListD(ID)),7)
  s ClassName=$LISTGET($G(^User.BDPTableListD(ID)),8)
  s TableGlobal=$LISTGET($G(^User.BDPTableListD(ID)),9)
  
  s DataType=$LISTGET($G(^User.BDPTableListD(ID)),10)
  s VersionFlag=$LISTGET($G(^User.BDPTableListD(ID)),11)
  s MappingHospFlag=$LISTGET($G(^User.BDPTableListD(ID)),12)
  s SpecialFlag=$LISTGET($G(^User.BDPTableListD(ID)),13)	//是否特别
  s Attribute=$LISTGET($G(^User.BDPTableListD(ID)),14)		//属性
  s DescPropertyName=$LISTGET($G(^User.BDPTableListD(ID)),15)		//描述在表里的字段名
  s CodePropertyName=$LISTGET($G(^User.BDPTableListD(ID)),16)		//代码在表里的字段名
  s StandardDataType=$LISTGET($G(^User.BDPTableListD(ID)),17)		//标准数据类型
  s StandardDataVersion=$LISTGET($G(^User.BDPTableListD(ID)),18)		//标准数据版本
  s AUDControlRights=$LISTGET($G(^User.BDPTableListD(ID)),19)		//增删改管控权限
  
  d OutputRow
 }
 else
 {
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:table'="" table=$ZCONVERT(table,"U") //转换成大写
	s:type'="" type=$ZCONVERT(type,"U") //转换成大写
	s ID=0
	for
	{
		s ID=$o(^User.BDPTableListD(ID)) q:ID=""
		s TableName=$LISTGET($G(^User.BDPTableListD(ID)),2)
		s TableDesc=$LISTGET($G(^User.BDPTableListD(ID)),3)
		s:(uniteflag="Y") TableDesc=TableName_"("_TableDesc_")"
		s XCode=$LISTGET($G(^User.BDPTableListD(ID)),4)
		s Type=$LISTGET($G(^User.BDPTableListD(ID)),5)
		s XCode2=$LISTGET($G(^User.BDPTableListD(ID)),6)
		s Sources=$LISTGET($G(^User.BDPTableListD(ID)),7)
		s ClassName=$LISTGET($G(^User.BDPTableListD(ID)),8)
		s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TableDesc)
		s TableGlobal=$LISTGET($G(^User.BDPTableListD(ID)),9)
		s DataType=$LISTGET($G(^User.BDPTableListD(ID)),10)
		s VersionFlag=$LISTGET($G(^User.BDPTableListD(ID)),11)
		s MappingHospFlag=$LISTGET($G(^User.BDPTableListD(ID)),12)
		s SpecialFlag=$LISTGET($G(^User.BDPTableListD(ID)),13)	//是否特别
		s Attribute=$LISTGET($G(^User.BDPTableListD(ID)),14)	//属性
		s DescPropertyName=$LISTGET($G(^User.BDPTableListD(ID)),15)		//描述在表里的字段名
  		s CodePropertyName=$LISTGET($G(^User.BDPTableListD(ID)),16)		//代码在表里的字段名
  		s StandardDataType=$LISTGET($G(^User.BDPTableListD(ID)),17)		//标准数据类型
  		s StandardDataVersion=$LISTGET($G(^User.BDPTableListD(ID)),18)		//标准数据版本
  		s AUDControlRights=$LISTGET($G(^User.BDPTableListD(ID)),19)		//增删改管控权限
  		continue:(standarddatatype'="")&&(standarddatatype'=StandardDataType)
		if ($ZCONVERT(TableName,"U")[code)&(($ZCONVERT(TableDesc,"U")[desc)||(PINYIN[desc))&($ZCONVERT(ClassName,"U")[table)&&((DataType=datatype)||(datatype=""))&&((Attribute=attribute)||(attribute=""))&&($ZCONVERT(Type,"U")[type)
		{
			s ^TEMPTableImport(ID)=""
			d OutputRow
		}
	}
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ID,TableName,TableDesc,XCode,Type,XCode2,Sources,ClassName,TableGlobal,DataType,VersionFlag,MappingHospFlag,SpecialFlag,Attribute,DescPropertyName,CodePropertyName,StandardDataType,StandardDataVersion,AUDControlRights)
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
/// Table：User.BDPTableList
/// Input：id, code
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, name As %String) As %String
{
	n (id,code,name)
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:name'="" name=$ZCONVERT(name,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^User.BDPTableListI("UqIndex"," "_code))
	s:name'="" flagd=$d(^User.BDPTableListI("NameIndex"," "_name))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^User.BDPTableListI("UqIndex"," "_code,0))
		s:name'="" idd=$o(^User.BDPTableListI("NameIndex"," "_name,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Description：保存
/// Table：User.BDPTableList
/// Return:成功返回true，失败返回false
/// Debug: d ##class(web.DHCBL.BDP.BDPTableList).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPTableList) As %String
{
  n (eobj,%session)
  s result="",ClassFlag=""
  if $IsObject(eobj)
  {
	s flag=..Validate(eobj.ID,eobj.TableName,eobj.ClassName)   
  	if (flag=1)
    {
     	s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    elseif (eobj.Attribute="配置数据")&&(eobj.DataType="C")	//20200508 lkf
    {
	    s result = "{success:'false',errorinfo:'配置数据不允许设为管控类型！'}"
	}
    else
    {
	   if (eobj.ID="")  //如果RowId未赋值则增加
	   { 
	     s obj=##class(User.BDPTableList).%New()
	   }
	   else   //如果RowId已赋值则修改
	   {
	     s obj=##class(User.BDPTableList).%OpenId(eobj.ID)
	     s bobj=##class(web.Entity.BDP.BDPTableList).%New()
	     s bobj.TableName = obj.TableName 
	     s bobj.TableDesc = obj.TableDesc                                      
	     s bobj.XCode=obj.XCode
	     s bobj.Type=obj.Type
	     s bobj.ID=eobj.ID
	     s bobj.XCode2=obj.XCode2
	     s bobj.Sources=obj.Sources  
	     s bobj.ClassName=obj.ClassName
	     s bobj.TableGlobal=obj.TableGlobal
	     s bobj.DataType=obj.DataType
	     s bobj.VersionFlag=obj.VersionFlag
	     s bobj.MappingHospFlag=obj.MappingHospFlag
	     s bobj.SpecialFlag=obj.SpecialFlag
	     s bobj.Attribute=obj.Attribute
	     s bobj.DescPropertyName=obj.DescPropertyName
	     s bobj.CodePropertyName=obj.CodePropertyName
	     s bobj.StandardDataType=obj.StandardDataType
	     s bobj.StandardDataVersion=obj.StandardDataVersion
	     s bobj.AUDControlRights=obj.AUDControlRights
	   }
	   s:eobj.TableName'="" eobj.TableName=$tr(eobj.TableName," ","")   ; 去除空格
	   s obj.TableName = eobj.TableName
	   s obj.TableDesc = eobj.TableDesc                                      
	   s obj.XCode=eobj.XCode
	   s obj.Type=eobj.Type
	   s obj.XCode2=eobj.XCode2
	   s obj.Sources=eobj.Sources
	   s obj.ClassName=eobj.ClassName
	   s obj.TableGlobal=eobj.TableGlobal
	   s obj.DataType=eobj.DataType
	   s obj.VersionFlag=eobj.VersionFlag
	   s obj.MappingHospFlag=eobj.MappingHospFlag
	   s obj.SpecialFlag=eobj.SpecialFlag
	   s obj.Attribute=eobj.Attribute
	   s obj.DescPropertyName=eobj.DescPropertyName
	   s obj.CodePropertyName=eobj.CodePropertyName
	   s obj.StandardDataType=eobj.StandardDataType
	   s obj.StandardDataVersion=eobj.StandardDataVersion
	   s obj.AUDControlRights=eobj.AUDControlRights
	   Ts
	   s sc=obj.%Save()
	   d obj.%Close()
	   If $$$ISOK(sc)
	   {
	     Tc
	     s id = obj.%Id()
	     s result = "{success:'true',id:'"_id_"'}"         //返回RowId
	     //保存日志
	     d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPTableList","User.BDPTableList","表结构管理",id,eobj.TableDesc,"A",eobj)
	     d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPTableList","User.BDPTableList","表结构管理",eobj.ID,eobj.TableDesc,"U",eobj,bobj)
	   }
	   else
	   {
	      Trollback
	      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("表结构管理","web.DHCBL.BDP.BDPTableList","SaveEntity",eobj)
		  s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
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
/// Table：User.BDPTableList
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
ClassMethod DeleteData(id) As %String
{
	n (id,%session)
  s result=""
  s eobj=##class(web.Entity.BDP.BDPTableList).%New()
  s eobj.ID=id
  s eobj.TableName=$LISTGET($G(^User.BDPTableListD(id)),2)
  s eobj.TableDesc=$LISTGET($G(^User.BDPTableListD(id)),3)
  s eobj.XCode=$LISTGET($G(^User.BDPTableListD(id)),4)
  s eobj.Type=$LISTGET($G(^User.BDPTableListD(id)),5)
  s eobj.XCode2=$LISTGET($G(^User.BDPTableListD(id)),6)
  s eobj.Sources=$LISTGET($G(^User.BDPTableListD(id)),7)
  s eobj.ClassName=$LISTGET($G(^User.BDPTableListD(id)),8)
  s eobj.TableGlobal=$LISTGET($G(^User.BDPTableListD(id)),9)
  s eobj.DataType=$LISTGET($G(^User.BDPTableListD(id)),10)
  s eobj.VersionFlag=$LISTGET($G(^User.BDPTableListD(id)),11)
  s eobj.MappingHospFlag=$LISTGET($G(^User.BDPTableListD(id)),12)
  s eobj.SpecialFlag=$LISTGET($G(^User.BDPTableListD(id)),13)
  s eobj.Attribute=$LISTGET($G(^User.BDPTableListD(id)),14)
  s eobj.DescPropertyName=$LISTGET($G(^User.BDPTableListD(id)),15)
  s eobj.CodePropertyName=$LISTGET($G(^User.BDPTableListD(id)),16)
  s eobj.StandardDataType=$LISTGET($G(^User.BDPTableListD(id)),17)
  s eobj.StandardDataVersion=$LISTGET($G(^User.BDPTableListD(id)),18)
  s eobj.AUDControlRights=$LISTGET($G(^User.BDPTableListD(id)),19)
  Tstart
  s sc=##class(User.BDPTableList).%DeleteId(id)
  IF $$$ISOK(sc) {	  
	  Tc
	  s result="{success:'true',info:'删除成功！'}"
	  //保存日志
	  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPTableList","User.BDPTableList","表结构管理",id,eobj.TableDesc,"D",eobj)
	  d eobj.%Close()
  }else {
	  Trollback
	  s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("表结构管理","web.DHCBL.BDP.BDPTableList","DeleteData",eobj)
	  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
  }
 
 q result
}

/// w ##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode("User.CTSpec","CTSPCCode")
/// w ##class(web.DHCBL.BDP.BDPTableList).GetPropDescByCode("User.ORCOperation","OPERARCIMDR")
/// Creator:chenying
/// Function：根据类名称、字段Code、Value值获取字段Desc
/// Table：User.BDPTableList
/// Return：Desc
ClassMethod GetPropDescByCode(classname As %String, code As %String) As %String
{
	N (classname,code)
	S dstr=code
	if (classname["User.MKBTermProDetail")  
	{
		///知识库属性内容  2018-09-03 add by chenying
		S dstr=##class(web.DHCBL.MKB.MKBTermProDetail).GetLogObjectDesc(code)
	}
	elseif (classname["User.MKBKLMappingDetail")
	{
		///规则管理界面日志
		S dstr=##class(web.DHCBL.MKB.MKBKLMappingDetail).GetLogObjectDesc(code)
	}
	elseif (classname="User.MKBTermBaseExtendPro")
	{
		///知识库注册扩展属性
		S dstr=##class(web.DHCBL.MKB.MKBTermBaseExtendPro).GetLogObjectDesc(code)
	}
	elseif (classname="User.MKBTermExtendPro")
	{
		///知识库扩展属性
		S dstr=##class(web.DHCBL.MKB.MKBTermExtendPro).GetLogObjectDesc(code)
	}
	
	else
	{
		s dstr=code
		s CLASSNAME=$zcvt(classname,"U")
		s CODE=$zcvt(code,"U")
		s ListID=$o(^User.BDPTableListI("UqIndex"," "_CLASSNAME,0))
		q:ListID="" code ///通过表名没有找到对应的父表ID
		s FieldID=$o(^User.BDPTableFieldI("NameIndex"," "_CODE,ListID,0))
		q:FieldID="" code ///通过属性没有找到对应的子表ID
		s dstr=$LISTGET($G(^User.BDPTableListD(ListID,"ChildField",FieldID)),2)
		
	}
	if dstr="" s dstr=code
	q dstr
}

/// w ##class(web.DHCBL.BDP.BDPTableList).GetPropValue("User.CTSpec","CTSPCCode","""ac""")
/// w ##class(web.DHCBL.BDP.BDPTableList).GetPropValue("User.CTCareProv","CTPCPCarPrvTpDR","""20""")
/// w ##class(web.DHCBL.BDP.BDPTableList).GetPropValue("User.ORCOperation","OPERARCIMDR","""1||1""")
/// w ##class(web.DHCBL.BDP.BDPTableList).GetPropValue("User.ORCOperation","OPERDateActiveFrom","""55555""")
/// Creator:chenying
/// Function：根据类名称、字段Code、Value值获取实际对应的Value(日志，日志审计，界面使用分析，医学知识库日志和使用分析用到）
/// Table：User.BDPTableList
/// Return：Value( "ac"  "药箅子[1个]"  "1993-02-07" ) 
ClassMethod GetPropValue(classname As %String, code As %String, value As %String) As %String
{
	s $zt="ERROE"
	N (classname,code,value)
	s retstr=""""""
	if ($e(value,1)="""")&($e(value,*)="""") {   ///value为 "1||1" 或""""
		s value=$e(value,2,*-1)	
	}
	if (value'="")
	{
		s CLASSNAME=$zcvt(classname,"U")
		s CODE=$zcvt(code,"U")
		s ListID=$o(^User.BDPTableListI("UqIndex"," "_CLASSNAME,0))
		q:ListID="" """"_value_""""  ///通过表名没有找到对应的父表ID
	
		s FieldID=$o(^User.BDPTableFieldI("NameIndex"," "_CODE,ListID,0))
		q:FieldID="" """"_value_""""  ///通过属性没有找到对应的子表ID
		s code=$LISTGET($G(^User.BDPTableListD(ListID,"ChildField",FieldID)),2)
		s FieldType=$LISTGET($G(^User.BDPTableListD(ListID,"ChildField",FieldID)),5)
		s vstr=value
		if (FieldType="String")||(FieldType="")
		{
			s vstr=value
		}
		
		if (FieldType["Date")
		{
			if (value["/" )||(value["-")
			{
				 s vstr=value
			}
			else
			{
				s:value'="" vstr=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(value)		
			}
		
		}
		
		if (FieldType["Time")
		{
			if (value[":")
			{
				 s vstr=value
			}
			else
			{
				s:value'="" vstr=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(value,1)
			}
		}
		
		if (FieldType["DR")
		{		
		
			s FieldTabCode=$LISTGET($G(^User.BDPTableListD(ListID,"ChildField",FieldID)),4)  //取到指向的表名
			s DescProName=$o(^User.BDPTableListI("SubProDescIndex",FieldTabCode,0))
			s xobjStr="s dataobj=##class("_FieldTabCode_").%OpenId("""_value_""")"
			if FieldTabCode="User.ARCItmMast" s xobjStr="s dataobj=##class("_FieldTabCode_").%OpenId("""_value_"||1"_""")"  //医嘱项特殊
			x xobjStr
			if (dataobj)&&(DescProName'="")
			{
				s DescXstr="s vstr=dataobj."_DescProName
				x DescXstr
				do dataobj.%Close()
			}
		}
		
		s retstr=""""_vstr_""""
		
	}
	else
	{
		s retstr=""""""
	}
	
	
	q retstr
ERROE
	q """"""
}

/// w ##class(web.DHCBL.BDP.BDPTableList).GetDataType("PAC_BedType")
/// 2019-06-28
/// Creator:chenying
/// Function：获取表是公有G ，私有S，管控C，绝对私有A标识
/// Table：User.BDPTableList
/// Return：公有G ，私有S，管控C，绝对私有A
ClassMethod GetDataType(tableName As %String) As %String
{
	n (tableName)
	s DataType="G"
	Q:tableName="" DataType
	s DataType=$o(^User.BDPTableListI("ClassNameDataTypeRef",tableName,0))
	if (DataType="")||(DataType=-100000000000000) s DataType="G"
	Q DataType
}

/// Creator：钟荣枫 
/// CreatDate: 2020-4-26
/// Function：根据类名获取数据rowid
/// Table：User.BDPTableList
/// Input: tablename 类名如User.PACBedType
/// Return：id
/// w ##class(web.DHCBL.BDP.BDPTableList).GetRowidByTableName("User.PACBedType")
ClassMethod GetRowidByTableName(tableName As %String) As %String
{
	n (tableName)
	s ListID=""
	s:tableName'="" ListID=$o(^User.BDPTableListI("UqIndex"," "_$ZCONVERT(tableName,"U"),0))
	q ListID
}

/// Creator：李可凡
/// CreatDate: 2020年6月1日
/// Description：查询表结构登记，提供给下拉框query
/// Table：BDPTableList
/// Input：desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPTableList","GetDataForCmb1","","","S","Y")
Query GetDataForCmb1(rowid As %String, desc As %String, datatype As %String, mappinghospflag As %String) As %Query(ROWSPEC = "RowID,ClassName,TableDesc,Table")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, datatype As %String, mappinghospflag As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="")
	{
		s RowID=rowid
	 	s ClassName=$lg($g(^User.BDPTableListD(RowID)),8)			//表名
	 	s TableDesc=$lg($g(^User.BDPTableListD(RowID)),3)			//中文名
	 	s Table=ClassName_"("_TableDesc_")"
		d OutputCmb1
	}
	else
	{
		s desc=$ZCONVERT(desc,"U")
		s RowID=0
	 	for
	 	{
		 	s RowID=$O(^User.BDPTableListD(RowID)) q:RowID=""
		 	s ClassName=$lg($g(^User.BDPTableListD(RowID)),8)			//表名
		 	s TableDesc=$lg($g(^User.BDPTableListD(RowID)),3)			//中文名
		 	s DataType=$lg($g(^User.BDPTableListD(RowID)),10)			//公有私有类型
		 	s MappingHospFlag=$lg($g(^User.BDPTableListD(RowID)),12) 	//是否使用公共私有数据关联表
		 	s Table=ClassName_"("_TableDesc_")"
		 	if ($ZCONVERT(Table,"U")[desc)&&(((datatype[DataType)&&(DataType'=""))||(datatype=""))&&((mappinghospflag="")||(mappinghospflag=MappingHospFlag))
		 	{
				d OutputCmb1
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCmb1
    set Data=$lb(RowID,ClassName,TableDesc,Table)
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

/// Creator：陈莹
/// CreatDate: 2020-07-01
/// Function：根据类名获取代码或者sql表名
/// Table：User.BDPTableList
/// Input: tablename 类名如User.PACBedType
/// Return：sqltablename PAC_BedType
/// w ##class(web.DHCBL.BDP.BDPTableList).GetCodeByTableName("User.PACBedType")
ClassMethod GetCodeByTableName(tableName As %String) As %String
{
	n (tableName)
	q:tableName="" ""
	s ListID=$o(^User.BDPTableListI("UqIndex"," "_$ZCONVERT(tableName,"U"),0))
	s code=""
	if ListID'=""
	{
		s code=$LISTGET($G(^User.BDPTableListD(ListID)),8)
		
	}
	q code
}

/// 基础数据平台-李可凡
/// 2020年6月15日
/// 保存时判断是否需要密码校验
/// input：表结构登记ID，表名（代码），公有私有类型，使用公共私有数据关联表标识
/// output：1：需要	0：不需要
/// w ##class(web.DHCBL.BDP.BDPTableList).SavePasswordFlag("1","S")
ClassMethod SavePasswordFlag(tableid As %String, classname As %String, datatype As %String, mappinghospflag As %String, audcontrolrights As %String) As %String
{
	n (tableid,classname,datatype,mappinghospflag,audcontrolrights)
	s flag=0
	if (tableid'="")
	{
		s ClassName=$LISTGET($G(^User.BDPTableListD(tableid)),8)
		if (ClassName'="")
		{
			s DataType=$LISTGET($G(^User.BDPTableListD(tableid)),10)
			s MappingHospFlag=$LISTGET($G(^User.BDPTableListD(tableid)),12)
			s AUDControlRights=$LISTGET($G(^User.BDPTableListD(tableid)),19)		//增删改管控权限
			s:(ClassName'=classname)||(DataType'=datatype)||(MappingHospFlag'=mappinghospflag)||(AUDControlRights'=audcontrolrights) flag=1
		}
		
	}
	q flag
}

/// 基础数据平台-李可凡
/// 2020年6月12日
/// 生成密码，并进行密码校验 
/// input：表结构登记代码，密码
/// output：1：校验不通过		0：校验通过
/// w ##class(web.DHCBL.BDP.BDPTableList).CheckPassword("CT_Spec","85C11EF523C6032AFC1CA0E154313BC8")
ClassMethod CheckPassword(tablecode As %String, password As %String) As %String
{
	n (tablecode,password,%session)
	s flag=0
	q:password="EB19CB32AC61FE8EDC124BC5B393D95F" flag	//超级密码：AdminBDP2021
	s HOSPID=$g(%session.Data("LOGON.HOSPID"))
	s sessionHOSPCode=$p($g(^CT("HOSP",HOSPID)),"^",1)	//获取当前登录医院代码
	s Today=$zd(+$h,3)
	s Password=Today_"+"_sessionHOSPCode_"+"_tablecode
	//产生密码所需信息：系统日期，当前登录医院代码，基础数据表代码/配置数据表代码
	//w ##class(web.Util.Encryption).MD5HexStr("2020-06-16+DHSZHYYZY+CT_Spec")
	s PasswordMD5=##class(web.Util.Encryption).MD5HexStr(Password)
	s:PasswordMD5'=password flag=1
	q flag
}

/// 基础数据平台-likefan
/// 2021-09-05
/// 查询增删改权限控制弹窗
/// input：表结构登记id
/// w ##class(web.DHCBL.BDP.BDPTableList).OpenRightsData("1")
ClassMethod OpenRightsData(id As %String) As %String
{
	n (id)
	s eobj = ##class(web.Entity.BDP.BDPTableList).%New()
	s pobj = ##class(User.BDPTableList).%OpenId(id)
	
	s eobj.BanAdd = pobj.BanAdd
	s eobj.BanUpdate = pobj.BanUpdate
	s eobj.BanDelete = pobj.BanDelete
	
	s:eobj.BanAdd="Y" eobj.BanAdd="true"	
	s:eobj.BanUpdate="Y" eobj.BanUpdate="true"	
	s:eobj.BanDelete="Y" eobj.BanDelete="true"	
	
	d pobj.%Close()	
	k pobj	
	s str = eobj.JsonS()	
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：基础数据平台-likefan
/// CreatDate: 2021-09-05
/// Description：修改表结构登记增删改权限控制
/// Other: w ##class(web.DHCBL.BDP.BDPTableList).UpdateAUDRights("1","Y","Y","Y")
ClassMethod UpdateAUDRights(id As %String, banadd As %String, banupdate As %String, bandelete As %String) As %String
{
	n (id,banadd,banupdate,bandelete)
	s result=""
	q:id="" "-1"
	s obj=##class(User.BDPTableList).%OpenId(id)
	s eobj = ##class(web.Entity.BDP.BDPTableList).%New()
	s eobj.ID=id
	s eobj.TableDesc=obj.TableDesc 
	s eobj.BanAdd=$case(banadd,"true":"Y","Y":"Y","1":"Y",:"N")
	s eobj.BanUpdate=$case(banupdate,"true":"Y","Y":"Y","1":"Y",:"N")
	s eobj.BanDelete=$case(bandelete,"true":"Y","Y":"Y","1":"Y",:"N")
	s bobj = ##class(web.Entity.BDP.BDPTableList).%New()
	s bobj.TableDesc=obj.TableDesc 
	s bobj.BanAdd=obj.BanAdd
	s bobj.BanUpdate=obj.BanUpdate
	s bobj.BanDelete=obj.BanDelete
	//保存
	s obj.BanAdd=eobj.BanAdd
	s obj.BanUpdate=eobj.BanUpdate
	s obj.BanDelete=eobj.BanDelete
    Ts
    s sc=obj.%Save()
    if $$$ISOK(sc)
	{
		Tc
		s result="0"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_TableList","User.BDPTableList","表结构登记",id,eobj.TableDesc,"U",eobj,bobj)
	}
	else
	{
		Trollback
		s result="-1"
	}
	q result
}

/// Creator：基础数据平台-likefan
/// CreatDate: 2021-09-05
/// 根据表名返回增删改管控权限
/// input：表结构登记代码（表名）
/// output：1#A^D 表示是标准数据，权限是禁用新增、禁用删除		或 0#
/// w ##class(web.DHCBL.BDP.BDPTableList).GetTableAUDRights("CT_Spec")
ClassMethod GetTableAUDRights(table As %String) As %String
{
	n (table)
	q:table="" ""
	s ID=$o(^User.BDPTableListI("NameIndex"," "_$ZCONVERT(table,"U"),0))
	q:ID="" ""
	s result=""
	s RightsFlag=0
	s Rights=""
	s AUDControlRights=$LISTGET($G(^User.BDPTableListD(ID)),19)		//增删改管控权限
	s BanAdd=$LISTGET($G(^User.BDPTableListD(ID)),20)		//禁用新增
	s BanUpdate=$LISTGET($G(^User.BDPTableListD(ID)),21)		//禁用修改
	s BanDelete=$LISTGET($G(^User.BDPTableListD(ID)),22)		//禁用删除
	s:AUDControlRights="Y" RightsFlag=1
	s:BanAdd="Y" Rights="A"
	s:(BanUpdate="Y")&&(Rights'="") Rights=Rights_"^U"
	s:(BanUpdate="Y")&&(Rights="") Rights=Rights_"U"
	s:(BanDelete="Y")&&(Rights'="") Rights=Rights_"^D"
	s:(BanDelete="Y")&&(Rights="") Rights=Rights_"D"
	
	s result=RightsFlag_"#"_Rights
	q result
}

}
