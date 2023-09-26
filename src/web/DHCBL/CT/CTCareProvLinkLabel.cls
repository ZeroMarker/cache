/// 基础数据平台-李可凡
/// 2021-11-11
/// 医护人员关联标签表，一个人可以关联多个标签
/// User.CTCareProvLinkLabel
Class web.DHCBL.CT.CTCareProvLinkLabel Extends %RegisteredObject
{

/// Creator：李可凡
/// CreatDate: 2021-11-11
/// Description：查询医护人员关联标签表
/// Table：User.CTCareProvLinkLabel
/// Input：parref,rowid,desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCareProvLinkLabel","GetList","","","")
Query GetList(parref As %String, rowid As %String, desc As %String) As %Query(ROWSPEC = "CPLLParRef,CPLLRowId,CPLLChildsub,CPLLLabelDR,CPLLLabelDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, parref As %String, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:desc'="" desc=$ZCONVERT(desc,"U")
	if (rowid'="") //根据rowid返回该条记录
	{
		s CPLLRowId=rowid
		s CPLLParRef=$p(rowid,"||",1)
		s CPLLChildsub=$p(rowid,"||",2)
		s CPLLLabelDR=$p($g(^CTPCP(CPLLParRef,"LinkLabel",CPLLChildsub)),"^",1)	//标签DR
		s CPLLLabelDesc=""
		s:CPLLLabelDR'="" CPLLLabelDesc=$lg($g(^User.CTLabelD(CPLLLabelDR)),3)	//标签名称
		d OutputRow
	}
	else
	{
		if (parref'="")
		{
			s CPLLParRef=parref
	 		s CPLLChildsub=0
	 		for
	 		{
		 		s CPLLChildsub=$o(^CTPCP(CPLLParRef,"LinkLabel",CPLLChildsub)) q:CPLLChildsub=""
		 		s CPLLRowId=CPLLParRef_"||"_CPLLChildsub
		 		s CPLLLabelDR=$p($g(^CTPCP(CPLLParRef,"LinkLabel",CPLLChildsub)),"^",1)	//标签DR
		 		s CPLLLabelDesc=""
				s:CPLLLabelDR'="" CPLLLabelDesc=$lg($g(^User.CTLabelD(CPLLLabelDR)),3)	//标签名称
		 		s PINYIN=""
				s:CPLLLabelDR'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CPLLLabelDesc)
				if (($ZCONVERT(CPLLLabelDesc,"U")[desc)||(PINYIN[desc))
				{
					d OutputRow
				}
		 	}
		}
	}
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(CPLLParRef,CPLLRowId,CPLLChildsub,CPLLLabelDR,CPLLLabelDesc)
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

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-11-11
/// Description：新增时医护人员批量关联标签
/// Table：User.CTCareProvLinkLabel
/// Input：医护人员id，标签id串("^"分隔)
/// Others：w ##class(web.DHCBL.CT.CTCareProvLinkLabel).SaveAll("1","1^2^3")
ClassMethod SaveAll(doctorid As %String, labelidstr As %String) As %String
{
	q:doctorid="" ""
	q:labelidstr="" ""
	s len=$l(labelidstr,"^")
	for i=1:1:len
	{
		s labelid=$p(labelidstr,"^",i)
		continue:labelid=""
		d ..SaveData(doctorid,labelid)
	}
	q "1"
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-11-11
/// Description：医护人员关联标签
/// Table：User.CTCareProvLinkLabel
/// Input：医护人员id，标签id
/// Others：w ##class(web.DHCBL.CT.CTCareProvLinkLabel).SaveData("1","1")
ClassMethod SaveData(doctorid As %String, labelid As %String) As %String
{
	q:doctorid="" ""
	q:labelid="" ""
	s result=""
	s eobj=##class(web.Entity.CT.CTCareProvLinkLabel).%New()
	s eobj.CPLLParRef=doctorid
	s eobj.CPLLLabelDR=labelid
	s result=##class(web.DHCBL.CT.CTCareProvLinkLabel).SaveEntity(eobj)
	q result
}

/// function：医护人员关联标签表保存数据
/// Creator:李可凡
/// CreatDate:2021-11-11
/// Table:User.CTCareProvLinkLabel
/// Input:web.Entity.CT.CTCareProvLinkLabel
/// Return:成功返回success:'true'和id;失败返回success:'false'和errorinfo
/// d ##class(web.DHCBL.CT.CTCareProvLinkLabel).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.CTCareProvLinkLabel) As %String
{
	s result=""
	s flag=..FormValidate(eobj.CPLLRowId,eobj.CPLLParRef,eobj.CPLLLabelDR)
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
		if (eobj.CPLLRowId="")
		{
			s obj=##class(User.CTCareProvLinkLabel).%New(eobj.CPLLParRef)
		}
		else                           
		{
			s obj=##class(User.CTCareProvLinkLabel).%OpenId(eobj.CPLLRowId)
			s bobj = ##class(web.Entity.CT.CTCareProvLinkLabel).%New()
			s:obj.CPLLParRef'="" bobj.CPLLParRef=obj.CPLLParRef.%Id()
			s bobj.CPLLChildsub=obj.CPLLChildsub
			s:obj.CPLLLabelDR'="" bobj.CPLLLabelDR=obj.CPLLLabelDR.%Id()
		}
		
		d obj.CPLLParRefSetObjectId(eobj.CPLLParRef)
		d obj.CPLLLabelDRSetObjectId(eobj.CPLLLabelDR)
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result= "{success:'true',id:'"_id_"'}"
			s LogDesc=""
			s:eobj.CPLLParRef'="" LogDesc=$p($g(^CTPCP(eobj.CPLLParRef,1)),"^",2)	//医护人员姓名
			s:eobj.CPLLLabelDR'="" LogDesc=LogDesc_"-"_$lg($g(^User.CTLabelD(eobj.CPLLLabelDR)),3)	//标签名称
			d:eobj.CPLLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CareProv_LinkLabel","User.CTCareProvLinkLabel","医护人员关联标签",id,LogDesc,"A",eobj)
			d:eobj.CPLLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CareProv_LinkLabel","User.CTCareProvLinkLabel","医护人员关联标签",id,LogDesc,"U",eobj,bobj)
		}
		else
		{
			Trollback
			s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员关联标签","web.DHCBL.CT.CTCareProvLinkLabel","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
		}
		
	}
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-11-11
/// Description：医护人员关联标签表数据校验
/// Table：User.CTCareProvLinkLabel
/// Input：本表id，医护人员id，标签id
/// Output：1：重复		0：不重复
/// Others：w ##class(web.DHCBL.CT.CTCareProvLinkLabel).FormValidate("","1","1")
ClassMethod FormValidate(id As %String, parref As %String, labeldr As %String) As %String
{
	q:parref="" ""
	q:labeldr="" ""
	s flag=0
	s CPLLRowId=$o(^CTPCP(parref,"LinkLabel",0,"Label",labeldr,0))
	s:(CPLLRowId'="")&&(CPLLRowId'=id) flag=1
	q flag
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-11-11
/// Description：删除医护人员关联标签表数据
/// Table：User.CTCareProvLinkLabel
/// Other: w ##class(web.DHCBL.CT.CTCareProvLinkLabel).DeleteData("1||3")
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj=##class(web.Entity.CT.CTCareProvLinkLabel).%New()
	s obj=##class(User.CTCareProvLinkLabel).%OpenId(id)
	if (obj)
	{
		s pobj.CPLLRowId=id
		s:obj.CPLLParRef'="" pobj.CPLLParRef=obj.CPLLParRef.%Id()
		s pobj.CPLLChildsub=obj.CPLLChildsub
		s:obj.CPLLLabelDR'="" pobj.CPLLLabelDR=obj.CPLLLabelDR.%Id()
		TS
		s sc=##class(User.CTCareProvLinkLabel).%DeleteId(id)
		if $$$ISOK(sc)
		{
			TC
			s result="{success:'true',info:'删除成功！'}"	
			s LogDesc=""
			s:pobj.CPLLParRef'="" LogDesc=$p($g(^CTPCP(pobj.CPLLParRef,1)),"^",2)	//医护人员姓名
			s:pobj.CPLLLabelDR'="" LogDesc=LogDesc_"-"_$lg($g(^User.CTLabelD(pobj.CPLLLabelDR)),3)	//标签名称
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CareProv_LinkLabel","User.CTCareProvLinkLabel","医护人员关联标签",id,LogDesc,"D",pobj)
		}
		else 
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员关联标签","web.DHCBL.CT.CTCareProvLinkLabel","DeleteData",pobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result="{success:'false',info:'对象不存在'}"
	}
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-11-11
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.CTCareProvLinkLabel
/// Input：id
/// w ##class(web.DHCBL.CT.CTCareProvLinkLabel).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{

    s str = ""
	s obj = ##class(User.CTCareProvLinkLabel).%OpenId(id)
	if (obj)
	{
		s eobj = ##class(web.Entity.CT.CTCareProvLinkLabel).%New()
		s eobj.CPLLRowId=id
		s:obj.CPLLParRef'="" eobj.CPLLParRef=obj.CPLLParRef.%Id()
		s eobj.CPLLChildsub=obj.CPLLChildsub
		s:obj.CPLLLabelDR'="" eobj.CPLLLabelDR=obj.CPLLLabelDR.%Id()
		d eobj.%Close()
		k obj
		s str=eobj.JsonS()
	}
	s str = "{list:["_str_"]}"
	q str
}

/// 根据医护人员id、标签代码返回是否关联Y/N
/// 基础数据-likefan
/// 2021-11-18
/// input: 医护人员id，标签代码
/// outout: 1/0/""(关联/未关联/入参错误或者标签不存在)
/// w ##class(web.DHCBL.CT.CTCareProvLinkLabel).GetLabelFlagByCode("","")
ClassMethod GetLabelFlagByCode(doctorid As %String, code As %String) As %String
{
	q:doctorid="" ""
	q:code="" ""
	s ID=$o(^User.CTLabelI("TableLabelCodeIdx"," CT_CAREPROV"," "_$$ALPHAUP^SSUTIL4(code),0))
	q:ID="" ""
	s flag="0"
	s CPLLRowId=$o(^CTPCP(doctorid,"LinkLabel",0,"Label",ID,0))
	s:CPLLRowId'="" flag="1"
	q flag
}

/// 根据医护人员id、标签描述返回是否关联Y/N
/// 基础数据-likefan
/// 2021-11-18
/// input: 医护人员id，标签描述
/// outout: 1/0/""(关联/未关联/入参错误或者标签不存在)
/// w ##class(web.DHCBL.CT.CTCareProvLinkLabel).GetLabelFlagByDesc("","")
ClassMethod GetLabelFlagByDesc(doctorid As %String, desc As %String) As %String
{
	q:doctorid="" ""
	q:desc="" ""
	s ID=$o(^User.CTLabelI("TableLabelNameIdx"," CT_CAREPROV"," "_$$ALPHAUP^SSUTIL4(desc),0))
	q:ID="" ""
	s flag="0"
	s CPLLRowId=$o(^CTPCP(doctorid,"LinkLabel",0,"Label",ID,0))
	s:CPLLRowId'="" flag="1"
	q flag
}

}
