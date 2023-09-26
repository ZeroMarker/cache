Class web.DHCBL.CT.Arcim Extends %RegisteredObject [ ProcedureBlock ]
{

/// w ##class(web.DHCBL.CT.Arcim).GetARCIMEnable("1||1")
/// Input: ARCIMRowId （医嘱项rowid）
/// 开始日期是今天的医嘱可以开，结束日期是今天的也可以开
/// Return: Y、N  判断医嘱是否可用
/// 开始日期不为空并早于今天，结束日期为空或者结束日期晚于今天  
ClassMethod GetARCIMEnable(ARCIMRowId) As %String
{
	s enable=""
	q:ARCIMRowId="" "N"
	s ARCIMSubscript=$p(ARCIMRowId,"||",1)
	s ARCIMVersion=$p(ARCIMRowId,"||",2)
	s enable="N"
  	s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)       ; 开始日期
  	s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
	s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
  	s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)      ; 结束日期
  	s enable="N" 
	if ((ARCIMEffDate'="")&(ARCIMEffDate<=+$h))&((ARCIMEffDateTo="")||((ARCIMEffDateTo'="")&(ARCIMEffDateTo>=+$h))) s enable="Y"
	q enable
}

/// Creator：高姗姗
/// CreatDate: 2015-1-27
/// Description：查询检查项目内容
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.Arcim","GetList","")
Query GetList(desc) As %Query(ROWSPEC = "RowId:%String,Code:%String,Desc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, desc) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1

		s:desc'="" desc=$ZCONVERT(desc,"U")
		s ARCIMSubscript = 0
		for{
			s ARCIMSubscript = $o(^ARCIM(ARCIMSubscript)) q:ARCIMSubscript=""
			s ARCIMVersion = 0
			for{
				s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))	q:ARCIMVersion=""
				s RowId = ARCIMSubscript_"||"_ARCIMVersion
				s Code=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
				s Desc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
				s ServerMaterial=$p($g(^ARCIM($p(RowId,"||",1),$p(RowId,"||",2),7)),"^",6)	
				s enableflag=..GetARCIMEnable(RowId)
				
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(Desc))
				i (ServerMaterial="S")&(enableflag="Y")&(($ZCONVERT(Desc,"U")[desc)||(PINYIN[desc))  
				{
					d OutputRow
				}	
			}	
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowId,Code,Desc)
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

/// Creator：高姗姗
/// CreatDate: 2015-1-28
/// Description：查询心电项目内容
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.Arcim","GetElectList","")
Query GetElectList(desc) As %Query(ROWSPEC = "RowId:%String,Code:%String,Desc:%String")
{
}

