/// 名称:实施综合管理平台-数据库字典表
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2020-10-21
Class web.CDSS.CMKB.DataTableDict Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：阚延新	
/// CreatDate: 2020-10-21
/// Description：查询 数据库字典
/// Table:CT.WDT.CDSS.DataTableDict 数据库字典表
/// Input:id, code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DataTableDict","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,TableSpaceName,TableNum,TableName,TableFieldNum,TableFieldName,TableFieldClass,TableFieldLength,TableFieldKeyFlag,TableFieldFkey,TableFieldDefaults,TableFieldDesc,Remarks,PMDataType")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s TableSpaceName= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),2)
        s TableNum= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),3)
        s TableName= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),4)
        s TableFieldNum= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),5)
        s TableFieldName= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),6)
        s TableFieldClass= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),7)
        s TableFieldLength= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),8)
        s TableFieldKeyFlag= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),9)
        s TableFieldKeyFlag=$case(TableFieldKeyFlag,"0":"是","1":"否",:"")
        s TableFieldFkey= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),10)
		s TableFieldDefaults= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),11)
		s TableFieldDesc= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),12)
		s Remarks= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),13)
		s PMDataType= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),14)
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.DataTableDictD(ID))
			q:ID=""
            s TableSpaceName= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),2)
            s TableNum= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),3)
            s TableName= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),4)
            s TableFieldNum= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),5)
            s TableFieldName= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),6)
            s TableFieldClass= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),7)
            s TableFieldLength= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),8)
            s TableFieldKeyFlag= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),9)
            s TableFieldKeyFlag=$case(TableFieldKeyFlag,"0":"是","1":"否",:"")
            s TableFieldFkey= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),10)
		    s TableFieldDefaults= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),11)
		    s TableFieldDesc= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),12)
		    s Remarks= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),13)
		    s PMDataType= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),14)
		    i ($ZCONVERT(TableName,"U")[code)&(($$ALPHAUP^SSUTIL4(TableFieldName)[desc)||($$ALPHAUP^SSUTIL4(TableFieldDesc)[desc))
			{
				d OutputRow
			}	
		}
						
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,TableSpaceName,TableNum,TableName,TableFieldNum,TableFieldName,TableFieldClass,TableFieldLength,TableFieldKeyFlag,TableFieldFkey,TableFieldDefaults,TableFieldDesc,Remarks,PMDataType)
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

/// Creator:阚延新
/// CreatDate:2020-10-21
/// Description:数据重复验证方法,js调用
/// Table:CT.WDT.CDSS.DataTableDict 
/// Input:id, 
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.DataTableDict).FormValidate("","a","CT.WDT.CDSS.AllergyHistory")
ClassMethod FormValidate(id As %String, TableFieldName As %String, TableName As %String) As %String
{
	
	s flag=0
	s idc=$o(^CT.WDT.CDSS.DataTableDictI("FieldNameIndex",TableFieldName,TableName,0))
	s idd=$o(^CT.WDT.CDSS.DataTableDictI("TableNameIndex",TableName,TableFieldName,0))
	if (id="")
	{
	   if ((idc'="")||(idd'="")) 
	   {
		  s flag=1  //返回重复标志 
	   }
	}
	else	//如果不为空，修改时的重复判断
	{
		
	 	if (((idc'=id)&&(idc'=""))||((idd'=id)&&(idd'="")))
	 	{
		 	
		 	s flag=1  //返回重复标志
	 	}
	} 
	q flag
}

