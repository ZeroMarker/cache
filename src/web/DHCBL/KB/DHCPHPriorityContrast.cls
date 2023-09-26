Class web.DHCBL.KB.DHCPHPriorityContrast Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2015-12-9
/// Description：查询已对照医嘱优先级表内容
/// Input：rowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHPriorityContrast","GetList","")
Query GetList(id) As %Query(ROWSPEC = "PHPCTRowId,PHPCTPriorityCode,PHPCTPriorityDesc,PHPCTHisPriorityCode,PHPCTHisPriorityDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (id'=""){
		s code=$p($g(^DHCPHEP(id)),"^",1)
    	s desc=$p($g(^DHCPHEP(id)),"^",2)
        
		s:code'="" code="<"_$ZCONVERT(code,"U")_">"
		s:desc'="" desc="<"_$ZCONVERT(desc,"U")_">"
		s PHPCTRowId=0
		for  
		{	
			s PHPCTRowId=$o(^DHCPHPRCON(PHPCTRowId)) q:PHPCTRowId="" 
			
			s PHPCTPriorityCode=$p($g(^DHCPHPRCON(PHPCTRowId)),"^",1)  //代码
			s PHPCTPriorityCodeU="<"_$ZCONVERT(PHPCTPriorityCode,"U")_">"
			s PHPCTPriorityDesc=$p($g(^DHCPHPRCON(PHPCTRowId)),"^",2)  //描述
			s PHPCTPriorityDescU="<"_$ZCONVERT(PHPCTPriorityDesc,"U")_">"
			s PHPCTHisPriorityCode=$p($g(^DHCPHPRCON(PHPCTRowId)),"^",3)  //his代码
			s PHPCTHisPriorityDesc=$p($g(^DHCPHPRCON(PHPCTRowId)),"^",4)  //his描述
		
			i (PHPCTPriorityCodeU[code)&(PHPCTPriorityDescU[desc)   //条件
			{
				d OutputRow
			}		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHPCTRowId,PHPCTPriorityCode,PHPCTPriorityDesc,PHPCTHisPriorityCode,PHPCTHisPriorityDesc)
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

/// Description：获取已对照医嘱优先级中的hiscode
/// Other: w ##class(web.DHCBL.KB.DHCPHPriorityContrast).GetHisCode()
ClassMethod GetHisCode() As %String
{
 s str=""
	s PHPCTRowId=0
	for
	{
		s PHPCTRowId=$o(^DHCPHPRCON(PHPCTRowId)) q:PHPCTRowId=""
		s PHPCTHisCode=$p(^DHCPHPRCON(PHPCTRowId),"^",3) //HisCode
		s str="<"_PHPCTHisCode_">^"_str
	}
 q str
}

/// Creator:高姗姗
/// CreatDate: 2015-12-9
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCPHPriorityContrast).SaveData("8^9")
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCPHEP(rowid)),"^",1)
	s desc=$p($g(^DHCPHEP(rowid)),"^",2)
	s hiscode=$p($g(^OECPR(hisrowid)),"^",1)
	s hisdesc=$p($g(^OECPR(hisrowid)),"^",2)
	
	If hiscode'="" s sshiscode=$o(^DHCPHPRCON(0,"HisCode",hiscode,""))
	If code'="" s sscode=$o(^DHCPHPRCON(0,"Code",code,hiscode,""))
	If ((sshiscode'="")&&(sscode'="")) Quit "{success:'false',info:'该记录已对照, 不能重复对照!'}"	
	s codeStr = ##class(web.DHCBL.KB.DHCPHPriorityContrast).GetHisCode()
	s hcode = "<"_hiscode_">"
	if (codeStr[hcode) Quit "{success:'false',info:'该记录已对照, 请删除后再对照!'}"
	
	s obj=##class(User.DHCPHPriorityContrast).%New()
	s obj.PHPCTPriorityCode = code
	s obj.PHPCTPriorityDesc = desc
	s obj.PHPCTHisPriorityCode = hiscode
	s obj.PHPCTHisPriorityDesc = hisdesc
	s logJson="{PHPCTPriorityCode:"_$c(34)_code_$c(34)_",PHPCTPriorityDesc:"_$c(34)_desc_$c(34)_",PHPCTHisPriorityCode:"_$c(34)_hiscode_$c(34)_",PHPCTHisPriorityDesc:"_$c(34)_hisdesc_$c(34)_"}"
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHPriorityContrast","User.DHCPHPriorityContrast","医嘱优先级对照",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2015-12-9
/// Description:根据id删除
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""

		Tstart
		s eobj = ##class(web.Entity.KB.DHCPHPriorityContrast).%New()
		s pobj = ##class(User.DHCPHPriorityContrast).%OpenId(id)
		s eobj.PHPCTRowId = id
		s eobj.PHPCTPriorityCode = pobj.PHPCTPriorityCode
		s eobj.PHPCTPriorityDesc = pobj.PHPCTPriorityDesc
		s eobj.PHPCTHisPriorityCode = pobj.PHPCTHisPriorityCode
		s eobj.PHPCTHisPriorityDesc = pobj.PHPCTHisPriorityDesc
	
		s sc=##class(User.DHCPHPriorityContrast).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHPriorityContrast","User.DHCPHPriorityContrast","医嘱优先级对照",id,eobj.PHPCTPriorityDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}
	q result
}

}
