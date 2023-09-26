/// Description: CDSS疾病关联指南V2.0表维护数据方法集合(增删改查)
/// Creator: 丁亚男
/// Date: 2020-08-07
Class web.CDSS.CMKB.DiseJoinDocu Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:丁亚男
/// CreatDate:2020-08-07
/// Description:获得疾病关联指南V2.0表内容
/// Table: CT.WDT.CDSS.DocuJoinDisease
/// Input: DiseID 疾病字典表RowID
/// Return:返回所有疾病关联指南V2.0表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseJoinDocu","GetList",86,"")
Query GetList(DiseID As %String, desc As %String) As %Query(ROWSPEC = "RowId,DocuDR,DocuDesc,DocuModifyDate,DocuModifyUser")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, DiseID As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (DiseID="") q ""
 	s:desc'="" desc=$ZCONVERT(desc,"U")  //转换成大写
 	s:desc'="" desc=$tr(desc," ","")     //过滤空格
	
	s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseID)),3)
	s DocuDRSet={}
	s IWordsDR =""
	for{
		s IWordsDR = $o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",DiseaseName,"识别条件",IWordsDR)) q:IWordsDR=""
		
		s RowId = ""
		for
		{
			s RowId = $o(^CT.WDT.CDSS.DocuJoinDiseaseI("IWordsDRIndex",IWordsDR,RowId)) q:RowId=""
			s DocuDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),2)
			s flag=DocuDRSet.%Get(DocuDR)
			if (flag=""){
				d DocuDRSet.%Set(DocuDR,DocuDR)
				s DocuDesc =""
				s:DocuDR'="" DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),3)
				s DocuModifyDate = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),4)
				s DocuModifyUser = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),5)
				
				if ($ZCONVERT(DocuDesc,"U")[desc)
				{
					d OutputRow
				}
			}
		}
	}
	s WordsDR=""
	for{
		s WordsDR = $o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",DiseaseName,"诊断条件",WordsDR)) q:WordsDR=""
		
		s RowId = 0
		for
		{
			s RowId = $o(^CT.WDT.CDSS.DocuJoinDiseaseI("WordsDRIndex",WordsDR,RowId)) q:RowId=""
			s DocuDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),2)
			s flag=DocuDRSet.%Get(DocuDR)
			if (flag=""){
				d DocuDRSet.%Set(DocuDR,DocuDR)
				s DocuDesc =""
				s:DocuDR'="" DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),3)
				s DocuModifyDate = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),4)
				s DocuModifyUser = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),5)
				
				if ($ZCONVERT(DocuDesc,"U")[desc)
				{
					d OutputRow
				}
			}
		}
	}
	
	
	/*
	s RowId = 0
	for
	{
		s RowId = $o(^CT.WDT.CDSS.DocuJoinDiseaseI("DiseIndex",DiseID,RowId)) q:RowId=""
		s DocuDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),2)
		s DocuDesc =""
		s:DocuDR'="" DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),3)
		s DocuModifyDate = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),4)
		s DocuModifyUser = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),5)
	
		if ($ZCONVERT(DocuDesc,"U")[desc)
		{
			d OutputRow
		}
	}*/
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,DocuDR,DocuDesc,DocuModifyDate,DocuModifyUser)
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

/// Creator:丁亚男
/// CreatDate:2020-8-7
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.ExamJoinParts	
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.ExamJoinParts).FormValidate("","1")
ClassMethod FormValidate(id As %String, IWordsDR As %String, DocuDR As %String) As %String
{
	q:(IWordsDR="")||(DocuDR="") ""
	s flag="",flagc=""
	s flagc=$d(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIWordsIndex",DocuDR,IWordsDR))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s idc=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIWordsIndex",DocuDR,IWordsDR,0))
  		
  		if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
	}
	
	q flag
}

