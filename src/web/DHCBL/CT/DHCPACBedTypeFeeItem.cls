Import SQLUser

/// 名称:科室/部门/病区  床位类型-床位类型附加费用
/// 描述:床位类型附加费用维护，包含增删改查功能
/// 编写者：基础数据平台组 - 钟荣枫 
/// 编写日期:  2020-1-15
Class web.DHCBL.CT.DHCPACBedTypeFeeItem Extends %RegisteredObject
{

/// Creator：钟荣枫 		
/// CreatDate: 2020-1-15
/// Description：查询 床位类型附加费用
/// Table:DHC_PAC_BedTypeFeeItem,DHC_PACBed_FeeType,ARC_ItmMast,PAC_BedType
/// Input：
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCPACBedTypeFeeItem","GetList","3||1","","","")
Query GetList(rowid As %String, ParRef As %String, feetype As %String, arcim As %String, hospid As %String) As %Query(ROWSPEC = "BEDTPIRowId,BEDTPIBEDTPParRef,BEDTPIChildsub,BEDTPIDesc,BEDTPIFeeType,BEDTPIARCIMDR,BEDTPIStartDate,BEDTPIEndDate,ARCIMPrice,BEDTPIAdmReasonDR,BEDTPIStartAge,BEDTPIEndAge,BEDTPIMomBedTypeDR,BEDTPIFeeTime")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, ParRef As %String, feetype As %String, arcim As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		
		//^PAC("BEDTP",6)="四人间及以上床位费23^四人间及以上床位费23^N^^N^^^65042^"  床位
		s BEDTPIRowId=rowid
		s BEDTPIBEDTPParRef=$p(BEDTPIRowId,"||",1)				//床位类型
		s BEDTPIChildsub=$p(BEDTPIRowId,"||",2)
		s BEDTPIDesc=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef)),"^",2)		//床位类型描述
		//床位类型费用项目
		s BEDTPIFeeType=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",1) //床位附加费用类
		s:BEDTPIFeeType'="" BEDTPIFeeType=$p($g(^PAC("FEETP",BEDTPIFeeType)),"^",2)		//床位附加费用类型描述
		//^PAC("FEETP",{FT_RowId})
		s BEDTPIARCIMDR=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",2) //床位附加费用医嘱项
		s ARCIMPrice= ##class(web.DHCBL.CT.ARCItmMast).GetOrderPrice(BEDTPIARCIMDR,hospid)				//医嘱项费用
		s BEDTPIARCIMParRef=$p(BEDTPIARCIMDR,"||",1)
		s BEDTPIARCIMSub=$p(BEDTPIARCIMDR,"||",2)
		s:BEDTPIARCIMDR'="" BEDTPIARCIMDR=$p($g(^ARCIM(BEDTPIARCIMParRef,BEDTPIARCIMSub,1)),"^",2)	//医嘱项描述
		s BEDTPIStartDate=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",3)	//开始日期
		s:BEDTPIStartDate'="" BEDTPIStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BEDTPIStartDate) //转换日期格式
		s BEDTPIEndDate=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",4)		//开始日期
		s:BEDTPIEndDate'="" BEDTPIEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BEDTPIEndDate) //转换日期格式
		
		s BEDTPIAdmReasonDR=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",5)	//费别
		s:BEDTPIAdmReasonDR'="" BEDTPIAdmReasonDR=$p($g(^PAC("ADMREA",BEDTPIAdmReasonDR)),"^",2)	//费别描述
		
		s BEDTPIStartAge=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",6)		//起始年龄
		s BEDTPIEndAge=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",7)		//截止年龄	
		s BEDTPIMomBedTypeDR=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",9)		//母亲床位类型DR
		s:BEDTPIMomBedTypeDR'="" BEDTPIMomBedTypeDR=$p($g(^PAC("BEDTP",BEDTPIMomBedTypeDR)),"^",2)		//母亲床位类型DR
		s BEDTPIFeeTime=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",8) //时制名称指针
		s:BEDTPIFeeTime'="" BEDTPIFeeTime=$lg($g(^CT.BDP.CT.BedFeeTimeD(BEDTPIFeeTime)),3) //时制名称描述			
		d OutputRow
	}
	else
	{
		
		s BEDTPIBEDTPParRef=ParRef
		s BEDTPIChildsub=0
		for
		{
			s BEDTPIChildsub=$o(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)) q:BEDTPIChildsub=""
			s BEDTPIRowId=BEDTPIBEDTPParRef_"||"_BEDTPIChildsub
			
			s BEDTPIDesc=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef)),"^",2)		//床位类型描述
			s BEDTPIFeeType=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",1) //床位附加费用类型
			if (feetype'="")
			{
				continue:feetype'=BEDTPIFeeType
			}
			s:BEDTPIFeeType'="" BEDTPIFeeType=$p($g(^PAC("FEETP",BEDTPIFeeType)),"^",2)		//床位附加费用类型描述
			s BEDTPIARCIMDR=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",2) //床位附加费用医嘱项
			if (arcim'="")
			{
				continue:arcim'=BEDTPIARCIMDR
			}
			s ARCIMPrice= ##class(web.DHCBL.CT.ARCItmMast).GetOrderPrice(BEDTPIARCIMDR,hospid)				//医嘱项费用
			s BEDTPIARCIMParRef=$p(BEDTPIARCIMDR,"||",1)
			s BEDTPIARCIMSub=$p(BEDTPIARCIMDR,"||",2)
			s:BEDTPIARCIMDR'="" BEDTPIARCIMDR=$p($g(^ARCIM(BEDTPIARCIMParRef,BEDTPIARCIMSub,1)),"^",2)	//医嘱项描述
			s BEDTPIStartDate=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",3)	//开始日期
			s:BEDTPIStartDate'="" BEDTPIStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BEDTPIStartDate) //转换日期格式
			s BEDTPIEndDate=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",4)		//开始日期
			s:BEDTPIEndDate'="" BEDTPIEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BEDTPIEndDate) //转换日期格式
			
			s BEDTPIAdmReasonDR=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",5)	//费别
			s:BEDTPIAdmReasonDR'="" BEDTPIAdmReasonDR=$p($g(^PAC("ADMREA",BEDTPIAdmReasonDR)),"^",2)	//费别描述
			s BEDTPIStartAge=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",6)		//起始年龄
			s BEDTPIEndAge=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",7)		//截止年龄
			s BEDTPIMomBedTypeDR=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",9)		//母亲床位类型DR
			s:BEDTPIMomBedTypeDR'="" BEDTPIMomBedTypeDR=$p($g(^PAC("BEDTP",BEDTPIMomBedTypeDR)),"^",2)		//母亲床位类型DR
			s BEDTPIFeeTime=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",8) //时制名称指针
			s:BEDTPIFeeTime'="" BEDTPIFeeTime=$lg($g(^CT.BDP.CT.BedFeeTimeD(BEDTPIFeeTime)),3) //时制名称描述			
			d OutputRow
		}
		
		
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(BEDTPIRowId,BEDTPIBEDTPParRef,BEDTPIChildsub,BEDTPIDesc,BEDTPIFeeType,BEDTPIARCIMDR,BEDTPIStartDate,BEDTPIEndDate,ARCIMPrice,BEDTPIAdmReasonDR,BEDTPIStartAge,BEDTPIEndAge,BEDTPIMomBedTypeDR,BEDTPIFeeTime)
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
/// Description：查询 床位类型附加费用
/// Table：
/// Input：code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCPACBedTypeFeeItem","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, ParRef As %String) As %Query(ROWSPEC = "BEDTPIRowId,BEDTPIBEDTPParRef,BEDTPIChildsub,BEDTPIDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, ParRef As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (rowid'="") //根据rowid返回该条记录
	{
		//^PAC("BEDTP",6)="四人间及以上床位费23^四人间及以上床位费23^N^^N^^^65042^"  床位
		s BEDTPIRowId=rowid
		s BEDTPIBEDTPParRef=$p(BEDTPIRowId,"||",1)				//床位类型
		s BEDTPIChildsub=$p(BEDTPIRowId,"||",2)
		s BEDTPIDesc=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef)),"^",2)		//床位类型描述
		d OutputRowCmb
	}
	else
	{
		s BEDTPIBEDTPParRef=ParRef
		s BEDTPIChildsub=0
		for
		{
			s BEDTPIChildsub=$o(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)) q:BEDTPIChildsub=""
			s BEDTPIRowId=BEDTPIBEDTPParRef_"||"_BEDTPIChildsub
			
			s BEDTPIDesc=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef)),"^",2)		//床位类型描述
			d OutputRowCmb
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(BEDTPIRowId,BEDTPIBEDTPParRef,BEDTPIChildsub,BEDTPIDesc)
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
/// Other:w ##class(web.DHCBL.CT.DHCPACBedTypeFeeItem).FormValidate("3||2","3","1","11458||1")
ClassMethod FormValidate(id As %String, parref As %String, feetype As %String, arcim As %String) As %String
{
	//^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)
	s flag=0
	s flagc=""
	s flagd=""
	if (id="") //如果为空，增加时的重复判断
	{
		s ParRef=parref
		s ChildSub=0
		for
		{
			s ChildSub=$o(^PAC("BEDTP",ParRef,"FEE",ChildSub))	q:ChildSub=""
			s BEDTPIFeeType=$p($g(^PAC("BEDTP",ParRef,"FEE",ChildSub)),"^",1) //床位附加费用类
			s BEDTPIARCIMDR=$p($g(^PAC("BEDTP",ParRef,"FEE",ChildSub)),"^",2) //床位附加费用医嘱项
			if (BEDTPIFeeType=feetype) 
			{
				s flagc=1
			}
			if (BEDTPIARCIMDR=arcim)
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
		s ChildSub=$p(id,"||",2)				
		s FeeType=$p($g(^PAC("BEDTP",ParRef,"FEE",ChildSub)),"^",1)
		s ARCIMDR=$p($g(^PAC("BEDTP",ParRef,"FEE",ChildSub)),"^",2)
		if (feetype'="")&&(arcim'="")
     	{
	     	if '((FeeType=feetype)&&(ARCIMDR=arcim))
      		{
	      		;b ;1
	      		s ChildSub=0
				for
				{
					s ChildSub=$o(^PAC("BEDTP",ParRef,"FEE",ChildSub))	q:ChildSub=""
					s BEDTPIFeeType=$p($g(^PAC("BEDTP",ParRef,"FEE",ChildSub)),"^",1) //床位附加费用类
					s BEDTPIARCIMDR=$p($g(^PAC("BEDTP",ParRef,"FEE",ChildSub)),"^",2) //床位附加费用医嘱项
					if (BEDTPIFeeType=feetype) 
					{
						s flagc=1
					}
					if (BEDTPIARCIMDR=arcim)
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
/// Table：User.DHCPACBedTypeFeeItem
/// Input：id
/// Other:w ##class(web.DHCBL.CT.DHCPACBedTypeFeeItem).OpenData("3||1","")
/// RetFlag=""时，用于EXT, =JSON时，用于HISUI，不输出 "{list:["_str_"]}"  
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{
	
    s str = ""
	s pobj = ##class(User.DHCPACBedTypeFeeItem).%OpenId(id)
	s eobj = ##class(web.Entity.CT.DHCPACBedTypeFeeItem).%New()
	s eobj.BEDTPIRowId=id
	s eobj.BEDTPIBEDTPParRef =$p(id,"||",1)
	s eobj.BEDTPIChildsub =$p(id,"||",2)
	s eobj.BEDTPIFeeType = pobj.BEDTPIFeeType
	if $IsObject(pobj.BEDTPIFeeType){
		s eobj.BEDTPIFeeType = pobj.BEDTPIFeeType.%Id() 
	}
	s eobj.BEDTPIARCIMDR = pobj.BEDTPIARCIMDR
	if $IsObject(pobj.BEDTPIARCIMDR){
		s eobj.BEDTPIARCIMDR = pobj.BEDTPIARCIMDR.%Id() 
	}
	s eobj.BEDTPIFeeTime=pobj.BEDTPIFeeTime
	if $IsObject(pobj.BEDTPIFeeTime){
		s eobj.BEDTPIFeeTime = pobj.BEDTPIFeeTime.%Id() 
	} 	
	s eobj.BEDTPIStartDate =pobj.BEDTPIStartDate
	s eobj.BEDTPIStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.BEDTPIStartDate)
	s eobj.BEDTPIEndDate =pobj.BEDTPIEndDate
	s eobj.BEDTPIEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.BEDTPIEndDate)
	s eobj.BEDTPIAdmReasonDR = pobj.BEDTPIAdmReasonDR
	if $IsObject(pobj.BEDTPIAdmReasonDR){
		s eobj.BEDTPIAdmReasonDR = pobj.BEDTPIAdmReasonDR.%Id() 
	}
	s eobj.BEDTPIStartAge =pobj.BEDTPIStartAge
	s eobj.BEDTPIEndAge =pobj.BEDTPIEndAge
	
	s:pobj.BEDTPIMomBedTypeDR'="" eobj.BEDTPIMomBedTypeDR = pobj.BEDTPIMomBedTypeDR.%Id() 
	
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	if (RetFlag="")
	{
		s str = "{list:["_str_"]}"
	}
	q str
}

/// w ##class(web.DHCBL.CT.DHCPACBedTypeFeeItem).SaveText()
ClassMethod SaveText()
{
	s bobj = ##class(web.Entity.CT.DHCPACBedTypeFeeItem).%New()
	s bobj.BEDTPIRowId="1||7"
	s bobj.BEDTPIBEDTPParRef=1
	s bobj.BEDTPIFeeType=4
	s bobj.BEDTPIARCIMDR="11419||1"
	s bobj.BEDTPIStartDate="2020-1-16"
	s result= ##class(web.DHCBL.CT.DHCPACBedTypeFeeItem).SaveEntity(bobj)
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-1-15
/// Description：保存 床位类型附加费用
/// Input: eobj As web.DHCBL.CT.DHCPACBedTypeFeeItem
/// Table：User.DHCPACBedTypeFeeItem
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.CT.DHCPACBedTypeFeeItem).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCPACBedTypeFeeItem) As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s flag=..FormValidate(eobj.BEDTPIRowId,eobj.BEDTPIBEDTPParRef,eobj.BEDTPIFeeType,eobj.BEDTPIARCIMDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s:eobj.BEDTPIStartDate'="" eobj.BEDTPIStartDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BEDTPIStartDate)
		s:eobj.BEDTPIEndDate'="" eobj.BEDTPIEndDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BEDTPIEndDate)
		if (eobj.BEDTPIRowId="")
		{	
	        s obj=##class(User.DHCPACBedTypeFeeItem).%New(eobj.BEDTPIBEDTPParRef)
	        
		}
		else
		{
			s obj=##class(User.DHCPACBedTypeFeeItem).%OpenId(eobj.BEDTPIRowId)
			s bobj = ##class(web.Entity.CT.DHCPACBedTypeFeeItem).%New()
			
			s bobj.BEDTPIRowId = eobj.BEDTPIRowId
			if $IsObject(obj.BEDTPIFeeType)
			{
				s bobj.BEDTPIBEDTPParRef = obj.BEDTPIBEDTPParRef.%Id() 
			}
			if $IsObject(obj.BEDTPIFeeType)
			{
				s bobj.BEDTPIFeeType = obj.BEDTPIFeeType.%Id() 
			}
			if $IsObject(obj.BEDTPIARCIMDR)
			{
				s bobj.BEDTPIARCIMDR = obj.BEDTPIARCIMDR.%Id() 
			}
			if $IsObject(obj.BEDTPIFeeTime)
			{
				s bobj.BEDTPIFeeTime=obj.BEDTPIFeeTime.%Id()
			}			
			s bobj.BEDTPIStartDate = obj.BEDTPIStartDate
			s bobj.BEDTPIEndDate = obj.BEDTPIEndDate
			if $IsObject(obj.BEDTPIAdmReasonDR)
			{
				s bobj.BEDTPIAdmReasonDR = obj.BEDTPIAdmReasonDR.%Id() 
			}
			s bobj.BEDTPIStartAge = obj.BEDTPIStartAge		
			s bobj.BEDTPIEndAge = obj.BEDTPIEndAge			
			s:obj.BEDTPIMomBedTypeDR'="" bobj.BEDTPIMomBedTypeDR = obj.BEDTPIMomBedTypeDR.%Id() 
		}	
		d:eobj.BEDTPIBEDTPParRef'="" obj.BEDTPIBEDTPParRefSetObjectId(eobj.BEDTPIBEDTPParRef)	//床位类型
		d:eobj.BEDTPIBEDTPParRef="" obj.BEDTPIBEDTPParRefSetObjectId("")
		d:eobj.BEDTPIFeeType'="" obj.BEDTPIFeeTypeSetObjectId(eobj.BEDTPIFeeType)	//费用类型
		d:eobj.BEDTPIFeeType="" obj.BEDTPIFeeTypeSetObjectId("")
		d:eobj.BEDTPIARCIMDR'="" obj.BEDTPIARCIMDRSetObjectId(eobj.BEDTPIARCIMDR)	//费用医嘱项
		d:eobj.BEDTPIARCIMDR="" obj.BEDTPIARCIMDRSetObjectId("")
		d:eobj.BEDTPIFeeTime'="" obj.BEDTPIFeeTimeSetObjectId(eobj.BEDTPIFeeTime)
		D:eobj.BEDTPIFeeTime="" obj.BEDTPIFeeTimeSetObjectId("")		
		s obj.BEDTPIStartDate=eobj.BEDTPIStartDate			//开始时间
		s obj.BEDTPIEndDate=eobj.BEDTPIEndDate				//结束时间
		d:eobj.BEDTPIAdmReasonDR'="" obj.BEDTPIAdmReasonDRSetObjectId(eobj.BEDTPIAdmReasonDR)	//费别
		d:eobj.BEDTPIAdmReasonDR="" obj.BEDTPIAdmReasonDRSetObjectId("")
		s obj.BEDTPIStartAge=eobj.BEDTPIStartAge		  //起始年龄
		s obj.BEDTPIEndAge=eobj.BEDTPIEndAge			 //截止年龄
		d obj.BEDTPIMomBedTypeDRSetObjectId(eobj.BEDTPIMomBedTypeDR)	//母亲床位类型
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			s BedTypeDesc=$p($g(^PAC("BEDTP",eobj.BEDTPIBEDTPParRef)),"^",2)
			d:eobj.BEDTPIRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PAC_BedTypeFeeItem","User.DHCPACBedTypeFeeItem","床位类型附加费用",id,BedTypeDesc,"A",eobj)
			d:eobj.BEDTPIRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PAC_BedTypeFeeItem","User.DHCPACBedTypeFeeItem","床位类型附加费用",id,BedTypeDesc,"U",eobj,bobj)
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位类型附加费用","web.DHCBL.CT.DHCPACBedTypeFeeItem","SaveEntity",eobj)
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
/// Description：根据id删除 床位类型附加费用
/// Table：User.DHCPACBedTypeFeeItem
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: d ##class(web.DHCBL.CT.DHCPACBedTypeFeeItem).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj = ##class(User.DHCPACBedTypeFeeItem).%OpenId(id)
	s eobj = ##class(web.Entity.CT.DHCPACBedTypeFeeItem).%New()
	s eobj.BEDTPIRowId = id
	s eobj.BEDTPIBEDTPParRef  = $p(id,"||",1)
	s eobj.BEDTPIChildsub = $p(id,"||",2)
	s:pobj.BEDTPIFeeType'="" eobj.BEDTPIFeeType = pobj.BEDTPIFeeType.%Id()
	s:pobj.BEDTPIARCIMDR'="" eobj.BEDTPIARCIMDR = pobj.BEDTPIARCIMDR.%Id()
	s eobj.BEDTPIStartDate =  pobj.BEDTPIStartDate 
	s eobj.BEDTPIEndDate =  pobj.BEDTPIEndDate
	s:pobj.BEDTPIAdmReasonDR'="" eobj.BEDTPIAdmReasonDR = pobj.BEDTPIAdmReasonDR.%Id()
	s eobj.BEDTPIStartAge =  pobj.BEDTPIStartAge
	s eobj.BEDTPIEndAge =  pobj.BEDTPIEndAge
	s:pobj.BEDTPIMomBedTypeDR'="" eobj.BEDTPIMomBedTypeDR = pobj.BEDTPIMomBedTypeDR.%Id() 
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(User.DHCPACBedTypeFeeItem).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		s BedTypeDesc=$p($g(^PAC("BEDTP",eobj.BEDTPIBEDTPParRef)),"^",2)
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PAC_BedTypeFeeItem","User.DHCPACBedTypeFeeItem","床位类型附加费用",id,BedTypeDesc,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位类型附加费用","web.DHCBL.CT.DHCPACBedTypeFeeItem","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	
	q result
}

/// Function:获取父表的描述
/// CreateDate:2020-1-17
/// Creator:钟荣枫
/// Debug: w ##class(web.DHCBL.CT.DHCPACBedTypeFeeItem).GetParentDesc("1")
ClassMethod GetParentDesc(ParentId As %String) As %String
{
   s result=""
   s result=$tr($p($g(^PAC("BEDTP",ParentId)),"^",2),$c(13,10))		//床位类型描述
   q result
}

}
