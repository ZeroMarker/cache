/// 症状字典对照表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-7-15
Class web.DHCBL.KB.DHCPHSymptomCon Extends %RegisteredObject
{

/// Creator：谷雪萍
/// CreatDate: 2016-7-15
/// Description：查询已对照内容
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHSymptomCon","GetList","","","","","")
Query GetList(id) As %Query(ROWSPEC = "SYMRowId,SYMCode,SYMDesc,SYMHisCode,SYMHisDesc")
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
		s code=$p($g(^DHCPHSYMP(id)),"^",1)
    	s desc=$p($g(^DHCPHSYMP(id)),"^",2)
        
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s SYMRowId=0
		for  
		{	
			s SYMRowId=$o(^DHCPHSYMCON(SYMRowId)) q:SYMRowId="" 
			//s strRowId = "{ID:"_SYMRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s SYMCode=$p($g(^DHCPHSYMCON(SYMRowId)),"^",1)  //代码
				s SYMCodeU=$ZCONVERT(SYMCode,"U")
				s SYMDesc=$p($g(^DHCPHSYMCON(SYMRowId)),"^",2)  //描述
				s SYMDescU=$ZCONVERT(SYMDesc,"U")
				s SYMHisCode=$p($g(^DHCPHSYMCON(SYMRowId)),"^",3)  //his代码
				s SYMHisDesc=$p($g(^DHCPHSYMCON(SYMRowId)),"^",4)  //his描述
		
				i (SYMCodeU[code)&(SYMDescU[desc)   //条件
				{
					d OutputRow
				}		
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(SYMRowId,SYMCode,SYMDesc,SYMHisCode,SYMHisDesc)
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
/// Other: w ##class(web.DHCBL.KB.DHCPHSymptomCon).GetHisCode()
ClassMethod GetHisCode() As %String
{
 s str=""
	s SYMRowId=0
	for{
		s SYMRowId=$o(^DHCPHSYMCON(SYMRowId)) q:SYMRowId=""
		s SYMHisCode=$p(^DHCPHSYMCON(SYMRowId),"^",3) //HisCode
		s str="<"_SYMHisCode_">^"_str
	}
 q str
}

/// Creator:谷雪萍
/// CreatDate: 2015-1-28
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCPHSymptomCon).SaveData("8^9")
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCPHSYMP(rowid)),"^",1)
	s desc=$p($g(^DHCPHSYMP(rowid)),"^",2)
	s hiscode=$p($g(^DHCSYMFEI(hisrowid)),"^",1)
	s hisdesc=$p($g(^DHCSYMFEI(hisrowid)),"^",2)
	
	
	If hiscode'="" s sshiscode=$o(^DHCPHSYMCON(0,"HisCode",hiscode,""))
	//If code'="" s sscode=$o(^DHCPHSYMCON(0,"Code",code,hiscode,""))
	s Exdesc=""
	If (sshiscode'="") 
	{
		s Exdesc=$p($g(^DHCPHSYMCON(sshiscode)),"^",2)  //描述
	 	Quit "{success:'false',info:'该记录已与"_Exdesc_"对照, 不能重复对照!'}"	
	}
	
	/*s codeStr = ##class(web.DHCBL.KB.DHCPHSymptomCon).GetHisCode()
	s hcode = "<"_hiscode_">"
	if (codeStr[hcode) Quit "{success:'false',info:'该记录已对照, 请删除后再对照!'}"*/
	
	Ts
	s obj=##class(User.DHCPHSymptomCon).%New()
	s obj.SYMCode = code
	s obj.SYMDesc = desc
	s obj.SYMHisCode = hiscode
	s obj.SYMHisDesc = hisdesc
	s logJson="{SYMCode:"_$c(34)_code_$c(34)_",SYMDesc:"_$c(34)_desc_$c(34)_",SYMHisCode:"_$c(34)_hiscode_$c(34)_",SYMHisDesc:"_$c(34)_hisdesc_$c(34)_"}"
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHSymptomCon","User.DHCPHSymptomCon","症状字典对照表",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("症状字典对照表","web.DHCBL.KB.DHCPHSymptomCon","SaveData",logJson)
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
		s eobj = ##class(web.Entity.KB.DHCPHSymptomCon).%New()
		s pobj = ##class(User.DHCPHSymptomCon).%OpenId(id)
		s eobj.SYMRowId = id
		s eobj.SYMCode = pobj.SYMCode
		s eobj.SYMDesc = pobj.SYMDesc
		s eobj.SYMHisCode = pobj.SYMHisCode
		s eobj.SYMHisDesc = pobj.SYMHisDesc
	
		s sc=##class(User.DHCPHSymptomCon).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHSymptomCon","User.DHCPHSymptomCon","症状字典对照表",id,eobj.SYMDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("症状字典对照表","web.DHCBL.KB.DHCPHSymptomCon","DeleteData",eobj)
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
	//遍历症状字典表
	s SYMRowId=0
    for {
        s SYMRowId=$o(^DHCPHSYMP(SYMRowId)) q:SYMRowId=""
        s SYMCode=$p($g(^DHCPHSYMP(SYMRowId)),"^",1)
        s SYMDesc=$p($g(^DHCPHSYMP(SYMRowId)),"^",2)
        s SYMActiveFlag=$p($g(^DHCPHSYMP(SYMRowId)),"^",3)       
        continue:SYMActiveFlag="N"
        
     	
        s RowId=0,Code=""	
		for
		{	
			s RowId=$o(^DHCSYMFEI(0,"Desc",$ZCONVERT(SYMDesc,"U"),RowId)) q:RowId=""
			s Code=$p($g(^DHCSYMFEI(RowId)),"^",1)	
		}
		
       //保存对照
	 	if (Code'="")
	 	{
			s sshiscode=$o(^DHCPHSYMCON(0,"HisCode",Code,""))
			If (sshiscode="") 
			{
				
				Ts
				s obj=##class(User.DHCPHSymptomCon).%New()
				s obj.SYMCode = SYMCode
				s obj.SYMDesc = SYMDesc
				s obj.SYMHisCode = Code
				s obj.SYMHisDesc = SYMDesc
				s logJson="{SYMCode:"_$c(34)_SYMCode_$c(34)_",SYMDesc:"_$c(34)_SYMDesc_$c(34)_",SYMHisCode:"_$c(34)_Code_$c(34)_",SYMHisDesc:"_$c(34)_SYMDesc_$c(34)_"}"
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc){	
					Tc		
					s id = obj.%Id()
					s count=count+1
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHSymptomCon","User.DHCPHSymptomCon","症状字典对照表",id,SYMDesc,"A",logJson)
				}else{
					Trollback
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("症状字典对照表","web.DHCBL.KB.DHCPHSymptomCon","SaveData",logJson)
					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
			 }
	 	} 
    }
 	
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

}