/// Creator:丁亚男
/// CreatDate:2020-08-07
/// Description:保存疾病关联指南V2.0表
/// Table: CT.WDT.CDSS.DocuJoinDisease
/// Input: eobj 疾病关联指南V2.0表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.CMKB.DiseJoinDocu).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.DiseJoinDocu)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		//eobj.DiseaseDR——》WordsDR
		s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(eobj.DiseaseDR)),3)
		s IWordsDR =""
		s IWordsDR = $o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",DiseaseName,"识别条件",IWordsDR)) 
		if (IWordsDR="")	 //
		{
			q "{success:'false',errorinfo:'该疾病对应识别词不存在！'}"
		}
		s eobj.IWordsDR=IWordsDR
		s flag=..FormValidate(eobj.RowId,eobj.IWordsDR,eobj.DocuDR)
		if (flag=1)	 //校验重复
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.DocuJoinDisease).%New()	
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.DocuJoinDisease).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.DiseJoinDocu).%New()
			s:obj.DiseaseDR'="" bobj.DiseaseDR = obj.DiseaseDR.%Id()
			s:obj.DocuDR'="" bobj.DocuDR = obj.DocuDR.%Id()
			s:obj.IWordsDR'="" bobj.IWordsDR = obj.IWordsDR.%Id()
			
			s bobj.DocuModifyDate = obj.DocuModifyDate
			s bobj.DocuModifyUser= obj.DocuModifyUser
			
		}
		d:eobj.DiseaseDR'="" obj.DiseaseDRSetObjectId(eobj.DiseaseDR)
		d:eobj.DocuDR'="" obj.DocuDRSetObjectId(eobj.DocuDR)
		d:eobj.IWordsDR'="" obj.IWordsDRSetObjectId(eobj.IWordsDR)
		s obj.DocuModifyDate = $zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)
		s obj.DocuModifyUser = $Get(%session.Data("LOGON.USERNAME")) 
		
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DocuJoinDisease","CT.WDT.CDSS.DocuJoinDisease","疾病关联指南V2.0",id,eobj.DocuDR,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DocuJoinDisease","CT.WDT.CDSS.DocuJoinDisease","疾病关联指南V2.0",eobj.RowId,eobj.DocuDR,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联指南V2.0","web.CDSS.CMKB.DiseJoinDocu","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联指南V2.0","web.CDSS.CMKB.DiseJoinDocu","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator: 丁亚男
/// CreatDate:2020-08-07
/// Description:删除疾病关联指南V2.0表
/// Table: CT.WDT.CDSS.DocuJoinDisease
/// Input: id 疾病关联辅助检查检验id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.DiseJoinDocu).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Ts
	s obj=##class(CT.WDT.CDSS.DocuJoinDisease).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.DiseJoinDocu).%New()
	s:obj.DiseaseDR'="" bobj.DiseaseDR = obj.DiseaseDR.%Id()
	s:obj.DocuDR'="" bobj.DocuDR = obj.DocuDR.%Id()
	s:obj.IWordsDR'="" bobj.IWordsDR = obj.IWordsDR.%Id()
	s bobj.DocuModifyDate = obj.DocuModifyDate
	s bobj.DocuModifyUser= obj.DocuModifyUser
			
	s sc=##class(CT.WDT.CDSS.DocuJoinDisease).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DocuJoinDisease","CT.WDT.CDSS.DocuJoinDisease","疾病关联指南V2.0",id,bobj.DocuDR,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联指南V2.0","web.CDSS.CMKB.DiseJoinDocu","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2020-08-07
/// Description:通过id获取疾病关联指南V2.0内容
/// Table: CT.WDT.CDSS.DocuJoinDisease
/// Input: id 疾病关联指南V2.0id
/// Return: 疾病关联指南V2.0内容
/// others:w ##class(web.CDSS.CMKB.DiseJoinDocu).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.DiseJoinDocu).%New()
	s eobj.RowId= id
	s eobj.DiseaseDR = $LISTGET($G(^CT.WDT.CDSS.DocuJoinDiseaseD(id)),3)
	s eobj.DocuDR= $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(id)),2)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

}