ClassMethod GetElectListExecute(ByRef qHandle As %Binary, desc) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1

		s:desc'="" desc=$ZCONVERT(desc,"U")
		s ARCIMSubscript = 0
		for{
			s ARCIMSubscript = $o(^ARCIM(ARCIMSubscript)) q:ARCIMSubscript=""
			s ARCIMVersion = 0
			for{
				s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))	q:ARCIMVersion=""
				s RowId = ARCIMSubscript_"||"_ARCIMVersion
				s Code=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
				s Desc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)	
				s enableflag=..GetARCIMEnable(RowId)
				
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(Desc))
				s ItemCatDr=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)     ; 医嘱子分类 
				if (ItemCatDr'=""){
					s OrderType=$P($g(^ARC("IC",ItemCatDr)),"^",7) 
					i ((OrderType'="L")&(OrderType'="S")&(OrderType'="R")&(OrderType'="M"))&(enableflag="Y")&(($ZCONVERT(Desc,"U")[desc)||(PINYIN[desc))  
					{
						d OutputRowElect
					}	
				}
			}	
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowElect
    set Data=$lb(RowId,Code,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetElectListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetElectListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetElectListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetElectListExecute ]
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

/// Creator：丁亚男
/// CreatDate: 2018-3-13
/// Description：查询治疗项目内容
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.Arcim","GetTreatmentList","")
Query GetTreatmentList(desc) As %Query(ROWSPEC = "RowId:%String,Code:%String,Desc:%String")
{
}

ClassMethod GetTreatmentListExecute(ByRef qHandle As %Binary, desc) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1

		s:desc'="" desc=$ZCONVERT(desc,"U")
		s ARCIMSubscript = 0
		for{
			s ARCIMSubscript = $o(^ARCIM(ARCIMSubscript)) q:ARCIMSubscript=""
			s ARCIMVersion = 0
			for{
				s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))	q:ARCIMVersion=""
				s RowId = ARCIMSubscript_"||"_ARCIMVersion
				s Code=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
				s Desc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)	
				s enableflag=..GetARCIMEnable(RowId)
				
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(Desc))
				s ItemCatDr=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)     ; 医嘱子分类 
				if (ItemCatDr'=""){
					s OrderType=$P(^ARC("IC",ItemCatDr),"^",7) 
					i (OrderType="N")&(enableflag="Y")&(($ZCONVERT(Desc,"U")[desc)||(PINYIN[desc))  
					{
						d OutputRowTreatment
					}	
				}
			}	
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowTreatment
    set Data=$lb(RowId,Code,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTreatmentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTreatmentListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTreatmentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTreatmentListExecute ]
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
/// CreatDate:2013-2-22
/// Description:为combobox查询取数据
/// Table:User.ORCOperation
/// Input:code,desc
/// Return:OPERRowId,OPERCode,OPERDesc,OPERVersionDictDR,VersionCode,VersionName
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.Arcim","GetDataForCmbOper1","","","","")
Query GetDataForCmbOper1(rowid As %String, code As %String, desc As %String, versiondr As %String) As %Query(ROWSPEC = "OPERRowId:%String,OPERCode:%String,OPERDesc:%String,OPERVersionDictDR:%String,VersionCode:%String,VersionName:%String")
{
}

ClassMethod GetDataForCmbOper1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, versiondr As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s OPERRowId=rowid
		s OPERCode=$p($g(^ORC("OPER",OPERRowId)),"^",1)
		s OPERDesc=$p($g(^ORC("OPER",OPERRowId)),"^",2)
		//s OPERCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(OPERCode)
		//s OPERDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(OPERDesc)
		s OPERVersionDictDR=$p($g(^ORC("OPER",OPERRowId)),"^",41) //版本id
		s VersionCode="",VersionName=""
		s:OPERVersionDictDR'="" VersionCode=$lg($g(^CT.BDP.CT.BDVersionDictD(OPERVersionDictDR)),3)  //版本代码
		s:OPERVersionDictDR'="" VersionName=$lg($g(^CT.BDP.CT.BDVersionDictD(OPERVersionDictDR)),4)  //版本名称
		d OutputRowCmbOper
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s LookUpMode=##class(web.DHCBL.BDP.BDPAlias).GetConfig("ORC_Operation")
		
		s AuStr=##class(web.DHCBL.Authorize.ORCOperation).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s ARCIMRowIdAuStr=##class(web.DHCBL.Authorize.ARCItmMast).DHCGetDataByDefaultSession()
		if ($l(ARCIMRowIdAuStr,"#")=1) 
		{
			s Limited=0
			s AutBit=""
		}
		elseif ($l(ARCIMRowIdAuStr,"#")=2) 
		{
			s Limited=$p(ARCIMRowIdAuStr,"#",1)
			s AutBit=$p(ARCIMRowIdAuStr,"#",2)
 		}
		s ARCIMRowIdAuFlag=0
		if (ARCIMRowIdAuStr="")||((ARCIMRowIdAuStr'="")&(Limited=0)) s ARCIMRowIdAuFlag=1 //判断是否有授权,如果没有则全部显示
		s CATEGRowIdAuStr=##class(web.DHCBL.Authorize.ORCOperationCategory).DHCGetDataByDefaultSession()
		s CATEGRowIdAuFlag=0
		;未授权情况下，默认显示全部数据
		if (CATEGRowIdAuStr="")||(CATEGRowIdAuStr["limited:0") s CATEGRowIdAuFlag=1
		s CTSEXRowIdAuStr=##class(web.DHCBL.Authorize.CTSex).DHCGetDataByDefaultSession()
		s CTSEXRowIdAuFlag=0
		;未授权情况下，默认显示全部数据
		if (CTSEXRowIdAuStr="")||(CTSEXRowIdAuStr["limited:0") s CTSEXRowIdAuFlag=1
		s OPERRowId=0
		for
		{
			s OPERRowId=$o(^ORC("OPER",OPERRowId)) q:OPERRowId=""
			s ARCIMRowId=$p($g(^ORC("OPER",OPERRowId)),"^",4)  //ARCIMRowId=ARCIMSubscript||ARCIMVersion
			s ARCIMSubscript=$p(ARCIMRowId,"||",1)
			s CATEGRowId=$p($g(^ORC("OPER",OPERRowId)),"^",7)
			s CTSEXRowId=$p($g(^ORC("OPER",OPERRowId)),"^",12)
			
			
			s strRowId="{ID:"_OPERRowId_"}"
			s CATEGRowIdstrRowId="{ID:"_CATEGRowId_"}"
			s CTSEXRowIdstrRowId="{ID:"_CTSEXRowId_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((CATEGRowIdAuStr[CATEGRowIdstrRowId)||(CATEGRowIdAuFlag=1))&&((CTSEXRowIdAuStr[CTSEXRowIdstrRowId)||(CTSEXRowIdAuFlag=1))&&((ARCIMSubscript'="")&&($bit(AutBit,ARCIMSubscript)=1)||(ARCIMRowIdAuFlag=1)) ;用来筛选授权数据
			{
				s OPERCode=$p($g(^ORC("OPER",OPERRowId)),"^",1)
				s OPERDesc=$p($g(^ORC("OPER",OPERRowId)),"^",2)
				//s OPERCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(OPERCode)
				//s OPERDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(OPERDesc)
				
				s OPERVersionDictDR=$p($g(^ORC("OPER",OPERRowId)),"^",41) //版本id
				continue:((versiondr'="")&&(OPERVersionDictDR'=versiondr))
				s VersionCode="",VersionName=""
				s:OPERVersionDictDR'="" VersionCode=$lg($g(^CT.BDP.CT.BDVersionDictD(OPERVersionDictDR)),3)  //版本代码
				s:OPERVersionDictDR'="" VersionName=$lg($g(^CT.BDP.CT.BDVersionDictD(OPERVersionDictDR)),4)  //版本名称
				
				s OPERActiveDateTo=$p($g(^ORC("OPER",OPERRowId)),"^",6)
				continue:(OPERActiveDateTo'="")&&(OPERActiveDateTo<+$h)
				
				s OPERValid=$p($g(^ORC("OPER",OPERRowId)),"^",22)
				continue:OPERValid="N"	
				
				
				if desc'=""
				{
					s AliasFlag=0
					s ALIASText1=""
					s ALIASChildsub=0
					for
					{
						s ALIASChildsub=$o(^ORC("OPER",OPERRowId,"ALIAS",ALIASChildsub)) q:ALIASChildsub=""					
						s ALIASText=$g(^ORC("OPER",OPERRowId,"ALIAS",ALIASChildsub))
						s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
					}
				
					s Flag1=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,OPERDesc,desc)
					s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(OPERDesc)
					s Flag2=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,PINYIN,desc)
					s Flag3=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,ALIASText1,desc)
					if (Flag1=1)||(Flag2=1)||(Flag3=1) s AliasFlag=1
				}
				else
				{
					s AliasFlag=1
				}
				i ($ZCONVERT(OPERCode,"U")[code)&(AliasFlag=1)
				{
				
					d OutputRowCmbOper
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmbOper
    set Data=$lb(OPERRowId,OPERCode,OPERDesc,OPERVersionDictDR,VersionCode,VersionName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmbOper1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForOperCmb1Execute ]
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

ClassMethod GetDataForCmbOper1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmbOper1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：陈莹 		
/// CreatDate: 2012-8-29
/// Description：查询 药品剂型for combo
/// 注意:code和desc有些数据有回车^PHCF(32) = "普通片剂"_$c(13,10)_"^普通片剂"_$c(13,10) 
/// Table：User.PHCForm
/// Input： code, desc
/// Output:PHCFRowId,PHCFCode,PHCFDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCForm","GetDataForCmb1","","","")
Query GetDataForCmbForm1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHCFRowId:%String,PHCFCode:%String,PHCFDesc:%String")
{
}

ClassMethod GetDataForCmbForm1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHCFRowId=rowid
		s PHCFCode=$p($g(^PHCF(PHCFRowId)),"^",1)
		s PHCFDesc=$p($g(^PHCF(PHCFRowId)),"^",2)
		d OutputRowCmbForm
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.PHCForm).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCFRowId=0
		for
		{
			s PHCFRowId=$o(^PHCF(PHCFRowId)) q:PHCFRowId=""
			s strRowId="{ID:"_PHCFRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCFCode=$p($g(^PHCF(PHCFRowId)),"^",1) //"普通片剂"_$c(13,10)_"
				s PHCFDesc=$p($g(^PHCF(PHCFRowId)),"^",2)
				s PHCFCode1=$ZCONVERT(PHCFCode,"U")
				s PHCFDesc1=$ZCONVERT(PHCFDesc,"U")
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Form",PHCFRowId,PHCFDesc,desc)
				}
				else
				{
					s AliasFlag=1
				}
				i ($ZCONVERT(PHCFCode,"U")[code)&(AliasFlag=1)
				{
					d OutputRowCmbForm
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmbForm
    set Data=$lb(PHCFRowId,PHCFCode,PHCFDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmbForm1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmbForm1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmbForm1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmbForm1Execute ]
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
/// CreatDate:2012-8-29
/// Description:查询 药品处方通用名
/// Table:User.PHCGeneric
/// Input: code, desc(name)
/// Output:PHCGERowId,PHCGECode,PHCGEName
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCGeneric","GetDataForCmb1","","")
Query GetDataForCmbGen1(rowid As %String, code As %String, desc As %String, name As %String) As %Query(ROWSPEC = "PHCGERowId:%String,PHCGECode:%String,PHCGEName:%String")
{
}

ClassMethod GetDataForCmbGen1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, name As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s PHCGERowId=rowid
		s PHCGECode= $p($g(^PHCGE("GE",PHCGERowId)),"^",1)
		s PHCGEName = $p($g(^PHCGE("GE",PHCGERowId)),"^",2)
		d OutputRowCmbGen
	}
	else
	{
		s:name'="" desc=name
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s AuStr=##class(web.DHCBL.Authorize.PHCGeneric).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCGERowId=0
		for
		{
			s PHCGERowId=$o(^PHCGE("GE",PHCGERowId)) q:PHCGERowId=""
			s strRowId="{ID:"_PHCGERowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCGECode=$p($g(^PHCGE("GE",PHCGERowId)),"^",1)
				s PHCGEName = $p($g(^PHCGE("GE",PHCGERowId)),"^",2)
				s PHCGEDateTo = $p($g(^PHCGE("GE",PHCGERowId)),"^",6)
				continue:(PHCGEDateTo'="")&&(PHCGEDateTo<+$h)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Generic",PHCGERowId,PHCGEName,desc)
				}
				else
				{
					s AliasFlag=1
				}
				i ($ZCONVERT(PHCGECode,"U")[code)&(AliasFlag=1)
				{
					d OutputRowCmbGen
				}
			}
	
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmbGen
    set Data=$lb(PHCGERowId,PHCGECode,PHCGEName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmbGen1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmbGen1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmbGen1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmbGen1Execute ]
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
