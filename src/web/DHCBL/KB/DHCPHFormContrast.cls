Class web.DHCBL.KB.DHCPHFormContrast Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2014-11-4
/// Description：查询已对照剂型表内容
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHFormContrast","GetList","","","","","")
Query GetList(id) As %Query(ROWSPEC = "PHFCTRowId,PHFCTFormCode,PHFCTFormDesc,PHFCTHisFormCode,PHFCTHisFormDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (id'=""){
		s code=$p($g(^DHCPHEF(id)),"^",1)
    	s desc=$p($g(^DHCPHEF(id)),"^",2)
        
		s:code'="" code="<"_$ZCONVERT(code,"U")_">"
		s:desc'="" desc="<"_$ZCONVERT(desc,"U")_">"
		s PHFCTRowId=0
		for  
		{	
			s PHFCTRowId=$o(^DHCPHFOCON(PHFCTRowId)) q:PHFCTRowId="" 
			
			s PHFCTFormCode=$p($g(^DHCPHFOCON(PHFCTRowId)),"^",1)  //代码
			s PHFCTFormCodeU="<"_$ZCONVERT(PHFCTFormCode,"U")_">"
			s PHFCTFormDesc=$p($g(^DHCPHFOCON(PHFCTRowId)),"^",2)  //描述
			s PHFCTFormDescU="<"_$ZCONVERT(PHFCTFormDesc,"U")_">"
			s PHFCTHisFormCode=$p($g(^DHCPHFOCON(PHFCTRowId)),"^",3)  //his代码
			s PHFCTHisFormDesc=$p($g(^DHCPHFOCON(PHFCTRowId)),"^",4)  //his描述
		
			i (PHFCTFormCodeU[code)&(PHFCTFormDescU[desc)   //条件
			{
				d OutputRow
			}		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHFCTRowId,PHFCTFormCode,PHFCTFormDesc,PHFCTHisFormCode,PHFCTHisFormDesc)
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

/// Description：获取已对照剂型中的hiscode
/// Other: w ##class(web.DHCBL.KB.DHCPHFormContrast).GetHisCode()
ClassMethod GetHisCode() As %String
{
 s str=""
	s PHFCTRowId=0
	for
	{
		s PHFCTRowId=$o(^DHCPHFOCON(PHFCTRowId)) q:PHFCTRowId=""
		s PHFCTHisCode=$p(^DHCPHFOCON(PHFCTRowId),"^",3) //HisCode
		s str="<"_PHFCTHisCode_">^"_str
	}
 q str
}

/// Creator:高姗姗
/// CreatDate: 2014-11-4
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCPHFormContrast).SaveData("8^9")
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCPHEF(rowid)),"^",1)
	s desc=$p($g(^DHCPHEF(rowid)),"^",2)
	s hiscode=$p($g(^PHCF(hisrowid)),"^",1)
	s hisdesc=$p($g(^PHCF(hisrowid)),"^",2)
	i hiscode[$c(13,10) s hiscode=$tr(hiscode,$c(13,10),"")
	i hisdesc[$c(13,10) s hisdesc=$tr(hisdesc,$c(13,10),"")
	
	If hiscode'="" s sshiscode=$o(^DHCPHFOCON(0,"HisCode",hiscode,""))
	//If code'="" s sscode=$o(^DHCPHFOCON(0,"Code",code,hiscode,""))
	s Exdesc=""
	If (sshiscode'="") 
	{
		s Exdesc=$p($g(^DHCPHFOCON(sshiscode)),"^",2)  //描述
	 	Quit "{success:'false',info:'该记录已与"_Exdesc_"对照, 不能重复对照!'}"	
	}
	
	/*s codeStr = ##class(web.DHCBL.KB.DHCPHFormContrast).GetHisCode()
	s hcode = "<"_hiscode_">"
	if (codeStr[hcode) Quit "{success:'false',info:'该记录已对照, 请删除后再对照!'}"*/
	
	s obj=##class(User.DHCPHFormContrast).%New()
	s obj.PHFCTFormCode = code
	s obj.PHFCTFormDesc = desc
	s obj.PHFCTHisFormCode = hiscode
	s obj.PHFCTHisFormDesc = hisdesc
	s logJson="{PHFCTFormCode:"_$c(34)_code_$c(34)_",PHFCTFormDesc:"_$c(34)_desc_$c(34)_",PHFCTHisFormCode:"_$c(34)_hiscode_$c(34)_",PHFCTHisFormDesc:"_$c(34)_hisdesc_$c(34)_"}"
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHFormContrast","User.DHCPHFormContrast","剂型对照",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("剂型对照","web.DHCBL.KB.DHCPHFormContrast","SaveData",logJson)
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
		s eobj = ##class(web.Entity.KB.DHCPHFormContrast).%New()
		s pobj = ##class(User.DHCPHFormContrast).%OpenId(id)
		s eobj.PHFCTRowId = id
		s eobj.PHFCTFormCode = pobj.PHFCTFormCode
		s eobj.PHFCTFormDesc = pobj.PHFCTFormDesc
		s eobj.PHFCTHisFormCode = pobj.PHFCTHisFormCode
		s eobj.PHFCTHisFormDesc = pobj.PHFCTHisFormDesc
	
		s sc=##class(User.DHCPHFormContrast).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHFormContrast","User.DHCPHFormContrast","剂型对照",id,eobj.PHFCTFormDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("剂型对照","web.DHCBL.KB.DHCPHFormContrast","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}
	q result
}

/// Creator:xuwenhu
/// CreatDate: 2021-05-24
/// Description：自动对照
/// Return：匹配数据的数目
/// w ##class(web.DHCBL.KB.DHCPHFormContrast).AutoContrastData()
ClassMethod AutoContrastData() As %String
{
	s count=0
	//遍历单位字典表
	s PHFormRowId=0
    for {
        s PHFormRowId=$o(^DHCPHEF(PHFormRowId)) q:PHFormRowId=""
        s PHFormCode=$p($g(^DHCPHEF(PHFormRowId)),"^",1)
        s PHFormDesc=$p($g(^DHCPHEF(PHFormRowId)),"^",2)
        s PHFormAcitveFlag=$p($g(^DHCPHEF(PHFormRowId)),"^",3)
        s PHFormSysFlag=$p($g(^DHCPHEF(PHFormRowId)),"^",4)
        continue:PHFormAcitveFlag="N" 
        s RowId=0,Code=""
        for
        {
			s RowId=$o(^PHCF(0,"Desc",PHFormDesc,RowId)) q:RowId=""
			s Code=$p($g(^PHCF(RowId)),"^",1) 
        }
       	//保存对照
	 	if (Code'="")
	 	{
			s sshiscode=$o(^DHCPHFOCON(0,"HisCode",Code,""))
			s Exdesc=""
			If (sshiscode="") 
			{
				
				s obj=##class(User.DHCPHFormContrast).%New()
				s obj.PHFCTFormCode = PHFormCode
				s obj.PHFCTFormDesc = PHFormDesc
				s obj.PHFCTHisFormCode = Code
				s obj.PHFCTHisFormDesc = PHFormDesc
				s logJson="{PHFCTFormCode:"_$c(34)_PHFormCode_$c(34)_",PHFCTFormDesc:"_$c(34)_PHFormDesc_$c(34)_",PHFCTHisFormCode:"_$c(34)_Code_$c(34)_",PHFCTHisFormDesc:"_$c(34)_PHFormDesc_$c(34)_"}"
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc){	
					Tc		
					s id = obj.%Id()
					s count=count+1
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHFormContrast","User.DHCPHFormContrast","剂型对照",id,PHFormDesc,"A",logJson)
				}else{
					Trollback
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("剂型对照","web.DHCBL.KB.DHCPHFormContrast","SaveData",logJson)
					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
				
			 }
	 	} 
    }
 	
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

}
