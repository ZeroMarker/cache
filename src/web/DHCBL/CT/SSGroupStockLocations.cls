Import SQLUser

/// 名称:系统管理  - 安全组子表 库存授权
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 -陈莹
/// 编写日期:2013-5-4
Class web.DHCBL.CT.SSGroupStockLocations Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-05-06
/// Description:查询 库存授权
/// Table:User.web.DHCBL.CT.SSGroupStockLocations
/// Input:ssgrprowid(父表SSGroup的id),strowid
/// Return:STParRef,STRowId,STCTLOCDR
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSGroupStockLocations","GetList","2","","1")
Query GetList(ssgrprowid As %String, rowid As %String, ctloc As %String, hospid As %String) As %Query(ROWSPEC = "STParRef:%String,STRowId:%String,STCTLOCDR:%String,STActiveFlag:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ssgrprowid As %String, rowid As %String, ctloc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s SSGRPRowId=$p(rowid,"||",1)
		s STChildsub=$p(rowid,"||",2)
		s STRowId=rowid
		s STParRef=SSGRPRowId
		s CTLOCDR=$p($g(^SSU("SSGRP",SSGRPRowId,"ST",STChildsub)),"^",1)
		s STActiveFlag=$p($g(^SSU("SSGRP",SSGRPRowId,"ST",STChildsub)),"^",2)
		s:STActiveFlag="" STActiveFlag="Y"
		i CTLOCDR'="" {
			s STCTLOCDR=$p($g(^CTLOC(CTLOCDR)),"^",2)
		}
		else {
			s STCTLOCDR=""
		}
		d OutputRow
	}
	else
	{
		if (ssgrprowid)
		{
		s SSGRPRowId=ssgrprowid,STChildsub=0
		for
		{
			s STChildsub=$o(^SSU("SSGRP",SSGRPRowId,"ST",STChildsub)) q:STChildsub=""
			s STRowId=SSGRPRowId_"||"_STChildsub
			s STParRef=ssgrprowid
			s CTLOCDR=$p($g(^SSU("SSGRP",SSGRPRowId,"ST",STChildsub)),"^",1)
			s STActiveFlag=$p($g(^SSU("SSGRP",SSGRPRowId,"ST",STChildsub)),"^",2)
			s:STActiveFlag="" STActiveFlag="Y"
			i CTLOCDR'="" 
			{
				if hospid'=""
				{
					//s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc",CTLOCDR,hospid)
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlagSpecial("CT_Loc",CTLOCDR,hospid,"","SS_Group")  //根据医院过滤
			
					continue:showflag="N"
				}
				s STCTLOCDR=$p($g(^CTLOC(CTLOCDR)),"^",2)
			}
			else {
				s STCTLOCDR=""
			}
			i (STChildsub>0)&((CTLOCDR=ctloc)||(ctloc="")) 
			{
				d OutputRow
			}
		}
		}
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(STParRef,STRowId,STCTLOCDR,STActiveFlag)
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
/// CreatDate:2013-7-15
/// Description:双击修改时,从后台取数据
/// Table:User.SSGroupStockLocations
/// Input:id
/// Return:Json格式的字符串str={list:[STParRef,STRowId,STCTLOCDR]}
/// Other:w ##class(web.DHCBL.CT.SSGroupStockLocations).OpenData("1||7")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.SSGroupStockLocations).%OpenId(id)
	s eobj = ##class(web.Entity.CT.SSGroupStockLocations).%New()
	s eobj.STRowId = id
	s eobj.STParRef = $p(id,"||",1)
	if $IsObject(pobj.STCTLOCDR){
		s eobj.STCTLOCDR = pobj.STCTLOCDR.%Id() 
		}
	s eobj.STActiveFlag = pobj.STActiveFlag
	s:eobj.STActiveFlag="" eobj.STActiveFlag="true"
	s:eobj.STActiveFlag="Y" eobj.STActiveFlag="true"
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// 用作调试增改功能
ClassMethod SaveTest()
{
	;d ##class(web.DHCBL.CT.SSGroupStockLocations).SaveTest()
	s eobj = ##class(web.Entity.CT.SSGroupStockLocations).%New()
	s eobj.STRowId="12||1"
	s eobj.STParRef="13"
	s eobj.STCTLOCDR="3"
	w ..SaveEntity(eobj)
}

/// Creator:陈莹
/// CreatDate:2012-9-20
/// Description:增加/修改 库存授权
/// Table:User.SSGroupStockLocations
/// Input:web.Entity.CT.SSGroupStockLocations
/// Return:成功返回success:'true'和id;失败返回success:'false'和errorinfo
ClassMethod SaveEntity(eobj As web.Entity.CT.SSGroupStockLocations) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.STActiveFlag="" eobj.STActiveFlag="N"
		if eobj.STParRef="" s eobj.STParRef=$p(eobj.STRowId,"||",1)
		if eobj.STParRef="" q "{success:'false',errorinfo:'父表指针不能为空！'}"
		s flag=##class(web.DHCBL.CT.SSGroupStockLocations).FormValidate(eobj.STParRef,eobj.STRowId,eobj.STCTLOCDR)
		if (flag=1) 
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
			
		}
			
		//如果RowId未赋值则增加
		if (eobj.STRowId="")
		{
			s obj = ##class(User.SSGroupStockLocations).%New(eobj.STParRef)
		}
		//如果RowId已赋值则修改
		else           
		{
			s obj = ##class(User.SSGroupStockLocations).%OpenId(eobj.STRowId)	
		
			s bobj = ##class(web.Entity.CT.SSGroupStockLocations).%New()
			s bobj.STRowId=eobj.STRowId
			s bobj.STParRef=$p(eobj.STRowId,"||",1)
			if $IsObject(obj.STCTLOCDR){
				s bobj.STCTLOCDR = obj.STCTLOCDR.%Id() 
			}
			s bobj.STActiveFlag = obj.STActiveFlag	
			
		}
		
		d obj.STParRefSetObjectId(eobj.STParRef) 
		d obj.STCTLOCDRSetObjectId(eobj.STCTLOCDR)
		s obj.STActiveFlag = eobj.STActiveFlag
		
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s SSGRPDesc=$p($g(^SSU("SSGRP",eobj.STParRef)),"^",1)
			s CTLOCDesc=$p($g(^CTLOC(eobj.STCTLOCDR)),"^",2)
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.STRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupStockLocations","User.SSGroupStockLocations","安全组-库存授权",id,SSGRPDesc_"->"_CTLOCDesc,"A",eobj)
			d:eobj.STRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupStockLocations","User.SSGroupStockLocations","安全组-库存授权",id,SSGRPDesc_"->"_CTLOCDesc,"U",eobj,bobj)
		}else{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组-库存授权","web.DHCBL.CT.SSGroupStockLocations","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：陈莹
/// CreatDate: 2012-12-5
/// Description：根据id删除 库存授权
/// Table：User.SSGroup
/// Input：id 
/// Return：成功返回true和info，失败返回false和info
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s pobj = ##class(User.SSGroupStockLocations).%OpenId(id)
	s eobj = ##class(web.Entity.CT.SSGroupStockLocations).%New()
	s eobj.STRowId = id
	s eobj.STParRef = $p(id,"||",1)
	if $IsObject(pobj.STCTLOCDR){
		s eobj.STCTLOCDR = pobj.STCTLOCDR.%Id() 
	}
	s eobj.STActiveFlag = pobj.STActiveFlag
	s SSGRPDesc=$p($g(^SSU("SSGRP",eobj.STParRef)),"^",1)
	s CTLOCDesc=""
	s:eobj.STCTLOCDR'="" CTLOCDesc=$p($g(^CTLOC(eobj.STCTLOCDR)),"^",2)
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.SSGroupStockLocations).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupStockLocations","User.SSGroupStockLocations","安全组-库存授权",id,SSGRPDesc_"->"_CTLOCDesc,"D",eobj)
	}
	else{
		Trollback
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组-库存授权","web.DHCBL.CT.SSGroupStockLocations","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// CheckedFlag=1 checked：true
/// w ##class(web.DHCBL.CT.SSGroupStockLocations).GetCheckedFlag("3","2")
ClassMethod GetCheckedFlag(LocId As %String, mySSGRPRowId As %String) As %String
{
	s SSGRPRowId=0,CheckedFlag=0
	for
	{
		s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
		s STChildsub=0
		for
		{	
			s STChildsub=$o(^SSU("SSGRP",SSGRPRowId,"ST",STChildsub)) q:(STChildsub="")||(CheckedFlag=1)
			s STRowId=SSGRPRowId_"||"_STChildsub
			s STParRef=SSGRPRowId
			s CTLOCDR=$p($g(^SSU("SSGRP",SSGRPRowId,"ST",STChildsub)),"^",1)
			s STActiveFlag=$p($g(^SSU("SSGRP",SSGRPRowId,"ST",STChildsub)),"^",2)
			if (CTLOCDR=LocId)&(STChildsub>0)&(mySSGRPRowId=STParRef)&(STActiveFlag'="N") {
				s CheckedFlag=1 //CheckedFlag=1 已存在，所以checked：true	
			}
		}
	}
	q CheckedFlag
}

/// 获取科室/病区-库存授权 安全组的Json串
/// LocId:科室/病区ID
/// w ##class(web.DHCBL.CT.SSGroupStockLocations).GetTreeJson("","3","")
ClassMethod GetTreeJson(ParentID As %String, LocId As %String, FilterCK, hospid As %String = "") As %String
{
	if (LocId="") s LocId="1" 
	//输出菜单JSON串
	
	s myJsonStr=""
	//获取授权Json
	s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	s AuStr=##class(web.DHCBL.Authorize.SSGroup).DHCGetDataByDefaultSession()
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	s mySSGRPRowId=0
	for
	{
		s mySSGRPRowId=$o(^SSU("SSGRP",mySSGRPRowId)) q:mySSGRPRowId=""
		if hospid'=""
		{
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_Group",mySSGRPRowId,hospid)
			continue:showflag="N"
		}
	    else
		{
			///新增医院级授权限制，2015-1-20
			s strHospRowId="",AuHospFlag=0 
			if (AuHospStr'="off")
			{
				s HOSPChildsub=0
				for
				{
					s HOSPChildsub=$o(^SSU("SSGRP",mySSGRPRowId,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")||(AuHospFlag=1)
					s CTHospitalDR=$g(^SSU("SSGRP",mySSGRPRowId,"HOSP",HOSPChildsub))
					s strHospRowId="{ID:"_CTHospitalDR_"}"
					if (AuHospStr[strHospRowId) s AuHospFlag=1
				}
			}
			if '((AuHospFlag=1)||(AuHospStr=1)||(AuHospStr="off")) continue
		}
		//过滤已选、未选
		s CheckedFlag=0
		s CheckedFlag=##class(web.DHCBL.CT.SSGroupStockLocations).GetCheckedFlag(LocId,mySSGRPRowId)
		if (FilterCK="checked") {
			if (CheckedFlag) {}
			else {
				continue
			}
		}
		elseif (FilterCK="unchecked") {
			if (CheckedFlag) {
				continue
			}
		}
		
		//筛选授权后的数据
		s strRowId="{ID:"_mySSGRPRowId_"}"
		if ((AuStr[strRowId)||(AuFlag=1))
		{
		
			s myGroupObj=##Class(User.SSGroup).%OpenId(mySSGRPRowId)
			if $IsObject(myGroupObj) {
				s myGroupDesc = myGroupObj.SSGRPDesc
				s myGroupDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(myGroupDesc)
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s mid=LocId_"^"_mySSGRPRowId
				s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myGroupDesc_""","
				
				if (CheckedFlag) s myJsonStr=myJsonStr_"""checked"":true,"	
				else  s myJsonStr=myJsonStr_"""checked"":false,"

				s myJsonStr=myJsonStr_"""leaf"":true"

				s myJsonStr=myJsonStr_"}"
			
				d myGroupObj.%Close()
			}
		}
		
	}

	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// Description:保存新增树节点
/// Return:成功返回success:'true'和id;失败返回success:'false'和errorinfo
ClassMethod SaveTreePanel(STCTLOCDR As %String, STParRef As %String) As %String
{
	s result=""
	s flag=0	
	s myobj=##class(%Dictionary.CompiledProperty).%OpenId("User.SSGroupStockLocations||STActiveFlag")
	i ($IsObject(myobj))
	{		
		s STChildsub=0
		for
		{
			s STChildsub=$o(^SSU("SSGRP",STParRef,"ST",STChildsub)) q:(flag=1)||(STChildsub="")
			s STRowId=STParRef_"||"_STChildsub
			s CTLOCDR=$p($g(^SSU("SSGRP",STParRef,"ST",STChildsub)),"^",1)
			i (STChildsub>0)&(CTLOCDR=STCTLOCDR)
			{
				s flag=1
				s sobj = ##class(web.Entity.CT.SSGroupStockLocations).%New()
				s sobj.STRowId=STRowId
				s sobj.STCTLOCDR=STCTLOCDR
				s sobj.STParRef=STParRef
				s sobj.STActiveFlag="Y"
				s result= ##class(web.DHCBL.CT.SSGroupStockLocations).SaveEntity(sobj)
			}
		}
		
		if (flag=0)
		{
			s sobj = ##class(web.Entity.CT.SSGroupStockLocations).%New()
			s sobj.STRowId=""
			s sobj.STCTLOCDR=STCTLOCDR
			s sobj.STParRef=STParRef
			s sobj.STActiveFlag="Y"
			s result= ##class(web.DHCBL.CT.SSGroupStockLocations).SaveEntity(sobj)
			
			
		}
	}
	else
	{
		s sobj = ##class(web.Entity.CT.SSGroupStockLocations).%New()
		s sobj.STRowId=""
		s sobj.STCTLOCDR=STCTLOCDR
		s sobj.STParRef=STParRef
		s result= ##class(web.DHCBL.CT.SSGroupStockLocations).SaveEntity(sobj)
		
	}
	q result
}

/// Description：删除树节点->改成只是取消激活
/// w ##class(web.DHCBL.CT.SSGroupStockLocations).DeleteTreePanel("1","1")
ClassMethod DeleteTreePanel(STCTLOCDR As %String, STParRef As %String) As %String
{
	s result=""
	s flag=0	
	s STChildsub=0
	for
	{
		s STChildsub=$o(^SSU("SSGRP",STParRef,"ST",STChildsub)) q:(flag=1)||(STChildsub="")
		s STRowId=STParRef_"||"_STChildsub
		s CTLOCDR=$p($g(^SSU("SSGRP",STParRef,"ST",STChildsub)),"^",1)
		i (STChildsub>0)&(CTLOCDR=STCTLOCDR)
		{
			s flag=1
			s myobj=##class(%Dictionary.CompiledProperty).%OpenId("User.SSGroupStockLocations||STActiveFlag")
			i ($IsObject(myobj))
			{
				s sobj = ##class(web.Entity.CT.SSGroupStockLocations).%New()
				s sobj.STRowId=STRowId
				s sobj.STCTLOCDR=STCTLOCDR
				s sobj.STParRef=STParRef
				s sobj.STActiveFlag="N"
				s result= ##class(web.DHCBL.CT.SSGroupStockLocations).SaveEntity(sobj)
			}
			else
			{
				s result= ##class(web.DHCBL.CT.SSGroupStockLocations).DeleteData(STRowId)
			}
		}
	}
	q result
}

/*
/// Creator:陈莹
/// CreatDate:2013-2-22
/// Description:为combobox查询取数据(科室)STCTLOCDR->CT_LOC
/// Table:User.CTLOC
/// Input:code,desc
/// Return:CTLOCRowId,CTLOCCode,CTLOCDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSGroupStockLocations","GetCTLOCDR","","","")
Query GetCTLOCDR(cthospital As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTLOCRowId:%String,CTLOCCode:%String,CTLOCDesc:%String")
{
}

ClassMethod GetCTLOCDRExecute(ByRef qHandle As %Binary, cthospital As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s CTLOCRowId=0
	for
	{
		s CTLOCRowId=$o(^CTLOC(CTLOCRowId)) q:CTLOCRowId=""
		s CTLOCCode=$p($g(^CTLOC(CTLOCRowId)),"^",1)
		s CTLOCDesc=$p($g(^CTLOC(CTLOCRowId)),"^",2)
		s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowId)),"^",22)
		s CTLOCCode1=$ZCONVERT(CTLOCCode,"U")
		s CTLOCDesc1=$ZCONVERT(CTLOCDesc,"U")
		i (CTLOCCode1[code)&(CTLOCDesc1[desc)&((CTLOCHospitalDR=cthospital)||(cthospital=""))
		{
			d OutputRowCTLOC
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCTLOC
    set Data=$lb(CTLOCRowId,CTLOCCode,CTLOCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetCTLOCDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTLOCDRExecute ]
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

ClassMethod GetCTLOCDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTLOCDRExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

///    CTHospitalDR->CT_Hospital  先不取医院,web.DHCBL.CT.CTHospital,GetDataForCmb1
*/
/// 描述：获取安全组-库存授权-批量授权 科室的Json串，提供给树
/// 编写者：基础数据平台-李可凡
/// 日期：2020年4月13日
/// 表：CT_Loc
/// 入参：groupid:安全组RowId	 FilterCK:是否勾选, hospid 医院id,根据医院过滤科室
/// 出参：Json串，包含安全组id，科室id，科室描述，是否勾选，例如{"id":"248^1","text":"静脉药物配置中心","checked":true,"leaf":true}
/// w ##class(web.DHCBL.CT.SSGroupStockLocations).GetTreeJsonForGRP("","")
ClassMethod GetTreeJsonForGRP(groupid As %String, FilterCK As %String, hospid As %String = "") As %String
{
	if (groupid="") q ""
	s myJsonStr=""
	s AuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
    s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
    s BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
	s AuRBCDepartmentGroupStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
    s AuCTHospitalStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
    
    
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    s AuRBCDepartmentGroupFlag=0
    if (AuRBCDepartmentGroupStr="")||(AuRBCDepartmentGroupStr["limited:0") s AuRBCDepartmentGroupFlag=1
    s AuCTHospitalFlag=0
    if (AuCTHospitalStr="")||(AuCTHospitalStr["limited:0") s AuCTHospitalFlag=1
    
	s CTLOCRowID=0
	for
	{
		s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
		s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
        s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)      //科室部分组
        s strRowId = "{ID:"_CTLOCRowID_"}"
        s strCTLOCDepDR = "{ID:"_CTLOCDepDR_"}"
        s strHospitalID = "{ID:"_CTLOCHospitalDR_"}" 
		if (hospid'="")
		{
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlagSpecial("CT_Loc",CTLOCRowID,hospid,"","SS_Group")  //根据医院过滤
			continue:showflag="N"
		}
		else
		{
			if '((AuHospStr="off")||(AuHospStr[strHospitalID)||(AuHospStr=1)) continue   ;医院级授权
		}
		
        i ((AuStr[strRowId)||(AuFlag=1))&&((AuRBCDepartmentGroupStr[strCTLOCDepDR)||(AuRBCDepartmentGroupFlag=1))&&((AuCTHospitalStr[strHospitalID)||(AuCTHospitalFlag=1))
        {
	        s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)
            S CTLOCType=$p($g(^CTLOC(CTLOCRowID)),"^",13)
            s CTLOCContactName=$p($g(^CTLOC(CTLOCRowID)),"^",43)   //科室检索码
            s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //截止日期
            continue:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
          
			//过滤已选、未选
			s CheckedFlag=0
			s CheckedFlag=##class(web.DHCBL.CT.SSGroupStockLocations).GetCheckedFlag(CTLOCRowID,groupid)
			if (FilterCK="checked") //如果为checked，只显示勾选的数据
			{	
				if (CheckedFlag) 
				{
					
				}
				else 
				{
					continue
				}
			}
			elseif (FilterCK="unchecked") //如果为checked，只显示未勾选的数据
			{	
				if (CheckedFlag) 
				{
					continue
				}
			}
			
			s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)
			
			if (CTLOCHospitalDR'="")&(BDPHospAutflag="Y")
	        {
	            s HOSPDesc=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",2)   //开了医院级授权，科室后面显示医院信息
	            s HOSPShortName=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",39)   //简称
	            if HOSPShortName'="" s CTLOCDesc=CTLOCDesc_"【"_HOSPShortName_"】"
	            else  s CTLOCDesc=CTLOCDesc_"【"_HOSPDesc_"】"
	        }
	        s CTLOCDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(CTLOCDesc)
			s:(myJsonStr'="") myJsonStr=myJsonStr_","
			s myJsonStr=myJsonStr_"{"
			s mid=CTLOCRowID_"^"_groupid
			s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_CTLOCDesc_""","
			if (CheckedFlag) s myJsonStr=myJsonStr_"""checked"":true,"	//根据CheckedFlag判断树的节点是否被勾选
			else  s myJsonStr=myJsonStr_"""checked"":false,"
			s myJsonStr=myJsonStr_"""leaf"":true"
			s myJsonStr=myJsonStr_"}"
		}
	}
	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// Creator：陈莹
/// CreatDate: 2020-07-29
/// Description：修改 项目上自己导入过科室数据后，在前台维护时报failed unique check的报错
/// Table：User.SSGroupStockLocations
/// flag=0时 查看错误数据，flag=1时处理错误数据
/// d ##class(web.DHCBL.CT.SSGroupStockLocations).RepairError(0) 
/// d ##class(web.DHCBL.CT.SSGroupStockLocations).RepairError(0) 
ClassMethod RepairError(flag) As %String
{
	
	k ^TMPERRORRECLOC("ST")
	s SSGRPRowId=0
	for
	{
		s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
		s ChildSub=$g(^SSU("SSGRP",SSGRPRowId,"ST",0))
		s realsub=$o(^SSU("SSGRP",SSGRPRowId,"ST",""),-1)
		if ((realsub'="")&&(ChildSub=""))||((realsub'="")&&(realsub>ChildSub)&&(ChildSub'="")) 
		{
			if (flag=0) s ^TMPERRORRECLOC("ST",SSGRPRowId)=ChildSub_"  "_realsub
			if (flag=1) s ^SSU("SSGRP",SSGRPRowId,"ST",0)=realsub
		}
	}
	if (flag=0) zw ^TMPERRORRECLOC("ST")
	q ""
}

/// Creator：基础数据平台组 chenying
/// CreatDate: 2020-08-12
/// Description：数据重复校验
/// Table：User.SSGroupStockLocations
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.DHCBL.CT.SSGroupStockLocations).FormValidate("","","")
ClassMethod FormValidate(parref As %String, id As %String, ctloc As %String) As %String
{
	if parref="" s parref=$p(id,"||",1)
	q:parref="" 0
	q:ctloc="" 0
	
	s flag=0
	s SSGRPRowId=parref
	s STChildsub=0
	for
	{
		s STChildsub=$o(^SSU("SSGRP",SSGRPRowId,"ST",STChildsub)) q:STChildsub=""
		s STRowId=SSGRPRowId_"||"_STChildsub
		s STCTLOCDR=$p($g(^SSU("SSGRP",SSGRPRowId,"ST",STChildsub)),"^",1)
		i (ctloc=STCTLOCDR)&&((id="")||((id'="")&&(id'=STRowId)))
		{
			s flag=1 //flag=1 有重复
		}
	}
	q flag
}

}
