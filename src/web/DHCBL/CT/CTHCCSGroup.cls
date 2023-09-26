/// 名称:群组通讯录维护
/// 描述:
/// 编写者:基础数据平台组 -杨帆
/// 编写日期: 2020-12-24
Class web.DHCBL.CT.CTHCCSGroup Extends %RegisteredObject [ ProcedureBlock ]
{

/// update2020-12-29
Parameter SQLTableName = "CT_HCCSGroup";

/// Creator：杨帆		
/// CreatDate: 2020-12-22
/// Description：查询 群组 下拉框
/// Table:User.CTHCCSGroup
/// Input:rowid, code, desc, hospid
/// Output: GROUPRowId,GROUPCode,GROUPDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHCCSGroup","GetDataForCmb1","","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "GROUPRowId:%String,GROUPCode:%String,GROUPDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s GROUPRowId = rowid
		s GROUPCode=$p($g(^CT("HCCSGROUP",GROUPRowId)),"^",1)     //群组代码
		s GROUPDesc= $p($g(^CT("HCCSGROUP",GROUPRowId)),"^",2)		//群组名称
		
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s GROUPRowId=0
		for 
		{
			s GROUPRowId=$o(^CT("HCCSGROUP",GROUPRowId)) q:GROUPRowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,GROUPRowId,hospid)
			continue:showflag="N"
			s GROUPCode=$p($g(^CT("HCCSGROUP",GROUPRowId)),"^",1)     //群组代码
			s GROUPDesc= $p($g(^CT("HCCSGROUP",GROUPRowId)),"^",2)		//群组名称
			s GROUPDateFrom= $p($g(^CT("HCCSGROUP",GROUPRowId)),"^",3)		//开始日期
			s GROUPDateTo= $p($g(^CT("HCCSGROUP",GROUPRowId)),"^",4)		//结束日期
			
			//continue:GROUPDateTo=""  //开始+结束 和当天判断?

			if (desc'="")           
			{
				;需要对描述或者别名进行检索
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(GROUPDesc) 
		        }
				if ((GROUPDesc[desc)||(PINYINCODE[desc))
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			}
			i ($ZCONVERT(GROUPCode,"U")[code)&&(AliasFlag=1)
			{
				d OutputRowCmb
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(GROUPRowId,GROUPCode,GROUPDesc)
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
/// CreatDate: 2020-12-24
/// Description：查询群组表的内容
/// Table：CT_HCCSGroup
/// Input：rowid,desc,hospid
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHCCSGroup","GetList","","","2")
Query GetList(rowid As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "GROUPRowId:%String,GROUPCode:%String,GROUPDesc:%String,GROUPDateFrom:%String,GROUPDateTo:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s GROUPRowId = rowid
		s GROUPCode=$p($g(^CT("HCCSGROUP",GROUPRowId)),"^",1)     //群组代码
		s GROUPDesc= $p($g(^CT("HCCSGROUP",GROUPRowId)),"^",2)		//群组名称
		s GROUPDateFrom= $p($g(^CT("HCCSGROUP",GROUPRowId)),"^",3)		//开始日期
		s:GROUPDateFrom'="" GROUPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(GROUPDateFrom) //转换日期格式
		s GROUPDateTo= $p($g(^CT("HCCSGROUP",GROUPRowId)),"^",4)		//结束日期
		s:GROUPDateTo'="" GROUPDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(GROUPDateTo) //转换日期格式
		d OutputRow
	}
	else
	{
		s GROUPRowId=0
		for 
		{
			s GROUPRowId=$o(^CT("HCCSGROUP",GROUPRowId)) q:GROUPRowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,GROUPRowId,hospid)
			continue:showflag="N"
			s GROUPCode=$p($g(^CT("HCCSGROUP",GROUPRowId)),"^",1)     //群组代码
			s GROUPDesc= $p($g(^CT("HCCSGROUP",GROUPRowId)),"^",2)		//群组名称
			s GROUPDateFrom= $p($g(^CT("HCCSGROUP",GROUPRowId)),"^",3)		//开始日期
			s:GROUPDateFrom'="" GROUPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(GROUPDateFrom) //转换日期格式
			s GROUPDateTo= $p($g(^CT("HCCSGROUP",GROUPRowId)),"^",4)		//结束日期
			s:GROUPDateTo'="" GROUPDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(GROUPDateTo) //转换日期格式
			if (desc'="")           
			{
				;需要对描述或者别名进行检索
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(GROUPDesc) 
		        }
				if (((GROUPDesc[desc)||(PINYINCODE[desc))||($ZCONVERT(GROUPCode,"U")[desc))
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
    set Data=$lb(GROUPRowId,GROUPCode,GROUPDesc,GROUPDateFrom,GROUPDateTo)
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
/// CreatDate:2020-12-24
/// Description:数据重复验证方法,js调用
/// Table:CT_HCCSGroup
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.CTHCCSGroup).FormValidate("","","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
	if code'=""
	{
		s idc=0
		for
		{
			s idc=$o(^CT("HCCSGROUP",0,"Code",code,idc)) q:idc=""
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
			s idd=$o(^CT("HCCSGROUP",0,"Desc",desc,idd)) q:idd=""
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

/// Creator：杨帆 
/// CreatDate: 2020-12-24
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：CT_HCCSGroup
/// Input：GROUPRowId
/// Other: w ##class(web.DHCBL.CT.CTHCCSGroup).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(User.CTHCCSGroup).%OpenId(id) 
	s eobj = ##class(web.Entity.CT.CTHCCSGroup).%New() 
	s eobj.GROUPRowId = id
	s eobj.GROUPCode = pobj.GROUPCode		  //群组代码
	s eobj.GROUPDesc = pobj.GROUPDesc		  //群组名称
	s eobj.GROUPDateFrom = pobj.GROUPDateFrom		  //开始日期
	s:pobj.GROUPDateFrom'="" eobj.GROUPDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.GROUPDateFrom)
	s eobj.GROUPDateTo = pobj.GROUPDateTo		  //结束日期
	s:pobj.GROUPDateTo'="" eobj.GROUPDateTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.GROUPDateTo)
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:杨帆
/// CreatDate:2020-12-17
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.DHCBL.CT.CTHCCSGroup).GetRefFlag()
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	//User.CTHCCSGroupLinkContList
	s CGCLChildsub=$o(^CT("HCCSGROUP",id,"CL",0))
	if (CGCLChildsub'="")
	{
		s myInfo=myInfo_"<群组关联个人通讯录表>"
	}
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"里被引用,不能删除！"
	q return
}

/// Creator：杨帆
/// CreatDate: 2020-12-24
/// Description：根据id删除 群组
/// Table：CT_HCCSGroup
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.CT.CTHCCSGroup).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.CTHCCSGroup).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0)
	{
		s pobj = ##class(User.CTHCCSGroup).%OpenId(id)
		s eobj = ##class(web.Entity.CT.CTHCCSGroup).%New()
		s eobj.GROUPCode = pobj.GROUPCode		  //群组代码
		s eobj.GROUPDesc = pobj.GROUPDesc		  //群组名称
		s eobj.GROUPDateFrom = pobj.GROUPDateFrom		  //开始日期
		s eobj.GROUPDateTo = pobj.GROUPDateTo		  //结束日期
		
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(User.CTHCCSGroup).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSGroup","User.CTHCCSGroup","群组",id,eobj.GROUPDesc,"D",eobj)
		}
		else
		{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("群组","web.DHCBL.CT.CTHCCSGroup","DeleteData",eobj)
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

/// Creator:杨帆 
/// CreatDate: 2020-12-24
/// Description：保存 群组
/// Input: eobj As web.Entity.CT.CTHCCSGroup
/// Table：CT_HCCSGroup
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.CT.CTHCCSGroup).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.CTHCCSGroup) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.GROUPDateFrom'="" eobj.GROUPDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.GROUPDateFrom) //转换日期
		s:eobj.GROUPDateFrom="" eobj.GROUPDateFrom=+$h
		s:eobj.GROUPDateTo'="" eobj.GROUPDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.GROUPDateTo) //转换日期
		if (eobj.GROUPDateTo'="")
		{
			if (eobj.GROUPDateFrom>eobj.GROUPDateTo) q "{success:'false',errorinfo:'开始日期不能大于结束日期！'}"
		}
		s flag=..FormValidate(eobj.GROUPRowId,eobj.GROUPCode,eobj.GROUPDesc,eobj.LinkHospId)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.GROUPRowId="")
		{
			s obj=##class(User.CTHCCSGroup).%New()
		}
		else
		{
			s obj=##class(User.CTHCCSGroup).%OpenId(eobj.GROUPRowId)
			s bobj=##class(web.Entity.CT.CTHCCSGroup).%New()
			s bobj.GROUPRowId = eobj.GROUPRowId		//GROUPRowId
			s bobj.GROUPCode = obj.GROUPCode		    //群组代码
			s bobj.GROUPDesc = obj.GROUPDesc		//群组名称
			s bobj.GROUPDateFrom = obj.GROUPDateFrom	//开始日期
			s bobj.GROUPDateTo = obj.GROUPDateTo	//结束日期
		}
		s obj.GROUPCode = eobj.GROUPCode		    //群组代码
		s obj.GROUPDesc = eobj.GROUPDesc		//群组名称
		s obj.GROUPDateFrom=eobj.GROUPDateFrom		//开始日期
		s obj.GROUPDateTo=eobj.GROUPDateTo		//结束日期
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.GROUPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSGroup","User.CTHCCSGroup","群组",eobj.GROUPRowId,eobj.GROUPDesc,"U",eobj,bobj)
    		d:eobj.GROUPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSGroup","User.CTHCCSGroup","群组",id,eobj.GROUPDesc,"A",eobj)
			//是否调用北科瑞声接口
    		s BKRSFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPYHTHTTP")
    		if (BKRSFlag="Y")
    		{
				// 调用接口新增直接调用新增接口，修改时判断是否有重名的，有调用新增接口，没有调用修改接口
				if (eobj.GROUPRowId="") 
				{
					//调用新增
					s ret=##class(web.DHCBL.BDP.BKRSMessage).SaveValue("群组","name^"_eobj.GROUPDesc,"A")
					if ($p(ret,"^",1)=-1) 
					{
						s result = "{success:'false',errorinfo:'北科瑞声信息-群组"_$p(ret,"^",2)_"'}" //返回错误信息
						q result
					}
				}
				elseif (eobj.GROUPRowId'="")
				{
					if (eobj.GROUPDesc'=bobj.GROUPDesc)
					{
						if ($d(^CT("HCCSGROUP",0,"Desc",bobj.GROUPDesc)))
						{
							//调用新增
							s ret=##class(web.DHCBL.BDP.BKRSMessage).SaveValue("群组","name^"_eobj.GROUPDesc,"A")
							if ($p(ret,"^",1)=-1) 
							{
								s result = "{success:'false',errorinfo:'北科瑞声信息-群组"_$p(ret,"^",2)_"'}" //返回错误信息
								q result
							}
						}
						else
						{
							//调用修改
							s ret=##class(web.DHCBL.BDP.BKRSMessage).SaveValue("群组","value^"_bobj.GROUPDesc_"$&new_value^"_eobj.GROUPDesc,"U")
							if ($p(ret,"^",1)=-1) 
							{
								s result = "{success:'false',errorinfo:'北科瑞声信息-群组"_$p(ret,"^",2)_"'}" //返回错误信息
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
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("群组","web.DHCBL.CT.CTHCCSGroup","SaveEntity",eobj)  //保存错误日志信息
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
