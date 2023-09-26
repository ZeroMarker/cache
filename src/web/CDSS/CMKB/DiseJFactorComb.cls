/// Description: 疾病关联诊断因子组合表数据维护
/// Creator: 丁亚男
/// Date: 2020-12-24
Class web.CDSS.CMKB.DiseJFactorComb Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2020-12-23
/// Description:获得疾病关联诊断因子组合内容
/// Table: CT.WDT.CDSS.DiseJFactorComb
/// Input: DiseID 疾病字典表RowID
/// Return:返回所有疾病关联诊断因子组合表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DiseJFactorComb","GetList",182,"")
Query GetList(DiseID As %String, desc As %String) As %Query(ROWSPEC = "RowId,DiseJFactorDRsF,DiseJFactorDRs,CombGradeF,CombGrade,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, DiseID As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (DiseID="") q ""
 	s:desc'="" desc=$ZCONVERT(desc,"U")  //转换成大写
 	s:desc'="" desc=$tr(desc," ","")     //过滤空格
	s RowId = 0
	for
	{
		s RowId = $o(^CT.WDT.CDSS.DiseJFactorCombI("DiseaseDRIndex",DiseID,RowId)) q:RowId=""
		s DiseJFactorDRsF = $lg($g(^CT.WDT.CDSS.DiseJFactorCombD(RowId)),3)
		s DiseJFactorDRs=""
		if (DiseJFactorDRsF'="")
	 	{
		 	s DiseJFLen=$L(DiseJFactorDRsF,",")
		 
		 	for iDiseJF=1:1:DiseJFLen
		 	{
			 	s DiseJFDR=$p(DiseJFactorDRsF,",",iDiseJF)
			 	s FactorDR = $lg($g(^CT.WDT.CDSS.DiseJFactorD(DiseJFDR)),3)
				s DiagFactorName =""
				s:FactorDR'="" DiagFactorName = $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(FactorDR)),3)
			 	s:DiseJFactorDRs'="" DiseJFactorDRs=DiseJFactorDRs_","_DiagFactorName
			 	s:DiseJFactorDRs="" DiseJFactorDRs=DiagFactorName
			}
		}
		
		s CombGrade= $lg($g(^CT.WDT.CDSS.DiseJFactorCombD(RowId)),4)
		s CombGradeF=CombGrade
		s Remarks= $lg($g(^CT.WDT.CDSS.DiseJFactorCombD(RowId)),5)
			
		if ($ZCONVERT(DiseJFactorDRs,"U")[desc)
		{
			d OutputRow
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,DiseJFactorDRsF,DiseJFactorDRs,CombGradeF,CombGrade,Remarks)
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
/// CreatDate:2020-12-23
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.DiseJFactorComb
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.ExamJoinParts).FormValidate("","1")
ClassMethod FormValidate(id As %String, DiseaseDR As %String, DiseJFactorDRs As %String) As %String
{
	q:(DiseaseDR="")||(DiseJFactorDRs="") ""
	s flag="",flagc=""
	s flagc=$d(^CT.WDT.CDSS.DiseJFactorCombI("DiseJFactorDRsIndex",DiseaseDR,DiseJFactorDRs))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s idc=$o(^CT.WDT.CDSS.DiseJFactorCombI("DiseJFactorDRsIndex",DiseaseDR,DiseJFactorDRs,0))
  		
  		if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
	}
	
	q flag
}

/// Creator:丁亚男
/// CreatDate:2020-12-23
/// Description:保存疾病关联诊断因子组合表
/// Table: CT.WDT.CDSS.DiseJFactorComb
/// Input: eobj 疾病关联诊断因子组合表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.CMKB.DiseJFactorComb).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.DiseJFactorComb)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.RowId,eobj.DiseaseDR,eobj.DiseJFactorDRs)
		if (flag=1)	 //校验重复
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.DiseJFactorComb).%New()	
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.DiseJFactorComb).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.DiseJFactorComb).%New()
			if $IsObject(obj.DiseaseDR)
			{
			 	s bobj.DiseaseDR = obj.DiseaseDR.%Id()
			}
			s bobj.DiseJFactorDRs = obj.DiseJFactorDRs
			s bobj.CombGrade = obj.CombGrade
			s bobj.Remarks= obj.Remarks
			
		}
		d:eobj.DiseaseDR'="" obj.DiseaseDRSetObjectId(eobj.DiseaseDR)
		s obj.DiseJFactorDRs = eobj.DiseJFactorDRs
		s obj.CombGrade = eobj.CombGrade
		s obj.Remarks= eobj.Remarks
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存责任人、操作时间
			d ##class(web.CDSS.CMKB.DiseJProperty).AddResponUser(eobj.DiseaseDR,eobj.OperationUser)
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJFactorComb","CT.WDT.CDSS.DiseJFactorComb","疾病关联诊断因子组合",id,eobj.DiseJFactorDRs,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJFactorComb","CT.WDT.CDSS.DiseJFactorComb","疾病关联诊断因子组合",eobj.RowId,eobj.DiseJFactorDRs,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联诊断因子组合","web.CDSS.CMKB.DiseJFactorComb","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联诊断因子组合","web.CDSS.CMKB.DiseJFactorComb","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator: 丁亚男
/// CreatDate:2020-12-23
/// Description:删除疾病关联诊断因子组合表
/// Table: CT.WDT.CDSS.DiseJFactorComb
/// Input: id 疾病关联辅助检查检验id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.DiseJFactorComb).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Ts
	s obj=##class(CT.WDT.CDSS.DiseJFactorComb).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.DiseJFactorComb).%New()
	if $IsObject(obj.DiseaseDR)
	{
	 	s bobj.DiseaseDR = obj.DiseaseDR.%Id()
	}
	s bobj.DiseJFactorDRs = obj.DiseJFactorDRs
	s bobj.CombGrade = obj.CombGrade
	s bobj.Remarks= obj.Remarks
			
	s sc=##class(CT.WDT.CDSS.DiseJFactorComb).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseJFactorComb","CT.WDT.CDSS.DiseJFactorComb","疾病关联诊断因子组合",id,bobj.DiseJFactorDRs,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("疾病关联诊断因子组合","web.CDSS.CMKB.DiseJFactorComb","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2020-12-23
/// Description:通过id获取疾病关联诊断因子组合内容
/// Table: CT.WDT.CDSS.DiseJFactorComb
/// Input: id 疾病关联诊断因子组合id
/// Return: 疾病关联诊断因子组合内容
/// others:w ##class(web.CDSS.CMKB.DiseJFactorComb).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.DiseJFactorComb).%New()
	s eobj.RowId= id
	s eobj.DiseaseDR = $LISTGET($G(^CT.WDT.CDSS.DiseJFactorCombD(id)),2)
	s eobj.DiseJFactorDRs= $lg($g(^CT.WDT.CDSS.DiseJFactorCombD(id)),3)
	s eobj.CombGrade = $lg($g(^CT.WDT.CDSS.DiseJFactorCombD(id)),4)
	s eobj.Remarks= $lg($g(^CT.WDT.CDSS.DiseJFactorCombD(id)),5)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

}
