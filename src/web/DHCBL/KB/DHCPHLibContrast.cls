Class web.DHCBL.KB.DHCPHLibContrast Extends %RegisteredObject
{

/// Creator：谷雪萍
/// CreatDate: 2015-1-28
/// Description：查询已对照内容
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHLibContrast","GetList","","","","","")
Query GetList(id) As %Query(ROWSPEC = "PHLCRowId,PHLCLibCode,PHLCLibDesc,PHLCHisLocCode,PHLCHisLocDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	//s AuStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s code=$p($g(^DHCPHLIBL(id)),"^",1)
    	s desc=$p($g(^DHCPHLIBL(id)),"^",2)
        
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s PHLCRowId=0
		for  
		{	
			s PHLCRowId=$o(^DHCPHLIBC(PHLCRowId)) q:PHLCRowId="" 
			//s strRowId = "{ID:"_PHLCRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s PHLCLibCode=$p($g(^DHCPHLIBC(PHLCRowId)),"^",1)  //代码
				s PHLCLibCodeU=$ZCONVERT(PHLCLibCode,"U")
				s PHLCLibDesc=$p($g(^DHCPHLIBC(PHLCRowId)),"^",2)  //描述
				s PHLCLibDescU=$ZCONVERT(PHLCLibDesc,"U")
				s PHLCHisLocCode=$p($g(^DHCPHLIBC(PHLCRowId)),"^",3)  //his代码
				s PHLCHisLocDesc=$p($g(^DHCPHLIBC(PHLCRowId)),"^",4)  //his描述
		
				i (PHLCLibCodeU[code)&(PHLCLibDescU[desc)   //条件
				{
					d OutputRow
				}		
			//}
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHLCRowId,PHLCLibCode,PHLCLibDesc,PHLCHisLocCode,PHLCHisLocDesc)
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

/// Description：获取已对照用法中的hiscode
/// Other: w ##class(web.DHCBL.KB.DHCPHLibContrast).GetHisCode()
ClassMethod GetHisCode() As %String
{
 s str=""
	s PHLCRowId=0
	for{
		s PHLCRowId=$o(^DHCPHLIBC(PHLCRowId)) q:PHLCRowId=""
		s PHLCHisCode=$p(^DHCPHLIBC(PHLCRowId),"^",3) //HisCode
		s str="<"_PHLCHisCode_">^"_str
	}
 q str
}

/// Creator:谷雪萍
/// CreatDate: 2015-1-28
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCPHLibContrast).SaveData("8^9")
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCPHLIBL(rowid)),"^",1)
	s desc=$p($g(^DHCPHLIBL(rowid)),"^",2)
	s hiscode=$p($g(^CTLOC(hisrowid)),"^",1)
	s hisdesc=$p($g(^CTLOC(hisrowid)),"^",2)
	
	
	If hiscode'="" s sshiscode=$o(^DHCPHLIBC(0,"HisCode",hiscode,""))
	If code'="" s sscode=$o(^DHCPHLIBC(0,"Code",code,hiscode,""))
	If ((sshiscode'="")&&(sscode'="")) Quit "{success:'false',info:'该记录已对照, 不能重复对照!'}"	
	s codeStr = ##class(web.DHCBL.KB.DHCPHLibContrast).GetHisCode()
	s hcode = "<"_hiscode_">"
	if (codeStr[hcode) Quit "{success:'false',info:'该记录已对照, 请删除后再对照!'}"
	
	Ts
	s obj=##class(User.DHCPHLibContrast).%New()
	s obj.PHLCLibCode = code
	s obj.PHLCLibDesc = desc
	s obj.PHLCHisLocCode = hiscode
	s obj.PHLCHisLocDesc = hisdesc
	s logJson="{PHLCLibCode:"_$c(34)_code_$c(34)_",PHLCLibDesc:"_$c(34)_desc_$c(34)_",PHLCHisLocCode:"_$c(34)_hiscode_$c(34)_",PHLCHisLocDesc:"_$c(34)_hisdesc_$c(34)_"}"
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHLibContrast","User.DHCPHLibContrast","知识库标识和HIS科室对照",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库标识和HIS科室对照","web.DHCBL.KB.DHCPHLibContrast","SaveData",logJson)
        s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2014-11-5
/// Description:根据id删除
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""

		Tstart
		s eobj = ##class(web.Entity.KB.DHCPHLibContrast).%New()
		s pobj = ##class(User.DHCPHLibContrast).%OpenId(id)
		s eobj.PHLCRowId = id
		s eobj.PHLCLibCode = pobj.PHLCLibCode
		s eobj.PHLCLibDesc = pobj.PHLCLibDesc
		s eobj.PHLCHisLocCode = pobj.PHLCHisLocCode
		s eobj.PHLCHisLocDesc = pobj.PHLCHisLocDesc
	
		s sc=##class(User.DHCPHLibContrast).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHLibContrast","User.DHCPHLibContrast","知识库标识和HIS科室对照",id,eobj.PHLCLibDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库标识和HIS科室对照","web.DHCBL.KB.DHCPHLibContrast","DeleteData",eobj)
    		s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}
	q result
}

}
