/// 商品名与His对照表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-10-11
Class web.DHCBL.KB.DHCPHProContrast Extends %RegisteredObject
{

/// Creator：谷雪萍
/// Description：查询已对照内容
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHProContrast","GetList","","","","","")
Query GetList(id) As %Query(ROWSPEC = "PHPCRowId,PHPCCode,PHPCDesc,PHPCHisCode,PHPCHisDesc")
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
		s code=$p($g(^DHCPHPNA(id)),"^",1)
    	s desc=$p($g(^DHCPHPNA(id)),"^",2)
        
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s PHPCRowId=0
		for  
		{	
			s PHPCRowId=$o(^DHCPHPCO(PHPCRowId)) q:PHPCRowId="" 
			//s strRowId = "{ID:"_PHPCRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s PHPCCode=$p($g(^DHCPHPCO(PHPCRowId)),"^",1)  //代码
				s PHPCCodeU=$ZCONVERT(PHPCCode,"U")
				s PHPCDesc=$p($g(^DHCPHPCO(PHPCRowId)),"^",2)  //描述
				s PHPCDescU=$ZCONVERT(PHPCDesc,"U")
				s PHPCHisCode=$p($g(^DHCPHPCO(PHPCRowId)),"^",3)  //his代码
				s PHPCHisDesc=$p($g(^DHCPHPCO(PHPCRowId)),"^",4)  //his描述
		
				i (PHPCCodeU[code)&(PHPCDescU[desc)   //条件
				{
					d OutputRow
				}		
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHPCRowId,PHPCCode,PHPCDesc,PHPCHisCode,PHPCHisDesc)
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
/// Other: w ##class(web.DHCBL.KB.DHCPHProContrast).GetHisCode()
ClassMethod GetHisCode() As %String
{
 s str=""
	s PHPCRowId=0
	for{
		s PHPCRowId=$o(^DHCPHPCO(PHPCRowId)) q:PHPCRowId=""
		s PHPCHisCode=$p(^DHCPHPCO(PHPCRowId),"^",3) //HisCode
		s str="<"_PHPCHisCode_">^"_str
	}
 q str
}

/// Creator:谷雪萍
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCPHProContrast).SaveData("8^9")
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCPHPNA(rowid)),"^",1)
	s desc=$p($g(^DHCPHPNA(rowid)),"^",2)
	s hiscode=$p($g(^PHCD(hisrowid,1)),"^",1)
	s hisdesc=$p($g(^PHCD(hisrowid,1)),"^",2)
	
	
	If hiscode'="" s sshiscode=$o(^DHCPHPCO(0,"HisCode",hiscode,""))
	//If code'="" s sscode=$o(^DHCPHPCO(0,"Code",code,hiscode,""))
	s Exdesc=""
	If (sshiscode'="") 
	{
		s Exdesc=$p($g(^DHCPHPCO(sshiscode)),"^",2)  //描述
	 	Quit "{success:'false',info:'该记录已与"_Exdesc_"对照, 不能重复对照!'}"	
	}	
	/*s codeStr = ##class(web.DHCBL.KB.DHCPHProContrast).GetHisCode()
	s hcode = "<"_hiscode_">"
	if (codeStr[hcode) Quit "{success:'false',info:'该记录已对照, 请删除后再对照!'}"*/
	
	Ts
	s obj=##class(User.DHCPHProContrast).%New()
	s obj.PHPCCode = code
	s obj.PHPCDesc = desc
	s obj.PHPCHisCode = hiscode
	s obj.PHPCHisDesc = hisdesc
	s logJson="{PHPCCode:"_$c(34)_code_$c(34)_",PHPCDesc:"_$c(34)_desc_$c(34)_",PHPCHisCode:"_$c(34)_hiscode_$c(34)_",PHPCHisDesc:"_$c(34)_hisdesc_$c(34)_"}"
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHProContrast","User.DHCPHProContrast","商品名与His对照表",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("商品名与His对照表","web.DHCBL.KB.DHCPHProContrast","SaveData",logJson)
    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:谷雪萍
/// Description:根据id删除
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""

		Tstart
		s eobj = ##class(web.Entity.KB.DHCPHProContrast).%New()
		s pobj = ##class(User.DHCPHProContrast).%OpenId(id)
		s eobj.PHPCRowId = id
		s eobj.PHPCCode = pobj.PHPCCode
		s eobj.PHPCDesc = pobj.PHPCDesc
		s eobj.PHPCHisCode = pobj.PHPCHisCode
		s eobj.PHPCHisDesc = pobj.PHPCHisDesc
	
		s sc=##class(User.DHCPHProContrast).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHProContrast","User.DHCPHProContrast","商品名与His对照表",id,eobj.PHPCDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("商品名与His对照表","web.DHCBL.KB.DHCPHProContrast","DeleteData",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	q result
}

