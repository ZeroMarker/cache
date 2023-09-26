Import SQLUser

/// 名称:科室/部门/病区  床位类型-床位附加费用类型
/// 描述:床位类型附加费用维护，包含增删改查功能
/// 编写者：基础数据平台组 - 钟荣枫 
/// 编写日期:  2020-1-15
Class web.DHCBL.CT.DHCPACBedFeeType Extends %RegisteredObject
{

/// Creator：钟荣枫 		
/// CreatDate: 2020-1-15
/// Description：查询 床位附加费用类型
/// Table:DHC_PACBed_FeeType
/// Input：rowid, code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCPACBedFeeType","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "FTRowId,FTCode,FTDesc,FTStartDate,FTEndDate")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		
		s FTRowId=rowid
		s FTCode=$p($g(^PAC("FEETP",FTRowId)),"^",1)	//代码
		s FTDesc=$p($g(^PAC("FEETP",FTRowId)),"^",2)	//描述
		s FTStartDate=$p($g(^PAC("FEETP",FTRowId)),"^",3)	//开始日期
		s FTEndDate=$p($g(^PAC("FEETP",FTRowId)),"^",4)		//结束日期
		s:FTStartDate'="" FTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(FTStartDate)
		s:FTEndDate'="" FTEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(FTEndDate)
		d OutputRow
		
	}
	else
	{
		s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
		s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
		s FTRowId=0
		for
		{
			s FTRowId=$o(^PAC("FEETP",FTRowId)) q:FTRowId=""
			s FTCode=$p($g(^PAC("FEETP",FTRowId)),"^",1)
			s FTDesc=$p($g(^PAC("FEETP",FTRowId)),"^",2)
			s FTStartDate=$p($g(^PAC("FEETP",FTRowId)),"^",3)
			s FTEndDate=$p($g(^PAC("FEETP",FTRowId)),"^",4)
			s:FTStartDate'="" FTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(FTStartDate)
			s:FTEndDate'="" FTEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(FTEndDate)
			if (desc'="")
	        {
	        	;需要对描述或者别名进行检索      
	        	s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_PACBed_FeeType",FTRowId,FTDesc,desc)
	        }
	        else
	        {
	        	s AliasFlag= 1   
	        }  
	        if ($$ALPHAUP^SSUTIL4(FTCode)[code)&(AliasFlag=1)				
			{
				d OutputRow
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(FTRowId,FTCode,FTDesc,FTStartDate,FTEndDate)
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
/// Description：查询 床位附加费用类型
/// Table:DHC_PACBed_FeeType
/// Input：rowid, code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCPACBedFeeType","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "FTRowId,FTCode,FTDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (rowid'="") //根据rowid返回该条记录
	{
		s FTRowId=rowid
		s FTCode=$p($g(^PAC("FEETP",FTRowId)),"^",1)	//代码
		s FTDesc=$p($g(^PAC("FEETP",FTRowId)),"^",2)	//描述
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
		s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
		s FTRowId=0
		for
		{
			s FTRowId=$o(^PAC("FEETP",FTRowId)) q:FTRowId=""
			s FTCode=$p($g(^PAC("FEETP",FTRowId)),"^",1)
			s FTDesc=$p($g(^PAC("FEETP",FTRowId)),"^",2)
			if (desc'="")
	        {
	        	;需要对描述或者别名进行检索      
	        	s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_PACBed_FeeType",FTRowId,FTDesc,desc)
	        }
	        else
	        {
	        	s AliasFlag= 1   
	        }  
	        if ($$ALPHAUP^SSUTIL4(FTCode)[code)&(AliasFlag=1)				
			{
				d OutputRowCmb
			}
			
		}
			
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(FTRowId,FTCode,FTDesc)
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
/// CreatDate:2020-2-4
/// Description:数据重复验证方法,js调用
/// Table:
/// Input:
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.DHCPACBedFeeType).FormValidate()
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	s flag=0
	s flagc=""
	s flagd=""
	;^PAC("FEETP",1)="E^诊查费^^"
	if (id="") //如果为空，增加时的重复判断
	{
		s RowID=0
		for
		{
			s RowID=$o(^PAC("FEETP",RowID))	q:RowID=""
			s FTCode=$p($g(^PAC("FEETP",RowID)),"^",1)	//代码
			s FTDesc=$p($g(^PAC("FEETP",RowID)),"^",2)	//描述
			if (FTCode=code) 
			{
				s flag=1	//返回重复标志
				q
			}
		}
		
	}
	else //如果不为空，修改时的重复判断
	{
		s RowID=0
		for
		{
			s RowID=$o(^PAC("FEETP",RowID))	q:RowID=""
			s FTCode=$p($g(^PAC("FEETP",RowID)),"^",1)	//代码
			s FTDesc=$p($g(^PAC("FEETP",RowID)),"^",2)	//描述
			continue:RowID=id
			if (FTCode=code) 
			{
				s flag=1	//返回重复标志
				q
			}
		}
		
	}
	q flag
}

/// Creator：钟荣枫 
/// CreatDate: 2020-1-15
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.DHCPACBedFeeType
/// Input：id
/// Other:w ##class(web.DHCBL.CT.DHCPACBedFeeType).OpenData("1","")
/// RetFlag=""时，用于EXT, =JSON时用于HISUI，不输出 "{list:["_str_"]}"  
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{

    s str = ""
	s pobj = ##class(User.DHCPACBedFeeType).%OpenId(id)
	s eobj = ##class(web.Entity.CT.DHCPACBedFeeType).%New()
	s eobj.FTRowId=id
	s eobj.FTCode = pobj.FTCode
	s eobj.FTDesc = pobj.FTDesc
	s eobj.FTStartDate =pobj.FTStartDate
	s eobj.FTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.FTStartDate)
	s eobj.FTEndDate =pobj.FTEndDate
	s eobj.FTEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.FTEndDate)
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	if (RetFlag="")
	{
		s str = "{list:["_str_"]}"
	}
	q str
}

// w ##class(web.DHCBL.CT.DHCPACBedFeeType).SaveText()

ClassMethod SaveText()
{
	s bobj = ##class(web.Entity.CT.DHCPACBedFeeType).%New()
	s bobj.FTRowId=""
	s bobj.FTCode="CS"
	s bobj.FTDesc="测试"
	s bobj.FTStartDate="2020-2-4"
	s bobj.FTEndDate=""
	s result= ##class(web.DHCBL.CT.DHCPACBedFeeType).SaveEntity(bobj)
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-1-15
/// Description：保存 床位附加费用类型
/// Input: eobj 
/// Table：User.DHCPACBedTypeFeeItem
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.CT.DHCPACBedFeeType).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCPACBedFeeType) As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s flag=..FormValidate(eobj.FTRowId,eobj.FTCode)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s:eobj.FTStartDate'="" eobj.FTStartDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.FTStartDate)
		s:eobj.FTEndDate'="" eobj.FTEndDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.FTEndDate)
		if (eobj.FTRowId="")
		{	
	        s obj=##class(User.DHCPACBedFeeType).%New()
		}
		else
		{
			s obj=##class(User.DHCPACBedFeeType).%OpenId(eobj.FTRowId)
			s bobj = ##class(web.Entity.CT.DHCPACBedFeeType).%New()
			s bobj.FTRowId = eobj.FTRowId
			s bobj.FTCode = obj.FTCode
			s bobj.FTDesc = obj.FTDesc
			s bobj.FTStartDate = obj.FTStartDate
			s bobj.FTEndDate = obj.FTEndDate
		}	
		s obj.FTCode=eobj.FTCode
		s obj.FTDesc=eobj.FTDesc
		s obj.FTStartDate=eobj.FTStartDate
		s obj.FTEndDate=eobj.FTEndDate
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.FTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PAC_BedFeeType","User.DHCPACBedFeeType","床位附加费用类型",id,eobj.FTDesc,"A",eobj)
			d:eobj.FTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PAC_BedFeeType","User.DHCPACBedFeeType","床位附加费用类型",id,eobj.FTDesc,"U",eobj,bobj)
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位附加费用类型","web.DHCBL.CT.DHCPACBedFeeType","SaveEntity",eobj)
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
/// CreatDate: 2020-2-4
/// Description：根据id删除 床位附加费用类型
/// Table：DHC_PAC_BedFeeType
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: d ##class(web.DHCBL.CT.DHCPACBedFeeType).DeleteData(5)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s flag=..GetRefFlag(id)
	if (flag'=0)
	{
		q "{success:'false',info:'"_$p($g(flag),"^",2)_"'}"
	}
	s pobj = ##class(User.DHCPACBedFeeType).%OpenId(id)
	s eobj = ##class(web.Entity.CT.DHCPACBedFeeType).%New()
	s eobj.FTRowId = id
	s eobj.FTCode =  pobj.FTCode 
	s eobj.FTDesc =  pobj.FTDesc 
	s eobj.FTStartDate =  pobj.FTStartDate 
	s eobj.FTEndDate =  pobj.FTEndDate
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(User.DHCPACBedFeeType).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PAC_BedFeeType","User.DHCPACBedFeeType","床位附加费用类型",id,eobj.FTDesc,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位附加费用类型","web.DHCBL.CT.DHCPACBedFeeType","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-07-16
/// Description：删除校验
/// Input：id 
/// Return：0 未被引用可以删除 1 被引用 ^引用表
/// Other: w ##class(web.DHCBL.CT.DHCPACBedFeeType).GetRefFlag(1)
ClassMethod GetRefFlag(id) As %String
{
	s result=0
	s reason=""
	//床位类型-费用设置
	s flag1=0
	s BEDTPIBEDTPParRef=0
	for
	{
		s BEDTPIBEDTPParRef=$o(^PAC("BEDTP",BEDTPIBEDTPParRef)) q:BEDTPIBEDTPParRef=""
		s BEDTPIChildsub=0
		for
		{
			s BEDTPIChildsub=$o(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)) q:BEDTPIChildsub=""
			s BEDTPIFeeType=$p($g(^PAC("BEDTP",BEDTPIBEDTPParRef,"FEE",BEDTPIChildsub)),"^",1) //费用类型DR
			if (BEDTPIFeeType=id)
			{
				s reason=reason_"<床位类型-费用设置>"
				s flag1=1
				q
			}
		}
		q:flag1=1
	}
	//科室病区-病区床位-费用设置
	s flag2=0
	s BEDIBEDParRef=0
	for
	{
		s BEDIBEDParRef=$o(^PAWARD(BEDIBEDParRef)) q:BEDIBEDParRef=""
		s BEDIBEDChildsub=0
		for
		{
			s BEDIBEDChildsub=$o(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub)) q:BEDIBEDChildsub=""
			s BEDIChildsub=0
			for
			{
				s BEDIChildsub=$o(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)) q:BEDIChildsub=""
				s BEDIIFeeType=$p($g(^PAWARD(BEDIBEDParRef,"BED",BEDIBEDChildsub,"FEE",BEDIChildsub)),"^",1) //费用类型DR
				if (BEDIIFeeType=id)
				{
					s reason=reason_"<科室病区-病区床位-费用设置>"
					s flag2=1
					q
				}
			}
			q:flag2=1
		}
		q:flag2=1
	}
	if (reason'="")
	{
		s result="1^该数据在"_reason_"表被引用"
	}
	q result
}

}
