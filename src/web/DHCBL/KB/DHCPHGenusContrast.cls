Class web.DHCBL.KB.DHCPHGenusContrast Extends %RegisteredObject
{

/// Creator：谷雪萍
/// CreatDate: 2017-04-10
/// Description：查询已对照内容（2018-08-07判断id是否为空---石萧伟）
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHGenusContrast","GetList","","","","","")
Query GetList(id) As %Query(ROWSPEC = "PHGRowId,PHGGenusCode,PHGGenusDesc,PHGHisGenusCode,PHGHisGenusDesc")
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
		s code=$p($g(^DHCPHBTGE(id)),"^",1)
    	s desc=$p($g(^DHCPHBTGE(id)),"^",2)
        
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s PHGRowId=0
		for  
		{	
			s PHGRowId=$o(^DHCPHGENUSCON(PHGRowId)) q:PHGRowId="" 
			//s strRowId = "{ID:"_PHGRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s PHGGenusCode=$p($g(^DHCPHGENUSCON(PHGRowId)),"^",1)  //代码
				s PHGGenusCodeU=$ZCONVERT(PHGGenusCode,"U")
				s PHGGenusDesc=$p($g(^DHCPHGENUSCON(PHGRowId)),"^",2)  //描述
				s PHGGenusDescU=$ZCONVERT(PHGGenusDesc,"U")
				s PHGHisGenusCode=$p($g(^DHCPHGENUSCON(PHGRowId)),"^",3)  //his代码
				s PHGHisGenusDesc=$p($g(^DHCPHGENUSCON(PHGRowId)),"^",4)  //his描述
		
				i (PHGGenusCodeU[code)&(PHGGenusDescU[desc)   //条件
				{
					d OutputRow
				}		
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHGRowId,PHGGenusCode,PHGGenusDesc,PHGHisGenusCode,PHGHisGenusDesc)
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
/// CreatDate: 2017-04-10
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCPHGenusContrast).SaveData("8^9")
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCPHBTGE(rowid)),"^",1)
	s desc=$p($g(^DHCPHBTGE(rowid)),"^",2)
	s hiscode=$listget($g(^dbo.BTGenusD(hisrowid)),2)
	s hisdesc=$listget($g(^dbo.BTGenusD(hisrowid)),3)
	
	
	If hiscode'="" s sshiscode=$o(^DHCPHGENUSCON(0,"HisCode",hiscode,""))
	s Exdesc=""
	If (sshiscode'="") 
	{
		s Exdesc=$p($g(^DHCPHGENUSCON(sshiscode)),"^",2)  //描述
	 	Quit "{success:'false',info:'该记录已与"_Exdesc_"对照, 不能重复对照!'}"	
	}	
	
	Ts
	s obj=##class(User.DHCPHGenusContrast).%New()
	s obj.PHGGenusCode = code
	s obj.PHGGenusDesc = desc
	s obj.PHGHisGenusCode = hiscode
	s obj.PHGHisGenusDesc = hisdesc
	s logJson="{PHGGenusCode:"_$c(34)_code_$c(34)_",PHGGenusDesc:"_$c(34)_desc_$c(34)_",PHGHisGenusCode:"_$c(34)_hiscode_$c(34)_",PHGHisGenusDesc:"_$c(34)_hisdesc_$c(34)_"}"
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHGenusContrast","User.DHCPHGenusContrast","菌属对照表",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("菌属对照表","web.DHCBL.KB.DHCPHGenusContrast","SaveData",logJson)
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
		s eobj = ##class(web.Entity.KB.DHCPHGenusContrast).%New()
		s pobj = ##class(User.DHCPHGenusContrast).%OpenId(id)
		s eobj.PHGRowId = id
		s eobj.PHGGenusCode = pobj.PHGGenusCode
		s eobj.PHGGenusDesc = pobj.PHGGenusDesc
		s eobj.PHGHisGenusCode = pobj.PHGHisGenusCode
		s eobj.PHGHisGenusDesc = pobj.PHGHisGenusDesc
	
		s sc=##class(User.DHCPHGenusContrast).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHGenusContrast","User.DHCPHGenusContrast","菌属对照表",id,eobj.PHGGenusDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("菌属对照表","web.DHCBL.KB.DHCPHGenusContrast","DeleteData",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	q result
}

