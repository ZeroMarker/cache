Import SQLUser

/// 名称: 医嘱子分类接收科室维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-9-6
Class web.DHCBL.CT.ARCItemCatRecLoc Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：李森
/// CreatDate: 2012-11-7
/// Description：数据重复验证方法
/// Table：User.ARCItemCatRecLoc
/// Input：id, RLRecLocDR, RLOrdLocDR
/// Return："1"(数据重复),"0"(数据不重复),"2"(医嘱子类所在医院组和病人科室所在医院组不同)
/// Other: W ##class(web.DHCBL.CT.ARCItemCatRecLoc).FormValidate("205","","22","22","")
/// W ##class(web.DHCBL.CT.ARCItemCatRecLoc).FormValidate("88","88||2","3","3","^^^2021-06-09^^^E")
ClassMethod FormValidate(RLParRef As %String, id As %String, RLRecLocDR As %String, RLOrdLocDR As %String, Str As %String) As %String
{
	n (RLParRef, id, RLRecLocDR, RLOrdLocDR, Str)
	q:(id="")&&(RLParRef="") 0
	if RLParRef="" s RLParRef=$p(id,"||",1)
	s RLOrderPriorityDR=$p(Str,"^",1),RLTimeFrom=$p(Str,"^",2),RLTimeTo=$p(Str,"^",3),RLDateFrom=$p(Str,"^",4),RLDateTo=$p(Str,"^",5),RLCTHospitalDR=$p(Str,"^",6)
	s RLClinicType=$p(Str,"^",7)
	s flag=0
	
	if RLOrdLocDR'=""  //病人科室不为空时，判断病人科室对应的医院 是否有这个医嘱子分类的权限
	{
		s OrdLocHospitalDR=$p($g(^CTLOC(RLOrdLocDR)),"^",22)     //病人科室所在医院
		s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat",RLParRef,OrdLocHospitalDR)
		if (showflag="N") //病人科室对应的医院 没有这个医嘱子分类的权限时返回2
		{
			s flag=2
			q flag	
		}
		
	}
	
	s ChildSub=0
	for
	{
		s ChildSub=$o(^ARC("IC",RLParRef,"RL",ChildSub)) q:(ChildSub="")||(flag'=0)
		s RecLocDR=$p($G(^ARC("IC",RLParRef,"RL",ChildSub)),"^",3)
		continue:(RecLocDR'=RLRecLocDR)
		s OrdLocDR=$p($G(^ARC("IC",RLParRef,"RL",ChildSub)),"^",2)
		continue:(OrdLocDR'=RLOrdLocDR)
		s TimeFrom=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",5)
		s TimeTo=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",6)
		s CTHospitalDR=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",7)	//20200402 增加医院校验
		continue:(CTHospitalDR'=RLCTHospitalDR)
		s DateFrom=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",8)
		s DateTo=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",9)
		s OrderPriorityDR=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",10)
		continue:(OrderPriorityDR'=RLOrderPriorityDR)
		s ClinicType=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",12)
		if ((ClinicType'=RLClinicType))
		{
			continue	
		}
		
		s Pid=RLParRef_"||"_ChildSub
		if ((id="")||((id'="")&&(Pid'=id)))&&(RLRecLocDR=RecLocDR)&&(RLOrdLocDR=OrdLocDR)&&(RLOrderPriorityDR=OrderPriorityDR)&&(CTHospitalDR=RLCTHospitalDR)
		{
			if (RLDateFrom'="")&&(DateFrom'="")
			{
				if ((RLDateTo="")&&(DateTo=""))||((RLDateTo'="")&&(DateFrom<=RLDateTo)&&(DateFrom>=RLDateFrom))||((DateTo'="")&&(RLDateFrom<=DateTo)&&(RLDateFrom>=DateFrom))
				//update2019-10-25 钟荣枫 优化日期无交叉时提示交叉错误
				//if ((RLDateTo="")&&(DateTo=""))||((RLDateTo'="")&&(DateFrom<=RLDateTo))||((DateTo'="")&&(RLDateFrom<=DateTo))
				{
					if ((RLTimeFrom="")&&(RLTimeTo=""))||((TimeFrom="")&&(TimeTo=""))
					{
						s flag=1  //返回重复标志
						q
					}
					if ((TimeFrom'="")&&(TimeTo'="")&&(RLTimeFrom'="")&&(RLTimeTo'="")&&(((RLTimeFrom>TimeTo)&&(RLTimeTo>TimeTo))||((RLTimeFrom<TimeFrom)&&(RLTimeTo<TimeFrom))))
					{
					}
					else{
						s flag=1  //返回重复标志
						q
					}
				}
			}
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator：李森
/// CreatDate: 2012-9-6
/// Description：保存修改医嘱子分类接收科室的内容
/// Table：User.ARCItemCatRecLoc
/// Input：web.Entity.CT.ARCItemCatRecLoc 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.ARCItemCatRecLoc).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.ARCItemCatRecLoc) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		if eobj.RLRowId'="" s eobj.RLParRef=$p(eobj.RLRowId,"||",1)
		if (eobj.RLParRef="") q "{success:'false',errorinfo:'父表指针有误，请确认！'}"
		
		
		s:eobj.RLDefaultFlag="" eobj.RLDefaultFlag="N"
		s ARCICDesc = $p($g(^ARC("IC",eobj.RLParRef)),"^",2)	//获取医嘱子类描述
		s RLRecLocDesc=""
		s RLOrdLocDesc=""
		s:eobj.RLRecLocDR'="" RLRecLocDesc=$p($g(^CTLOC(eobj.RLRecLocDR)),"^",2) //获取接收科室描述
		s:eobj.RLOrdLocDR'="" RLOrdLocDesc=$p($g(^CTLOC(eobj.RLOrdLocDR)),"^",2) //获取病人科室描述
		
		s RLTimeFrom=eobj.RLTimeFrom,RLTimeTo=eobj.RLTimeTo
		s RLDateFrom=eobj.RLDateFrom,RLDateTo=eobj.RLDateTo
		s:eobj.RLDateFrom'="" eobj.RLDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RLDateFrom)
		s:eobj.RLDateTo'="" eobj.RLDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RLDateTo)
		s:eobj.RLDateFrom="" eobj.RLDateFrom =+$h
		s:eobj.RLTimeFrom'="" eobj.RLTimeFrom= ##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(eobj.RLTimeFrom,1)
		s:eobj.RLTimeTo'="" eobj.RLTimeTo= ##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(eobj.RLTimeTo,1)
		s str=eobj.RLOrderPriorityDR_"^"_eobj.RLTimeFrom_"^"_eobj.RLTimeTo_"^"_eobj.RLDateFrom_"^"_eobj.RLDateTo_"^"_eobj.RLCTHospitalDR_"^"_eobj.RLClinicType
		//eobj.RLOrderPriorityDR_"^"_RLTimeFrom_"^"_RLTimeTo_"^"_RLDateFrom_"^"_RLDateTo_"^"_eobj.RLCTHospitalDR_"^1"
		
		s flag=##class(web.DHCBL.CT.ARCItemCatRecLoc).FormValidate(eobj.RLParRef,eobj.RLRowId,eobj.RLRecLocDR,eobj.RLOrdLocDR,str)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'与另一条相同接收科室记录的日期时间冲突，请确认！',ARCICDesc:'"_ARCICDesc_"',RLOrdLocDesc:'"_RLOrdLocDesc_"',RLRecLocDesc:'"_RLRecLocDesc_"'}"
			//s result = "{success:'false',errorinfo:'与另一条相同接收科室记录的日期时间冲突，请确认！'}"
		}
		elseif (flag=2)	//医嘱子类所在医院组和病人科室所在医院组不同
		{
			
			s result = "{success:'false',errorinfo:'医嘱子类与病人科室不在同一个医院组，请确认！',ARCICDesc:'"_ARCICDesc_"',RLOrdLocDesc:'"_RLOrdLocDesc_"',RLRecLocDesc:'"_RLRecLocDesc_"'}"

		}
		else
		{
			///2017-2-16  增加默认接收科室时，把同一个病人科室的其他的默认科室改成不默认  chenying
			if (eobj.RLDefaultFlag="Y")
			{
				d ##class(web.DHCBL.CT.ARCItemCatRecLoc).GetDefRecLoc(eobj.RLParRef,eobj.RLRowId,eobj.RLOrdLocDR,eobj.RLOrderPriorityDR_"^"_RLTimeFrom_"^"_RLTimeTo_"^"_RLDateFrom_"^"_RLDateTo_"^"_eobj.RLCTHospitalDR_"^"_eobj.RLClinicType_"^1")
			 
			}
			
			
			if (eobj.RLRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.ARCItemCatRecLoc).%New(eobj.RLParRef)
			}
			else                  //如果RowId已赋值则修改
			{
				s obj=##class(User.ARCItemCatRecLoc).%OpenId(eobj.RLRowId)
				s bobj=##class(web.Entity.CT.ARCItemCatRecLoc).%New()
				s bobj.RLRowId=eobj.RLRowId
				s bobj.RLParRef=$p(eobj.RLRowId,"||",1)
				if $IsObject(obj.RLRecLocDR){
					s bobj.RLRecLocDR = obj.RLRecLocDR.%Id() 
				}
				if $IsObject(obj.RLOrdLocDR){
					s bobj.RLOrdLocDR = obj.RLOrdLocDR.%Id() 
				}
				s bobj.RLFunction = obj.RLFunction
				s bobj.RLDefaultFlag = obj.RLDefaultFlag
				s bobj.RLTimeFrom = obj.RLTimeFrom
				s bobj.RLTimeTo = obj.RLTimeTo
				if $IsObject(obj.RLCTHospitalDR){
					s bobj.RLCTHospitalDR = obj.RLCTHospitalDR.%Id() 
				}
				s bobj.RLDateFrom = obj.RLDateFrom
				s bobj.RLDateTo = obj.RLDateTo
				if $IsObject(obj.RLOrderPriorityDR){
					s bobj.RLOrderPriorityDR = obj.RLOrderPriorityDR.%Id() 
				}
				
				s bobj.RLClinicType = obj.RLClinicType
				
			}
			        	
	        d:eobj.RLParRef'="" obj.RLParRefSetObjectId(eobj.RLParRef) //修改数据时RLParRef为空
	        d obj.RLRecLocDRSetObjectId(eobj.RLRecLocDR)
			d obj.RLOrdLocDRSetObjectId(eobj.RLOrdLocDR)
			s obj.RLFunction = eobj.RLFunction
			s obj.RLDefaultFlag = eobj.RLDefaultFlag
			s obj.RLTimeFrom = eobj.RLTimeFrom
			s obj.RLTimeTo = eobj.RLTimeTo
			d obj.RLCTHospitalDRSetObjectId(eobj.RLCTHospitalDR)
			s obj.RLDateFrom = eobj.RLDateFrom
			s obj.RLDateTo = eobj.RLDateTo
			d obj.RLOrderPriorityDRSetObjectId(eobj.RLOrderPriorityDR)
			
			s obj.RLClinicType = eobj.RLClinicType
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				//s result = "{success:'true',id:'"_id_"'}"         //返回RowId
				s result = "{success:'true',id:'"_id_"',ARCICDesc:'"_ARCICDesc_"',RLOrdLocDesc:'"_RLOrdLocDesc_"',RLRecLocDesc:'"_RLRecLocDesc_"'}"       
				//保存日志
				s ARCICDesc=$p($g(^ARC("IC",$p(id,"||",1))),"^",2)
				s RLOrdLocDRDesc="",RLRecLocDRDesc=""
				s:eobj.RLOrdLocDR'="" RLOrdLocDRDesc=$p($g(^CTLOC(eobj.RLOrdLocDR)),"^",2)
				s:eobj.RLRecLocDR'="" RLRecLocDRDesc=$p($g(^CTLOC(eobj.RLRecLocDR)),"^",2)
				s DescLog=ARCICDesc_"-"_RLOrdLocDRDesc_"-"_RLRecLocDRDesc
				d:eobj.RLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemCatRecLoc","User.ARCItemCatRecLoc","医嘱子分类接收科室",id,DescLog,"A",eobj)
				d:eobj.RLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemCatRecLoc","User.ARCItemCatRecLoc","医嘱子分类接收科室",eobj.RLRowId,DescLog,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱子分类接收科室","web.DHCBL.CT.ARCItemCatRecLoc","SaveEntity",eobj)
    			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"',ARCICDesc:'"_ARCICDesc_"',RLOrdLocDesc:'"_RLOrdLocDesc_"',RLRecLocDesc:'"_RLRecLocDesc_"'}"  //返回错误信息
				//s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator：李森
/// CreatDate: 2012-9-6
/// Description：根据ID删除医嘱子分类接收科室的内容
/// Table：User.ARCItemCatRecLoc
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// w ##class(web.DHCBL.CT.ARCItemCatRecLoc).DeleteData("84||8")
ClassMethod DeleteData(id As %String) As %String
{
	n (id,%session)
	s result=""
	s eobj = ##class(web.Entity.CT.ARCItemCatRecLoc).%New()
	s ParRef=$p(id,"||",1)
	s ChildSub=$p(id,"||",2)
	s eobj.RLRowId=id
	s eobj.RLRecLocDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",3) //接收科室
	s eobj.RLOrdLocDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",2) //病人科室
	s eobj.RLFunction=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",1)
	s eobj.RLDefaultFlag=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",4)
	s:eobj.RLDefaultFlag="Y" eobj.RLDefaultFlag="true"
	s eobj.RLTimeFrom=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",5)
	s eobj.RLTimeTo=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",6)
	s eobj.RLCTHospitalDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",7)
	s eobj.RLDateFrom=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",8)
	s eobj.RLDateTo=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",9)
	s eobj.RLOrderPriorityDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",10)
	
	s eobj.RLClinicType=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",12)
	
	TS
	s sc=##class(User.ARCItemCatRecLoc).%DeleteId(id)
	i $$$ISOK(sc)
	{
		TC
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		s ARCICDesc=$p($g(^ARC("IC",$p(id,"||",1))),"^",2)
		s RLOrdLocDRDesc="",RLRecLocDRDesc=""
		s:eobj.RLOrdLocDR'="" RLOrdLocDRDesc=$p($g(^CTLOC(eobj.RLOrdLocDR)),"^",2)
		s:eobj.RLRecLocDR'="" RLRecLocDRDesc=$p($g(^CTLOC(eobj.RLRecLocDR)),"^",2)
		s DescLog=ARCICDesc_"-"_RLOrdLocDRDesc_"-"_RLRecLocDRDesc
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemCatRecLoc","User.ARCItemCatRecLoc","医嘱子分类接收科室",id,DescLog,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		TRO
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱子分类接收科室","web.DHCBL.CT.ARCItemCatRecLoc","DeleteData",eobj)
    	s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator：李森
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.ARCItemCatRecLoc
/// Input：id
/// w ##class(web.DHCBL.CT.ARCItemCatRecLoc).OpenData("1||1")
ClassMethod OpenData(id As %String) As %String
{
	n (id)
	s str=""
	s eobj = ##class(web.Entity.CT.ARCItemCatRecLoc).%New()
	s ParRef=$p(id,"||",1)
	s ChildSub=$p(id,"||",2)
	s eobj.RLRowId=id
	s eobj.RLParRef=ParRef
	s eobj.RLRecLocDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",3) //接收科室
	s eobj.RLOrdLocDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",2) //病人科室
	s eobj.RLFunction=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",1)
	s eobj.RLDefaultFlag=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",4)
	s:eobj.RLDefaultFlag="Y" eobj.RLDefaultFlag="true"
	s eobj.RLTimeFrom=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",5)
	s eobj.RLTimeTo=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",6)
	s eobj.RLCTHospitalDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",7)
	s eobj.RLDateFrom=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",8)
	s eobj.RLDateTo=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",9)
	s eobj.RLOrderPriorityDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",10)
	s eobj.RLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateFrom)
	s eobj.RLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateTo)
	s eobj.RLTimeFrom= ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom,1)
	s eobj.RLTimeTo= ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeTo,1)
	s eobj.RLClinicType=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",12)

	s str = eobj.JsonS()
	d eobj.%Close()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：李森
/// CreatDate: 2012-9-6
/// Description：查询医嘱子分类接收科室的内容	
/// update:2019-9-18 添加接收科室描述、病人科室描述、医院描述、医嘱优先级等返回值
/// Table：User.ARCItemCatRecLoc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCItemCatRecLoc","GetList","","","")
Query GetList(rowid As %String, RecLoc As %String, OrdLoc As %String, ParRef As %String, hospid As %String) As %Query(ROWSPEC = "RLRowId:%String,RLRecLocDesc:%String,RLOrdLocDesc:%String,RLFunction:%String,RLDefaultFlag:%String,RLTimeFrom:%String,RLTimeTo:%String,RLCTHospitalDesc:%String,RLDateFrom:%String,RLDateTo:%String,RLOrderPriorityDesc:%String,RLOrdLocDR,RLRecLocDR,RLCTHospitalDR,RLOrderPriorityDR,RLClinicType")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, RecLoc As %String, OrdLoc As %String, ParRef As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //rowid不为空,ParRef为空
	{
		s RLParRef=$p(rowid,"||",1)
		s ChildSub=$p(rowid,"||",2)
		s RLRowId=rowid
		
		s RLRecLocDR=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",3)
		s RLRecLocDesc=""
		s:RLRecLocDR'="" RLRecLocDesc=$p($g(^CTLOC(RLRecLocDR)),"^",2) //获取接收科室描述
		
		s RLOrdLocDR=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",2)
		s RLOrdLocDesc=""
		s:RLOrdLocDR'="" RLOrdLocDesc=$p($g(^CTLOC(RLOrdLocDR)),"^",2) //获取病人科室描述
		
		s RLFunction=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",1)
		s RLDefaultFlag=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",4)
		s:RLDefaultFlag="" RLDefaultFlag="N"
		s RLTimeFrom=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",5)
		s RLTimeTo=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",6)
		s RLCTHospitalDR=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",7)
		s RLCTHospitalDesc=""
		s:RLCTHospitalDR'="" RLCTHospitalDesc=$p($g(^CT("HOSP",RLCTHospitalDR)),"^",2) //获取医院描述
		s RLDateFrom=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",8)
		s RLDateTo=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",9)
		s RLOrderPriorityDR=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",10)
		s RLOrderPriorityDesc=""
		s:RLOrderPriorityDR'="" RLOrderPriorityDesc=$p($g(^OECPR(RLOrderPriorityDR)),"^",2) //获取医嘱优先级描述
		s:RLDateFrom'="" RLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(RLDateFrom) //转换日期格式
		s:RLDateTo'="" RLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(RLDateTo) //转换日期格式
		s:RLTimeFrom'="" RLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(RLTimeFrom)  //转换时间
		s:RLTimeTo'="" RLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(RLTimeTo)      //转换时间
		
		s RLClinicType=$p($g(^ARC("IC",RLParRef,"RL",ChildSub)),"^",12)		//就诊类型
		s RLClinicType=$case(RLClinicType,"O":"门诊","E":"急诊","I":"住院","H":"体检","N":"新生儿",:"")
					
		d OutputRow
	}
	else //rowid为空,ParRef不为空
	{
		
	
		if (ParRef)
		{
			
			//获取医院级授权
			//s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
			s ChildSub=0
			f {
				s ChildSub=$o(^ARC("IC",ParRef,"RL",ChildSub))
				q:ChildSub=""
				s RLRowId=ParRef_"||"_ChildSub
				
				///2020-02-15判断接收科室的所属医院
				s RLRecLocDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",3)
				s CTLOCHospitalDR=$p($g(^CTLOC(RLRecLocDR)),"^",22)
				s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
				//筛选授权后的数据，医院级授权
				//s RLCTHospitalDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",7)
				//s strHospitalID = "{ID:"_RLCTHospitalDR_"}"
				//if ((AuHospStr[strHospitalID)||(AuHospStr=1)||(AuHospStr="off")) {
				
					s RLRecLocDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",3)
					s RLRecLocDesc=""
					s:RLRecLocDR'="" RLRecLocDesc=$p($g(^CTLOC(RLRecLocDR)),"^",2) //获取接收科室描述
				
					s RLOrdLocDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",2)
					s RLOrdLocDesc=""
					s:RLOrdLocDR'="" RLOrdLocDesc=$p($g(^CTLOC(RLOrdLocDR)),"^",2) //获取病人科室描述
				
					s RLFunction=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",1)
					s RLDefaultFlag=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",4)
					s:RLDefaultFlag="" RLDefaultFlag="N"
					s RLTimeFrom=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",5)
					s RLTimeTo=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",6)
					s RLCTHospitalDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",7)
					s RLCTHospitalDesc=""
					s:RLCTHospitalDR'="" RLCTHospitalDesc=$p($g(^CT("HOSP",RLCTHospitalDR)),"^",2) //获取医院描述
					s RLDateFrom=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",8)
					s RLDateTo=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",9)
					s RLOrderPriorityDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",10)
					s RLOrderPriorityDesc=""
					s:RLOrderPriorityDR'="" RLOrderPriorityDesc=$p($g(^OECPR(RLOrderPriorityDR)),"^",2) //获取医嘱优先级描述
					s:RLDateFrom'="" RLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(RLDateFrom) //转换日期格式
					s:RLDateTo'="" RLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(RLDateTo) //转换日期格式
					s:RLTimeFrom'="" RLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(RLTimeFrom)  //转换时间
					s:RLTimeTo'="" RLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(RLTimeTo)      //转换时间
					s RLClinicType=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",12)		//就诊类型
					s RLClinicType=$case(RLClinicType,"O":"门诊","E":"急诊","I":"住院","H":"体检","N":"新生儿",:"")
					i ((RLRecLocDR=RecLoc)||(RecLoc=""))&((RLOrdLocDR=OrdLoc)||(OrdLoc=""))
					{
						d OutputRow
					}
				//}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RLRowId,RLRecLocDesc,RLOrdLocDesc,RLFunction,RLDefaultFlag,RLTimeFrom,RLTimeTo,RLCTHospitalDesc,RLDateFrom,RLDateTo,RLOrderPriorityDesc,RLOrdLocDR,RLRecLocDR,RLCTHospitalDR,RLOrderPriorityDR,RLClinicType)
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

/// Creator：钟荣枫
/// CreatDate: 2019-10-28
/// Description：复制医嘱子类的接收科室  吉大三院 获取病人科室为某个科室的全部数据，然后复制给另一个科室
/// Table：User.ARCItemCatRecLoc 医嘱子类接收科室
/// Input：FromLocDR 被复制的科室id,ToLocDR 复制到的科室id
/// Return：result 0 失败 1成功
/// w ##class(web.DHCBL.CT.ARCItemCatRecLoc).CopyLocToLoc(366,353)
ClassMethod CopyLocToLoc(FromLocDR, ToLocDR) As %String
{
	s ARCICRowId=0
	for
	{
		s ARCICRowId=$o(^ARC("IC",ARCICRowId))
		q:ARCICRowId=""		
		s ARCICDesc = $p($g(^ARC("IC",ARCICRowId)),"^",2)	//获取医嘱子类描述 	
		s ChildSub=0
	    
		for
		{
			s ChildSub=$o(^ARC("IC",ARCICRowId,"RL",ChildSub))
			q:ChildSub=""
			s Function=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",1)	//功能
			s OrdLocDR=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",2)	//病人科室
			continue:OrdLocDR'=FromLocDR
			
			s RecLocDR=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",3)	//接收科室
			s Defaultflag=$P(^ARC("IC",ARCICRowId,"RL",ChildSub),"^",4)	//默认
			s stTime=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",5)	//开始时间
			s endTime=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",6)	//结束时间
			s CTHospitalDR=$P(^ARC("IC",ARCICRowId,"RL",ChildSub),"^",7)	//医院
			s stDate=$P($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",8)	//开始日期
	 		s endDate=$P($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",9)	//结束日期
			s Priority=$P(^ARC("IC",ARCICRowId,"RL",ChildSub),"^",10)	//医嘱优先级
			if (+Priority=0)  {
				s Priority=""
			}
			s RecLocDesc=""
			s OrdLocDesc=""
			s:RecLocDR'="" RecLocDesc=$p($g(^CTLOC(RecLocDR)),"^",2) //获取接收科室描述
			s:OrdLocDR'="" OrdLocDesc=$p($g(^CTLOC(OrdLocDR)),"^",2) //获取病人科室描述
			s RLClinicType=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",12)		//就诊类型
			
			s str=Priority_"^"_stTime_"^"_endTime_"^"_stDate_"^"_endDate
			
			s str2=str_"^"_CTHospitalDR_"^"_RLClinicType
			s flag=..FormValidate(ARCICRowId,"",RecLocDR,ToLocDR,str2)	//检测是否存在
			
			if (flag=0)		//不重复
			{
				if (Defaultflag="Y"){	//是默认
					s flag2= ..GetDefRecLoc(ARCICRowId,"",ToLocDR,str2)
					if (flag2=1){		//存在默认数据
						s result=0
						continue
					}
					
				}
				else{			//非默认
					s eobj =##class(web.Entity.CT.ARCItemCatRecLoc).%New()
					s eobj.RLParRef=ARCICRowId
					s eobj.RLRowId=""
					s eobj.RLOrdLocDR=ToLocDR
					s eobj.RLRecLocDR=RecLocDR
					s eobj.RLFunction=Function
					s eobj.RLDefaultFlag=Defaultflag
					s eobj.RLCTHospitalDR=CTHospitalDR
					S eobj.RLDateFrom=stDate
					S eobj.RLDateTo=endDate
					S eobj.RLTimeFrom=stTime
					S eobj.RLTimeTo=endTime
					S eobj.RLOrderPriorityDR=Priority
					s eobj.RLClinicType=RLClinicType
					s result= ..SaveEntity(eobj)
					if (result["success:'true'")	//保存成功
					{
						 s result=1 					
					}
					if (result["success:'false'")	//保存失败
					{
										
						s result=0 
					}
				}
			}
			else	//数据重复
			{
				s result=0 
				continue	
			}
			
		}
	}
	q result
}

/// Creator：钟荣枫
/// CreatDate: 2019-9-20
/// Description：复制医嘱子类的接收科室 	获取医嘱子类下的所有接收科室数据，复制给另一医嘱子类
/// Table：User.ARCItemCatRecLoc	医嘱子类接收科室
/// Input：FromCatsubDr 被复制的医嘱子类id,ToCatsubDr 复制到的医嘱子类id
/// Return：resultstr 结果串
/// w ##class(web.DHCBL.CT.ARCItemCatRecLoc).CopyCatsubRecLoc(83,81)
ClassMethod CopyCatsubRecLoc(FromCatsubDr, ToCatsubDr) As %String
{
	s n=0
	s Fsub=0
	s resultstr=""
	s ARCICDesc = $p($g(^ARC("IC",ToCatsubDr)),"^",2)	//获取医嘱子类描述 
	s ToARCICDesc = $p($g(^ARC("IC",ToCatsubDr)),"^",2)
	for
	{
		s Fsub=$O(^ARC("IC",FromCatsubDr,"RL",Fsub))  q:Fsub=""
		s n=n+1
		s mFunction=$p($g(^ARC("IC",FromCatsubDr,"RL",Fsub)),"^",1)	//功能
		s mPatlocdr=$P(^ARC("IC",FromCatsubDr,"RL",Fsub),"^",2)	//病人科室ID
		s mReclocdr=$P(^ARC("IC",FromCatsubDr,"RL",Fsub),"^",3)	//接收科室ID
		s mDefaultflag=$P(^ARC("IC",FromCatsubDr,"RL",Fsub),"^",4)	//默认
		s stTime=$p($g(^ARC("IC",FromCatsubDr,"RL",Fsub)),"^",5)	//开始时间
		s endTime=$p($g(^ARC("IC",FromCatsubDr,"RL",Fsub)),"^",6)	//结束时间
		if stTime'="" s stTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(stTime)
		if endTime'="" s endTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(endTime)
		
		s mCTHospitalDR=$P(^ARC("IC",FromCatsubDr,"RL",Fsub),"^",7)	//医院
		s stDate=$P($g(^ARC("IC",FromCatsubDr,"RL",Fsub)),"^",8)	//开始日期
 		s endDate=$P($g(^ARC("IC",FromCatsubDr,"RL",Fsub)),"^",9)	//结束日期
 		if stDate'="" s stDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(stDate)
 		if endDate'="" s endDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(endDate)
		s mPriority=$P(^ARC("IC",FromCatsubDr,"RL",Fsub),"^",10)	//医嘱优先级
		if (+mPriority=0)  {
			s mPriority=""
		}
		s RLClinicType=$p($g(^ARC("IC",FromCatsubDr,"RL",Fsub)),"^",12)		//就诊类型
		
		s eobj =##class(web.Entity.CT.ARCItemCatRecLoc).%New()
		s eobj.RLParRef=ToCatsubDr
		s eobj.RLRowId=""
		s eobj.RLOrdLocDR=mPatlocdr
		s eobj.RLRecLocDR=mReclocdr
		s eobj.RLFunction=mFunction
		s eobj.RLDefaultFlag=mDefaultflag
		s eobj.RLCTHospitalDR=mCTHospitalDR
		S eobj.RLDateFrom=stDate
		S eobj.RLDateTo=endDate
		S eobj.RLTimeFrom=stTime
		S eobj.RLTimeTo=endTime
		S eobj.RLOrderPriorityDR=mPriority
		s eobj.RLClinicType=RLClinicType
		
		s result= ..SaveEntity(eobj)
		s resultstr=resultstr_"^"_result
			
		
	}	
	q resultstr
}

/// Creator：陈莹
/// CreatDate: 2016-12-12
/// Description：修改 项目上自己导入过科室数据后，在前台维护时报uniqueindex的报错
/// Table：User.ARCItemCatRecLoc
/// flag=0时 查看错误数据，flag=1时处理错误数据
/// d ##class(web.DHCBL.CT.ARCItemCatRecLoc).RepairError(0) 
/// d ##class(web.DHCBL.CT.ARCItemCatRecLoc).RepairError(0) 
ClassMethod RepairError(flag) As %String
{
	
	k ^TMPERRORRECLOC("IC")
	s ARCICRowId=0
	for
	{
		s ARCICRowId=$o(^ARC("IC",ARCICRowId))
		q:ARCICRowId=""
		s ChildSub=$g(^ARC("IC",ARCICRowId,"RL",0))
		s realsub=$o(^ARC("IC",ARCICRowId,"RL",""),-1)
		if ((realsub'="")&&(ChildSub=""))||((realsub'="")&&(realsub>ChildSub)&&(ChildSub'="")) 
		{
			if (flag=0) s ^TMPERRORRECLOC("IC",ARCICRowId)=ChildSub_"  "_realsub
			if (flag=1) s ^ARC("IC",ARCICRowId,"RL",0)=realsub
		}
	}
	if (flag=0) zw ^TMPERRORRECLOC("IC")
	q ""
}

/// Creator：陈莹
/// CreatDate: 2016-12-30  update20190927
/// Description：获取默认科室 （要求 对同一个病人科室 或者为空的，优先级相同时，不允许在同一个时间段内存在两个默认值）
/// Table：User.ARCItemCatRecLoc
/// Input:医嘱子分类rowid，，Str:优先级^开始时间^结束时间^开始日期^结束日期^医院^updateflag=1是把默认更新成N
/// w ##class(web.DHCBL.CT.ARCItemCatRecLoc).GetDefRecLoc("83","","366","^12:00:00^23:00:00^2019-10-14^2019-10-14^^") 
/// w ##class(web.DHCBL.CT.ARCItemCatRecLoc).GetDefRecLoc("83","","366","^12:00:00^23:00:00^65300^65301^^") 
/// w ##class(web.DHCBL.CT.ARCItemCatRecLoc).GetDefRecLoc("83","","366","^^^65311^65313^^") 
/// 0 不存在默认  1 存在默认
ClassMethod GetDefRecLoc(ParRef, RLRowId, RLOrdLocDR, Str As %String, updateflag As %String = "") As %String
{
	n (ParRef,RLRowId,RLOrdLocDR,Str)
	if ParRef="" s ParRef=$p(RLRowId,"||",1)
	q:ParRef="" 0
	s RLOrderPriorityDR=$p(Str,"^",1),RLTimeFrom=$p(Str,"^",2),RLTimeTo=$p(Str,"^",3),RLDateFrom=$p(Str,"^",4),RLDateTo=$p(Str,"^",5)
	s RLCTHospitalDR=$p(Str,"^",6)
	s RLClinicType=$p(Str,"^",7)
	
	s updateflag=$p(Str,"^",8)
	s:RLDateFrom'="" RLDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(RLDateFrom)
	s:RLDateTo'="" RLDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(RLDateTo)
	s:RLTimeFrom'="" RLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(RLTimeFrom)
	s:RLTimeTo'="" RLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(RLTimeTo)
	s flag=0
	if RLOrdLocDR'=""  //病人科室不为空时，判断病人科室对应的医院 是否有这个医嘱子分类的权限
	{
		s OrdLocHospitalDR=$p($g(^CTLOC(RLOrdLocDR)),"^",22)     //病人科室所在医院
		s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat",ParRef,OrdLocHospitalDR)
		if (showflag="N") //病人科室对应的医院 没有这个医嘱子分类的权限时返回2
		{
			s flag=2
			q flag	
		}
		
	}
	
	S n=0
	s ChildSub=0
	for
	{
		s ChildSub=$o(^ARC("IC",ParRef,"RL",ChildSub)) q:(ChildSub="")
		s OrdLocDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",2)
		continue:(OrdLocDR'=RLOrdLocDR)
		s DefaultFlag=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",4)
		continue:(DefaultFlag'="Y")
		s OrderPriorityDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",10)
		continue:(OrderPriorityDR'=RLOrderPriorityDR)
		s TimeFrom=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",5)
		s TimeTo=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",6)
		s DateFrom=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",8)
		s DateTo=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",9)	
		s HospitalDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",7)
		continue:(HospitalDR'=RLCTHospitalDR)
		s ClinicType=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",12)
		continue:((ClinicType'=RLClinicType))
		s rowid=ParRef_"||"_ChildSub
		if (((RLRowId'="")&(RLRowId'=rowid))||(RLRowId="")) //&&(RLCTHospitalDR=HospitalDR)	//likefan 2021-06-15
		{
			//日期不交叉   开始日期或结束时间同一天		或开始日期同一天且结束日期同一天 但时间不交叉
			//if ((DateTo'="")&&(DateTo<RLDateFrom))||((RLDateTo'="")&&(RLDateTo<DateFrom))||(('((RLDateTo="")&&(DateTo=""))&&((DateTo=RLDateFrom)||(DateFrom=RLDateTo)||((DateTo=RLDateTo)&&(DateFrom=RLDateFrom))))&&((TimeFrom'="")&&(TimeTo'="")&&(RLTimeFrom'="")&&(RLTimeTo'="")&&((RLTimeFrom>TimeTo)||(RLTimeTo<TimeFrom))))	
			//if ('((RLDateTo="")&&(DateTo=""))||((RLDateTo'="")&&(DateFrom<=RLDateTo))||((DateTo'="")&&(RLDateFrom<=DateTo)))||((TimeFrom'="")&&(TimeTo'="")&&(RLTimeFrom'="")&&(RLTimeFrom'="")&&(((RLTimeFrom>TimeTo)&&(RLTimeTo>TimeTo))||((RLTimeFrom<TimeFrom)&&(RLTimeTo<TimeFrom))))
			if (((RLDateTo'="")&&(DateFrom>=RLDateTo))||((DateTo'="")&&(RLDateFrom>=DateTo)))||((TimeFrom'="")&&(TimeTo'="")&&(RLTimeFrom'="")&&(RLTimeTo'="")&&(((RLTimeFrom>TimeTo)&&(RLTimeTo>TimeTo))||((RLTimeFrom<TimeFrom)&&(RLTimeTo<TimeFrom))))
			{
				 continue
			}
			s flag=1 
			if updateflag=1
			{
				
				s rowid=ParRef_"||"_ChildSub
				s updobj=##class(User.ARCItemCatRecLoc).%OpenId(rowid)
				s updateeobj=##class(web.Entity.CT.ARCItemCatRecLoc).%New()
				s updateeobj.RLRowId=rowid
				s updateeobj.RLParRef=ParRef
				if $IsObject(updobj.RLRecLocDR){
					s updateeobj.RLRecLocDR = updobj.RLRecLocDR.%Id() 
				}
				if $IsObject(updobj.RLOrdLocDR){
					s updateeobj.RLOrdLocDR = updobj.RLOrdLocDR.%Id() 
				}
				s updateeobj.RLFunction = updobj.RLFunction
				s updateeobj.RLDefaultFlag = "N"
				s updateeobj.RLTimeFrom = updobj.RLTimeFrom
				s updateeobj.RLTimeTo = updobj.RLTimeTo

				s:updateeobj.RLTimeFrom'="" updateeobj.RLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(updateeobj.RLTimeFrom,1)
				s:updateeobj.RLTimeTo'="" updateeobj.RLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(updateeobj.RLTimeTo,1)

				if $IsObject(updobj.RLCTHospitalDR){
					s updateeobj.RLCTHospitalDR = updobj.RLCTHospitalDR.%Id() 
				}
				s updateeobj.RLDateFrom = updobj.RLDateFrom
				s updateeobj.RLDateTo = updobj.RLDateTo
				s:updateeobj.RLDateFrom'="" updateeobj.RLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(updateeobj.RLDateFrom)   // $tr($zd(updateeobj.RLDateFrom,3),"-","/")
				s:updateeobj.RLDateTo'="" updateeobj.RLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(updateeobj.RLDateTo)
				if $IsObject(updobj.RLOrderPriorityDR){
					s updateeobj.RLOrderPriorityDR = updobj.RLOrderPriorityDR.%Id() 
				}
				
				
				s updatebobj=##class(web.Entity.CT.ARCItemCatRecLoc).%New()
				s updatebobj.RLRowId=rowid
				s updatebobj.RLParRef=ParRef
				if $IsObject(updobj.RLRecLocDR){
					s updatebobj.RLRecLocDR = updobj.RLRecLocDR.%Id() 
				}
				if $IsObject(updobj.RLOrdLocDR){
					s updatebobj.RLOrdLocDR = updobj.RLOrdLocDR.%Id() 
				}
				s updatebobj.RLFunction = updobj.RLFunction
				s updatebobj.RLDefaultFlag = "N"
				s updatebobj.RLTimeFrom = updobj.RLTimeFrom
				s updatebobj.RLTimeTo = updobj.RLTimeTo
				if $IsObject(updobj.RLCTHospitalDR){
					s updatebobj.RLCTHospitalDR = updobj.RLCTHospitalDR.%Id() 
				}
				s updatebobj.RLDateFrom = updobj.RLDateFrom
				s updatebobj.RLDateTo = updobj.RLDateTo
				if $IsObject(updobj.RLOrderPriorityDR){
					s updatebobj.RLOrderPriorityDR = updobj.RLOrderPriorityDR.%Id() 
				}
				
				
		        s updobj.RLDefaultFlag =updateeobj.RLDefaultFlag
				s sc=updobj.%Save()
				d updobj.%Close()
				If $$$ISOK(sc)
				{
					//保存日志
					s RecLocDesc = $p($g(^CTLOC(updateeobj.RLRecLocDR)),"^",2)
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemCatRecLoc","User.ARCItemCatRecLoc","医嘱子分类接收科室",rowid,RecLocDesc,"U",updateeobj,updatebobj)
				}
				
			}
		}
	}			
				
	q flag
}

}
