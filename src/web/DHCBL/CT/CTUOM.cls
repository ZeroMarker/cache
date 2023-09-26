Import SQLUser

/// 名称:库存 - 3单位
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-5-14
Class web.DHCBL.CT.CTUOM Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter SQLTableName = "CT_UOM";

/// Creator:陈莹
/// CreatDate:2013-2-19
/// Description:查询 单位
/// Table:User.CTUOM
/// Input:rowid,code,desc,foreigndesc
/// Return:CTUOMRowId,CTUOMCode,CTUOMDesc,CTUOMForeignDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTUOM","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, foreigndesc As %String) As %Query(ROWSPEC = "CTUOMRowId:%String,CTUOMCode:%String,CTUOMDesc:%String,CTUOMForeignDesc:%String,BDPInternalCode:%String,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, foreigndesc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s CTUOMRowId=rowid
		s CTUOMCode=$p($g(^CT("UOM",CTUOMRowId)),"^",1)
		s CTUOMDesc=$p($g(^CT("UOM",CTUOMRowId)),"^",2)
		s CTUOMForeignDesc=$p($g(^CT("UOM",CTUOMRowId)),"^",3)
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_UOM",CTUOMRowId)
		s BDPInternalCode =$p($g(resultStr),"^",1)
		s BDPInternalDesc = $p($g(resultStr),"^",2)
		s BDPHospNationalCode=$p($g(resultStr),"^",3)  
		s BDPHospNationalDesc = $p($g(resultStr),"^",4)
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s:foreigndesc'="" foreigndesc=$ZCONVERT(foreigndesc,"U")
		s AuStr=##class(web.DHCBL.Authorize.CTUOM).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s CTUOMRowId=0
		for
		{
			s CTUOMRowId=$o(^CT("UOM",CTUOMRowId)) q:CTUOMRowId=""
			s strRowId="{ID:"_CTUOMRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s CTUOMCode=$p($g(^CT("UOM",CTUOMRowId)),"^",1)
				s CTUOMDesc=$p($g(^CT("UOM",CTUOMRowId)),"^",2)
				s CTUOMForeignDesc=$p($g(^CT("UOM",CTUOMRowId)),"^",3)
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_UOM",CTUOMRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)
				s BDPInternalDesc = $p($g(resultStr),"^",2)
				s BDPHospNationalCode=$p($g(resultStr),"^",3)  
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)
				
				if (desc'="")            
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_UOM",CTUOMRowId,CTUOMDesc,desc)
				}
				else
				{
					s AliasFlag=1   
				}
				
				i ($ZCONVERT(CTUOMCode,"U")[code)&(AliasFlag=1)&(($ZCONVERT(CTUOMForeignDesc,"U")[foreigndesc))
				{
					d OutputRow
				}
			}
		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(CTUOMRowId,CTUOMCode,CTUOMDesc,CTUOMForeignDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2013-2-19
/// Description:为combobox查询取数据
/// Table:User.CTUOM
/// Input:code,desc
/// Return:CTUOMRowId,CTUOMCode,CTUOMDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTUOM","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTUOMRowId:%String,CTUOMCode:%String,CTUOMDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s CTUOMRowId=rowid
		s CTUOMCode=$p($g(^CT("UOM",CTUOMRowId)),"^",1)
		s CTUOMDesc=$p($g(^CT("UOM",CTUOMRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.CTUOM).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s CTUOMRowId=0
		for
		{
			s CTUOMRowId=$o(^CT("UOM",CTUOMRowId)) q:CTUOMRowId=""
			s strRowId="{ID:"_CTUOMRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s CTUOMCode=$p($g(^CT("UOM",CTUOMRowId)),"^",1)
				s CTUOMDesc=$p($g(^CT("UOM",CTUOMRowId)),"^",2)
				
				if (desc'="")            
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_UOM",CTUOMRowId,CTUOMDesc,desc)
				}
				else
				{
					s AliasFlag=1   
				}
				
				i ($ZCONVERT(CTUOMCode,"U")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(CTUOMRowId,CTUOMCode,CTUOMDesc)
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
/// CreatDate:2012-12-24 @20170215
/// Description:数据重复验证方法,js调用
/// Table:User.CTUOM
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.CTUOM).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	n (code,desc,id)
	s flag=0
	if $ZCONVERT(code,"U")'=""
	{
		s idc=0
		for
		{
			s idc=$o(^CT("UOM",0,"Code",$ZCONVERT(code,"U"),idc)) q:idc=""
			if (idc'=id)
			{
				s flag=1
			}
		}
	}
	if $ZCONVERT(desc,"U")'=""
	{
		s idd=0
		for
		{
			s idd=$o(^CT("UOM",0,"Desc",$ZCONVERT(desc,"U"),idd)) q:idd=""
			if (idd'=id)
			{
				s flag=1
			}
		}
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-12
/// Description:双击修改时从后台取数据
/// Table:User.CTUOM
/// Input:id
/// Return:Json格式的字符串str={list:[CTUOMCode,CTUOMDesc,CTUOMForeignDesc,CTUOMRowId]}
/// Other:w ##class(web.DHCBL.CT.CTUOM).OpenData("5")
/// RetFlag=""时，用于EXT, RetFlag="JSON"时用于HISUI，不输出 "{list:["_str_"]}"  //2019-12-20 钟荣枫
ClassMethod OpenData(CTUOMRowId As %String, RetFlag As %String = "") As %String
{
	n (CTUOMRowId,RetFlag)
	s str=""
	s pobj = ##class(User.CTUOM).%OpenId(CTUOMRowId)
	s eobj = ##class(web.Entity.CT.CTUOM).%New()
	s eobj.CTUOMRowId = CTUOMRowId
	s eobj.CTUOMCode = pobj.CTUOMCode
	s eobj.CTUOMDesc = pobj.CTUOMDesc
	s eobj.CTUOMForeignDesc=pobj.CTUOMForeignDesc
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	if (RetFlag="")
	{
		s str = "{list:["_str_"]}"
	}
	q str
}

/// Creator:陈莹
/// CreatDate:2012-9-12
/// Description:增加/修改 单位
/// Table:User.CTUOM
/// Input:web.Entity.CT.CTUOM 实体类
/// Return:成功返回success:'true'和id;失败返回success:'false'和errorinfo
ClassMethod SaveEntity(eobj As web.Entity.CT.CTUOM) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s flag= ##class(web.DHCBL.CT.CTUOM).FormValidate(eobj.CTUOMRowId,eobj.CTUOMCode,eobj.CTUOMDesc)
		if flag=1 q "{success:'false',errorinfo:'该记录已经存在！'}"
		if (eobj.CTUOMRowId="")       
		{
			s obj=##class(User.CTUOM).%New()
		}
		else                           
		{
			s obj=##class(User.CTUOM).%OpenId(eobj.CTUOMRowId)
			s bobj = ##class(web.Entity.CT.CTUOM).%New()
			s bobj.CTUOMRowId = eobj.CTUOMRowId
			s bobj.CTUOMCode = obj.CTUOMCode
			s bobj.CTUOMDesc = obj.CTUOMDesc
			s bobj.CTUOMForeignDesc = obj.CTUOMForeignDesc
		}

		s obj.CTUOMCode = eobj.CTUOMCode
		s obj.CTUOMDesc = eobj.CTUOMDesc
		s obj.CTUOMForeignDesc = eobj.CTUOMForeignDesc
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.CTUOMRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_UOM","User.CTUOM","单位",id,eobj.CTUOMDesc,"A",eobj)
			d:eobj.CTUOMRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_UOM","User.CTUOM","单位",id,eobj.CTUOMDesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("单位","web.DHCBL.CT.CTUOM","SaveEntity",eobj)
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

/// Creator:陈莹
/// CreatDate:2013-8-21
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.CT.CTUOM).GetRefFlag("267")
ClassMethod GetRefFlag(id As %String) As %String
{
	n (id)
	s return="",myInfo=""

	if $d(^CT("CTCF",0,"UOM",+id)) 
	{
		s myInfo=myInfo_"<单位转换>"
	}
	
	if (myInfo="")
	{
		s uom=0,flag=0
		for
		{
			s uom=$o(^CT("CTCF",0,"UOM",uom)) q:(uom="")||(flag=1)
			i ($d(^CT("CTCF",0,"UOM",uom,+id)))
			{
				s flag=1
				s myInfo=myInfo_"<单位转换>"
			}
		}
	}
	
	s inci=0,flag=0,flag1=0
	for
	{
		s inci=$o(^INCI(inci)) q:(inci="")||(flag=1)
		s INCICTUOMDR=$p($g(^INCI(inci,1)),"^",10)
		s INCICTUOMPurchDR=$p($g(^INCI(inci,3)),"^",6)
		i (INCICTUOMDR=id)||(INCICTUOMPurchDR=id)
		{
				s flag=1
				s myInfo=myInfo_"<库存项>"
		}
		s incisub=0
		for
		{
			s incisub=$o(^INCI(inci,"REC",incisub)) q:(incisub="")||(flag1=0)
			s INRECCTUOMDR=$p(^INCI(inci,"REC",incisub),"^",1)
			i INRECCTUOMDR=id
			{
				s flag1=1
				s myInfo=myInfo_"<INCItmRcp>"
			}
		}
	}
	
	s phcdf=0,flag=0
	for
	{
		s phcdf=$o(^PHCD(phcdf)) q:(phcdf="")||(flag=1)
		s phcdfsub=0
		for
		{
			s phcdfsub=$o(^PHCD(phcdf,"DF",phcdfsub)) q:(phcdfsub="")||(flag=1)
			s PHCDFCTUOMDR=$p($g(^PHCD(phcdf,"DF",phcdfsub,2)),"^",4)
			i PHCDFCTUOMDR=id
			{
				s flag=1
				s myInfo=myInfo_"<药学项-药物形态设定>" //PHCDrgForm
			}	
		}
	}
	
	s ARCIMSubscript=0,flag=0
	for
	{
		s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:(ARCIMSubscript="")||(flag=1)
		s ARCIMVersion=0
		for
		{
			s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:(ARCIMVersion="")||(flag=1)
			s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)
			s ARCIMUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",4)
			i (ARCIMBillingUOMDR=id)||(ARCIMUOMDR=id)
			{
				s flag=1
				s myInfo=myInfo_"<医嘱项>"
			}
		}
	}
	
	s CTUOMCode=$p($g(^CT("UOM",id)),"^",1)
	i ($o(^DHCPHUOCON(0,"HisCode",CTUOMCode,"")))
	{
		s myInfo=myInfo_"<单位对照表>"
	}
	
	s phcdorowid=0,flag=0
	for
	{
		s phcdorowid=$o(^PHCDO(phcdorowid)) q:(phcdorowid="")||(flag=1)
		s uomdr=$p($g(^PHCDO(phcdorowid)),"^",5)
		i (uomdr=id)
		{
			s flag=1
			s myInfo=myInfo_"<药品用量表>"
		}
	}
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator:陈莹
/// CreatDate:2012-9-12
/// Description:根据id删除 单位
/// Table:User.CTUOM
/// Input:id(CTUOM的CTUOMRowId) 
/// Return:成功返回success:'true'和info;失败返回success:'false'和info
/// Other:d ##class(web.DHCBL.CT.CTUOM).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	n (id,%session)
	s result=""
	
	s re=##class(web.DHCBL.CT.CTUOM).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
	s pobj = ##class(User.CTUOM).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTUOM).%New()
	s eobj.CTUOMRowId = id
	s eobj.CTUOMCode = pobj.CTUOMCode
	s eobj.CTUOMDesc = pobj.CTUOMDesc
	s eobj.CTUOMForeignDesc=pobj.CTUOMForeignDesc
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.CTUOM).%DeleteId(id)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_UOM","User.CTUOM","单位",id,eobj.CTUOMDesc,"D",eobj)
	}
	else{
		Trollback
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("单位","web.DHCBL.CT.CTUOM","DeleteData",eobj)
     	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

}
