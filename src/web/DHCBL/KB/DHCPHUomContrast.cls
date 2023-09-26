Class web.DHCBL.KB.DHCPHUomContrast Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2014-11-6
/// Description：查询已对照单位表内容
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHUomContrast","GetList","","","","","")
Query GetList(id) As %Query(ROWSPEC = "PHUCTRowId,PHUCTUomCode,PHUCTUomDesc,PHUCTHisUomCode,PHUCTHisUomDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (id'=""){
		s code=$p($g(^DHCPHEUO(id)),"^",1)
    	s desc=$p($g(^DHCPHEUO(id)),"^",2)
        
		s:code'="" code="<"_$ZCONVERT(code,"U")_">"
		s:desc'="" desc="<"_$ZCONVERT(desc,"U")_">"
		s PHUCTRowId=0
		for  
		{	
			s PHUCTRowId=$o(^DHCPHUOCON(PHUCTRowId)) q:PHUCTRowId="" 

			s PHUCTUomCode=$p($g(^DHCPHUOCON(PHUCTRowId)),"^",1)  //代码
			s PHUCTUomCodeU="<"_$ZCONVERT(PHUCTUomCode,"U")_">"
			s PHUCTUomDesc=$p($g(^DHCPHUOCON(PHUCTRowId)),"^",2)  //描述
			s PHUCTUomDescU="<"_$ZCONVERT(PHUCTUomDesc,"U")_">"
			s PHUCTHisUomCode=$p($g(^DHCPHUOCON(PHUCTRowId)),"^",3)  //his代码
			s PHUCTHisUomDesc=$p($g(^DHCPHUOCON(PHUCTRowId)),"^",4)  //his描述
		
			i (PHUCTUomCodeU[code)&(PHUCTUomDescU[desc)   //条件
			{
				d OutputRow
			}		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHUCTRowId,PHUCTUomCode,PHUCTUomDesc,PHUCTHisUomCode,PHUCTHisUomDesc)
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

/// Description：获取已对照单位中的hiscode
/// Other: w ##class(web.DHCBL.KB.DHCPHUomContrast).GetHisCode()
ClassMethod GetHisCode() As %String
{
 s str=""
	s PHUCTRowId=0
	for
	{
		s PHUCTRowId=$o(^DHCPHUOCON(PHUCTRowId)) q:PHUCTRowId=""
		s PHUCTHisCode=$p(^DHCPHUOCON(PHUCTRowId),"^",3) //HisCode
		s str="<"_PHUCTHisCode_">^"_str
	}
 q str
}

/// Creator:高姗姗
/// CreatDate: 2014-11-4
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCPHUomContrast).SaveData("8^9")
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCPHEUO(rowid)),"^",1)
	s desc=$p($g(^DHCPHEUO(rowid)),"^",2)
	s hiscode=$p($g(^CT("UOM",hisrowid)),"^",1)
	s hisdesc=$p($g(^CT("UOM",hisrowid)),"^",2)
	
	
	If hiscode'="" s sshiscode=$o(^DHCPHUOCON(0,"HisCode",hiscode,""))
	//If code'="" s sscode=$o(^DHCPHUOCON(0,"Code",code,hiscode,""))
	s Exdesc=""
	If (sshiscode'="") 
	{
		s Exdesc=$p($g(^DHCPHUOCON(sshiscode)),"^",2)  //描述
	 	Quit "{success:'false',info:'该记录已与"_Exdesc_"对照, 不能重复对照!'}"	
	}	
	/*s codeStr = ##class(web.DHCBL.KB.DHCPHUomContrast).GetHisCode()
	s hcode = "<"_hiscode_">"
	if (codeStr[hcode) Quit "{success:'false',info:'该记录已对照, 请删除后再对照!'}"*/
	
	s obj=##class(User.DHCPHUomContrast).%New()
	s obj.PHUCTUomCode = code
	s obj.PHUCTUomDesc = desc
	s obj.PHUCTHisUomCode = hiscode
	s obj.PHUCTHisUomDesc = hisdesc
	s logJson="{PHUCTUomCode:"_$c(34)_code_$c(34)_",PHUCTUomDesc:"_$c(34)_desc_$c(34)_",PHUCTHisUomCode:"_$c(34)_hiscode_$c(34)_",PHUCTHisUomDesc:"_$c(34)_hisdesc_$c(34)_"}"
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHUomContrast","User.DHCPHUomContrast","单位对照",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("单位对照","web.DHCBL.KB.DHCPHUomContrast","SaveData",logJson)
		s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
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
		s eobj = ##class(web.Entity.KB.DHCPHUomContrast).%New()
		s pobj = ##class(User.DHCPHUomContrast).%OpenId(id)
		s eobj.PHUCTRowId = id
		s eobj.PHUCTUomCode = pobj.PHUCTUomCode
		s eobj.PHUCTUomDesc = pobj.PHUCTUomDesc
		s eobj.PHUCTHisUomCode = pobj.PHUCTHisUomCode
		s eobj.PHUCTHisUomDesc = pobj.PHUCTHisUomDesc
	
		s sc=##class(User.DHCPHUomContrast).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHUomContrast","User.DHCPHUomContrast","单位对照",id,eobj.PHUCTUomDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("单位对照","web.DHCBL.KB.DHCPHUomContrast","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}
	q result
}

