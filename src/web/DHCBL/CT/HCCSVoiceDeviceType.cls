/// 名称:语音备忘类型
/// 描述:
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期: 2021-01-25
Class web.DHCBL.CT.HCCSVoiceDeviceType Extends %RegisteredObject [ ProcedureBlock ]
{

/// update2020-12-29
Parameter SQLTableName = "CT_HCCSVoiceDeviceType";

/// Creator：丁亚男		
/// CreatDate: 2020-12-22
/// Description：查询 语音备忘类型字典 下拉框
/// Table:User.CTHCCSVoiceDeviceType
/// Input:id, code, desc, hospid
/// Output:VDTRowId,VDTCode,EQName(备忘代码+备忘ID)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HCCSVoiceDeviceType","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "VDTRowId,VDTCode,VDTDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s VDTRowId=rowid
		s VDTCode=$p($g(^CT("HCCSVDT",VDTRowId)),"^",1)     //代码
		s VDTDesc= $p($g(^CT("HCCSVDT",VDTRowId)),"^",2)		//描述
		s VDTActiveFlag = $p($g(^CT("HCCSVDT",VDTRowId)),"^",3)  //是否启用
		d OutputRowCmb
	}
	else
	{
		
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s VDTRowId=0
		for 
		{
			s VDTRowId=$o(^CT("HCCSVDT",VDTRowId)) q:VDTRowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,VDTRowId,hospid)
			continue:showflag="N"
			s VDTCode=$p($g(^CT("HCCSVDT",VDTRowId)),"^",1)     //代码
			s VDTDesc= $p($g(^CT("HCCSVDT",VDTRowId)),"^",2)		//描述
			s VDTActiveFlag = $p($g(^CT("HCCSVDT",VDTRowId)),"^",3)  //是否启用
			continue:(VDTActiveFlag="N")
			
			if (desc'="")           
			{
				;需要对描述或者别名进行检索 
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINDesc=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(VDTDesc) 
		        }
				if (($ZCONVERT(VDTDesc,"U")[desc)||(PINYINDesc[desc)) 
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			
			i (AliasFlag=1) //包含
			{
				d OutputRowCmb
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(VDTRowId,VDTCode,VDTDesc)
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
/// CreatDate: 2021-01-25
/// Description：查询语音备忘类型字典字典的内容
/// Table：User.CTHCCSVoiceDeviceType
/// Input：rowid,code,desc,hospid
/// Output: VDTRowId,VDTCode,VDTDesc,VDTActiveFlag,VDTRemarks
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HCCSVoiceDeviceType","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "VDTRowId:%String,VDTCode:%String,VDTDesc:%String,VDTActiveFlag:%String,VDTType:%String,VDTRemarks:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s VDTRowId = rowid
		s VDTCode=$p($g(^CT("HCCSVDT",VDTRowId)),"^",1)     //代码
		s VDTDesc= $p($g(^CT("HCCSVDT",VDTRowId)),"^",2)		//描述
		s VDTActiveFlag = $p($g(^CT("HCCSVDT",VDTRowId)),"^",3)  //是否启用
        s:VDTActiveFlag="" VDTActiveFlag="Y"
        s VDTType = $p($g(^CT("HCCSVDT",VDTRowId)),"^",4)   //类型
		s VDTRemarks = $p($g(^CT("HCCSVDT",VDTRowId)),"^",5)   //备注
		
		d OutputRow
	}
	else
	{
		s VDTRowId=0
		for 
		{
			s VDTRowId=$o(^CT("HCCSVDT",VDTRowId)) q:VDTRowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,VDTRowId,hospid)
			continue:showflag="N"
			s VDTCode=$p($g(^CT("HCCSVDT",VDTRowId)),"^",1)     //代码
			s VDTDesc= $p($g(^CT("HCCSVDT",VDTRowId)),"^",2)		//描述
			s VDTActiveFlag = $p($g(^CT("HCCSVDT",VDTRowId)),"^",3)  //是否启用
	        s:VDTActiveFlag="" VDTActiveFlag="Y"
	        s VDTType = $p($g(^CT("HCCSVDT",VDTRowId)),"^",4)   //类型
			s VDTRemarks = $p($g(^CT("HCCSVDT",VDTRowId)),"^",5)   //备注
			if (desc'="")           
			{
				;需要对描述或者别名进行检索
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINDesc=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(VDTDesc) 
		        }
				if (($ZCONVERT(VDTDesc,"U")[desc)||(PINYINDesc[desc))  
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			i ($ZCONVERT(VDTCode,"U")[code)&&(AliasFlag=1) //包含)
			{
				d OutputRow
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(VDTRowId,VDTCode,VDTDesc,VDTActiveFlag,VDTType,VDTRemarks)
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
/// CreatDate:2021-01-25
/// Description:数据重复验证方法,js调用
/// Table:User.CTHCCSVoiceDeviceType
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.HCCSVoiceDeviceType).FormValidate("","005","cs005","2")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
	if code'=""
	{
		s idc=0
		for
		{
			s idc=$o(^CT("HCCSVDT",0,"Code",code,idc)) q:idc=""
			if (idc'=id)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
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
			s idd=$o(^CT("HCCSVDT",0,"Desc",desc,idd)) q:idd=""
			if (idd'=id)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)
				continue:showflag="N"
				s flag=1
			}
		}
	}
	q flag
}

/// Creator：丁亚男 
/// CreatDate: 2021-01-25
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.CTHCCSVoiceDeviceType
/// Input：RowId
/// Other: w ##class(web.DHCBL.CT.HCCSVoiceDeviceType).OpenData(2)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(User.CTHCCSVoiceDeviceType).%OpenId(id) 
	s eobj = ##class(web.Entity.CT.CTHCCSVoiceDeviceType).%New() 
	s eobj.VDTRowId = id
	s eobj.VDTCode = pobj.VDTCode  //代码
	s eobj.VDTDesc = pobj.VDTDesc  //描述
	s eobj.VDTActiveFlag=pobj.VDTActiveFlag  //是否有效
	s:eobj.VDTActiveFlag="" eobj.VDTActiveFlag="Y"
	s eobj.VDTType = pobj.VDTType  //类型
	s eobj.VDTRemarks = pobj.VDTRemarks  //备注
	s eobj.VDTRemarks = ##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.VDTRemarks)
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:丁亚男 
/// CreatDate: 2021-01-25
/// Description：保存 语音备忘类型字典
/// Input: eobj As web.Entity.CT.CTHCCSVoiceDeviceType
/// Table：User.CTHCCSVoiceDeviceType
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.CT.HCCSVoiceDeviceType).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.CTHCCSVoiceDeviceType) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.VDTActiveFlag="" eobj.VDTActiveFlag="N"
		s flag=..FormValidate(eobj.VDTRowId,eobj.VDTCode,eobj.VDTDesc,eobj.LinkHospId)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.VDTRowId="")
		{
			s obj=##class(User.CTHCCSVoiceDeviceType).%New()
		}
		else
		{
			s obj=##class(User.CTHCCSVoiceDeviceType).%OpenId(eobj.VDTRowId)
			s bobj=##class(web.Entity.CT.CTHCCSVoiceDeviceType).%New()
			s bobj.VDTRowId = eobj.VDTRowId		//VDTRowId
			s bobj.VDTCode = obj.VDTCode		    //代码
			s bobj.VDTDesc = obj.VDTDesc		//描述
			s bobj.VDTActiveFlag=obj.VDTActiveFlag	//是否启用
			s bobj.VDTType = obj.VDTType  //类型
			s bobj.VDTRemarks = obj.VDTRemarks	//备注
		}
		s obj.VDTCode = eobj.VDTCode		    //代码
		s obj.VDTDesc = eobj.VDTDesc		//描述
		S obj.VDTActiveFlag=eobj.VDTActiveFlag	//是否启用
		s obj.VDTType = eobj.VDTType  //类型
		s obj.VDTRemarks = eobj.VDTRemarks	//备注
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.VDTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSVoiceDeviceType","User.CTHCCSVoiceDeviceType","语音备忘类型字典",eobj.VDTRowId,eobj.VDTDesc,"U",eobj,bobj)
    		d:eobj.VDTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSVoiceDeviceType","User.CTHCCSVoiceDeviceType","语音备忘类型字典",id,eobj.VDTDesc,"A",eobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("语音备忘类型字典","web.DHCBL.CT.CTHCCSVoiceDeviceType","SaveEntity",eobj)  //保存错误日志信息
      		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-01-25
/// Description：根据id删除 语音备忘类型
/// Table：User.CTHCCSVoiceDeviceType
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.CT.HCCSVoiceDeviceType).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	
	s pobj = ##class(User.CTHCCSVoiceDeviceType).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTHCCSVoiceDeviceType).%New()
	s eobj.VDTCode = pobj.VDTCode  //代码
	s eobj.VDTDesc = pobj.VDTDesc  //描述
	s eobj.VDTActiveFlag=pobj.VDTActiveFlag  //是否有效
	s eobj.VDTType = pobj.VDTType  //类型
	s eobj.VDTRemarks = pobj.VDTRemarks  //备注
	
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(User.CTHCCSVoiceDeviceType).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSVoiceDeviceType","User.CTHCCSVoiceDeviceType","语音备忘类型字典",id,eobj.VDTDesc,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("语音备忘类型字典","web.DHCBL.CT.HCCSVoiceDeviceType","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	
	q result
}

}
