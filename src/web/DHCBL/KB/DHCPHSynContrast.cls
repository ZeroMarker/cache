/// 证型字典对照表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-7-15
Class web.DHCBL.KB.DHCPHSynContrast Extends %RegisteredObject
{

/// Creator：谷雪萍
/// CreatDate: 2016-7-15
/// Description：查询已对照内容
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHSynContrast","GetList","","","","","")
Query GetList(id) As %Query(ROWSPEC = "PHSYCRowId,PHSYCCode,PHSYCDesc,PHSYCHisCode,PHSYCHisDesc")
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
	if (id'="")
	{
		s code=$p($g(^DHCPHSYDRO(id)),"^",1)
    	s desc=$p($g(^DHCPHSYDRO(id)),"^",2)
        
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s PHSYCRowId=0
		for  
		{	
			s PHSYCRowId=$o(^DHCPHSYNCON(PHSYCRowId)) q:PHSYCRowId="" 
			//s strRowId = "{ID:"_PHSYCRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s PHSYCCode=$p($g(^DHCPHSYNCON(PHSYCRowId)),"^",1)  //代码
				s PHSYCCodeU=$ZCONVERT(PHSYCCode,"U")
				s PHSYCDesc=$p($g(^DHCPHSYNCON(PHSYCRowId)),"^",2)  //描述
				s PHSYCDescU=$ZCONVERT(PHSYCDesc,"U")
				s PHSYCHisCode=$p($g(^DHCPHSYNCON(PHSYCRowId)),"^",3)  //his代码
				s PHSYCHisDesc=$p($g(^DHCPHSYNCON(PHSYCRowId)),"^",4)  //his描述
		
				i (PHSYCCodeU[code)&(PHSYCDescU[desc)   //条件
				{
					d OutputRow
				}		
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHSYCRowId,PHSYCCode,PHSYCDesc,PHSYCHisCode,PHSYCHisDesc)
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
/// Other: w ##class(web.DHCBL.KB.DHCPHSynContrast).GetHisCode()
ClassMethod GetHisCode() As %String
{
 s str=""
	s PHSYCRowId=0
	for{
		s PHSYCRowId=$o(^DHCPHSYNCON(PHSYCRowId)) q:PHSYCRowId=""
		s PHSYCHisCode=$p(^DHCPHSYNCON(PHSYCRowId),"^",3) //HisCode
		s str="<"_PHSYCHisCode_">^"_str
	}
 q str
}

/// Creator:谷雪萍
/// CreatDate: 2015-1-28
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCPHSynContrast).SaveData("8^9")
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCPHSYDRO(rowid)),"^",1)
	s desc=$p($g(^DHCPHSYDRO(rowid)),"^",2)
	s hiscode=$p($g(^MRC("ID",hisrowid)),"^",1)
	s hisdesc=$p($g(^MRC("ID",hisrowid)),"^",2)
	
	
	If hiscode'="" s sshiscode=$o(^DHCPHSYNCON(0,"HisCode",hiscode,""))
	//If code'="" s sscode=$o(^DHCPHSYNCON(0,"Code",code,hiscode,""))
	s Exdesc=""
	If (sshiscode'="") 
	{
		s Exdesc=$p($g(^DHCPHSYNCON(sshiscode)),"^",2)  //描述
	 	Quit "{success:'false',info:'该记录已与"_Exdesc_"对照, 不能重复对照!'}"	
	}
	/*s codeStr = ##class(web.DHCBL.KB.DHCPHSynContrast).GetHisCode()
	s hcode = "<"_hiscode_">"
	if (codeStr[hcode) Quit "{success:'false',info:'该记录已对照, 请删除后再对照!'}"*/
	
	Ts
	s obj=##class(User.DHCPHSynContrast).%New()
	s obj.PHSYCCode = code
	s obj.PHSYCDesc = desc
	s obj.PHSYCHisCode = hiscode
	s obj.PHSYCHisDesc = hisdesc
	s logJson="{PHSYCCode:"_$c(34)_code_$c(34)_",PHSYCDesc:"_$c(34)_desc_$c(34)_",PHSYCHisCode:"_$c(34)_hiscode_$c(34)_",PHSYCHisDesc:"_$c(34)_hisdesc_$c(34)_"}"
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHSynContrast","User.DHCPHSynContrast","证型字典对照表",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("证型字典对照表","web.DHCBL.KB.DHCPHSynContrast","SaveData",logJson)
    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
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
		s eobj = ##class(web.Entity.KB.DHCPHSynContrast).%New()
		s pobj = ##class(User.DHCPHSynContrast).%OpenId(id)
		s eobj.PHSYCRowId = id
		s eobj.PHSYCCode = pobj.PHSYCCode
		s eobj.PHSYCDesc = pobj.PHSYCDesc
		s eobj.PHSYCHisCode = pobj.PHSYCHisCode
		s eobj.PHSYCHisDesc = pobj.PHSYCHisDesc
	
		s sc=##class(User.DHCPHSynContrast).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHSynContrast","User.DHCPHSynContrast","证型字典对照表",id,eobj.PHSYCDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("证型字典对照表","web.DHCBL.KB.DHCPHSynContrast","DeleteData",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	q result
}

/// Description:医生站 辩证维护 MRC_DiagnosSignSymptom
/// Table：User.DHCPHSyndrome
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHSyndrome","GetDataForHis","","","")
Query GetDataForHis(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "DSYMRowId:%String,DSYMCode:%String,DSYMDesc:%String")
{
}

ClassMethod GetDataForHisExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCPHSyndrome).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s DSYMRowId=rowid
		s DSYMCode=$p($g(^MRC("ID",DSYMRowId)),"^",1)
		s DSYMDesc=$p($g(^MRC("ID",DSYMRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s DSYMRowId=0
		for {
			s DSYMRowId=$o(^MRC("ID",DSYMRowId)) q:DSYMRowId=""

			s DSYMCode=$p($g(^MRC("ID",DSYMRowId)),"^",1)
			s DSYMDesc=$p($g(^MRC("ID",DSYMRowId)),"^",2)
			s MRCIDBillFlag1=$p($g(^MRC("ID",DSYMRowId)),"^",13) //中医证型标志
			s PINYIN=""
			if (desc'="")
			{
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DSYMDesc)
			}
			if ($ZCONVERT(DSYMCode,"U")[code)&(($ZCONVERT(DSYMDesc,"U")[desc)||(PINYIN[desc))&(MRCIDBillFlag1="Y")
			{
				d OutputRowCmb
			}
		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(DSYMRowId,DSYMCode,DSYMDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForHisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForHisExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForHisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForHisExecute ]
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

/// Creator:丁亚男
/// CreatDate: 2021-05-24
/// Description：自动对照
/// Return：匹配数据的数目
/// w ##class(web.DHCBL.KB.DHCPHHospLocCon).AutoContrastData()
ClassMethod AutoContrastData() As %String
{
	s count=0
	//遍历证型字典表
	s DRORowId=0
    for {
        s DRORowId=$o(^DHCPHSYDRO(DRORowId)) q:DRORowId=""
        
        s DROCode=$p($g(^DHCPHSYDRO(DRORowId)),"^",1)
        s DRODesc=$p($g(^DHCPHSYDRO(DRORowId)),"^",2)
        s DROActiveFlag=$p($g(^DHCPHSYDRO(DRORowId)),"^",3)
        continue:DROActiveFlag="N"
     	
        s RowId=0,Code=""	
		for
		{	
			s RowId=$o(^MRC("ID",0,"Desc",$ZCONVERT(DRODesc,"U"),RowId)) q:RowId=""
			s Code=$p($g(^MRC("ID",RowId)),"^",1)
			s MRCIDBillFlag1=$p($g(^MRC("ID",RowId)),"^",13) //中医证型标志
			continue:MRCIDBillFlag1'="Y"
		}
		
       //保存对照
	 	if (Code'="")
	 	{
			s sshiscode=$o(^DHCPHSYNCON(0,"HisCode",Code,""))
			If (sshiscode="") 
			{
				
				Ts
				s obj=##class(User.DHCPHSynContrast).%New()
				s obj.PHSYCCode = DROCode
				s obj.PHSYCDesc = DRODesc
				s obj.PHSYCHisCode = Code
				s obj.PHSYCHisDesc = DRODesc
				s logJson="{PHSYCCode:"_$c(34)_DROCode_$c(34)_",PHSYCDesc:"_$c(34)_DRODesc_$c(34)_",PHSYCHisCode:"_$c(34)_Code_$c(34)_",PHSYCHisDesc:"_$c(34)_DRODesc_$c(34)_"}"
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc){	
					Tc		
					s id = obj.%Id()
					s count=count+1
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHSynContrast","User.DHCPHSynContrast","证型字典对照表",id,DRODesc,"A",logJson)
				}else{
					Trollback
					
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("证型字典对照表","web.DHCBL.KB.DHCPHSynContrast","SaveData",logJson)
			    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
				
			 }
	 	} 
    }
 	
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

}