/// Description:医生站 PHC_DrgMast
/// Table：User.PHCDrgMast
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHSyndrome","GetDataForHis","","","")
Query GetDataForHis(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHCDRowId:%String,PHCDCode:%String,PHCDName:%String")
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
		s PHCDRowId=rowid
		s PHCDCode=$p($g(^PHCD(PHCDRowId,1)),"^",1)
		s PHCDName=$p($g(^PHCD(PHCDRowId,1)),"^",2)	
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s PHCDRowId=0
		for {
			s PHCDRowId=$o(^PHCD(PHCDRowId))
			q:PHCDRowId=""

			s PHCDCode=$p($g(^PHCD(PHCDRowId,1)),"^",1)
			s PHCDName=$p($g(^PHCD(PHCDRowId,1)),"^",2)
			continue:(PHCDCode="")&(PHCDName="")
			s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHCDName)
			if ($ZCONVERT(PHCDCode,"U")[code)&(($ZCONVERT(PHCDName,"U")[desc)||(PINYIN[desc))
			{
				d OutputRowCmb
			}
		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(PHCDRowId,PHCDCode,PHCDName)
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

/// 根据his商品名代码获取知识库商品名id
/// w ##class(web.DHCBL.KB.DHCPHProContrast).getProInfo("A00N001")
ClassMethod getProInfo(code As %String) As %String
{
	s str=""
	s PHPCRowId=$o(^DHCPHPCO(0,"HisCode",code,0))  //获取对照表id
	if (PHPCRowId'="")
	{
		s PHPCCode=$p($g(^DHCPHPCO(PHPCRowId)),"^",1)  //代码
		s PHPCCodeU=$ZCONVERT(PHPCCode,"U")
		s PHNRowId=$o(^DHCPHPNA(0,"Code",PHPCCodeU,0))  //商品名id
		s PHNDesc="",PHNFactory=""
		if (PHNRowId'="")
		{
			s PHNDesc=$p($g(^DHCPHPNA(PHNRowId)),"^",2)  //商品名描述
			s PHNFactory=$p($g(^DHCPHPNA(PHNRowId)),"^",6)  //厂家
		}
		s str=PHNRowId_"[N]"_PHNDesc_"[N]"_PHNFactory
	}
	q str
}

/// Creator:丁亚男
/// CreatDate: 2021-05-24
/// Description：自动对照
/// Return：匹配数据的数目
/// w ##class(web.DHCBL.KB.DHCPHProContrast).AutoContrastData()
ClassMethod AutoContrastData() As %String
{
	s count=0
	//遍历商品名字典表
	s PHNRowId=0
    for
    {
        s PHNRowId=$o(^DHCPHPNA(PHNRowId)) q:PHNRowId=""
        s PHNActiveFlag=$p($g(^DHCPHPNA(PHNRowId)),"^",3)  //是否可用
        continue:PHNActiveFlag="N"
        s PHNCode=$p($g(^DHCPHPNA(PHNRowId)),"^",1)  //代码
        s PHNDesc=$p($g(^DHCPHPNA(PHNRowId)),"^",2)
     	
        s RowId=0,Code=""	
		for
		{	
			s RowId=$o(^PHCD(0,"Name",$$ALPHAUP^SSUTIL4(PHNDesc),RowId)) q:RowId=""
			s Code=$p($g(^PHCD(RowId,1)),"^",1)
		}
		
		
       //保存对照
	 	if (Code'="")
	 	{
			s sshiscode=$o(^DHCPHPCO(0,"HisCode",Code,""))
			If (sshiscode="") 
			{
				
				Ts
				s obj=##class(User.DHCPHProContrast).%New()
				s obj.PHPCCode = PHNCode
				s obj.PHPCDesc = PHNDesc
				s obj.PHPCHisCode = Code
				s obj.PHPCHisDesc = PHNDesc
				s logJson="{PHPCCode:"_$c(34)_PHNCode_$c(34)_",PHPCDesc:"_$c(34)_PHNDesc_$c(34)_",PHPCHisCode:"_$c(34)_Code_$c(34)_",PHPCHisDesc:"_$c(34)_PHNDesc_$c(34)_"}"
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc){	
					Tc		
					s id = obj.%Id()
					s count=count+1
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHProContrast","User.DHCPHProContrast","商品名与His对照表",id,PHNDesc,"A",logJson)
				}else{
					Trollback
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("商品名与His对照表","web.DHCBL.KB.DHCPHProContrast","SaveData",logJson)
			    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}	
			 }
	 	} 
    }
 	
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

}
