Class web.BDPExt.ORCOperationBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod SaveEntity(Ceobj As web.Entity.CT.ORCOperation2) As %String
{
	n (Ceobj,%session)
	s ImportResult=""
	
	s Ceobj.OPERValid="Y"
	
	s Ceobj.OPERType=$CASE(Ceobj.OPERType,"常规":"N","诊断性操作":"D","治疗性操作":"T","手术":"N","介入治疗":"I",:"")
	s Ceobj.OPERTechnique=$CASE(Ceobj.OPERTechnique,"常规":"N","普通":"N","开放":"N","介入":"I","内镜":"E","腹镜":"L","腔镜":"L","操作":"P",:"")
	s Ceobj.OPERApplyFeature=$CASE(Ceobj.OPERApplyFeature,"必选":"R","中医必选":"C","选择性":"O",:"")
	
	s:Ceobj.OPERDateActiveFrom="" Ceobj.OPERDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	ts
	s OPERSaveResult=##class(web.DHCBL.CT.ORCOperation).SaveEntity2(Ceobj)
	s OPERRowId=##class(web.BDPExt.FunLib).GetResultRowId(OPERSaveResult)
	if (OPERRowId="")
	{
		s ImportResult="手术:"_OPERSaveResult	
	}
	else{
		if (Ceobj.DataAlias'="")  //2017-3-9 自动添加别名到BDPAlias表
		{
			S aliasstr=""
			s length=$l(Ceobj.DataAlias,"&")
			for aliasi=1:1:length
			{
				s alias=$p(Ceobj.DataAlias,"&",aliasi)
				IF alias'=""
				{
					
					 i aliasstr="" s aliasstr="^"_alias_"^"_OPERRowId
					 else  s aliasstr=aliasstr_"#"_"^"_alias_"^"_OPERRowId
				}
			}
			s:alias'="" aliasret= ##class(web.DHCBL.CT.ORCOperationAlias).SaveAll(aliasstr)
		}
	}
	
	if (ImportResult="")
	{
		tc
		s ImportResult="{success:'true',id:'"_OPERRowId_"'}" 
	}
	else
	{
		tro
		s RowId=$o(^ORC("OPER",""),-1)
		if (RowId'="")&&(RowId>0)
		{
			if ($D(^ORC("OPER",RowId))=10) k ^ORC("OPER",RowId)
		}
	}
	q ImportResult
}

/// d ##class(web.BDPExt.ORCOperationBLL).Update(12697)
ClassMethod Update(StartRowId) As %String
{
	s RowId=StartRowId
	for
	{
		s RowId=$o(^ORC("OPER",RowId)) q:RowId=""
		if (RowId'="")&&(RowId>0)
		{
			if ($D(^ORC("OPER",RowId))=10) k ^ORC("OPER",RowId)
		}
	
	}
}

/// chenying 
/// 2020-08-25
/// d ##class(web.BDPExt.ORCOperationBLL).EndAllOperation("2020-08-25") /// 批量全停所有有效手术
ClassMethod EndAllOperation(date) As %String
{
	s date=$zdh(date,3)
	s id=0
	for
	{
		s id=$o(^ORC("OPER",id)) q:id=""
		s obj=##class(User.ORCOperation).%OpenId(id)
		if (obj.OPERActiveDateTo="")&&(obj.OPERDateActiveFrom'="")&&(obj.OPERDateActiveFrom<date)
		{
			 s obj.OPERActiveDateTo=date
			 s obj.OPERValid="N"
			 D obj.%Save()
		}	
	}
}

/// 手术数据，如果ICD10和名称一样就把原来数据的截止日期去掉，开始日期还是使用原来的。
/// 如果不完全一样就新增数据。
ClassMethod SaveEntityAdd(Ceobj As web.Entity.CT.ORCOperation2) As %String
{
	n (Ceobj,%session)
	s ImportResult=""
	s:Ceobj.OPERValid="" Ceobj.OPERValid="Y"
	s Ceobj.OPERType=$CASE(Ceobj.OPERType,"常规":"N","诊断性操作":"D","治疗性操作":"T","手术":"N","介入治疗":"I",:"")
	s Ceobj.OPERTechnique=$CASE(Ceobj.OPERTechnique,"常规":"N","普通":"N","开放":"N","介入":"I","内镜":"E","腹镜":"L","腔镜":"L","操作":"P",:"")
	s Ceobj.OPERApplyFeature=$CASE(Ceobj.OPERApplyFeature,"必选":"R","中医必选":"C","选择性":"O",:"")
	s:Ceobj.OPERDateActiveFrom="" Ceobj.OPERDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	s OPERRowId=""
	///获取描述和ICD10完全一样的数据的rowid
	s id=0
	for
	{
		s id=$o(^ORC("OPER",0,"Desc",$$ALPHAUP^SSUTIL4(Ceobj.OPERDesc),id)) q:id=""
		s OPERDesc=$p($g(^ORC("OPER",id)),"^",2)
		s OPERICD10=$p($g(^ORC("OPER",id)),"^",14)
		if (OPERICD10=Ceobj.OPERICD10)&&(OPERDesc=Ceobj.OPERDesc)
		{
			s OPERRowId=id
		}
	}
	
	ts
	if OPERRowId'=""
	{
		s Ceobj.OPERRowId=OPERRowId
		s Ceobj.OPERDateActiveFrom=$p($g(^ORC("OPER",OPERRowId)),"^",5)
		s Ceobj.OPERActiveDateTo=""
	}
	s OPERSaveResult=##class(web.DHCBL.CT.ORCOperation).SaveEntity2(Ceobj)
	s OPERRowId=##class(web.BDPExt.FunLib).GetResultRowId(OPERSaveResult)
	if (OPERRowId="")
	{
		s ImportResult="手术:"_OPERSaveResult	
	}
	else
	{
		if (Ceobj.DataAlias'="")  //2017-3-9 自动添加别名到BDPAlias表
		{
			S aliasstr=""
			s length=$l(Ceobj.DataAlias,"\")
			for aliasi=1:1:length
			{
				s alias=$p(Ceobj.DataAlias,"\",aliasi)
				IF alias'=""
				{
					
					 i aliasstr="" s aliasstr="^"_alias_"^"_OPERRowId
					 else  s aliasstr=aliasstr_"#"_"^"_alias_"^"_OPERRowId
				}
			}
			d:alias'="" ##class(web.DHCBL.CT.ORCOperationAlias).SaveAll(aliasstr)
		}
	}
	
	if (ImportResult="")
	{
		tc
		s ImportResult="{success:'true',id:'"_OPERRowId_"'}" 
	}
	else
	{
		tro
		s RowId=$o(^ORC("OPER",""),-1)
		if (RowId'="")&&(RowId>0)
		{
			if ($D(^ORC("OPER",RowId))=10) k ^ORC("OPER",RowId)
		}
	}
	q ImportResult
}

}
