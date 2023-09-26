Class web.DHCBL.KB.DHCPHUsageDosage Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2014-12-5
/// Description：查询用法用量表内容
/// Table：User.DHCPHUsageDosage
/// Input：rowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHUsageDosage","GetList","3","10","FORM","2")
Query GetList(TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHUSDORowId,PHUSDOInstDr,PHINSTText")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s TypeDr=$o(^DHCPHPINL("0","Code","USAGE",0))
	s PHUSDOInstDr=0
	for
	{
		s PHUSDOInstDr=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PHUSDOInstDr))	q:PHUSDOInstDr=""
		s PHINSTText = $p($g(^DHCPHINSTRUC(PHUSDOInstDr)),"^",15)
		s PHUSDORowId = $o(^DHCPHUSDO("0","Inst",PHUSDOInstDr,0)) continue:PHUSDORowId=""
		d OutputRow
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHUSDORowId,PHUSDOInstDr,PHINSTText)
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
/// CreatDate: 2014-12-5
/// Description：保存修改内容
/// Table：User.DHCPHUsageDosage
/// Input：web.Entity.KB.DHCPHUsageDosage 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// , ids As %String
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHUsageDosage) As %String
{
 
 s result = "" 
 //病症、特殊人群描述历史数据赋初值
 s OPHDDDiseaDrs="",OSPEPISpecDrs=""
 if $IsObject(eobj)
 {	
 		Ts
		if (eobj.PHUSDORowId="")  //如果RowId未赋值则增加
		{
			;用法用量主索引
			s instobj=##class(User.DHCPHInstructions).%New() 
			;病症		
			;s drugobj = ##class(User.DHCPHDrugDisease).%New()
			;用法
			s useobj = ##class(User.DHCPHDiseaseUse).%New() 
			;用法用量
			s dosobj = ##class(User.DHCPHUsageDosage).%New() 
			;年龄
			s ageobj = ##class(User.DHCPHDiseaseAge).%New() 
			;特殊人群
			;s popuobj = ##class(User.DHCLibSpecPopuItm).%New() 
			;检验指标
			s labobj = ##class(User.DHCLibLabItm).%New() 
		}
		else  //如果RowId已赋值则修改
		{	
				;用法用量表
				s dosobj=##class(User.DHCPHUsageDosage).%OpenId(eobj.PHUSDORowId)
				;主索引
				s:eobj.PHUSDOInstDr'="" instobj = ##class(User.DHCPHInstructions).%OpenId(eobj.PHUSDOInstDr)
				;病症
					
				;用法
				s PDIRowId=$o(^DHCPHDISUSE(0,"Inst",eobj.PHUSDOInstDr,0))
				s:PDIRowId'="" useobj = ##class(User.DHCPHDiseaseUse).%OpenId(PDIRowId)
				s:PDIRowId="" useobj = ##class(User.DHCPHDiseaseUse).%New()
				;年龄
				s PDARowId=$o(^DHCPHDISAGE(0,"Inst",eobj.PHUSDOInstDr,0))
				s:PDARowId'="" ageobj = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
				s:PDARowId="" ageobj = ##class(User.DHCPHDiseaseAge).%New()
				;特殊人群
				;检验指标
				s LABIRowId=$o(^DHCLIBLABI(0,"Inst",eobj.PHUSDOInstDr,0))
				s:LABIRowId'="" labobj = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
				s:LABIRowId="" labobj = ##class(User.DHCLibLabItm).%New()
				;日志开始
				s bobj = ##class(web.Entity.KB.DHCPHUsageDosage).%New()
				s bobj.PHUSDORowId = eobj.PHUSDORowId
				//主索引
				s bobj.PHINSTMode=instobj.PHINSTMode //级别			
				s bobj.PHINSTSex=instobj.PHINSTSex //性别			
				s bobj.PHINSTDocUseTips=instobj.PHINSTDocUseTips //提示（医生）		
				s bobj.PHINSTNurseUseTips=instobj.PHINSTNurseUseTips //提示（护士患者）
				s bobj.PHINSTText=instobj.PHINSTText //描述
				
				s bobj.PHINSTActiveFlag=instobj.PHINSTActiveFlag 
				s bobj.PHINSTGenDr=instobj.PHINSTGenDr 
				s:instobj.PHINSTLibDr'="" bobj.PHINSTLibDr=instobj.PHINSTLibDr.%Id() 
				s bobj.PHINSTOrderNum=instobj.PHINSTOrderNum 
				s:instobj.PHINSTTypeDr'="" bobj.PHINSTTypeDr=instobj.PHINSTTypeDr.%Id()
				
				
				//用法用量
				s:dosobj.PHUSDOInstDr'="" bobj.PHUSDOInstDr = dosobj.PHUSDOInstDr.%Id() 
				s bobj.PHUSDOOneDayTimeMin = dosobj.PHUSDOOneDayTimeMin
				s bobj.PHUSDOOneDayTimeMax = dosobj.PHUSDOOneDayTimeMax
				s bobj.PHUSDOOnceQtyMin = dosobj.PHUSDOOnceQtyMin
				s bobj.PHUSDOOnceQtyMax = dosobj.PHUSDOOnceQtyMax
				s:dosobj.PHUSDOOnceQtyUomDr'="" bobj.PHUSDOOnceQtyUomDr = dosobj.PHUSDOOnceQtyUomDr.%Id()
				s bobj.PHUSDOOneDayQtyMin = dosobj.PHUSDOOneDayQtyMin
				s bobj.PHUSDOOneDayQtyMax = dosobj.PHUSDOOneDayQtyMax
				s:dosobj.PHUSDOOneDayQtyUomDr'="" bobj.PHUSDOOneDayQtyUomDr = dosobj.PHUSDOOneDayQtyUomDr.%Id()
				s bobj.PHUSDOOnceMaxQty = dosobj.PHUSDOOnceMaxQty
				s:dosobj.PHUSDOOnceMaxQtyUomDr'="" bobj.PHUSDOOnceMaxQtyUomDr = dosobj.PHUSDOOnceMaxQtyUomDr.%Id()
				s bobj.PHUSDOOneDayMaxQty = dosobj.PHUSDOOneDayMaxQty
				s:dosobj.PHUSDOOneDayMaxQtyUomDr'="" bobj.PHUSDOOneDayMaxQtyUomDr = dosobj.PHUSDOOneDayMaxQtyUomDr.%Id()
				s bobj.PHUSDOFristTimeQtyMin = dosobj.PHUSDOFristTimeQtyMin
				s bobj.PHUSDOFristTimeQtyMax = dosobj.PHUSDOFristTimeQtyMax
				s:dosobj.PHUSDOFristTimeQtyUomDr'="" bobj.PHUSDOFristTimeQtyUomDr = dosobj.PHUSDOFristTimeQtyUomDr.%Id()
				s bobj.PHUSDODurationQtyMin = dosobj.PHUSDODurationQtyMin
				s bobj.PHUSDODurationQtyMax = dosobj.PHUSDODurationQtyMax
				s:dosobj.PHUSDODurationQtyUomDr'="" bobj.PHUSDODurationQtyUomDr = dosobj.PHUSDODurationQtyUomDr.%Id()
				s bobj.PHUSDOSpaceQtyMin = dosobj.PHUSDOSpaceQtyMin
				s bobj.PHUSDOSpaceQtyMax = dosobj.PHUSDOSpaceQtyMax
				s:dosobj.PHUSDOSpaceQtyUomDr'="" bobj.PHUSDOSpaceQtyUomDr = dosobj.PHUSDOSpaceQtyUomDr.%Id()
				s bobj.PHUSDOWeightMin = dosobj.PHUSDOWeightMin
				s bobj.PHUSDOWeightMax = dosobj.PHUSDOWeightMax
				s bobj.PHUSDOBodyAreaMin = dosobj.PHUSDOBodyAreaMin
				s bobj.PHUSDOBodyAreaMax = dosobj.PHUSDOBodyAreaMax
				s bobj.PHUSDOPeriod = dosobj.PHUSDOPeriod  //疗程
				//病症	
				
				if (eobj.PHUSDORowId'=""){		
					s PHDDRowId=0
					for
					{
						s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",eobj.PHUSDOInstDr,PHDDRowId)) q:PHDDRowId=""
						s PHDDDiseaDr=$p($g(^DHCPHDDIS(PHDDRowId)),"^",3) //病症DR
						s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",2) //病症描述
						s:OPHDDDiseaDrs'="" OPHDDDiseaDrs=OPHDDDiseaDrs_"、"_PHDISLDiseaDesc	
						s:OPHDDDiseaDrs="" OPHDDDiseaDrs=PHDISLDiseaDesc
					}	
				}
				
				s bobj.PHDDDiseaDrs=OPHDDDiseaDrs
				//用法
				s:useobj.PDIUseDR'="" bobj.PHEINInstruc=useobj.PDIUseDR.%Id()
				//年龄
				s:ageobj.PDAAgeDr'="" bobj.PDAAge=ageobj.PDAAgeDr.%Id()
				s bobj.PDAMinVal=ageobj.PDAMinVal
				s bobj.PDAMaxVal=ageobj.PDAMaxVal
				s:ageobj.PDAUomDr'="" bobj.PDAUomDr=ageobj.PDAUomDr.%Id()
				//特殊人群	
				
				if (eobj.PHUSDORowId'=""){
					s SPEPIRowId=0
					for
					{
						s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",eobj.PHUSDOInstDr,SPEPIRowId)) q:SPEPIRowId=""
						s SPEPISpecDr=$p($g(^DHCLIBSPEPI(SPEPIRowId)),"^",2) //特殊人群DR
						if (SPEPISpecDr'="")
						{	
							s SPEDesc=$p($g(^DHCPHBTGE(SPEPISpecDr)),"^",2) //特殊人群描述
							s:OSPEPISpecDrs'="" OSPEPISpecDrs=OSPEPISpecDrs_"、"_SPEDesc	
							s:OSPEPISpecDrs="" OSPEPISpecDrs=SPEDesc
						}
					}
				}	
				s bobj.SPEPISpecDrs=OSPEPISpecDrs
						
				//检验指标
				s:labobj.LABILabDr'="" bobj.LABILabDr = labobj.LABILabDr.%Id()
				s bobj.LABIMinVal=labobj.LABIMinVal
				s bobj.LABIMaxVal=labobj.LABIMaxVal
				s:labobj.LABIUomDr'="" bobj.LABIUomDr = labobj.LABIUomDr.%Id()
				s bobj.LABIRelation=labobj.LABIRelation
				;日志结束
			}
			;用法用量主索引
			s instobj.PHINSTMode=eobj.PHINSTMode //级别			
			s instobj.PHINSTSex=eobj.PHINSTSex //性别			
			s instobj.PHINSTDocUseTips=eobj.PHINSTDocUseTips //提示（医生）		
			s instobj.PHINSTNurseUseTips=eobj.PHINSTNurseUseTips //提示（护士患者）
			s instobj.PHINSTText=eobj.PHINSTText //描述
			if (eobj.PHUSDORowId=""){
				s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT(eobj.PHINSTTypeDr,"U"),0))
				d:TypeDr'="" instobj.PHINSTTypeDrSetObjectId(TypeDr)
				s instobj.PHINSTOrderNum=eobj.PHINSTOrderNum
				//d:eobj.PHINSTGenDr'="" instobj.PHINSTGenDrSetObjectId(eobj.PHINSTGenDr)
				s:eobj.PHINSTGenDr'="" instobj.PHINSTGenDr=eobj.PHINSTGenDr
				s instobj.PHINSTPointerDr=eobj.PHINSTPointerDr
				s instobj.PHINSTPointerType=eobj.PHINSTPointerType
				s LibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT(eobj.PHINSTLibDr,"U"),0))
				d:LibDr'="" instobj.PHINSTLibDrSetObjectId(LibDr)
				s instobj.PHINSTActiveFlag=eobj.PHINSTActiveFlag
				s instobj.PHINSTSysFlag=eobj.PHINSTSysFlag	
			}	
			s instsc=instobj.%Save()
			If $$$ISOK(instsc){ 
				s instid = instobj.%Id()
				d instobj.%Close()				
			}else{		
			  s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(instsc)_"_'}"    //返回错误信息
			}
		if (instid'=""){
			
			;病症	
			s PHDDDiseaDrs=""
			s args=eobj.PHDISLDisea
			if (args'=""){
				s argsLen=$Length(args,",")
				for i=1:1:argsLen
				{                    //病症多选
					s eobj.PHDISLDisea=$p(args,",",i)
					s PHDISLDiseaDesc=$p($g(^DHCPHDISL(eobj.PHDISLDisea)),"^",2) //病症描述
					s:PHDDDiseaDrs'="" PHDDDiseaDrs=PHDDDiseaDrs_"、"_PHDISLDiseaDesc	
					s:PHDDDiseaDrs="" PHDDDiseaDrs=PHDISLDiseaDesc
					
					s drugobj = ##class(User.DHCPHDrugDisease).%New()
					d:eobj.PHDISLDisea'="" drugobj.PHDDDiseaDrSetObjectId(eobj.PHDISLDisea)
					d drugobj.PHDDInstDrSetObjectId(instid)
					s drugsc=drugobj.%Save()
					d drugobj.%Close()
					If $$$ISOK(drugsc){ 	
						s drugid = drugobj.%Id()
					}else{	
						s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(drugsc)_"_'}"    //返回错误信息
					}
				}
			}
			s:OPHDDDiseaDrs'="" PHDDDiseaDrs=OPHDDDiseaDrs_"、"_PHDDDiseaDrs	
			s:OPHDDDiseaDrs="" PHDDDiseaDrs=PHDDDiseaDrs
			
			s eobj.PHDDDiseaDrs=PHDDDiseaDrs
			
			;用法
			d:eobj.PHEINInstruc'="" useobj.PDIUseDRSetObjectId(eobj.PHEINInstruc)
			d useobj.PDIInstDrSetObjectId(instid)
			s usesc=useobj.%Save()
			d useobj.%Close()
			If $$$ISOK(usesc){ 	
				s useid = useobj.%Id()
			}else{	
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(usesc)_"_'}"    //返回错误信息
			}	
			;用法用量
			s dosobj.PHUSDOOneDayTimeMin = eobj.PHUSDOOneDayTimeMin
			s dosobj.PHUSDOOneDayTimeMax = eobj.PHUSDOOneDayTimeMax
			s dosobj.PHUSDOOnceQtyMin = eobj.PHUSDOOnceQtyMin
			s dosobj.PHUSDOOnceQtyMax = eobj.PHUSDOOnceQtyMax
			d:eobj.PHUSDOOnceQtyUomDr'="" dosobj.PHUSDOOnceQtyUomDrSetObjectId(eobj.PHUSDOOnceQtyUomDr)
			s dosobj.PHUSDOOneDayQtyMin = eobj.PHUSDOOneDayQtyMin
			s dosobj.PHUSDOOneDayQtyMax = eobj.PHUSDOOneDayQtyMax
			d:eobj.PHUSDOOneDayQtyUomDr'="" dosobj.PHUSDOOneDayQtyUomDrSetObjectId(eobj.PHUSDOOneDayQtyUomDr)
			s dosobj.PHUSDOOnceMaxQty = eobj.PHUSDOOnceMaxQty
			d:eobj.PHUSDOOnceMaxQtyUomDr'="" dosobj.PHUSDOOnceMaxQtyUomDrSetObjectId(eobj.PHUSDOOnceMaxQtyUomDr)
			s dosobj.PHUSDOOneDayMaxQty = eobj.PHUSDOOneDayMaxQty
			d:eobj.PHUSDOOneDayMaxQtyUomDr'="" dosobj.PHUSDOOneDayMaxQtyUomDrSetObjectId(eobj.PHUSDOOneDayMaxQtyUomDr)
			s dosobj.PHUSDOFristTimeQtyMin = eobj.PHUSDOFristTimeQtyMin
			s dosobj.PHUSDOFristTimeQtyMax = eobj.PHUSDOFristTimeQtyMax
			d:eobj.PHUSDOFristTimeQtyUomDr'="" dosobj.PHUSDOFristTimeQtyUomDrSetObjectId(eobj.PHUSDOFristTimeQtyUomDr)
			s dosobj.PHUSDODurationQtyMin = eobj.PHUSDODurationQtyMin
			s dosobj.PHUSDODurationQtyMax = eobj.PHUSDODurationQtyMax
			d:eobj.PHUSDODurationQtyUomDr'="" dosobj.PHUSDODurationQtyUomDrSetObjectId(eobj.PHUSDODurationQtyUomDr)
			s dosobj.PHUSDOSpaceQtyMin = eobj.PHUSDOSpaceQtyMin
			s dosobj.PHUSDOSpaceQtyMax = eobj.PHUSDOSpaceQtyMax
			d:eobj.PHUSDOSpaceQtyUomDr'="" dosobj.PHUSDOSpaceQtyUomDrSetObjectId(eobj.PHUSDOSpaceQtyUomDr)
			s dosobj.PHUSDOWeightMin = eobj.PHUSDOWeightMin
			s dosobj.PHUSDOWeightMax = eobj.PHUSDOWeightMax
			s dosobj.PHUSDOBodyAreaMin = eobj.PHUSDOBodyAreaMin
			s dosobj.PHUSDOBodyAreaMax = eobj.PHUSDOBodyAreaMax
			s dosobj.PHUSDOPeriod = eobj.PHUSDOPeriod  //疗程
			d dosobj.PHUSDOInstDrSetObjectId(instid)
			s dossc=dosobj.%Save()
			d dosobj.%Close()
			If $$$ISOK(dossc){ 	
				s dosid = dosobj.%Id()
			}else{	
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(dossc)_"_'}"    //返回错误信息
			}				
			;特殊人群
			s SPEPISpecDrs=""
			s popus=eobj.SpecialPopu
			if (popus'=""){
				s popusLen=$Length(popus,",")
				for i=1:1:popusLen
				{                   
					s eobj.SpecialPopu=$p(popus,",",i)
					s SPEDesc=$p($g(^DHCSPEP(eobj.SpecialPopu)),"^",2) //特殊人群描述
					s:SPEPISpecDrs'="" SPEPISpecDrs=SPEPISpecDrs_"、"_SPEDesc	
					s:SPEPISpecDrs="" SPEPISpecDrs=SPEDesc
					
					s popuobj = ##class(User.DHCLibSpecPopuItm).%New()
					d:eobj.SpecialPopu'="" popuobj.SPEPISpecDrSetObjectId(eobj.SpecialPopu)
					d popuobj.SPEPIInstDrSetObjectId(instid)
					s popusc=popuobj.%Save()
					d popuobj.%Close()
					If $$$ISOK(popusc){ 	
						s popuid = popuobj.%Id()
					}else{	
						s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(popusc)_"_'}"    //返回错误信息
					}
				}
			}
			s:OSPEPISpecDrs'="" SPEPISpecDrs=OSPEPISpecDrs_"、"_SPEPISpecDrs	
			s:OSPEPISpecDrs="" SPEPISpecDrs=SPEPISpecDrs
			s eobj.SPEPISpecDrs=SPEPISpecDrs
			
			/*
			s idsLen=$Length(ids,",")
			for i=1:1:idsLen
			{
				s id = $p(ids,",",i)
				s popuobj = ##class(User.DHCLibSpecPopuItm).%New() 
				d popuobj.SPEPISpecDrSetObjectId(id)	
				d popuobj.SPEPIInstDrSetObjectId(instid)
				s popusc=popuobj.%Save()
				d popuobj.%Close()	
			If $$$ISOK(popusc){ 
				s popuid = popuobj.%Id()	
			}else{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(popusc)_"_'}"    //返回错误信息
			}
			}*/
			;检验指标
			d:eobj.LABILabDr'="" labobj.LABILabDrSetObjectId(eobj.LABILabDr)
			s labobj.LABIMinVal=eobj.LABIMinVal
			s labobj.LABIMaxVal=eobj.LABIMaxVal
			d:eobj.LABIUomDr'="" labobj.LABIUomDrSetObjectId(eobj.LABIUomDr)
			s labobj.LABIRelation=eobj.LABIRelation
			d labobj.LABIInstDrSetObjectId(instid)
			s labsc=labobj.%Save()
			d labobj.%Close()
			If $$$ISOK(labsc){ 	
				s labid = labobj.%Id()
				s:eobj.LABILabDr'="" $p(^DHCPHEGEN(eobj.LABILabDr),"^",9)="Y" //设置检验项目通用名数据池标识
			}else{	
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(labsc)_"_'}"    //返回错误信息
			}
			;年龄
			d:eobj.PDAAge'="" ageobj.PDAAgeDrSetObjectId(eobj.PDAAge)
			d ageobj.PDAInstDrSetObjectId(instid)
			s ageobj.PDAMinVal=eobj.PDAMinVal
			s ageobj.PDAMaxVal=eobj.PDAMaxVal
			d:eobj.PDAUomDr'="" ageobj.PDAUomDrSetObjectId(eobj.PDAUomDr)
			s agesc=ageobj.%Save()
			d ageobj.%Close()
			If $$$ISOK(agesc){ 	
				s ageid = ageobj.%Id()
				s result = "{success:'true',id:'"_ageid_"'}" //返回RowId
				
			}else{	
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(agesc)_"_'}"    //返回错误信息
			}
		}	
		if (result["true"){
			d:eobj.PHUSDORowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-用法用量",instid,eobj.PHINSTText,"A",eobj)
			d:eobj.PHUSDORowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-用法用量",instid,eobj.PHINSTText,"U",eobj,bobj)
			Tc
		}else{
			Trollback
			s result="{success:'false',info:'保存失败'}"
		}	
	}
	q result
}

