/// 名称:医呼通设备
/// 描述:
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2020-12-17
Class web.DHCBL.CT.HCCSEquipment Extends %RegisteredObject [ ProcedureBlock ]
{

/// update2020-12-29
Parameter SQLTableName = "CT_HCCSEquipment";

/// Creator：杨帆		
/// CreatDate: 2020-12-22
/// Description：查询 医呼通设备 下拉框
/// Table:User.CTHCCSEquipment
/// Input:id, eqcode, eqid, hospid
/// Output:EQRowId,EQCode,EQName(设备代码+设备ID)
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HCCSEquipment","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, eqcode As %String, eqid As %String, hospid As %String) As %Query(ROWSPEC = "EQRowId,EQCode,EQName")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, eqcode As %String, eqid As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s EQRowId=rowid
		s EQCode=$p($g(^CT("HCCSEQ",EQRowId)),"^",1)     //设备代码
		s EQId= $p($g(^CT("HCCSEQ",EQRowId)),"^",2)		//设备ID
		s EQActiveFlag = $p($g(^CT("HCCSEQ",EQRowId)),"^",3)  //是否启用
		s EQName=EQCode_"-"_EQId  //设备代码+设备ID
		d OutputRowCmb
	}
	else
	{
		
		s:eqcode'="" eqcode=$ZCONVERT(eqcode,"U") //转换成大写
		s:eqid'="" eqid=$ZCONVERT(eqid,"U") //转换成大写
		s EQRowId=0
		for 
		{
			s EQRowId=$o(^CT("HCCSEQ",EQRowId)) q:EQRowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,EQRowId,hospid)
			continue:showflag="N"
			s EQCode=$p($g(^CT("HCCSEQ",EQRowId)),"^",1)     //设备代码
			s EQId= $p($g(^CT("HCCSEQ",EQRowId)),"^",2)		//设备ID
			s EQActiveFlag = $p($g(^CT("HCCSEQ",EQRowId)),"^",3)  //是否启用
			continue:(EQActiveFlag="N")
			s EQName=EQCode_"-"_EQId  //设备代码+设备ID
			
			if (eqcode'="")           
			{
				;需要对描述或者别名进行检索 
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(eqcode) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(EQCode) 
		        }
				if (($ZCONVERT(EQCode,"U")[eqcode)||(PINYINCODE[eqcode)) 
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			i ($ZCONVERT(EQId,"U")[eqid)&&(AliasFlag=1) //包含
			{
				d OutputRowCmb
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(EQRowId,EQCode,EQName)
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
/// Description：查询医呼通设备字典的内容
/// Table：User.CTHCCSEquipment
/// Input：rowid,code,eqid,hospid
/// Output: EQRowId,EQCode,EQId,EQActiveFlag,EQRemarks
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HCCSEquipment","GetList","","","","")
Query GetList(rowid As %String, code As %String, eqid As %String, hospid As %String) As %Query(ROWSPEC = "EQRowId:%String,EQCode:%String,EQId:%String,EQActiveFlag:%String,EQRemarks:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, eqid As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:eqid'="" eqid=$ZCONVERT(eqid,"U") //转换成大写
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s EQRowId = rowid
		s EQCode=$p($g(^CT("HCCSEQ",EQRowId)),"^",1)     //设备代码
		s EQId= $p($g(^CT("HCCSEQ",EQRowId)),"^",2)		//设备ID
		s EQActiveFlag = $p($g(^CT("HCCSEQ",EQRowId)),"^",3)  //是否启用
        s:EQActiveFlag="" EQActiveFlag="Y"
		s EQRemarks = $p($g(^CT("HCCSEQ",EQRowId)),"^",4)   //备注
		
		d OutputRow
	}
	else
	{
		s EQRowId=0
		for 
		{
			s EQRowId=$o(^CT("HCCSEQ",EQRowId)) q:EQRowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,EQRowId,hospid)
			continue:showflag="N"
			s EQCode=$p($g(^CT("HCCSEQ",EQRowId)),"^",1)     //设备代码
			s EQId= $p($g(^CT("HCCSEQ",EQRowId)),"^",2)		//设备ID
			s EQActiveFlag = $p($g(^CT("HCCSEQ",EQRowId)),"^",3)  //是否启用
	        s:EQActiveFlag="" EQActiveFlag="Y"
			s EQRemarks = $p($g(^CT("HCCSEQ",EQRowId)),"^",4)   //备注
			if (code'="")           
			{
				;需要对描述或者别名进行检索
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(code) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(EQCode) 
		        }
				if (($ZCONVERT(EQCode,"U")[code)||(PINYINCODE[code))  
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			i ($ZCONVERT(EQId,"U")[eqid)&&(AliasFlag=1) //包含)
			{
				d OutputRow
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(EQRowId,EQCode,EQId,EQActiveFlag,EQRemarks)
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
/// Table:User.CTHCCSEquipment
/// Input:id, code, eqid
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.HCCSEquipment).FormValidate("","005","cs005","2")
ClassMethod FormValidate(id As %String, code As %String, eqid As %String, hospid As %String = "") As %String
{
	s flag=0
	if code'=""
	{
		s idc=0
		for
		{
			s idc=$o(^CT("HCCSEQ",0,"Code",code,idc)) q:idc=""
			if (idc'=id)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
				continue:showflag="N"
				s flag=1
			}
		}
	}
	if eqid'=""
	{
		s idd=0
		for
		{
			s idd=$o(^CT("HCCSEQ",0,"Id",eqid,idd)) q:idd=""
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

/// Creator：杨帆 
/// CreatDate: 2020-12-17
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.CTHCCSEquipment
/// Input：RowId
/// Other: w ##class(web.DHCBL.CT.HCCSEquipment).OpenData(2)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(User.CTHCCSEquipment).%OpenId(id) 
	s eobj = ##class(web.Entity.CT.CTHCCSEquipment).%New() 
	s eobj.EQRowId = id
	s eobj.EQCode = pobj.EQCode  //设备代码
	s eobj.EQId = pobj.EQId  //设备ID
	s eobj.EQActiveFlag=pobj.EQActiveFlag  //是否有效
	s:eobj.EQActiveFlag="" eobj.EQActiveFlag="Y"
	s eobj.EQRemarks = pobj.EQRemarks  //备注
	s eobj.EQRemarks = ##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.EQRemarks)
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:杨帆 
/// CreatDate: 2020-12-17
/// Description：保存 医呼通设备
/// Input: eobj As web.Entity.CT.CTHCCSEquipment
/// Table：User.CTHCCSEquipment
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.CT.HCCSEquipment).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.CTHCCSEquipment) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.EQActiveFlag="" eobj.EQActiveFlag="N"
		s flag=..FormValidate(eobj.EQRowId,eobj.EQCode,eobj.EQId,eobj.LinkHospId)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.EQRowId="")
		{
			s obj=##class(User.CTHCCSEquipment).%New()
		}
		else
		{
			s obj=##class(User.CTHCCSEquipment).%OpenId(eobj.EQRowId)
			s bobj=##class(web.Entity.CT.CTHCCSEquipment).%New()
			s bobj.EQRowId = eobj.EQRowId		//EQRowId
			s bobj.EQCode = obj.EQCode		    //设备代码
			s bobj.EQId = obj.EQId		//设备ID
			s bobj.EQActiveFlag=obj.EQActiveFlag	//是否启用
			s bobj.EQRemarks = obj.EQRemarks	//备注
		}
		s obj.EQCode = eobj.EQCode		    //设备代码
		s obj.EQId = eobj.EQId		//设备ID
		S obj.EQActiveFlag=eobj.EQActiveFlag	//是否启用
		s obj.EQRemarks = eobj.EQRemarks	//备注
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.EQRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSEquipment","User.CTHCCSEquipment","医呼通设备字典",eobj.EQRowId,eobj.EQId,"U",eobj,bobj)
    		d:eobj.EQRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSEquipment","User.CTHCCSEquipment","医呼通设备字典",id,eobj.EQId,"A",eobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医呼通设备字典","web.DHCBL.CT.CTHCCSEquipment","SaveEntity",eobj)  //保存错误日志信息
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
/// Other: w ##class(web.DHCBL.CT.HCCSEquipment).GetRefFlag(1)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	//User.CTHCCSEquipLinkContList
	s ELCLRowId=$o(^CT("HCCSELCL",0,"Equipment",id,0))
	if (ELCLRowId'="")
	{
		s myInfo=myInfo_"<医呼通设备和个人通讯录关联表>"
	}
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"里被引用,不能删除！"
	q return
}

/// Creator：杨帆
/// CreatDate: 2020-12-17
/// Description：根据id删除 医呼通设备
/// Table：User.CTHCCSEquipment
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.CT.HCCSEquipment).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.HCCSEquipment).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.CTHCCSEquipment).%OpenId(id)
		s eobj = ##class(web.Entity.CT.CTHCCSEquipment).%New()
		s eobj.EQCode = pobj.EQCode  //设备代码
		s eobj.EQId = pobj.EQId  //设备ID
		s eobj.EQActiveFlag=pobj.EQActiveFlag  //是否有效
		s eobj.EQRemarks = pobj.EQRemarks  //备注
		
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(User.CTHCCSEquipment).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSEquipment","User.CTHCCSEquipment","医呼通设备字典",id,eobj.EQId,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医呼通设备字典","web.DHCBL.CT.HCCSEquipment","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"	
	}
	q result
}

}