/// Creator:阚延新
/// CreatDate: 2020-10-21
/// Description：数据库字典的增改
/// Table:CT.WDT.CDSS.DataTableDict
/// Input: eobj As web.CDSSEntity.CMKB.DataTableDict
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.CMKB.DataTableDict).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.DataTableDict) As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s flag=..FormValidate(eobj.ID,eobj.TableFieldName,eobj.TableName)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.DataTableDict).%New()
		}else	//修改
		{
			s obj=##class(CT.WDT.CDSS.DataTableDict).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.CMKB.DataTableDict).%New()
			s bobj.ID = eobj.ID		
			s bobj.TableSpaceName=eobj.TableSpaceName				
		    s bobj.TableNum=eobj.TableNum
		    s bobj.TableName=eobj.TableName
		    s bobj.TableFieldNum=eobj.TableFieldNum
		    s bobj.TableFieldName=eobj.TableFieldName
		    s bobj.TableFieldClass=eobj.TableFieldClass
		    s bobj.TableFieldLength=eobj.TableFieldLength
		    s bobj.TableFieldKeyFlag=eobj.TableFieldKeyFlag
		    s:eobj.TableFieldKeyFlag="" bobj.TableFieldKeyFlag ="0"
		    s:eobj.TableFieldKeyFlag="on" bobj.TableFieldKeyFlag ="1" 
	     	s bobj.TableFieldFkey=eobj.TableFieldFkey
	    	s bobj.TableFieldDefaults=eobj.TableFieldDefaults
	    	s bobj.TableFieldDesc=eobj.TableFieldDesc				             
	    	s bobj.Remarks=eobj.Remarks	
	    	s bobj.PMDataType=eobj.PMDataType			
		}
		s obj.TableSpaceName=eobj.TableSpaceName				
		s obj.TableNum=eobj.TableNum
		s obj.TableName=eobj.TableName
		s obj.TableFieldNum=eobj.TableFieldNum
		s obj.TableFieldName=eobj.TableFieldName
		s obj.TableFieldClass=eobj.TableFieldClass
		s obj.TableFieldLength=eobj.TableFieldLength
		s obj.TableFieldKeyFlag=eobj.TableFieldKeyFlag
		s:eobj.TableFieldKeyFlag="" obj.TableFieldKeyFlag ="0"
		s:eobj.TableFieldKeyFlag="on" obj.TableFieldKeyFlag ="1" 
		s obj.TableFieldFkey=eobj.TableFieldFkey
		s obj.TableFieldDefaults=eobj.TableFieldDefaults
		s obj.TableFieldDesc=eobj.TableFieldDesc				             
		s obj.Remarks=eobj.Remarks
		s obj.PMDataType=eobj.PMDataType							
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:阚延新
/// CreatDate:2020-10-21
/// Description：修改时打开的数据
/// Table:CT.WDT.CDSS.DataTableDict
/// Input：id-数据库字典的Id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.CMKB.DataTableDict).NewOpenData("2")
ClassMethod NewOpenData(Id As %String) As %String
{
    s str="" 
    s eobj=##class(web.CDSSEntity.CMKB.DataTableDict).%New()
    s eobj.ID=Id 
    s eobj.TableSpaceName=$lg($g(^CT.WDT.CDSS.DataTableDictD(Id)),2)
    s eobj.TableNum= $lg($g(^CT.WDT.CDSS.DataTableDictD(Id)),3)
    s eobj.TableName= $lg($g(^CT.WDT.CDSS.DataTableDictD(Id)),4)
	s eobj.TableFieldNum= $lg($g(^CT.WDT.CDSS.DataTableDictD(Id)),5)
	s eobj.TableFieldName= $lg($g(^CT.WDT.CDSS.DataTableDictD(Id)),6)
	s eobj.TableFieldClass= $lg($g(^CT.WDT.CDSS.DataTableDictD(Id)),7)
	s eobj.TableFieldLength= $lg($g(^CT.WDT.CDSS.DataTableDictD(Id)),8)
	s eobj.TableFieldKeyFlag= $lg($g(^CT.WDT.CDSS.DataTableDictD(Id)),9)
	s eobj.TableFieldFkey= $lg($g(^CT.WDT.CDSS.DataTableDictD(Id)),10)
	s eobj.TableFieldDefaults= $lg($g(^CT.WDT.CDSS.DataTableDictD(Id)),11) 
	s eobj.TableFieldDesc= $lg($g(^CT.WDT.CDSS.DataTableDictD(Id)),12) 
	s eobj.Remarks= $lg($g(^CT.WDT.CDSS.DataTableDictD(Id)),13)
	s eobj.PMDataType= $lg($g(^CT.WDT.CDSS.DataTableDictD(Id)),14) 
    s str = eobj.JsonS()    
    d eobj.%Close()
    q str
}

/// Creator:阚延新
/// CreatDate:2020-10-21
/// Description：根据ID删除数据库字典表的内容
/// Table:CT.WDT.CDSS.DataTableDict
/// Input：id-数据库字典的Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Others:w ##class(web.CDSS.CMKB.DataTableDict).DeleteData("4")
ClassMethod DeleteData(Id As %String) As %String
{
	s result=""
	Quit:Id="" result="{success:'false',info:'删除失败,入参为空！'}"  
	TSTART
	s sc=##class(CT.WDT.CDSS.DataTableDict).%DeleteId(Id)
	if ($$$ISOK(sc))
	{
		TCOMMIT
		s result="{success:'true',info:'删除成功！'}"  
	}
	else
	{
		TROLLBACK
		s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
		
	}
	Quit result
}

/// Creator:徐文虎
/// CreatDate:2020-12-04
/// Description：根据英文名称回对应中文名称
/// Table:CT.WDT.CDSS.DataTableDict
/// Input：TableFieldName
/// Return：ChineseName
/// Others:w ##class(web.CDSS.CMKB.DataTableDict).Transform("")
ClassMethod Transform(tablefieldname As %String) As %String
{
	s ID=0
	s ChineseName=tablefieldname
	s:tablefieldname'="" tablefieldname=$ZCONVERT(tablefieldname,"U") //转换成大写
	for
	{
		s ID=$o(^CT.WDT.CDSS.DataTableDictD(ID))
		q:ID=""
        s TableFieldName= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),6)
		s TableFieldDesc= $lg($g(^CT.WDT.CDSS.DataTableDictD(ID)),12)
		if ($ZCONVERT(TableFieldName,"U")=tablefieldname){
			s ChineseName=TableFieldDesc
		}
	}
	q ChineseName
}

}