/// Description：打开禁忌数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHUsageDosage).OpenData("9")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	
	s eobj = ##class(web.Entity.KB.DHCPHUsageDosage).%New()
	;用法用量表
	s objdos = ##class(User.DHCPHUsageDosage).%OpenId(id)	
	s eobj.PHUSDORowId=id
	s:objdos.PHUSDOInstDr'="" eobj.PHUSDOInstDr = objdos.PHUSDOInstDr.%Id() 
	s eobj.PHUSDOOneDayTimeMin = objdos.PHUSDOOneDayTimeMin
	s eobj.PHUSDOOneDayTimeMax = objdos.PHUSDOOneDayTimeMax
	s eobj.PHUSDOOnceQtyMin = objdos.PHUSDOOnceQtyMin
	s eobj.PHUSDOOnceQtyMax = objdos.PHUSDOOnceQtyMax
	s:objdos.PHUSDOOnceQtyUomDr'="" eobj.PHUSDOOnceQtyUomDr = objdos.PHUSDOOnceQtyUomDr.%Id()
	s eobj.PHUSDOOneDayQtyMin = objdos.PHUSDOOneDayQtyMin
	s eobj.PHUSDOOneDayQtyMax = objdos.PHUSDOOneDayQtyMax
	s:objdos.PHUSDOOneDayQtyUomDr'="" eobj.PHUSDOOneDayQtyUomDr = objdos.PHUSDOOneDayQtyUomDr.%Id()
	s eobj.PHUSDOOnceMaxQty = objdos.PHUSDOOnceMaxQty
	s:objdos.PHUSDOOnceMaxQtyUomDr'="" eobj.PHUSDOOnceMaxQtyUomDr = objdos.PHUSDOOnceMaxQtyUomDr.%Id()
	s eobj.PHUSDOOneDayMaxQty = objdos.PHUSDOOneDayMaxQty
	s:objdos.PHUSDOOneDayMaxQtyUomDr'="" eobj.PHUSDOOneDayMaxQtyUomDr = objdos.PHUSDOOneDayMaxQtyUomDr.%Id()
	s eobj.PHUSDOFristTimeQtyMin = objdos.PHUSDOFristTimeQtyMin
	s eobj.PHUSDOFristTimeQtyMax = objdos.PHUSDOFristTimeQtyMax
	s:objdos.PHUSDOFristTimeQtyUomDr'="" eobj.PHUSDOFristTimeQtyUomDr = objdos.PHUSDOFristTimeQtyUomDr.%Id()
	s eobj.PHUSDODurationQtyMin = objdos.PHUSDODurationQtyMin
	s eobj.PHUSDODurationQtyMax = objdos.PHUSDODurationQtyMax
	s:objdos.PHUSDODurationQtyUomDr'="" eobj.PHUSDODurationQtyUomDr = objdos.PHUSDODurationQtyUomDr.%Id()
	s eobj.PHUSDOSpaceQtyMin = objdos.PHUSDOSpaceQtyMin
	s eobj.PHUSDOSpaceQtyMax = objdos.PHUSDOSpaceQtyMax
	s:objdos.PHUSDOSpaceQtyUomDr'="" eobj.PHUSDOSpaceQtyUomDr = objdos.PHUSDOSpaceQtyUomDr.%Id()
	s eobj.PHUSDOWeightMin = objdos.PHUSDOWeightMin
	s eobj.PHUSDOWeightMax = objdos.PHUSDOWeightMax
	s eobj.PHUSDOBodyAreaMin = objdos.PHUSDOBodyAreaMin
	s eobj.PHUSDOBodyAreaMax = objdos.PHUSDOBodyAreaMax
	s eobj.PHUSDOPeriod = objdos.PHUSDOPeriod  //疗程
	;主索引
	s:eobj.PHUSDOInstDr'="" objins = ##class(User.DHCPHInstructions).%OpenId(eobj.PHUSDOInstDr)
	s eobj.PHINSTMode=objins.PHINSTMode //级别			
	s eobj.PHINSTSex=objins.PHINSTSex //性别			
	s eobj.PHINSTDocUseTips=objins.PHINSTDocUseTips //提示（医生）		
	s eobj.PHINSTNurseUseTips=objins.PHINSTNurseUseTips //提示（护士患者）
	s eobj.PHINSTText=objins.PHINSTText //描述
	;病症
	s PHDDRowId=0
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",eobj.PHUSDOInstDr,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		s:PHDDDiseaDr'="" eobj.PHDISLDisea = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_","_eobj.PHDISLDisea 
		/*s eobj.PHDISLDisea = $p(^DHCPHDDIS(PHDDRowId),"^",3)_","_eobj.PHDISLDisea*/
	}
	;用法
	s PDIRowId=$o(^DHCPHDISUSE(0,"Inst",eobj.PHUSDOInstDr,0)) 
	s:PDIRowId'="" objuse = ##class(User.DHCPHDiseaseUse).%OpenId(PDIRowId)
	s:objuse.PDIUseDR'="" eobj.PHEINInstruc=objuse.PDIUseDR.%Id()
	
	;年龄
	s PDARowId=$o(^DHCPHDISAGE(0,"Inst",eobj.PHUSDOInstDr,0))
	if (PDARowId'=""){
		s objage = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
		if $IsObject(objage.PDAAgeDr){
			s eobj.PDAAge=objage.PDAAgeDr.%Id()
		}
		s eobj.PDAMinVal=objage.PDAMinVal
		s eobj.PDAMaxVal=objage.PDAMaxVal
		if $IsObject(objage.PDAUomDr){
			s eobj.PDAUomDr=objage.PDAUomDr.%Id()
		}
	}
	;特殊人群
	s SPEPIRowId=0
	for
	{
		s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",eobj.PHUSDOInstDr,SPEPIRowId)) q:SPEPIRowId=""
		s SPEPISpecDr=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)
		s:SPEPISpecDr'="" eobj.SpecialPopu=$p(^DHCSPEP(SPEPISpecDr),"^",2)_","_eobj.SpecialPopu	
		//s eobj.SpecialPopu=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)_"^"_eobj.SpecialPopu	
	}
	
	;检验指标
	s LABIRowId=$o(^DHCLIBLABI(0,"Inst",eobj.PHUSDOInstDr,0))
	s:LABIRowId'="" objlab = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
	s:objlab.LABILabDr'="" eobj.LABILabDr = objlab.LABILabDr.%Id()
	s:objlab.LABIMinVal'="" eobj.LABIMinVal=objlab.LABIMinVal
	s:objlab.LABIMaxVal'="" eobj.LABIMaxVal=objlab.LABIMaxVal
	s:objlab.LABIUomDr'="" eobj.LABIUomDr = objlab.LABIUomDr.%Id()
	s:objlab.LABIRelation'="" eobj.LABIRelation=objlab.LABIRelation
	
	s str = eobj.JsonS()
	s str = "{data:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2014-12-4
