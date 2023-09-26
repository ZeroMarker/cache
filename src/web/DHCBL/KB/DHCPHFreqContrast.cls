Class web.DHCBL.KB.DHCPHFreqContrast Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2014-11-6
/// Description：查询已对照频率表内容
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHFreqContrast","GetList","")
Query GetList(id) As %Query(ROWSPEC = "PHFCTRowId,PHFCTFreqCode,PHFCTFreqDesc,PHFCTHisFreqCode,PHFCTHisFreqDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (id'=""){
		s code=$p($g(^DHCPHEFR(id)),"^",1)
    	s desc=$p($g(^DHCPHEFR(id)),"^",2)
        
		s:code'="" code="<"_$ZCONVERT(code,"U")_">"
		s:desc'="" desc="<"_$ZCONVERT(desc,"U")_">"
		s PHFCTRowId=0
		for  
		{	
			s PHFCTRowId=$o(^DHCPHFRCON(PHFCTRowId)) q:PHFCTRowId="" 

			s PHFCTFreqCode=$p($g(^DHCPHFRCON(PHFCTRowId)),"^",1)  //代码
			s PHFCTFreqCodeU="<"_$ZCONVERT(PHFCTFreqCode,"U")_">"
			s PHFCTFreqDesc=$p($g(^DHCPHFRCON(PHFCTRowId)),"^",2)  //描述
			s PHFCTFreqDescU="<"_$ZCONVERT(PHFCTFreqDesc,"U")_">"
			s PHFCTHisFreqCode=$p($g(^DHCPHFRCON(PHFCTRowId)),"^",3)  //his代码
			s PHFCTHisFreqDesc=$p($g(^DHCPHFRCON(PHFCTRowId)),"^",4)  //his描述
		
			i (PHFCTFreqCodeU[code)&(PHFCTFreqDescU[desc)   //条件
			{
				d OutputRow
			}		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHFCTRowId,PHFCTFreqCode,PHFCTFreqDesc,PHFCTHisFreqCode,PHFCTHisFreqDesc)
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

/// Description：获取已对照频率中的hiscode
/// Other: w ##class(web.DHCBL.KB.DHCPHFreqContrast).GetHisCode()
ClassMethod GetHisCode() As %String
{
 s str=""
	s PHFCTRowId=0
	for
	{
		s PHFCTRowId=$o(^DHCPHFRCON(PHFCTRowId)) q:PHFCTRowId=""
		s PHFCTHisCode=$p(^DHCPHFRCON(PHFCTRowId),"^",3) //HisCode
		s str="<"_PHFCTHisCode_">^"_str
	}
 q str
}

/// Creator:高姗姗
/// CreatDate: 2014-11-4
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCPHEFR(rowid)),"^",1)
	s desc=$p($g(^DHCPHEFR(rowid)),"^",2)
	s hiscode=$p($g(^PHCFR(hisrowid)),"^",1)
	s hisdesc=$p($g(^PHCFR(hisrowid)),"^",3)
	
	
	If hiscode'="" s sshiscode=$o(^DHCPHFRCON(0,"HisCode",hiscode,""))
	//If code'="" s sscode=$o(^DHCPHFRCON(0,"Code",code,hiscode,""))
	s Exdesc=""
	If (sshiscode'="") 
	{
		s Exdesc=$p($g(^DHCPHFRCON(sshiscode)),"^",2)  //描述
	 	Quit "{success:'false',info:'该记录已与"_Exdesc_"对照, 不能重复对照!'}"	
	}	
	/*s codeStr = ##class(web.DHCBL.KB.DHCPHFreqContrast).GetHisCode()
	s hcode = "<"_hiscode_">"
	if (codeStr[hcode) Quit "{success:'false',info:'该记录已对照, 请删除后再对照!'}"*/
	
	s obj=##class(User.DHCPHFreqContrast).%New()
	s obj.PHFCTFreqCode = code
	s obj.PHFCTFreqDesc = desc
	s obj.PHFCTHisFreqCode = hiscode
	s obj.PHFCTHisFreqDesc = hisdesc
	s logJson="{PHFCTFreqCode:"_$c(34)_code_$c(34)_",PHFCTFreqDesc:"_$c(34)_desc_$c(34)_",PHFCTHisFreqCode:"_$c(34)_hiscode_$c(34)_",PHFCTHisFreqDesc:"_$c(34)_hisdesc_$c(34)_"}"
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHFreqContrast","User.DHCPHFreqContrast","频率对照",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("频率对照","web.DHCBL.KB.DHCPHFreqContrast","SaveData",logJson)
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
		s eobj = ##class(web.Entity.KB.DHCPHFreqContrast).%New()
		s pobj = ##class(User.DHCPHFreqContrast).%OpenId(id)
		s eobj.PHFCTRowId = id
		s eobj.PHFCTFreqCode = pobj.PHFCTFreqCode
		s eobj.PHFCTFreqDesc = pobj.PHFCTFreqDesc
		s eobj.PHFCTHisFreqCode = pobj.PHFCTHisFreqCode
		s eobj.PHFCTHisFreqDesc = pobj.PHFCTHisFreqDesc
	
		s sc=##class(User.DHCPHFreqContrast).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHFreqContrast","User.DHCPHFreqContrast","频率对照",id,eobj.PHFCTFreqDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("频率对照","web.DHCBL.KB.DHCPHFreqContrast","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}
	q result
}

/// Creator:xuwenhu
/// CreatDate: 2021-05-24
/// Description：自动对照
/// Return：匹配数据的数目
/// w ##class(web.DHCBL.KB.DHCPHFreqContrast).AutoContrastData()
ClassMethod AutoContrastData() As %String
{
	s count=0
	//遍历频率字典表
	s PHEFRowId=0
    for {
        s PHEFRowId=$o(^DHCPHEFR(PHEFRowId)) q:PHEFRowId=""
        s PHEFCode=$p($g(^DHCPHEFR(PHEFRowId)),"^",1)
        s PHEFDesc=$p($g(^DHCPHEFR(PHEFRowId)),"^",2)
        s PHEFAcitveFlag=$p($g(^DHCPHEFR(PHEFRowId)),"^",3)
        s PHEFSysFlag=$p($g(^DHCPHEFR(PHEFRowId)),"^",4)
        continue:PHEFAcitveFlag="N" 
        s RowId=0,Code=""
        for
        {
			s RowId=$o(^PHCFR(0,"Desc1",$$ALPHAUP^SSUTIL4(PHEFDesc),RowId)) q:RowId=""
			b ;11
			s Code=$p($g(^PHCFR(RowId)),"^",1) 
        }
       	//保存对照
	 	if (Code'="")
	 	{
			s sshiscode=$o(^DHCPHFRCON(0,"HisCode",Code,""))
			s Exdesc=""
			If (sshiscode="") 
			{
				
				s obj=##class(User.DHCPHFreqContrast).%New()
				s obj.PHFCTFreqCode = PHEFCode
				s obj.PHFCTFreqDesc = PHEFDesc
				s obj.PHFCTHisFreqCode = Code
				s obj.PHFCTHisFreqDesc = PHEFDesc
				s logJson="{PHFCTFreqCode:"_$c(34)_PHEFCode_$c(34)_",PHFCTFreqDesc:"_$c(34)_PHEFDesc_$c(34)_",PHFCTHisFreqCode:"_$c(34)_Code_$c(34)_",PHFCTHisFreqDesc:"_$c(34)_PHEFDesc_$c(34)_"}"
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc){	
					Tc		
					s id = obj.%Id()
					s count=count+1
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHFreqContrast","User.DHCPHFreqContrast","频率对照",id,PHEFDesc,"A",logJson)
				}else{
					Trollback
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("频率对照","web.DHCBL.KB.DHCPHFreqContrast","SaveData",logJson)
					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
				
			 }
	 	} 
    }
 	
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

}
