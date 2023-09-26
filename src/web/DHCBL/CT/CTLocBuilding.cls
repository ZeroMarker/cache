/// 医院楼表，包含增删改等方法
/// 基础数据平台-李可凡
/// 2020年8月11日
Class web.DHCBL.CT.CTLocBuilding Extends %RegisteredObject
{

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年8月11日
/// Description：查询医院楼表的内容,提供给下拉框
/// Table：User.CTLocBuilding
/// Input：rowid,code,desc
/// output: 医院楼rowid，医院楼代码，医院楼描述
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocBuilding","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid, code, desc, hospid) As %Query(ROWSPEC = "CTLBRowId,CTLBCode,CTLBDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid, code, desc, hospid) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s code=$ZCONVERT(code,"U")
	s desc=$ZCONVERT(desc,"U")
	if (rowid'="") //根据rowid返回该条记录
	{
		s CTLBRowId=rowid
		s CTLBCode=$p($g(^CT("CTLB",CTLBRowId)),"^",1)		//医院楼代码
		s CTLBDesc=$p($g(^CT("CTLB",CTLBRowId)),"^",2)		//医院楼描述
		d OutputRowCmb
	}
	else
	{
		s CTLBRowId=0	
		for  
		{	
			s CTLBRowId=$o(^CT("CTLB",CTLBRowId)) q:CTLBRowId=""
			s CTLBCode=$p($g(^CT("CTLB",CTLBRowId)),"^",1)		//医院楼代码
			s CTLBDesc=$p($g(^CT("CTLB",CTLBRowId)),"^",2)		//医院楼描述
			s CTLBHospitalDR=$p($g(^CT("CTLB",CTLBRowId)),"^",6)	//医院dr
			continue:CTLBHospitalDR'=hospid
			s PINYIN=""
			s:CTLBDesc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLBDesc)
			if ($ZCONVERT(CTLBCode,"U")[code)&&(($ZCONVERT(CTLBDesc,"U")[desc)||(PINYIN[desc))
			{
				d OutputRowCmb
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(CTLBRowId,CTLBCode,CTLBDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年8月11日
/// Description：查询医院楼表的内容
/// Table：User.CTLocBuilding
/// Input：rowid,code,desc
/// output：医院楼rowid，医院楼代码，医院楼描述，开始日期，结束日期，备注，医院
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocBuilding","GetList","","","")
Query GetList(rowid, code, desc, hospid) As %Query(ROWSPEC = "CTLBRowId,CTLBCode,CTLBDesc,CTLBDateFrom,CTLBDateTo,CTLBMark,CTLBHospitalDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc, hospid) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s code=$ZCONVERT(code,"U")
	s desc=$ZCONVERT(desc,"U")
	if (rowid'="") //根据rowid返回该条记录
	{
		s CTLBRowId=rowid
		s CTLBCode=$p($g(^CT("CTLB",CTLBRowId)),"^",1)		//医院楼代码
		s CTLBDesc=$p($g(^CT("CTLB",CTLBRowId)),"^",2)		//医院楼描述
		s CTLBDateFrom=$p($g(^CT("CTLB",CTLBRowId)),"^",3)		//开始日期
		s CTLBDateTo=$p($g(^CT("CTLB",CTLBRowId)),"^",4)		//结束日期
		s CTLBMark=$p($g(^CT("CTLB",CTLBRowId)),"^",5)		//备注
		s CTLBHospitalDR=$p($g(^CT("CTLB",CTLBRowId)),"^",6)	//医院dr
		s:CTLBHospitalDR'="" CTLBHospitalDR=$p($g(^CT("HOSP",CTLBHospitalDR)),"^",2)	//医院描述
		s:CTLBDateFrom'="" CTLBDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTLBDateFrom)	//转换日期格式
		s:CTLBDateTo'="" CTLBDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTLBDateTo)	//转换日期格式
		d OutputRow
	}
	else
	{
		s CTLBRowId=0	
		for  
		{	
			s CTLBRowId=$o(^CT("CTLB",CTLBRowId)) q:CTLBRowId=""
			s CTLBCode=$p($g(^CT("CTLB",CTLBRowId)),"^",1)		//医院楼代码
			s CTLBDesc=$p($g(^CT("CTLB",CTLBRowId)),"^",2)		//医院楼描述
			s CTLBDateFrom=$p($g(^CT("CTLB",CTLBRowId)),"^",3)		//开始日期
			s CTLBDateTo=$p($g(^CT("CTLB",CTLBRowId)),"^",4)		//结束日期
			s CTLBMark=$p($g(^CT("CTLB",CTLBRowId)),"^",5)		//备注
			s CTLBHospitalDR=$p($g(^CT("CTLB",CTLBRowId)),"^",6)	//医院dr
			s:CTLBDateFrom'="" CTLBDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTLBDateFrom)	//转换日期格式
			s:CTLBDateTo'="" CTLBDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTLBDateTo)	//转换日期格式
			s PINYIN=""
			s:CTLBDesc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLBDesc)
			if ($ZCONVERT(CTLBCode,"U")[code)&&(($ZCONVERT(CTLBDesc,"U")[desc)||(PINYIN[desc))&&((CTLBHospitalDR=hospid)||(hospid=""))
			{
				s:CTLBHospitalDR'="" CTLBHospitalDR=$p($g(^CT("HOSP",CTLBHospitalDR)),"^",2)	//医院描述
				d OutputRow
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(CTLBRowId,CTLBCode,CTLBDesc,CTLBDateFrom,CTLBDateTo,CTLBMark,CTLBHospitalDR)
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

/// Description：保存修改
/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年8月11日
/// input: eobj对象，包含窗口维护信息
/// output: 成功失败信息
/// Table：User.CTLocBuilding
ClassMethod SaveEntity(eobj As web.Entity.CT.CTLocBuilding) As %String
{
	s result=""
	s:eobj.CTLBDateFrom'="" eobj.CTLBDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTLBDateFrom)
	s:eobj.CTLBDateTo'="" eobj.CTLBDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTLBDateTo)
	s:eobj.CTLBDateFrom="" eobj.CTLBDateFrom=+$h
    s flag=..FormValidate(eobj.CTLBRowId,eobj.CTLBCode,eobj.CTLBDesc,eobj.CTLBHospitalDR)
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
		if (eobj.CTLBRowId="")
		{	
			s obj=##class(User.CTLocBuilding).%New()
		}
		else 
		{
	    	s obj=##class(User.CTLocBuilding).%OpenId(eobj.CTLBRowId)
			s bobj=##class(web.Entity.CT.CTLocBuilding).%New()
			s bobj.CTLBRowId = eobj.CTLBRowId
			s bobj.CTLBCode=obj.CTLBCode
			s bobj.CTLBDesc=obj.CTLBDesc
			s bobj.CTLBDateFrom=obj.CTLBDateFrom
			s bobj.CTLBDateTo=obj.CTLBDateTo
			s bobj.CTLBMark=obj.CTLBMark
			s:obj.CTLBHospitalDR'="" bobj.CTLBHospitalDR=obj.CTLBHospitalDR.%Id()
		}
		s obj.CTLBCode=eobj.CTLBCode	//医院楼代码
		s obj.CTLBDesc=eobj.CTLBDesc	//医院楼描述
		s obj.CTLBDateFrom=eobj.CTLBDateFrom	//开始日期
		s obj.CTLBDateTo=eobj.CTLBDateTo	//结束日期
		s obj.CTLBMark=eobj.CTLBMark	//备注
		d obj.CTLBHospitalDRSetObjectId(eobj.CTLBHospitalDR)	//医院
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.CTLBRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocBuilding","User.CTLocBuilding","医院楼",id,eobj.CTLBDesc,"A",eobj)
			d:eobj.CTLBRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocBuilding","User.CTLocBuilding","医院楼",id,eobj.CTLBDesc,"U",eobj,bobj)
		}
		else
		{
			Tro
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医院楼","web.DHCBL.CT.CTLocBuilding","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
		}	
	}
	q result
ERROE
	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医院楼","web.DHCBL.CT.CTLocBuilding","SaveEntity",eobj)
	s ^ERRORLOGINFO(logid)=$ze 
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年8月31日
/// function：删除校验
/// input：医院楼id
/// output：是否引用
/// debug：w ##class(web.DHCBL.CT.CTLocBuilding).GetRefFlag("5")
ClassMethod GetRefFlag(id As %String) As %String
{
	s result=""
	s myInfo=""
	
	//User.CTLoc
	s CTLOCRowID=0
	for 
	{
		s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
		s CTLOCFloor=$p($g(^CTLOC(CTLOCRowID)),"^",16)      //楼层
		s CTLBFParRef=$p(CTLOCFloor,"||",1)
		if (CTLBFParRef=id)
		{
			s myInfo=myInfo_"<科室病区>"
			q
		}
	}
	
	//User.PACRoom
	s ROOMRowID=0
	for 
	{
		s ROOMRowID=$o(^PAROOM(ROOMRowID)) q:ROOMRowID=""
		s ROOMFloorDR=$p($g(^PAROOM(ROOMRowID)),"^",11)      //楼层
		s CTLBFParRef=$p(ROOMFloorDR,"||",1)
		if (CTLBFParRef=id)
		{
			s myInfo=myInfo_"<房间>"
			q
		}
	}
	
	s:myInfo="" result="0^未被引用可删除！"
	s:myInfo'="" result="1^在"_myInfo_"表里被引用,不能删除！"
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年8月11日
/// Description：数据重复校验 
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.CTLocBuilding).FormValidate("1","01","","2")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String) As %String
{
	s flag=0
	if (hospid'="")
	{
		if code'=""
		{
			s idc=$o(^CT("CTLB",0,"Code",$$ALPHAUP^SSUTIL4(code),hospid,0))
			if (idc'="")&&(id'=idc) s flag=1
		}
		if desc'=""
		{
			s idd=$o(^CT("CTLB",0,"Desc",$$ALPHAUP^SSUTIL4(desc),hospid,0))
			if (idd'="")&&(id'=idd) s flag=1
		}
	}
	q flag
}

/// Description：修改表单查询数据
/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年8月11日
/// Table：User.CTLocBuilding
/// input：医院楼id
/// output：医院楼信息Json串
/// Other:w ##class(web.DHCBL.CT.CTLocBuilding).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.CTLocBuilding).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTLocBuilding).%New()
	s eobj.CTLBRowId = id
	s eobj.CTLBCode = pobj.CTLBCode		//医院楼代码
	s eobj.CTLBDesc = pobj.CTLBDesc		//医院楼描述
	s:pobj.CTLBDateFrom'="" eobj.CTLBDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTLBDateFrom)	//开始日期
	s:pobj.CTLBDateTo'="" eobj.CTLBDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTLBDateTo)			//结束日期
	s eobj.CTLBMark = pobj.CTLBMark		//备注
	s:pobj.CTLBHospitalDR'="" eobj.CTLBHospitalDR=pobj.CTLBHospitalDR.%Id()		//医院
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：删除数据
/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年8月11日
/// input：医院楼id
/// output：成功失败信息
/// Table：User.CTLocBuilding
/// Other:w ##class(web.DHCBL.CT.CTLocBuilding).DeleteData(2)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=..GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	s reason=$p(re,"^",2)
	if (RefFlag=0)
	{
		s eobj = ##class(web.Entity.CT.CTLocBuilding).%New()
		s pobj = ##class(User.CTLocBuilding).%OpenId(id)	
		s eobj.CTLBRowId = id
		s eobj.CTLBCode = pobj.CTLBCode
		s eobj.CTLBDesc = pobj.CTLBDesc
		s eobj.CTLBDateFrom = pobj.CTLBDateFrom
		s eobj.CTLBDateTo = pobj.CTLBDateTo
		s eobj.CTLBMark = pobj.CTLBMark
		s:pobj.CTLBHospitalDR'="" eobj.CTLBHospitalDR=pobj.CTLBHospitalDR.%Id()
		Ts
		s sc = ##class(User.CTLocBuilding).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result= ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocBuilding","User.CTLocBuilding","医院楼",eobj.CTLBRowId,eobj.CTLBDesc,"D",eobj)
			s result = "{success:'true',info:'删除成功！'}"	
		}
		else 
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医院楼","web.DHCBL.CT.CTLocBuilding","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result= "{success:'false',info:'"_reason_"'}"	
	}
	q result
}

}
