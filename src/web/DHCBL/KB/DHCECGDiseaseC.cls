/// 名称: (禁忌症)心电业务表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-高姗姗
/// 编写日期: 2015-1-7
Class web.DHCBL.KB.DHCECGDiseaseC Extends %RegisteredObject
{

/// Description：打开禁忌症数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCECGDiseaseC).OpenConData("128")
ClassMethod OpenConData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.KB.DHCECGDiseaseC).%New()
	s eobj.PHDDInstDr=id
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	;病症
	s PHDDRowId=0
	for{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",id,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		if (PHDDDiseaDr'="") {
			if (eobj.PHDDDiseaDr'=""){
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_","_eobj.PHDDDiseaDr
			}
			else{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		} 
	}
	;检查结果
	s EXAIRowId=0
	for{
		s EXAIRowId=$o(^DHCLIBEXAI(0,"Inst",id,EXAIRowId)) q:EXAIRowId=""
		s EXAIExamDr=$p(^DHCLIBEXAI(EXAIRowId),"^",2)
		if (EXAIExamDr'="") {
			if (eobj.PHDDExamDr'=""){
				s eobj.PHDDExamDr = $p(^DHCEXAMINE(EXAIExamDr),"^",2)_","_eobj.PHDDExamDr
			}
			else{
				s eobj.PHDDExamDr = $p(^DHCEXAMINE(EXAIExamDr),"^",2)
			}
		} 
	}

	//通过索引获取生理参数业务表DHC_PhysiologyVal的RowId——PHYVRowId
	s PHYVRowId=$o(^DHCPHYVAL(0,"Inst",eobj.PHDDInstDr,0))
	s eobj.PHYVFeildDr=""
	if (PHYVRowId'=""){
		s pobjPhy = ##class(User.DHCPhysiologyVal).%OpenId(PHYVRowId)
		if $IsObject(pobjPhy.PHYVFeildDr){
			s eobj.PHYVFeildDr =pobjPhy.PHYVFeildDr.%Id() 
		}
		s eobj.PHYVMinVal=pobjPhy.PHYVMinVal
		s eobj.PHYVMaxVal=pobjPhy.PHYVMaxVal
		d pobjPhy.%Close()
	}
	;检验指标
	s LABIRowId=$o(^DHCLIBLABI(0,"Inst",eobj.PHDDInstDr,0))
		if (LABIRowId'=""){ 
			s labobj = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
			s:labobj.LABILabDr'="" eobj.LABILabDr=labobj.LABILabDr.%Id()
			s eobj.LABIMinVal=labobj.LABIMinVal
			s eobj.LABIMaxVal=labobj.LABIMaxVal
			s:labobj.LABIUomDr'="" eobj.LABIUomDr=labobj.LABIUomDr.%Id()	
			d labobj.%Close()
		}

	d pobjIns.%Close()

	s str = eobj.JsonS()
	s str = "{data:["_str_"]}"
	q str
}

