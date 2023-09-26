Import SQLUser

/// 名称: 医嘱与结果- 医嘱大类接收科室维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2012-9-4
Class web.DHCBL.CT.OECOrdCatRecLoc Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate: 2012-11-7
/// Description：数据重复验证方法
/// Table：User.OECOrdCatRecLoc
/// Input：id, RLRecLocDR, RLOrdLocDR
/// Return："1"(数据重复),"0"(数据不重复)
/// W ##class(web.DHCBL.CT.OECOrdCatRecLoc).FormValidate("2","","1","","^^^64539^")
ClassMethod FormValidate(RLParRef As %String, id As %String, RLRecLocDR As %String, RLOrdLocDR As %String, Str As %String) As %String
{
	n (RLParRef,id,RLRecLocDR,RLOrdLocDR,Str)
	q:(id="")&&(RLParRef="")
	if RLParRef="" s RLParRef=$p(id,"||",1)
	s RLOrderPriorityDR=$p(Str,"^",1),RLTimeFrom=$p(Str,"^",2),RLTimeTo=$p(Str,"^",3),RLDateFrom=$p(Str,"^",4),RLDateTo=$p(Str,"^",5),RLCTHospitalDR=$p(Str,"^",6)
	s RLClinicType=$p(Str,"^",7)
	s flag=0
	s ChildSub=0
	for
	{
		s ChildSub=$o(^OEC("ORCAT",RLParRef,"RL",ChildSub))
		q:ChildSub=""
		s RecLocDR=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",3)
		s OrdLocDR=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",2)
		s TimeFrom=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",5)
		s TimeTo=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",6)
		s DateFrom=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",8)
		s DateTo=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",9)
		s OrderPriorityDR=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",10)
		s CTHospitalDR=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",7)	//20200402 增加医院校验
		s ClinicType=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",12)
		continue:((ClinicType'="")&&(RLClinicType'="")&&(ClinicType'=RLClinicType))
		
		s Pid=RLParRef_"||"_ChildSub
		if ((id="")||((id'="")&&(Pid'=id)))&&(RLRecLocDR=RecLocDR)&&(RLOrdLocDR=OrdLocDR)&&(RLOrderPriorityDR=OrderPriorityDR)&&(RLCTHospitalDR=CTHospitalDR)
		{
			if (RLDateFrom'="")&&(DateFrom'="")
			{
				if ((RLDateTo="")&&(DateTo=""))||((RLDateTo'="")&&(DateFrom<=RLDateTo))||((DateTo'="")&&(RLDateFrom<=DateTo))
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

/// Creator：陈莹
/// CreatDate: 2012-9-4
/// Description：保存修改医嘱大类接收科室的内容
/// Table：User.OECOrdCatRecLoc
/// Input：web.Entity.CT.OECOrdCatRecLoc 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.OECOrdCatRecLoc).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.OECOrdCatRecLoc) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		
		
		if eobj.RLRowId'="" s eobj.RLParRef=$p(eobj.RLRowId,"||",1)
		if (eobj.RLParRef="") q "{success:'false',errorinfo:'父表指针有误，请确认！'}"
		s:eobj.RLDateFrom'="" eobj.RLDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RLDateFrom)
		s:eobj.RLDateTo'="" eobj.RLDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RLDateTo)
		s:eobj.RLDateFrom="" eobj.RLDateFrom =+$h
		s:eobj.RLTimeFrom'="" eobj.RLTimeFrom= ##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(eobj.RLTimeFrom,1)
		s:eobj.RLTimeTo'="" eobj.RLTimeTo= ##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(eobj.RLTimeTo,1)
		s:eobj.RLDefaultFlag="" eobj.RLDefaultFlag="N"
		s str=eobj.RLOrderPriorityDR_"^"_eobj.RLTimeFrom_"^"_eobj.RLTimeTo_"^"_eobj.RLDateFrom_"^"_eobj.RLDateTo_"^"_eobj.RLCTHospitalDR_"^"_eobj.RLClinicType
		s flag=..FormValidate(eobj.RLParRef,eobj.RLRowId,eobj.RLRecLocDR,eobj.RLOrdLocDR,str)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'与另一条相同接收科室记录的日期时间冲突，请确认！'}"
		}
		else
		{
			///2016-12-30  增加默认接收科室时，把其他的默认科室改成不默认 chenying
			if (eobj.RLDefaultFlag="Y")
			{
				s flag=..GetDefRecLoc(eobj.RLParRef,eobj.RLRowId,eobj.RLOrdLocDR,str)
	
				if (flag=1)&&(eobj.RLParRef'="")
				{
					s n=0
					for 
					{
						s n=$o(^TMPRECLOC("OECOrdCatRecLoc",eobj.RLParRef,n)) q:n=""
						s rowid=$G(^TMPRECLOC("OECOrdCatRecLoc",eobj.RLParRef,n))
						s updobj=##class(User.OECOrdCatRecLoc).%OpenId(rowid)
						s updateeobj=##class(web.Entity.CT.OECOrdCatRecLoc).%New()
						s updateeobj.RLRowId=rowid
						s updateeobj.RLParRef=$p(rowid,"||",1)
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
						
						s updatebobj=##class(web.Entity.CT.OECOrdCatRecLoc).%New()
						s updatebobj.RLRowId=rowid
						s updatebobj.RLParRef=$p(rowid,"||",1)
						if $IsObject(updobj.RLRecLocDR){
							s updatebobj.RLRecLocDR = updobj.RLRecLocDR.%Id() 
						}
						if $IsObject(updobj.RLOrdLocDR){
							s updatebobj.RLOrdLocDR = updobj.RLOrdLocDR.%Id() 
						}
						s updatebobj.RLFunction = updobj.RLFunction
						s updatebobj.RLDefaultFlag = updobj.RLDefaultFlag
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
						s updatebobj.RLClinicType =updobj.RLClinicType
						
				        s updobj.RLDefaultFlag =updateeobj.RLDefaultFlag
						s sc=updobj.%Save()
						d updobj.%Close()
						If $$$ISOK(sc)
						{
							//保存日志
							s RecLocDesc = $p($g(^CTLOC(updateeobj.RLRecLocDR)),"^",2)
							d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_OrdCatRecLoc","User.OECOrdCatRecLoc","医嘱大类接收科室",rowid,RecLocDesc,"U",updateeobj,updatebobj)
						}
						
					
					}
				}	
			 
			}
		
			if (eobj.RLRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.OECOrdCatRecLoc).%New(eobj.RLParRef)
			}
			else                  //如果RowId已赋值则修改
			{
				s obj=##class(User.OECOrdCatRecLoc).%OpenId(eobj.RLRowId)
				s bobj=##class(web.Entity.CT.OECOrdCatRecLoc).%New()
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
				s bobj.RLClinicType=obj.RLClinicType
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
			
			s obj.RLClinicType=eobj.RLClinicType
			
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"         //返回RowId
				//保存日志
				s ORCATDesc=$p($g(^OEC("ORCAT",$p(id,"||",1))),"^",2)
				s RLOrdLocDRDesc="",RLRecLocDRDesc=""
				s:eobj.RLOrdLocDR'="" RLOrdLocDRDesc=$p($g(^CTLOC(eobj.RLOrdLocDR)),"^",2)
				s:eobj.RLRecLocDR'="" RLRecLocDRDesc=$p($g(^CTLOC(eobj.RLRecLocDR)),"^",2)
				s DescLog=ORCATDesc_"-"_RLOrdLocDRDesc_"-"_RLRecLocDRDesc
				d:eobj.RLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_OrdCatRecLoc","User.OECOrdCatRecLoc","医嘱大类接收科室",id,DescLog,"A",eobj)
				d:eobj.RLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_OrdCatRecLoc","User.OECOrdCatRecLoc","医嘱大类接收科室",eobj.RLRowId,DescLog,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱大类接收科室","web.DHCBL.CT.OECOrdCatRecLoc","SaveEntity",eobj)
     			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 2012-9-4
/// Description：根据ID删除医嘱大类接收科室的内容
/// Table：User.OECOrdCatRecLoc
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	n (id,%session)
	s result=""
	s eobj = ##class(web.Entity.CT.OECOrdCatRecLoc).%New()
	s ParRef=$p(id,"||",1)
	s ChildSub=$p(id,"||",2)
	s eobj.RLRowId=id
	s eobj.RLRecLocDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",3)
	s eobj.RLOrdLocDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",2)
	s eobj.RLFunction=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",1)
	s eobj.RLDefaultFlag=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",4)
	//s:eobj.RLDefaultFlag="Y" eobj.RLDefaultFlag="true"
	s eobj.RLTimeFrom=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",5)
	s eobj.RLTimeTo=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",6)
	s eobj.RLCTHospitalDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",7)
	s eobj.RLDateFrom=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",8)
	s eobj.RLDateTo=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",9)
	s eobj.RLOrderPriorityDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",10)
	
	s eobj.RLClinicType=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",12)
	
	ts
	s sc=##class(User.OECOrdCatRecLoc).%DeleteId(id)
	i $$$ISOK(sc)
	{
		tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		s ORCATDesc=$p($g(^OEC("ORCAT",$p(id,"||",1))),"^",2)
		s RLOrdLocDRDesc="",RLRecLocDRDesc=""
		s:eobj.RLOrdLocDR'="" RLOrdLocDRDesc=$p($g(^CTLOC(eobj.RLOrdLocDR)),"^",2)
		s:eobj.RLRecLocDR'="" RLRecLocDRDesc=$p($g(^CTLOC(eobj.RLRecLocDR)),"^",2)
		s DescLog=ORCATDesc_"-"_RLOrdLocDRDesc_"-"_RLRecLocDRDesc
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_OrdCatRecLoc","User.OECOrdCatRecLoc","医嘱大类接收科室",id,DescLog,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		tro
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱大类接收科室","web.DHCBL.CT.OECOrdCatRecLoc","DeleteData",eobj)
     	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.OECOrdCatRecLoc
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
	n (id)
	s str=""
	s eobj = ##class(web.Entity.CT.OECOrdCatRecLoc).%New()
	s ParRef=$p(id,"||",1)
	s ChildSub=$p(id,"||",2)
	s eobj.RLRowId=id
	s eobj.RLParRef=ParRef
	s eobj.RLRecLocDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",3)
	s eobj.RLOrdLocDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",2)
	s eobj.RLFunction=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",1)
	s eobj.RLDefaultFlag=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",4)
	s:eobj.RLDefaultFlag="Y" eobj.RLDefaultFlag="true"
	s eobj.RLTimeFrom=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",5)
	s eobj.RLTimeTo=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",6)
	s eobj.RLCTHospitalDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",7)
	s eobj.RLDateFrom=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",8)
	s eobj.RLDateTo=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",9)
	s eobj.RLOrderPriorityDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",10)
	
	s eobj.RLClinicType=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",12)
	
	s eobj.RLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateFrom)
	s eobj.RLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateTo)
	s eobj.RLTimeFrom= ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom,1)
	s eobj.RLTimeTo= ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeTo,1)
	
	s str = eobj.JsonS()	
	d eobj.%Close()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹
/// CreatDate: 2012-9-4
/// Description：查询医嘱大类接收科室的内容
/// Table：User.OECOrdCatRecLoc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.OECOrdCatRecLoc","GetList","","","")
Query GetList(rowid As %String, RecLoc As %String, OrdLoc As %String, ParRef As %String) As %Query(ROWSPEC = "RLRowId:%String,RLRecLocDesc:%String,RLOrdLocDesc:%String,RLFunction:%String,RLDefaultFlag:%String,RLTimeFrom:%String,RLTimeTo:%String,RLCTHospitalDesc:%String,RLDateFrom:%String,RLDateTo:%String,RLOrderPriorityDesc:%String,RLClinicType")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, RecLoc As %String, OrdLoc As %String, ParRef As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //rowid不为空,ParRef为空
	{
		s RLParRef=$p(rowid,"||",1)
		s ChildSub=$p(rowid,"||",2)
		s RLRowId=rowid
		s RLRecLocDR=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",3)
		s RLRecLocDesc=""
		s:RLRecLocDR'="" RLRecLocDesc=$p($g(^CTLOC(RLRecLocDR)),"^",2) //获取科室描述
		s RLOrdLocDR=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",2)
		s RLOrdLocDesc=""
		s:RLOrdLocDR'="" RLOrdLocDesc=$p($g(^CTLOC(RLOrdLocDR)),"^",2) //获取科室描述
		s RLFunction=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",1)
		s RLDefaultFlag=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",4)
		s:RLDefaultFlag="" RLDefaultFlag="N"
		s RLTimeFrom=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",5)
		s RLTimeTo=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",6)
		s RLCTHospitalDR=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",7)
		s RLCTHospitalDesc=""
		s:RLCTHospitalDR'="" RLCTHospitalDesc=$p($g(^CT("HOSP",RLCTHospitalDR)),"^",2) //获取医院描述
		s RLDateFrom=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",8)
		s RLDateTo=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",9)
		s RLOrderPriorityDR=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",10)
		s RLOrderPriorityDesc=""
		s:RLOrderPriorityDR'="" RLOrderPriorityDesc=$p($g(^OECPR(RLOrderPriorityDR)),"^",2) //获取医嘱优先级描述
		s:RLDateFrom'="" RLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(RLDateFrom) //转换日期格式
		s:RLDateTo'="" RLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(RLDateTo) //转换日期格式
		s:RLTimeFrom'="" RLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(RLTimeFrom)  //转换时间
		s:RLTimeTo'="" RLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(RLTimeTo)      //转换时间
		
		s RLClinicType=$p($g(^OEC("ORCAT",RLParRef,"RL",ChildSub)),"^",12)
		s RLClinicType=$case(RLClinicType,"O":"门诊","E":"急诊","I":"住院","H":"体检","N":"新生儿",:"")
		d OutputRow
	}
	else //rowid为空,ParRef不为空
	{
		//获取医院级授权
		//s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	
		if (ParRef)
		{
			s ChildSub=0
			f {
				s ChildSub=$o(^OEC("ORCAT",ParRef,"RL",ChildSub))
				q:ChildSub=""
				s RLRowId=ParRef_"||"_ChildSub
				
				///2020-02-15判断接收科室的所属医院
				s RLRecLocDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",3)
				s CTLOCHospitalDR=$p($g(^CTLOC(RLRecLocDR)),"^",22)
				//s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
				
				
				//筛选授权后的数据，医院级授权
				//s RLCTHospitalDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",7)
				//s strHospitalID = "{ID:"_RLCTHospitalDR_"}"
				//if ((AuHospStr[strHospitalID)||(AuHospStr=1)||(AuHospStr="off")) 
				//{
					s RLRecLocDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",3)
					s RLRecLocDesc=""
					s:RLRecLocDR'="" RLRecLocDesc=$p($g(^CTLOC(RLRecLocDR)),"^",2) //获取科室描述
					s RLOrdLocDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",2)
					s RLOrdLocDesc=""
					s:RLOrdLocDR'="" RLOrdLocDesc=$p($g(^CTLOC(RLOrdLocDR)),"^",2) //获取科室描述
					s RLFunction=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",1)
					s RLDefaultFlag=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",4)
					s:RLDefaultFlag="" RLDefaultFlag="N"
					s RLTimeFrom=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",5)
					s RLTimeTo=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",6)
					s RLCTHospitalDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",7)
					s RLCTHospitalDesc=""
					s:RLCTHospitalDR'="" RLCTHospitalDesc=$p($g(^CT("HOSP",RLCTHospitalDR)),"^",2) //获取医院描述
					s RLDateFrom=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",8)
					s RLDateTo=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",9)
					s RLOrderPriorityDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",10)
					s RLOrderPriorityDesc=""
					s:RLOrderPriorityDR'="" RLOrderPriorityDesc=$p($g(^OECPR(RLOrderPriorityDR)),"^",2) //获取医嘱优先级描述
					s:RLDateFrom'="" RLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(RLDateFrom) //转换日期格式
					s:RLDateTo'="" RLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(RLDateTo) //转换日期格式
					s:RLTimeFrom'="" RLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(RLTimeFrom)  //转换时间
					s:RLTimeTo'="" RLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(RLTimeTo)      //转换时间
					s RLClinicType=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",12)
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
    set Data=$lb(RLRowId,RLRecLocDesc,RLOrdLocDesc,RLFunction,RLDefaultFlag,RLTimeFrom,RLTimeTo,RLCTHospitalDesc,RLDateFrom,RLDateTo,RLOrderPriorityDesc,RLClinicType)
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

/// Creator：陈莹
/// CreatDate: 2016-12-12
/// Description：修改 项目上自己导入过科室数据后，在前台维护时报uniqueindex的报错
/// Table：User.OECOrdCatRecLoc
/// flag=0时 查看错误数据，flag=1时处理错误数据
/// d ##class(web.DHCBL.CT.OECOrdCatRecLoc).RepairError(0) 
/// d ##class(web.DHCBL.CT.OECOrdCatRecLoc).RepairError(1) 
ClassMethod RepairError(flag) As web.BDP.sys.String
{
	k ^TMPERRORRECLOC("ORCAT")
	s ORCATRowId=0
	f 
	{
		s ORCATRowId=$o(^OEC("ORCAT",ORCATRowId))
		q:ORCATRowId=""
		s sub=$g(^OEC("ORCAT",ORCATRowId,"RL",0))
		s realsub=$o(^OEC("ORCAT",ORCATRowId,"RL",""),-1)
		if ((realsub'="")&&(sub=""))||((realsub'="")&&(realsub>sub)&&(sub'=""))
		{
			if (flag=0) s ^TMPERRORRECLOC("ORCAT",ORCATRowId)=sub_"  "_realsub
			if (flag=1) s ^OEC("ORCAT",ORCATRowId,"RL",0)=realsub
			 
		}
	}
	if (flag=0) zw ^TMPERRORRECLOC("ORCAT")
}

/// Creator：陈莹
/// CreatDate: 2016-12-30 update20170907
/// Description：获取默认科室 （要求 对同一个病人科室 或者为空的，优先级相同时，不允许在同一个时间段内存在两个默认值）
/// Table：User.OECOrdCatRecLoc
/// Input:医嘱大类rowid,Str:优先级^开始时间^结束时间
/// w ##class(web.DHCBL.CT.OECOrdCatRecLoc).GetDefRecLoc("2,2||1,315,,^4500^8100^64539^") 
/// 0 不存在默认  1 存在默认
ClassMethod GetDefRecLoc(ParRef, RLRowId, RLOrdLocDR, Str As %String) As %String
{
	n (ParRef, RLRowId,RLOrdLocDR,Str)
	k ^TMPRECLOC("OECOrdCatRecLoc")
	if ParRef="" s ParRef=$p(RLRowId,"||",1)
	q:ParRef="" 0
	s RLOrderPriorityDR=$p(Str,"^",1),RLTimeFrom=$p(Str,"^",2),RLTimeTo=$p(Str,"^",3),RLDateFrom=$p(Str,"^",4),RLDateTo=$p(Str,"^",5),RLCTHospitalDR=$p(Str,"^",6)
	
	s RLClinicType=$p(Str,"^",7)
	
	s:RLTimeFrom'="" RLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(RLTimeFrom)
	s:RLTimeTo'="" RLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(RLTimeTo)
	s flag=0
	s n=0
	s ChildSub=0
	for
	{
		s ChildSub=$o(^OEC("ORCAT",ParRef,"RL",ChildSub)) q:(ChildSub="")
		s OrdLocDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",2)
		continue:OrdLocDR'=RLOrdLocDR
		s DefaultFlag=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",4)
		continue:(DefaultFlag'="Y")
		s OrderPriorityDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",10)
		continue:(OrderPriorityDR'=RLOrderPriorityDR)
		s TimeFrom=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",5)
		s TimeTo=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",6)
		s DateFrom=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",8)
		s DateTo=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",9)
		s CTHospitalDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",7)
		continue:(CTHospitalDR'=RLCTHospitalDR)
		s ClinicType=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",12)
		continue:((ClinicType'="")&&(RLClinicType'="")&&(ClinicType'=RLClinicType))
		
		s rowid=ParRef_"||"_ChildSub
		if (((RLRowId'="")&(RLRowId'=rowid))||(RLRowId=""))
		{
			if ('((RLDateTo="")&&(DateTo=""))||((RLDateTo'="")&&(DateFrom<=RLDateTo))||((DateTo'="")&&(RLDateFrom<=DateTo)))||((TimeFrom'="")&&(TimeTo'="")&&(RLTimeFrom'="")&&(RLTimeFrom'="")&&(((RLTimeFrom>TimeTo)&&(RLTimeTo>TimeTo))||((RLTimeFrom<TimeFrom)&&(RLTimeTo<TimeFrom))))
			{
				 continue
			}
			s flag=1 
			s n=n+1
			S ^TMPRECLOC("OECOrdCatRecLoc",ParRef,n)=ParRef_"||"_ChildSub
		}
	}
	q flag
}

}
