Import SQLUser

/// 名称: 接收科室查询功能
/// 描述: 医嘱大类、医嘱子分类、医嘱项关联的接收科室都显示出来
/// 编写者：基础数据平台组-谷雪萍、陈莹
/// 编写日期: 2016-6-13
Class web.DHCBL.CT.RecLocSelect Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：谷雪萍
/// CreatDate: 2016-6-13
/// Description：查询医嘱大类、医嘱子分类、医嘱项接收科室的内容
/// Table：User.ARCItemCatRecLoc，User.ARCItemCatRecLoc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RecLocSelect","GetList","AM","","","11550||1","3")
Query GetList(objecttype As %String, RecLoc As %String, OrdLoc As %String, ParRef As %String, hospid As %String) As %Query(ROWSPEC = "RLRowId:%String,RLRecLocDesc:%String,RLOrdLocDesc:%String,RLFunction:%String,RLDefaultFlag:%String,RLTimeFrom:%String,RLTimeTo:%String,RLCTHospitalDesc:%String,RLDateFrom:%String,RLDateTo:%String,RLOrderPriorityDesc:%String,ARCICDesc:%String,ParRefType:%String,RLParRef,ARCICCode,RLClinicType")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, objecttype As %String, RecLoc As %String, OrdLoc As %String, ParRef As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	k ^TMPACCOUNT
	k ^TMPOCCOUNT
	k ^TMPAMCOUNT
	
	s count=0
	if (objecttype="AC")
	{
		s ParRefType="医嘱子分类"
		//获取医院级授权
		//s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
		s ARCICRowId=0
		for
		{
			s ARCICRowId=$o(^ARC("IC",ARCICRowId))
			q:ARCICRowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat",ARCICRowId,hospid)
			continue:showflag="N"
			if (ParRef=ARCICRowId)||(ParRef="")
			{
				s ChildSub=0
				for 
				{
					s ChildSub=$o(^ARC("IC",ARCICRowId,"RL",ChildSub))
					q:ChildSub=""
					s RLRowId=ARCICRowId_"||"_ChildSub
					//筛选授权后的数据，医院级授权
					//s RLCTHospitalDR=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",7)
					//s strHospitalID = "{ID:"_RLCTHospitalDR_"}"
					//if ((AuHospStr[strHospitalID)||(AuHospStr=1)||(AuHospStr="off")) 
					//{
						
						s ARCICCode=$p($g(^ARC("IC",ARCICRowId)),"^",1) //医嘱子分类代码
						s ARCICDesc=$p($g(^ARC("IC",ARCICRowId)),"^",2) //医嘱子分类
						s RLParRef=ARCICRowId
						s RLRecLocDR=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",3)
						s RLRecLocDesc=""
						s:RLRecLocDR'="" RLRecLocDesc=$p($g(^CTLOC(RLRecLocDR)),"^",2) //获取接收科室描述
				
						s RLOrdLocDR=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",2)
						
						s RLOrdLocDesc=""
						s:RLOrdLocDR'="" RLOrdLocDesc=$p($g(^CTLOC(RLOrdLocDR)),"^",2) //获取病人科室描述
				
						s RLFunction=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",1)
						s RLDefaultFlag=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",4)
						s:RLDefaultFlag="" RLDefaultFlag="N"
						s RLTimeFrom=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",5)
						s RLTimeTo=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",6)
						s RLCTHospitalDR=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",7)
						s RLCTHospitalDesc=""
						s:RLCTHospitalDR'="" RLCTHospitalDesc=$p($g(^CT("HOSP",RLCTHospitalDR)),"^",2) //获取医院描述
						s RLDateFrom=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",8)
						s RLDateTo=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",9)
						s RLOrderPriorityDR=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",10)
						s RLOrderPriorityDesc=""
						s:RLOrderPriorityDR'="" RLOrderPriorityDesc=$p($g(^OECPR(RLOrderPriorityDR)),"^",2) //获取医嘱优先级描述
						s:RLDateFrom'="" RLDateFrom=$zd(RLDateFrom,1) //转换日期格式
						s:RLDateTo'="" RLDateTo=$zd(RLDateTo,1) //转换日期格式
						s:RLTimeFrom'="" RLTimeFrom=$zt(RLTimeFrom,1)  //转换时间
						s:RLTimeTo'="" RLTimeTo=$zt(RLTimeTo,1)      //转换时间
						
						s RLClinicType=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",12)		//就诊类型
						s RLClinicType=$case(RLClinicType,"O":"门诊","E":"急诊","I":"住院","H":"体检","N":"新生儿",:"")
		
		
						i ((RLRecLocDR=RecLoc)||(RecLoc=""))&((RLOrdLocDR=OrdLoc)||(OrdLoc=""))
						{
							s count=count+1
							s ^TMPACCOUNT(count)=RLRowId
							d OutputRow
						}
					//}
				}
			}
		}
	}
	
	if (objecttype="OC")
	{
		s ParRefType="医嘱大类"
		//获取医院级授权
		//s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
		s ARCICRowId=0
		for
		{
			s ARCICRowId=$o(^OEC("ORCAT",ARCICRowId))
			q:ARCICRowId=""			
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("OEC_OrderCategory",ARCICRowId,hospid)
			continue:showflag="N"
			s ARCICCode=$p($g(^OEC("ORCAT",ARCICRowId)),"^",1)	//医嘱大类代码
			s ARCICDesc=$p($g(^OEC("ORCAT",ARCICRowId)),"^",2) //医嘱大类描述
			if (ParRef=ARCICRowId)||(ParRef="")
			{
				s ChildSub=0
				for
				{
					s ChildSub=$o(^OEC("ORCAT",ARCICRowId,"RL",ChildSub))
					q:ChildSub=""
					s RLRowId=ARCICRowId_"||"_ChildSub
					//筛选授权后的数据，医院级授权
					//s RLCTHospitalDR=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",7)
					//s strHospitalID = "{ID:"_RLCTHospitalDR_"}"
					//if ((AuHospStr[strHospitalID)||(AuHospStr=1)||(AuHospStr="off")) 
					//{
						
						s RLRecLocDR=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",3)
						s RLParRef=ARCICRowId
					
						s RLRecLocDesc=""
						s:RLRecLocDR'="" RLRecLocDesc=$p($g(^CTLOC(RLRecLocDR)),"^",2) //获取科室描述
						s RLOrdLocDR=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",2)
						s RLOrdLocDesc=""
						s:RLOrdLocDR'="" RLOrdLocDesc=$p($g(^CTLOC(RLOrdLocDR)),"^",2) //获取科室描述
						s RLFunction=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",1)
						s RLDefaultFlag=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",4)
						s:RLDefaultFlag="" RLDefaultFlag="N"
						s RLTimeFrom=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",5)
						s RLTimeTo=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",6)
						s RLCTHospitalDR=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",7)
						s RLCTHospitalDesc=""
						s:RLCTHospitalDR'="" RLCTHospitalDesc=$p($g(^CT("HOSP",RLCTHospitalDR)),"^",2) //获取医院描述
						s RLDateFrom=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",8)
						s RLDateTo=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",9)
						s RLOrderPriorityDR=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",10)
						s RLOrderPriorityDesc=""
						s:RLOrderPriorityDR'="" RLOrderPriorityDesc=$p($g(^OECPR(RLOrderPriorityDR)),"^",2) //获取医嘱优先级描述
						s:RLDateFrom'="" RLDateFrom=$zd(RLDateFrom,1) //转换日期格式
						s:RLDateTo'="" RLDateTo=$zd(RLDateTo,1) //转换日期格式
						s:RLTimeFrom'="" RLTimeFrom=$zt(RLTimeFrom,1)  //转换时间
						s:RLTimeTo'="" RLTimeTo=$zt(RLTimeTo,1)      //转换时间
						s RLClinicType=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",12)
						s RLClinicType=$case(RLClinicType,"O":"门诊","E":"急诊","I":"住院","H":"体检","N":"新生儿",:"")
		
		
						i ((RLRecLocDR=RecLoc)||(RecLoc=""))&((RLOrdLocDR=OrdLoc)||(OrdLoc=""))
						{
							s count=count+1
							s ^TMPOCCOUNT(count)=RLRowId
							d OutputRow
						}
					//}
				}
			}
		}
	}
	if ((objecttype="AM")||(objecttype=""))
	{
		 s ParRefType="医嘱项"
		 s parref=0
		 for
		 {
			 s parref=$o(^ARCIM(parref)) q:(parref="")
			 
			 s ARCIMVersion=0
			 for 
			 {
				s ARCIMVersion=$o(^ARCIM(parref,ARCIMVersion))
				q:(ARCIMVersion="")
				s ARCIMRowId=parref_"||"_ARCIMVersion
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast",ARCIMRowId,hospid)
				continue:showflag="N" 
				s ARCICCode=$p($g(^ARCIM(parref,ARCIMVersion,1)),"^",1)	//医嘱项代码
				s ARCICDesc=$p($g(^ARCIM(parref,ARCIMVersion,1)),"^",2)  //医嘱项
			 
				 if (ParRef=ARCIMRowId)||(ParRef="")
				 {
					s RLParRef=ARCIMRowId
					s rowid=0
					for
					{  
						 s rowid=$o(^ARCRL(parref,rowid))
						 q:rowid=""  
						 s RLRowId=parref_"||"_rowid
						  
						 s RLOrdLocDR=$p($g(^ARCRL(parref,rowid)),"^",1)
						 
						 s RLOrdLocDesc=""
						 s:RLOrdLocDR'="" RLOrdLocDesc=$p($g(^CTLOC(RLOrdLocDR)),"^",2) //获取科室描述
						 s RLRecLocDR=$p($g(^ARCRL(parref,rowid)),"^",2)
						 s RLRecLocDesc=""
						 s:RLRecLocDR'="" RLRecLocDesc=$p($g(^CTLOC(RLRecLocDR)),"^",2) //获取科室描述
						 
						 s RLFunction=$p($g(^ARCRL(parref,rowid)),"^",3)  //功能
						 s RLCTHospitalDR=$p($g(^ARCRL(parref,rowid)),"^",7) 
						 s RLCTHospitalDesc=""
						 s:RLCTHospitalDR'="" RLCTHospitalDesc=$p($g(^CT("HOSP",RLCTHospitalDR)),"^",2) //获取医院描述

						 s RLOrderPriorityDR=$p($g(^ARCRL(parref,rowid)),"^",10)
						 s RLOrderPriorityDesc=""
						 s:RLOrderPriorityDR'="" RLOrderPriorityDesc=$p($g(^OECPR(RLOrderPriorityDR)),"^",2) //系统医嘱优先级描述
						 s RLDefaultFlag=$p($g(^ARCRL(parref,rowid)),"^",4)
						 s:RLDefaultFlag="" RLDefaultFlag="N"
						 s RLDateFrom=$p($g(^ARCRL(parref,rowid)),"^",8)
						 s RLDateTo=$p($g(^ARCRL(parref,rowid)),"^",9)
						 s:RLDateFrom'="" RLDateFrom=$zd(RLDateFrom,1) //转换日期格式
						 s:RLDateTo'="" RLDateTo=$zd(RLDateTo,1) //转换日期格式
						 s RLTimeFrom=$p($g(^ARCRL(parref,rowid)),"^",5)
						 s RLTimeTo=$p($g(^ARCRL(parref,rowid)),"^",6)
						 s:RLTimeFrom'="" RLTimeFrom=$zt(RLTimeFrom,1)  //转换时间
						 s:RLTimeTo'="" RLTimeTo=$zt(RLTimeTo,1)      //转换时间
		
						s RLClinicType=$p($g(^ARCRL(parref,rowid)),"^",12)
						s RLClinicType=$case(RLClinicType,"O":"门诊","E":"急诊","I":"住院","H":"体检","N":"新生儿",:"")
	
						 i ((RLRecLocDR=RecLoc)||(RecLoc=""))&((RLOrdLocDR=OrdLoc)||(OrdLoc=""))
						 {
							 s count=count+1
							s ^TMPAMCOUNT(count)=RLRowId
							d OutputRow
						 }
					}
				}
			}	
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RLRowId,RLRecLocDesc,RLOrdLocDesc,RLFunction,RLDefaultFlag,RLTimeFrom,RLTimeTo,RLCTHospitalDesc,RLDateFrom,RLDateTo,RLOrderPriorityDesc,ARCICDesc,ParRefType,RLParRef,ARCICCode,RLClinicType)
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

/// Creator：谷雪萍
/// CreatDate: 2016-6-14
/// Description：医嘱大类、医嘱子分类、医嘱项
/// Table：
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPPreferences","GetPre","G","")
Query GetPre(objecttype As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "RowId:%String,Desc:%String")
{
}

ClassMethod GetPreExecute(ByRef qHandle As %Binary, objecttype As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (objecttype="AC")   //医嘱子分类
	{
		s RowId=0
		for
		{
			s RowId=$o(^ARC("IC",RowId)) q:RowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat",RowId,hospid)
			continue:showflag="N" 
			s Desc=$p($g(^ARC("IC",RowId)),"^",2)
			
			s PINYINCODE=""
			if (desc'="")
			{
				s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
			}
			i ($ZCONVERT(Desc,"U")[$ZCONVERT(desc,"U"))||(PINYINCODE[$ZCONVERT(desc,"U"))
			{
				d OutputRowPre
			}
		}
	}
	elseif (objecttype="OC")  //医嘱大类
	{
		s RowId=0
		for
		{
			s RowId=$o(^OEC("ORCAT",RowId)) q:RowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("OEC_OrderCategory",RowId,hospid)
			continue:showflag="N" 
			s Desc=$p($g(^OEC("ORCAT",RowId)),"^",2)
			
			s PINYINCODE=""
			if (desc'="")
			{
				s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
			}
			i ($ZCONVERT(Desc,"U")[$ZCONVERT(desc,"U"))||(PINYINCODE[$ZCONVERT(desc,"U"))
			{
				d OutputRowPre
			}
		}
	}
	elseif ((objecttype="AM")||(objecttype=""))  //医嘱项
	{
		s ARCIMSubscript=0
		for
		{
		  s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:(ARCIMSubscript="")
		  s ARCIMVersion=0
		  for 
		  {
			s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))
			q:(ARCIMVersion="")
				
			s RowId=ARCIMSubscript_"||"_ARCIMVersion
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast",RowId,hospid)
			continue:showflag="N" 
			s Desc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
			
			s PINYINCODE=""
			if (desc'="")
			{
				s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
			}
			i ($ZCONVERT(Desc,"U")[$ZCONVERT(desc,"U"))||(PINYINCODE[$ZCONVERT(desc,"U"))
			{
				d OutputRowPre	
			}
		
		  }
		}
 	}
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPre
    set Data=$lb(RowId,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPreExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPreExecute ]
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

/// w ##class(web.DHCBL.CT.RecLocSelect).GetTitle()
ClassMethod GetTitle(table As %String) As %String
{
	s str=""
	if (table="AM")
	{
		s str="医嘱项医院&%医嘱代码&%医嘱名称&%病人科室所属医院&%病人科室&%接收科室所属医院&%接收科室&%医嘱优先级&%开始日期&%结束日期&%开始时间&%结束时间&%默认接收科室（Y/N）&%就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)"
		s str=str_"^LinkHospId&%ARCIMCode&%ARCIMDesc&%ARCRLCTHospitalDR&%ARCRLOrdLocDR&%ARCRLRecLocHospDR&%ARCRLRecLocDR&%ARCRLOrderPriorityDR&%ARCRLDateFrom&%ARCRLDateTo&%ARCRLTimeFrom&%ARCRLTimeTo&%ARCRLDefaultFlag&%ARCRLClinicType"

	}
	if (table="OC")
	{
		s str="医嘱大类所属医院&%医嘱大类代码&%医嘱大类名称&%病人科室医院&%病人科室&%接收科室医院&%接收科室&%功能(Execute,Processing)&%默认(Y/N)&%开始时间&%结束时间&%医院&%开始日期&%结束日期&%医嘱优先级&%就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)"
		s str=str_"^LinkHospId&%ORCATCode&%ORCATDesc&%RLOrdLocDRHosp&%RLOrdLocDR&%RLRecLocDRHosp&%RLRecLocDR&%RLFunction&%RLDefaultFlag&%RLTimeFrom&%RLTimeTo&%RLCTHospitalDR&%RLDateFrom&%RLDateTo&%RLOrderPriorityDR&%RLClinicType"
	}
	if (table="AC")
	{

		s str="医嘱子分类所属医院&%医嘱子类代码&%医嘱子类名称&%病人科室医院&%病人科室&%接收科室医院&%接收科室&%功能(Execute,Processing)&%默认&%开始时间&%结束时间&%医院&%开始日期&%结束日期&%医嘱优先级&%就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)"
		s str=str_"^LinkHospId&%ARCICCode&%ARCICDesc&%RLOrdLocDRHosp&%RLOrdLocDR&%RLRecLocDRHosp&%RLRecLocDR&%RLFunction&%RLDefaultFlag&%RLTimeFrom&%RLTimeTo&%RLCTHospitalDR&%RLDateFrom&%RLDateTo&%RLOrderPriorityDR&%RLClinicType"
	}

	q str
}

/// w ##class(web.DHCBL.CT.RecLocSelect).GetCount("SS_User")
ClassMethod GetCount(table) As %String
{
	s rs=""
	if (table="AM")
	{
		s rs=##class(web.DHCBL.CT.RecLocSelect).GetAMCount(1)
	}
	if (table="OC")
	{
		s rs=##class(web.DHCBL.CT.RecLocSelect).GetOCCount(1)
	}
	
	if (table="AC")
	{
		s rs=##class(web.DHCBL.CT.RecLocSelect).GetACCount(1)
	}
	q rs
}

/// w ##class(web.DHCBL.CT.RecLocSelect).GetName("SS_User")
ClassMethod GetName(table) As %String
{
	s rs=""
	if (table="AM")
	{
		s rs="医嘱项"
	}
	if (table="OC")
	{
		s rs="医嘱大类"
	}
	
	if (table="AC")
	{
		s rs="医嘱子分类"
	}
	q rs
}

/// w ##class(web.DHCBL.CT.RecLocSelect).GetInfo("SS_User",3)
ClassMethod GetInfo(table, i) As %String
{
	s rs=""
	if (table="AM")
	{
		s rs=##class(web.DHCBL.CT.RecLocSelect).GetAMInfo(i)
	}
	if (table="OC")
	{
		s rs=##class(web.DHCBL.CT.RecLocSelect).GetOCInfo(i)
	}
	
	if (table="AC")
	{
		s rs=##class(web.DHCBL.CT.RecLocSelect).GetACInfo(i)
	}
	q rs
}

/// w ##class(web.DHCBL.CT.RecLocSelect).GetAMCount()
ClassMethod GetAMCount(searchflag = "") As %String
{
	s count=0
	if (searchflag'="")		//根据查询条件来导出
	{
		s count=$o(^TMPAMCOUNT(""),-1)
	}
	else
	{
		k ^TMPAMCOUNT	
		s parref=0
		for
		{
			s parref=$o(^ARCIM(parref)) q:(parref="")
			s rowid=0
			for
			{  
				 s rowid=$o(^ARCRL(parref,rowid))
				 q:rowid=""  
				 s RLRowId=parref_"||"_rowid
				 s count=count+1
				 s ^TMPAMCOUNT(count)=RLRowId
			}
			
		}
		
	}
	q count
}

/// w ##class(web.DHCBL.CT.RecLocSelect).GetOCCount()
ClassMethod GetOCCount(searchflag = "") As %String
{
		
	s count=0
	if (searchflag'="")		//根据查询条件来导出
	{
		s count=$o(^TMPOCCOUNT(""),-1)
	}
	else
	{
		k ^TMPOCCOUNT
		s ARCICRowId=0
		for
		{
			s ARCICRowId=$o(^OEC("ORCAT",ARCICRowId))
			q:ARCICRowId=""			
			s ChildSub=0
			for
			{
				s ChildSub=$o(^OEC("ORCAT",ARCICRowId,"RL",ChildSub))
				q:ChildSub=""
				s RLRowId=ARCICRowId_"||"_ChildSub
				s count=count+1
				s ^TMPOCCOUNT(count)=RLRowId
			}
		}
	}
	
	q count
}

/// w ##class(web.DHCBL.CT.RecLocSelect).GetACCount()
ClassMethod GetACCount(searchflag = "") As %String
{
	s count=0
	if (searchflag'="")		//根据查询条件来导出
	{
		s count=$o(^TMPACCOUNT(""),-1)
	}
	else
	{
		k ^TMPACCOUNT
		s ARCICRowId=0
		for
		{
			s ARCICRowId=$o(^ARC("IC",ARCICRowId))
			q:ARCICRowId=""			
			s ChildSub=0
			for
			{
				s ChildSub=$o(^ARC("IC",ARCICRowId,"RL",ChildSub))
				q:ChildSub=""
				s RLRowId=ARCICRowId_"||"_ChildSub
				s count=count+1
				s ^TMPACCOUNT(count)=RLRowId
			}
		}
	}
	
	q count
}

/// Creator：钟荣枫
/// CreatDate: 2020-04-03
/// Description：获取医嘱项接收科室数据
/// Table：ARC_ItmRecLoc
/// Input：num
/// Return：
/// /w ##class(web.DHCBL.CT.RecLocSelect).GetAMInfo("2")
ClassMethod GetAMInfo(i) As %String
{
	n (i)
	s str=""
	S RLRowId=$g(^TMPAMCOUNT(i))
	q:(RLRowId="") ""
	s parref=$p(RLRowId, "||", 1)
  	s rowid=$p(RLRowId, "||", 2)
	 
	
	s ARCIMRowId=parref_"||1"
	s ARCICCode=$p($g(^ARCIM(parref,1,1)),"^",1)  //医嘱项代码
	s ARCICDesc=$p($g(^ARCIM(parref,1,1)),"^",2)  //医嘱项
	s LinkHospDesc=##class(web.DHCBL.BDP.BDPDataExport).GetHospital("ARC_ItmMast",parref_"||1","Desc")
	 
	
	 s RLOrdLocDR=$p($g(^ARCRL(parref,rowid)),"^",1)
	 s RLOrdLocDesc=""
	 
	 s:RLOrdLocDR'="" RLOrdLocDesc=$p($g(^CTLOC(RLOrdLocDR)),"^",2) //获取科室描述
	 s RLOrdLocHospDR=$s(RLOrdLocDR="":$p($g(^ARCRL(parref,rowid)),"^",7),1:$p($g(^CTLOC(RLOrdLocDR)),"^",22))
	 s RLOrdLocHospDesc=""
	 s:RLOrdLocHospDR'="" RLOrdLocHospDesc=$p($g(^CT("HOSP",RLOrdLocHospDR)),"^",2)

		
	 s RLRecLocDR=$p($g(^ARCRL(parref,rowid)),"^",2)
	 s RLRecLocDesc=""
	 
	 s:RLRecLocDR'="" RLRecLocDesc=$p($g(^CTLOC(RLRecLocDR)),"^",2) //获取科室描述
	 s RLRecLocHospDesc=##class(web.DHCBL.BDP.BDPDataExport).GetHospital("CT_Loc",RLRecLocDR,"Desc")
		 
	 s RLFunction=$p($g(^ARCRL(parref,rowid)),"^",3)  //功能
	 s RLCTHospitalDR=$p($g(^ARCRL(parref,rowid)),"^",7) 
	 s RLCTHospitalDesc=""
	 s:RLCTHospitalDR'="" RLCTHospitalDesc=$p($g(^CT("HOSP",RLCTHospitalDR)),"^",2) //获取医院描述

	 
	 s RLOrderPriorityDR=$p($g(^ARCRL(parref,rowid)),"^",10)
	 s RLOrderPriorityDesc=""
	 s:RLOrderPriorityDR'="" RLOrderPriorityDesc=$p($g(^OECPR(RLOrderPriorityDR)),"^",2) //系统医嘱优先级描述
	 s RLDefaultFlag=$p($g(^ARCRL(parref,rowid)),"^",4)
	 s RLDateFrom=$p($g(^ARCRL(parref,rowid)),"^",8)
	 s RLDateTo=$p($g(^ARCRL(parref,rowid)),"^",9)
	 s:RLDateFrom'="" RLDateFrom=$zd(RLDateFrom,3) //转换日期格式
	 s:RLDateTo'="" RLDateTo=$zd(RLDateTo,3) //转换日期格式
	 s RLTimeFrom=$p($g(^ARCRL(parref,rowid)),"^",5)
	 s RLTimeTo=$p($g(^ARCRL(parref,rowid)),"^",6)
	 s:RLTimeFrom'="" RLTimeFrom=$zt(RLTimeFrom,1)  //转换时间
	 s:RLTimeTo'="" RLTimeTo=$zt(RLTimeTo,1)      //转换时间
	s RLClinicType=$p($g(^ARCRL(parref,rowid)),"^",12)
	//s RLClinicType=$case(RLClinicType,"O":"门诊","E":"急诊","I":"住院","H":"体检","N":"新生儿",:"")
	
	
	//"医嘱项医院&%医嘱代码&%医嘱名称&%病人科室所属医院&%病人科室&%接收科室所属医院&%接收科室&%医嘱优先级&%开始日期&%结束日期&%开始时间&%结束时间&%默认接收科室（Y/N）&%就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)"

  	s str=LinkHospDesc_"&%"_ARCICCode_"&%"_ARCICDesc_"&%"_RLOrdLocHospDesc_"&%"_RLOrdLocDesc_"&%"_RLRecLocHospDesc_"&%"_RLRecLocDesc_"&%"_RLOrderPriorityDesc_"&%"_RLDateFrom_"&%"_RLDateTo_"&%"_RLTimeFrom_"&%"_RLTimeTo_"&%"_RLDefaultFlag_"&%"_RLClinicType
	q str
}

/// Creator：钟荣枫
/// CreatDate: 2020-04-03
/// Description：获取医嘱大类接收科室数据
/// Table：
/// Input：num
/// Return：
/// /w ##class(web.DHCBL.CT.RecLocSelect).GetOCInfo("2")
ClassMethod GetOCInfo(i) As %String
{
	n (i)
	s str=""
	S RLRowId=$g(^TMPOCCOUNT(i))
	q:(RLRowId="") ""
	s ARCICRowId=$p(RLRowId, "||", 1)
  	s ChildSub=$p(RLRowId, "||", 2)
	s ARCICCode=$p($g(^OEC("ORCAT",ARCICRowId)),"^",2) //医嘱大类
			
	s ARCICDesc=$p($g(^OEC("ORCAT",ARCICRowId)),"^",2) //医嘱大类
	s LinkHospDesc=##class(web.DHCBL.BDP.BDPDataExport).GetHospital("OEC_OrderCategory",ARCICRowId,"Desc")
	
	s RLRecLocDR=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",3)
	s RLRecLocDesc=""
	s:RLRecLocDR'="" RLRecLocDesc=$p($g(^CTLOC(RLRecLocDR)),"^",2) //获取科室描述
	s RLRecLocHospDesc=##class(web.DHCBL.BDP.BDPDataExport).GetHospital("CT_Loc",RLRecLocDR,"Desc")		//接收科室所在医院
	
	s RLOrdLocDR=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",2)
	s RLOrdLocDesc=""
	s:RLOrdLocDR'="" RLOrdLocDesc=$p($g(^CTLOC(RLOrdLocDR)),"^",2) //获取科室描述
	s RLOrdLocHospDesc=""		//病人科室所在医院
	s:RLOrdLocDR'="" RLOrdLocHospDesc=$s($p($g(^CTLOC(RLOrdLocDR)),"^",22)="":"",1:$p($g(^CT("HOSP",$p($g(^CTLOC(RLOrdLocDR)),"^",22))),"^",2))
	 
	s RLFunction=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",1)
	s RLDefaultFlag=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",4)
	s RLTimeFrom=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",5)
	s RLTimeTo=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",6)
	s RLCTHospitalDR=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",7)
	s RLCTHospitalDesc=""
	s:RLCTHospitalDR'="" RLCTHospitalDesc=$p($g(^CT("HOSP",RLCTHospitalDR)),"^",2) //获取医院描述
	s RLDateFrom=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",8)
	s RLDateTo=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",9)
	s RLOrderPriorityDR=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",10)
	s RLOrderPriorityDesc=""
	s:RLOrderPriorityDR'="" RLOrderPriorityDesc=$p($g(^OECPR(RLOrderPriorityDR)),"^",2) //获取医嘱优先级描述
	s:RLDateFrom'="" RLDateFrom=$zd(RLDateFrom,3) //转换日期格式
	s:RLDateTo'="" RLDateTo=$zd(RLDateTo,3) //转换日期格式
	s:RLTimeFrom'="" RLTimeFrom=$zt(RLTimeFrom,1)  //转换时间
	s:RLTimeTo'="" RLTimeTo=$zt(RLTimeTo,1)      //转换时间
	
	s RLClinicType=$p($g(^OEC("ORCAT",ARCICRowId,"RL",ChildSub)),"^",12)
	//s RLClinicType=$case(RLClinicType,"O":"门诊","E":"急诊","I":"住院","H":"体检","N":"新生儿",:"")
	
	
	//医嘱大类所属医院&%医嘱大类代码&%医嘱大类名称&%病人科室医院&%病人科室&%接收科室医院&%接收科室&%功能(Execute,Processing)&%默认(Y/N)&%开始时间&%结束时间&%医院&%开始日期&%结束日期&%医嘱优先级&%就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)
  	s str=LinkHospDesc_"&%"_ARCICCode_"&%"_ARCICDesc_"&%"_RLOrdLocHospDesc_"&%"_RLOrdLocDesc_"&%"_RLRecLocHospDesc_"&%"_RLRecLocDesc_"&%"_RLFunction_"&%"_RLDefaultFlag_"&%"_RLTimeFrom_"&%"_RLTimeTo_"&%"_RLCTHospitalDesc_"&%"_RLDateFrom_"&%"_RLDateTo_"&%"_RLOrderPriorityDesc_"&%"_RLClinicType
	q str
}

/// Creator：钟荣枫
/// CreatDate: 2020-04-03
/// Description：获取医嘱子类接收科室数据
/// Table：
/// Input：num
/// Return：
/// /w ##class(web.DHCBL.CT.RecLocSelect).GetOCInfo("2")
ClassMethod GetACInfo(i) As %String
{
	n (i)
	s str=""
	S RLRowId=$g(^TMPACCOUNT(i))
	q:(RLRowId="") ""
	s ARCICRowId=$p(RLRowId, "||", 1)
  	s ChildSub=$p(RLRowId, "||", 2)
	
	s ARCICCode=$p($g(^ARC("IC",ARCICRowId)),"^",1) //医嘱子分类		
	s ARCICDesc=$p($g(^ARC("IC",ARCICRowId)),"^",2) //医嘱子分类
	s LinkHospDesc=##class(web.DHCBL.BDP.BDPDataExport).GetHospital("ARC_ItemCat",ARCICRowId,"Desc")
	
	s RLRecLocDR=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",3)
	s RLRecLocDesc=""
	s:RLRecLocDR'="" RLRecLocDesc=$p($g(^CTLOC(RLRecLocDR)),"^",2) //获取接收科室描述
	s RLRecLocHospDesc=""
	s:RLRecLocDR'="" RLRecLocHospDesc=$s($p($g(^CTLOC(RLRecLocDR)),"^",22)="":"",1:$p($g(^CT("HOSP",$p($g(^CTLOC(RLRecLocDR)),"^",22))),"^",2))		//接收科室所在医院
	s RLOrdLocDR=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",2)
	s RLOrdLocDesc=""
	s:RLOrdLocDR'="" RLOrdLocDesc=$p($g(^CTLOC(RLOrdLocDR)),"^",2) //获取病人科室描述
	s RLOrdLocHospDesc=""		//病人科室所在医院
	s:RLOrdLocDR'="" RLOrdLocHospDesc=$s($p($g(^CTLOC(RLOrdLocDR)),"^",22)="":"",1:$p($g(^CT("HOSP",$p($g(^CTLOC(RLOrdLocDR)),"^",22))),"^",2))
	
	
	s RLFunction=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",1)
	s RLDefaultFlag=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",4)
	s RLTimeFrom=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",5)
	s RLTimeTo=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",6)
	s RLCTHospitalDR=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",7)
	s RLCTHospitalDesc=""
	s:RLCTHospitalDR'="" RLCTHospitalDesc=$p($g(^CT("HOSP",RLCTHospitalDR)),"^",2) //获取医院描述
	s RLDateFrom=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",8)
	s RLDateTo=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",9)
	s RLOrderPriorityDR=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",10)
	s RLOrderPriorityDesc=""
	s:RLOrderPriorityDR'="" RLOrderPriorityDesc=$p($g(^OECPR(RLOrderPriorityDR)),"^",2) //获取医嘱优先级描述
	s:RLDateFrom'="" RLDateFrom=$zd(RLDateFrom,3) //转换日期格式
	s:RLDateTo'="" RLDateTo=$zd(RLDateTo,3) //转换日期格式
	s:RLTimeFrom'="" RLTimeFrom=$zt(RLTimeFrom,1)  //转换时间
	s:RLTimeTo'="" RLTimeTo=$zt(RLTimeTo,1)      //转换时间
		
	s RLClinicType=$p($g(^ARC("IC",ARCICRowId,"RL",ChildSub)),"^",12)		//就诊类型
	//s RLClinicType=$case(RLClinicType,"O":"门诊","E":"急诊","I":"住院","H":"体检","N":"新生儿",:"")
	
	//"医嘱子分类所属医院&%医嘱子类代码&%医嘱子类名称&%病人科室医院&%病人科室&%接收科室医院&%接收科室&%功能(Execute,Processing)&%默认&%开始时间&%结束时间&%医院&%开始日期&%结束日期&%医嘱优先级&%就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)"		
  	s str=LinkHospDesc_"&%"_ARCICCode_"&%"_ARCICDesc_"&%"_RLOrdLocHospDesc_"&%"_RLOrdLocDesc_"&%"_RLRecLocHospDesc_"&%"_RLRecLocDesc_"&%"_RLFunction_"&%"_RLDefaultFlag_"&%"_RLTimeFrom_"&%"_RLTimeTo_"&%"_RLCTHospitalDesc_"&%"_RLDateFrom_"&%"_RLDateTo_"&%"_RLOrderPriorityDesc_"&%"_RLClinicType
	q str
}

/// Creator:陈莹
/// CreatDate:2016-6-23
/// Description:为combobox查询取数据
/// Table：User.ARCItemCat  User.OECOrderCategory   User.ARCItmMast
/// Input:code,desc,objecttype
/// Return:RowId,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RecLocSelect","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, objecttype As %String, hospid As %String) As %Query(ROWSPEC = "RowId:%String,Desc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, objecttype As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (objecttype="AC")
	{
		if (rowid'="") //根据rowid返回该条记录
		{
			s ARCICRowId=rowid
			
			s ARCICDesc=$p($g(^ARC("IC",ARCICRowId)),"^",2)
			s RowId=ARCICRowId
			s Desc=ARCICDesc
			d OutputRowCmb
		}
		else
		{
	
			//获取授权Json
			s AuStr=##class(web.DHCBL.Authorize.ARCItemCat).DHCGetDataByDefaultSession()
			s AuFlag=0
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
			s ARCICOrdCatDRAuStr=##class(web.DHCBL.Authorize.OECOrderCategory).DHCGetDataByDefaultSession()
			s ARCICOrdCatDRAuFlag=0
			if (ARCICOrdCatDRAuStr="")||(ARCICOrdCatDRAuStr["limited:0") s ARCICOrdCatDRAuFlag=1 //判断是否有授权,如果没有则全部显示
			s ARCICExecCategDRAuStr=##class(web.DHCBL.Authorize.OECExecCateg).DHCGetDataByDefaultSession()
			s ARCICExecCategDRAuFlag=0
			if (ARCICExecCategDRAuStr="")||(ARCICExecCategDRAuStr["limited:0") s ARCICExecCategDRAuFlag=1 //判断是否有授权,如果没有则全部显示
	
			s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
			s ARCICRowId=0
			f {
				s ARCICRowId=$o(^ARC("IC",ARCICRowId))
				q:ARCICRowId=""
				//筛选授权后的数据
				s ARCICOrdCatDR=$p($g(^ARC("IC",ARCICRowId)),"^",8)
				s ARCICExecCategDR=$p($g(^ARC("IC",ARCICRowId)),"^",9)
				//筛选授权后的数据
				s strRowId="{ID:"_ARCICRowId_"}"
				s ARCICOrdCatDRstrRowId="{ID:"_ARCICOrdCatDR_"}"
				s ARCICExecCategDRstrRowId="{ID:"_ARCICExecCategDR_"}"
				if ((AuStr[strRowId)||(AuFlag=1))&&((ARCICOrdCatDRAuStr[ARCICOrdCatDRstrRowId)||(ARCICOrdCatDRAuFlag=1))&&((ARCICExecCategDRAuStr[ARCICExecCategDRstrRowId)||(ARCICExecCategDRAuFlag=1))
				{
					s ARCICDesc=$p($g(^ARC("IC",ARCICRowId)),"^",2)
					s ARCICOrdCatDR=$p($g(^ARC("IC",ARCICRowId)),"^",8)
					
					s RowId=ARCICRowId
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat",RowId,hospid)
					continue:showflag="N" 
					s Desc=ARCICDesc
					
					if (desc'="")           
					{
						;需要对描述或者别名进行检索      
						s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ARC_ItemCat",RowId,Desc,desc)
					}
					else
					{
						s AliasFlag=1
					}
					i ( AliasFlag=1)
					{
						d OutputRowCmb
					}
				}
			}
		}
	}
	IF (objecttype="AM")
	{
		
		
		 if (rowid'="") {
		  s ARCIMSubscript=$p(rowid, "||", 1)
		  s ARCIMVersion=$p(rowid, "||", 2)
		  s ARCIMRowId=rowid
		  s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
		  s ARCIMDesc =$tr(ARCIMDesc,"""","")
		  s ARCIMDesc =$p(ARCIMDesc,$c(13,10),1)
		  s RowId=ARCIMRowId
		  s Desc =ARCIMDesc
		  
		  d OutputRowCmb
		 }
		 else {
		 s:desc'="" desc=$ZCONVERT(desc,"U")
		 s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
		 s AuStr=##class(web.DHCBL.Authorize.ARCItmMast).DHCGetDataByDefaultSession()

		 if ($l(AuStr,"#")=1) {
		  s Limited=0
		  s AutBit=""
		 }
		 elseif ($l(AuStr,"#")=2) {
		  s Limited=$p(AuStr,"#",1)
		  s AutBit=$p(AuStr,"#",2)
		 }
		 s AuFlag=0
		 if (AuStr="")||((AuStr'="")&(Limited=0)) s AuFlag=1 //判断是否有授权,如果没有则全部显示

		 s ARCIMItemCatDRAuStr=##class(web.DHCBL.Authorize.ARCItemCat).DHCGetDataByDefaultSession()
		 s ARCIMItemCatDRAuFlag=0
		 ;未授权情况下，默认显示全部数据
		 if (ARCIMItemCatDRAuStr="")||(ARCIMItemCatDRAuStr["limited:0") s ARCIMItemCatDRAuFlag=1

		 s ARCIMBillingUOMDRAuStr=##class(web.DHCBL.Authorize.CTUOM).DHCGetDataByDefaultSession()
		 s ARCIMBillingUOMDRAuFlag=0
		 ;未授权情况下，默认显示全部数据
		 if (ARCIMBillingUOMDRAuStr="")||(ARCIMBillingUOMDRAuStr["limited:0") s ARCIMBillingUOMDRAuFlag=1

		 s ARCIMBillGrp1AuStr=##class(web.DHCBL.Authorize.ARCBillGrp).DHCGetDataByDefaultSession()
		 s ARCIMBillGrp1AuFlag=0
		 ;未授权情况下，默认显示全部数据
		 if (ARCIMBillGrp1AuStr="")||(ARCIMBillGrp1AuStr["limited:0") s ARCIMBillGrp1AuFlag=1

		 s ARCIMDefPriorityDRAuStr=##class(web.DHCBL.Authorize.OECPriority).DHCGetDataByDefaultSession()
		 s ARCIMDefPriorityDRAuFlag=0
		 ;未授权情况下，默认显示全部数据
		 if (ARCIMDefPriorityDRAuStr="")||(ARCIMDefPriorityDRAuStr["limited:0") s ARCIMDefPriorityDRAuFlag=1

		 s ARCIMDerFeeRulesDRAuStr=##class(web.DHCBL.Authorize.ARCDerivedFeeRules).DHCGetDataByDefaultSession()
		 s ARCIMDerFeeRulesDRAuFlag=0
		 ;未授权情况下，默认显示全部数据
		 if (ARCIMDerFeeRulesDRAuStr="")||(ARCIMDerFeeRulesDRAuStr["limited:0") s ARCIMDerFeeRulesDRAuFlag=1

		 s ARCIMServiceGroupDRAuStr=##class(web.DHCBL.Authorize.RBCServiceGroup).DHCGetDataByDefaultSession()
		 s ARCIMServiceGroupDRAuFlag=0
		 ;未授权情况下，默认显示全部数据
		 if (ARCIMServiceGroupDRAuStr="")||(ARCIMServiceGroupDRAuStr["limited:0") s ARCIMServiceGroupDRAuFlag=1
	



		 s ARCIMSubscript=0
		 for
		 {
		 s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:(ARCIMSubscript="")
		 s ARCIMVersion=0
		 for 
		 {
			s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))
			q:(ARCIMVersion="")
	
	
			s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
			
			; 遍历 医院子表，查询医院dr 进行筛选
			s HospChildsub=0,AuHospFlag=0 
			s strHospitalID=""
			for
			{
				s HospChildsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)) q:(HospChildsub="")||(AuHospFlag=1)  
				s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)),"^",1)  
				s strHospitalID = "{ID:"_HOSPHospitalDR_"}"
				if (AuHospStr[strHospitalID) s AuHospFlag=1
			}
	
	
			s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
			s ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)       ; 账单组与 账单子组
			s:ARCIMBillSubDR'="" ARCIMBillGrp1=$p(ARCIMBillSubDR,"||",1)                     ; 账单组DR
			s:ARCIMBillSubDR="" ARCIMBillGrp1=""
			s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)
			s ARCIMDefPriorityDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",22)
			s ARCIMDerFeeRulesDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",19)
			s ARCIMServiceGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7) ;服务资源组

			s ARCIMItemCatDRstrRowId="{ID:"_ARCIMItemCatDR_"}"
			s ARCIMBillGrp1strRowId="{ID:"_ARCIMBillGrp1_"}"
			s ARCIMBillingUOMDRstrRowId="{ID:"_ARCIMBillingUOMDR_"}"
			s ARCIMDefPriorityDRstrRowId="{ID:"_ARCIMDefPriorityDR_"}"
			s ARCIMDerFeeRulesDRstrRowId="{ID:"_ARCIMDerFeeRulesDR_"}"
			s ARCIMServiceGroupDRstrRowId="{ID:"_ARCIMServiceGroupDR_"}"
			if ((AuHospStr=1)||(AuHospFlag=1)||((AuHospStr="off"))&&(($bit(AutBit,ARCIMSubscript)=1)||(AuFlag=1)))&&((ARCIMBillGrp1AuStr[ARCIMBillGrp1strRowId)||(ARCIMBillGrp1AuFlag=1))&&((ARCIMItemCatDRAuStr[ARCIMItemCatDRstrRowId)||(ARCIMItemCatDRAuFlag=1))&&((ARCIMBillingUOMDRAuStr[ARCIMBillingUOMDRstrRowId)||(ARCIMBillingUOMDRAuFlag=1))&&((ARCIMDefPriorityDRAuStr[ARCIMDefPriorityDRstrRowId)||(ARCIMDefPriorityDRAuFlag=1))&&((ARCIMDerFeeRulesDRAuStr[ARCIMDerFeeRulesDRstrRowId)||(ARCIMDerFeeRulesDRAuFlag=1))&&((ARCIMServiceGroupDRAuStr[ARCIMServiceGroupDRstrRowId)||(ARCIMServiceGroupDRAuFlag=1))
			{
		        s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
		        s ARCIMDesc =$tr(ARCIMDesc,"""","")
		  		s ARCIMDesc =$p(ARCIMDesc,$c(13,10),1)
		  		s RowId=ARCIMRowId
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast",RowId,hospid)
				continue:showflag="N"
				
		  		s Desc =ARCIMDesc
		        s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
		        s ARCIMItemCatDRDesc=""
		        if (ARCIMItemCatDR'="")  s ARCIMItemCatDRDesc=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)
		        if (ARCIMItemCatDR'="")  s ARCICOrdCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)     
		        if (ARCIMItemCatDR="")  s ARCICOrdCatDR=""
       
		        s ARCICOrdCatDRDesc=""
		        if (ARCICOrdCatDR'="")  s ARCICOrdCatDRDesc=$p($g(^OEC("ORCAT",ARCICOrdCatDR)),"^",2)
		        
		        
		        
		        s ALIASRowId=0,ALIASText1=""
		        for 
		        {
		           s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId))
		           q:ALIASRowId=""
		           s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
		           s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
		        }
				s PINYIN=""
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(ARCIMDesc)	
		       if (($ZCONVERT(ARCIMDesc,"U")[desc)||(PINYIN[desc)||(ALIASText1[desc))
		       {
		         d OutputRowCmb
		       }
		     }
		   }
		  }
		 }
		
		
		
	}
	
	IF (objecttype="OC")
	{
		
		if (rowid'="") //根据rowid返回该条记录
		{
			s ORCATRowId = rowid
			s ORCATDesc = $p($g(^OEC("ORCAT",ORCATRowId)),"^",2)
			S RowId = ORCATRowId
			S Desc = ORCATDesc
			d OutputRowCmb
		}
		else
		{
			//获取授权Json
			s AuStr=##class(web.DHCBL.Authorize.OECOrderCategory).DHCGetDataByDefaultSession()
			s AuFlag=0
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
			s ORCATOCGroupDRAuStr=##class(web.DHCBL.Authorize.OECOrderCategoryGroup).DHCGetDataByDefaultSession()
			s ORCATOCGroupDRAuFlag=0
			if (ORCATOCGroupDRAuStr="")||(ORCATOCGroupDRAuStr["limited:0") s ORCATOCGroupDRAuFlag=1 //判断是否有授权,如果没有则全部显示
	
			s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
			s ORCATRowId=0
			f {
				s ORCATRowId=$o(^OEC("ORCAT",ORCATRowId))
				q:ORCATRowId=""
				s ORCATOCGroupDR = $p($g(^OEC("ORCAT",ORCATRowId)),"^",15)
				//筛选授权后的数据
				s ORCATOCGroupDRstrRowId="{ID:"_ORCATOCGroupDR_"}"
				s strRowId="{ID:"_ORCATRowId_"}"
				if ((AuStr[strRowId)||(AuFlag=1))&&((ORCATOCGroupDRAuStr[ORCATOCGroupDRstrRowId)||(ORCATOCGroupDRAuFlag=1))
				{
					s ORCATDesc = $p($g(^OEC("ORCAT",ORCATRowId)),"^",2)
					
					S RowId = ORCATRowId
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("OEC_OrderCategory",RowId,hospid)
					continue:showflag="N"
					S Desc = ORCATDesc
					if (desc'="")           
					{
						;需要对描述或者别名进行检索      
						s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("OEC_OrderCategory",RowId,Desc,desc)
					}
					else
					{
						s AliasFlag=1
					}
					i ( AliasFlag=1)
					{
						d OutputRowCmb
					}
				}
			}
		}
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(RowId,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2016-6-1
/// Description:复制科室 将一个医嘱项的一条接收科室 复制给另一个医嘱项
///  主要用于新增了一个关联表数据，比如新增医嘱分类 西药片剂，可以查询西药口服剂的接收科室，选中将 西药口服剂 的所有接收科室赋值给  西药片剂
/// Table:
/// Input:id
/// Other:w ##class(web.DHCBL.CT.RecLocSelect).CopyRecLoc("1")
ClassMethod CopyRecLoc(idstr As %String, parref As %String, type As %String) As %String
{
	n (idstr,parref,type,%session)
	s result="{success:false'}"
	s flag=0,flag2=0
	if (type="AM")
	{
		s length=$l(idstr,"&%")
		
		for i=1:1:length
		{
			s RLRowId=$p(idstr,"&%",i)
			s RLParRef=$p(RLRowId,"||",1)
			s RLChildsub=$p(RLRowId,"||",2)
			
			s ARCRLOrdLocDR=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",1)
			s ARCRLRecLocDR=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",2)
			s ARCRLFunction=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",3)  //功能
			s ARCRLCTHospitalDR=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",7) 
			s ARCRLOrderPriorityDR=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",10)
			s ARCRLDefaultFlag=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",4)
			if ARCRLDefaultFlag="Y" S ARCRLDefaultFlag="true"
			s ARCRLDateFrom=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",8)
			s ARCRLDateTo=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",9)
			s ARCRLTimeFrom=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",5)
			s ARCRLTimeTo=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",6)
			
			s:ARCRLDateFrom'="" ARCRLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCRLDateFrom)
			s:ARCRLDateTo'="" ARCRLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCRLDateTo)
			s:ARCRLTimeFrom'="" ARCRLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(ARCRLTimeFrom)
			s:ARCRLTimeTo'="" ARCRLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(ARCRLTimeFrom)
			s ARCRLClinicType=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",12)
			
			s DataStr=parref_"^"_ARCRLOrdLocDR_"^"_ARCRLRecLocDR_"^"_ARCRLOrderPriorityDR_"^"_ARCRLDateFrom_"^"_ARCRLDateTo_"^"_ARCRLTimeFrom_"^"_ARCRLTimeTo_"^"_ARCRLDefaultFlag_"^"_ARCRLFunction_"^"_ARCRLCTHospitalDR_"^"_ARCRLClinicType
			s rs= ##class(web.DHCBL.CT.ARCItmRecLoc).AddReceiveLoc(DataStr)		
			if rs["{success:'false'" s flag=1
			if rs["{success:'true'" s flag2=1
		}		
		if (flag=1)
		{
			if (flag2=1)
			{
				s result="{success:'false',info:'重复数据已跳过保存，非重复数据保存成功！'}"
			}
			else
			{
				
				s result="{success:'false',info:'重复数据已跳过保存！'}"
			}
		}
		else
		{
			s result="{success:'true'}"
		}
		
		
	}
	if (type="OC")
	{
		s length=$l(idstr,"&%")
		s flag=0
		for i=1:1:length
		{
			s RLRowId=$p(idstr,"&%",i)
			s RLParRef=$p(RLRowId,"||",1)
			s RLChildsub=$p(RLRowId,"||",2)
			s eobj=##class(web.Entity.CT.OECOrdCatRecLoc).%New()
			s eobj.RLParRef=parref
			s eobj.RLRecLocDR=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",3)
			s eobj.RLOrdLocDR=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",2)
			s eobj.RLFunction=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",1)
			s eobj.RLDefaultFlag=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",4)
			s eobj.RLTimeFrom=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",5)
			s eobj.RLTimeTo=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",6)
			s eobj.RLCTHospitalDR=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",7)
			s eobj.RLDateFrom=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",8)
			s eobj.RLDateTo=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",9)
			s eobj.RLOrderPriorityDR=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",10)
			s:eobj.RLDateFrom'="" eobj.RLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateFrom)
			s:eobj.RLDateTo'="" eobj.RLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateTo)
			s:eobj.RLTimeFrom'="" eobj.RLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom)
			s:eobj.RLTimeTo'="" eobj.RLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom)
			s eobj.RLClinicType=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",12)  //就诊类型 2022-4-11 钟荣枫
			
			s rs=##class(web.DHCBL.CT.OECOrdCatRecLoc).SaveEntity(eobj)
			if rs["{success:'false'" s flag=1
			if rs["{success:'true'" s flag2=1
		}		
		if (flag=1)
		{
			if (flag2=1)
			{
				s result="{success:'false',info:'重复数据已跳过保存，非重复数据保存成功！'}"
			}
			else
			{
				
				s result="{success:'false',info:'重复数据已跳过保存！'}"
			}
		}
		else
		{
			s result="{success:'true'}"
		}
	}
	if (type="AC")
	{
		s length=$l(idstr,"&%")
		s flag=0
		for i=1:1:length
		{
			s RLRowId=$p(idstr,"&%",i)
			s RLParRef=$p(RLRowId,"||",1)
			s RLChildsub=$p(RLRowId,"||",2)
			s eobj=##class(web.Entity.CT.ARCItemCatRecLoc).%New()
			
			s eobj.RLParRef=parref
			s eobj.RLRecLocDR=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",3)
			s eobj.RLOrdLocDR=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",2)
			s eobj.RLFunction=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",1)
			s eobj.RLDefaultFlag=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",4)
			s eobj.RLTimeFrom=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",5)
			s eobj.RLTimeTo=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",6)
			s eobj.RLCTHospitalDR=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",7)
			s eobj.RLDateFrom=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",8)
			s eobj.RLDateTo=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",9)
			s eobj.RLOrderPriorityDR=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",10)
			s:eobj.RLDateFrom'="" eobj.RLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateFrom)
			s:eobj.RLDateTo'="" eobj.RLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateTo)
			s:eobj.RLTimeFrom'="" eobj.RLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom)
			s:eobj.RLTimeTo'="" eobj.RLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeTo)
			s eobj.RLClinicType=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",12)  //就诊类型 2022-4-11 钟荣枫
			
			s rs=##class(web.DHCBL.CT.ARCItemCatRecLoc).SaveEntity(eobj)
			if rs["{success:'false'" s flag=1
			if rs["{success:'true'" s flag2=1
		}		
		if (flag=1)
		{
			if (flag2=1)
			{
				s result="{success:'false',info:'重复数据已跳过保存，非重复数据保存成功！'}"
			}
			else
			{
				
				s result="{success:'false',info:'重复数据已跳过保存！'}"
			}
		}
		else
		{
			s result="{success:'true'}"
		}
			
	}
	Q result
}

/// Creator:陈莹
/// CreatDate:2016-6-1
/// Description:复制接收科室  对于一条医嘱项 ，有一个接收科室的数据，复制添加另一个接收科室的数据
/// 主要用于新增了一个科室时，比如药房2，将医嘱项数据 原来有YF-药房1的 都复制加上YF-药房2
/// Table:
/// Input:id
/// Other:w ##class(web.DHCBL.CT.RecLocSelect).CopyRecLocI("1")
ClassMethod CopyRecLocI(idstr As %String, type As %String, OrdLoc As %String, RecLoc As %String) As %String
{
	s result="{success:false'}"
	s flag=0,flag2=0
	if (type="AM")
	{
		s length=$l(idstr,"&%")  
		s flag=0
		for i=1:1:length
		{
			s str=$p(idstr,"&%",i)  //1||1&*1||2
			
			
			s parref=$p(str,"&*",1)
			s RLRowId=$p(str,"&*",2)
			
			s RLParRef=$p(RLRowId,"||",1)
			s RLChildsub=$p(RLRowId,"||",2)
			s ARCRLOrdLocDR=OrdLoc
			s ARCRLRecLocDR=RecLoc
			s ARCRLFunction=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",3)  //功能
			s ARCRLCTHospitalDR=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",7) 
			s ARCRLOrderPriorityDR=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",10)
			s ARCRLDefaultFlag=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",4)
			if ARCRLDefaultFlag="Y" S ARCRLDefaultFlag="true"
			s ARCRLDateFrom=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",8)
			s ARCRLDateTo=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",9)
			s ARCRLTimeFrom=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",5)
			s ARCRLTimeTo=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",6)
			s:ARCRLDateFrom'="" ARCRLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCRLDateFrom)
			s:ARCRLDateTo'="" ARCRLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCRLDateTo)
			s:ARCRLTimeFrom'="" ARCRLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(ARCRLTimeFrom)
			s:ARCRLTimeTo'="" ARCRLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(ARCRLTimeFrom)
			s ARCRLClinicType=$p($g(^ARCRL(RLParRef,RLChildsub)),"^",12)
			
			s DataStr=parref_"^"_ARCRLOrdLocDR_"^"_ARCRLRecLocDR_"^"_ARCRLOrderPriorityDR_"^"_ARCRLDateFrom_"^"_ARCRLDateTo_"^"_ARCRLTimeFrom_"^"_ARCRLTimeTo_"^"_ARCRLDefaultFlag_"^"_ARCRLFunction_"^"_ARCRLCTHospitalDR_"^"_ARCRLClinicType
			s rs= ##class(web.DHCBL.CT.ARCItmRecLoc).AddReceiveLoc(DataStr)
			if rs["{success:'false'" s flag=1
			if rs["{success:'true'" s flag2=1
		}		
		if (flag=1)
		{
			if (flag2=1)
			{
				s result="{success:'false',info:'重复数据已跳过保存，非重复数据保存成功！'}"
			}
			else
			{
				
				s result="{success:'false',info:'重复数据已跳过保存！'}"
			}
		}
		else
		{
			s result="{success:'true'}"
		}
		
	}
	if (type="OC")
	{
		s length=$l(idstr,"&%")
		
		for i=1:1:length
		{
			s str=$p(idstr,"&%",i)
			s parref=$p(str,"&*",1)
			s RLRowId=$p(str,"&*",2)
			s RLParRef=$p(RLRowId,"||",1)
			s RLChildsub=$p(RLRowId,"||",2)
			s eobj=##class(web.Entity.CT.OECOrdCatRecLoc).%New()
			s eobj.RLParRef=parref
			s eobj.RLRecLocDR=RecLoc
			s eobj.RLOrdLocDR=OrdLoc
			s eobj.RLFunction=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",1)
			s eobj.RLDefaultFlag=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",4)
			s eobj.RLTimeFrom=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",5)
			s eobj.RLTimeTo=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",6)
			s eobj.RLCTHospitalDR=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",7)
			s eobj.RLDateFrom=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",8)
			s eobj.RLDateTo=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",9)
			s eobj.RLOrderPriorityDR=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",10)
			s:eobj.RLDateFrom'="" eobj.RLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateFrom)
			s:eobj.RLDateTo'="" eobj.RLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateTo)
			s:eobj.RLTimeFrom'="" eobj.RLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom)
			s:eobj.RLTimeTo'="" eobj.RLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom)
			s eobj.RLClinicType=$p($g(^OEC("ORCAT",RLParRef,"RL",RLChildsub)),"^",12)	//2022-4-11 钟荣枫
			
			s rs=##class(web.DHCBL.CT.OECOrdCatRecLoc).SaveEntity(eobj)
			if rs["{success:'false'" s flag=1
			if rs["{success:'true'" s flag2=1
		}		
		if (flag=1)
		{
			if (flag2=1)
			{
				s result="{success:'false',info:'重复数据已跳过保存，非重复数据保存成功！'}"
			}
			else
			{
				
				s result="{success:'false',info:'重复数据已跳过保存！'}"
			}
		}
		else
		{
			s result="{success:'true'}"
		}
		
	}
	if (type="AC")
	{
		s length=$l(idstr,"&%")
		s flag=0
		for i=1:1:length
		{
			s str=$p(idstr,"&%",i)
			s parref=$p(str,"&*",1)
			s RLRowId=$p(str,"&*",2)
			s RLParRef=$p(RLRowId,"||",1)
			s RLChildsub=$p(RLRowId,"||",2)
			s eobj=##class(web.Entity.CT.ARCItemCatRecLoc).%New()
			s eobj.RLParRef=parref
			s eobj.RLRecLocDR=RecLoc
			s eobj.RLOrdLocDR=OrdLoc
			s eobj.RLFunction=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",1)
			s eobj.RLDefaultFlag=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",4)
			s eobj.RLTimeFrom=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",5)
			s eobj.RLTimeTo=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",6)
			s eobj.RLCTHospitalDR=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",7)
			s eobj.RLDateFrom=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",8)
			s eobj.RLDateTo=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",9)
			s eobj.RLOrderPriorityDR=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",10)
			s:eobj.RLDateFrom'="" eobj.RLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateFrom)
			s:eobj.RLDateTo'="" eobj.RLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateTo)
			s:eobj.RLTimeFrom'="" eobj.RLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom)
			s:eobj.RLTimeTo'="" eobj.RLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom)
			s eobj.RLClinicType=$p($g(^ARC("IC",RLParRef,"RL",RLChildsub)),"^",12) //2022-4-11 钟荣枫
			
			s rs=##class(web.DHCBL.CT.ARCItemCatRecLoc).SaveEntity(eobj)
			if rs["{success:'false'" s flag=1
			if rs["{success:'true'" s flag2=1
		}		
		if (flag=1)
		{
			if (flag2=1)
			{
				s result="{success:'false',info:'重复数据已跳过保存，非重复数据保存成功！'}"
			}
			else
			{
				
				s result="{success:'false',info:'重复数据已跳过保存！'}"
			}
		}
		else
		{
			s result="{success:'true'}"
		}
			
	}
	q result
}

/// Creator:likefan
/// CreatDate:2021-02-08
/// Description:复制所选数据给某个病人科室
/// 比如新增一个病人科室2，把病人科室1的所有接收科室复制给病人科室2
/// Input:idstr(所选数据id), type(AM/OC/AC), OrdLoc(病人科室id)
/// Other:w ##class(web.DHCBL.CT.RecLocSelect).CopyDataToOrdLoc("11564||1&%11565||1&%11566||1","AM","1")
ClassMethod CopyDataToOrdLoc(idstr As %String, type As %String, OrdLoc As %String) As %String
{
	n (idstr,type,OrdLoc,%session)
	s result=""
	s flag=0,flag2=0
	s ^templkf("idstr")=idstr
	s ^templkf("type")=type
	s ^templkf("OrdLoc")=OrdLoc
	if (type="AM")	//医嘱项接收科室
	{
		s length=$l(idstr,"&%")
		for i=1:1:length
		{
			s RLRowId=$p(idstr,"&%",i)
			s obj=##class(User.ARCItmRecLoc).%OpenId(RLRowId)
			
			//若病人科室和接收科室相同，则新数据也保持一致	2021-03-16
			s bARCRLRecLocDR=""
			s bARCRLOrdLocDR=""
			s:obj.ARCRLRecLocDR'="" bARCRLRecLocDR=obj.ARCRLRecLocDR.%Id()
			s:obj.ARCRLOrdLocDR'="" bARCRLOrdLocDR=obj.ARCRLOrdLocDR.%Id()
			if (bARCRLRecLocDR=bARCRLOrdLocDR)
			{
				s ARCRLOrdLocDR=OrdLoc
				s ARCRLRecLocDR=OrdLoc
			}
			else
			{
				s ARCRLOrdLocDR=OrdLoc
				s ARCRLRecLocDR=bARCRLRecLocDR
			}
			
			s ARCRLFunction=obj.ARCRLFunction
			s ARCRLCTHospitalDR=""
			s:obj.ARCRLCTHospitalDR'="" ARCRLCTHospitalDR=obj.ARCRLCTHospitalDR.%Id()
			s ARCRLOrderPriorityDR=""
			s:obj.ARCRLOrderPriorityDR'="" ARCRLOrderPriorityDR=obj.ARCRLOrderPriorityDR.%Id()
			s ARCRLDefaultFlag=obj.ARCRLDefaultFlag
			s:ARCRLDefaultFlag="Y" ARCRLDefaultFlag="true"
			s ARCRLDateFrom=obj.ARCRLDateFrom
			s ARCRLDateTo=obj.ARCRLDateTo
			s ARCRLTimeFrom=obj.ARCRLTimeFrom
			s ARCRLTimeTo=obj.ARCRLTimeTo
			s:ARCRLDateFrom'="" ARCRLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCRLDateFrom)
			s:ARCRLDateTo'="" ARCRLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCRLDateTo)
			s:ARCRLTimeFrom'="" ARCRLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(ARCRLTimeFrom)
			s:ARCRLTimeTo'="" ARCRLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(ARCRLTimeFrom)
			s ARCRLClinicType=obj.ARCRLClinicType	//2022-4-11 钟荣枫
			
			s DataStr=RLRowId_"^"_ARCRLOrdLocDR_"^"_ARCRLRecLocDR_"^"_ARCRLOrderPriorityDR_"^"_ARCRLDateFrom_"^"_ARCRLDateTo_"^"_ARCRLTimeFrom_"^"_ARCRLTimeTo_"^"_ARCRLDefaultFlag_"^"_ARCRLFunction_"^"_ARCRLCTHospitalDR_"^"_ARCRLClinicType
			s ^templkf("DataStr")=DataStr
			s rs=##class(web.DHCBL.CT.ARCItmRecLoc).AddReceiveLoc(DataStr)
			if rs["{success:'false'" s flag=1
			if rs["{success:'true'" s flag2=1
		}		
		if (flag=1)
		{
			if (flag2=1)
			{
				s result="{success:'false',info:'重复数据已跳过保存，非重复数据保存成功！'}"
			}
			else
			{
				s result="{success:'false',info:'重复数据已跳过保存！'}"
			}
		}
		else
		{
			s result="{success:'true'}"
		}
	}
	if (type="OC")	//医嘱大类接收科室
	{
		s length=$l(idstr,"&%")
		for i=1:1:length
		{
			s RLRowId=$p(idstr,"&%",i)
			s eobj=##class(web.Entity.CT.OECOrdCatRecLoc).%New()
			s obj=##class(User.OECOrdCatRecLoc).%OpenId(RLRowId)
			s eobj.RLParRef=$p(RLRowId,"||",1)
			
			//若病人科室和接收科室相同，则新数据也保持一致	2021-03-16
			s:obj.RLRecLocDR'="" eobj.RLRecLocDR=obj.RLRecLocDR.%Id()
			s:obj.RLOrdLocDR'="" eobj.RLOrdLocDR=obj.RLOrdLocDR.%Id()
			if (eobj.RLRecLocDR=eobj.RLOrdLocDR)
			{
				s eobj.RLRecLocDR=OrdLoc
				s eobj.RLOrdLocDR=OrdLoc
			}
			else
			{
				s eobj.RLOrdLocDR=OrdLoc
			}
			
			s eobj.RLFunction=obj.RLFunction
			s eobj.RLDefaultFlag=obj.RLDefaultFlag
			s eobj.RLTimeFrom=obj.RLTimeFrom
			s eobj.RLTimeTo=obj.RLTimeTo
			s:obj.RLCTHospitalDR'="" eobj.RLCTHospitalDR=obj.RLCTHospitalDR.%Id()
			s eobj.RLDateFrom=obj.RLDateFrom
			s eobj.RLDateTo=obj.RLDateTo
			s:obj.RLOrderPriorityDR'="" eobj.RLOrderPriorityDR=obj.RLOrderPriorityDR.%Id()
			s:eobj.RLDateFrom'="" eobj.RLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateFrom)
			s:eobj.RLDateTo'="" eobj.RLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateTo)
			s:eobj.RLTimeFrom'="" eobj.RLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom)
			s:eobj.RLTimeTo'="" eobj.RLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom)
			s eobj.RLClinicType=obj.RLClinicType		//钟荣枫 20220411
			s rs=##class(web.DHCBL.CT.OECOrdCatRecLoc).SaveEntity(eobj)
			if rs["{success:'false'" s flag=1
			if rs["{success:'true'" s flag2=1
		}		
		if (flag=1)
		{
			if (flag2=1)
			{
				s result="{success:'false',info:'重复数据已跳过保存，非重复数据保存成功！'}"
			}
			else
			{
				s result="{success:'false',info:'重复数据已跳过保存！'}"
			}
		}
		else
		{
			s result="{success:'true'}"
		}
	}
	if (type="AC")	//医嘱子类接收科室
	{
		s length=$l(idstr,"&%")
		for i=1:1:length
		{
			s RLRowId=$p(idstr,"&%",i)
			s eobj=##class(web.Entity.CT.ARCItemCatRecLoc).%New()
			s obj=##class(User.ARCItemCatRecLoc).%OpenId(RLRowId)
			s eobj.RLParRef=$p(RLRowId,"||",1)
			
			//若病人科室和接收科室相同，则新数据也保持一致	2021-03-16
			s:obj.RLRecLocDR'="" eobj.RLRecLocDR=obj.RLRecLocDR.%Id() 
			s:obj.RLOrdLocDR'="" eobj.RLOrdLocDR=obj.RLOrdLocDR.%Id()
			if (eobj.RLRecLocDR=eobj.RLOrdLocDR)
			{
				s eobj.RLRecLocDR=OrdLoc
				s eobj.RLOrdLocDR=OrdLoc
			}
			else
			{
				s eobj.RLOrdLocDR=OrdLoc
			}
			
			s eobj.RLFunction=obj.RLFunction
			s eobj.RLDefaultFlag=obj.RLDefaultFlag
			s eobj.RLTimeFrom=obj.RLTimeFrom
			s eobj.RLTimeTo=obj.RLTimeTo
			s:obj.RLCTHospitalDR'="" eobj.RLCTHospitalDR=obj.RLCTHospitalDR.%Id()
			s eobj.RLDateFrom=obj.RLDateFrom
			s eobj.RLDateTo=obj.RLDateTo
			s:obj.RLOrderPriorityDR'="" eobj.RLOrderPriorityDR=obj.RLOrderPriorityDR.%Id()
			s:eobj.RLDateFrom'="" eobj.RLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateFrom)
			s:eobj.RLDateTo'="" eobj.RLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateTo)
			s:eobj.RLTimeFrom'="" eobj.RLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom)
			s:eobj.RLTimeTo'="" eobj.RLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom)
			s eobj.RLClinicType=obj.RLClinicType		//钟荣枫 20220411
			
			s rs=##class(web.DHCBL.CT.ARCItemCatRecLoc).SaveEntity(eobj)
			if rs["{success:'false'" s flag=1
			if rs["{success:'true'" s flag2=1
		}		
		if (flag=1)
		{
			if (flag2=1)
			{
				s result="{success:'false',info:'重复数据已跳过保存，非重复数据保存成功！'}"
			}
			else
			{
				s result="{success:'false',info:'重复数据已跳过保存！'}"
			}
		}
		else
		{
			s result="{success:'true'}"
		}
	}
	q result
}

/// Creator:likefan
/// CreatDate:2021-02-23
/// Description:复制所选数据给某个接收科室
/// 比如新增一个接收科室2，把接收科室1的所有病人科室复制给接收科室2
/// Input:idstr(所选数据id), type(AM/OC/AC), OrdLoc(接收科室id)
/// Other:w ##class(web.DHCBL.CT.RecLocSelect).CopyDataToRecLoc("")
ClassMethod CopyDataToRecLoc(idstr As %String, type As %String, RecLoc As %String) As %String
{
	n (idstr,type,RecLoc,%session)
	s result=""
	s flag=0,flag2=0
	s ^templkf(2,"idstr")=idstr
	s ^templkf(2,"type")=type
	s ^templkf(2,"RecLoc")=RecLoc
	if (type="AM")	//医嘱项接收科室
	{
		s length=$l(idstr,"&%")
		for i=1:1:length
		{
			s RLRowId=$p(idstr,"&%",i)
			s obj=##class(User.ARCItmRecLoc).%OpenId(RLRowId)
			s ARCRLOrdLocDR=""
			s:obj.ARCRLOrdLocDR'="" ARCRLOrdLocDR=obj.ARCRLOrdLocDR.%Id()
			s ARCRLRecLocDR=RecLoc
			s ARCRLFunction=obj.ARCRLFunction
			s ARCRLCTHospitalDR=""
			s:obj.ARCRLCTHospitalDR'="" ARCRLCTHospitalDR=obj.ARCRLCTHospitalDR.%Id()
			s ARCRLOrderPriorityDR=""
			s:obj.ARCRLOrderPriorityDR'="" ARCRLOrderPriorityDR=obj.ARCRLOrderPriorityDR.%Id()
			s ARCRLDefaultFlag=obj.ARCRLDefaultFlag
			s:ARCRLDefaultFlag="Y" ARCRLDefaultFlag="true"
			s ARCRLDateFrom=obj.ARCRLDateFrom
			s ARCRLDateTo=obj.ARCRLDateTo
			s ARCRLTimeFrom=obj.ARCRLTimeFrom
			s ARCRLTimeTo=obj.ARCRLTimeTo
			s:ARCRLDateFrom'="" ARCRLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCRLDateFrom)
			s:ARCRLDateTo'="" ARCRLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCRLDateTo)
			s:ARCRLTimeFrom'="" ARCRLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(ARCRLTimeFrom)
			s:ARCRLTimeTo'="" ARCRLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(ARCRLTimeFrom)
			s ARCRLClinicType=obj.ARCRLClinicType		//钟荣枫  20220411
			
			s DataStr=RLRowId_"^"_ARCRLOrdLocDR_"^"_ARCRLRecLocDR_"^"_ARCRLOrderPriorityDR_"^"_ARCRLDateFrom_"^"_ARCRLDateTo_"^"_ARCRLTimeFrom_"^"_ARCRLTimeTo_"^"_ARCRLDefaultFlag_"^"_ARCRLFunction_"^"_ARCRLCTHospitalDR_"^"_ARCRLClinicType
			s ^templkf(2,"DataStr")=DataStr
			s rs=##class(web.DHCBL.CT.ARCItmRecLoc).AddReceiveLoc(DataStr)
			if rs["{success:'false'" s flag=1
			if rs["{success:'true'" s flag2=1
		}		
		if (flag=1)
		{
			if (flag2=1)
			{
				s result="{success:'false',info:'重复数据已跳过保存，非重复数据保存成功！'}"
			}
			else
			{
				s result="{success:'false',info:'重复数据已跳过保存！'}"
			}
		}
		else
		{
			s result="{success:'true'}"
		}
	}
	if (type="OC")	//医嘱大类接收科室
	{
		s length=$l(idstr,"&%")
		for i=1:1:length
		{
			s RLRowId=$p(idstr,"&%",i)
			s eobj=##class(web.Entity.CT.OECOrdCatRecLoc).%New()
			s obj=##class(User.OECOrdCatRecLoc).%OpenId(RLRowId)
			s eobj.RLParRef=$p(RLRowId,"||",1)
			s:obj.RLOrdLocDR'="" eobj.RLOrdLocDR=obj.RLOrdLocDR.%Id()
			s eobj.RLRecLocDR=RecLoc
			s eobj.RLFunction=obj.RLFunction
			s eobj.RLDefaultFlag=obj.RLDefaultFlag
			s eobj.RLTimeFrom=obj.RLTimeFrom
			s eobj.RLTimeTo=obj.RLTimeTo
			s:obj.RLCTHospitalDR'="" eobj.RLCTHospitalDR=obj.RLCTHospitalDR.%Id()
			s eobj.RLDateFrom=obj.RLDateFrom
			s eobj.RLDateTo=obj.RLDateTo
			s:obj.RLOrderPriorityDR'="" eobj.RLOrderPriorityDR=obj.RLOrderPriorityDR.%Id()
			s:eobj.RLDateFrom'="" eobj.RLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateFrom)
			s:eobj.RLDateTo'="" eobj.RLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateTo)
			s:eobj.RLTimeFrom'="" eobj.RLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom)
			s:eobj.RLTimeTo'="" eobj.RLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom)
			s eobj.RLClinicType=obj.RLClinicType   //2022-4-11 钟荣枫
			
			s rs=##class(web.DHCBL.CT.OECOrdCatRecLoc).SaveEntity(eobj)
			if rs["{success:'false'" s flag=1
			if rs["{success:'true'" s flag2=1
		}		
		if (flag=1)
		{
			if (flag2=1)
			{
				s result="{success:'false',info:'重复数据已跳过保存，非重复数据保存成功！'}"
			}
			else
			{
				s result="{success:'false',info:'重复数据已跳过保存！'}"
			}
		}
		else
		{
			s result="{success:'true'}"
		}
	}
	if (type="AC")	//医嘱子类接收科室
	{
		s length=$l(idstr,"&%")
		for i=1:1:length
		{
			s RLRowId=$p(idstr,"&%",i)
			s eobj=##class(web.Entity.CT.ARCItemCatRecLoc).%New()
			s obj=##class(User.ARCItemCatRecLoc).%OpenId(RLRowId)
			s eobj.RLParRef=$p(RLRowId,"||",1)
			s:obj.RLOrdLocDR'="" eobj.RLOrdLocDR=obj.RLOrdLocDR.%Id()
			s eobj.RLRecLocDR=RecLoc
			s eobj.RLFunction=obj.RLFunction
			s eobj.RLDefaultFlag=obj.RLDefaultFlag
			s eobj.RLTimeFrom=obj.RLTimeFrom
			s eobj.RLTimeTo=obj.RLTimeTo
			s:obj.RLCTHospitalDR'="" eobj.RLCTHospitalDR=obj.RLCTHospitalDR.%Id()
			s eobj.RLDateFrom=obj.RLDateFrom
			s eobj.RLDateTo=obj.RLDateTo
			s:obj.RLOrderPriorityDR'="" eobj.RLOrderPriorityDR=obj.RLOrderPriorityDR.%Id()
			s:eobj.RLDateFrom'="" eobj.RLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateFrom)
			s:eobj.RLDateTo'="" eobj.RLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.RLDateTo)
			s:eobj.RLTimeFrom'="" eobj.RLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom)
			s:eobj.RLTimeTo'="" eobj.RLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(eobj.RLTimeFrom)
			s eobj.RLClinicType=obj.RLClinicType   	//20220411 钟荣枫
			s rs=##class(web.DHCBL.CT.ARCItemCatRecLoc).SaveEntity(eobj)
			if rs["{success:'false'" s flag=1
			if rs["{success:'true'" s flag2=1
		}		
		if (flag=1)
		{
			if (flag2=1)
			{
				s result="{success:'false',info:'重复数据已跳过保存，非重复数据保存成功！'}"
			}
			else
			{
				s result="{success:'false',info:'重复数据已跳过保存！'}"
			}
		}
		else
		{
			s result="{success:'true'}"
		}
	}
	q result
}

/// 钟荣枫 2019-10-29  医嘱项、医嘱大类、医嘱子分类导入
/// w ##class(web.DHCBL.CT.RecLocSelect).ImportExcel("医嘱项","BCT008#颅底CT平扫(轴位)#收发室#超声医学科#Execute#N##2019-10-25")
/// w ##class(web.DHCBL.CT.RecLocSelect).ImportExcel("医嘱大类","其他#电工班##体检中心#N#2019-10-19#")
/// w ##class(web.DHCBL.CT.RecLocSelect).ImportExcel("医嘱子分类","麻醉#男科门诊#体检中心#N#2019-10-19#")
/// 0 失败，1修改/新增
ClassMethod ImportExcel(sheetname, datastr) As %String
{
	n (sheetname,datastr,%session)
	//s str="医嘱项医院&%医嘱代码&%医嘱名称&%病人科室所属医院&%病人科室&%接收科室所属医院&%接收科室&%医嘱优先级&%开始日期&%结束日期&%开始时间&%结束时间&%默认接收科室（Y/N）&%就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)"
	//s str=str_"^LinkHospId&%ARCIMCode&%ARCIMDesc&%ARCRLCTHospitalDR&%ARCRLOrdLocDR&%ARCRLRecLocHospDR&%ARCRLRecLocDR&%ARCRLOrderPriorityDR&%ARCRLDateFrom&%ARCRLDateTo&%ARCRLTimeFrom&%ARCRLTimeTo&%ARCRLDefaultFlag&%ARCRLClinicType"
	//检查CT#BCT008#颅底CT平扫(轴位)#收发室#超声医学科#Execute#N##2019-10-25
	s result =0
	q:datastr="" 0 
	if (sheetname["医嘱项") //User.ARCItmRecLoc 
	{
		s LinkHospDesc=$p(datastr,"#",1)
		s LinkHospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(LinkHospDesc),0))
		q:LinkHospId="" 0
		s ARCIMCode=$p(datastr,"#",2)
		s ARCIMDesc=$p(datastr,"#",3)
		q:ARCIMCode="" 0
		
		s ARCIMRowID=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",ARCIMCode,LinkHospId)
		q:ARCIMRowID="" 0
		s RLOrdLocHospDesc=$p(datastr,"#",4)
		s OrdLocDesc=$p(datastr,"#",5)
		
		s RLOrdLocHospDR=""
		if (RLOrdLocHospDesc'="")
		{
			s RLOrdLocHospDR=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(RLOrdLocHospDesc),0))
			q:RLOrdLocHospDR="" 0
		}
		s OrdLocDR=""
		s:OrdLocDesc'="" OrdLocDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Loc",OrdLocDesc,RLOrdLocHospDR)
		
		s RLRecLocHospDesc=$p(datastr,"#",6)
		s RecLocDesc=$p(datastr,"#",7)
		q:RecLocDesc="" 0	//	接收科室为空
		s RLRecLocHospDR=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(RLRecLocHospDesc),0))
		q:RLRecLocHospDR="" 0
		s RecLocDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Loc",RecLocDesc,RLRecLocHospDR)
		q:RecLocDR="" 0
		
		s Priority=$p(datastr,"#",8)
		s PriorityDR=""
		s:Priority'="" PriorityDR=$o(^OECPR(0,"Desc",$$ALPHAUP^SSUTIL4(Priority),0))
		s RLDateFrom=$p(datastr,"#",9)
		s RLDateTo=$p(datastr,"#",10)
		s RLTimeFrom=$p(datastr,"#",11)
		s RLTimeTo=$p(datastr,"#",12)
			
		
		s RLDefaultFlag=$p(datastr,"#",13)
		s:(RLDefaultFlag="Y") RLDefaultFlag="true"
		s:(RLDefaultFlag="N") RLDefaultFlag="false"
		
		
		s RLClinicType=$p(datastr,"#",14)	//就诊类型  2022-4-11 钟荣枫
		q:((RLClinicType'="O")&&(RLClinicType'="E")&&(RLClinicType'="I")&&(RLClinicType'="H")&&(RLClinicType'="N")&&(RLClinicType'="")) 0
		//"21||1^224^1531^^Execute^^2019-10-24^^^^false^Execute^"
		s str=ARCIMRowID_"^"_OrdLocDR_"^"_RecLocDR_"^"_PriorityDR_"^"_RLDateFrom_"^"_RLDateTo_"^"_RLTimeFrom_"^"_RLTimeTo_"^"_RLDefaultFlag_"^^^"_RLClinicType
	   	s re=##class(web.DHCBL.CT.ARCItmRecLoc).AddReceiveLoc(str)		
		if (re["success:'true'")
		{
			 s result=1  					
		}
		if (re["success:'false'")
		{
			s result=0				
		}
		
	}
		//s str="医嘱大类所属医院&%医嘱大类代码&%医嘱大类名称&%病人科室医院&%病人科室&%接收科室医院&%接收科室&%功能(Execute,Processing)&%默认(Y/N)&%开始时间&%结束时间&%医院&%开始日期&%结束日期&%医嘱优先级&%就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)"
		//s str=str_"^LinkHospId&%ORCATCode&%ORCATDesc&%RLOrdLocDRHosp&%RLOrdLocDR&%RLRecLocDRHosp&%RLRecLocDR&%RLFunction&%RLDefaultFlag&%RLTimeFrom&%RLTimeTo&%RLCTHospitalDR&%RLDateFrom&%RLDateTo&%RLOrderPriorityDR&%RLClinicType"
		if (sheetname["医嘱大类") //OEC_OrdCatRecLoc
		{	
			s LinkHospDesc=$p(datastr,"#",1)
			s LinkHospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(LinkHospDesc),0))
			q:LinkHospId="" 0
			s RLParRefCode=$p(datastr,"#",2)
			s RLParRefDesc=$p(datastr,"#",3)
			
			s RLParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("OEC_OrderCategory",RLParRefCode,LinkHospId)
			
			s RLOrdLocHospDesc=$p(datastr,"#",4)
			s OrdLocDesc=$p(datastr,"#",5)
			
			s RLOrdLocHospDR=""
			if (RLOrdLocHospDesc'="")
			{
				s RLOrdLocHospDR=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(RLOrdLocHospDesc),0))
				q:RLOrdLocHospDR="" 0
			}
			s OrdLocDR=""
			s:OrdLocDesc'="" OrdLocDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Loc",OrdLocDesc,RLOrdLocHospDR)
			
			s RLRecLocHospDesc=$p(datastr,"#",6)
			s RecLocDesc=$p(datastr,"#",7)
			
			q:RecLocDesc="" 0	//	接收科室为空
			s RLRecLocHospDR=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(RLRecLocHospDesc),0))
			q:RLRecLocHospDR="" 0
			s RecLocDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Loc",RecLocDesc,RLRecLocHospDR)
			q:RecLocDR="" 0
		
			s RLFunction=$p(datastr,"#",8)
			if (RLFunction="")
			{
				s RLFunction="Execute"
			}
			elseif ((RLFunction'="")&&(RLFunction'="Execute")&&(RLFunction'="Processing")) {
				q 0
			}
			s RLDefaultFlag=$p(datastr,"#",9)
			s RLTimeFrom=$p(datastr,"#",10)
			s RLTimeTo=$p(datastr,"#",11)
			
			s Hospital=$p(datastr,"#",12)
			s HospitalDR=""
			s:Hospital'="" HospitalDR=$O(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Hospital),0))
			s RLDateFrom=$p(datastr,"#",13)
			s RLDateTo=$p(datastr,"#",14)
			
			s Priority=$p(datastr,"#",15)
			s PriorityDR=""
			s:Priority'="" PriorityDR=$o(^OECPR(0,"Desc",$$ALPHAUP^SSUTIL4(Priority),0))
			//w ##class(web.DHCBL.CT.RecLocSelect).ImportExcel("医嘱大类","其他#电工班#体检中心#Execute#N##2019-10-19#")
			s RLClinicType=$p(datastr,"#",16)	//就诊类型  2022-4-11 钟荣枫
			q:((RLClinicType'="O")&&(RLClinicType'="E")&&(RLClinicType'="I")&&(RLClinicType'="H")&&(RLClinicType'="N")&&(RLClinicType'="")) 0
			
   			s eobj=##class(web.Entity.CT.OECOrdCatRecLoc).%New()
			s eobj.RLParRef=RLParRef
			s eobj.RLOrdLocDR=OrdLocDR
			s eobj.RLRecLocDR=RecLocDR
			s eobj.RLFunction=RLFunction
			s eobj.RLDefaultFlag=RLDefaultFlag
			s eobj.RLDateFrom=RLDateFrom
			s eobj.RLTimeFrom=RLTimeFrom
			s eobj.RLDateTo=RLDateTo
			s eobj.RLTimeTo=RLTimeTo
			s eobj.RLCTHospitalDR=HospitalDR
			s eobj.RLOrderPriorityDR=PriorityDR
			s eobj.RLClinicType=RLClinicType
			s estr=##class(web.DHCBL.CT.OECOrdCatRecLoc).SaveEntity(eobj)
			if (estr["success:'true'")
			{
				 s result=1  					
			}
			if (estr["success:'false'")
			{
				s result=0				
				
			}
		}
	//s str="医嘱子分类所属医院&%医嘱子类代码&%医嘱子类名称&%病人科室医院&%病人科室&%接收科室医院&%接收科室&%功能(Execute,Processing)&%默认&%开始时间&%结束时间&%医院&%开始日期&%结束日期&%医嘱优先级&%就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)"
	//s str=str_"^LinkHospId&%ARCICCode&%ARCICDesc&%RLOrdLocDRHosp&%RLOrdLocDR&%RLRecLocDRHosp&%RLRecLocDR&%RLFunction&%RLDefaultFlag&%RLTimeFrom&%RLTimeTo&%RLCTHospitalDR&%RLDateFrom&%RLDateTo&%RLOrderPriorityDR&%RLClinicType"
	if (sheetname["医嘱子分类") //ARC_ItemCatRecLoc
	{
		s LinkHospDesc=$p(datastr,"#",1)
		s LinkHospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(LinkHospDesc),0))
		q:LinkHospId="" 0
		s RLParRefCode=$p(datastr,"#",2)
		s RLParRefDesc=$p(datastr,"#",3)
		
		s ParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItemCat",RLParRefCode,LinkHospId)
		
		s OrdLocDesc=$p(datastr,"#",5)
		s RLOrdLocHospDesc=$p(datastr,"#",4)
		s RLOrdLocHospDR=""
		if (RLOrdLocHospDesc'="")
		{
			s RLOrdLocHospDR=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(RLOrdLocHospDesc),0))
			q:RLOrdLocHospDR="" 0
		}
		s OrdLocDR=""
		s:OrdLocDesc'="" OrdLocDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Loc",OrdLocDesc,RLOrdLocHospDR)
		
		s RecLocDesc=$p(datastr,"#",7)
		s RLRecLocHospDesc=$p(datastr,"#",6)
		q:RecLocDesc="" 0	//	接收科室为空
		s RLRecLocHospDR=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(RLRecLocHospDesc),0))
		q:RLRecLocHospDR="" 0
		s RecLocDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Loc",RecLocDesc,RLRecLocHospDR)
		q:RecLocDR="" 0
	//s str="医嘱子分类所属医院&%医嘱子类代码&%医嘱子类名称&%病人科室医院&%病人科室&%接收科室医院&%接收科室&%功能(Execute,Processing)&%默认&%开始时间&%结束时间&%医院&%开始日期&%结束日期&%医嘱优先级&%就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)"
		s RLFunction=$p(datastr,"#",8)
		if (RLFunction="")
		{
			s RLFunction="Execute"
		}
		elseif ((RLFunction'="")&&(RLFunction'="Execute")&&(RLFunction'="Processing")) {
			q 0
		}
		
		s RLDefaultFlag=$p(datastr,"#",9)
		s RLTimeFrom=$p(datastr,"#",10)
		s RLTimeTo=$p(datastr,"#",11)
		s Hospital=$p(datastr,"#",12)
		s HospitalDR=""
		s:Hospital'="" HospitalDR=$O(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Hospital),0))
		
		s RLDateFrom=$p(datastr,"#",13)
		s RLDateTo=$p(datastr,"#",14)
		
		s Priority=$p(datastr,"#",15)
		s PriorityDR=""
		s:Priority'="" PriorityDR=$o(^OECPR(0,"Desc",$$ALPHAUP^SSUTIL4(Priority),0))
		s RLClinicType=$p(datastr,"#",16)	//就诊类型  2022-4-11 钟荣枫
		q:((RLClinicType'="O")&&(RLClinicType'="E")&&(RLClinicType'="I")&&(RLClinicType'="H")&&(RLClinicType'="N")&&(RLClinicType'="")) 0
			
		s eobj =##class(web.Entity.CT.ARCItemCatRecLoc).%New()
				
		s eobj.RLParRef=ParRef
		s eobj.RLRowId=""
		s eobj.RLOrdLocDR=OrdLocDR
		s eobj.RLRecLocDR=RecLocDR
		s eobj.RLFunction=RLFunction
		s eobj.RLDefaultFlag=RLDefaultFlag
		s eobj.RLDateFrom=RLDateFrom
		s eobj.RLTimeFrom=RLTimeFrom
		s eobj.RLDateTo=RLDateTo
		s eobj.RLTimeTo=RLTimeTo
		s eobj.RLCTHospitalDR=HospitalDR
		s eobj.RLOrderPriorityDR=PriorityDR
		s eobj.RLClinicType=RLClinicType
		s estr= ##class(web.DHCBL.CT.ARCItemCatRecLoc).SaveEntity(eobj)
		if (estr["success:'true'")
		{
			 s result=1  					
		}
		if (estr["success:'false'")
		{
			s result=0				
			
		}
	}
	
	q result
}

/// Function: 根据菜单日志对照 取对照的表
/// CreateDate:2022-04-22
/// Creator:zrf
/// Input:  bdp功能大表的代码
/// Output: result:结果 User类1^User类2^User类3...
/// OHters: w ##class(web.DHCBL.CT.RecLocSelect).GetLinkTable("RecLocSelect")
ClassMethod GetLinkTable(Code As %String) As %String
{
   s result=""  
   q:Code="" ""       
   s:Code'="" Code=$ZCONVERT(Code,"U") //转换成大写 
   
   s menucode=##class(web.DHCBL.BDP.BDPExecutables).GetMenuNameByTable(Code)  /// 获取菜单名
   s LinkTableName=0
   for
   {
     s LinkTableName=$o(^User.BDPMenuTableI("mt"," "_$zcvt(menucode,"U"),LinkTableName))   /// 获取菜单日志对照的授权数据
     q:LinkTableName=""
     s LinkTableNameI=$tr(LinkTableName," ","")   
     if result="" s result=  LinkTableNameI
     else  s result=result_"^"_LinkTableNameI
   }
   q result
}

}
