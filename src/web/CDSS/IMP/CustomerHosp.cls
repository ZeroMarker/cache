/// 名称:实施综合管理平台-医院字典表
/// 描述:包含增删改查功能
/// 编写者:基础平台组 - 钟荣枫
/// 编写日期:2020-5-30
Class web.CDSS.IMP.CustomerHosp Extends %RegisteredObject
{

/// Creator：钟荣枫 		
/// CreatDate: 2020-5-28
/// Description：查询 医院 
/// Table:CT.WDT.CDSS.CustomerHosp
/// Input:id, code, desc,
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.CustomerHosp","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,HospitalCode,HospitalName,CreateDate,Creator,Remarks")
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
		//HospitalCode,HospitalName,CreateDate,Creator,Remarks
		s ID=rowid
		s HospitalCode= $lg($g(^CT.WDT.CDSS.CustomerHospD(ID)),2)		//医院编码
		s HospitalName= $lg($g(^CT.WDT.CDSS.CustomerHospD(ID)),3)		//医院名称
		s CreateDate=$lg($g(^CT.WDT.CDSS.CustomerHospD(ID)),4)		//创建时间
		s Creator=$lg($g(^CT.WDT.CDSS.CustomerHospD(ID)),5)		//创建人员
		s Remarks=$lg($g(^CT.WDT.CDSS.CustomerHospD(ID)),6)		//备注	
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.CustomerHospD(ID))
			q:ID=""
			s HospitalCode= $lg($g(^CT.WDT.CDSS.CustomerHospD(ID)),2)		//医院编码
			s HospitalName= $lg($g(^CT.WDT.CDSS.CustomerHospD(ID)),3)		//医院名称
			s CreateDate=$lg($g(^CT.WDT.CDSS.CustomerHospD(ID)),4)		//创建时间
			s Creator=$lg($g(^CT.WDT.CDSS.CustomerHospD(ID)),5)		//创建人员
			s Remarks=$lg($g(^CT.WDT.CDSS.CustomerHospD(ID)),6)		//备注	
			if (desc'="")           //描述不为空
			{
				;需要对描述或者别名进行检索 
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) 
		        if (PINYINFlag=1)	/// 是拼音 才去转换拼音码
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HospitalName) 
		        }
				if (($ZCONVERT(HospitalName,"U")[desc)||(PINYINCODE[desc))  	//过滤描述
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			if ($ZCONVERT(HospitalCode,"U")[code)&&(AliasFlag=1) //过滤代码
			{
				d OutputRow
			}
			
		}
						
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,HospitalCode,HospitalName,CreateDate,Creator,Remarks)
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

/// Creator：钟荣枫 		
/// CreatDate: 2020-6-1
/// Description：查询 医院 下拉框
/// Table:CT.WDT.CDSS.CustomerHosp
/// Input:id, code, desc
/// Output:RowId,Code,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.CustomerHosp","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,HospitalCode,HospitalName")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s HospitalCode= $lg($g(^CT.WDT.CDSS.CustomerHospD(ID)),2)		//医院编码
		s HospitalName= $lg($g(^CT.WDT.CDSS.CustomerHospD(ID)),3)		//医院名称
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.CustomerHospD(ID))
			q:ID=""
			s HospitalCode= $lg($g(^CT.WDT.CDSS.CustomerHospD(ID)),2)		//医院编码
			s HospitalName= $lg($g(^CT.WDT.CDSS.CustomerHospD(ID)),3)		//医院名称
			if (desc'="")           //描述非空
			{
				;需要对描述或者别名进行检索 
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HospitalName) 
		        }
				if (($ZCONVERT(HospitalName,"U")[desc)||(PINYINCODE[desc)) 
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			if ($ZCONVERT(HospitalCode,"U")[code)&&(AliasFlag=1) //包含
			{
				d OutputRowCmb
			}
			
		}
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(ID,HospitalCode,HospitalName)
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

/// Creator：钟荣枫 
/// CreatDate: 2020-5-30
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：CT.WDT.CDSS.CustomerHosp 医院
/// Input：id
/// Return：json串 如 {list:[{"CreateDate":"","Creator":"","HospitalCode":"yy01","HospitalName":"医院1","ID":"1","LinkHospId":"","Remarks":"1"}]}
/// Other: w ##class(web.CDSS.IMP.CustomerHosp).OpenData(1,"")
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{
    s str = ""
	s pobj = ##class(CT.WDT.CDSS.CustomerHosp).%OpenId(id) 
	s eobj = ##class(web.CDSSEntity.IMP.CustomerHosp).%New() 
	s eobj.ID = id
	s eobj.HospitalCode = pobj.HospitalCode		//医院编码
	s eobj.HospitalName = pobj.HospitalName		//医院名称
	s eobj.CreateDate=pobj.CreateDate	//创建时间
	s eobj.Creator = pobj.Creator			//创建人员
	s eobj.Remarks=pobj.Remarks				//备注
	
	kill pobj
	s str = eobj.JsonS()
	if (RetFlag'="JSON")	//RetFlag=""时，用于EXT, =JSON时，用于HISUI，不输出 "{list:["_str_"]}"
	{
		s str = "{list:["_str_"]}"
	}
	q str
}

/// Creator:钟荣枫
/// CreatDate:2020-5-30
/// Description:医院删除限制
/// Input：id 医院id
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.CDSS.IMP.CustomerHosp).GetRefFlag(2)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	s LinkID=0
	for 
	{
		s LinkID=$o(^CT.WDT.CDSS.HospLinkRulesD(LinkID))
		q:LinkID=""
		s Hospitaldr= $lg($g(^CT.WDT.CDSS.HospLinkRulesD(LinkID)),2)	
		if (Hospitaldr=id)
		{
			s myInfo=myInfo_"<医院关联规则>"
			q
		}
	}
	if (myInfo="")	//未被引用
	{
		s return="0^未被引用可删除！"
	}
	else  //被引用
	{
		s return="1^在"_myInfo_"表里被引用,不能删除！"
	}
	q return
}

/// Creator：钟荣枫 
/// CreatDate: 2020-5-30
/// Description：根据id删除 医院
/// Table：CT.WDT.CDSS.CustomerHosp 医院
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.CDSS.IMP.CustomerHosp).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	
	s pobj = ##class(CT.WDT.CDSS.CustomerHosp).%OpenId(id)
	s eobj = ##class(web.CDSSEntity.IMP.CustomerHosp).%New()
	
	s eobj.HospitalCode = pobj.HospitalCode		//医院编码
	s eobj.HospitalName = pobj.HospitalName		//医院名称
	s eobj.CreateDate=pobj.CreateDate	//创建时间
	s eobj.Creator = pobj.Creator			//创建人员
	s eobj.Remarks=pobj.Remarks				//备注
	
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(CT.WDT.CDSS.CustomerHosp).%DeleteId(id)
	IF $$$ISOK(sc)
	{
		s result="{success:'true'}"	
		s errorflag=0
		s childsub=""
		for
		{
			s childsub=$o(^CT.WDT.CDSS.CustomerHospD(id,"ChildExt",childsub))
			q:childsub=""
			q:errorflag=1
			s AreaID=id_"||"_childsub
			s re=..DeleteHospAreaData(AreaID)
			s:re["false" errorflag=1
		}
		
		if ((result["false")||(errorflag=1))
		{
			tro
		}
		else
		{
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CustomerHosp","CT.WDT.CDSS.CustomerHosp","医院",id,eobj.HospitalName,"D",eobj)
		}
	}
	else
	{
		Trollback
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("医院","web.CDSS.IMP.CustomerHosp","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}


	q result
}

/// Creator:钟荣枫 
/// CreatDate:2020-6-9
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.CustomerHosp 医院
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.IMP.CustomerHosp).FormValidate("","yy01","医院1")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag=0
	s ID=0
	
	for 
	{
		s ID=$o(^CT.WDT.CDSS.CustomerHospD(ID)) q:ID=""
		//Index CodeIndex On HospitalCode [ Unique ];
		s HospitalCode= $lg($g(^CT.WDT.CDSS.CustomerHospD(ID)),2)		//医院编码
		s HospitalName= $lg($g(^CT.WDT.CDSS.CustomerHospD(ID)),3)		//医院名称
		if ($ZCONVERT(HospitalCode,"U")=code)
		{
			if (id'="")&&(id'=ID)	//修改
			{
				s flag=1
			}
			elseif (id="")	//新增
			{
				s flag=1
			}
		}
		
	}
	q flag
}

/// Creator:钟荣枫 
/// CreatDate: 2020-6-1
/// Description：保存 医院 
/// Input: eobj As web.CDSSEntity.IMP.CustomerHosp
/// Table:CT.WDT.CDSS.CustomerHosp 医院 
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.CustomerHosp).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.IMP.CustomerHosp) As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		//s:eobj.CreateDate'="" eobj.CreateDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CreateDate)
		//s:eobj.CreateDate="" eobj.CreateDate =$h
		
		s flag=..FormValidate(eobj.ID,eobj.HospitalCode,eobj.HospitalName)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.CustomerHosp).%New()
		}
		else	//修改
		{
			s obj=##class(CT.WDT.CDSS.CustomerHosp).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.IMP.CustomerHosp).%New()
			s bobj.ID = eobj.ID
			
			s bobj.HospitalCode = obj.HospitalCode		//医院编码
			s bobj.HospitalName = obj.HospitalName		//医院名称
			s bobj.CreateDate=obj.CreateDate	//创建时间
			s bobj.Creator = obj.Creator			//创建人员
			s bobj.Remarks=obj.Remarks				//备注
						
		}

		
		s obj.HospitalCode = eobj.HospitalCode		//医院编码
		s obj.HospitalName = eobj.HospitalName		//医院名称
		s obj.CreateDate=eobj.CreateDate	//创建时间
		s obj.Creator = eobj.Creator			//创建人员
		s obj.Remarks=eobj.Remarks				//备注
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CustomerHosp","CT.WDT.CDSS.CustomerHosp","医院",id,eobj.HospitalName,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.CustomerHosp","CT.WDT.CDSS.CustomerHosp","医院",id,eobj.HospitalName,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("医院","web.CDSS.IMP.CustomerHosp","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:钟荣枫 
/// CreatDate:2020-6-12
/// Description:用于自动生成医院的代码,js调用
/// Table：CT.WDT.CDSS.CustomerHosp 医院
/// Input:
/// Return:id
/// Other:w ##class(web.CDSS.IMP.CustomerHosp).GetHospCode()
ClassMethod GetHospCode(desc) As %String
{
	s HospCode=""
	
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.CustomerHospD(ID))
		q:ID=""
		s HospCode=ID
	}
	s:HospCode="" HospCode=0
	s HospCode="CH"_HospCode
	q HospCode
}

