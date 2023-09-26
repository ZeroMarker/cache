/// 名称:库存 4单位转换
/// 描述:单位转换，包含增删改查功能
/// 编写者：基础数据平台组 - 陈莹 
/// 编写日期:2012-9-11
Class web.DHCBL.CT.CTConFac Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter SQLTableName = "CT_ConFac";

/// Creator：陈莹
/// CreatDate: 2013-5-15
/// Description:查询 单位转换
/// Table:User.CTConFac
/// Input:rowid,FrUOMDR,ToUOMDR,Factor,Flag
/// Return:CTCFRowId,CTCFFrUOMDR,CTCFToUOMDR,CTCFFactor,CTCFActiveFlag
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTConFac","GetList","","","","","")
Query GetList(rowid As %String, FrUOMDR As %String, ToUOMDR As %String, Factor As %String, Flag As %String) As %Query(ROWSPEC = "CTCFRowId:%String,CTCFFrUOMDR:%String,CTCFToUOMDR:%String,CTCFFactor:%String,CTCFActiveFlag:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, FrUOMDR As %String, ToUOMDR As %String, Factor As %String, Flag As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s CTCFRowId=rowid	
		s CTUOMRowId1=$p($g(^CT("CTCF",CTCFRowId)),"^",1)
		if CTUOMRowId1'=""{
			s CTCFFrUOMDR=$p($g(^CT("UOM",CTUOMRowId1)),"^",2)
		}
		else
		{
			s CTCFFrUOMDR=""
		}
		s CTUOMRowId2=$p($g(^CT("CTCF",CTCFRowId)),"^",2)
		if CTUOMRowId2'=""
		{
			s CTCFToUOMDR=$p($g(^CT("UOM",CTUOMRowId2)),"^",2)
		}
		else
		{
			s CTCFToUOMDR=""
		}
		s CTCFFactor=$p($g(^CT("CTCF",CTCFRowId)),"^",3)
		s CTCFActiveFlag=$p($g(^CT("CTCF",CTCFRowId)),"^",4)
		d OutputRow
	}
	else
	{
		s CTCFRowId=0
		s AuStr=##class(web.DHCBL.Authorize.CTConFac).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s CTUOMAuStr=##class(web.DHCBL.Authorize.CTUOM).DHCGetDataByDefaultSession()
		s CTUOMAuFlag=0
		;未授权情况下，默认显示全部数据
		if (CTUOMAuStr="")||(CTUOMAuStr["limited:0") s CTUOMAuFlag=1
		for
		{
			s CTCFRowId=$o(^CT("CTCF",CTCFRowId)) q:CTCFRowId=""
			s CTUOMRowId1=$p($g(^CT("CTCF",CTCFRowId)),"^",1)
			s CTUOMRowId2=$p($g(^CT("CTCF",CTCFRowId)),"^",2)
			s CTUOMstrRowId1="{ID:"_CTUOMRowId1_"}"
			s CTUOMstrRowId2="{ID:"_CTUOMRowId2_"}"
			s strRowId="{ID:"_CTCFRowId_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((CTUOMAuStr[CTUOMstrRowId1)||(CTUOMAuFlag=1))&&((CTUOMAuStr[CTUOMstrRowId2)||(CTUOMAuFlag=1)) ;用来筛选授权数据
			{
				
				if CTUOMRowId1'=""{
					s CTCFFrUOMDR=$p($g(^CT("UOM",CTUOMRowId1)),"^",2)
				}
				else
				{
					s CTCFFrUOMDR=""
				}
				
				if CTUOMRowId2'=""
				{
					s CTCFToUOMDR=$p($g(^CT("UOM",CTUOMRowId2)),"^",2)
				}
				else
				{
					s CTCFToUOMDR=""
				}
				s CTCFFactor=$p($g(^CT("CTCF",CTCFRowId)),"^",3)
				s CTCFActiveFlag=$p($g(^CT("CTCF",CTCFRowId)),"^",4)
				i ((CTCFFrUOMDR[FrUOMDR)||(FrUOMDR=""))&((CTCFToUOMDR[ToUOMDR)||(ToUOMDR=""))&((CTCFFactor=Factor)||(Factor=""))&((CTCFActiveFlag=Flag)||(Flag=""))
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(CTCFRowId,CTCFFrUOMDR,CTCFToUOMDR,CTCFFactor,CTCFActiveFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2016-12-12
/// Description:数据重复验证方法,js调用
/// Table:User.CTConFac
/// Input:id, CTCFFrUOMDR,CTCFToUOMDR
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.CTConFac).FormValidate("","","")
ClassMethod FormValidate(id As %String, CTCFFrUOMDR As %String, CTCFToUOMDR As %String) As %String
{
	n (CTCFFrUOMDR,CTCFToUOMDR,id)
	s flag=0
	q:(CTCFFrUOMDR="")||(CTCFToUOMDR="") flag
	s idc=$o(^CT("CTCF",0,"UOM",CTCFFrUOMDR,CTCFToUOMDR,0))	
	if ((idc'=0)&(idc=id)) s flag=0
	else  s flag=1	
	q flag
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.CTConFac
/// Input:CTCFRowId
/// Return：Json格式的字符串(即：form表单中对应的数据项)
/// RetFlag=""或"Y"时，用于EXT, =JSON时，RetFlag="N"时用于HISUI，不输出 "{list:["_str_"]}"  //2019-12-24 钟荣枫
ClassMethod OpenData(CTCFRowId As %String, RetFlag As %String = "") As %String
{
	n (CTCFRowId,RetFlag)
    s str = ""
	s pobj = ##class(User.CTConFac).%OpenId(CTCFRowId)
	s eobj = ##class(web.Entity.CT.CTConFac).%New()
	s eobj.CTCFRowId = CTCFRowId
	if $IsObject(pobj.CTCFFrUOMDR){
		s eobj.CTCFFrUOMDR = pobj.CTCFFrUOMDR.%Id() 
		}
	if $IsObject(pobj.CTCFToUOMDR){
		s eobj.CTCFToUOMDR = pobj.CTCFToUOMDR.%Id() 
		}		
	s eobj.CTCFFactor = pobj.CTCFFactor 
	s:pobj.CTCFActiveFlag="Y" eobj.CTCFActiveFlag="true" //checkbox
	//s eobj.CTCFActiveFlag = pobj.CTCFActiveFlag  //radio
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	if (RetFlag="")||(RetFlag="Y")
	{
		s str = "{list:["_str_"]}"
	}
	q str
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：保存 单位转换 ，对应form中的保存按钮
/// Table：User.CTConFac
/// Return:成功返回true，失败返回false
ClassMethod SaveEntity(eobj As web.Entity.CT.CTConFac) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.CTCFActiveFlag="" eobj.CTCFActiveFlag="N"
		s validateflag=##class(web.DHCBL.CT.CTConFac).FormValidate(eobj.CTCFRowId,eobj.CTCFFrUOMDR,eobj.CTCFToUOMDR)
		if (validateflag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.CTCFRowId="")
			{	
				s obj=##class(User.CTConFac).%New()
			}
			else
			{
				s obj=##class(User.CTConFac).%OpenId(eobj.CTCFRowId)
				s bobj=##class(web.Entity.CT.CTConFac).%New()
				s bobj.CTCFRowId = eobj.CTCFRowId
				if $IsObject(obj.CTCFFrUOMDR){
					s bobj.CTCFFrUOMDR = obj.CTCFFrUOMDR.%Id() 
				}
				if $IsObject(obj.CTCFToUOMDR){
					s bobj.CTCFToUOMDR = obj.CTCFToUOMDR.%Id() 
				}
				s bobj.CTCFFactor = obj.CTCFFactor 
				s bobj.CTCFActiveFlag=obj.CTCFActiveFlag
				
			}
			s obj.CTCFActiveFlag = eobj.CTCFActiveFlag                     
			s obj.CTCFFactor = eobj.CTCFFactor     
			d obj.CTCFFrUOMDRSetObjectId(eobj.CTCFFrUOMDR)               	 
			d obj.CTCFToUOMDRSetObjectId(eobj.CTCFToUOMDR) 

			s CTUOMDesc=$p($g(^CT("UOM",eobj.CTCFFrUOMDR)),"^",2) //码表日志里描述取"从单位"的Desc

			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"
				d:eobj.CTCFRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_ConFac","User.CTConFac","单位转换",id,CTUOMDesc,"A",eobj)
				d:eobj.CTCFRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_ConFac","User.CTConFac","单位转换",id,CTUOMDesc,"U",eobj,bobj)
			}else{
				Trollback
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("单位转换","web.DHCBL.CT.CTConFac","SaveEntity",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：根据id删除 单位转换
/// Table：User.CTConFac
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
ClassMethod DeleteData(id) As %String
{
	n (id,%session)
	s result=""
	s pobj = ##class(User.CTConFac).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTConFac).%New()
	s eobj.CTCFRowId = id
	if $IsObject(pobj.CTCFFrUOMDR){
		s eobj.CTCFFrUOMDR = pobj.CTCFFrUOMDR.%Id() 
		}
	if $IsObject(pobj.CTCFToUOMDR){
		s eobj.CTCFToUOMDR = pobj.CTCFToUOMDR.%Id() 
		}		
	s eobj.CTCFFactor = pobj.CTCFFactor 
	//s:pobj.CTCFActiveFlag="Y" eobj.CTCFActiveFlag="true" //checkbox
	s eobj.CTCFActiveFlag = pobj.CTCFActiveFlag  //radio
	s CTUOMDesc=$p($g(^CT("UOM",eobj.CTCFFrUOMDR)),"^",2) //码表日志里描述取"从单位"的Desc
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.CTConFac).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_ConFac","User.CTConFac","单位转换",id,CTUOMDesc,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("单位转换","web.DHCBL.CT.CTConFac","DeleteData",eobj)
    	s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

}
