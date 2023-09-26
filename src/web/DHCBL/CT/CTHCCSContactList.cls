/// 名称:个人通讯录
/// 描述:
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2020-12-17
Class web.DHCBL.CT.CTHCCSContactList Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "CT_HCCSContactList";

/// Creator：丁亚男
/// CreatDate: 2021-03-16
/// Description：查询个人通讯录科室的内容
/// Table：User.CTHCCSContactList
/// Input：rowid,desc(科室代码/描述),hospid
/// Output: HCCSCLRowId,HCCSCLLocCode,HCCSCLLocDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHCCSContactList","GetLocList","","","2")
Query GetLocList(rowid As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "HCCSCLRowId:%String,HCCSCLLocCode:%String,HCCSCLLocDesc:%String,HCCSCLLoc:%String")
{
}

ClassMethod GetLocListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s HCCSCLRowId = rowid
		s HCCSCLLocCode= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",2)		//科室代码
		s HCCSCLLocDesc= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",7)		//科室描述HCCSCL_LocCode
		s HCCSCLLoc=HCCSCLLocCode_"-"_HCCSCLLocDesc //科室代码-科室名
		d OutputRow
	}
	else
	{
		s LocCode=0
		for 
		{
			s LocCode=$o(^CT("HCCSCL",0,"Loc",LocCode)) q:LocCode=""
			s HCCSCLRowId=0,OutputFlag=0
			for 
			{
				s HCCSCLRowId=$o(^CT("HCCSCL",0,"Loc",LocCode,HCCSCLRowId)) q:HCCSCLRowId=""||OutputFlag=1
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,HCCSCLRowId,hospid)
				continue:showflag="N"
				s HCCSCLLocCode= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",2)		//科室代码
				s HCCSCLLocDesc= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",7)		//科室描述
				s HCCSCLLoc=HCCSCLLocCode_"-"_HCCSCLLocDesc //科室代码-科室名
				s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HCCSCLLocDesc)
				
				if ((($ZCONVERT(HCCSCLLocCode,"U")[desc)||($ZCONVERT(HCCSCLLocDesc,"U")[desc)) ||($ZCONVERT(PINYINCODE,"U")[desc))
				{
					s OutputFlag=1
					d OutputRow	
				} 	
			}
		 }
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(HCCSCLRowId,HCCSCLLocCode,HCCSCLLocDesc,HCCSCLLoc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocListExecute ]
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

/// Creator：杨帆
/// Editor:丁亚男		
/// CreatDate: 2020-12-22
/// Description：查询 个人通讯录 下拉框
/// Table:User.CTHCCSContactList
/// Input:rowid, desc, parref(?), hospid,type(人员分类)
/// Output:HCCSCLRowId,HCCSCLUserCode,HCCSCLLocCode,HCCSCLVOIPNumber,HCCSCLUser,HCCSCLUserDesc,checked,HCCSCLType
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHCCSContactList","GetDataForCmb1","","","1","2","已选")
Query GetDataForCmb1(rowid As %String, desc As %String, loc As %String, parref As %String, hospid As %String, CheckFlag As %String = "全部", type) As %Query(ROWSPEC = "HCCSCLRowId,HCCSCLUserCode,HCCSCLUserDesc,HCCSCLUser,HCCSCLLocCode,HCCSCLLocDesc,HCCSCLLoc,HCCSCLVOIPNumber,checked:%Boolean,CGCLRowId,HCCSCLType")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, loc As %String, parref As %String, hospid As %String, CheckFlag As %String = "全部", type) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s HCCSCLRowId = rowid
		s HCCSCLUserCode=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",1)     //用户代码
		s HCCSCLUserDesc=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",6)     //用户描述
		s HCCSCLUser=HCCSCLUserCode_"-"_HCCSCLUserDesc //用户代码-用户名
		s HCCSCLLocCode= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",2)		//科室代码
		s HCCSCLLocDesc= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",7)		//科室描述
		s HCCSCLLoc=HCCSCLLocCode_"-"_HCCSCLLocDesc //科室代码-科室名
		s HCCSCLVOIPNumber = $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",3)   //VOIP号码
		s HCCSCLType=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",9)     //人员分类
		s checkstr=##class(web.DHCBL.CT.CTHCCSGroupLinkContList).GetCheckFlagInfo(HCCSCLRowId,parref) //是否关联	input:个人通讯录id,群组id
		s checked=$p(checkstr,"^",1)
		s CGCLRowId=$p(checkstr,"^",2)
	    
		d OutputRowCmb
	}
	else
	{
		
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s:loc'="" loc=$ZCONVERT(loc,"U") //转换成大写
		s:CheckFlag="已选" CheckFlag="true"
		s:CheckFlag="未选" CheckFlag="false"
		
		s HCCSCLRowId=0
		for 
		{
			s HCCSCLRowId=$o(^CT("HCCSCL",HCCSCLRowId)) q:HCCSCLRowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,HCCSCLRowId,hospid)
			continue:showflag="N"
			s HCCSCLUserCode=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",1)     //用户代码
			s HCCSCLUserDesc=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",6)     //用户描述
			s HCCSCLUser=HCCSCLUserCode_"-"_HCCSCLUserDesc //用户代码-用户名
			s HCCSCLLocCode= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",2)		//科室代码
			s HCCSCLLocDesc= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",7)		//科室描述
			s HCCSCLLoc=HCCSCLLocCode_"-"_HCCSCLLocDesc //科室代码-科室名
			s HCCSCLVOIPNumber = $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",3)   //VOIP号码
			s HCCSCLType=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",9)     //人员分类
			continue:HCCSCLType'[type
			s checkstr=##class(web.DHCBL.CT.CTHCCSGroupLinkContList).GetCheckFlagInfo(HCCSCLRowId,parref)		//是否关联	input:个人通讯录id,群组id
			s checked=$p(checkstr,"^",1)
			s CGCLRowId=$p(checkstr,"^",2)
			
			s CheckOutFlag=1
			if ((CheckFlag'="全部")&&(CheckFlag'=checked))
			{
				s CheckOutFlag=0
			}
			
		
			if (desc'="")           
			{
				;需要对描述或者别名进行检索 
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) // 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HCCSCLUserDesc) 
		        }
				if ((($ZCONVERT(HCCSCLUserDesc,"U")[desc)||(PINYINCODE[desc)) ||($ZCONVERT(HCCSCLUserCode,"U")[desc))
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			if (loc'="")           
			{
				;需要对科室或者别名进行检索 
				s LocFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(loc) // 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HCCSCLLocDesc) 
		        }
				if ((($ZCONVERT(HCCSCLLocDesc,"U")[loc)||(PINYINCODE[loc)) ||($ZCONVERT(HCCSCLLocCode,"U")[loc))
				{
					s LocFlag= 1	
				} 
			}
			else
			{
				s LocFlag= 1
			} 
			
			i (AliasFlag=1)&&(CheckOutFlag=1)&&(LocFlag=1)
			{
				d OutputRowCmb
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(HCCSCLRowId,HCCSCLUserCode,HCCSCLUserDesc,HCCSCLUser,HCCSCLLocCode,HCCSCLLocDesc,HCCSCLLoc,HCCSCLVOIPNumber,checked,CGCLRowId,HCCSCLType)
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

/// Creator：杨帆
/// CreatDate: 2020-12-17
/// Description：查询个人通讯录的内容
/// Table：User.CTHCCSContactList
/// Input：rowid,usercode(用户代码),loccode(科室代码),hospid,type(人员分类)
/// Output: HCCSCLRowId,HCCSCLUserCode,HCCSCLLocCode,HCCSCLVOIPNumber,HCCSCLDateFrom,HCCSCLDateTo,HCCSCLUser,HCCSCLUserDesc,HCCSCLType
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHCCSContactList","GetList","","","","")
Query GetList(rowid As %String, usercode As %String, loccode As %String, hospid As %String, type As %String) As %Query(ROWSPEC = "HCCSCLRowId:%String,HCCSCLUserCode:%String,HCCSCLLocCode:%String,HCCSCLVOIPNumber:%String,HCCSCLDateFrom:%String,HCCSCLDateTo:%String,HCCSCLUser,HCCSCLUserDesc,HCCSCLLocDesc,HCCSCLType")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, usercode As %String, loccode As %String, hospid As %String, type As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:usercode'="" usercode=$ZCONVERT(usercode,"U") //转换成大写
	s:loccode'="" loccode=$ZCONVERT(loccode,"U") //转换成大写
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s HCCSCLRowId = rowid
		s HCCSCLUserCode=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",1)     //用户代码
		s HCCSCLUserDesc=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",6)     //用户描述
		s HCCSCLUser=HCCSCLUserCode_"-"_HCCSCLUserDesc //用户代码-用户名
		s HCCSCLLocCode= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",2)		//科室代码
		s HCCSCLLocDesc= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",7)		//科室描述
		s HCCSCLLoc=HCCSCLLocCode_"-"_HCCSCLLocDesc //科室代码-科室名
		s HCCSCLVOIPNumber = $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",3)   //VOIP号码
		s HCCSCLDateFrom= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",4)		//开始日期
		s:HCCSCLDateFrom'="" HCCSCLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HCCSCLDateFrom) //转换日期格式
		s HCCSCLDateTo= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",5)		//结束日期
		s:HCCSCLDateTo'="" HCCSCLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HCCSCLDateTo) //转换日期格式
		//s HCCSCLPatientFlag= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",8)		//患者标识
		s HCCSCLType=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",9)     //人员分类
		
		d OutputRow
	}
	else
	{
		s HCCSCLRowId=0
		for 
		{
			s HCCSCLRowId=$o(^CT("HCCSCL",HCCSCLRowId)) q:HCCSCLRowId=""
			
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,HCCSCLRowId,hospid)
			continue:showflag="N"
			s HCCSCLUserCode=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",1)     //用户代码
			s HCCSCLUserDesc=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",6)     //用户描述
			s HCCSCLUser=HCCSCLUserCode_"-"_HCCSCLUserDesc //用户代码-用户名
			s HCCSCLLocCode= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",2)		//科室代码
			s HCCSCLLocDesc= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",7)		//科室描述
			s HCCSCLLoc=HCCSCLLocCode_"-"_HCCSCLLocDesc //科室代码-科室名
			s HCCSCLVOIPNumber = $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",3)   //VOIP号码
			s HCCSCLDateFrom= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",4)		//开始日期
			s:HCCSCLDateFrom'="" HCCSCLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HCCSCLDateFrom) //转换日期格式
			s HCCSCLDateTo= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",5)		//结束日期
			s:HCCSCLDateTo'="" HCCSCLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HCCSCLDateTo) //转换日期格式
			//s HCCSCLPatientFlag= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",8)		//患者标识
			s HCCSCLType=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",9)     //人员分类
			continue:HCCSCLType'[type
			if (usercode'="")           
			{
				;需要对描述或者别名进行检索 
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(usercode) // 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HCCSCLUserDesc) 
		        }
		        
				if ((($ZCONVERT(HCCSCLUserDesc,"U")[usercode)||(PINYINCODE[usercode)) ||($ZCONVERT(HCCSCLUserCode,"U")[usercode))
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			
			if (loccode'="")           
			{
				;需要对科室或者别名进行检索 
				s LocFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(loccode) // 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HCCSCLLocDesc) 
		        }
				if ((($ZCONVERT(HCCSCLLocDesc,"U")[loccode)||(PINYINCODE[loccode)) ||($ZCONVERT(HCCSCLLocCode,"U")[loccode))
				{
					s LocFlag= 1	
				} 
			}
			else
			{
				s LocFlag= 1
			} 
            
            if (LocFlag=1)&(AliasFlag=1)
            {
               d OutputRow
            }	
		 }
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(HCCSCLRowId,HCCSCLUserCode,HCCSCLLocCode,HCCSCLVOIPNumber,HCCSCLDateFrom,HCCSCLDateTo,HCCSCLUser,HCCSCLUserDesc,HCCSCLLocDesc,HCCSCLType)
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

/// Creator:杨帆 
/// CreatDate:2020-12-17
/// Description:数据重复验证方法,js调用
/// Table:User.CTHCCSContactList
/// Input:id, usercode(用户代码), hospid
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.CTHCCSContactList).FormValidate("16","yf1","2")
ClassMethod FormValidate(id As %String, usercode As %String, hospid As %String = "") As %String
{
	s flag=0
	s HCCSCLDateTo=""
	if usercode'=""
	{
		s idc=0
		for
		{
			s idc=$o(^CT("HCCSCL",0,"User",usercode,idc)) q:idc=""
			s HCCSCLDateTo= $p($g(^CT("HCCSCL",idc)),"^",5)		//结束日期
			if (idc'=id)&&(HCCSCLDateTo="")
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
				continue:showflag="N"
				s flag=1
			}
		}
	}
	q flag
}

/// Creator：杨帆 
/// CreatDate: 2020-12-17
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.CTHCCSContactList
/// Input：RowId
/// Other: w ##class(web.DHCBL.CT.CTHCCSContactList).OpenData("")
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(User.CTHCCSContactList).%OpenId(id) 
	s eobj = ##class(web.Entity.CT.CTHCCSContactList).%New() 
	s eobj.HCCSCLRowId = id
	s eobj.HCCSCLUserCode = pobj.HCCSCLUserCode  //用户代码
	s eobj.HCCSCLUserDesc=pobj.HCCSCLUserDesc  //用户名
	s eobj.HCCSCLLocCode = pobj.HCCSCLLocCode  //科室代码
	s eobj.HCCSCLLocDesc = pobj.HCCSCLLocDesc  //科室名
	s eobj.HCCSCLVOIPNumber = pobj.HCCSCLVOIPNumber  //VOIP号码
	s eobj.HCCSCLDateFrom = pobj.HCCSCLDateFrom		  //开始日期
	s:pobj.HCCSCLDateFrom'="" eobj.HCCSCLDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.HCCSCLDateFrom)
	s eobj.HCCSCLDateTo = pobj.HCCSCLDateTo		  //结束日期
	s:pobj.HCCSCLDateTo'="" eobj.HCCSCLDateTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.HCCSCLDateTo)
	//s eobj.HCCSCLPatientFlag = pobj.HCCSCLPatientFlag  //患者标识
	s eobj.HCCSCLType = pobj.HCCSCLType  //人员分类
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:杨帆 
/// CreatDate: 2020-12-17
/// Description：保存 个人通讯录
/// Input: eobj As web.Entity.CT.CTHCCSContactList
/// Table：User.CTHCCSContactList
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.CT.CTHCCSContactList).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.CTHCCSContactList) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//s:eobj.HCCSCLPatientFlag="" eobj.HCCSCLPatientFlag="N"
		s:eobj.HCCSCLDateFrom'="" eobj.HCCSCLDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HCCSCLDateFrom) //转换日期
		s:eobj.HCCSCLDateFrom="" eobj.HCCSCLDateFrom=+$h
		s:eobj.HCCSCLDateTo'="" eobj.HCCSCLDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HCCSCLDateTo) //转换日期
		if (eobj.HCCSCLLocCode'="")
		{
			s CTLOCRowID=""
			s CTLOCRowID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(eobj.HCCSCLLocCode),0))
			s:CTLOCRowID'="" eobj.HCCSCLLocDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
		}
		if (eobj.HCCSCLDateTo'="")
		{
			if (eobj.HCCSCLDateFrom>eobj.HCCSCLDateTo) q "{success:'false',errorinfo:'开始日期不能大于结束日期！'}"
		}
		s flag=..FormValidate(eobj.HCCSCLRowId,eobj.HCCSCLUserCode,eobj.LinkHospId)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.HCCSCLRowId="")
		{
			s obj=##class(User.CTHCCSContactList).%New()
		}
		else
		{
			s obj=##class(User.CTHCCSContactList).%OpenId(eobj.HCCSCLRowId)
			s bobj=##class(web.Entity.CT.CTHCCSContactList).%New()
			s bobj.HCCSCLRowId = eobj.HCCSCLRowId		    //HCCSCLRowId
			s bobj.HCCSCLUserCode = obj.HCCSCLUserCode		//用户代码
			s bobj.HCCSCLUserDesc = obj.HCCSCLUserDesc		//用户描述
			s bobj.HCCSCLLocCode = obj.HCCSCLLocCode		//科室代码
			s bobj.HCCSCLLocDesc = obj.HCCSCLLocDesc		//科室描述
			s bobj.HCCSCLVOIPNumber = obj.HCCSCLVOIPNumber	//VOIP号码
			s bobj.HCCSCLDateFrom = obj.HCCSCLDateFrom	    //开始日期
			s bobj.HCCSCLDateTo = obj.HCCSCLDateTo	        //结束日期
			//s bobj.HCCSCLPatientFlag = obj.HCCSCLPatientFlag	//患者标识
			s bobj.HCCSCLType = obj.HCCSCLType              //人员分类
		}
		s obj.HCCSCLUserCode = eobj.HCCSCLUserCode		//用户代码
		s obj.HCCSCLUserDesc = eobj.HCCSCLUserDesc		//用户描述
		s obj.HCCSCLLocCode = eobj.HCCSCLLocCode		//科室代码
		s obj.HCCSCLLocDesc = eobj.HCCSCLLocDesc		//科室描述
		s obj.HCCSCLVOIPNumber = eobj.HCCSCLVOIPNumber	//VOIP号码
		s obj.HCCSCLDateFrom = eobj.HCCSCLDateFrom	    //开始日期
		s obj.HCCSCLDateTo = eobj.HCCSCLDateTo	        //结束日期
		//s obj.HCCSCLPatientFlag = eobj.HCCSCLPatientFlag	//患者标识
		s obj.HCCSCLType = eobj.HCCSCLType              //人员分类
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.HCCSCLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSContactList","User.CTHCCSContactList","个人通讯录",eobj.HCCSCLRowId,eobj.HCCSCLUserCode_"-"_eobj.HCCSCLLocCode,"U",eobj,bobj)
    		d:eobj.HCCSCLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSContactList","User.CTHCCSContactList","个人通讯录",id,eobj.HCCSCLUserCode_"-"_eobj.HCCSCLLocCode,"A",eobj)
    		//是否调用北科瑞声接口
    		s BKRSFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPYHTHTTP")
    		if (BKRSFlag="Y")
    		{
	    		//调用北科瑞声用户注册接口
				if (eobj.HCCSCLRowId="") 
				{
				
					s ret=##class(web.DHCBL.BDP.BKRSMessage).PostMessage("YHT_Send_User","username^"_eobj.HCCSCLVOIPNumber_"$&password^123456$&nickname^"_$p(eobj.HCCSCLUserDesc,"[",1))
					if ($p(ret,"^",1)=-1) 
					{
						s result = "{success:'false',errorinfo:'北科瑞声信息-"_$p(ret,"^",2)_"'}" //返回错误信息
						q result
					}
				}
				else
				{
					if (eobj.HCCSCLUserDesc'=bobj.HCCSCLUserDesc)||(eobj.HCCSCLVOIPNumber'=bobj.HCCSCLVOIPNumber) //名称VOIP 变化/的时候同步
					{
						//删除
						s ret=##class(web.DHCBL.BDP.BKRSMessage).PostMessage("YHT_Delete_User","username^"_bobj.HCCSCLVOIPNumber)
						if ($p(ret,"^",1)=-1) 
						{
							s result = "{success:'false',errorinfo:'北科瑞声信息"_$p(ret,"^",2)_"'}" //返回错误信息
							q result
						}
						
						//注册
						s ret=##class(web.DHCBL.BDP.BKRSMessage).PostMessage("YHT_Send_User","username^"_eobj.HCCSCLVOIPNumber_"$&password^123456$&nickname^"_$p(eobj.HCCSCLUserDesc,"[",1))
						if ($p(ret,"^",1)=-1) 
						{
							s result = "{success:'false',errorinfo:'北科瑞声信息"_$p(ret,"^",2)_"'}" //返回错误信息
							q result
						}
					}	
				}
				// 调用接口新增直接调用新增接口，修改时判断是否有重名的，有调用新增接口，没有调用修改接口
				if (eobj.HCCSCLRowId="") 
				{
					//用户
					s ret=##class(web.DHCBL.BDP.BKRSMessage).SaveValue("姓名","name^"_$p(eobj.HCCSCLUserDesc,"[",1),"A")
					if ($p(ret,"^",1)=-1) 
					{
						s result = "{success:'false',errorinfo:'北科瑞声信息-用户"_$p(ret,"^",2)_"'}" //返回错误信息
						q result
					}
					//科室
					s ret=##class(web.DHCBL.BDP.BKRSMessage).SaveValue("科室","name^"_$tr(eobj.HCCSCLLocDesc,"/",""),"A")
					if ($p(ret,"^",1)=-1) 
					{
						s result = "{success:'false',errorinfo:'北科瑞声信息-科室"_$p(ret,"^",2)_"'}" //返回错误信息
						q result
					}
				}
				else
				{
					//用户
					if (eobj.HCCSCLUserDesc'=bobj.HCCSCLUserDesc) //名称变化的时候才同步
					{
						if ($d(^CT("HCCSCL",0,"UserDesc",bobj.HCCSCLUserDesc)))
						{
							//调用新增
							s ret=##class(web.DHCBL.BDP.BKRSMessage).SaveValue("姓名","name^"_$p(eobj.HCCSCLUserDesc,"[",1),"A")
							if ($p(ret,"^",1)=-1) 
							{
								s result = "{success:'false',errorinfo:'北科瑞声信息-用户"_$p(ret,"^",2)_"'}" //返回错误信息
								q result
							}
						}
						else
						{
							//调用修改
							s ret=##class(web.DHCBL.BDP.BKRSMessage).SaveValue("姓名","value^"_$p(bobj.HCCSCLUserDesc,"[",1)_"$&new_value^"_$p(eobj.HCCSCLUserDesc,"[",1),"U")
							if ($p(ret,"^",1)=-1) 
							{
								s result = "{success:'false',errorinfo:'北科瑞声信息-用户"_$p(ret,"^",2)_"'}" //返回错误信息
								q result
							}
						}
					}
					//科室
					if (eobj.HCCSCLLocDesc'=bobj.HCCSCLLocDesc)  //名称变化的时候才同步
					{
						if ($d(^CT("HCCSCL",0,"LocDesc",bobj.HCCSCLLocDesc)))
						{
							//调用新增
							s ret=##class(web.DHCBL.BDP.BKRSMessage).SaveValue("科室","name^"_$tr(eobj.HCCSCLLocDesc,"/",""),"A")
							if ($p(ret,"^",1)=-1) 
							{
								s result = "{success:'false',errorinfo:'北科瑞声信息-科室"_$p(ret,"^",2)_"'}" //返回错误信息
								q result
							}
						}
						else
						{
							//调用修改
							s ret=##class(web.DHCBL.BDP.BKRSMessage).SaveValue("科室","value^"_$tr(bobj.HCCSCLLocDesc,"/","")_"$&new_value^"_$tr(eobj.HCCSCLLocDesc,"/",""),"U")
							if ($p(ret,"^",1)=-1) 
							{
								s result = "{success:'false',errorinfo:'北科瑞声信息-科室"_$p(ret,"^",2)_"'}" //返回错误信息
								q result
							}
						}
					}
				}
    		}
    		
		}
		else
		{
			TROLLBACK
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("个人通讯录","web.DHCBL.CT.CTHCCSContactList","SaveEntity",eobj)
      		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:杨帆
/// CreatDate:2020-12-17
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.DHCBL.CT.CTHCCSContactList).GetRefFlag()
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	//User.CTHCCSEquipLinkContList 
	s ELCLRowId=""
	s ELCLRowId=$o(^CT("HCCSELCL",0,"CL",id,0))
	if (ELCLRowId'="")
	{
		s myInfo=myInfo_"<医呼通设备和个人通讯录关联表>"
	}
	//User.CTHCCSGroupLinkContList  //考虑加索引，不去循环所有数据?
	s parref=0
	for
	{
		s parref=$o(^CT("HCCSGROUP",parref)) q:parref=""
		s CGCLChildsub=0
		for 
		{
			s CGCLChildsub=$o(^CT("HCCSGROUP",parref,"CL",CGCLChildsub)) q:CGCLChildsub=""
			s CGCLContactListDR= $p($g(^CT("HCCSGROUP",parref,"CL",CGCLChildsub)),"^",1)		//关联个人通讯录id
			if (CGCLContactListDR=id)
			{
				s myInfo=myInfo_"<群组关联个人通讯录表>"
				q
			}
		}
	}
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"里被引用,不能删除！"
	q return
}

/// Creator：杨帆
/// CreatDate: 2020-12-17
/// Description：根据id删除 个人通讯录
/// Table：User.CTHCCSContactList
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.CT.CTHCCSContactList).DeleteData("")
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.CTHCCSContactList).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0)
	{
		s pobj = ##class(User.CTHCCSContactList).%OpenId(id)
		s eobj = ##class(web.Entity.CT.CTHCCSContactList).%New()
		s eobj.HCCSCLUserCode = pobj.HCCSCLUserCode		    //用户代码
		s eobj.HCCSCLUserDesc = pobj.HCCSCLUserDesc		    //用户描述
		s eobj.HCCSCLLocCode = pobj.HCCSCLLocCode		//科室代码
		s eobj.HCCSCLLocDesc = pobj.HCCSCLLocDesc		//科室描述	
		s eobj.HCCSCLVOIPNumber = pobj.HCCSCLVOIPNumber  //VOIP号码
		s eobj.HCCSCLDateFrom = pobj.HCCSCLDateFrom  //开始日期
		s eobj.HCCSCLDateTo = pobj.HCCSCLDateTo  //结束日期
		//s eobj.HCCSCLPatientFlag = pobj.HCCSCLPatientFlag  //患者标识
		s eobj.HCCSCLType = pobj.HCCSCLType  //人员分类
		
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(User.CTHCCSContactList).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSContactList","User.CTHCCSContactList","个人通讯录",id,eobj.HCCSCLUserCode_"-"_eobj.HCCSCLLocCode,"D",eobj)
			//是否调用北科瑞声接口
			s BKRSFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPYHTHTTP")
    		if (BKRSFlag="Y")
    		{
				//用户删除调用北科瑞声接口
				s ret=##class(web.DHCBL.BDP.BKRSMessage).PostMessage("YHT_Delete_User","username"_"^"_eobj.HCCSCLVOIPNumber)
				if ($p(ret,"^",1)=-1) 
				{
					s result = "{success:'false',info:'北科瑞声信息:"_$p(ret,"^",2)_"'}" //返回错误信息
					q result
				}
    		}
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("个人通讯录","web.DHCBL.CT.CTHCCSContactList","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"	
	}
	q result
}

/// Creator:丁亚男 
/// CreatDate:2021-03-11
/// Description:保存配置数据
/// Input:str 配置数据 以^间隔
/// Return:1(保存成功),0(保存失败)
/// Other:w ##class(web.DHCBL.CT.CTHCCSContactList).SaveConfigData()
ClassMethod saveConfigData(str As %String) As %String
{
	s flag=0
	
	if (str'="")
	{
		s ^Config.BDPSpeConfig("CTHCCS")=str
		s flag=1
			
	}
	q flag
}

/// Creator:丁亚男 
/// CreatDate:2021-03-11
/// Description:获取配置数据
/// Input:str 配置数据 以^间隔
/// Return:1(保存成功),0(保存失败)
/// Other:w ##class(web.DHCBL.CT.CTHCCSContactList).getConfigData()
ClassMethod getConfigData() As %String
{
	s result=""	
	if ($d(^Config.BDPSpeConfig("CTHCCS")))
	{
		s result=^Config.BDPSpeConfig("CTHCCS")
	}
	q result
}

/// Creator:丁亚男 
/// CreatDate:2021-03-11
/// Description:批量处理个人通讯录表的数据，之前保存的用户编码、用户科室，现在将名称同步过来
/// Input:str 配置数据 以^间隔
/// Return:1(保存成功),0(保存失败)
/// Other:w ##class(web.DHCBL.CT.CTHCCSContactList).batchDealDesc()
ClassMethod batchDealDesc() As %String
{
	s HCCSCLRowId=0
	for 
	{
		s HCCSCLRowId=$o(^CT("HCCSCL",HCCSCLRowId)) q:HCCSCLRowId=""
		s (SSUSRRowId,SSUSRName,CTLOCRowID,CTLOCDesc)=""
			
		s HCCSCLUserCode=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",1)     //用户代码
		s:HCCSCLUserCode'="" SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(HCCSCLUserCode),0))
		s:SSUSRRowId'="" SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
		
		s HCCSCLLocCode= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",2)		//科室代码
		s:HCCSCLLocCode'="" CTLOCRowID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(HCCSCLLocCode),0))
		s:CTLOCRowID'="" CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
		s obj=##class(User.CTHCCSContactList).%OpenId(HCCSCLRowId)
		s obj.HCCSCLUserDesc = SSUSRName		    //用户描述
		s obj.HCCSCLLocDesc = CTLOCDesc		//科室描述
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
		}
		else
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			w !,result
		}	
	}
	q "批处理完成！"
}

/// Creator:丁亚男 
/// CreatDate:2021-03-11
/// Description:科室名称+用户名称 群组名称+用户名称 医呼通科室名称+用户名称 的组合调用接口推送同步数据
/// Return:ok(推送完成)
/// Other:w ##class(web.DHCBL.CT.CTHCCSContactList).PushLocJoinUser()
ClassMethod PushLocJoinUser() As %String
{
	//科室名称+用户名称
	s HCCSCLRowId=0
	for 
	{
		s HCCSCLRowId=$o(^CT("HCCSCL",HCCSCLRowId)) q:HCCSCLRowId=""
		s HCCSCLUserDesc=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",6)     //用户描述
		s HCCSCLLocDesc= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",7)		//科室描述
		if (HCCSCLUserDesc["[")
		{
			s HCCSCLUserDesc=$p(HCCSCLUserDesc,"[",1)
		}
		if (HCCSCLLocDesc["/")
		{
			s HCCSCLLocDesc=$tr(HCCSCLLocDesc,"/","")
		}
		//调用接口
		w !,HCCSCLLocDesc_HCCSCLUserDesc
		//d ..TrainingSet(HCCSCLLocDesc_HCCSCLUserDesc)
		
	}
	//群组名称+用户名称
	s groupid=0
	for 
	{
		s groupid=$o(^CT("HCCSGROUP",0,"ContactList",groupid)) q:groupid=""
		s GROUPDesc= $p($g(^CT("HCCSGROUP",groupid)),"^",2)		//群组名称
		s hccsclid=0
		for 
		{
			s hccsclid=$o(^CT("HCCSGROUP",0,"ContactList",groupid,hccsclid)) q:hccsclid=""
			s HCCSCLUserDesc=$p($g(^CT("HCCSCL",hccsclid)),"^",6)     //用户描述
			if (HCCSCLUserDesc["[")
			{
				s HCCSCLUserDesc=$p(HCCSCLUserDesc,"[",1)
			}
			//调用接口
			w !,GROUPDesc_HCCSCLUserDesc
			//d ..TrainingSet(GROUPDesc_HCCSCLUserDesc)
		}
		
	}
	//医呼通科室名称+用户名称
	s LOCRowId=0
	for 
	{
		s LOCRowId=$o(^CT("HCCSLOC",0,"HISCode",LOCRowId)) q:LOCRowId=""
		s LOCDesc= $p($g(^CT("HCCSLOC",LOCRowId)),"^",2)		//医呼通科室名称
		s CTLOCCode=0
		for 
		{
			s CTLOCCode=$o(^CT("HCCSLOC",0,"HISCode",LOCRowId,CTLOCCode)) q:CTLOCCode=""
			s HCCSCLRowId=0
			for 
			{
				s HCCSCLRowId=$o(^CT("HCCSCL",0,"Loc",CTLOCCode,HCCSCLRowId)) q:HCCSCLRowId=""
				s HCCSCLUserDesc=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",6)     //用户描述
				if (HCCSCLUserDesc["[")
				{
					s HCCSCLUserDesc=$p(HCCSCLUserDesc,"[",1)
				}
				//调用接口
				w !,LOCDesc_HCCSCLUserDesc
				//d ..TrainingSet(LOCDesc_HCCSCLUserDesc)
			}
		}	
	}
	
	q "ok"
}

/// Creator:陈莹
/// CreatDate:2022-09-13
/// Description:根据his科室代码获取科室下的用户信息（代码 名称）
/// Input:LLLHISCode(his科室代码)
/// Return:   {},{},{}
/// Other:w ##class(web.DHCBL.CT.CTHCCSContactList).GetUserInfoByLocCode("ZYMZ001")
ClassMethod GetUserInfoByLocCode(LLLHISCode) As %String
{
	q:LLLHISCode="" ""
	s HCCSCLRowId=0
	s str=""
	for 
	{
		s HCCSCLRowId=$o(^CT("HCCSCL",0,"Loc",LLLHISCode,HCCSCLRowId)) q:HCCSCLRowId=""
		s HCCSCLUserCode=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",1)     //用户代码
		s HCCSCLUserDesc=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",6)     //用户描述
		s HCCSCLLocCode= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",2)		//科室代码
		s HCCSCLLocDesc= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",7)		//科室描述
		s HCCSCLVOIPNumber = $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",3)   //VOIP号码
		s HCCSCLDateFrom= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",4)		//开始日期
		continue:((HCCSCLDateFrom'="")&&(HCCSCLDateFrom>+$h))
		s HCCSCLDateTo= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",5)		//结束日期
		continue:((HCCSCLDateTo'="")&&(HCCSCLDateTo<+$h))
		s HCCSCLType=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",9)     //人员分类
		
		s UserInfo="{""HCCSCLLocCode"":"""_HCCSCLLocCode_""",""HCCSCLLocDesc"":"""_HCCSCLLocDesc_""",""HCCSCLRowId"":"""_HCCSCLRowId_""",""HCCSCLType"":"""_HCCSCLType_""",""HCCSCLUserCode"":"""_HCCSCLUserCode_""",""HCCSCLUserDesc"":"""_HCCSCLUserDesc_""",""HCCSCLVOIPNumber"":"""_HCCSCLVOIPNumber_"""}"
		if str=""
		{
			s str=UserInfo
		}
		else
		{
			s str=str_","_UserInfo
		}
	}
	q str
}

}
