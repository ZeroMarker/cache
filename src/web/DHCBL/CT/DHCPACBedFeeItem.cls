Import SQLUser

/// 名称:科室/部门/病区  科室/病区-病区床位-床位附加费用
/// 描述:床位附加费用维护，包含增删改查功能
/// 编写者：基础数据平台组 - 钟荣枫 
/// 编写日期:  2020-2-7
Class web.DHCBL.CT.DHCPACBedFeeItem Extends %RegisteredObject
{

/// Creator：钟荣枫 		
/// CreatDate: 2020-1-15
/// Description：查询 床位附加费用
/// Table:DHC_PAC_BedFeeItem,DHC_PACBed_FeeType,ARC_ItmMast,PAC_BedType
/// Input：
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCPACBedFeeItem","GetList","","1","","","")
Query GetList(rowid As %String, ParRef As %String, BedChildsub As %String, feetype As %String, arcim As %String) As %Query(ROWSPEC = "BEDIRowId,BEDIBEDParRef,BEDIBEDChildsub,BEDIChildsub,BEDIDesc,BEDIIFeeType,BEDIARCIMDR,BEDIStartDate,BEDIEndDate,ARCIMPrice,BEDIAdmReasonDR,BEDIStartAge,BEDIEndAge,BEDIFeeTime")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, ParRef As %String, BedChildsub As %String, feetype As %String, arcim As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s BEDIRowId=rowid
		s BEDIBEDParRef=$p(BEDIRowId,"||",1)				//床位类型
		s BEDIBEDChildsub=$p(BEDIRowId,"||",2)
		s BEDIChildsub=$p(BEDIRowId,"||",3)
		s BEDIDesc=$p($g(^PAWARD(BEDIBEDParRef)),"^",2)		//床位类型描述
		s BEDIIFeeType=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",1) //床位附加费用类型
		s:BEDIIFeeType'="" BEDIIFeeType=$p($g(^PAC("FEETP",BEDIIFeeType)),"^",2)		//床位附加费用类型描述
		s BEDIARCIMDR=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",2) //床位附加费用医嘱项
		s ARCIMPrice= ##class(web.DHCBL.CT.ARCItmMast).GetOrderPrice(BEDIARCIMDR)				//医嘱项费用
		s BEDIARCIMParRef=$p(BEDIARCIMDR,"||",1)
		s BEDTPIARCIMSub=$p(BEDIARCIMDR,"||",2)
		s:BEDIARCIMDR'="" BEDIARCIMDR=$p($g(^ARCIM(BEDIARCIMParRef,BEDTPIARCIMSub,1)),"^",2)	//医嘱项描述
		s BEDIStartDate=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",3)	//开始日期
		s:BEDIStartDate'="" BEDIStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BEDIStartDate) //转换日期格式
		s BEDIEndDate=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",4)		//开始日期
		s:BEDIEndDate'="" BEDIEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BEDIEndDate) //转换日期格式
		s BEDIAdmReasonDR=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",5)	//费别
		s:BEDIAdmReasonDR'="" BEDIAdmReasonDR=$p($g(^PAC("ADMREA",BEDIAdmReasonDR)),"^",2)	//费别描述
		s BEDIStartAge=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",6)		//起始年龄
		s BEDIEndAge=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",7)		//截止年龄		
		s BEDIFeeTime=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",8) //时制名称指针
		s:BEDIFeeTime'="" BEDIFeeTime=$lg($g(^CT.BDP.CT.BedFeeTimeD(BEDIFeeTime)),3) //时制名称描述		
		d OutputRow
	}
	else
	{
		s BEDIBEDParRef=ParRef
		s BEDIBEDChildsub=BedChildsub
		
		s BEDIChildsub=0
		for
		{
			s BEDIChildsub=$o(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)) q:BEDIChildsub=""
			s BEDIRowId=BEDIBEDParRef_"||"_BEDIBEDChildsub_"||"_BEDIChildsub
		
			s BEDIDesc=$p($g(^PAWARD(BEDIBEDParRef)),"^",2)		//床位类型描述
			s BEDIIFeeType=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",1) //床位附加费用类型
			if (feetype'="")
			{
				continue:feetype'=BEDIIFeeType
			}
			s:BEDIIFeeType'="" BEDIIFeeType=$p($g(^PAC("FEETP",BEDIIFeeType)),"^",2)		//床位附加费用类型描述
			s BEDIARCIMDR=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",2) //床位附加费用医嘱项
			if (arcim'="")
			{
				continue:arcim'=BEDIARCIMDR
			}
			s ARCIMPrice= ##class(web.DHCBL.CT.ARCItmMast).GetOrderPrice(BEDIARCIMDR)				//医嘱项费用
			s BEDIARCIMParRef=$p(BEDIARCIMDR,"||",1)
			s BEDTPIARCIMSub=$p(BEDIARCIMDR,"||",2)
			s:BEDIARCIMDR'="" BEDIARCIMDR=$p($g(^ARCIM(BEDIARCIMParRef,BEDTPIARCIMSub,1)),"^",2)	//医嘱项描述
			s BEDIStartDate=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",3)	//开始日期
			s:BEDIStartDate'="" BEDIStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BEDIStartDate) //转换日期格式
			s BEDIEndDate=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",4)		//开始日期
			s:BEDIEndDate'="" BEDIEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BEDIEndDate) //转换日期格式
			
			s BEDIAdmReasonDR=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",5)	//费别
			s:BEDIAdmReasonDR'="" BEDIAdmReasonDR=$p($g(^PAC("ADMREA",BEDIAdmReasonDR)),"^",2)	//费别描述
			s BEDIStartAge=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",6)		//起始年龄
			s BEDIEndAge=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",7)		//截止年龄
			s BEDIFeeTime=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",8) //时制名称指针
			s:BEDIFeeTime'="" BEDIFeeTime=$lg($g(^CT.BDP.CT.BedFeeTimeD(BEDIFeeTime)),3) //时制名称描述	
			d OutputRow
		}
			
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(BEDIRowId,BEDIBEDParRef,BEDIBEDChildsub,BEDIChildsub,BEDIDesc,BEDIIFeeType,BEDIARCIMDR,BEDIStartDate,BEDIEndDate,ARCIMPrice,BEDIAdmReasonDR,BEDIStartAge,BEDIEndAge,BEDIFeeTime)
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
/// CreatDate: 2020-1-15
/// Description：查询 床位附加费用
/// Table：
/// Input：code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCPACBedFeeItem","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, ParRef As %String) As %Query(ROWSPEC = "BEDIRowId,BEDIBEDParRef,BEDIBEDChildsub,BEDIChildsub,BEDIDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, ParRef As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (rowid'="") //根据rowid返回该条记录
	{
		s BEDIRowId=rowid
		s BEDIBEDParRef=$p(BEDIRowId,"||",1)				//床位类型
		s BEDIBEDChildsub=$p(BEDIRowId,"||",2)
		s BEDIChildsub=$p(BEDIRowId,"||",3)
		s BEDIDesc=$p($g(^PAWARD(BEDIBEDParRef)),"^",2)		//床位类型描述
		d OutputRowCmb
	}
	else
	{
		s BEDIBEDParRef=ParRef
		s BEDIBEDChildsub=0
		for
		{
			s BEDIBEDChildsub=$o(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub)) q:BEDIBEDChildsub=""
			s BEDIChildsub=0
			for
			{
				s BEDIChildsub=$o(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)) q:BEDIChildsub=""
				s BEDIRowId=BEDIBEDParRef_"||"_BEDIBEDChildsub_"||"_BEDIChildsub
			
				s BEDIDesc=$p($g(^PAWARD(BEDIBEDParRef)),"^",2)		//床位类型描述
				d OutputRowCmb
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(BEDIRowId,BEDIBEDParRef,BEDIBEDChildsub,BEDIChildsub,BEDIDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator:钟荣枫 
/// CreatDate:2020-1-16
/// Description:数据重复验证方法,js调用
/// Table:
/// Input:
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.DHCPACBedFeeItem).FormValidate("","1","1","1","1||1")
ClassMethod FormValidate(id As %String, parref As %String, bedchildsub As %String, feetype As %String, arcim As %String) As %String
{
	s flag=0
	s flagc=""
	s flagd=""
	if (id="") //如果为空，增加时的重复判断
	{
		s ParRef=parref
		s BEDIBEDChildsub=bedchildsub
		s ChildSub=0
		for
		{
			s ChildSub=$o(^PAWARD(ParRef,"BED",BEDIBEDChildsub,"FEE",ChildSub))	q:ChildSub=""
			s BEDIIFeeType=$p($g(^PAWARD(ParRef,"BED",BEDIBEDChildsub,"FEE",ChildSub)),"^",1) //床位附加费用类型
			s BEDIARCIMDR=$p($g(^PAWARD(ParRef,"BED",BEDIBEDChildsub,"FEE",ChildSub)),"^",2) //床位附加费用医嘱项
			if (BEDIIFeeType=feetype) 
			{
				s flagc=1
			}
			if (BEDIARCIMDR=arcim)
			{
				s flagd=1
			}
		}
		if ((flagc>0)&&(flagd>0))
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	else //如果不为空，修改时的重复判断
	{
		s ParRef=$p(id,"||",1)
		s BEDIBEDChildsub=$p(id,"||",2)	
		s ChildSub=$p(id,"||",3)				
		s FeeType=$p($g(^PAWARD(ParRef,"BED",BEDIBEDChildsub,"FEE",ChildSub)),"^",1) //床位附加费用类
		s ARCIMDR=$p($g(^PAWARD(ParRef,"BED",BEDIBEDChildsub,"FEE",ChildSub)),"^",2) //床位附加费用医嘱项
		if (feetype'="")&&(arcim'="")
     	{
	     	if '((FeeType=feetype)&&(ARCIMDR=arcim))
      		{
	      		s ChildSub=0
				for
				{
					s ChildSub=$o(^PAWARD(ParRef,"BED",BEDIBEDChildsub,"FEE",ChildSub))	q:ChildSub=""
					s BEDIIFeeType=$p($g(^PAWARD(ParRef,"BED",BEDIBEDChildsub,"FEE",ChildSub)),"^",1) //床位附加费用类
					s BEDIARCIMDR=$p($g(^PAWARD(ParRef,"BED",BEDIBEDChildsub,"FEE",ChildSub)),"^",2) //床位附加费用医嘱项
					if (BEDIIFeeType=feetype) 
					{
						s flagc=1
					}
					if (BEDIARCIMDR=arcim)
					{
						s flagd=1
					}
				}
				if ((flagc>0)&&(flagd>0))
				{
					s flag=1  //返回重复标志
				}
				else
				{
					s flag=0 //返回不重复标志
				}
      		}
     	} 
		
	}
	q flag
}

/// Creator：钟荣枫 
/// CreatDate: 2020-1-15
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.DHCPACBedFeeItem
/// Input：id
/// Other:w ##class(web.DHCBL.CT.DHCPACBedFeeItem).OpenData("1||2||1","")
/// RetFlag=""时，用于EXT, =JSON时，用于HISUI，不输出 "{list:["_str_"]}"  
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{
    s str = ""
	s pobj = ##class(User.DHCPACBedFeeItem).%OpenId(id)
	s eobj = ##class(web.Entity.CT.DHCPACBedFeeItem).%New()
	s eobj.BEDIRowId=id
	s eobj.BEDIBEDParRef =$p(id,"||",1)
	s eobj.BEDIBEDChildsub =$p(id,"||",2)
	s eobj.BEDIChildsub =$p(id,"||",3)
	s eobj.BEDIIFeeType = pobj.BEDIIFeeType
	if $IsObject(pobj.BEDIIFeeType){
		s eobj.BEDIIFeeType = pobj.BEDIIFeeType.%Id() 
	}
	s eobj.BEDIARCIMDR = pobj.BEDIARCIMDR
	if $IsObject(pobj.BEDIARCIMDR){
		s eobj.BEDIARCIMDR = pobj.BEDIARCIMDR.%Id() 
	}
	s eobj.BEDIStartDate =pobj.BEDIStartDate
	s eobj.BEDIStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.BEDIStartDate)
	s eobj.BEDIEndDate =pobj.BEDIEndDate
	s eobj.BEDIEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.BEDIEndDate)
	
	s eobj.BEDIAdmReasonDR =pobj.BEDIAdmReasonDR
	if $IsObject(pobj.BEDIAdmReasonDR){
		s eobj.BEDIAdmReasonDR = pobj.BEDIAdmReasonDR.%Id() 
	}
	s eobj.BEDIFeeTime=pobj.BEDIFeeTime
	if $IsObject(pobj.BEDIFeeTime){
		s eobj.BEDIFeeTime = pobj.BEDIFeeTime.%Id() 
	} 
	s eobj.BEDIStartAge =pobj.BEDIStartAge
	s eobj.BEDIEndAge =pobj.BEDIEndAge
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	if (RetFlag="")
	{
		s str = "{list:["_str_"]}"
	}
	q str
}

/// w ##class(web.DHCBL.CT.DHCPACBedFeeItem).SaveText()
ClassMethod SaveText()
{
	s bobj = ##class(web.Entity.CT.DHCPACBedFeeItem).%New()
	s bobj.BEDIRowId=""
	s bobj.BEDIBEDParRef=1
	s bobj.BEDIBEDChildsub=2
	s bobj.BEDIIFeeType=4
	s bobj.BEDIARCIMDR="5||1"
	s bobj.BEDIStartDate="2020-2-9"
	s bobj.BEDIStartAge=10
	s result= ##class(web.DHCBL.CT.DHCPACBedFeeItem).SaveEntity(bobj)
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-1-15
/// Description：保存 床位附加费用
/// Input: eobj As web.DHCBL.CT.DHCPACBedFeeItem
/// Table：User.DHCPACBedFeeItem
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.CT.DHCPACBedFeeItem).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCPACBedFeeItem) As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s flag=..FormValidate(eobj.BEDIRowId,eobj.BEDIBEDParRef,eobj.BEDIBEDChildsub,eobj.BEDIIFeeType,eobj.BEDIARCIMDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s:eobj.BEDIStartDate'="" eobj.BEDIStartDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BEDIStartDate)
		s:eobj.BEDIEndDate'="" eobj.BEDIEndDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BEDIEndDate)
		if (eobj.BEDIRowId="")
		{	
	        s obj=##class(User.DHCPACBedFeeItem).%New(eobj.BEDIBEDParRef_"||"_eobj.BEDIBEDChildsub)
		}
		else
		{
			s obj=##class(User.DHCPACBedFeeItem).%OpenId(eobj.BEDIRowId)
			s bobj = ##class(web.Entity.CT.DHCPACBedFeeItem).%New()
			
			s bobj.BEDIRowId = eobj.BEDIRowId
			if $IsObject(obj.BEDIIFeeType)
			{
				s bobj.BEDIBEDParRef = obj.BEDIBEDParRef.%Id() 
			}
			if $IsObject(obj.BEDIIFeeType)
			{
				s bobj.BEDIIFeeType = obj.BEDIIFeeType.%Id() 
			}
			if $IsObject(obj.BEDIARCIMDR)
			{
				s bobj.BEDIARCIMDR = obj.BEDIARCIMDR.%Id() 
			}
			s bobj.BEDIStartDate = obj.BEDIStartDate
			s bobj.BEDIEndDate = obj.BEDIEndDate
			if $IsObject(obj.BEDIAdmReasonDR)
			{
				s bobj.BEDIAdmReasonDR = obj.BEDIAdmReasonDR.%Id() 
			}
			if $IsObject(obj.BEDIFeeTime)
			{
			s bobj.BEDIFeeTime = obj.BEDIFeeTime.%Id() 
			} 
			s bobj.BEDIStartAge = obj.BEDIStartAge
			s bobj.BEDIEndAge = obj.BEDIEndAge
			
		}	
		d:eobj.BEDIBEDParRef'="" obj.BEDIBEDParRefSetObjectId(eobj.BEDIBEDParRef)	// 床位类型
		d:eobj.BEDIBEDParRef="" obj.BEDIBEDParRefSetObjectId("")
		d:eobj.BEDIIFeeType'="" obj.BEDIIFeeTypeSetObjectId(eobj.BEDIIFeeType)		//费用类型
		d:eobj.BEDIIFeeType="" obj.BEDIIFeeTypeSetObjectId("")
		d:eobj.BEDIARCIMDR'="" obj.BEDIARCIMDRSetObjectId(eobj.BEDIARCIMDR)		//费用医嘱项
		d:eobj.BEDIARCIMDR="" obj.BEDIARCIMDRSetObjectId("")
		d:eobj.BEDIFeeTime'="" obj.BEDIFeeTimeSetObjectId(eobj.BEDIFeeTime) //床位费时制
		D:eobj.BEDIFeeTime="" obj.BEDIFeeTimeSetObjectId("")
		
		s obj.BEDIStartDate=eobj.BEDIStartDate					//开始时间
		s obj.BEDIEndDate=eobj.BEDIEndDate						//结束时间
		d:eobj.BEDIAdmReasonDR'="" obj.BEDIAdmReasonDRSetObjectId(eobj.BEDIAdmReasonDR)		//费别
		d:eobj.BEDIAdmReasonDR="" obj.BEDIAdmReasonDRSetObjectId("")
		s obj.BEDIStartAge=eobj.BEDIStartAge				//起始年龄
		s obj.BEDIEndAge=eobj.BEDIEndAge					//截止年龄
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			s BedTypeDesc=$p($g(^PAWARD(eobj.BEDIBEDParRef)),"^",2)
			d:eobj.BEDIRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PAC_BedFeeItem","User.DHCPACBedFeeItem","床位附加费用",id,BedTypeDesc,"A",eobj)
			d:eobj.BEDIRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PAC_BedFeeItem","User.DHCPACBedFeeItem","床位附加费用",id,BedTypeDesc,"U",eobj,bobj)
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位附加费用","web.DHCBL.CT.DHCPACBedFeeItem","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：钟荣枫
/// CreatDate: 2020-1-15
/// Description：根据id删除 床位附加费用
/// Table：User.DHCPACBedFeeItem
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.CT.DHCPACBedFeeItem).DeleteData("1||2||2")
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj = ##class(User.DHCPACBedFeeItem).%OpenId(id)
	s eobj = ##class(web.Entity.CT.DHCPACBedFeeItem).%New()
	s eobj.BEDIRowId = id
	s eobj.BEDIBEDParRef  = $p(id,"||",1)
	s eobj.BEDIBEDChildsub = $p(id,"||",2)
	s eobj.BEDIChildsub = $p(id,"||",3)
	s:pobj.BEDIIFeeType'="" eobj.BEDIIFeeType = pobj.BEDIIFeeType.%Id()
	s:pobj.BEDIARCIMDR'="" eobj.BEDIARCIMDR = pobj.BEDIARCIMDR.%Id()
	s eobj.BEDIStartDate =  pobj.BEDIStartDate 
	s eobj.BEDIEndDate =  pobj.BEDIEndDate
	s:pobj.BEDIAdmReasonDR'="" eobj.BEDIAdmReasonDR = pobj.BEDIAdmReasonDR.%Id()
	s eobj.BEDIStartAge =  pobj.BEDIStartAge
	s eobj.BEDIEndAge =  pobj.BEDIEndAge
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(User.DHCPACBedFeeItem).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		s BedTypeDesc=$p($g(^PAWARD(eobj.BEDIBEDParRef)),"^",2)
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PAC_BedFeeItem","User.DHCPACBedFeeItem","床位附加费用",id,BedTypeDesc,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位附加费用","web.DHCBL.CT.DHCPACBedFeeItem","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	
	q result
}

/// Function:获取父表的描述
/// CreateDate:2020-1-17
/// Creator:钟荣枫
/// Debug: w ##class(web.DHCBL.CT.DHCPACBedFeeItem).GetParentDesc("1")
ClassMethod GetParentDesc(ParentId As %String) As %String
{
   s result=""
   s result=$tr($p($g(^PAWARD(ParentId)),"^",2),$c(13,10))		//床位类型描述
   q result
}

}
