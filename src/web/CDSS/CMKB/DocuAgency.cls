/// Creator:高姗姗
/// CreatDate:2021-09-28
/// Description：文献发布机构
Class web.CDSS.CMKB.DocuAgency Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2021-09-28
/// Description:获得文献发布机构表内容
/// Table: CT.WDT.CDSS.DocuAgency
/// Input: Desc名称
/// Return:返回所有文献发布机构表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DocuAgency","GetList","","")
Query GetList(Id, Desc, Priority) As %Query(ROWSPEC = "RowId,AgencyCode,AgencyDesc,AgencyPriority")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, Id, Desc, Priority) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (Id'=""){
	 	s RowId=Id
	 	s AgencyCode = $lg($g(^CT.WDT.CDSS.DocuAgencyD(RowId)),2) //发布机构代码
		s AgencyDesc = $lg($g(^CT.WDT.CDSS.DocuAgencyD(RowId)),3) //发布机构名称 
		s AgencyPriority = $lg($g(^CT.WDT.CDSS.DocuAgencyD(RowId)),4) //机构优先级
		d OutputRow
	}
	else{
	 	s:Desc'="" Desc=$ZCONVERT(Desc,"U") //转换成大写
		s RowId=""
		for
		{
			s RowId = $o(^CT.WDT.CDSS.DocuAgencyD(RowId),-1)
			q:RowId=""
			s AgencyCode = $lg($g(^CT.WDT.CDSS.DocuAgencyD(RowId)),2) //发布机构代码
			s AgencyDesc = $lg($g(^CT.WDT.CDSS.DocuAgencyD(RowId)),3) //发布机构名称
			s AgencyPriority = $lg($g(^CT.WDT.CDSS.DocuAgencyD(RowId)),4) //机构优先级
			s PINYINDesc=""
			s:Desc'="" PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(AgencyDesc)  

			if ((($ZCONVERT(AgencyDesc,"U")[Desc)||(PINYINDesc[Desc)||(Desc=""))&&((AgencyPriority=Priority)||(Priority=""))){
		  		d OutputRow
		  	}
		}
	
	}    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,AgencyCode,AgencyDesc,AgencyPriority)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：高姗姗
/// CreatDate: 2021-09-28
/// Description：查询文献发布机构
/// Table：CT.WDT.CDSS.DocuAgency
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DocuAgency","GetDataForCmb1","","测测测","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "RowId,AgencyDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	s RowId=rowid
	s AgencyDesc = $lg($g(^CT.WDT.CDSS.DocuAgencyD(RowId)),3) //发布机构名称
	d OutputRowCmb
 }
 else
 {
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:q'="" q=$ZCONVERT(q,"U") //转换成大写
	s Id=""
	for{  
		s Id=$o(^CT.WDT.CDSS.DocuAgencyD(Id)) q:Id=""  
		s AgencyDesc = $lg($g(^CT.WDT.CDSS.DocuAgencyD(Id)),3) //发布机构名称
		s PINYINDesc=""
		s:desc'="" PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(AgencyDesc)  

		if ((($ZCONVERT(AgencyDesc,"U")[desc)||(PINYINDesc[desc))&(($ZCONVERT(AgencyDesc,"U")[q)||(PINYINDesc[q))) {
			s ArrAgency($l(AgencyDesc),Id)=""
		}
	}
	//按名称长度排序
	s len=""
	for{
		s len=$o(ArrAgency(len)) q:len=""
		s RowId=""
		for {
			s RowId=$o(ArrAgency(len,RowId),-1) q:RowId=""
			s AgencyDesc = $lg($g(^CT.WDT.CDSS.DocuAgencyD(RowId)),3) //发布机构名称
			d OutputRowCmb
		}	
	}
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(RowId,AgencyDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Function:用于实现数据校验功能的方法
/// Creator:高姗姗
/// CreateDate:2021-09-28   
/// Table: CT.WDT.CDSS.DocuAgency
/// w ##class(web.CDSS.CMKB.DocuAgency).FormValidate("","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, desc As %String) As %String
{
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc=""
	s:desc'="" flagc=$d(^CT.WDT.CDSS.DocuAgencyI("DescIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:desc'="" idc=$o(^CT.WDT.CDSS.DocuAgencyI("DescIndex",desc,0))	
		if ((idc'="")&(idc'=id)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Creator:高姗姗
/// CreatDate:2021-09-28
/// Description:保存文献发布机构
/// Table: CT.WDT.CDSS.DocuAgency
/// Input: eobj 文献发布机构实体对象
/// others:w ##class(web.CDSS.CMKB.DocuAgency).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.DocuAgency)
{
	s $zt="ERROR"
	s result=""

	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.RowId,eobj.AgencyDesc)  //重复校验
		q:flag=1 "{success:'false',errorinfo:'该发布机构已经存在'}"
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.DocuAgency).%New()
			s obj.AgencyCode = ..GetLastCode()
	
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.DocuAgency).%OpenId(eobj.RowId)
			
			s bobj = ##class(web.CDSSEntity.CMKB.DocuAgency).%New()
			s bobj.AgencyCode = obj.AgencyCode
			s bobj.AgencyDesc = obj.AgencyDesc
			s bobj.AgencyPriority = obj.AgencyPriority
		}
		s obj.AgencyDesc =##class(web.DHCBL.BDP.FunLib).Util(eobj.AgencyDesc) 
		s obj.AgencyPriority = eobj.AgencyPriority
		Ts
		s sc=obj.%Save()

		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
			
			Tc
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			
			 //保存日志
		    d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DocuAgency","CT.WDT.CDSS.DocuAgency","文献发布机构",id,eobj.AgencyDesc,"A",eobj)
		 	d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DocuAgency","CT.WDT.CDSS.DocuAgency","文献发布机构",eobj.RowId,eobj.AgencyDesc,"U",eobj,bobj)    
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("文献发布机构","web.CDSS.CMKB.DocuAgency","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("文献发布机构","web.CDSS.CMKB.DocuAgency","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze 
 q result
}

/// Other: w ##class(web.CDSS.CMKB.DocuAgency).TestSave()
ClassMethod TestSave() As %String
{
	s eobj = ##class(web.CDSSEntity.CMKB.DocuAgency).%New()
	s eobj.RowId=""
	s eobj.AgencyDesc="发布机构"
	s res=..SaveData(eobj)
	q res
}

/// Creator：高姗姗
/// CreatDate: 2021-09-28
/// Description:代码自动生成  DM000000 代码最大值加1
/// Table：CT.WDT.CDSS.DocuAgency
/// Other: w ##class(web.CDSS.CMKB.DocuAgency).GetLastCode()
ClassMethod GetLastCode() As %String
{
  	s CodeLen=8    //代码长度
  	s StartCode="DA"  //代码起始字符
  	s code=""
	s StartCodeLen=$Length(StartCode)
	s MKBTBRowId=0, preCode=""    //寻找符合规则的最大的代码
	s preCode=$tr($o(^CT.WDT.CDSS.DocuAgencyI("CodeIndex",""),-1)," ","")
	if (preCode="")   //如果没有符合规则的代码，则生成第一个
	{
		s zeroLen=CodeLen-StartCodeLen
		s zeroStr=""
		s count=0
		for
		{
			s count=count+1
			q:count>zeroLen
			s zeroStr=zeroStr_"0"
		}
		s preCode=StartCode_zeroStr
	}
	s CodeNum=$p(preCode,StartCode,2)+1     //ZD后的数字+1
	s CodeNumLen=$Length(CodeNum)     //数字的长度
	s code=$e(preCode,1,CodeLen-CodeNumLen)_CodeNum  //组合
	q code
}

/// Creator：高姗姗
/// CreatDate: 2021-09-28
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.DocuAgency
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.DocuAgency).OpenData("1")
ClassMethod OpenData(RowId As %String) As %String
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.DocuAgency).%New()
	s pobj = ##class(CT.WDT.CDSS.DocuAgency).%OpenId(RowId)
	s eobj.RowId = RowId
	s eobj.AgencyDesc = pobj.AgencyDesc
	s eobj.AgencyPriority = pobj.AgencyPriority

	d pobj.%Close()	
	k pobj	
	
	s str = eobj.JsonS()
		
	q str
}

/// Creator:高姗姗
/// CreatDate:2021-09-28
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other:w ##class(web.CDSS.CMKB.DocuAgency).GetRefFlag(8)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
    
    s return="0^未被引用可删除！"
	s RowId=""
	for
	{
		s RowId = $o(^CT.WDT.CDSS.DocuManageI("InstitutionIndex",id,RowId))
		q:RowId=""
		s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(RowId)),3) //中文文献名称
		if (myInfo=""){
			s myInfo="<文献发布机构V2.0--"_DocuDesc	
		}else{
			s myInfo=myInfo_" & "_DocuDesc	
		}	
	}
	s:myInfo'="" myInfo=myInfo_">"
	
	i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:高姗姗