/// Description：保存禁忌症
/// Table：User.DHCPHDrugDisease
/// Input：web.Entity.KB.DHCECGDiseaseC 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCECGDiseaseC).SaveIndData()
ClassMethod SaveConData(eobj As web.Entity.KB.DHCECGDiseaseC) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//开始保存到主索引表
		Ts		   				
			s objIns=##class(User.DHCPHInstructions).%New()	
			s objIns.PHINSTMode=eobj.PHINSTMode						
			s objIns.PHINSTText=eobj.PHINSTText
			
			//主索引表必填项
			s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ELECTContr","U"),0))
			s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("ELECT","U"),0))	
			d objIns.PHINSTTypeDrSetObjectId(eobj.PHINSTTypeDr)		
			s objIns.PHINSTOrderNum=eobj.PHINSTOrderNum
			//d objIns.PHINSTGenDrSetObjectId(eobj.PHINSTGenDr)
			s objIns.PHINSTGenDr=eobj.PHINSTGenDr
			s objIns.PHINSTPointerDr=eobj.PHINSTPointerDr
			s objIns.PHINSTPointerType=eobj.PHINSTPointerType	
			d objIns.PHINSTLibDrSetObjectId(eobj.PHINSTLibDr)		
			s objIns.PHINSTActiveFlag=eobj.PHINSTActiveFlag
			s objIns.PHINSTSysFlag=eobj.PHINSTSysFlag
					
			s scIns=objIns.%Save()	
			d objIns.%Close()
			If $$$ISOK(scIns)
			{
				s Insid = objIns.%Id()
				d:eobj.PHDDRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","主索引表",Insid,eobj.PHINSTTypeDr,"A",eobj)
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
			
		//开始保存到病症业务表
		s dargs=eobj.PHDDDiseaDr
		if (dargs'=""){
			s PHDDDiseaDrs=""
			s dargsLen=$Length(dargs,",")
			for i=1:1:dargsLen
			{         
				s eobj.PHDDDiseaDr=$p(dargs,",",i)
				s PHDISLDiseaDesc=$p($g(^DHCPHDISL(eobj.PHDDDiseaDr)),"^",2) //病症描述
				s:PHDDDiseaDrs'="" PHDDDiseaDrs=PHDDDiseaDrs_"、"_PHDISLDiseaDesc	
				s:PHDDDiseaDrs="" PHDDDiseaDrs=PHDISLDiseaDesc
				
				s objDisea=##class(User.DHCPHDrugDisease).%New()				
				d objDisea.PHDDInstDrSetObjectId(Insid)         
				d objDisea.PHDDDiseaDrSetObjectId(eobj.PHDDDiseaDr)	
				s objDisea.PHDDMode = "C"			
				s scDis=objDisea.%Save()
				d objDisea.%Close()
				if $$$ISOK(scDis){		
					s diseaid=objDisea.%Id()
				}
				else
				{
					s result = "{success:'false',errorinfo:'"_$zconvert(scDis,"O","JS")_"'}"  //返回错误信息
				}
			}
			s eobj.PHDDDiseaDrs=PHDDDiseaDrs
		}
		//开始保存到检查结果业务表
		s eargs=eobj.PHDDExamDr
		if (eargs'=""){
			s PHDDExamDrs=""
			s eargsLen=$Length(eargs,",")
			for i=1:1:eargsLen
			{        
				s eobj.PHDDExamDr=$p(eargs,",",i)
				s ExaResult=$p($g(^DHCEXAMINE(eobj.PHDDExamDr)),"^",2) //检查结果描述
				s:PHDDExamDrs'="" PHDDExamDrs=PHDDExamDrs_"、"_ExaResult	
				s:PHDDExamDrs="" PHDDExamDrs=ExaResult
				
				s objExam=##class(User.DHCLibExaItm).%New()				
				d objExam.EXAIInstDrSetObjectId(Insid)         
				d objExam.EXAIExamDrSetObjectId(eobj.PHDDExamDr)	
				s:eobj.PHDDExamDr'="" $p(^DHCEXAMINE(eobj.PHDDExamDr),"^",6)="Y" //设置检查结果表数据池标识			
				s scExa=objExam.%Save()
				d objExam.%Close()
				if $$$ISOK(scExa){
					s examid=objExam.%Id()
				}
				else
				{
					s result = "{success:'false',errorinfo:'"_$zconvert(scExa,"O","JS")_"'}"  //返回错误信息
				}
			}
		}
		//开始保存到生理参数业务表
			s objPhy=##class(User.DHCPhysiologyVal).%New()
			d objPhy.PHYVInstDrSetObjectId(Insid)
			d objPhy.PHYVFeildDrSetObjectId(eobj.PHYVFeildDr)
			s objPhy.PHYVMinVal=eobj.PHYVMinVal
			s objPhy.PHYVMaxVal=eobj.PHYVMaxVal				
			s scPhy=objPhy.%Save()
		
			d objPhy.%Close()
			if $$$ISOK(scPhy){
				s phyId=objPhy.%Id()
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_$zconvert(scPhy,"O","JS")_"'}"  //返回错误信息
			}
			//检验指标业务表
			s labobj = ##class(User.DHCLibLabItm).%New()
			d labobj.LABILabDrSetObjectId(eobj.LABILabDr)
			s labobj.LABIMinVal=eobj.LABIMinVal
			s labobj.LABIMaxVal=eobj.LABIMaxVal
			d labobj.LABIUomDrSetObjectId(eobj.LABIUomDr)
			d labobj.LABIInstDrSetObjectId(Insid)
			s labsc=labobj.%Save()
			d labobj.%Close()
			If $$$ISOK(labsc){ 	
				s labid = labobj.%Id()
				s:eobj.LABILabDr'="" $p(^DHCPHEGEN(eobj.LABILabDr),"^",9)="Y" //设置检验项目通用名数据池标识
				s result = "{success:'true',id:'"_labid_"'}"  //返回RowId

			}
			else{	
				s result = "{success:'false',info:'"_$zconvert(labsc,"O","JS")_"_'}"    //返回错误信息
			}
		if (result["true")
		{
			Tc
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","心电项目编辑器-禁忌证",Insid,eobj.PHINSTText,"A",eobj)
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"
		}
			
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Description：修改禁忌症
/// Table：User.DHCPHDrugDisease
/// Input：web.Entity.KB.DHCECGDiseaseC 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCECGDiseaseC).SaveIndData()
ClassMethod UpdateConData(eobj As web.Entity.KB.DHCECGDiseaseC) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		Ts
		//日志
		s bobj = ##class(web.Entity.KB.DHCECGDiseaseC).%New()
		//修改病症业务表(先删除所有的病症)
		s OPHDDDiseaDrs=""
		s PHDDRowId=0
		for{
			s PHDDRowId=$o(^DHCPHDDIS("0","Inst",eobj.PHDDInstDr,PHDDRowId)) q:PHDDRowId=""
			s PHDDDiseaDr=$p($g(^DHCPHDDIS(PHDDRowId)),"^",3) //病症DR
			s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",2) //病症描述
			s:OPHDDDiseaDrs'="" OPHDDDiseaDrs=OPHDDDiseaDrs_"、"_PHDISLDiseaDesc	
			s:OPHDDDiseaDrs="" OPHDDDiseaDrs=PHDISLDiseaDesc
			//s scdrug=##class(User.DHCPHDrugDisease).%DeleteId(PHDDRowId)
		}
		s bobj.PHDDMode="C"
		s bobj.PHDDDiseaDrs=OPHDDDiseaDrs
		 //病症多选
		s dargs=eobj.PHDDDiseaDr
		if (dargs'=""){
			s PHDDDiseaDrs=""
			s dargsLen=$Length(dargs,",")
			for i=1:1:dargsLen
			{ 	               
				s eobj.PHDDDiseaDr=$p(dargs,",",i)
				s PHDISLDiseaDesc=$p($g(^DHCPHDISL(eobj.PHDDDiseaDr)),"^",2) //病症描述
				s:PHDDDiseaDrs'="" PHDDDiseaDrs=PHDDDiseaDrs_"、"_PHDISLDiseaDesc	
				s:PHDDDiseaDrs="" PHDDDiseaDrs=PHDISLDiseaDesc
				
				s obj=##class(User.DHCPHDrugDisease).%New()				
				d obj.PHDDInstDrSetObjectId(eobj.PHDDInstDr)        
				d obj.PHDDDiseaDrSetObjectId(eobj.PHDDDiseaDr)	
				s obj.PHDDMode = "C"				
				s scDis=obj.%Save()
				d obj.%Close()
				if $$$ISOK(scDis){			
					s diseaid=obj.%Id()
				}
				else
				{
					s result = "{success:'false',errorinfo:'"_$zconvert(scDis,"O","JS")_"'}"  //返回错误信息
				}
			}
			s:OPHDDDiseaDrs'="" PHDDDiseaDrs=OPHDDDiseaDrs_"、"_PHDDDiseaDrs	
			s:OPHDDDiseaDrs="" PHDDDiseaDrs=PHDDDiseaDrs
			s eobj.PHDDDiseaDrs=PHDDDiseaDrs
		}
		//修改检查结果业务表(先删除所有的检查结果)
		s OPHDDExamDrs=""
		s EXAIRowId=0
		for{
			s EXAIRowId=$o(^DHCLIBEXAI("0","Inst",eobj.PHDDInstDr,EXAIRowId)) q:EXAIRowId=""
			s EXAIExamDr=$p($g(^DHCLIBEXAI(EXAIRowId)),"^",2) //检查结果DR
			s ExaResult=$p($g(^DHCEXAMINE(EXAIExamDr)),"^",2) //检查结果描述
			s:OPHDDExamDrs'="" OPHDDExamDrs=OPHDDExamDrs_"、"_ExaResult	
			s:OPHDDExamDrs="" OPHDDExamDrs=ExaResult
			//s scexam=##class(User.DHCLibExaItm).%DeleteId(EXAIRowId)
		}
		s bobj.PHDDExamDrs=OPHDDExamDrs
		//检查结果多选
		s eargs=eobj.PHDDExamDr
		if (eargs'=""){
			s PHDDExamDrs=""
			s eargsLen=$Length(eargs,",")
			for i=1:1:eargsLen
			{              
				s eobj.PHDDExamDr=$p(eargs,",",i)
				s ExaResult=$p($g(^DHCEXAMINE(eobj.PHDDExamDr)),"^",2) //检查结果描述
				s:PHDDExamDrs'="" PHDDExamDrs=PHDDExamDrs_"、"_ExaResult	
				s:PHDDExamDrs="" PHDDExamDrs=ExaResult
				s objExam=##class(User.DHCLibExaItm).%New()				
				d objExam.EXAIInstDrSetObjectId(eobj.PHDDInstDr)         
				d objExam.EXAIExamDrSetObjectId(eobj.PHDDExamDr)				
				s scExa=objExam.%Save()
				d objExam.%Close()
				if $$$ISOK(scExa){
					s examid=objExam.%Id()
				}
				else
				{
					s result = "{success:'false',errorinfo:'"_$zconvert(scExa,"O","JS")_"'}"  //返回错误信息
				}
			}
			s:OPHDDExamDrs'="" PHDDExamDrs=OPHDDExamDrs_"、"_PHDDExamDrs	
			s:OPHDDExamDrs="" PHDDExamDrs=PHDDExamDrs
			s eobj.PHDDExamDrs=PHDDExamDrs
		}
		//修改主索引表		
		s objIns=##class(User.DHCPHInstructions).%OpenId(eobj.PHDDInstDr)
		s bobj.PHINSTMode=objIns.PHINSTMode   
		s bobj.PHINSTText=objIns.PHINSTText
		
		s:objIns.PHINSTTypeDr'="" bobj.PHINSTTypeDr=objIns.PHINSTTypeDr.%Id()
		s bobj.PHINSTOrderNum=objIns.PHINSTOrderNum 
		s bobj.PHINSTGenDr=objIns.PHINSTGenDr 
		s bobj.PHINSTPointerDr=objIns.PHINSTPointerDr
		s:objIns.PHINSTLibDr'="" bobj.PHINSTLibDr=objIns.PHINSTLibDr.%Id() 
		s bobj.PHINSTPointerType=objIns.PHINSTPointerType
		s bobj.PHINSTActiveFlag=objIns.PHINSTActiveFlag 
		s bobj.PHINSTSysFlag=objIns.PHINSTSysFlag 
		
		s objIns.PHINSTMode=eobj.PHINSTMode
		s objIns.PHINSTText=eobj.PHINSTText		
		s scIns=objIns.%Save()	
		d objIns.%Close()
		If $$$ISOK(scIns)
		{
			s Insid = objIns.%Id()
			//d:eobj.PHDDRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","主索引表",Insid,eobj.PHDDInstDr,"U",eobj,bobjIns)
		}
		else
		{
			s result = "{success:'false',errorinfo:'"_$zconvert(scIns,"O","JS")_"'}"  //返回错误信息
		}
	
		//修改生理参数业务表		
		//通过索引获取生理参数业务表DHC_PhysiologyVal的RowId——PHYVRowId
		s PHYVRowId=$o(^DHCPHYVAL(0,"Inst",eobj.PHDDInstDr,0))
		if (PHYVRowId'="")
		{
			s objPhy=##class(User.DHCPhysiologyVal).%OpenId(PHYVRowId)
			s:objPhy.PHYVFeildDr'="" bobj.PHYVFeildDr=objPhy.PHYVFeildDr.%Id()
			s bobj.PHYVMinVal=objPhy.PHYVMinVal
			s bobj.PHYVMaxVal=objPhy.PHYVMaxVal
			
		}
		else
		{
			s objPhy=##class(User.DHCPhysiologyVal).%New()
		}
		d objPhy.PHYVInstDrSetObjectId(eobj.PHDDInstDr)
		d objPhy.PHYVFeildDrSetObjectId(eobj.PHYVFeildDr)
		s objPhy.PHYVMinVal=eobj.PHYVMinVal
		s objPhy.PHYVMaxVal=eobj.PHYVMaxVal		
				
		s scPhy=objPhy.%Save()		
		d objPhy.%Close()
		if $$$ISOK(scPhy){
			s phyId=objPhy.%Id()
		}
		else
		{
			s result = "{success:'false',errorinfo:'"_$zconvert(scPhy,"O","JS")_"'}"  //返回错误信息
		}	
					
		
		;检验指标
		s LABIRowId=$o(^DHCLIBLABI(0,"Inst",eobj.PHDDInstDr,0))
		if (LABIRowId'="")
		{ 
			s labobj = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
			s:labobj.LABILabDr'="" bobj.LABILabDr=labobj.LABILabDr.%Id()
			s bobj.LABIMinVal=labobj.LABIMinVal
			s bobj.LABIMaxVal=labobj.LABIMaxVal
			s:labobj.LABIUomDr'="" bobj.LABIUomDr=labobj.LABIUomDr.%Id()
		}
		else
		{
			s labobj = ##class(User.DHCLibLabItm).%New()
		}
				
		d:eobj.LABILabDr'="" labobj.LABILabDrSetObjectId(eobj.LABILabDr)
		s labobj.LABIMinVal=eobj.LABIMinVal
		s labobj.LABIMaxVal=eobj.LABIMaxVal
		d:eobj.LABIUomDr'="" labobj.LABIUomDrSetObjectId(eobj.LABIUomDr)
		d labobj.LABIInstDrSetObjectId(eobj.PHDDInstDr)

		s labsc=labobj.%Save()
		d labobj.%Close()
		If $$$ISOK(labsc){ 	
			s labid = labobj.%Id()
			s result = "{success:'true',id:'"_labid_"'}"  //返回RowId
		}
		else{	
			s result = "{success:'false',info:'"_$zconvert(labsc,"O","JS")_"_'}"    //返回错误信息
		}
	
		if (result["true")
		{
			Tc
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","心电项目编辑器-禁忌症",Insid,eobj.PHINSTText,"U",eobj,bobj)
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"
		}
			
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator：谷雪萍
/// CreatDate: 2014-12-4
/// Description：查询病症业务表内容
/// Input：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCECGDiseaseC","GetList","")
Query GetListCon(TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,PHDDRowId,PHINSTText,PHYVFeildDr,PHYFDesc,PHYVMinVal,PHYVMaxVal,LABILabDr,PHLFDesc,LABIMaxVal,LABIMinVal,LABIUomDr,PHEUDesc")
{
}

ClassMethod GetListConExecute(ByRef qHandle As %Binary, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
		s PHINSTRowId=0
		for
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ELECTContr","U"),0))
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PHINSTRowId)) q:PHINSTRowId=""	
				
				//主索引表^DHCPHINSTRUC
				s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
				s PHDDRowId=$o(^DHCPHDDIS("0","Inst",PHINSTRowId,0))

				//生理参数业务表^DHCPHYVAL
				s PHYVRowId=$o(^DHCPHYVAL("0","Inst",PHINSTRowId,0))
				s PHYVFeildDr=""
				s:PHYVRowId'="" PHYVFeildDr=$p($g(^DHCPHYVAL(PHYVRowId)),"^",2)
				s:PHYVFeildDr'="" PHYFDesc=$p($g(^DHCPHYSIF(PHYVFeildDr)),"^",2)
				s:PHYVRowId'="" PHYVMaxVal=$p($g(^DHCPHYVAL(PHYVRowId)),"^",4)
				s:PHYVRowId'="" PHYVMinVal=$p($g(^DHCPHYVAL(PHYVRowId)),"^",5)
				
				//检验指标
				s LABIRowId=$o(^DHCLIBLABI("0","Inst",PHINSTRowId,0))
				s LABILabDr="",PHLFDesc="",LABIMaxVal="",LABIMinVal="",LABIUomDr="",PHEUDesc=""
				if (LABIRowId'="")
				{
					s LABILabDr = $p($g(^DHCLIBLABI(LABIRowId)),"^",2)
					s:LABILabDr'="" PHLFDesc=$p($g(^DHCLABIF(LABILabDr)),"^",2)
					s LABIMaxVal = $p($g(^DHCLIBLABI(LABIRowId)),"^",3)
					s LABIMinVal = $p($g(^DHCLIBLABI(LABIRowId)),"^",4)
					s LABIUomDr = $p($g(^DHCLIBLABI(LABIRowId)),"^",5)
					s:LABIUomDr'="" PHEUDesc=$p($g(^DHCPHEUO(LABIUomDr)),"^",2)
				}
				d OutputRow
				
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHINSTRowId,PHDDRowId,PHINSTText,PHYVFeildDr,PHYFDesc,PHYVMinVal,PHYVMaxVal,LABILabDr,PHLFDesc,LABIMaxVal,LABIMinVal,LABIUomDr,PHEUDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListConClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListConExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListConFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListConExecute ]
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

/// Description:根据id删除 病症业务表
/// Table:User.DHCPHDrugDisease
/// Input:id 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.KB.DHCECGDiseaseC).DeleteConData("112")
ClassMethod DeleteConData(id As %String) As %String
{
		s result=""	
		TS
		//日志
		s bobj = ##class(web.Entity.KB.DHCECGDiseaseC).%New()
		//删除病症业务表
		s OPHDDDiseaDrs=""
		s PHDDRowId=0
		for{
			s PHDDRowId=$o(^DHCPHDDIS("0","Inst",id,PHDDRowId)) q:PHDDRowId=""	
			s PHDDDiseaDr=$p($g(^DHCPHDDIS(PHDDRowId)),"^",3) //病症DR
			s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",2) //病症描述
			s:OPHDDDiseaDrs'="" OPHDDDiseaDrs=OPHDDDiseaDrs_"、"_PHDISLDiseaDesc	
			s:OPHDDDiseaDrs="" OPHDDDiseaDrs=PHDISLDiseaDesc		
			s sc=##class(User.DHCPHDrugDisease).%DeleteId(PHDDRowId)
			if $$$ISOK(sc){
				s result="{success:'true',info:'删除成功！'}"
			}
			else{
				s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
		}
		s bobj.PHDDDiseaDrs=OPHDDDiseaDrs
		//删除检查结果业务表
		s OPHDDExamDrs=""
		s EXAIRowId=0
		for{
			s EXAIRowId=$o(^DHCLIBEXAI("0","Inst",id,EXAIRowId)) q:EXAIRowId=""	
			s EXAIExamDr=$p($g(^DHCLIBEXAI(EXAIRowId)),"^",2) //检查结果DR
			s ExaResult=$p($g(^DHCEXAMINE(EXAIExamDr)),"^",2) //检查结果描述
			s:OPHDDExamDrs'="" OPHDDExamDrs=OPHDDExamDrs_"、"_ExaResult	
			s:OPHDDExamDrs="" OPHDDExamDrs=ExaResult			
			s scexam=##class(User.DHCLibExaItm).%DeleteId(EXAIRowId)
			if $$$ISOK(scexam){
				s result="{success:'true',info:'删除成功！'}"
			}
			else{
				s result= "{success:'false',info:'"_$zconvert(scexam,"O","JS")_"'}"  //返回错误信息
			}
		}
		s bobj.PHDDExamDrs=OPHDDExamDrs
		
		//删除主索引表		
		s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
		s bobj.PHINSTMode=pobjIns.PHINSTMode
		s bobj.PHINSTText=pobjIns.PHINSTText
		if $IsObject(pobjIns.PHINSTTypeDr){
			 s bobj.PHINSTTypeDr=pobjIns.PHINSTTypeDr.%Id()
		}
		/*if $IsObject(pobjIns.PHINSTGenDr){
			s eobjIns.PHINSTGenDr=pobjIns.PHINSTGenDr.%Id()
		}*/
		s bobj.PHINSTGenDr=pobjIns.PHINSTGenDr
		if $IsObject(pobjIns.PHINSTLibDr){
			s bobj.PHINSTLibDr=pobjIns.PHINSTLibDr.%Id()
		}		
		s bobj.PHINSTActiveFlag=pobjIns.PHINSTActiveFlag
		s bobj.PHINSTOrderNum=pobjIns.PHINSTOrderNum
		s bobj.PHINSTPointerDr=pobjIns.PHINSTPointerDr
		s bobj.PHINSTPointerType=pobjIns.PHINSTPointerType
		s bobj.PHINSTSysFlag=pobjIns.PHINSTSysFlag
		
		s scInst=##class(User.DHCPHInstructions).%DeleteId(id)
		if $$$ISOK(scInst){
			//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","主索引表",id,eobjIns.PHINSTTypeDr,"D",eobjIns)
		}
		else{
			s result= "{success:'false',info:'"_$zconvert(scInst,"O","JS")_"'}"  //返回错误信息
		}
		//删除生理参数业务表
		s PHYVRowId=$o(^DHCPHYVAL("0","Inst",id,0))	
		if (PHYVRowId'=""){
			s objPhy=##class(User.DHCPhysiologyVal).%OpenId(PHYVRowId)
			s:objPhy.PHYVFeildDr'="" bobj.PHYVFeildDr=objPhy.PHYVFeildDr.%Id()
			s bobj.PHYVMinVal=objPhy.PHYVMinVal
			s bobj.PHYVMaxVal=objPhy.PHYVMaxVal
			
			s scPhy=##class(User.DHCPhysiologyVal).%DeleteId(PHYVRowId)
			if $$$ISOK(scPhy){
				s result="{success:'true',info:'删除成功！'}"
			}
			else{
				s result= "{success:'false',info:'"_$zconvert(scPhy,"O","JS")_"'}"  //返回错误信息
			}
		}
		//删除检验指标业务表
		s LABIRowId=$o(^DHCLIBLABI(0,"Inst",id,0))
		if (LABIRowId'=""){
			s labobj = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
			s:labobj.LABILabDr'="" bobj.LABILabDr=labobj.LABILabDr.%Id()
			s bobj.LABIMinVal=labobj.LABIMinVal
			s bobj.LABIMaxVal=labobj.LABIMaxVal
			s:labobj.LABIUomDr'="" bobj.LABIUomDr=labobj.LABIUomDr.%Id()
			
			s scLab=##class(User.DHCLibLabItm).%DeleteId(LABIRowId)
			if $$$ISOK(scLab){
				s result="{success:'true',info:'删除成功！'}"
			}
			else{
				s result= "{success:'false',info:'"_$zconvert(scLab,"O","JS")_"'}"  //返回错误信息
			}
		}
		if (result["true")
		{
			Tc
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","心电项目编辑器-禁忌证",id,bobj.PHINSTText,"D",bobj)
		}
		else
		{
			Trollback
			s result = "{success:'false',info:'删除失败！'}"
		}
		q result
}

/// Description：根据主索引的id获取禁忌症数据
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCECGDiseaseC).GetConData("7")
ClassMethod GetConData(InstId As %String) As %String
{
		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

}