/// Creator：谷雪萍
/// CreatDate: 2017-04-10
/// Description：查询对照dbo.BT_Genus表内容
/// Table：dbo.BT_Genus
/// Input：rowid, desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHBtGenus","GetHisList","","","")
Query GetHisList(rowid, desc) As %Query(ROWSPEC = "RowID,Code,CName")
{
}

ClassMethod GetHisListExecute(ByRef qHandle As %Binary, rowid, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid 
		s Code=$listget($g(^dbo.BTGenusD(RowID)),2)  //代码
		s CName=$listget($g(^dbo.BTGenusD(RowID)),3)  //描述
		d OutputRowHis
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s RowID=0
		for  
		{	
			s RowID=$o(^dbo.BTGenusD(RowID)) q:RowID="" 

			s Code=$listget($g(^dbo.BTGenusD(RowID)),2)  //代码
			s CName=$listget($g(^dbo.BTGenusD(RowID)),3)  //描述
			s CNameU=$ZCONVERT(CName,"U")
			s PINYIN=""
			s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CNameU)
			i (CNameU[desc)||(PINYIN[desc)   //条件
			{
				d OutputRowHis
			}		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowHis
    set Data=$lb(RowID,Code,CName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetHisListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHisListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHisListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHisListExecute ]
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
/// w ##class(web.DHCBL.KB.DHCPHGenusContrast).AutoContrastData()
ClassMethod AutoContrastData() As %String
{
	s count=0
	//遍历HIS菌属字典表(因为HIS菌属表没有名称索引)
	s HISRowID=0
	for  
	{	
		s HISRowID=$o(^dbo.BTGenusD(HISRowID)) q:HISRowID="" 
		s Code=$listget($g(^dbo.BTGenusD(HISRowID)),2)  //代码
		s CName=$listget($g(^dbo.BTGenusD(HISRowID)),3)  //描述
		
     	//在临床知识库的菌属字典表查找同名菌属
        s RowId=0,BTGECode=""	
		for
		{	
			s RowId=$o(^DHCPHBTGEi(0,"Desc",$ZCONVERT(CName,"U"),RowId)) q:RowId=""
			s BTGEActiveFlag=$p($g(^DHCPHBTGE(RowId)),"^",3)  //是否可用
            continue:BTGEActiveFlag="N"
            s BTGECode=$p($g(^DHCPHBTGE(RowId)),"^",1)  //代码
		}
		
       //保存对照
	 	if (BTGECode'="")
	 	{
			s sshiscode=$o(^DHCPHGENUSCON(0,"HisCode",Code,""))
			If (sshiscode="") 
			{
				
				Ts
				s obj=##class(User.DHCPHGenusContrast).%New()
				s obj.PHGGenusCode = BTGECode
				s obj.PHGGenusDesc = CName
				s obj.PHGHisGenusCode = Code
				s obj.PHGHisGenusDesc = CName
				s logJson="{PHGGenusCode:"_$c(34)_BTGECode_$c(34)_",PHGGenusDesc:"_$c(34)_CName_$c(34)_",PHGHisGenusCode:"_$c(34)_Code_$c(34)_",PHGHisGenusDesc:"_$c(34)_CName_$c(34)_"}"
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc){	
					Tc		
					s id = obj.%Id()
					s count=count+1
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHGenusContrast","User.DHCPHGenusContrast","菌属对照表",id,CName,"A",logJson)
				}else{
					Trollback
					
					s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("菌属对照表","web.DHCBL.KB.DHCPHGenusContrast","SaveData",logJson)
			        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}		
			 }
	 	} 
    }
 	
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

}