/// CreatDate:2021-09-28
/// Description:删除文献发布机构内容
/// Table: CT.WDT.CDSS.DocuAgency
/// Input:id
/// others:w ##class(web.CDSS.CMKB.DocuAgency).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	s re=##class(web.CDSS.CMKB.DocuAgency).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
		s obj=##class(CT.WDT.CDSS.DocuAgency).%OpenId(id)	
		s bobj = ##class(web.CDSSEntity.CMKB.DocuAgency).%New()
		s bobj.AgencyCode = obj.AgencyCode
		s bobj.AgencyDesc = obj.AgencyDesc
		s bobj.AgencyPriority = obj.AgencyPriority

		Ts
		s sc=##class(CT.WDT.CDSS.DocuAgency).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DocuAgency","CT.WDT.CDSS.DocuAgency","文献发布机构",id,bobj.AgencyDesc,"D",bobj)
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
    }
	q result
}

/// Creator:Xuwenhu
/// CreatDate:2022-02-10
/// Description:数据统计
/// Table:CT.WDT.CDSS.DocuAgency
/// Input:
/// Return:总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Others:w ##class(web.CDSS.CMKB.DocuAgency).CountData()
ClassMethod CountData() As %String
{
	s (EditNum,AuditNum,StayNum,AllNum)=0
	s SQL="SELECT Count(*) AS num FROM CT_WDT_CDSS.DocuAgency"
	s tStatement=##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(SQL)
	if qStatus '= 1 
	{
		w "%Prepare failed:"
		d $System.status.DisplayError(qStatus)
		q
	}
	s rset = tStatement.%Execute()
	while rset.%Next() 
	{
		s AllNum=rset.num
	}
	q AllNum_"^"_EditNum_"^"_AuditNum_"^"_StayNum
}

}
