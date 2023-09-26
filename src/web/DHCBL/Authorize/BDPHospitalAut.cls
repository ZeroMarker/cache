/// 医院级别授权
/// 2013-10-11 by caihaozhe
Class web.DHCBL.Authorize.BDPHospitalAut Extends web.BDP.sys.ExtPreferences
{

/// w ##class(web.DHCBL.Authorize.CTAcuity).SaveAuthorizeData("G","1","[{ID:1},{ID:2}]")
/// w ##class(web.DHCBL.Authorize.CTAcuity).GetTreeJson("menuTreeRoot","G","1")
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "HospPre";

// Parameter EntityClassName = "web.Entity.CT.CTLoc";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
	s strAutMenu=##class(web.DHCBL.Authorize.BDPHospitalAut).DHCGetDataByReference(ObjectType,ObjectReference)
	q strAutMenu
}

// 根据session获取医院级别数据授权

ClassMethod GetHospAutFlag() As %String
{
	s flag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
	if flag = "N" Q "off"						//如果没开启医院级别授权  则没有任何医院级限制
	s result = 0
	;s mySessionStr=..DHCGetDefaultSystemSession()
	
	s myLocID=$g(%session.Data("LOGON.CTLOCID"))  //获取登录科室
	s myHospitalID = $p($g(^CTLOC(myLocID)),"^",22) 	//根据登录科室获取对应的医院  
	if myHospitalID ="" s result=0
	s AuStr=..DHCGetDataByDefaultSession()
	if AuStr=""			//当登录角色没有过授权时，则默认权限为登录科室指向医院
	{
		s result = "{ID:"_ myHospitalID_"}"
	}
	else				//当登录角色有进行医院授权时，则权限根据授权来控制
	{
		if (AuStr["limited:0")  s result = 1    //不受任何限制，可以查看所有医院数据
		if (AuStr["limited:2")  
		{
			s:myHospitalID'="" result = "{ID:"_ myHospitalID_"}"   //只可以查看该角色登录科室指向的医院数据
		}
		if (AuStr["limited:1") 				  //只可以查看所授权医院数据
		{
			s result = AuStr
		}
	}
	s ^TmpCai1=result
	q result
}

/// 一级授权中获取Tree类型的json串
/// ParentID： 父ID
/// ObjectType: 需要显示的优先级类别
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String, start, limit, query) As %String
{
	if (ParentID="menuTreeRoot") s ParentID=-100000000000000
	
	s myJsonStr=""
	s myImage=""
	
	//获取授权JSON
	s AuStr=##class(web.DHCBL.Authorize.BDPHospitalAut).DHCGetDataByReference(ObjectType,ObjectReference)				
	
	s RowId=0
	s count=0
	s end=start+limit
	
	for
	{
		s RowId=$o(^CT("HOSP",RowId)) q:RowId=""
		s Desc=$p(^CT("HOSP",RowId),"^",2)
		s HOSPDateTo=$p($g(^CT("HOSP",RowId)),"^",10)
        continue:(HOSPDateTo'="")&&(HOSPDateTo<+$h)  //2022-07-25 过滤掉停用的医院
		if ($ZCONVERT(Desc,"U")[$ZCONVERT(query,"U")){
			s count=count+1
			if ((count>start) & (count<=end)) || (end=0){
				s AuStr2="{ID:"_RowId_"}"
				if (AuStr[AuStr2) s myEnable=1
				else  s myEnable=0
				
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_RowId_""",""text"":"""_Desc_""","
				
				if (+myEnable){
					s myJsonStr=myJsonStr_"""checked"":true,"
				}else{
					s myJsonStr=myJsonStr_"""checked"":false,"
				}
				s myJsonStr=myJsonStr_"""leaf"":true"
				s myJsonStr=myJsonStr_"}"
			}
		}
	}
	s myJsonStr="{data:["_myJsonStr_"],totalCount:"_count_"}"
	
	q myJsonStr
}

}
