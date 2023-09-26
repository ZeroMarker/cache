/// 2014.02和药库物资合并，不维护
/// 名称:药学 1生产厂家
/// 描述:生产厂家维护，包含增删改查功能
/// 编写者:基础平台组 - 陈莹 
/// 编写日期: 2012-8-30
Class web.DHCBL.CT.PHManufacturer Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：陈莹 	
/// CreatDate: 2012-8-29
/// Description：查询 生产厂家
/// Table：User.PHManufacturer
/// Input：rowid, code, name
/// Output: PHMNFRowId,PHMNFCode,PHMNFName,PHMNFAddress,PHMNFTel
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHManufacturer","GetList","","","")
Query GetList(rowid As %String, code As %String, name As %String) As %Query(ROWSPEC = "PHMNFRowId:%String,PHMNFCode:%String,PHMNFName:%String,PHMNFAddress:%String,PHMNFTel:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, name As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHMNFRowId=rowid
		s PHMNFCode= $p($g(^PHMNF(PHMNFRowId)),"^",1)
		s PHMNFName = $p($g(^PHMNF(PHMNFRowId)),"^",2)
		s obj=##class(User.PHManufacturer).%OpenId(rowid)
		s myCount=obj.PHMNFAddress.Count()
		s PHMNFAddress=""
		f i=1:1:myCount {
			s PHMNFAddress=PHMNFAddress_obj.PHMNFAddress.GetAt(i)
		}
		s PHMNFTel = $p($g(^PHMNF(PHMNFRowId)),"^",3)	
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:name'="" name=$ZCONVERT(name,"U")
		s AuStr=##class(web.DHCBL.Authorize.PHManufacturer).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHMNFRowId=0
		for
		{
			s PHMNFRowId=$o(^PHMNF(PHMNFRowId)) q:PHMNFRowId=""
			s strRowId="{ID:"_PHMNFRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHMNFCode=$p($g(^PHMNF(PHMNFRowId)),"^",1)
				s PHMNFName = $p($g(^PHMNF(PHMNFRowId)),"^",2)
				s PHMNFCode1=$ZCONVERT(PHMNFCode,"U")
				s PHMNFName1=$ZCONVERT(PHMNFName,"U")
				s obj=##class(User.PHManufacturer).%OpenId(PHMNFRowId)
				s myCount=obj.PHMNFAddress.Count()
				s PHMNFAddress=""
				f i=1:1:myCount {
					s PHMNFAddress=PHMNFAddress_obj.PHMNFAddress.GetAt(i)
				}
				s PHMNFTel = $p($g(^PHMNF(PHMNFRowId)),"^",3)
				i (PHMNFCode1[code)&(PHMNFName1[name)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHMNFRowId,PHMNFCode,PHMNFName,PHMNFAddress,PHMNFTel)
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

/// Creator：陈莹 	
/// CreatDate: 2012-8-29
/// Description：查询 生产厂家
/// Table：User.PHManufacturer
/// Input：code, desc(name)
/// Output: PHMNFRowId,PHMNFCode,PHMNFName
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHManufacturer","GetDataForCmb1","","")
Query GetDataForCmb1(code As %String, desc As %String) As %Query(ROWSPEC = "PHMNFRowId:%String,PHMNFCode:%String,PHMNFName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s AuStr=##class(web.DHCBL.Authorize.PHManufacturer).DHCGetDataByDefaultSession()
	s AuFlag=0
	;未授权情况下，默认显示全部数据
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	s PHMNFRowId=0
	for
	{
		s PHMNFRowId=$o(^PHMNF(PHMNFRowId)) q:PHMNFRowId=""
		s strRowId="{ID:"_PHMNFRowId_"}"
		if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
		{
			s PHMNFCode=$p($g(^PHMNF(PHMNFRowId)),"^",1)
			s PHMNFName = $p($g(^PHMNF(PHMNFRowId)),"^",2)
			s PHMNFCode1=$ZCONVERT(PHMNFCode,"U")
			s PHMNFName1=$ZCONVERT(PHMNFName,"U")
			i (PHMNFCode1[code)&(PHMNFName1[desc)
			{
				d OutputRowCmb
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(PHMNFRowId,PHMNFCode,PHMNFName)
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

/// Creator:陈莹 
/// CreatDate:2012-12-24
/// Description:数据重复验证方法,js调用
/// Table:User.PHManufacturer
/// Input:id, code, name
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PHManufacturer).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, name As %String) As %String
{
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:name'="" name=$$ALPHAUP^SSUTIL4(name) //$ZCONVERT(name,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^PHMNF(0,"Code",code))
	s:name'="" flagd=$d(^PHMNF(0,"Name",name))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0))
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s idd=""
		s:code'="" idc=$o(^PHMNF(0,"Code",code,0))
		s:name'="" idd=$o(^PHMNF(0,"Name",name,0))
		if (name="")
		{
			if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		else
		{
			if (code="")
			{
				if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
				else  s flag=0 //返回不重复标志
			}
			else
			{
				if ((idc'=id)||(idd'=id))&((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
				else  s flag=0 //返回不重复标志
			}
		}
	}
	q flag
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.PHManufacturer
/// Input:PHMNFRowId
/// Other:w ##class(web.DHCBL.CT.PHManufacturer).OpenData(5)
ClassMethod OpenData(PHMNFRowId As %String) As %String
{
    s str = ""
	s pobj = ##class(User.PHManufacturer).%OpenId(PHMNFRowId)
	s eobj = ##class(web.Entity.CT.PHManufacturer).%New()
	s eobj.PHMNFRowId = PHMNFRowId
	s eobj.PHMNFCode  = pobj.PHMNFCode
	s eobj.PHMNFName = pobj.PHMNFName
	s myCount=pobj.PHMNFAddress.Count()
	s eobj.PHMNFAddress=""
	f i=1:1:myCount {
		s eobj.PHMNFAddress=eobj.PHMNFAddress_pobj.PHMNFAddress.GetAt(i)
	}
	s eobj.PHMNFTel =pobj.PHMNFTel
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	;s str="{list:[{PHMNFRowId:'"_eobj.PHMNFRowId_"',PHMNFCode:'"_eobj.PHMNFCode_"',PHMNFName:'"_eobj.PHMNFName_"',PHMNFAddress:'"_eobj.PHMNFAddress_"',PHMNFTel:'"_eobj.PHMNFTel_"'}]}"
	q str
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：保存 生产厂家
/// Table：User.PHManufacturer
/// Return:成功返回true和id，失败返回false和errorinfo
ClassMethod SaveEntity(eobj As web.Entity.CT.PHManufacturer) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{	
		if (eobj.PHMNFRowId="")
		{	
	        s obj=##class(User.PHManufacturer).%New()
		}
		else
		{
			s obj=##class(User.PHManufacturer).%OpenId(eobj.PHMNFRowId)
		}
		s obj.PHMNFCode = eobj.PHMNFCode
		s obj.PHMNFName = eobj.PHMNFName
		d obj.PHMNFAddress.Clear()
		d obj.PHMNFAddress.Insert(eobj.PHMNFAddress)
		s obj.PHMNFTel = eobj.PHMNFTel
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.PHMNFRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PH_Manufacturer","User.PHManufacturer","生产厂家",id,eobj.PHMNFName,"A",eobj)
			d:eobj.PHMNFRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PH_Manufacturer","User.PHManufacturer","生产厂家",id,eobj.PHMNFName,"U",eobj)
		}else{
			Trollback
			s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
ERROR
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:陈莹
/// CreatDate:2013-8-22
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	i ($d(^PHCD(0,"Manuf",+id))'=0)
	{
		s myInfo=myInfo_"<药学项>"
	}
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：根据id删除 生产厂家
/// Table：User.PHManufacturer
/// Input：id 
/// Return：成功返回true和info，失败返回false和info
/// Other:d ##class(web.DHCBL.CT.PHManufacturer). DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.PHManufacturer).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.PHManufacturer).%OpenId(id)
		s eobj = ##class(web.Entity.CT.PHManufacturer).%New()
		s eobj.PHMNFRowId = id
		s eobj.PHMNFCode  = pobj.PHMNFCode
		s eobj.PHMNFName = pobj.PHMNFName
		s myCount=pobj.PHMNFAddress.Count()
		s eobj.PHMNFAddress=""
		f i=1:1:myCount {
			s eobj.PHMNFAddress=eobj.PHMNFAddress_pobj.PHMNFAddress.GetAt(i)
		}
		s eobj.PHMNFTel =pobj.PHMNFTel
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.PHManufacturer).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PH_Manufacturer","User.PHManufacturer","生产厂家",id,eobj.PHMNFName,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

}