/// Description:根据id删除
/// Table:User.DHCPHUsageDosage
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHUsageDosage).DeleteData("21")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
	
	s eobj = ##class(web.Entity.KB.DHCPHUsageDosage).%New()
		
	;用法用量表
	s objdos = ##class(User.DHCPHUsageDosage).%OpenId(id)
	s eobj.PHUSDORowId=id
	s:objdos.PHUSDOInstDr'="" eobj.PHUSDOInstDr = objdos.PHUSDOInstDr.%Id() 
	s eobj.PHUSDOOneDayTimeMin = objdos.PHUSDOOneDayTimeMin
	s eobj.PHUSDOOneDayTimeMax = objdos.PHUSDOOneDayTimeMax
	s eobj.PHUSDOOnceQtyMin = objdos.PHUSDOOnceQtyMin
	s eobj.PHUSDOOnceQtyMax = objdos.PHUSDOOnceQtyMax
	s:objdos.PHUSDOOnceQtyUomDr'="" eobj.PHUSDOOnceQtyUomDr = objdos.PHUSDOOnceQtyUomDr.%Id()
	s eobj.PHUSDOOneDayQtyMin = objdos.PHUSDOOneDayQtyMin
	s eobj.PHUSDOOneDayQtyMax = objdos.PHUSDOOneDayQtyMax
	s:objdos.PHUSDOOneDayQtyUomDr'="" eobj.PHUSDOOneDayQtyUomDr = objdos.PHUSDOOneDayQtyUomDr.%Id()
	s eobj.PHUSDOOnceMaxQty = objdos.PHUSDOOnceMaxQty
	s:objdos.PHUSDOOnceMaxQtyUomDr'="" eobj.PHUSDOOnceMaxQtyUomDr = objdos.PHUSDOOnceMaxQtyUomDr.%Id()
	s eobj.PHUSDOOneDayMaxQty = objdos.PHUSDOOneDayMaxQty
	s:objdos.PHUSDOOneDayMaxQtyUomDr'="" eobj.PHUSDOOneDayMaxQtyUomDr = objdos.PHUSDOOneDayMaxQtyUomDr.%Id()
	s eobj.PHUSDOFristTimeQtyMin = objdos.PHUSDOFristTimeQtyMin
	s eobj.PHUSDOFristTimeQtyMax = objdos.PHUSDOFristTimeQtyMax
	s:objdos.PHUSDOFristTimeQtyUomDr'="" eobj.PHUSDOFristTimeQtyUomDr = objdos.PHUSDOFristTimeQtyUomDr.%Id()
	s eobj.PHUSDODurationQtyMin = objdos.PHUSDODurationQtyMin
	s eobj.PHUSDODurationQtyMax = objdos.PHUSDODurationQtyMax
	s:objdos.PHUSDODurationQtyUomDr'="" eobj.PHUSDODurationQtyUomDr = objdos.PHUSDODurationQtyUomDr.%Id()
	s eobj.PHUSDOSpaceQtyMin = objdos.PHUSDOSpaceQtyMin
	s eobj.PHUSDOSpaceQtyMax = objdos.PHUSDOSpaceQtyMax
	s:objdos.PHUSDOSpaceQtyUomDr'="" eobj.PHUSDOSpaceQtyUomDr = objdos.PHUSDOSpaceQtyUomDr.%Id()
	s eobj.PHUSDOWeightMin = objdos.PHUSDOWeightMin
	s eobj.PHUSDOWeightMax = objdos.PHUSDOWeightMax
	s eobj.PHUSDOBodyAreaMin = objdos.PHUSDOBodyAreaMin
	s eobj.PHUSDOBodyAreaMax = objdos.PHUSDOBodyAreaMax
	s eobj.PHUSDOPeriod = objdos.PHUSDOPeriod
	s scdos=##class(User.DHCPHUsageDosage).%DeleteId(id)	
	;病症
	s PHDDDiseaDrs=""
	s PHDDRowId=0
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",eobj.PHUSDOInstDr,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p($g(^DHCPHDDIS(PHDDRowId)),"^",3) //病症DR
		s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",2) //病症描述
		s:PHDDDiseaDrs'="" PHDDDiseaDrs=PHDDDiseaDrs_"、"_PHDISLDiseaDesc	
		s:PHDDDiseaDrs="" PHDDDiseaDrs=PHDISLDiseaDesc
		
		s:PHDDRowId'="" objdrug = ##class(User.DHCPHDrugDisease).%OpenId(PHDDRowId)
		s:objdrug.PHDDDiseaDr'="" eobj.PHDISLDisea=objdrug.PHDDDiseaDr.%Id()
		s scdrug=##class(User.DHCPHDrugDisease).%DeleteId(PHDDRowId)
	}
	s eobj.PHDDDiseaDrs=PHDDDiseaDrs
	;用法
	s PDIRowId=$o(^DHCPHDISUSE(0,"Inst",eobj.PHUSDOInstDr,0))
	s:PDIRowId'="" objuse = ##class(User.DHCPHDiseaseUse).%OpenId(PDIRowId)
	s:objuse.PDIUseDR'="" eobj.PHEINInstruc=objuse.PDIUseDR.%Id()
	s scuse=##class(User.DHCPHDiseaseUse).%DeleteId(PDIRowId)
	;年龄
	s PDARowId=$o(^DHCPHDISAGE(0,"Inst",eobj.PHUSDOInstDr,0))
	s:PDARowId'="" objage = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
	s:objage.PDAAgeDr'="" eobj.PDAAge=objage.PDAAgeDr.%Id()
	s eobj.PDAMinVal=objage.PDAMinVal
	s eobj.PDAMaxVal=objage.PDAMaxVal
	s:objage.PDAUomDr'="" eobj.PDAUomDr=objage.PDAUomDr.%Id()
	s scage=##class(User.DHCPHDiseaseAge).%DeleteId(PDARowId)
	;特殊人群
	s SPEPISpecDrs=""
	s SPEPIRowId=0
	for
	{
		s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",eobj.PHUSDOInstDr,SPEPIRowId)) q:SPEPIRowId=""
		s SPEPISpecDr=$p($g(^DHCLIBSPEPI(SPEPIRowId)),"^",2) //特殊人群DR	
		s SPEDesc=$p($g(^DHCSPEP(SPEPISpecDr)),"^",2) //特殊人群描述
		s:SPEPISpecDrs'="" SPEPISpecDrs=SPEPISpecDrs_"、"_SPEDesc	
		s:SPEPISpecDrs="" SPEPISpecDrs=SPEDesc
			
		s:SPEPIRowId'="" objpopu = ##class(User.DHCLibSpecPopuItm).%OpenId(SPEPIRowId)
		s:objpopu.SPEPISpecDr'="" eobj.SpecialPopu=objpopu.SPEPISpecDr.%Id()
		s scpopu=##class(User.DHCLibSpecPopuItm).%DeleteId(SPEPIRowId)
	}
	s eobj.SPEPISpecDrs=SPEPISpecDrs
	;检验指标
	s LABIRowId=$o(^DHCLIBLABI(0,"Inst",eobj.PHUSDOInstDr,0))
	s:LABIRowId'="" objlab = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
	s:objlab.LABILabDr'="" eobj.LABILabDr = objlab.LABILabDr.%Id()
	s eobj.LABIMinVal=objlab.LABIMinVal
	s eobj.LABIMaxVal=objlab.LABIMaxVal
	s:objlab.LABIUomDr'="" eobj.LABIUomDr = objlab.LABIUomDr.%Id()
	s eobj.LABIRelation=objlab.LABIRelation
	s sclab=##class(User.DHCLibLabItm).%DeleteId(LABIRowId)
	;主索引
	s:eobj.PHUSDOInstDr'="" objins = ##class(User.DHCPHInstructions).%OpenId(eobj.PHUSDOInstDr)
	s eobj.PHINSTMode=objins.PHINSTMode //级别			
	s eobj.PHINSTSex=objins.PHINSTSex //性别			
	s eobj.PHINSTDocUseTips=objins.PHINSTDocUseTips //提示（医生）		
	s eobj.PHINSTNurseUseTips=objins.PHINSTNurseUseTips //提示（护士患者）
	s eobj.PHINSTText=objins.PHINSTText //描述	
	s eobj.PHINSTActiveFlag=objins.PHINSTActiveFlag 
	s eobj.PHINSTGenDr=objins.PHINSTGenDr 
	s:objins.PHINSTLibDr'="" eobj.PHINSTLibDr=objins.PHINSTLibDr.%Id() 
	s eobj.PHINSTOrderNum=objins.PHINSTOrderNum 
	s:objins.PHINSTTypeDr'="" eobj.PHINSTTypeDr=objins.PHINSTTypeDr.%Id()
	s scinst=##class(User.DHCPHInstructions).%DeleteId(eobj.PHUSDOInstDr)
	
	if $$$ISOK(scinst){
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-用法用量",eobj.PHUSDOInstDr,eobj.PHINSTText,"D",eobj)
	}
	else{
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}

	q result
}

/// Description：根据主索引的id获取用法用量显示数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHUsageDosage).GetData("34")
ClassMethod GetData(InstId As %String) As %String
{
	s PHINSTText=""
	s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
	q PHINSTText
}

}