/// Creator：钟荣枫 		
/// CreatDate: 2022-1-21
/// Description：查询 医院关联的院区 
/// Table:CT.WDT.CDSS.CustomerHosp
/// Input:id, code, desc,
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.CustomerHosp","GetHospAreaList","1","","")
Query GetHospAreaList(ParRef As %String, code As %String, desc As %String) As %Query(ROWSPEC = "HospAreaID,HospAreaCode,HospAreaDesc,StartDate,EndDate")
{
}

ClassMethod GetHospAreaListExecute(ByRef qHandle As %Binary, ParRef As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (ParRef'="")
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s ChildSub=""
		for 
		{
			s ChildSub=$o(^CT.WDT.CDSS.CustomerHospD(ParRef,"ChildExt",ChildSub))
			q:ChildSub=""
			s HospAreaID=ParRef_"||"_ChildSub
			s HospAreaCode= $lg($g(^CT.WDT.CDSS.CustomerHospD(ParRef,"ChildExt",ChildSub)),2)		//院区编码
			s HospAreaDesc= $lg($g(^CT.WDT.CDSS.CustomerHospD(ParRef,"ChildExt",ChildSub)),3)		//院区名称
			s StartDate=$lg($g(^CT.WDT.CDSS.CustomerHospD(ParRef,"ChildExt",ChildSub)),4)		//开始时间
			s:StartDate'="" StartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(StartDate)
			s EndDate=$lg($g(^CT.WDT.CDSS.CustomerHospD(ParRef,"ChildExt",ChildSub)),5)		//结束时间
			s:EndDate'="" EndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EndDate) 
			s:desc'="" PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HospAreaDesc) 
			if ((($ZCONVERT(HospAreaDesc,"U")[desc)||(PINYINCODE[desc))&&($ZCONVERT(HospAreaCode,"U")[code)) //过滤
			{
				d OutputRow
			}
			
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(HospAreaID,HospAreaCode,HospAreaDesc,StartDate,EndDate)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetHospAreaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospAreaListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHospAreaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospAreaListExecute ]
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

/// Creator：钟荣枫 		
/// CreatDate: 2022-1-21
/// Description：查询 医院所属院区 下拉框
/// Table:CT.WDT.CDSS.CustomerHosp
/// Input:id, code, desc
/// Output:RowId,Code,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.IMP.CustomerHosp","GetHospAreaForCmb1","","","")
Query GetHospAreaForCmb1(ParRef As %String, code As %String, desc As %String) As %Query(ROWSPEC = "HospAreaID,HospAreaCode,HospAreaDesc")
{
}

ClassMethod GetHospAreaForCmb1Execute(ByRef qHandle As %Binary, ParRef As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (ParRef'="")
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s ChildSub=0
		for 
		{
			s ChildSub=$o(^CT.WDT.CDSS.CustomerHospD(ParRef,"ChildExt",ChildSub))
			q:ChildSub=""
			s HospAreaID=ParRef_"||"_ChildSub
			s HospAreaCode= $lg($g(^CT.WDT.CDSS.CustomerHospD(ParRef,"ChildExt",ChildSub)),2)		//院区编码
			s HospAreaDesc= $lg($g(^CT.WDT.CDSS.CustomerHospD(ParRef,"ChildExt",ChildSub)),3)		//院区名称
			s StartDate=$lg($g(^CT.WDT.CDSS.CustomerHospD(ParRef,"ChildExt",ChildSub)),4)		//开始时间
			//continue:StartDate>+$h
			s:StartDate'="" StartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(StartDate)
			s EndDate=$lg($g(^CT.WDT.CDSS.CustomerHospD(ParRef,"ChildExt",ChildSub)),5)		//结束时间
			//continue:EndDate<+$h
			s:EndDate'="" EndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EndDate) 
			s:desc'="" PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HospAreaDesc) 
			if ((($ZCONVERT(HospAreaDesc,"U")[desc)||(PINYINCODE[desc))&&($ZCONVERT(HospAreaCode,"U")[code)) //过滤
			{
				d OutputRowCmb
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(HospAreaID,HospAreaCode,HospAreaDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetHospAreaForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospAreaForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHospAreaForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospAreaForCmb1Execute ]
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

/// Creator：钟荣枫 
/// CreatDate: 2020-5-30
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：CT.WDT.CDSS.CustomerHosp 医院
/// Input：id
/// Return：json串 如 
/// Other: w ##class(web.CDSS.IMP.CustomerHosp).OpenChildData("1||4")
ClassMethod OpenChildData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(CT.WDT.CDSS.CustomerHospArea).%OpenId(id) 
	s eobj = ##class(web.CDSSEntity.IMP.CustomerHospArea).%New() 
	s eobj.HospAreaID=id
	s eobj.ParRef=pobj.ParRef.%Id()
	s eobj.HospAreaCode= pobj.HospAreaCode		//院区编码
	s eobj.HospAreaDesc= pobj.HospAreaDesc		//院区名称
	s eobj.StartDate=pobj.StartDate	//开始时间
	s:eobj.StartDate'="" eobj.StartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.StartDate)
	s eobj.EndDate=pobj.EndDate
	s:eobj.EndDate'="" eobj.EndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.EndDate)
	kill pobj
	s str = eobj.JsonS()
	q str
}

/// Creator:钟荣枫
/// CreatDate:2020-5-30
/// Description:医院删除限制
/// Input：id 医院id
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.CDSS.IMP.CustomerHosp).GetChildRefFlag(2)
ClassMethod GetChildRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	//Index InterDictIndex On (HospAreaDR As Exact, InterDictDR As Exact); 对接方字典关联院区表
	s InterDictDR=0
	for 
	{
		s InterDictDR=$o(^CT.WDT.CDSS.InterDictConAreaI("InterDictIndex",id,InterDictDR))
		q:InterDictDR=""
		if (InterDictDR'="")
		{
			s myInfo=myInfo_"<对接方字典关联院区>"
			q
		}
	}
	//科室字典
	s DeptID=0
	for 
	{
		s DeptID=$o(^CT.WDT.CDSS.DiseaseDeptDictD(DeptID))
		q:DeptID=""
		s Areaid=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(10)),10)
		if (Areaid=id)
		{
			s myInfo=myInfo_"<科室字典>"
			q
		}
	}
	if (myInfo="")	//未被引用
	{
		s return="0^未被引用可删除！"
	}
	else  //被引用
	{
		s return="1^在"_myInfo_"表里被引用,不能删除！"
	}
	q return
}

/// Creator：钟荣枫 
/// CreatDate: 2020-5-30
/// Description：根据id删除 医院
/// Table：CT.WDT.CDSS.CustomerHosp 医院
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.CDSS.IMP.CustomerHosp).DeleteHospAreaData(1)
ClassMethod DeleteHospAreaData(id) As %String
{
	s result=""
	s re=..GetChildRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0)	//未被引用
	{
		s pobj = ##class(CT.WDT.CDSS.CustomerHospArea).%OpenId(id) 
		s eobj = ##class(web.CDSSEntity.IMP.CustomerHospArea).%New() 
		s eobj.HospAreaID=id
		s eobj.ParRef=pobj.ParRef.%Id()
		s eobj.HospAreaCode= pobj.HospAreaCode		//院区编码
		s eobj.HospAreaDesc= pobj.HospAreaDesc		//院区名称
		s eobj.StartDate=pobj.StartDate	//开始时间
		s eobj.EndDate=pobj.EndDate
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(CT.WDT.CDSS.CustomerHospArea).%DeleteId(id)
		IF $$$ISOK(sc)
		{
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS_CustomerHospArea","CT.WDT.CDSS.CustomerHospArea","医院院区子表",id,eobj.HospAreaDesc,"D",eobj)
			
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("医院院区子表","web.CDSS.IMP.CustomerHosp","DeleteHospAreaData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else
	{
		s result= "{success:'false',errorinfo:'"_$p(re,"^",2)_"'}"	
	}
	
	
	q result
}

/// Creator:钟荣枫 
/// CreatDate:2020-6-9
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.CustomerHosp 医院
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.IMP.CustomerHosp).FormValidateChild("1||4",1,2)
ClassMethod FormValidateChild(id As %String, parref As %String, code As %String) As %String
{
	
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    
	s flag=""
	s flagc=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.CustomerHospAreaI("CodeIndex",parref,code))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0)
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
		s conareaid=$p(id,"||",2)
		s idc=""
		s:code'="" idc=$o(^CT.WDT.CDSS.CustomerHospAreaI("CodeIndex",parref,code,""))
		if (idc'="")&(idc'=conareaid)&(flagc>0) 
		{
			s flag=1  //返回重复标志
		}
		else  
		{
			s flag=0 //返回不重复标志
		}
			
	}
	q flag
}

/// Creator:钟荣枫 
/// CreatDate: 2022-1-21
/// Description：保存 医院院区
/// Input: eobj As web.CDSSEntity.IMP.CustomerHospArea
/// Table:CT.WDT.CDSS.CustomerHospArea 医院院区 
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.CustomerHosp).SaveHospAreaEntity(eobj)
ClassMethod SaveHospAreaEntity(eobj As web.CDSSEntity.IMP.CustomerHospArea) As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.StartDate'="" eobj.StartDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.StartDate)
		s:eobj.EndDate'="" eobj.EndDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EndDate)
		
		s flag=..FormValidateChild(eobj.HospAreaID,eobj.ParRef,eobj.HospAreaCode)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.HospAreaID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.CustomerHospArea).%New()
		}
		else	//修改
		{
			s obj = ##class(CT.WDT.CDSS.CustomerHospArea).%OpenId(eobj.HospAreaID) 
			s bobj = ##class(web.CDSSEntity.IMP.CustomerHospArea).%New() 
			s bobj.HospAreaID=eobj.HospAreaID
			s bobj.ParRef=obj.ParRef.%Id()
			s bobj.HospAreaCode= obj.HospAreaCode		//院区编码
			s bobj.HospAreaDesc=obj.HospAreaDesc		//院区名称
			s bobj.StartDate=obj.StartDate	//开始时间
			s bobj.EndDate=obj.EndDate
		}
		d:eobj.ParRef'="" obj.ParRefSetObjectId(eobj.ParRef)
		d:eobj.ParRef="" obj.ParRefSetObjectId()
		s obj.HospAreaCode= eobj.HospAreaCode		//院区编码
		s obj.HospAreaDesc=eobj.HospAreaDesc		//院区名称
		s obj.StartDate=eobj.StartDate	//开始时间
		s obj.EndDate=eobj.EndDate
		
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.HospAreaID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS_CustomerHospArea","CT.WDT.CDSS.CustomerHospArea","医院院区子表",id,eobj.HospAreaDesc,"A",eobj)
			d:eobj.HospAreaID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS_CustomerHospArea","CT.WDT.CDSS.CustomerHospArea","医院院区子表",id,eobj.HospAreaDesc,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("医院院区子表","CT.WDT.CDSS.CustomerHospArea","SaveHospAreaEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：阚延新
/// CreatDate: 2022-01-24
/// Description：导入对接方字典表,名称相同时添加到对照表,导入文本格式为txt，TXT要求格式为ANSI编码
/// Table:CT.WDT.CDSS.CustomerHospArea
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.IMP.CustomerHosp).ImportDataTXT("")
ClassMethod ImportDataTXT(path) As %String
{
	s savecount=0
	s nosavecount=0
	s continuecount=0
	s id=0
	
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
	
	s TheMarkFlag=""
	
	s num=0
	k myFileAry
	TS
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行
		s myFileAry(i)=data
		s DictCode=$p(data,$c(9),1)	//对接方字典代码
		continue:DictCode=""
		s DictDesc=$p(data,$c(9),2)
		continue:DictDesc=""
		s StartDate=$p(data,$c(9),3)	//开始日期
		s EndDate=$p(data,$c(9),4)	//结束日期
		s DictHospDesc="苏州科技城医院" //$p(data,$c(9),4)	//对接方字典医院		
		if (StartDate[":")		//带有时间
		{
			s StartDate=$p(StartDate," ",1)	
		}
		if (EndDate[":")		//带有时间
		{
			s EndDate=$p(EndDate," ",1)	
		}
		if (StartDate'="")
		{
			s:StartDate["/" StartDate=$Replace(StartDate,"/","-")
			s StartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(StartDate)
		}
		if (EndDate'="")
		{
			s:EndDate["/" EndDate=$Replace(EndDate,"/","-")
			s EndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(EndDate)
		}
		if ((EndDate'="")&&(EndDate<+$h))	//过期
		{
			s continuecount=continuecount+1
			continue
		}
		s DictHosp=$o(^CT.WDT.CDSS.CustomerHospI("NameIndex"," "_$zconvert(DictHospDesc,"U"),""))
		if (DictHosp="")	//医院错误
		{
			s continuecount=continuecount+1
			continue
		}	
		
		s eobj = ##class(web.CDSSEntity.IMP.CustomerHospArea).%New()
		s eobj.HospAreaID = ""
		
		s eobj.HospAreaCode=DictCode				//代码
		s eobj.HospAreaDesc=DictDesc				//描述
		s eobj.ParRef = DictHosp					//医院
		s eobj.StartDate=StartDate					//开始日期
		s eobj.EndDate=EndDate						//结束日期
		s result=..SaveHospAreaEntity(eobj)
		if ((result'["false"))
		{	
			s savecount=savecount+1
			
		}
		else
		{
			s nosavecount=nosavecount+1
		}
	}
	close file
    k file
	w "读取数据总共"_(num-1)_"条",!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	w "continuecount:"_continuecount,!
	q "{success:'true'}"
}

/// 判断是否存在该配置项的医院
/// Other: w ##class(web.CDSS.IMP.CustomerHosp).GetHosp("31")
ClassMethod GetHosp(hosp) As %String
{
	q:hosp="" ""
	s hosp1=""
	s hosp1= $d(^CT.WDT.CDSS.CustomerHospD(hosp)) 
	q hosp1
}

}
