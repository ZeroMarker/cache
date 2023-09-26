Import SQLUser

/// 名称: 用法接收科室维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-钟荣枫
/// 编写日期: 2020-2-26
Class web.DHCBL.CT.DHCPHCInstrRecLoc Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：钟荣枫
/// CreatDate: 2020-2-26
/// Description：查询用法接收科室的内容	
/// Table：User.DHCPHCInstrRecLoc 用法接收科室
/// Input：rowid,ItemCate 医嘱子类, RecLoc 接收科室,OrdLoc 病人科室,ParRef 药品用法
/// Return：RowID,InstrOrdDep,InstrOrdDepDesc,InstrRecLoc,InstrRecLocDesc,InstrDefault,InstrOrdSubCat,InstrOrdSubCatDesc,InstrOrdPrior,InstrOrdPriorDesc,InstrTimeRange,InstrTimeFrom,InstrTimeTo,InstrHospitalDR,InstrHospitalDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCPHCInstrRecLoc","GetList","","","","","4","2")
Query GetList(rowid As %String, ItemCate As %String, RecLoc As %String, OrdLoc As %String, ParRef As %String, hospid As %String) As %Query(ROWSPEC = "RowID,InstrOrdDep,InstrOrdDepDesc,InstrRecLoc,InstrRecLocDesc,InstrDefault,InstrOrdSubCat,InstrOrdSubCatDesc,InstrOrdPrior,InstrOrdPriorDesc,InstrTimeRange,InstrTimeFrom,InstrTimeTo,InstrHospitalDR,InstrHospitalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, ItemCate As %String, RecLoc As %String, OrdLoc As %String, ParRef As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //rowid不为空,ParRef为空
	{
		s InstrRecLocParRef=$p(rowid,"||",1)
		s InstrRecLocSub=$p(rowid,"||",2)
		s RowID=rowid
		
		s InstrOrdDep=$p($g(^PHCIN(InstrRecLocParRef,"RecLoc",InstrRecLocSub)),"^",1)	//获取病人科室	
		s InstrOrdDepDesc=""
		s:InstrOrdDep'="" InstrOrdDepDesc=$p($g(^CTLOC(InstrOrdDep)),"^",2) //获取病人科室描述
		s InstrRecLoc=$p($g(^PHCIN(InstrRecLocParRef,"RecLoc",InstrRecLocSub)),"^",2)	//获取接收科室
		s InstrRecLocDesc=""
		s:InstrRecLoc'="" InstrRecLocDesc=$p($g(^CTLOC(InstrRecLoc)),"^",2) //获取接收科室描述
		s InstrDefault=$p($g(^PHCIN(InstrRecLocParRef,"RecLoc",InstrRecLocSub)),"^",3)	//默认
		//s:InstrDefault="" InstrDefault="N"
		s InstrDefault=$case(InstrDefault,"":"N","0":"N","N":"N","Y":"Y","1":"Y",:"")
		s InstrOrdSubCat=$p($g(^PHCIN(InstrRecLocParRef,"RecLoc",InstrRecLocSub)),"^",4)	//医嘱子类	
		s InstrOrdSubCatDesc=""
		s:InstrOrdSubCat'="" InstrOrdSubCatDesc=$p($g(^ARC("IC",InstrOrdSubCat)),"^",2)	//医嘱子类描述
		s InstrOrdPrior=$p($g(^PHCIN(InstrRecLocParRef,"RecLoc",InstrRecLocSub)),"^",5)	//医嘱类型
		s InstrOrdPriorDesc=""
		s:InstrOrdPrior'="" InstrOrdPriorDesc=$p($g(^OECPR(InstrOrdPrior)),"^",2) //获取医嘱类型描述
		s InstrTimeRange=$p($g(^PHCIN(InstrRecLocParRef,"RecLoc",InstrRecLocSub)),"^",6) //时间范围 eg:"01:00:00~02:00:00"
		s InstrTimeFrom=$p($g(InstrTimeRange),"~",1)	//开始时间
		s InstrTimeTo=$p($g(InstrTimeRange),"~",2)	//结束时间
		s InstrHospitalDR=$p($g(^PHCIN(InstrRecLocParRef,"RecLoc",InstrRecLocSub)),"^",7)	//医院
		s InstrHospitalDesc=""
		s:InstrHospitalDR'="" InstrHospitalDesc=$p($g(^CT("HOSP",InstrHospitalDR)),"^",2) //获取医院描述
					
		d OutputRow
	}
	else //rowid为空,ParRef不为空
	{
		if (ParRef)
		{
			
			//获取医院级授权
			//s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
			s InstrRecLocSub=0
			f {
				s InstrRecLocSub=$o(^PHCIN(ParRef,"RecLoc",InstrRecLocSub))
				q:InstrRecLocSub=""
				s RowID=ParRef_"||"_InstrRecLocSub
				
				///判断接收科室的所属医院
				s InstrRecLoc=$p($g(^PHCIN(ParRef,"RecLoc",InstrRecLocSub)),"^",2)
				//s CTLOCHospitalDR=$p($g(^CTLOC(InstrRecLoc)),"^",22)
				
				//s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
				//if ((AuHospStr[strHospitalID)||(AuHospStr=1)||(AuHospStr="off")) {		//筛选授权后的数据，医院级授权
					 
					s InstrOrdDep=$p($g(^PHCIN(ParRef,"RecLoc",InstrRecLocSub)),"^",1)	//获取病人科室	
					s InstrOrdDepDesc=""
					s:InstrOrdDep'="" InstrOrdDepDesc=$p($g(^CTLOC(InstrOrdDep)),"^",2) //获取病人科室描述
					s InstrRecLoc=$p($g(^PHCIN(ParRef,"RecLoc",InstrRecLocSub)),"^",2)	//获取接收科室
					s InstrRecLocDesc=""
					s:InstrRecLoc'="" InstrRecLocDesc=$p($g(^CTLOC(InstrRecLoc)),"^",2) //获取接收科室描述
					s InstrDefault=$p($g(^PHCIN(ParRef,"RecLoc",InstrRecLocSub)),"^",3)	//默认
					//s:InstrDefault="" InstrDefault="N"
					s InstrDefault=$case(InstrDefault,"":"N","0":"N","N":"N","Y":"Y","1":"Y",:"")
					s InstrOrdSubCat=$p($g(^PHCIN(ParRef,"RecLoc",InstrRecLocSub)),"^",4)	//医嘱子类
					if (InstrOrdSubCat'="")
					{
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat",InstrOrdSubCat,hospid)
						continue:showflag="N"
					}
						
					s InstrOrdSubCatDesc=""
					s:InstrOrdSubCat'="" InstrOrdSubCatDesc=$p($g(^ARC("IC",InstrOrdSubCat)),"^",2)	//医嘱子类描述
					
					s InstrOrdPrior=$p($g(^PHCIN(ParRef,"RecLoc",InstrRecLocSub)),"^",5)	//医嘱类型
					s InstrOrdPriorDesc=""
					s:InstrOrdPrior'="" InstrOrdPriorDesc=$p($g(^OECPR(InstrOrdPrior)),"^",2) //获取医嘱类型描述
					s InstrTimeRange=$p($g(^PHCIN(ParRef,"RecLoc",InstrRecLocSub)),"^",6) //时间范围 eg:"01:00:00~02:00:00"
					s InstrTimeFrom=$p($g(InstrTimeRange),"~",1)	//开始时间
					s InstrTimeTo=$p($g(InstrTimeRange),"~",2)	//结束时间
					s InstrHospitalDR=$p($g(^PHCIN(ParRef,"RecLoc",InstrRecLocSub)),"^",7)	//获取医院
					s InstrHospitalDesc=""
					s:InstrHospitalDR'="" InstrHospitalDesc=$p($g(^CT("HOSP",InstrHospitalDR)),"^",2) //获取医院描述
					//筛选符合条件的接收科室
					if ((InstrRecLoc=RecLoc)||(RecLoc=""))&((InstrOrdDep=OrdLoc)||(OrdLoc=""))&((InstrOrdSubCat=ItemCate)||(ItemCate=""))  
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
    set Data=$lb(RowID,InstrOrdDep,InstrOrdDepDesc,InstrRecLoc,InstrRecLocDesc,InstrDefault,InstrOrdSubCat,InstrOrdSubCatDesc,InstrOrdPrior,InstrOrdPriorDesc,InstrTimeRange,InstrTimeFrom,InstrTimeTo,InstrHospitalDR,InstrHospitalDesc)
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
/// CreatDate: 2020-2-26
/// Description：修改时打开的数据
/// Table：User.DHCPHCInstrRecLoc 用法接收科室
/// Input：id,RetFlag
/// Return：str json字符串
/// w ##class(web.DHCBL.CT.DHCPHCInstrRecLoc).OpenData("7||1","JSON")
/// RetFlag=""时，用于EXT, =JSON时，用于HISUI，不输出 "{list:["_str_"]}"  
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{
	s str=""
	s eobj = ##class(web.Entity.CT.DHCPHCInstrRecLoc).%New()
	s ParRef=$p(id,"||",1)
	s ChildSub=$p(id,"||",2)
	s eobj.RowID=id
	s eobj.InstrRecLocParRef=ParRef
	s eobj.InstrRecLocSub=ChildSub
	s eobj.InstrOrdDep=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",1)		//病人科室
	s eobj.InstrRecLoc=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",2)		//接收科室
	s eobj.InstrDefault=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",3)	//默认
	s eobj.InstrDefault=$case(eobj.InstrDefault,"Y":"true","1":"true","0":"false","N":"false","":"false",:"")
	s eobj.InstrOrdSubCat=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",4)
	s eobj.InstrOrdPrior=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",5)
	s eobj.InstrTimeRange=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",6)

	s eobj.InstrHospitalDR=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",7)
	s str = eobj.JsonS()
	d eobj.%Close()
	if (RetFlag'="JSON")	//用于HISUI，不输出 "{list:["_str_"]}"
	{
		s str = "{list:["_str_"]}"
	}
	q str
}

/// Creator：钟荣枫
/// CreatDate: 2020-2-26
/// Description：根据ID删除用法接收科室的内容
/// Table：User.DHCPHCInstrRecLoc 用法接收科室
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// w ##class(web.DHCBL.CT.DHCPHCInstrRecLoc).DeleteData("7||6")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s eobj = ##class(web.Entity.CT.DHCPHCInstrRecLoc).%New()
	s ParRef=$p(id,"||",1)
	s ChildSub=$p(id,"||",2)
	s eobj.RowID=id
	s eobj.InstrRecLocSub=ParRef
	s eobj.InstrOrdDep=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",1)		//病人科室
	s eobj.InstrRecLoc=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",2)		//接收科室
	s eobj.InstrDefault=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",3)	//默认
	s eobj.InstrDefault=$case(eobj.InstrDefault,"1":"true","0":"false",:"")
	s eobj.InstrOrdSubCat=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",4)
	s eobj.InstrOrdPrior=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",5)
	s eobj.InstrTimeRange=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",6)
	s eobj.InstrHospitalDR=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",7)
	TS
	s sc=##class(User.DHCPHCInstrRecLoc).%DeleteId(id)
	i $$$ISOK(sc)	//成功
	{
		TC
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		s RecLocDesc = $p($g(^CTLOC(eobj.InstrRecLoc)),"^",2)
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHCInstrRecLoc","User.DHCPHCInstrRecLoc","用法接收科室",id,RecLocDesc,"D",eobj)
		d eobj.%Close()
	}
	else 	//失败
	{
		TRO
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("用法接收科室","web.DHCBL.CT.DHCPHCInstrRecLoc","DeleteData",eobj)
    	s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator：钟荣枫
/// CreatDate: 2020-2-26
/// Description：获取默认科室 （要求 对同一个病人科室 或者为空的，优先级相同时，不允许在同一个时间段内存在两个默认值）
/// Table：User.DHCPHCInstrRecLoc
/// Input:ParRef,RowID,OrdDep,OrdPrior  Str:优先级^时间范围^医院^updateflag=1是把默认更新成N
/// Return：0 不存在默认  1 存在默认
/// w ##class(web.DHCBL.CT.DHCPHCInstrRecLoc).GetDefRecLoc("1","","4","25","^^2^") 
ClassMethod GetDefRecLoc(ParRef, RowID, InstrOrdDep, InstrOrdSubCat, Str As %String, updateflag As %String = "") As %String
{
	//药品用法为空
	if ParRef="" s ParRef=$p(RowID,"||",1)	
	q:ParRef="" 0
	s InstrOrdPrior=$p(Str,"^",1),InstrTimeRange=$p(Str,"^",2)
	s InstrHospitalDR=$p(Str,"^",3)
	s updateflag=$p(Str,"^",4)
	s InstrTimeFrom=$p(InstrTimeRange,"~",1)
	s InstrTimeTo=$p(InstrTimeRange,"~",2)
	s flag=0
	
	if InstrOrdDep'=""  //病人科室不为空时，判断病人科室对应的医院 是否有这个医嘱子分类的权限
	{
		s OrdLocHospitalDR=$p($g(^CTLOC(InstrOrdDep)),"^",22)     //病人科室所在医院
		s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat",InstrOrdSubCat,OrdLocHospitalDR)
		if (showflag="N") //病人科室对应的医院 没有这个医嘱子分类的权限时返回2
		{
			s flag=2
			q flag	
		}
		
	}
	
	s ChildSub=0
	for
	{
		s ChildSub=$o(^PHCIN(ParRef,"RecLoc",ChildSub)) q:(ChildSub="")
				
		s OrdLocDR=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",1)	//病人科室
		continue:(OrdLocDR'=InstrOrdDep)
		s Default=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",3)	//默认
		continue:(Default'="1")
		s OrdSubCat=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",4)	//医嘱子类
		continue:(OrdSubCat'=InstrOrdSubCat)
		s OrdPrior=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",5)	//医嘱优先级
		continue:(OrdPrior'=InstrOrdPrior)
		s TimeRange=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",6)	//时间范围
		
		s TimeFrom=$p(TimeRange,"~",1)
		s TimeTo=$p(TimeRange,"~",2)
		s HospitalDR=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",7)	//医院
		continue:(HospitalDR'=InstrHospitalDR)
		s rowid=ParRef_"||"_ChildSub
		if (((RowID'="")&(RowID'=rowid))||(RowID=""))	//新增数据
		{
			if ('((TimeFrom<=InstrTimeTo)&&(TimeTo>=InstrTimeFrom)))	//时间有交叉
			{
				 continue
			}
			s flag=1 
			if (updateflag=1)		//需要修改默认
			{
				
				s rowid=ParRef_"||"_ChildSub
				s updobj=##class(User.DHCPHCInstrRecLoc).%OpenId(rowid)
				s updateeobj=##class(web.Entity.CT.DHCPHCInstrRecLoc).%New() //修改前
				s updateeobj.RowID=rowid
				s updateeobj.InstrRecLocParRef=ParRef
				
				s updateeobj.InstrRecLoc = updobj.InstrRecLoc 
				s updateeobj.InstrOrdDep = updobj.InstrOrdDep
				
				s updateeobj.InstrDefault = updobj.InstrDefault
				s updateeobj.InstrOrdSubCat = updobj.InstrOrdSubCat
				s updateeobj.InstrOrdPrior = updobj.InstrOrdPrior 
				s updateeobj.InstrTimeRange = updobj.InstrTimeRange

				s updateeobj.InstrHospitalDR = updobj.InstrHospitalDR 
				
				s updatebobj=##class(web.Entity.CT.DHCPHCInstrRecLoc).%New()   //修改后
				s updatebobj.RowID=rowid
				s updatebobj.InstrRecLocParRef=ParRef
				s updatebobj.InstrRecLoc = updobj.InstrRecLoc
				s updatebobj.InstrOrdDep = updobj.InstrOrdDep 
				s updatebobj.InstrDefault = "0"
				s updatebobj.InstrOrdSubCat = updobj.InstrOrdSubCat 
				s updatebobj.InstrOrdPrior = updobj.InstrOrdPrior 
				s updatebobj.InstrTimeRange = updobj.InstrTimeRange
				s updatebobj.InstrHospitalDR = updobj.InstrHospitalDR 
				
		        s updobj.InstrDefault =updatebobj.InstrDefault
				s sc=updobj.%Save()
				d updobj.%Close()
				If $$$ISOK(sc)	//保存成功
				{
					//保存日志
					s RecLocDesc = $p($g(^CTLOC(updateeobj.InstrRecLoc)),"^",2)
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHCInstrRecLoc","User.DHCPHCInstrRecLoc","用法接收科室",rowid,RecLocDesc,"U",updateeobj,updatebobj)
				}
			}
		}
	}			
				
	q flag
}

/// Creator：钟荣枫
/// CreatDate: 2020-2-26
/// Description：数据重复验证方法
/// Table：User.DHCPHCInstrRecLoc
/// Input：id, OrdLocDR, RecLocDR,OrdSubCatDR,Str
/// Return："1"(数据重复),"0"(数据不重复)
/// Other: W ##class(web.DHCBL.CT.DHCPHCInstrRecLoc).FormValidate("1||2","","4","243","25","^^2")
ClassMethod FormValidate(id As %String, ParRef As %String, OrdLocDR As %String, RecLocDR As %String, OrdSubCatDR As %String, Str As %String) As %String
{
	q:(id="")&&(ParRef="") 0
	if ParRef="" s ParRef=$p(id,"||",1)		//药品用法为空
	s InstrOrdPrior=$p(Str,"^",1),InstrTimeRange=$p(Str,"^",2),InstrHospitalDR=$p(Str,"^",3)
	s InstrTimeFrom=$p(InstrTimeRange,"~",1)
	s InstrTimeTo=$p(InstrTimeRange,"~",2)
	s flag=0
	
	if ((OrdLocDR'="")&&(OrdSubCatDR'=""))  //病人科室不为空时，判断病人科室对应的医院 是否有这个医嘱子分类的权限
	{
		s OrdLocHospitalDR=$p($g(^CTLOC(OrdLocDR)),"^",22)     //病人科室所在医院
		s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat",OrdSubCatDR,OrdLocHospitalDR)
		if (showflag="N") //病人科室对应的医院 没有这个医嘱子分类的权限时返回2
		{
			s flag=2
			q flag	
		}
		
	}
	
	s ChildSub=0
	for
	{
		
		s ChildSub=$o(^PHCIN(ParRef,"RecLoc",ChildSub)) q:(ChildSub="")||(flag'=0)
		
		s OrdDep=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",1)
		continue:(OrdLocDR'=OrdDep)
		s RecLoc=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",2)
		continue:(RecLocDR'=RecLoc)
		s OrdSubCat=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",4)
		continue:(OrdSubCatDR'=OrdSubCat)
		
		s OrdPrior=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",5)
		continue:(InstrOrdPrior'=OrdPrior)
		s TimeRange=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",6)
		
		s TimeFrom=$p(TimeRange,"~",1)
		s TimeTo=$p(TimeRange,"~",2)
		s HospitalDR=$p($g(^PHCIN(ParRef,"RecLoc",ChildSub)),"^",7)
		continue:(InstrHospitalDR'=HospitalDR)
		s Pid=ParRef_"||"_ChildSub
		if ((id="")||((id'="")&&(Pid'=id)))	//新增数据
		{
			if (InstrTimeRange'="~")&&(TimeRange'="~")	//时间范围不为空
			{
				if ((TimeFrom<=InstrTimeTo)&&(TimeTo>=InstrTimeFrom))	//时间交叉
				{
					s flag=1  
					q
				}
			}
			else		//时间范围为空
			{
				s flag=1  //返回重复标志
				q	
			}
		}
		else	//修改
		{
			s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator：钟荣枫
/// CreatDate: 2020-2-26
/// Description：保存修改用法接收科室的内容
/// Table：User.DHCPHCInstrRecLoc 用法接收科室
/// Input：web.Entity.CT.DHCPHCInstrRecLoc 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.DHCPHCInstrRecLoc).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCPHCInstrRecLoc) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		if eobj.RowID'="" s eobj.InstrRecLocParRef=$p(eobj.RowID,"||",1)	//获取药品用法
		////药品用法为空
		if (eobj.InstrRecLocParRef="") q "{success:'false',errorinfo:'父表指针有误，请确认！'}"
		s eobj.InstrDefault=$case(eobj.InstrDefault,"":"0","N":"0","0":"0","Y":"1","1":"1",:"")		
		s InstrOrdSubCatDesc=""
		s:eobj.InstrOrdSubCat'="" InstrOrdSubCatDesc = $p($g(^ARC("IC",eobj.InstrOrdSubCat)),"^",2)	//获取医嘱子类描述
		s InstrOrdDepDesc=""
		s InstrRecLocDesc=""
		s InstructDesc=$p($g(^PHCIN(eobj.InstrRecLocParRef)),"^",2)		//用法描述
		s:eobj.InstrRecLoc'="" InstrRecLocDesc=$p($g(^CTLOC(eobj.InstrRecLoc)),"^",2) //获取接收科室描述
		s:eobj.InstrOrdDep'="" InstrOrdDepDesc=$p($g(^CTLOC(eobj.InstrOrdDep)),"^",2) //获取病人科室描述
		s str=eobj.InstrOrdPrior_"^"_eobj.InstrTimeRange_"^"_eobj.InstrHospitalDR
		s flag=##class(web.DHCBL.CT.DHCPHCInstrRecLoc).FormValidate(eobj.RowID,eobj.InstrRecLocParRef,eobj.InstrOrdDep,eobj.InstrRecLoc,eobj.InstrOrdSubCat,str)  //调用重复验证
		
		if (flag=1)	//判断重复
		{
			s result = "{success:'false',errorinfo:'与另一条相同接收科室记录的时间冲突，请确认！',InstructDesc:'"_InstructDesc_"',InstrOrdSubCatDesc:'"_InstrOrdSubCatDesc_"',InstrOrdDepDesc:'"_InstrOrdDepDesc_"',InstrRecLocDesc:'"_InstrRecLocDesc_"'}"
		}
		elseif (flag=2)	//医嘱子类所在医院组和病人科室所在医院组不同
		{
			
			s result = "{success:'false',errorinfo:'医嘱子类与病人科室不在同一个医院组，请确认！',InstructDesc:'"_InstructDesc_"',InstrOrdSubCatDesc:'"_InstrOrdSubCatDesc_"',InstrOrdDepDesc:'"_InstrOrdDepDesc_"',InstrRecLocDesc:'"_InstrRecLocDesc_"'}"

		}
		else	//不重复
		{
			///增加默认接收科室时，把同一个病人科室的其他的默认科室改成不默认
			if (eobj.InstrDefault="1")	//是默认
			{
				s rese= ##class(web.DHCBL.CT.DHCPHCInstrRecLoc).GetDefRecLoc(eobj.InstrRecLocParRef,eobj.RowID,eobj.InstrOrdDep,eobj.InstrOrdSubCat,str_"^1")
			}
			if (eobj.RowID="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCPHCInstrRecLoc).%New(eobj.InstrRecLocParRef)
			}
			else                  //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCPHCInstrRecLoc).%OpenId(eobj.RowID)
				s bobj=##class(web.Entity.CT.DHCPHCInstrRecLoc).%New()
				s bobj.RowID=eobj.RowID
				s bobj.InstrRecLocParRef=$p(eobj.RowID,"||",1)
			
				s bobj.InstrRecLoc = obj.InstrRecLoc 
				s bobj.InstrOrdDep = obj.InstrOrdDep
				s bobj.InstrDefault = obj.InstrDefault
				s bobj.InstrOrdSubCat = obj.InstrOrdSubCat 
				s bobj.InstrOrdPrior = obj.InstrOrdPrior 
				s bobj.InstrTimeRange = obj.InstrTimeRange
				s bobj.InstrHospitalDR = obj.InstrHospitalDR 
			}
			s obj.InstrRecLocParRef = eobj.InstrRecLocParRef
			s obj.InstrRecLoc = eobj.InstrRecLoc	//接收科室
			s obj.InstrOrdDep = eobj.InstrOrdDep	//病人科室
			s obj.InstrOrdSubCat = eobj.InstrOrdSubCat	//医嘱子类
			s obj.InstrDefault = eobj.InstrDefault				//默认
			
			s obj.InstrTimeRange = eobj.InstrTimeRange			//时间范围
			
			s obj.InstrHospitalDR = eobj.InstrHospitalDR		//医院
			s obj.InstrOrdPrior = eobj.InstrOrdPrior			//医嘱类型
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"',InstructDesc:'"_InstructDesc_"',InstrOrdSubCatDesc:'"_InstrOrdSubCatDesc_"',InstrOrdDepDesc:'"_InstrOrdDepDesc_"',InstrRecLocDesc:'"_InstrRecLocDesc_"'}"      
				//保存日志
				s RecLocDesc = $p($g(^CTLOC(eobj.InstrRecLoc)),"^",2)
				d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHCInstrRecLoc","User.DHCPHCInstrRecLoc","用法接收科室",id,RecLocDesc,"A",eobj)
				d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHCInstrRecLoc","User.DHCPHCInstrRecLoc","用法接收科室",eobj.RowID,RecLocDesc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("用法接收科室","web.DHCBL.CT.DHCPHCInstrRecLoc","SaveEntity",eobj)
    			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"',InstructDesc:'"_InstructDesc_"',InstrOrdSubCatDesc:'"_InstrOrdSubCatDesc_"',InstrOrdDepDesc:'"_InstrOrdDepDesc_"',InstrRecLocDesc:'"_InstrRecLocDesc_"'}"  //返回错误信息
			}
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Function: 获取父表药品用法的描述
/// CreateDate:2020-3-11
/// Creator:钟荣枫
/// Input：ParentId 药品用法的id
/// Return：药品用法的描述
/// Debug: w ##class(web.DHCBL.CT.DHCPHCInstrRecLoc).GetParentDesc("1")
ClassMethod GetParentDesc(ParentId As %String) As %String
{
   s result=""
   s result=$p($g(^PHCIN(ParentId)),"^",2)		//用法描述
   
   q result
}

/// Creator：钟荣枫
/// CreatDate: 2020-4-10
/// Description：根据药品用法id删除其下所有接收科室数据
/// Table：User.DHCPHCInstrRecLoc 药品用法接收科室
/// Input：ParentID 药品用法id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// w ##class(web.DHCBL.CT.DHCPHCInstrRecLoc).DeleteAllData("10")
ClassMethod DeleteAllData(ParentID As %String) As %String
{
	s result=""
	s flag=$d(^PHCIN(ParentID))
	if (flag>0)		//药品用法存在
	{
		s ChildSub=0
		for {
			s ChildSub=$o(^PHCIN(ParentID,"RecLoc",ChildSub))
			q:ChildSub=""
			s RowID=ParentID_"||"_ChildSub
			d ..DeleteData(RowID)
		}
		s result="{success:'true',info:'删除成功！'}" 
	}
	else	//药品用法不存在
	{
		s result = "{success:'false',info:'该药品用法不存在!'}"  //返回错误信息
	}
	
	q result
}

}
