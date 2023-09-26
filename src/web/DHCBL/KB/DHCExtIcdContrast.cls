Class web.DHCBL.KB.DHCExtIcdContrast Extends %RegisteredObject
{

/// Creator：谷雪萍
/// CreatDate: 2014-11-11
/// Description：查询已对照诊断表内容
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCExtIcdContrast","GetList","5833")
Query GetList(id) As %Query(ROWSPEC = "ICONRowId,ICONCode,ICONDesc,ICONHisCode,ICONHisDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	//s AuStr=##class(web.DHCBL.Authorize.DHCExtIcdContrast).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
	if (id'=""){
		s code=$p($g(^DHCEXTICD(id)),"^",1)
		s:code'="" code=$ZCONVERT(code,"U")
		s desc=$p($g(^DHCEXTICD(id)),"^",2)   
		s ICONRowId=0
		for  
		{	
			s ICONRowId=$o(^DHCEXTICON(ICONRowId)) q:ICONRowId="" 
			//s strRowId = "{ID:"_ICONRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s ICONCode=$p($g(^DHCEXTICON(ICONRowId)),"^",1)  //代码
				s ICONCodeU=$ZCONVERT(ICONCode,"U")
				s ICONDesc=desc
				
				s ICONHisCode=$p($g(^DHCEXTICON(ICONRowId)),"^",2)  //his代码
				s ICONHisDesc=$p($g(^DHCEXTICON(ICONRowId)),"^",3)  //his描述
				
				i (ICONCodeU=code)   //条件
				{
					d OutputRow
				}		
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ICONRowId,ICONCode,ICONDesc,ICONHisCode,ICONHisDesc)
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

/// Creator:谷雪萍
/// CreatDate: 2014-11-11
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.KB.DHCExtIcdContrast).SaveData("1^1")
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCEXTICD(rowid)),"^",1)
	s desc=$p($g(^DHCEXTICD(rowid)),"^",2)
	//s hiscode=$p($g(^MRC("ID",hisrowid)),"^",1)
	s hiscode=$p($g(^MRC("ID",hisrowid)),"^",4)  //改成取ICD代码
	s hisdesc=$p($g(^MRC("ID",hisrowid)),"^",2)
	
	If hiscode'="" s sshiscode=$o(^DHCEXTICON(0,"HisCode",hiscode,""))
	//If code'="" s sscode=$o(^DHCEXTICON(0,"Code",code,hiscode,""))
	s Exdesc=""
	If (sshiscode'="") 
	{
		s Exdesc=$p($g(^DHCEXTICON(sshiscode)),"^",1)  //代码
	 	Quit "{success:'false',info:'该记录已与"_Exdesc_"对照, 不能重复对照!'}"	
	}
	/*s ICONRowId=0,flag=0
	for  
	{	
		s ICONRowId=$o(^DHCEXTICON(ICONRowId)) q:ICONRowId="" 
		s ICONHisCode=$p($g(^DHCEXTICON(ICONRowId)),"^",2)  //his代码
		i (ICONHisCode=hiscode){
			s flag=1	
		}	
	}
	if (flag=1) Quit "{success:'false',info:'该his诊断已对照, 请删除后重新对照!'}"*/
	
	Ts
	s obj=##class(User.DHCExtIcdContrast).%New()
	s obj.ICONCode = code
	//s obj.ICONDesc = desc
	s obj.ICONHisCode = hiscode
	s obj.ICONHisDesc = hisdesc
	s logJson="{ICONCode:"_$c(34)_code_$c(34)_",ICONDesc:"_$c(34)_desc_$c(34)_",ICONHisCode:"_$c(34)_hiscode_$c(34)_",ICONHisDesc:"_$c(34)_hisdesc_$c(34)_"}"
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_ExtIcdContrast","User.DHCExtIcdContrast","诊断对照",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断对照","web.DHCBL.KB.DHCExtIcdContrast","SaveData",logJson)
     	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2014-11-11
