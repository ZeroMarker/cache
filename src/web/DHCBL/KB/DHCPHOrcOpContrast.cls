Class web.DHCBL.KB.DHCPHOrcOpContrast Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2017-4-10
/// Description：查询已对照手术表内容
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHOrcOpContrast","GetList","","","","","")
Query GetList(id) As %Query(ROWSPEC = "PHOCTRowId,PHOCTOperCode,PHOCTOperDesc,PHOCTHisOperCode,PHOCTHisOperDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (id'=""){
		s code=$p($g(^DHCPHEGEN(id)),"^",1)
    	s desc=$p($g(^DHCPHEGEN(id)),"^",2)
        
		s:code'="" code="<"_$ZCONVERT(code,"U")_">"
		s:desc'="" desc="<"_$ZCONVERT(desc,"U")_">"
		s PHOCTRowId=0
		for  
		{	
			s PHOCTRowId=$o(^DHCPHOPCON(PHOCTRowId)) q:PHOCTRowId="" 
			
			s PHOCTOperCode=$p($g(^DHCPHOPCON(PHOCTRowId)),"^",1)  //代码
			s PHOCTOperCodeU="<"_$ZCONVERT(PHOCTOperCode,"U")_">"
			s PHOCTOperDesc=$p($g(^DHCPHOPCON(PHOCTRowId)),"^",2)  //描述
			s PHOCTOperDescU="<"_$ZCONVERT(PHOCTOperDesc,"U")_">"
			s PHOCTHisOperCode=$p($g(^DHCPHOPCON(PHOCTRowId)),"^",3)  //his代码
			s PHOCTHisOperDesc=$p($g(^DHCPHOPCON(PHOCTRowId)),"^",4)  //his描述
		
			i (PHOCTOperCodeU[code)&(PHOCTOperDescU[desc)   //条件
			{
				d OutputRow
			}		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHOCTRowId,PHOCTOperCode,PHOCTOperDesc,PHOCTHisOperCode,PHOCTHisOperDesc)
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

/// Description：获取已对照手术中的hiscode
/// Other: w ##class(web.DHCBL.KB.DHCPHOrcOpContrast).GetHisCode()
ClassMethod GetHisCode() As %String
{
 s str=""
	s PHOCTRowId=0
	for
	{
		s PHOCTRowId=$o(^DHCPHOPCON(PHOCTRowId)) q:PHOCTRowId=""
		s PHOCTHisCode=$p(^DHCPHOPCON(PHOCTRowId),"^",3) //HisCode
		s str="<"_PHOCTHisCode_">^"_str
	}
 q str
}

/// Creator:高姗姗
/// CreatDate: 2014-11-4
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCPHOrcOpContrast).SaveData("8^9")
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCPHEGEN(rowid)),"^",1)
	s desc=$p($g(^DHCPHEGEN(rowid)),"^",2)
	s hiscode=$p($g(^ORC("OPER",hisrowid)),"^",1)
	s hisdesc=$p($g(^ORC("OPER",hisrowid)),"^",2)
	i hiscode[$c(13,10) s hiscode=$tr(hiscode,$c(13,10),"")
	i hisdesc[$c(13,10) s hisdesc=$tr(hisdesc,$c(13,10),"")
	
	If hiscode'="" s sshiscode=$o(^DHCPHOPCON(0,"HisCode",hiscode,""))
	//If code'="" s sscode=$o(^DHCPHOPCON(0,"Code",code,hiscode,""))
	If (sshiscode'="") Quit "{success:'false',info:'该记录已对照, 不能重复对照!'}"	
	/*s codeStr = ##class(web.DHCBL.KB.DHCPHOrcOpContrast).GetHisCode()
	s hcode = "<"_hiscode_">"
	if (codeStr[hcode) Quit "{success:'false',info:'该记录已对照, 请删除后再对照!'}"*/
	
	s obj=##class(User.DHCPHOrcOpContrast).%New()
	s obj.PHOCTOperCode = code
	s obj.PHOCTOperDesc = desc
	s obj.PHOCTHisOperCode = hiscode
	s obj.PHOCTHisOperDesc = hisdesc
	s logJson="{PHOCTOperCode:"_$c(34)_code_$c(34)_",PHOCTOperDesc:"_$c(34)_desc_$c(34)_",PHOCTHisOperCode:"_$c(34)_hiscode_$c(34)_",PHOCTHisOperDesc:"_$c(34)_hisdesc_$c(34)_"}"
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHOrcOpContrast","User.DHCPHOrcOpContrast","手术对照",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术对照","web.DHCBL.KB.DHCPHOrcOpContrast","SaveData",logJson)
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
		s eobj = ##class(web.Entity.KB.DHCPHOrcOpContrast).%New()
		s pobj = ##class(User.DHCPHOrcOpContrast).%OpenId(id)
		s eobj.PHOCTRowId = id
		s eobj.PHOCTOperCode = pobj.PHOCTOperCode
		s eobj.PHOCTOperDesc = pobj.PHOCTOperDesc
		s eobj.PHOCTHisOperCode = pobj.PHOCTHisOperCode
		s eobj.PHOCTHisOperDesc = pobj.PHOCTHisOperDesc
	
		s sc=##class(User.DHCPHOrcOpContrast).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHOrcOpContrast","User.DHCPHOrcOpContrast","手术对照",id,eobj.PHOCTOperDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术对照","web.DHCBL.KB.DHCPHOrcOpContrast","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}
	q result
}

/// Creator:xuwenhu
/// CreatDate: 2021-05-24
/// Description：自动对照
/// Return：匹配数据的数目
/// w ##class(web.DHCBL.KB.DHCPHOrcOpContrast).AutoContrastData()
ClassMethod AutoContrastData() As %String
{
	s count=0
	//遍历单位字典表
	s PHOrcOpRowId=0
    for {
        s PHOrcOpRowId=$o(^DHCPHEGEN(PHOrcOpRowId)) q:PHOrcOpRowId=""
        s PHOrcOpCode=$p($g(^DHCPHEGEN(PHOrcOpRowId)),"^",1)
        s PHOrcOpDesc=$p($g(^DHCPHEGEN(PHOrcOpRowId)),"^",2)
        s PHEGLibDr=$p($g(^DHCPHEGEN(PHOrcOpRowId)),"^",7)  //知识库标识DR
		s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
		s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
		s PHLICodeU=$ZCONVERT(PHLICode,"U")
		continue:(PHLICodeU'="OPERATION")		
        s PHOrcOpAcitveFlag=$p($g(^DHCPHEGEN(PHOrcOpRowId)),"^",6)
        s PHOrcOpSysFlag=$p($g(^DHCPHEGEN(PHOrcOpRowId)),"^",8)
        continue:PHOrcOpAcitveFlag="N" 
        s RowId=0,Code=""
        for
        {
			s RowId=$o(^ORC("OPER",0,"Desc",$$ALPHAUP^SSUTIL4(PHOrcOpDesc),RowId)) q:RowId=""
			s Code=$p($g(^ORC("OPER",RowId)),"^",1) 
        }
       	//保存对照
	 	if (Code'="")
	 	{
			s sshiscode=$o(^DHCPHOPCON(0,"HisCode",Code,""))
			s Exdesc=""
			If (sshiscode="") 
			{
				
				s obj=##class(User.DHCPHOrcOpContrast).%New()
				s obj.PHOCTOperCode = PHOrcOpCode
				s obj.PHOCTOperDesc = PHOrcOpDesc
				s obj.PHOCTHisOperCode = Code
				s obj.PHOCTHisOperDesc = PHOrcOpDesc
				s logJson="{PHOCTOperCode:"_$c(34)_PHOrcOpCode_$c(34)_",PHOCTOperDesc:"_$c(34)_PHOrcOpDesc_$c(34)_",PHOCTHisOperCode:"_$c(34)_Code_$c(34)_",PHOCTHisOperDesc:"_$c(34)_PHOrcOpDesc_$c(34)_"}"
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc){	
					Tc		
					s id = obj.%Id()
					s count=count+1
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHOrcOpContrast","User.DHCPHOrcOpContrast","手术对照",id,PHOrcOpDesc,"A",logJson)
				}else{
					Trollback
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术对照","web.DHCBL.KB.DHCPHOrcOpContrast","SaveData",logJson)
					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
				
			 }
	 	} 
    }
 	
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

}
