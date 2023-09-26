/// 名称: 表登记授权
/// 编写者：xy
/// 编写日期: 2021-08-02
Class web.DHCPE.CT.PowerTable Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 插入表登记授权表
/// Table：表登记授权管理表 User.DHCPEPowerTableList 
/// Input: TabCode 表名, TabDesc 中文名, PowerType 公/私/管控类型 
/// Return：
/// Creator：xy 
/// CreatDate：20210802
/// debug: w ##class(web.DHCPE.CT.PowerTable).InsertPowerTable("DHC_PE_NewMessageTemplet","短信模板字段表","A","User.DHCPENewMessageTemplet ",""))
ClassMethod InsertPowerTable(TabCode As %String, TabDesc As %String, PowerType As %String, ClsCode As %String, ParCode As %String = "")
{
	s ^tempdhcpe("InsertPowerTable")=$lb(TabCode,TabDesc,PowerType,ClsCode,ParCode)
	new (TabCode,TabDesc,PowerType,ClsCode,ParCode)
	s result=1
    
    s obj=##class(User.DHCPEPowerTableList).%New()
    s obj.PTTabCode=TabCode
    s obj.PTTabDesc=TabDesc
    s obj.PTPowerType=PowerType
    s obj.PTClsCode=ClsCode
    s obj.PTParCode=ParCode
    Ts
    s sc=obj.%Save()
    d obj.%Close()
    If $$$ISOK(sc) 
    {   
    	Tc
    	s id=obj.%Id()
    	s result=id_"^添加成功"
    }
    else
    {
     	Trollback
     	s result="-1^添加失败"
    }
    q result
}

/// Description: 更新表登记授权表
/// Table：表登记授权管理表 User.DHCPEPowerTableList  
/// Input: PTLRowid 数据ID, STabCode 表名, TabDesc 中文名, PowerType 公/私/管控类型 
/// Return：
/// Creator：xy 
/// CreatDate：20210802
/// debug: w ##class(web.DHCPE.CT.PowerTable).UpdatePowerTable()
ClassMethod UpdatePowerTable(PTLRowid As %String, TabCode As %String, TabDesc As %String, PowerType As %String, ClsCode As %String, ParCode As %String = "")
{
	s ^tempdhcpe("UpdatePowerTable")=$lb(PTLRowid,TabCode,TabDesc,PowerType,ClsCode,ParCode)
    new (PTLRowid,TabCode,TabDesc,PowerType,ClsCode,ParCode)  
    s obj=##class(User.DHCPEPowerTableList).%OpenId(PTLRowid)
    s obj.PTTabCode=TabCode
    s obj.PTTabDesc=TabDesc
    s obj.PTPowerType=PowerType
    s obj.PTClsCode=ClsCode
    s obj.PTParCode=ParCode
    s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id_"^修改成功"
	}
}

/// Description: 查询表登记授权管理
/// Table：表登记授权管理 User.DHCPEPowerTableList 
/// Input: Code 表名, Desc 中文名, Type 公/私/管控类型的ID
/// Return：
/// Creator：xy 
/// CreatDate：20210802
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.PowerTable","SearchPowerTableList","","","","","")
Query SearchPowerTableList(Code As %String = "", Desc As %String = "", Type As %String = "", ClsCode As %String = "", ParCode As %String = "") As %Query(ROWSPEC = "TPTLRowid:%String,TTabCode:%String,TTabDesc:%String,TPowerTypeID::%String,TPowerType:%String,TTabClsCode:%String,TTabParCode:%String")
{
}

ClassMethod SearchPowerTableListExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Type As %String = "", ClsCode As %String = "", ParCode As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.CT.PowerTable","SearchPowerTableList")
	S ^tempdhcpe("SearchPowerTableList1")=$lb(Code,Desc,Type,ClsCode,ParCode)
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if (Code'=""){
	 	S Code=$ZCVT(Code,"U")
	 	s ID=$O(^CT.PE.PowerTableListI("IdxOfCode"," "_Code,0))
	 	d GetPowerTableList 
 	}elseif (ClsCode'=""){
	 	S ClsCode=$ZCVT(ClsCode,"U")
	 	s ID=$O(^CT.PE.PowerTableListI("IdxOfClsCode"," "_ClsCode,0))
	 	d GetPowerTableList 
 	}elseif (ParCode'=""){
	 	S ParCode=$ZCVT(ParCode,"U")
	 	s ID=$O(^CT.PE.PowerTableListI("IdxOfParCode"," "_ParCode,0))
	 	d GetPowerTableList 
 	}else{
	 	s ID=""
 		f  s ID=$O(^CT.PE.PowerTableListD(ID)) q:ID=""  d
 	    .d GetPowerTableList  	   
 	   
 	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetPowerTableList
    ;b ;	ID
 	s TabCode=$LG(^CT.PE.PowerTableListD(ID),2)
 	s TabDesc=$LG(^CT.PE.PowerTableListD(ID),3)
 	q:(Desc'="")&&(TabDesc'[Desc)
 	s PowerTypeID=$LG(^CT.PE.PowerTableListD(ID),4)
 	q:(Type'="")&&(PowerTypeID'=Type)
 	s TabClsCode=$LG(^CT.PE.PowerTableListD(ID),5)
 	s TabPTParCode=$LG(^CT.PE.PowerTableListD(ID),6)
 	S PowerType=..GetPowerType(PowerTypeID)
 	d FindBuild 
 	q
 	

FindBuild 
	set Data=$lb(ID,TabCode,TabDesc,PowerTypeID,PowerType,TabClsCode,TabPTParCode) 
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchPowerTableListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPowerTableListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchPowerTableListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPowerTableListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Description: 获取公/私/管控类型
/// Table： 
/// Input:  PowerTypeID 公/私/管控类型 的ID
/// Return：
/// Creator：xy 
/// CreatDate：20210803
/// debug: w ##class(web.DHCPE.CT.PowerTable).GetPowerType()
ClassMethod GetPowerType(PowerTypeID)
{
	new (PowerTypeID)
	q:PowerTypeID="" ""
	s PowerType=""
	i PowerTypeID="G" s PowerType="公有"
	i PowerTypeID="S" s PowerType="私有"
	i PowerTypeID="C" s PowerType="管控"
	i PowerTypeID="A" s PowerType="绝对私有"
	q PowerType
}

}
