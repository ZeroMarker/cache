/// 名称:医嘱项 项目依赖 增删改查(协定处方）
/// 编写者:基础数据平台组 - 李欣  陈莹
/// 编写日期:2017-09-15
Class web.DHCBL.CT.ARCItemDependent Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function: 医嘱项项目依赖 查询方法
/// Creator: 李欣	
/// CreateDate:2017-09-13
/// Table: ARC_ItemDependent
/// Output:DEPRowId,DEPARCIMDR,DEPDoseQty,DEPUnitDR,DEPDateFrom,DEPDateTo
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCItemDependent","GetList","3||1")
Query GetList(ParRef As %String) As %Query(ROWSPEC = "DEPRowId:%String,DEPARCIMDR:%String,DEPARCIMDRID:%String,DEPDoseQty:%String,DEPUnitDR:%String,DEPUnitDRID:%String,DEPDateFrom:%String,DEPDateTo:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ParRef As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if ParRef'=""
	{
		s parref=$p(ParRef,"||",1)
		s version=$p(ParRef,"||",2)
		s childsub = 0
		for
		{
			s childsub=$o(^ARCIM(parref,version,"DEPEND",childsub)) q:childsub=""
			s DEPRowId=parref_"||"_version_"||"_childsub
			s DEPARCIMDR = $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",3)
			s DEPARCIMDRID = $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",3)
			s ARCIMSub = $p(DEPARCIMDR,"||",1)
			s ARCIMVersion = $p(DEPARCIMDR,"||",2)
			s:DEPARCIMDR'="" DEPARCIMDR = $p($g(^ARCIM(ARCIMSub,ARCIMVersion,1)),"^",2) //医嘱项
			s DEPDoseQty = $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",7) //数量
			s DEPUnitDR = $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",8)
			s DEPUnitDRID = $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",8)
			s:DEPUnitDR'="" DEPUnitDR = $p($g(^CT("UOM",DEPUnitDR)),"^",2) //单位
			s DEPDateFrom= $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",1)
			s DEPDateTo= $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",2)
			s:DEPDateFrom'="" DEPDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPDateFrom)
			s:DEPDateTo'="" DEPDateTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPDateTo)
			d OutputRow
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(DEPRowId,DEPARCIMDR,DEPARCIMDRID,DEPDoseQty,DEPUnitDR,DEPUnitDRID,DEPDateFrom,DEPDateTo)
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

/// Function:获取单位拼串   基本单位、及两个等效单位
/// Creator:李欣
/// CreateDate:2017-09-14
/// Others:w ##class(web.DHCBL.CT.ARCItemDependent).GetUnitDataForCmb1("","1||1")
ClassMethod GetUnitDataForCmb1(rowid As %String, ARCIMRowId As %String)
{
	///单位拼串
	s total = 0
	s result=""
	k ^TMPUOMDEP
	if rowid'=""
	{
		s desc=$p($g(^CT("UOM",rowid)),"^",2)
		s result = "{""RowId"":"""_rowid_""",""Desc"":"""_desc_"""}"
		s total = 1
	}
	elseif ARCIMRowId'=""
	{
		///1.获取基本单位
		s INCIRowId = $o(^INCI(0,"ARCIM_DR",$p(ARCIMRowId,"||",1),0))
		if INCIRowId'=""
		{
			s INCICTUOMDR = $p($g(^INCI(INCIRowId,1)),"^",10)
			if (INCICTUOMDR'=""){
				s ^TMPUOMDEP(INCICTUOMDR)=""
				s desc=$p($g(^CT("UOM",INCICTUOMDR)),"^",2)
				s result = "{""RowId"":"""_INCICTUOMDR_""",""Desc"":"""_desc_"""}"
				s total = total + 1
			}
		}
		///2.获取等效单位
		s ARCIMSub = $p(ARCIMRowId,"||",1)
		s ARCIMVersion = $p(ARCIMRowId,"||",2)
		s ARCIMPDHDFDR = $p($g(^ARCIM(ARCIMSub,ARCIMVersion,1)),"^",12) //药学形态表RowID
		s PHCDrgMastRowId = $p(ARCIMPDHDFDR,"||",1) //DrgMast.RowId
		s PHCDFChildSub = $p(ARCIMPDHDFDR,"||",2) //PHCDrgForm.Chidlsub
		s EQChildsub = 0
		for
		{
			s EQChildsub = $o(^PHCD(PHCDrgMastRowId,"DF",PHCDFChildSub,"EQ",EQChildsub))
			q:EQChildsub=""
			s EQCTUOMDR = $p($g(^PHCD(PHCDrgMastRowId,"DF",PHCDFChildSub,"EQ",EQChildsub)),"^",1)
			if EQCTUOMDR'=""
			{
				if $d(^TMPUOMDEP(INCICTUOMDR))=0   //当基本单位和等效单位相同时去重 2017-11-13
				{
					s desc=$p($g(^CT("UOM",EQCTUOMDR)),"^",2)
					if result'=""
					{
						s result = result_",{""RowId"":"""_EQCTUOMDR_""",""Desc"":"""_desc_"""}"
					}
					else
					{
						s result = "{""RowId"":"""_EQCTUOMDR_""",""Desc"":"""_desc_"""}"
					}
					s total = total + 1	
				}
			}
		}
	}
	s result = "{""data"":["_result_"],""success"":""true"",""total"":"""_total_"""}"
	q result
}

/// Creator:李欣
/// CreateDate:2017-09-15
/// Table:User.ARCItemDependent
/// Description：保存/修改
/// Return:是否成功，成功返回RowId，失败返回原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ARCItemDependent) As %String
{
	n (eobj,%session)
	if $IsObject(eobj)
	{
		s:eobj.DEPDateFrom'="" eobj.DEPDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DEPDateFrom)
		s:eobj.DEPDateTo'="" eobj.DEPDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DEPDateTo)
	    s flag= ..FormValidate(eobj.DEPRowId,eobj.DEPParRef,eobj.DEPARCIMDR,eobj.DEPDateFrom,eobj.DEPDateTo)
		if (flag=0)
		{
			if (eobj.DEPRowId="")
			{	
		        s obj=##class(User.ARCItemDependent).%New(eobj.DEPParRef)
			}
			else
			{
				s obj=##class(User.ARCItemDependent).%OpenId(eobj.DEPRowId)
				s bobj = ##class(web.Entity.CT.ARCItemDependent).%New()
				s bobj.DEPRowId = eobj.DEPRowId
				s bobj.DEPParRef=$p(eobj.DEPRowId,"||",1)_"||"_$p(eobj.DEPRowId,"||",2)
				if $IsObject(obj.DEPARCIMDR)
	        	{
	        		s bobj.DEPARCIMDR=obj.DEPARCIMDR.%Id()
	        	}
				s bobj.DEPDateFrom = obj.DEPDateFrom
				s bobj.DEPDateTo = obj.DEPDateTo
	        	s bobj.DEPDoseQty=obj.DEPDoseQty
	        	if $IsObject(obj.DEPUnitDR){
	        		s bobj.DEPUnitDR=obj.DEPUnitDR.%Id()
	        	}
			}
			
			d obj.DEPParRefSetObjectId(eobj.DEPParRef)
			s obj.DEPDateFrom=eobj.DEPDateFrom
			s obj.DEPDateTo=eobj.DEPDateTo
	        s obj.DEPDoseQty=eobj.DEPDoseQty
	        d obj.DEPUnitDRSetObjectId(eobj.DEPUnitDR)
	        d obj.DEPARCIMDRSetObjectId(eobj.DEPARCIMDR)
	        s ARCIMDesc=eobj.DEPARCIMDR
			s:eobj.DEPARCIMDR'="" ARCIMDesc=$p($g(^ARCIM($p(eobj.DEPARCIMDR,"||",1),$p(eobj.DEPARCIMDR,"||",2),1)),"^",2) 
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"
				d:eobj.DEPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemDependent","User.ARCItemDependent","医嘱项项目依赖",id,ARCIMDesc,"A",eobj)
				d:eobj.DEPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemDependent","User.ARCItemDependent","医嘱项项目依赖",id,ARCIMDesc,"U",eobj,bobj)
			
			
			}else{
				Trollback
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项项目依赖","web.DHCBL.CT.ARCItemDependent","SaveEntity",eobj)
	    		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}
		else
		{
			s result = "{success:'false',errorinfo:'与数据库中记录重复，请重新核对数据'}"
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Function: 保存医嘱项项目依赖
/// CreateDate:2017-09-16
/// Creator:  陈莹
/// SaveDataStr:DEPRowId^DEPParRef^DEPARCIMDR^DEPUnitDR^DEPDoseQty^DEPDateFrom^ALRDateTo
/// Debug:    w ##class(web.DHCBL.CT.ARCItemDependent).SaveData("^1||1^2||1^4^1^09/06/2017^")
ClassMethod SaveData(SaveDataStr As %String) As %String
{
	n (SaveDataStr,%session)
	s eobj = ##class(web.Entity.CT.ARCItemDependent).%New()
	s eobj.DEPRowId=$p(SaveDataStr,"^",1)
	s eobj.DEPParRef=$p(SaveDataStr,"^",2)
	s eobj.DEPARCIMDR=$p(SaveDataStr,"^",3)
	s eobj.DEPUnitDR=$p(SaveDataStr,"^",4)
	s eobj.DEPDoseQty=$p(SaveDataStr,"^",5)
	s eobj.DEPDateFrom=$p(SaveDataStr,"^",6)
	s eobj.DEPDateTo=$p(SaveDataStr,"^",7)
	s Result=##class(web.DHCBL.CT.ARCItemDependent).SaveEntity(eobj)
	q Result
}

/// Creator:李欣
/// CreatDate:20170915
/// Description:数据重复验证方法
/// Table:User.ARCItemDependent
/// Input:id, parref,datefrom
/// Return:"1"(数据重复),"0"(数据都不重复)
/// 如果有已经截止的这条数据，要求新加的数据的开始日期要晚于 （不能等于）原来数据的结束日期
/// Other:W ##class(web.DHCBL.CT.ARCItemDependent).FormValidate("","3||1","57333")
ClassMethod FormValidate(id, parref, arcimdr, datefrom, dateto) As %String
{
	new (id,parref,arcimdr,datefrom,dateto)
	s id1="",id2="",id3="",flag=0
	s id1=$p(parref,"||",1)
	s id2=$p(parref,"||",2)
	if id'=""
	{
		s id1=$p(id,"||",1)
		s id2=$p(id,"||",2)
		s id3=$p(id,"||",3)
	}

	q:(id1="")||(id2="") 0
	s childsub=0
	for 
	{
		s childsub=$o(^ARCIM(id1,id2,"DEPEND",childsub)) 
		q:(childsub="")||(flag=1)
		s DEPARCIMDR = $p($g(^ARCIM(id1,id2,"DEPEND",childsub)),"^",3)
		s DEPDateFrom=$p($g(^ARCIM(id1,id2,"DEPEND",childsub)),"^",1)
		s DEPDateTo=$p($g(^ARCIM(id1,id2,"DEPEND",childsub)),"^",2)
		if (DEPARCIMDR=arcimdr)&&((id="")||((id'="")&&(id3'=childsub)))&&((DEPDateTo="")||((DEPDateTo'="")&&(datefrom<=DEPDateTo)))
		{
			s flag=1
		}
	}
	q flag
}

/// Function:对项目依赖的删除操作
/// Creator:李欣
/// CreateDate:2017-09-15
/// Desc:通过输入id来删除信息 
/// Output:success:'true',info:'删除成功！ 失败时输出删除失败！
/// Tables: ARC_ItemDependent
/// Others:w ##class(web.DHCBL.CT.ARCItemDependent).DeleteData("3||1||2")
ClassMethod DeleteData(id As %String) As %String
{
	n (id,%session)
	s result=""
	s eobj = ##class(web.Entity.CT.ARCItemDependent).%New()
	s parref=$p(id,"||",1)
	s version=$p(id,"||",2)
	s childsub=$p(id,"||",3)
	s eobj.DEPRowId = id
	s eobj.DEPParRef =$p(id,"||",1)_"||"_$p(id,"||",2)
	s eobj.DEPARCIMDR = $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",3)
	s eobj.DEPDoseQty = $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",7) //数量
	s eobj.DEPUnitDR = $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",8)
	s eobj.DEPDateFrom= $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",1)
	s eobj.DEPDateTo= $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",2)
	s ARCIMDesc=eobj.DEPARCIMDR
	s:eobj.DEPARCIMDR'="" ARCIMDesc=$p($g(^ARCIM($p(eobj.DEPARCIMDR,"||",1),$p(eobj.DEPARCIMDR,"||",2),1)),"^",2) 
	TStart
	s sc=##class(User.ARCItemDependent).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemDependent","User.ARCItemDependent","医嘱项项目依赖",id,ARCIMDesc,"D",eobj)
		d eobj.%Close()
	}
	else
	{
		Trollback
		s result= "{success:'false',info:'删除失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项项目依赖","web.DHCBL.CT.ARCItemDependent","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	} 
	q result
}

/// Creator：李欣 
/// CreatDate: 2017-09-15
/// Description：修改时打开Form，根据RowId查询
/// Table：User.ARCItemDependent
/// Input:id
/// Return：Json格式的字符串(即：form表单中对应的数据项)
/// Other:w ##class(web.DHCBL.CT.ARCItemDependent).OpenData("3||1||3")
ClassMethod OpenData(id As %String) As %String
{
	n (id)
    s str = ""
	s eobj = ##class(web.Entity.CT.ARCItemDependent).%New()
	s eobj.DEPRowId = id
	s parref=$p(id,"||",1)
	s version=$p(id,"||",2)
	s childsub=$p(id,"||",3)
	s eobj.DEPParRef =$p(id,"||",1)_"||"_$p(id,"||",2)
	s eobj.DEPARCIMDR = $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",3)
	s eobj.DEPDoseQty = $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",7) //数量
	s eobj.DEPUnitDR = $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",8)
	s eobj.DEPDateFrom= $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",1)
	s eobj.DEPDateTo= $p($g(^ARCIM(parref,version,"DEPEND",childsub)),"^",2)
	s eobj.DEPDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.DEPDateFrom)
	s eobj.DEPDateTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.DEPDateTo)
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2017-11-13  
/// Description:为combobox查询取数据(医嘱项)->ARC_ItmMast  不受授权限制，只取中药饮片（子类）
/// Table:User.ARCItmMast
/// Input:ordercat(医嘱大类desc),subcat(医嘱子类id),code,desc
/// Other:w ##class(web.DHCBL.CT.ARCItemDependent).GetDataForCmb3("","","","","")
/// 安徽亳州  中草药饮片
/// 新疆中医院 中药饮片
/// 广州正骨医院  中药饮片、中药免煎颗粒2019-03-19
ClassMethod GetDataForCmb3(rowid As %String, code As %String, desc As %String, start, limit) As %String
{
	if (rowid'="") {
		s ARCIMSubscript=$p(rowid, "||", 1)
		s ARCIMVersion=$p(rowid, "||", 2)
		s ARCIMRowId=rowid
		s ARCIMCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
		s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)

		s ARCIMCode =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMCode)
		s ARCIMDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMDesc)
		w "{""data"":["
		w "{""ARCIMRowId"":"""_ARCIMRowId_""",""ARCIMDesc"":"""_ARCIMDesc_"""}" 		
		w "],""total"":""1"",""success"":""true""}"
	}
	else 
	{
		if start="" s start=0
		if limit="" s limit=20
		s count=0
		s start=start+1
		s LookUpMode=""
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		
		
		W "{""data"":["
		S CurrentCount=0
		s arcimtemDesc="中药饮片^中药免煎颗粒"
		s length=$l(arcimtemDesc,"^")
		for i=1:1:length
		{
			s itemdesc=$p(arcimtemDesc,"^",i)
			s subcat=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(itemdesc),0))
			CONTINUE:subcat=""
			S ARCIMSubscript=0
			for
			{
				s ARCIMSubscript=$o(^ARCIM(0,"ARCIC_DR",subcat,ARCIMSubscript))  q:ARCIMSubscript=""
				s ARCIMVersion=0
				for 
				{
					s ARCIMVersion=$o(^ARCIM(0,"ARCIC_DR",subcat,ARCIMSubscript,ARCIMVersion))  q:ARCIMVersion=""
					s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
					
					s ARCIMCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)                  ;代码
					s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)                  ;描述
					
					s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)               ;开始日期
					s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
					s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
					s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)              ;结束日期
		
					CONTINUE:(ARCIMEffDate'="")&&(ARCIMEffDate>+$H)
					CONTINUE:(ARCIMEffDateTo'="")&&(ARCIMEffDateTo<+$H)
  		
					
					if desc'=""
					{
						s AliasFlag=0
						s ALIASText1=""
						s ALIASRowId=0,ALIASText1=""
						for 
						{
							s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId))             ;别名
							q:ALIASRowId=""
							s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
							s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
						}
						s Flag1=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,ARCIMDesc,desc)
						s Flag3=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,ALIASText1,desc)
						if (Flag1=1)||(Flag3=1) s AliasFlag=1
					}
					else
					{
						s AliasFlag=1
					}
					if ($ZCONVERT(ARCIMCode,"U")[code)&&(AliasFlag=1)
					{
						s count=count+1
						if (count<start) continue
						if ((count<(start+limit)))
						{
							s ARCIMCode =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMCode)
							s ARCIMDesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(ARCIMDesc)
				
							if CurrentCount=0
							{
								s CurrentCount=1
							}
							else
							{
								s CurrentCount=CurrentCount+1
								w ","
							}
							w "{""ARCIMRowId"":"""_ARCIMRowId_""",""ARCIMDesc"":"""_ARCIMDesc_"""}"
						}

					}
				}
			}
		}
		
		w "],""total"":"""_count_""",""success"":""true""}"
	}
	q ""
}

/// Creator:陈莹
/// CreatDate:2017-11-13  
/// Description:获取默认单位(g)对应的rowid
/// Other:w ##class(web.DHCBL.CT.ARCItemDependent).GetDefUnit()
ClassMethod GetDefUnit() As %String
{
	s id=$o(^CT("UOM",0,"Code","G",0))
	Q id
}

}
