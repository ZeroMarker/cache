Class web.DHCBL.KB.DHCPHPartContrast Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2017-7-5
/// Description：查询检查部位内容
/// Table：老版数据取User.MRCBodyParts，新版检查申请单部位表DHC_APPPART
/// Input：desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHPartContrast","GetHisList","")
Query GetHisList(desc) As %Query(ROWSPEC = "RowId:%String,Code:%String,Desc:%String")
{
}

ClassMethod GetHisListExecute(ByRef qHandle As %Binary, desc) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1

		s:desc'="" desc=$ZCONVERT(desc,"U")
		s RowId=0
		if (##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.DHCAppPart")=1){
			//新版检查部位：检查医嘱配置-检查医嘱及项目维护-部位维护
			for
			{	
				s RowId=$o(^DHCAPPART(RowId)) q:RowId=""
				s Code=$p($g(^DHCAPPART(RowId)),"^",1)
				s Desc=$p($g(^DHCAPPART(RowId)),"^",2)
				s APParPDr=$p($g(^DHCAPPART(RowId)),"^",3) //AP_LastRowid
				
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(Desc))
				i (($ZCONVERT(Desc,"U")[desc)||(PINYIN[desc))&(APParPDr>0)
				{
					d OutputRowHis
				}	
			}
		}
		else{
			//老版检查部位：电子病历-身体部位
			for
			{	
				s RowId=$o(^MRC("BODP",RowId)) q:RowId=""
				s Code=$p($g(^MRC("BODP",RowId)),"^",1) 
     			s Desc=$p($g(^MRC("BODP",RowId)),"^",2)
				
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(Desc))
				i ($ZCONVERT(Desc,"U")[desc)||(PINYIN[desc)
				{
					d OutputRowHis
				}	
			}	
		}
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowHis
    set Data=$lb(RowId,Code,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetHisListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHisListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHisListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHisListExecute ]
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

/// Creator：高姗姗
/// CreatDate: 2014-11-4
/// Description：查询已对照检查部位表内容
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHPartContrast","GetList","","","","","")
Query GetList(id) As %Query(ROWSPEC = "PHEPRowId,PHEPPartCode,PHEPPartDesc,PHEPHisPartCode,PHEPHisPartDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (id'=""){
		s code=$p($g(^DHCPHEPA(id)),"^",1)
    	s desc=$p($g(^DHCPHEPA(id)),"^",2)
        
		s:code'="" code="<"_$ZCONVERT(code,"U")_">"
		s:desc'="" desc="<"_$ZCONVERT(desc,"U")_">"
		s PHEPRowId=0
		for  
		{	
			s PHEPRowId=$o(^DHCPHPACON(PHEPRowId)) q:PHEPRowId="" 
			
			s PHEPPartCode=$p($g(^DHCPHPACON(PHEPRowId)),"^",1)  //代码
			s PHEPPartCodeU="<"_$ZCONVERT(PHEPPartCode,"U")_">"
			s PHEPPartDesc=$p($g(^DHCPHPACON(PHEPRowId)),"^",2)  //描述
			s PHEPPartDescU="<"_$ZCONVERT(PHEPPartDesc,"U")_">"
			s PHEPHisPartCode=$p($g(^DHCPHPACON(PHEPRowId)),"^",3)  //his代码
			s PHEPHisPartDesc=$p($g(^DHCPHPACON(PHEPRowId)),"^",4)  //his描述
		
			i (PHEPPartCodeU[code)&(PHEPPartDescU[desc)   //条件
			{
				d OutputRow
			}		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHEPRowId,PHEPPartCode,PHEPPartDesc,PHEPHisPartCode,PHEPHisPartDesc)
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

/// Description：获取已对照检查部位中的hiscode
/// Other: w ##class(web.DHCBL.KB.DHCPHPartContrast).GetHisCode()
ClassMethod GetHisCode() As %String
{
 s str=""
	s PHEPRowId=0
	for
	{
		s PHEPRowId=$o(^DHCPHPACON(PHEPRowId)) q:PHEPRowId=""
		s PHEPHisCode=$p(^DHCPHPACON(PHEPRowId),"^",3) //HisCode
		s str="<"_PHEPHisCode_">^"_str
	}
 q str
}

/// Creator:高姗姗
/// CreatDate: 2014-11-4
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCPHPartContrast).SaveData("8^9")
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCPHEPA(rowid)),"^",1)
	s desc=$p($g(^DHCPHEPA(rowid)),"^",2)
	
	if (##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.DHCAppPart")=1){
		s hiscode=$p($g(^DHCAPPART(hisrowid)),"^",1)
		s hisdesc=$p($g(^DHCAPPART(hisrowid)),"^",2)
	}else{
		s hiscode=$p($g(^MRC("BODP",hisrowid)),"^",1)
		s hisdesc=$p($g(^MRC("BODP",hisrowid)),"^",2)
	}
	
	If hiscode'="" s sshiscode=$o(^DHCPHPACON(0,"HisCode",hiscode,""))
	//If code'="" s sscode=$o(^DHCPHPACON(0,"Code",hiscode,code,""))
	s Exdesc=""
	If (sshiscode'="") 
	{
		s Exdesc=$p($g(^DHCPHPACON(sshiscode)),"^",2)  //描述
	 	Quit "{success:'false',info:'该记录已与"_Exdesc_"对照, 不能重复对照!'}"	
	}	
	/*s codeStr = ##class(web.DHCBL.KB.DHCPHPartContrast).GetHisCode()
	s hcode = "<"_hiscode_">"
	if (codeStr[hcode) Quit "{success:'false',info:'该记录已对照, 请删除后再对照!'}"*/
	
	s obj=##class(User.DHCPHPartContrast).%New()
	s obj.PHEPPartCode = code
	s obj.PHEPPartDesc = desc
	s obj.PHEPHisPartCode = hiscode
	s obj.PHEPHisPartDesc = hisdesc
	s logJson="{PHEPPartCode:"_$c(34)_code_$c(34)_",PHEPPartDesc:"_$c(34)_desc_$c(34)_",PHEPHisPartCode:"_$c(34)_hiscode_$c(34)_",PHEPHisPartDesc:"_$c(34)_hisdesc_$c(34)_"}"
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHPartContrast","User.DHCPHPartContrast","检查部位对照",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("检查部位对照","web.DHCBL.KB.DHCPHPartContrast","SaveData",logJson)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2014-11-5
/// Description:根据id删除
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""

		Tstart
		s eobj = ##class(web.Entity.KB.DHCPHPartContrast).%New()
		s pobj = ##class(User.DHCPHPartContrast).%OpenId(id)
		s eobj.PHEPRowId = id
		s eobj.PHEPPartCode = pobj.PHEPPartCode
		s eobj.PHEPPartDesc = pobj.PHEPPartDesc
		s eobj.PHEPHisPartCode = pobj.PHEPHisPartCode
		s eobj.PHEPHisPartDesc = pobj.PHEPHisPartDesc
	
		s sc=##class(User.DHCPHPartContrast).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHPartContrast","User.DHCPHPartContrast","检查部位对照",id,eobj.PHEPPartDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("检查部位对照","web.DHCBL.KB.DHCPHPartContrast","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	q result
}

/// Creator:丁亚男
/// CreatDate: 2021-05-24
/// Description：自动对照
/// Return：匹配数据的数目
/// w ##class(web.DHCBL.KB.DHCPHPartContrast).AutoContrastData()
ClassMethod AutoContrastData() As %String
{
	s count=0
	//遍历部位字典表
	s PHEPRowId=0
    for {
        s PHEPRowId=$o(^DHCPHEPA(PHEPRowId)) q:PHEPRowId=""
        s PHEPCode=$p($g(^DHCPHEPA(PHEPRowId)),"^",1)
        s PHEPDesc=$p($g(^DHCPHEPA(PHEPRowId)),"^",2)
        s PHEPAcitveFlag=$p($g(^DHCPHEPA(PHEPRowId)),"^",3)
        s PHEPSysFlag=$p($g(^DHCPHEPA(PHEPRowId)),"^",4)
        continue:PHEPAcitveFlag="N" 
        s RowId=0,Code=""
		if (##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.DHCAppPart")=1){
			//新版检查部位：检查医嘱配置-检查医嘱及项目维护-部位维护
			for
			{	
				s RowId=$o(^DHCAPPART(0,"Desc",PHEPDesc,RowId)) q:RowId=""
				s Code=$p($g(^DHCAPPART(RowId)),"^",1)
				s APParPDr=$p($g(^DHCAPPART(RowId)),"^",3) 
				continue:APParPDr=0		
			}
		}
		else{
			//老版检查部位：电子病历-身体部位
			for
			{	
				s RowId=$o(^MRC("BODP",0,"Desc",$$ALPHAUP^SSUTIL4(PHEPDesc),RowId)) q:RowId=""
				s Code=$p($g(^MRC("BODP",RowId)),"^",1) 	
			}	
		}
       //保存对照
	 	if (Code'="")
	 	{
			s sshiscode=$o(^DHCPHPACON(0,"HisCode",Code,""))
			If (sshiscode="") 
			{
				
				s obj=##class(User.DHCPHPartContrast).%New()
				s obj.PHEPPartCode = PHEPCode
				s obj.PHEPPartDesc = PHEPDesc
				s obj.PHEPHisPartCode = Code
				s obj.PHEPHisPartDesc = PHEPDesc
				s logJson="{PHEPPartCode:"_$c(34)_PHEPCode_$c(34)_",PHEPPartDesc:"_$c(34)_PHEPDesc_$c(34)_",PHEPHisPartCode:"_$c(34)_Code_$c(34)_",PHEPHisPartDesc:"_$c(34)_PHEPDesc_$c(34)_"}"
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc){	
					Tc		
					s id = obj.%Id()
					s count=count+1
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHPartContrast","User.DHCPHPartContrast","检查部位对照",id,PHEPDesc,"A",logJson)
				}else{
					Trollback
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("检查部位对照","web.DHCBL.KB.DHCPHPartContrast","SaveData",logJson)
					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
				
			 }
	 	} 
    }
 	
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

}
