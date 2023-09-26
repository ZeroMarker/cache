/// 科室字典对照表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-7-15
Class web.DHCBL.KB.DHCPHHospLocCon Extends %RegisteredObject
{

/// Creator：谷雪萍
/// CreatDate: 2016-7-15
/// Description：查询已对照内容
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHHospLocCon","GetList","","","","","")
Query GetList(id) As %Query(ROWSPEC = "HOSPLRowId,HOSPLCode,HOSPLDesc,HOSPLHisCode,HOSPLHisDesc")
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
		s code=$p($g(^DHCPHHLOC(id)),"^",1)
    	s desc=$p($g(^DHCPHHLOC(id)),"^",2)
        
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s HOSPLRowId=0
		for  
		{	
			s HOSPLRowId=$o(^DHCPHHLOCCON(HOSPLRowId)) q:HOSPLRowId="" 
			//s strRowId = "{ID:"_HOSPLRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s HOSPLCode=$p($g(^DHCPHHLOCCON(HOSPLRowId)),"^",1)  //代码
				s HOSPLCodeU=$ZCONVERT(HOSPLCode,"U")
				s HOSPLDesc=$p($g(^DHCPHHLOCCON(HOSPLRowId)),"^",2)  //描述
				s HOSPLDescU=$ZCONVERT(HOSPLDesc,"U")
				s HOSPLHisCode=$p($g(^DHCPHHLOCCON(HOSPLRowId)),"^",3)  //his代码
				s HOSPLHisDesc=$p($g(^DHCPHHLOCCON(HOSPLRowId)),"^",4)  //his描述
		
				i (HOSPLCodeU[code)&(HOSPLDescU[desc)   //条件
				{
					d OutputRow
				}		
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(HOSPLRowId,HOSPLCode,HOSPLDesc,HOSPLHisCode,HOSPLHisDesc)
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
/// Other: w ##class(web.DHCBL.KB.DHCPHHospLocCon).GetHisCode()
ClassMethod GetHisCode() As %String
{
 s str=""
	s HOSPLRowId=0
	for{
		s HOSPLRowId=$o(^DHCPHHLOCCON(HOSPLRowId)) q:HOSPLRowId=""
		s HOSPLHisCode=$p(^DHCPHHLOCCON(HOSPLRowId),"^",3) //HisCode
		s str="<"_HOSPLHisCode_">^"_str
	}
 q str
}

/// Creator:谷雪萍
/// CreatDate: 2015-1-28
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCPHHospLocCon).SaveData("8^9")
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCPHHLOC(rowid)),"^",1)
	s desc=$p($g(^DHCPHHLOC(rowid)),"^",2)
	s hiscode=$p($g(^CTLOC(hisrowid)),"^",1)
	s hisdesc=$p($g(^CTLOC(hisrowid)),"^",2)
	
	
	If hiscode'="" s sshiscode=$o(^DHCPHHLOCCON(0,"HisCode",hiscode,""))
	//If code'="" s sscode=$o(^DHCPHHLOCCON(0,"Code",code,hiscode,""))
	s Exdesc=""
	If (sshiscode'="") 
	{
		s Exdesc=$p($g(^DHCPHHLOCCON(sshiscode)),"^",2)  //描述
	 	Quit "{success:'false',info:'该记录已与"_Exdesc_"对照, 不能重复对照!'}"	
	}
	/*s codeStr = ##class(web.DHCBL.KB.DHCPHHospLocCon).GetHisCode()
	s hcode = "<"_hiscode_">"
	if (codeStr[hcode) Quit "{success:'false',info:'该记录已对照, 请删除后再对照!'}"*/
	
	Ts
	s obj=##class(User.DHCPHHospLocCon).%New()
	s obj.HOSPLCode = code
	s obj.HOSPLDesc = desc
	s obj.HOSPLHisCode = hiscode
	s obj.HOSPLHisDesc = hisdesc
	s logJson="{HOSPLCode:"_$c(34)_code_$c(34)_",HOSPLDesc:"_$c(34)_desc_$c(34)_",HOSPLHisCode:"_$c(34)_hiscode_$c(34)_",HOSPLHisDesc:"_$c(34)_hisdesc_$c(34)_"}"
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHHospLocCon","User.DHCPHHospLocCon","科室字典对照表",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室字典对照表","web.DHCBL.KB.DHCPHHospLocCon","SaveData",logJson)
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
		s eobj = ##class(web.Entity.KB.DHCPHHospLocCon).%New()
		s pobj = ##class(User.DHCPHHospLocCon).%OpenId(id)
		s eobj.HOSPLRowId = id
		s eobj.HOSPLCode = pobj.HOSPLCode
		s eobj.HOSPLDesc = pobj.HOSPLDesc
		s eobj.HOSPLHisCode = pobj.HOSPLHisCode
		s eobj.HOSPLHisDesc = pobj.HOSPLHisDesc
	
		s sc=##class(User.DHCPHHospLocCon).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHHospLocCon","User.DHCPHHospLocCon","科室字典对照表",id,eobj.HOSPLDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室字典对照表","web.DHCBL.KB.DHCPHHospLocCon","DeleteData",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	q result
}

/// Creator:丁亚男
/// CreatDate: 2021-05-24
/// Description：自动对照
/// Return：匹配数据的数目
/// w ##class(web.DHCBL.KB.DHCPHHospLocCon).AutoContrastData()
ClassMethod AutoContrastData() As %String
{
	s count=0
	//遍历科室字典表
	s HOSPLRowId=0
    for {
        s HOSPLRowId=$o(^DHCPHHLOC(HOSPLRowId)) q:HOSPLRowId=""
        s HOSPLCode=$p($g(^DHCPHHLOC(HOSPLRowId)),"^",1)
        s HOSPLDesc=$p($g(^DHCPHHLOC(HOSPLRowId)),"^",2)
        s HOSPLActiveFlag=$p($g(^DHCPHHLOC(HOSPLRowId)),"^",3)    
        continue:HOSPLActiveFlag="N"
        
         
        s RowId=0,Code=""	
		for
		{	
			s RowId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(HOSPLDesc),RowId)) q:RowId=""
			s Code=$p($g(^CTLOC(RowId)),"^",1)        //科室Code	
		}
		
       //保存对照
	 	if (Code'="")
	 	{
			s sshiscode=$o(^DHCPHHLOCCON(0,"HisCode",Code,""))
			If (sshiscode="") 
			{
				
				s obj=##class(User.DHCPHHospLocCon).%New()
				s obj.HOSPLCode = HOSPLCode
				s obj.HOSPLDesc = HOSPLDesc
				s obj.HOSPLHisCode = Code
				s obj.HOSPLHisDesc = HOSPLDesc
				s logJson="{HOSPLCode:"_$c(34)_HOSPLCode_$c(34)_",HOSPLDesc:"_$c(34)_HOSPLDesc_$c(34)_",HOSPLHisCode:"_$c(34)_Code_$c(34)_",HOSPLHisDesc:"_$c(34)_HOSPLDesc_$c(34)_"}"
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc){	
					Tc		
					s id = obj.%Id()
					s count=count+1
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHHospLocCon","User.DHCPHHospLocCon","科室字典对照表",id,HOSPLDesc,"A",logJson)
				}else{
					Trollback
					
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室字典对照表","web.DHCBL.KB.DHCPHHospLocCon","SaveData",logJson)
			    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
			 }
	 	} 
    }
 	
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

}
