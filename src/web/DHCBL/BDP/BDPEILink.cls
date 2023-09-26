/// 导入导出基础配置表
Class web.DHCBL.BDP.BDPEILink Extends %RegisteredObject
{

/// Creator：
/// CreatDate: 2014-9-1
/// Description：修改时打开的数据
/// Table：User.BDPEILink
/// Input：id
/// Other: w ##class(web.DHCBL.BDP.BDPEILink).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.BDP.BDPEILink).%New()
	s eobj.ID = id
	s eobj.EILFileName=$listget($g(^User.BDPEILinkD(id)),2)
	s eobj.EILType=$listget($g(^User.BDPEILinkD(id)),3)
	s eobj.EILFileType=$listget($g(^User.BDPEILinkD(id)),4)
	s eobj.EILEIType=$listget($g(^User.BDPEILinkD(id)),5)
	s eobj.EILStartSheet=$listget($g(^User.BDPEILinkD(id)),6)
	s eobj.EILEndSheet=$listget($g(^User.BDPEILinkD(id)),7)
	s eobj.EILStartRow=$listget($g(^User.BDPEILinkD(id)),8)

	s str = eobj.JsonS()	
	d eobj.%Close()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：
/// CreatDate: 2014-9-2
/// Description：根据ID删除基础配置的内容
/// Table：User.BDPEILink2
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s eobj = ##class(web.Entity.BDP.BDPEILink).%New()
	s eobj.ID = id
	s eobj.EILFileName=$listget($g(^User.BDPEILinkD(id)),2)
	s eobj.EILType=$listget($g(^User.BDPEILinkD(id)),3)
	s eobj.EILFileType=$listget($g(^User.BDPEILinkD(id)),4)
	s eobj.EILEIType=$listget($g(^User.BDPEILinkD(id)),5)
	s eobj.EILStartSheet=$listget($g(^User.BDPEILinkD(id)),6)
	s eobj.EILEndSheet=$listget($g(^User.BDPEILinkD(id)),7)
	s eobj.EILStartRow=$listget($g(^User.BDPEILinkD(id)),8)
	s sc=##class(User.BDPEILink).%DeleteId(id)
	if $$$ISOK(sc)
	{
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPEILINK","User.BDPEILink","导入导出基础配置表",id,eobj.EILFileName,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Description：数据重复验证方法，由js调用
/// Input：id, code
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s flag="",flagc=""
	s:code'="" flagc=$d(^User.BDPEILinkI("EILFileNameI"," "_code))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^User.BDPEILinkI("EILFileNameI"," "_code,0))
		if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Description：保存基础配置的内容
/// Table：User.BDPEILink
/// Input：web.Entity.BDP.BDPEILink
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.BDP.BDPEILink).SaveData()
ClassMethod SaveData(eobj As web.Entity.BDP.BDPEILink) As %String
{
	s result="",flag=""
	if $IsObject(eobj)
	{
		s flag=..Validate(eobj.ID,eobj.EILFileName)  //调用重复验证
  		if (flag=1)
  		{
  	 		s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  		}
 		 else
  		{
			if (eobj.ID="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.BDPEILink).%New()
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.BDPEILink).%OpenId(eobj.ID)
				s bobj=##class(web.Entity.BDP.BDPEILink).%New()
				s bobj.ID=eobj.ID				
				s bobj.EILFileName=obj.EILFileName
				s bobj.EILFileType=obj.EILFileType
				s bobj.EILType=obj.EILType
				s bobj.EILEIType=obj.EILEIType
				s bobj.EILStartSheet=obj.EILStartSheet
				s bobj.EILEndSheet=obj.EILEndSheet
				s bobj.EILStartRow=obj.EILStartRow
			}
			Ts
			        
			s obj.EILFileName = eobj.EILFileName         
			s obj.EILType = eobj.EILType  
			s obj.EILEIType = eobj.EILEIType  
			s obj.EILFileType = eobj.EILFileType
			s obj.EILStartSheet = eobj.EILStartSheet    
			s obj.EILEndSheet = eobj.EILEndSheet
			s obj.EILStartRow = eobj.EILStartRow 
	
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
				//新增时，日志
				d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPEILINK","User.BDPEILink","导入导出基础配置表",id,eobj.EILFileName,"A",eobj)
				//修改时，日志
				d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPEILINK","User.BDPEILink","导入导出基础配置表",eobj.ID,eobj.EILFileName,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
  		}				
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
ERROE
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：
/// CreatDate: 2014-8-25
/// Description：查询基础配置的内容
/// Table：User.BDPEILink
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPEILink","GetList","","","")
Query GetList(rowid As %String, filename As %String, type As %String, filetype As %String, eitype As %String) As %Query(ROWSPEC = "ID:%String,EILFileName:%String,EILType:%String,EILFileType:%String,EILEIType:%String,EILStartSheet:%String,EILEndSheet:%String,EILStartRow:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, filename As %String, type As %String, filetype As %String, eitype As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid		
		s EILFileName=$listget($g(^User.BDPEILinkD(ID)),2)
		s EILType=$listget($g(^User.BDPEILinkD(ID)),3)
		s EILFileType=$listget($g(^User.BDPEILinkD(ID)),4)
		s EILEIType=$listget($g(^User.BDPEILinkD(ID)),5)
		s EILStartSheet=$listget($g(^User.BDPEILinkD(ID)),6)
		s EILEndSheet=$listget($g(^User.BDPEILinkD(ID)),7)
		s EILStartRow=$listget($g(^User.BDPEILinkD(ID)),8)

		d OutputRow
	}
	else
	{
		s:filename'="" filename=$ZCONVERT(filename,"U") //转换成大写
		s:type'="" type=$ZCONVERT(type,"U") //转换成大写
		s ID=0
		for {
			s ID=$o(^User.BDPEILinkD(ID))
			q:ID=""			
			s EILFileName=$listget($g(^User.BDPEILinkD(ID)),2)
			s EILType=$listget($g(^User.BDPEILinkD(ID)),3)
			s EILFileType=$listget($g(^User.BDPEILinkD(ID)),4)
			s EILEIType=$listget($g(^User.BDPEILinkD(ID)),5)
			s EILStartSheet=$listget($g(^User.BDPEILinkD(ID)),6)
			s EILEndSheet=$listget($g(^User.BDPEILinkD(ID)),7)
			s EILStartRow=$listget($g(^User.BDPEILinkD(ID)),8)

			if ($ZCONVERT(EILFileName,"U")[filename)&($ZCONVERT(EILType,"U")[type)&(EILFileType[filetype)&(EILEIType[eitype)
			{
				d OutputRow
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,EILFileName,EILType,EILFileType,EILEIType,EILStartSheet,EILEndSheet,EILStartRow)
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

}
