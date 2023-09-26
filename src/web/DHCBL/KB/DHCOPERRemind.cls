Import SQLUser

/// 名称: 高危提醒维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-高姗姗
/// 编写日期: 2017-4-11
Class web.DHCBL.KB.DHCOPERRemind Extends %RegisteredObject
{

/// Description：打开高危提醒数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCOPERRemind).OpenRemindData("11731")
ClassMethod OpenRemindData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCOPERRemind).%New()
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTText=pobjIns.PHINSTText
	s eobj.PHINSTBMIMin=pobjIns.PHINSTBMIMin
	s eobj.PHINSTBMIMax=pobjIns.PHINSTBMIMax
	
	//通过索引获取年龄业务表的RowId——PDARowId
	s PDARowId=$o(^DHCPHDISAGE(0,"Inst",id,0))
	s eobj.PDAAgeDr=""
	if (PDARowId'="")
	{
		s pobjAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
		if $IsObject(pobjAge.PDAAgeDr)
		{
			s eobj.PDAAgeDr =pobjAge.PDAAgeDr.%Id() 
		}
		s eobj.PDAMaxVal=pobjAge.PDAMaxVal
		s eobj.PDAMinVal=pobjAge.PDAMinVal
		if $IsObject(pobjAge.PDAUomDr)
		{
			s eobj.PDAUomDr = pobjAge.PDAUomDr.%Id() 
		}
		d pobjAge.%Close()
		k pobjAge
	}
	//通过索引获取生理业务表的RowId——PHYVRowId
	s PHYVRowId=0
	for {
		s PHYVRowId=$o(^DHCPHYVAL(0,"Inst",id,PHYVRowId)) q:PHYVRowId="" 
		s objPhy=##class(User.DHCPhysiologyVal).%OpenId(PHYVRowId)
		if (objPhy.PHYVType="S")
		{
			s eobj.SysPressMinVal=objPhy.PHYVMinVal
			s eobj.SysPressMaxVal=objPhy.PHYVMaxVal
				
			d objPhy.%Close()
			k objPhy			
		}
		else
		{
			s eobj.DiaPressMinVal=objPhy.PHYVMinVal
			s eobj.DiaPressMaxVal=objPhy.PHYVMaxVal
			
			d objPhy.%Close()
			k objPhy		
		}
	}
		
	;病症
	s PHDDRowId=0
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",id,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		if (PHDDDiseaDr'="") 
		{
			if (eobj.PHDDDiseaDr'="")
			{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_","_eobj.PHDDDiseaDr
			}
			else
			{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		} 
	}

	;特殊人群
	s SPEPIRowId=0
	for
	{
		s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",id,SPEPIRowId)) q:SPEPIRowId=""
		//s eobj.SpecialPopu=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)_"^"_eobj.SpecialPopu
		s SPEPISpecDr=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)
		s:SPEPISpecDr'="" eobj.SpecialPopu=$p(^DHCSPEP(SPEPISpecDr),"^",2)_","_eobj.SpecialPopu		
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存高危提醒
/// Table：User.DHCPHDrugDisease
/// Input：web.Entity.KB.DHCOPERRemind 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCOPERRemind).SaveRemindData()
ClassMethod SaveRemindData(eobj As web.Entity.KB.DHCOPERRemind) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//开始保存到主索引表
		Ts		   				
		s objIns=##class(User.DHCPHInstructions).%New()	
		s objIns.PHINSTMode=eobj.PHINSTMode						
		s objIns.PHINSTText=eobj.PHINSTText
		s objIns.PHINSTBMIMin=eobj.PHINSTBMIMin
		s objIns.PHINSTBMIMax=eobj.PHINSTBMIMax		

		//主索引表必填项
		s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("OPERRemind","U"),0))
		s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("OPERATION","U"),0))
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
		}
		else
		{	
			s result = "{success:'false',errorinfo:'"_$zconvert(scIns,"O","JS")_"'}"  //返回错误信息
		}
			
		//开始保存到病症业务表
		s args=eobj.PHDDDiseaDr
		if (args'="")
		{
			s PHDDDiseaDrs=""
			s argsLen=$Length(args,",")
			for i=1:1:argsLen
			{
	                  
				s eobj.PHDDDiseaDr=$p(args,",",i)
				s PHDISLDiseaDesc=$p($g(^DHCPHDISL(eobj.PHDDDiseaDr)),"^",2) //病症描述
				s:PHDDDiseaDrs'="" PHDDDiseaDrs=PHDDDiseaDrs_"、"_PHDISLDiseaDesc	
				s:PHDDDiseaDrs="" PHDDDiseaDrs=PHDISLDiseaDesc
				
				s obj=##class(User.DHCPHDrugDisease).%New()				
				s eobj.PHDDInstDr=Insid
				d obj.PHDDInstDrSetObjectId(eobj.PHDDInstDr)      
				d obj.PHDDDiseaDrSetObjectId(eobj.PHDDDiseaDr)				
				s scDis=obj.%Save()
				d obj.%Close()
				if $$$ISOK(scDis)
				{
					s id=obj.%Id()
				}
				else
				{
					s result = "{success:'false',errorinfo:'"_$zconvert(scDis,"O","JS")_"'}"  //返回错误信息
				}
			}
			s eobj.PHDDDiseaDrs=PHDDDiseaDrs
		}
		//开始保存到年龄业务表
	
		s objAge=##class(User.DHCPHDiseaseAge).%New()
		d objAge.PDAInstDrSetObjectId(Insid)
		d objAge.PDAAgeDrSetObjectId(eobj.PDAAgeDr)
		s objAge.PDAMinVal=eobj.PDAMinVal
		s objAge.PDAMaxVal=eobj.PDAMaxVal
		d objAge.PDAUomDrSetObjectId(eobj.PDAUomDr)
		;年龄业务表json
		//s logJsonAge="{PDAInstDr:"_$c(34)_Insid_$C(34)_",PDAAgeDr:"_$C(34)_eobj.PDAAgeDr_$C(34)_"}"				
		s scAge=objAge.%Save()		
		d objAge.%Close()
		if $$$ISOK(scAge)
		{			
			s ageId=objAge.%Id()
		}
		else
		{			
			s result = "{success:'false',errorinfo:'"_$zconvert(scAge,"O","JS")_"'}"  //返回错误信息
		}
		//开始保存到特殊人群业务表
		s argPopu=eobj.SpecialPopu
		if (argPopu'="")
		{
			s SPEPISpecDrs=""
			s popuLen=$Length(argPopu,",")
			for i=1:1:popuLen
			{
				s eobj.SpecialPopu=$p(argPopu,",",i)
				s SPEDesc=$p($g(^DHCSPEP(eobj.SpecialPopu)),"^",2) //特殊人群描述
				s:SPEPISpecDrs'="" SPEPISpecDrs=SPEPISpecDrs_"、"_SPEDesc	
				s:SPEPISpecDrs="" SPEPISpecDrs=SPEDesc
				
				s popuobj = ##class(User.DHCLibSpecPopuItm).%New() 
				d popuobj.SPEPIInstDrSetObjectId(Insid)
				d popuobj.SPEPISpecDrSetObjectId(eobj.SpecialPopu)
							
				s scPopu=popuobj.%Save()
		
				d popuobj.%Close()
				if $$$ISOK(scPopu)
				{
					s popuId=popuobj.%Id()
				}
				else
				{
					s result = "{success:'false',errorinfo:'"_$zconvert(scPopu,"O","JS")_"'}"  //返回错误信息
				}
			}
			s eobj.SPEPISpecDrs=SPEPISpecDrs
		}
		
		//开始保存到生理参数业务表（收缩压）
		s objPhySys=##class(User.DHCPhysiologyVal).%New()
		d objPhySys.PHYVInstDrSetObjectId(Insid)
		s objPhySys.PHYVType="S"
		s objPhySys.PHYVMinVal=eobj.SysPressMinVal
		s objPhySys.PHYVMaxVal=eobj.SysPressMaxVal		
		s scPhySys=objPhySys.%Save()
		if $$$ISOK(scPhySys)
		{

			s phySysId=objPhySys.%Id()
		}
		else
		{
			s result ="false"
		}
						
		//开始保存到生理参数业务表（舒张压）
		s objPhyDia=##class(User.DHCPhysiologyVal).%New()
		d objPhyDia.PHYVInstDrSetObjectId(Insid)
		s objPhyDia.PHYVType="D"
		s objPhyDia.PHYVMinVal=eobj.DiaPressMinVal
		s objPhyDia.PHYVMaxVal=eobj.DiaPressMaxVal
		
				
		s scPhyDia=objPhyDia.%Save()
		if $$$ISOK(scPhyDia)
		{

			s phyDiaId=objPhyDia.%Id()
		}
		else
		{
			s result ="false"
		}
		
		
		if (result["false")
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"
		}
		else
		{
			Tc
			s result = "{success:'true',id:'"_Insid_"'}" //返回RowId
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","手术项目编辑器-高危提醒",Insid,eobj.PHINSTText,"A",eobj)
		}
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Description：修改高危提醒
/// Table：User.DHCPHDrugDisease
/// Input：web.Entity.KB.DHCOPERRemind 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCOPERRemind).SaveRemindData()
ClassMethod UpdateRemindData(eobj As web.Entity.KB.DHCOPERRemind) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		TS
		//日志
		s bobj = ##class(web.Entity.KB.DHCOPERRemind).%New()
		
		s PHDDInstDr=eobj.PHDDInstDr
		//修改病症业务表(先删除所有的病症)
		s OPHDDDiseaDrs=""
		s PHDDRowId=0
		for
		{
			s PHDDRowId=$o(^DHCPHDDIS("0","Inst",PHDDInstDr,PHDDRowId)) q:PHDDRowId=""
			s PHDDDiseaDr=$p($g(^DHCPHDDIS(PHDDRowId)),"^",3) //病症DR
			s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",2) //病症描述
			s:OPHDDDiseaDrs'="" OPHDDDiseaDrs=OPHDDDiseaDrs_"、"_PHDISLDiseaDesc	
			s:OPHDDDiseaDrs="" OPHDDDiseaDrs=PHDISLDiseaDesc
			//s scdrug=##class(User.DHCPHDrugDisease).%DeleteId(PHDDRowId)
		}
		s bobj.PHDDDiseaDrs=OPHDDDiseaDrs
		 //病症多选
		s args=eobj.PHDDDiseaDr
		if (args'="")
		{
			s PHDDDiseaDrs=""
			s argsLen=$Length(args,",")
			for i=1:1:argsLen
			{ 
		               
				s eobj.PHDDDiseaDr=$p(args,",",i)
				s PHDISLDiseaDesc=$p($g(^DHCPHDISL(eobj.PHDDDiseaDr)),"^",2) //病症描述
				s:PHDDDiseaDrs'="" PHDDDiseaDrs=PHDDDiseaDrs_"、"_PHDISLDiseaDesc	
				s:PHDDDiseaDrs="" PHDDDiseaDrs=PHDISLDiseaDesc
				
				s obj=##class(User.DHCPHDrugDisease).%New()				
				s eobj.PHDDInstDr=PHDDInstDr
				d obj.PHDDInstDrSetObjectId(eobj.PHDDInstDr)      
				d obj.PHDDDiseaDrSetObjectId(eobj.PHDDDiseaDr)				
				s scDis=obj.%Save()
				d obj.%Close()
				if $$$ISOK(scDis)
				{			
					s id=obj.%Id()
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
		//修改特殊人群业务表(先删除)
		s OSPEPISpecDrs=""
		s SPEPIRowId=0
		for
		{
			s SPEPIRowId=$o(^DHCLIBSPEPI("0","Inst",PHDDInstDr,SPEPIRowId)) q:SPEPIRowId=""
			s SPEPISpecDr=$p($g(^DHCLIBSPEPI(SPEPIRowId)),"^",2) //特殊人群DR
			s SPEDesc=$p($g(^DHCSPEP(SPEPISpecDr)),"^",2) //特殊人群描述
			s:OSPEPISpecDrs'="" OSPEPISpecDrs=OSPEPISpecDrs_"、"_SPEDesc	
			s:OSPEPISpecDrs="" OSPEPISpecDrs=SPEDesc
			//s scPopu=##class(User.DHCLibSpecPopuItm).%DeleteId(SPEPIRowId)
		}
		s bobj.SPEPISpecDrs=OSPEPISpecDrs
		
		//开始保存到特殊人群业务表
		s argPopu=eobj.SpecialPopu
		if (argPopu'="")
		{
			s SPEPISpecDrs=""
			s popuLen=$Length(argPopu,",")
			for i=1:1:popuLen
			{
				s eobj.SpecialPopu=$p(argPopu,",",i)
				s SPEDesc=$p($g(^DHCSPEP(eobj.SpecialPopu)),"^",2) //特殊人群描述
				s:SPEPISpecDrs'="" SPEPISpecDrs=SPEPISpecDrs_"、"_SPEDesc	
				s:SPEPISpecDrs="" SPEPISpecDrs=SPEDesc
				
				s popuobj = ##class(User.DHCLibSpecPopuItm).%New() 
				d popuobj.SPEPIInstDrSetObjectId(PHDDInstDr)
				d popuobj.SPEPISpecDrSetObjectId(eobj.SpecialPopu)
							
				s scPopu=popuobj.%Save()
		
				d popuobj.%Close()
				if $$$ISOK(scPopu)
				{
					s popuId=popuobj.%Id()
				}
				else
				{
					s result = "{success:'false',errorinfo:'"_$zconvert(scPopu,"O","JS")_"'}"  //返回错误信息
				}
			}
			s:OSPEPISpecDrs'="" SPEPISpecDrs=OSPEPISpecDrs_"、"_SPEPISpecDrs	
			s:OSPEPISpecDrs="" SPEPISpecDrs=SPEPISpecDrs
			s eobj.SPEPISpecDrs=SPEPISpecDrs
		}
		
		//修改主索引表
				
		s objIns=##class(User.DHCPHInstructions).%OpenId(PHDDInstDr)
		s bobj.PHINSTMode=objIns.PHINSTMode
		s bobj.PHINSTText=objIns.PHINSTText 
		s bobj.PHINSTBMIMin=objIns.PHINSTBMIMin 
		s bobj.PHINSTBMIMax=objIns.PHINSTBMIMax
		
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
		s objIns.PHINSTBMIMin=eobj.PHINSTBMIMin	
		s objIns.PHINSTBMIMax=eobj.PHINSTBMIMax	
		s scIns=objIns.%Save()	
		d objIns.%Close()
		If $$$ISOK(scIns)
		{
			s Insid = objIns.%Id()
		}
		else
		{
			s result = "{success:'false',errorinfo:'"_$zconvert(scIns,"O","JS")_"'}"  //返回错误信息
		}
	//修改年龄业务表
	
		//通过索引获取年龄业务表的RowId——PDARowId
		s PDARowId=$o(^DHCPHDISAGE(0,"Inst",PHDDInstDr,0))
		if (PDARowId'="")
		{
			s objAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
			s:objAge.PDAAgeDr'="" bobj.PDAAgeDr=objAge.PDAAgeDr.%Id()
			s bobj.PDAMinVal=objAge.PDAMinVal
			s bobj.PDAMaxVal=objAge.PDAMaxVal
			s:objAge.PDAUomDr'="" bobj.PDAUomDr=objAge.PDAUomDr.%Id()
		}
		else
		{
			s objAge = ##class(User.DHCPHDiseaseAge).%New()
		}
		d objAge.PDAInstDrSetObjectId(PHDDInstDr)		
		d objAge.PDAAgeDrSetObjectId(eobj.PDAAgeDr)
		s objAge.PDAMaxVal=eobj.PDAMaxVal
		s objAge.PDAMinVal=eobj.PDAMinVal
		d objAge.PDAUomDrSetObjectId(eobj.PDAUomDr)
		s scAge=objAge.%Save()
		d objAge.%Close()
	
		if $$$ISOK(scAge)
		{
			s ageId=objAge.%Id()
		}
		else
		{
			s result = "{success:'false',errorinfo:'"_$zconvert(scAge,"O","JS")_"'}"  //返回错误信息
		}
		
		//修改生理参数业务表		
		//通过索引获取生理参数业务表DHC_PhysiologyVal的RowId——PHYVRowId
		s PHYVRowId=0,flag=0  //flag标志是否已经有生理参数 处理历史数据的新增问题
		for {
			s PHYVRowId=$o(^DHCPHYVAL(0,"Inst",PHDDInstDr,PHYVRowId)) q:PHYVRowId=""
			s flag=1
			s objPhy=##class(User.DHCPhysiologyVal).%OpenId(PHYVRowId)
			if (objPhy.PHYVType="S")
			{
				s bobj.SysPressMinVal=objPhy.PHYVMinVal
				s bobj.SysPressMaxVal=objPhy.PHYVMaxVal
				
				s objPhy.PHYVMinVal=eobj.SysPressMinVal
				s objPhy.PHYVMaxVal=eobj.SysPressMaxVal	
				
				s scPhy=objPhy.%Save()		
				d objPhy.%Close()
				if $$$ISOK(scPhy)
				{
					s phyId=objPhy.%Id()
				}
				else
				{

					s result ="false"
				}				
			}
			else
			{
				s bobj.DiaPressMinVal=objPhy.PHYVMinVal
				s bobj.DiaPressMaxVal=objPhy.PHYVMaxVal
				
				s objPhy.PHYVMinVal=eobj.DiaPressMinVal
				s objPhy.PHYVMaxVal=eobj.DiaPressMaxVal	
				
				s scPhy1=objPhy.%Save()		
				d objPhy.%Close()
				if $$$ISOK(scPhy1)
				{
					s phyId1=objPhy.%Id()
				}
				else
				{

					s result ="false"
				}			
			}
			
		}
			
		if (flag=0)&((eobj.SysPressMinVal'="")||(eobj.SysPressMaxVal)||(eobj.DiaPressMinVal'="")||(eobj.DiaPressMinVal))
		{
			//开始保存到生理参数业务表（收缩压）
			s objPhySys=##class(User.DHCPhysiologyVal).%New()
			d objPhySys.PHYVInstDrSetObjectId(Insid)
			s objPhySys.PHYVType="S"
			s objPhySys.PHYVMinVal=eobj.SysPressMinVal
			s objPhySys.PHYVMaxVal=eobj.SysPressMaxVal		
			s scPhySys=objPhySys.%Save()
			if $$$ISOK(scPhySys)
			{

				s phySysId=objPhySys.%Id()
			}
			else
			{
				s result ="false"
			}
			//开始保存到生理参数业务表（舒张压）
			s objPhyDia=##class(User.DHCPhysiologyVal).%New()
			d objPhyDia.PHYVInstDrSetObjectId(Insid)
			s objPhyDia.PHYVType="D"
			s objPhyDia.PHYVMinVal=eobj.DiaPressMinVal
			s objPhyDia.PHYVMaxVal=eobj.DiaPressMaxVal
			
					
			s scPhyDia=objPhyDia.%Save()
			if $$$ISOK(scPhyDia)
			{

				s phyDiaId=objPhyDia.%Id()
			}
			else
			{
				s result ="false"
			}
		}
		if (result["false")
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"
			
		}
		else
		{
			Tc
			s result = "{success:'true',id:'"_PHDDInstDr_"'}" //返回RowId
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","手术项目编辑器-高危提醒",PHDDInstDr,eobj.PHINSTText,"U",eobj,bobj)

		}
			
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2017-4-11
/// Description：查询高危提醒内容
/// Input：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCOPERRemind","GetList","","","124","Form","2")
Query GetList(rowid, TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,PHINSTText")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("OPERRemind","U"),0))
	s PHINSTRowId=0
	for
	{
		s PHINSTRowId=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PHINSTRowId)) q:PHINSTRowId=""	
		s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
		d OutputRow
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHINSTRowId,PHINSTText)
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

/// Description:根据id删除 高危提醒业务表
/// Table:User.DHCPHDrugDisease
/// Input:id 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.KB.DHCOPERRemind).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
		s result=""
		TS
		//日志
		s bobj = ##class(web.Entity.KB.DHCOPERRemind).%New()	
		//删除病症业务表
		s OPHDDDiseaDrs=""
		s PHDDRowId=0
		for
		{
			s PHDDRowId=$o(^DHCPHDDIS("0","Inst",id,PHDDRowId)) q:PHDDRowId=""
			s PHDDDiseaDr=$p($g(^DHCPHDDIS(PHDDRowId)),"^",3) //病症DR
			s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",2) //病症描述
			s:OPHDDDiseaDrs'="" OPHDDDiseaDrs=OPHDDDiseaDrs_"、"_PHDISLDiseaDesc	
			s:OPHDDDiseaDrs="" OPHDDDiseaDrs=PHDISLDiseaDesc			
			s sc=##class(User.DHCPHDrugDisease).%DeleteId(PHDDRowId)
			if '$$$ISOK(sc)
			{
				s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
		}
		s bobj.PHDDDiseaDrs=OPHDDDiseaDrs
		//删除主索引表			
		s objIns=##class(User.DHCPHInstructions).%OpenId(id)
		s bobj.PHINSTText=objIns.PHINSTText 
		s bobj.PHINSTBMIMin=objIns.PHINSTBMIMin 
		s bobj.PHINSTBMIMax=objIns.PHINSTBMIMax
		
		s:objIns.PHINSTTypeDr'="" bobj.PHINSTTypeDr=objIns.PHINSTTypeDr.%Id()
		s bobj.PHINSTOrderNum=objIns.PHINSTOrderNum 
		s bobj.PHINSTGenDr=objIns.PHINSTGenDr 
		s bobj.PHINSTPointerDr=objIns.PHINSTPointerDr
		s:objIns.PHINSTLibDr'="" bobj.PHINSTLibDr=objIns.PHINSTLibDr.%Id() 
		s bobj.PHINSTPointerType=objIns.PHINSTPointerType
		s bobj.PHINSTActiveFlag=objIns.PHINSTActiveFlag 
		s bobj.PHINSTSysFlag=objIns.PHINSTSysFlag 
		
		s scInst=##class(User.DHCPHInstructions).%DeleteId(id)
		if '$$$ISOK(scInst)
		{
			s result= "{success:'false',info:'"_$zconvert(scInst,"O","JS")_"'}"  //返回错误信息
		}
		//删除年龄业务表
		s PDARowId=$o(^DHCPHDISAGE("0","Inst",id,0))
		if (PDARowId'="")
		{
			s objAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
			s:objAge.PDAAgeDr'="" bobj.PDAAgeDr=objAge.PDAAgeDr.%Id()
			s bobj.PDAMinVal=objAge.PDAMinVal
			s bobj.PDAMaxVal=objAge.PDAMaxVal
			s:objAge.PDAUomDr'="" bobj.PDAUomDr=objAge.PDAUomDr.%Id()
			
			s scAge=##class(User.DHCPHDiseaseAge).%DeleteId(PDARowId)
			if '$$$ISOK(scAge)
			{
				s result= "{success:'false',info:'"_$zconvert(scAge,"O","JS")_"'}"  //返回错误信息
			}
		}
		//删除特殊人群业务表
		s OSPEPISpecDrs=""
		s SPEPIRowId=0
		for
		{
			s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",id,SPEPIRowId)) q:SPEPIRowId=""
			s SPEPISpecDr=$p($g(^DHCLIBSPEPI(SPEPIRowId)),"^",2) //特殊人群DR	
			s SPEDesc=$p($g(^DHCSPEP(SPEPISpecDr)),"^",2) //特殊人群描述
			s:OSPEPISpecDrs'="" OSPEPISpecDrs=OSPEPISpecDrs_"、"_SPEDesc	
			s:OSPEPISpecDrs="" OSPEPISpecDrs=SPEDesc
			s scPopu=##class(User.DHCLibSpecPopuItm).%DeleteId(SPEPIRowId)
			if '$$$ISOK(scPopu)
			{
				s result= "{success:'false',info:'"_$zconvert(scPopu,"O","JS")_"'}"  //返回错误信息
			}
		}
		s PHYVRowId=0
		for {
			s PHYVRowId=$o(^DHCPHYVAL(0,"Inst",id,PHYVRowId)) q:PHYVRowId="" 
			s objPhy=##class(User.DHCPhysiologyVal).%OpenId(PHYVRowId)
			if (objPhy.PHYVType="S")
			{
				s bobj.SysPressMinVal=objPhy.PHYVMinVal
				s bobj.SysPressMaxVal=objPhy.PHYVMaxVal
				s scPhy=##class(User.DHCPhysiologyVal).%DeleteId(PHYVRowId)
				if '$$$ISOK(scPhy)
				{
					s result= "{success:'false',info:'"_$zconvert(scPhy,"O","JS")_"'}"  //返回错误信息
				}			
			}
			else
			{
				s bobj.DiaPressMinVal=objPhy.PHYVMinVal
				s bobj.DiaPressMaxVal=objPhy.PHYVMaxVal
				
				s scPhy1=##class(User.DHCPhysiologyVal).%DeleteId(PHYVRowId)
				if '$$$ISOK(scPhy1)
				{
					s result= "{success:'false',info:'"_$zconvert(scPhy,"O","JS")_"'}"  //返回错误信息
				}			
			}
		}
	
		if (result["false")
		{
			Trollback
			s result = "{success:'false',info:'删除失败！'}"
		}
		else
		{
			TC
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","手术项目编辑器-高危提醒",id,bobj.PHINSTText,"D",bobj)
		}
		q result
}

/// Description：根据主索引的id获取高危提醒数据
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCOPERRemind).GetRemindData("4")
ClassMethod GetData(InstId As %String) As %String
{

		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

}
