Class web.eprajax.StdDictionaryInfo Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s type = $Get(%request.Data("Type",1),"")
	q:(type = "") $$$OK
	
	s param = $Get(%request.Data("Param",1),"")
	
	if (type = "getloc")
	{
		 d ..DicList(param)
	}
	
    Quit $$$OK
}

/// d ##Class(web.eprajax.StdDictionaryInfo).DicList("sjw")
ClassMethod DicList(param As %String)
{
	//结果行总数
	s totRowCount = 0
	
	s jsonStart = "["
	w jsonStart
	
	//开始查询
	s count = 0
	s rowid = 0
	for {
		s rowid=$o(^CTLOC(rowid))
		quit:(rowid = "")
		
		s ID = rowid
		s CodeValue=$p($g(^CTLOC(rowid)),"^",1)
		s DescValue=$p($g(^CTLOC(rowid)),"^",2)
		s AliasValue = $p($g(^CTLOC(rowid)),"^",43)
		
		//是否满足查询条件
		if (param '= "")
		{
			s containD = $F(DescValue,param)
			s containC = $F(CodeValue,param)
			s containA = $F(AliasValue,param)
			
			if ((containD = 0) && (containC = 0) && (containA = 0))
			{
				continue
			}	
		}
		
		s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue))
		s CodeValue = ##Class(EPRservice.Util.StringHelper).FilterSpecialChar(CodeValue)
		s DescValue = ##Class(EPRservice.Util.StringHelper).FilterSpecialChar(DescValue)
		s AliasValue = ##Class(EPRservice.Util.StringHelper).FilterSpecialChar(AliasValue)
		
		s count = count + 1
		if (count > 1) { w ","}
		
 	 	s json = "{ID:'"_ID_"',"
	 	s json = json_"DicCode:'"_CodeValue_"',"
		s json = json_"DicDesc:'"_DescValue_"',"	
	 	s json = json_"DicAlias:'"_AliasValue_"'}"
	 	w json
	}
	
	s jsonEnd = "]"	
	w jsonEnd
}

}