/// Description:根据id删除
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""

		Tstart
		s eobj = ##class(web.Entity.KB.DHCExtIcdContrast).%New()
		s pobj = ##class(User.DHCExtIcdContrast).%OpenId(id)
		s eobj.ICONRowId = id
		s eobj.ICONCode = pobj.ICONCode
		s ICONCodeU=$ZCONVERT(eobj.ICONCode,"U")
		if (ICONCodeU'="") {	
			s ICDRowId=$o(^DHCEXTICD(0,"Code",ICONCodeU,0))
			s:ICDRowId'="" eobj.ICONDesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)  //描述
		}
		else{
			s eobj.ICONDesc = ""
		}
		//s eobj.ICONDesc = $p($g(^DHCEXTICD(id)),"^",2)
		s eobj.ICONHisCode = pobj.ICONHisCode
		s eobj.ICONHisDesc = pobj.ICONHisDesc
	
		s sc=##class(User.DHCExtIcdContrast).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ExtIcdContrast","User.DHCExtIcdContrast","诊断对照",id,eobj.ICONDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断对照","web.DHCBL.KB.DHCExtIcdContrast","DeleteData",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	q result
}

/// Creator:丁亚男
/// CreatDate: 2021-05-24
/// Description：自动对照
/// Return：匹配数据的数目
/// w ##class(web.DHCBL.KB.DHCExtIcdContrast).AutoContrastData()
ClassMethod AutoContrastData() As %String
{
	s count=0
	//遍历诊断字典表
	s ICDRowId=0
	for {
		s ICDRowId=$o(^DHCEXTICD(ICDRowId)) q:ICDRowId=""
		s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
		s ICDDesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
        
        //诊断表找描述相同的数据
        s RowId=0,Code=""	
		for
		{	
			s RowId=$o(^MRC("ID",0,"Desc",$$ALPHAUP^SSUTIL4(ICDDesc),RowId)) q:RowId=""
			s Code=$p($g(^MRC("ID",RowId)),"^",4)
			s MRCIDValid=$p($g(^MRC("ID",RowId)),"^",27)
			continue:MRCIDValid="N"
			s MRCIDDateActiveFrom=$p($g(^MRC("ID",RowId)),"^",6)
			s MRCIDDateActiveTo=$p($g(^MRC("ID",RowId)),"^",7)
			continue:(MRCIDDateActiveFrom'="")&&(MRCIDDateActiveFrom>+$h)
			continue:(MRCIDDateActiveTo'="")&&(MRCIDDateActiveTo<+$h)
			//s MRCIDICD9CMCode=$p($g(^MRC("ID",RowId)),"^",4)
		
	       //保存对照
		 	if (Code'="")
		 	{
				s sshiscode=$o(^DHCEXTICON(0,"HisCode",Code,""))
				If (sshiscode="") 
				{
					
					s obj=##class(User.DHCExtIcdContrast).%New()
					s obj.ICONCode = ICDCode
					//s obj.ICONDesc = desc
					s obj.ICONHisCode = Code
					s obj.ICONHisDesc = ICDDesc
					s logJson="{ICONCode:"_$c(34)_ICDCode_$c(34)_",ICONDesc:"_$c(34)_ICDDesc_$c(34)_",ICONHisCode:"_$c(34)_Code_$c(34)_",ICONHisDesc:"_$c(34)_ICDDesc_$c(34)_"}"
					Ts
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc){	
						Tc		
						s id = obj.%Id()
						s count=count+1
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_ExtIcdContrast","User.DHCExtIcdContrast","诊断对照",id,ICDDesc,"A",logJson)
					}else{
						Trollback
						
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断对照","web.DHCBL.KB.DHCExtIcdContrast","SaveData",logJson)
				     	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
					}
					
				 }
		 	} 
    	}
	}
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

}