/// Creator:xuwenhu
/// CreatDate: 2021-05-24
/// Description：自动对照
/// Return：匹配数据的数目
/// w ##class(web.DHCBL.KB.DHCPHUomContrast).AutoContrastData()
ClassMethod AutoContrastData() As %String
{
	s count=0
	//遍历单位字典表
	s PHUomRowId=0
    for {
        s PHUomRowId=$o(^DHCPHEUO(PHUomRowId)) q:PHUomRowId=""
        s PHUomCode=$p($g(^DHCPHEUO(PHUomRowId)),"^",1)
        s PHUomDesc=$p($g(^DHCPHEUO(PHUomRowId)),"^",2)
        s PHUomAcitveFlag=$p($g(^DHCPHEUO(PHUomRowId)),"^",3)
        s PHUomSysFlag=$p($g(^DHCPHEUO(PHUomRowId)),"^",4)
        continue:PHUomAcitveFlag="N" 
        s RowId=0,Code=""
        for
        {
			s RowId=$o(^CT("UOM",0,"Desc",$zconvert(PHUomDesc,"U"),RowId)) q:RowId=""
			s Code=$p($g(^CT("UOM",RowId)),"^",1) 
        }
       	//保存对照
	 	if (Code'="")
	 	{
			s sshiscode=$o(^DHCPHUOCON(0,"HisCode",Code,""))
			s Exdesc=""
			If (sshiscode="") 
			{
				
				s obj=##class(User.DHCPHUomContrast).%New()
				s obj.PHUCTUomCode = PHUomCode
				s obj.PHUCTUomDesc = PHUomDesc
				s obj.PHUCTHisUomCode = Code
				s obj.PHUCTHisUomDesc = PHUomDesc
				s logJson="{PHUCTUomCode:"_$c(34)_PHUomCode_$c(34)_",PHUCTUomDesc:"_$c(34)_PHUomDesc_$c(34)_",PHUCTHisUomCode:"_$c(34)_Code_$c(34)_",PHUCTHisUomDesc:"_$c(34)_PHUomDesc_$c(34)_"}"
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc){	
					Tc		
					s id = obj.%Id()
					s count=count+1
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHUomContrast","User.DHCPHUomContrast","单位对照",id,PHUomDesc,"A",logJson)
				}else{
					Trollback
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("单位对照","web.DHCBL.KB.DHCPHUomContrast","SaveData",logJson)
					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
				
			 }
	 	} 
    }
 	
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

}
