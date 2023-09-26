Import SQLUser

/// 名称:床位编制
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 谷雪萍
/// 编写日期:2015-4-3
Class web.DHCBL.CT.PACBedOrganization Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:谷雪萍
/// CreatDate:2015-4-3
/// Description:查询 床位编制
/// Table:User.PACBedOrganization
/// Input:rowid,code,desc
/// Return:BEDORGZRowId,BEDORGZCode,BEDORGZDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACBedOrganization","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BEDORGZRowId:%String,BEDORGZCode:%String,BEDORGZDesc:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s BEDORGZRowId=rowid
		s BEDORGZCode=$p($g(^PAC("BEDORGZ",BEDORGZRowId)),"^",1)
		s BEDORGZDesc=$p($g(^PAC("BEDORGZ",BEDORGZRowId)),"^",2)
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_BedOrganization",BEDORGZRowId)
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
		s AuStr=##class(web.DHCBL.Authorize.PACBedOrganization).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s BEDORGZRowId=0
		for
		{
			s BEDORGZRowId=$o(^PAC("BEDORGZ",BEDORGZRowId)) q:BEDORGZRowId=""
			s strRowId="{ID:"_BEDORGZRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s BEDORGZCode=$p($g(^PAC("BEDORGZ",BEDORGZRowId)),"^",1)
				s BEDORGZDesc=$p($g(^PAC("BEDORGZ",BEDORGZRowId)),"^",2)
				s BEDORGZCode1=$ZCONVERT(BEDORGZCode,"U")
				s BEDORGZDesc1=$ZCONVERT(BEDORGZDesc,"U")
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_BedOrganization",BEDORGZRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)       
				s BDPInternalDesc = $p($g(resultStr),"^",2)  
				s BDPHospNationalCode=$p($g(resultStr),"^",3)         
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
				//别名查询
				/*s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","PAC_BedOrganization",BEDORGZRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BEDORGZDesc1)
				i (BEDORGZCode1[code)&((BEDORGZDesc1[desc)||(ALIASText1[desc)||(PINYIN[desc))*/
				if (desc'="")
		        {
		        	;需要对描述或者别名进行检索      
		        	s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_BedOrganization",BEDORGZRowId,BEDORGZDesc,desc)
		        }
		        else
		        {
		        	s AliasFlag= 1   
		        }  
		        if ($ZCONVERT(BEDORGZCode,"U")[code) &(AliasFlag=1)				
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(BEDORGZRowId,BEDORGZCode,BEDORGZDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Creator:谷雪萍
/// CreatDate:2013-2-22
/// Description:为combobox查询取数据
/// Table:User.PACBedOrganization
/// Input:code,desc
/// Return:BEDORGZRowId,BEDORGZCode,BEDORGZDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACBedOrganization","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BEDORGZRowId:%String,BEDORGZCode:%String,BEDORGZDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s BEDORGZRowId=rowid
		s BEDORGZCode=$p($g(^PAC("BEDORGZ",BEDORGZRowId)),"^",1)
		s BEDORGZDesc=$p($g(^PAC("BEDORGZ",BEDORGZRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.PACBedOrganization).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s BEDORGZRowId=0
		for
		{
			s BEDORGZRowId=$o(^PAC("BEDORGZ",BEDORGZRowId)) q:BEDORGZRowId=""
			s strRowId="{ID:"_BEDORGZRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s BEDORGZCode=$p($g(^PAC("BEDORGZ",BEDORGZRowId)),"^",1)
				s BEDORGZDesc=$p($g(^PAC("BEDORGZ",BEDORGZRowId)),"^",2)
				s BEDORGZCode1=$ZCONVERT(BEDORGZCode,"U")
				s BEDORGZDesc1=$ZCONVERT(BEDORGZDesc,"U")
				
				//别名查询
				/*s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","PAC_BedOrganization",BEDORGZRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BEDORGZDesc1)
				i (BEDORGZCode1[code)&((BEDORGZDesc1[desc)||(ALIASText1[desc)||(PINYIN[desc))*/
				if (desc'="")
		        {
		        	;需要对描述或者别名进行检索      
		        	s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_BedOrganization",BEDORGZRowId,BEDORGZDesc,desc)
		        }
		        else
		        {
		        	s AliasFlag= 1   
		        }  
		        if ($ZCONVERT(BEDORGZCode,"U")[code) &(AliasFlag=1)					
				{
					d OutputRowCmb
				}
			}
		}

	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(BEDORGZRowId,BEDORGZCode,BEDORGZDesc)
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

/// Creator:谷雪萍
/// CreatDate:2015-4-3
/// Description:数据重复验证方法,js调用
/// Table:User.PACBedOrganization
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PACBedOrganization).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^PAC("BEDORGZ",0,"Code",code))
	s:desc'="" flagd=$d(^PAC("BEDORGZ",0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0))
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
		s idc=""
		s idd=""
		s:code'="" idc=$o(^PAC("BEDORGZ",0,"Code",code,0))
		s:desc'="" idd=$o(^PAC("BEDORGZ",0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:谷雪萍
/// CreatDate:2015-4-3
/// Description:双击修改时从后台取数据
/// Table:User.PACBedOrganization
/// Input:id
/// Return:Json格式的字符串str={list:[BEDORGZCode,BEDORGZDesc,BEDORGZRowId]}
/// Other:d ##class(web.DHCBL.CT.PACBedOrganization).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	new (id)
	s str=""
	s pobj = ##class(User.PACBedOrganization).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PACBedOrganization).%New()
	s eobj.BEDORGZRowId = id
	s eobj.BEDORGZCode = pobj.BEDORGZCode
	s eobj.BEDORGZDesc = pobj.BEDORGZDesc
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:谷雪萍
/// CreatDate:2015-4-3
/// Description:增加/修改 床位编制
/// Table:User.PACBedOrganization
/// Input:web.Entity.CT.PACBedOrganization 实体类
/// Return:成功返回success:'true'和新增或修改的数据的BEDORGZRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.PACBedOrganization) As %String
{
    new (eobj,%session)
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		//前台js已添加空值判断、重复判断
		if (eobj.BEDORGZRowId="")       
		{
			s obj=##class(User.PACBedOrganization).%New()
		}
		else                           
		{
			s obj=##class(User.PACBedOrganization).%OpenId(eobj.BEDORGZRowId)
			s bobj=##class(web.Entity.CT.PACBedOrganization).%New()
			s bobj.BEDORGZRowId = eobj.BEDORGZRowId
			s bobj.BEDORGZCode = obj.BEDORGZCode
			s bobj.BEDORGZDesc = obj.BEDORGZDesc
		}
		s obj.BEDORGZCode = eobj.BEDORGZCode
		s obj.BEDORGZDesc = eobj.BEDORGZDesc
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.BEDORGZRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BedOrganization","User.PACBedOrganization","床位编制",id,eobj.BEDORGZDesc,"A",eobj)
			d:eobj.BEDORGZRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BedOrganization","User.PACBedOrganization","床位编制",id,eobj.BEDORGZDesc,"U",eobj,bobj)
		}else{
			Trollback
			s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
		    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位编制","web.DHCBL.CT.PACBedOrganization","SaveEntity",eobj)
     		s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}	
					
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
ERROR
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位编制","web.DHCBL.CT.PACBedOrganization","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:谷雪萍
/// CreatDate:2015-4-3
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other:d ##class(web.DHCBL.CT.PACBedOrganization).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	if $d(^PAWARDA("0","BEDORGZ",id)){
		s myInfo=myInfo_"<床位扩展表>"
	}
	
	s WARDRowID=0,flag=0
	for
	{
		s WARDRowID=$o(^PAWARD(WARDRowID)) q:(WARDRowID="")||(flag=1)  d
		s BEDRowID=0
		for
		{
			s BEDRowID=$o(^PAWARD(WARDRowID,"BED",BEDRowID)) q:(BEDRowID="")||(flag=1)  d
			s EXPBedOrganizationDR = $p($g(^PAWARDA(WARDRowID,"BED",BEDRowID,"EXP",1)),"^",2)
			i EXPBedOrganizationDR=id
			{
				s flag=1
				s myInfo=myInfo_"<科室/病区-病区床位表>"
			}
		}
	}	
		
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator:谷雪萍
/// CreatDate:2015-4-3
/// Description:根据id删除 床位编制
/// Table:User.PACBedOrganization
/// Input:id(PACBedOrganization的BEDORGZRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.PACBedOrganization).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.PACBedOrganization).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.PACBedOrganization).%OpenId(id)
		s eobj = ##class(web.Entity.CT.PACBedOrganization).%New()
		s eobj.BEDORGZRowId = id
		s eobj.BEDORGZCode = pobj.BEDORGZCode
		s eobj.BEDORGZDesc = pobj.BEDORGZDesc
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.PACBedOrganization).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BedOrganization","User.PACBedOrganization","床位编制",id,eobj.BEDORGZDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位编制","web.DHCBL.CT.PACBedOrganization","DeleteData",eobj)
    		s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

}
