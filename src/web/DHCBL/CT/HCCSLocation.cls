/// 名称:医呼通科室维护
/// 描述:
/// 编写者:基础数据平台组 -丁亚男
/// 编写日期: 2021-02-02
Class web.DHCBL.CT.HCCSLocation Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "CT_HCCSLocation";

/// Creator：丁亚男		
/// CreatDate: 2020-12-22
/// Description：查询 医呼通科室 下拉框
/// Table:User.CTHCCSLocation
/// Input:rowid, code, desc, hospid
/// Output: LOCRowId,LOCCode,LOCDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HCCSLocation","GetDataForCmb1","","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "LOCRowId:%String,LOCCode:%String,LOCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s LOCRowId = rowid
		s LOCCode=$p($g(^CT("HCCSLOC",LOCRowId)),"^",1)     //医呼通科室代码
		s LOCDesc= $p($g(^CT("HCCSLOC",LOCRowId)),"^",2)		//医呼通科室名称
		
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s LOCRowId=0
		for 
		{
			s LOCRowId=$o(^CT("HCCSLOC",LOCRowId)) q:LOCRowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,LOCRowId,hospid)
			continue:showflag="N"
			s LOCCode=$p($g(^CT("HCCSLOC",LOCRowId)),"^",1)     //医呼通科室代码
			s LOCDesc= $p($g(^CT("HCCSLOC",LOCRowId)),"^",2)		//医呼通科室名称
			s LOCDateFrom= $p($g(^CT("HCCSLOC",LOCRowId)),"^",3)		//开始日期
			s LOCDateTo= $p($g(^CT("HCCSLOC",LOCRowId)),"^",4)		//结束日期

			if (desc'="")           
			{
				;需要对描述或者别名进行检索
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(LOCDesc) 
		        }
				if ((LOCDesc[desc)||(PINYINCODE[desc))
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			}
			i ($ZCONVERT(LOCCode,"U")[code)&&(AliasFlag=1)
			{
				d OutputRowCmb
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(LOCRowId,LOCCode,LOCDesc)
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

/// Creator：丁亚男
/// CreatDate: 2021-02-02
/// Description：查询医呼通科室表的内容
/// Table：CT_HCCSLocation
/// Input：rowid,desc,hospid
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HCCSLocation","GetList","","","2")
Query GetList(rowid As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "LOCRowId:%String,LOCCode:%String,LOCDesc:%String,LOCDateFrom:%String,LOCDateTo:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s LOCRowId = rowid
		s LOCCode=$p($g(^CT("HCCSLOC",LOCRowId)),"^",1)     //医呼通科室代码
		s LOCDesc= $p($g(^CT("HCCSLOC",LOCRowId)),"^",2)		//医呼通科室名称
		s LOCDateFrom= $p($g(^CT("HCCSLOC",LOCRowId)),"^",3)		//开始日期
		s:LOCDateFrom'="" LOCDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(LOCDateFrom) //转换日期格式
		s LOCDateTo= $p($g(^CT("HCCSLOC",LOCRowId)),"^",4)		//结束日期
		s:LOCDateTo'="" LOCDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(LOCDateTo) //转换日期格式
		d OutputRow
	}
	else
	{
		s LOCRowId=0
		for 
		{
			s LOCRowId=$o(^CT("HCCSLOC",LOCRowId)) q:LOCRowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,LOCRowId,hospid)
			continue:showflag="N"
			s LOCCode=$p($g(^CT("HCCSLOC",LOCRowId)),"^",1)     //医呼通科室代码
			s LOCDesc= $p($g(^CT("HCCSLOC",LOCRowId)),"^",2)		//医呼通科室名称
			s LOCDateFrom= $p($g(^CT("HCCSLOC",LOCRowId)),"^",3)		//开始日期
			s:LOCDateFrom'="" LOCDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(LOCDateFrom) //转换日期格式
			s LOCDateTo= $p($g(^CT("HCCSLOC",LOCRowId)),"^",4)		//结束日期
			s:LOCDateTo'="" LOCDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(LOCDateTo) //转换日期格式
			if (desc'="")           
			{
				;需要对描述或者别名进行检索
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(LOCDesc) 
		        }
				if (((LOCDesc[desc)||(PINYINCODE[desc))||($ZCONVERT(LOCCode,"U")[desc))
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			i (AliasFlag=1)
			{
				d OutputRow
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(LOCRowId,LOCCode,LOCDesc,LOCDateFrom,LOCDateTo)
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

/// Creator:丁亚男 
/// CreatDate:2021-02-02
/// Description:数据重复验证方法,js调用
/// Table:CT_HCCSLocation
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.HCCSLocation).FormValidate("","","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
	if code'=""
	{
		s idc=0
		for
		{
			s idc=$o(^CT("HCCSLOC",0,"Code",code,idc)) q:idc=""
			if (idc'=id)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)  //判断多院区医院
				continue:showflag="N"
				s flag=1
			}
		}
	}
	if desc'=""
	{
		s idd=0
		for
		{
			s idd=$o(^CT("HCCSLOC",0,"Desc",desc,idd)) q:idd=""
			if (idd'=id)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)  //判断多院区医院
				continue:showflag="N"
				s flag=1
			}
		}
	}
	q flag
}

/// Creator：丁亚男 
/// CreatDate: 2021-02-02
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：CT_HCCSLocation
/// Input：LOCRowId
/// Other: w ##class(web.DHCBL.CT.HCCSLocation).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(User.CTHCCSLocation).%OpenId(id) 
	s eobj = ##class(web.Entity.CT.HCCSLocation).%New() 
	s eobj.LOCRowId = id
	s eobj.LOCCode = pobj.LOCCode		  //医呼通科室代码
	s eobj.LOCDesc = pobj.LOCDesc		  //医呼通科室名称
	s eobj.LOCDateFrom = pobj.LOCDateFrom		  //开始日期
	s:pobj.LOCDateFrom'="" eobj.LOCDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.LOCDateFrom)
	s eobj.LOCDateTo = pobj.LOCDateTo		  //结束日期
	s:pobj.LOCDateTo'="" eobj.LOCDateTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.LOCDateTo)
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:丁亚男
/// CreatDate:2020-12-17
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.DHCBL.CT.HCCSLocation).GetRefFlag()
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	//User.CTHCCSLocationLinkLoc
	if ($d(^CT("HCCSLOC",0,"HISCode",id)))
	{
		s myInfo=myInfo_"<医呼通科室关联HIS科室表>"
	}
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"里被引用,不能删除！"
	q return
}

/// Creator：丁亚男
/// CreatDate: 2021-02-02
/// Description：根据id删除 医呼通科室
/// Table：CT_HCCSLocation
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.CT.HCCSLocation).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.HCCSLocation).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0)
	{
		s pobj = ##class(User.CTHCCSLocation).%OpenId(id)
		s eobj = ##class(web.Entity.CT.HCCSLocation).%New()
		s eobj.LOCCode = pobj.LOCCode		  //医呼通科室代码
		s eobj.LOCDesc = pobj.LOCDesc		  //医呼通科室名称
		s eobj.LOCDateFrom = pobj.LOCDateFrom		  //开始日期
		s eobj.LOCDateTo = pobj.LOCDateTo		  //结束日期
		
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(User.CTHCCSLocation).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSLocation","User.CTHCCSLocation","医呼通科室",id,eobj.LOCDesc,"D",eobj)
		}
		else
		{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医呼通科室","web.DHCBL.CT.HCCSLocation","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else
	{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"	
	}
	q result
}

/// Creator:丁亚男 
/// CreatDate: 2021-02-02
/// Description：保存 医呼通科室
/// Input: eobj As web.Entity.CT.HCCSLocation
/// Table：CT_HCCSLocation
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.CT.HCCSLocation).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HCCSLocation) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.LOCDateFrom'="" eobj.LOCDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.LOCDateFrom) //转换日期
		s:eobj.LOCDateFrom="" eobj.LOCDateFrom=+$h
		s:eobj.LOCDateTo'="" eobj.LOCDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.LOCDateTo) //转换日期
		if (eobj.LOCDateTo'="")
		{
			if (eobj.LOCDateFrom>eobj.LOCDateTo) q "{success:'false',errorinfo:'开始日期不能大于结束日期！'}"
		}
		s flag=..FormValidate(eobj.LOCRowId,eobj.LOCCode,eobj.LOCDesc,eobj.LinkHospId)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.LOCRowId="")
		{
			s obj=##class(User.CTHCCSLocation).%New()
		}
		else
		{
			s obj=##class(User.CTHCCSLocation).%OpenId(eobj.LOCRowId)
			s bobj=##class(web.Entity.CT.HCCSLocation).%New()
			s bobj.LOCRowId = eobj.LOCRowId		//LOCRowId
			s bobj.LOCCode = obj.LOCCode		    //医呼通科室代码
			s bobj.LOCDesc = obj.LOCDesc		//医呼通科室名称
			s bobj.LOCDateFrom = obj.LOCDateFrom	//开始日期
			s bobj.LOCDateTo = obj.LOCDateTo	//结束日期
		}
		s obj.LOCCode = eobj.LOCCode		    //医呼通科室代码
		s obj.LOCDesc = eobj.LOCDesc		//医呼通科室名称
		s obj.LOCDateFrom=eobj.LOCDateFrom		//开始日期
		s obj.LOCDateTo=eobj.LOCDateTo		//结束日期
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.LOCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSLocation","User.CTHCCSLocation","医呼通科室",eobj.LOCRowId,eobj.LOCDesc,"U",eobj,bobj)
    		d:eobj.LOCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSLocation","User.CTHCCSLocation","医呼通科室",id,eobj.LOCDesc,"A",eobj)
			//是否调用北科瑞声接口
    		s BKRSFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPYHTHTTP")
    		if (BKRSFlag="Y")
    		{
				// 调用接口新增直接调用新增接口，修改时判断是否有重名的，有调用新增接口，没有调用修改接口
				if (eobj.LOCRowId="") 
				{
					//调用新增
					s ret=##class(web.DHCBL.BDP.BKRSMessage).SaveValue("科室","name^"_eobj.LOCDesc,"A")
					if ($p(ret,"^",1)=-1) 
					{
						s result = "{success:'false',errorinfo:'北科瑞声信息-科室"_$p(ret,"^",2)_"'}" //返回错误信息
						q result
					}
				}
				elseif (eobj.LOCRowId'="")
				{
					if (eobj.LOCDesc'=bobj.LOCDesc)
					{
						if ($d(^CT("HCCSLOC",0,"Desc",bobj.LOCDesc)))
						{
							//调用新增
							s ret=##class(web.DHCBL.BDP.BKRSMessage).SaveValue("科室","name^"_eobj.LOCDesc,"A")
							if ($p(ret,"^",1)=-1) 
							{
								s result = "{success:'false',errorinfo:'北科瑞声信息-科室"_$p(ret,"^",2)_"'}" //返回错误信息
								q result
							}
						}
						else
						{
							//调用修改
							s ret=##class(web.DHCBL.BDP.BKRSMessage).SaveValue("科室","value^"_bobj.LOCDesc_"$&new_value^"_eobj.LOCDesc,"U")
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
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医呼通科室","web.DHCBL.CT.HCCSLocation","SaveEntity",eobj)  //保存错误日志信息
      		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

}
