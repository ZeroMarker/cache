Class web.DHCBL.KB.KBaseConfig Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2015-2-26
/// Description：查询知识库度量数据来源
/// Table：%IHBI.KBaseConfig
/// Input：rowid, tableName
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.KBaseConfig","GetTypeList","ARC_BillSub","")
Query GetTypeList(tableName, desc) As %Query(ROWSPEC = "TypeRowID,TypeName")
{
}

ClassMethod GetTypeListExecute(ByRef qHandle As %Binary, tableName, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:desc'="" desc=$ZCONVERT(desc,"U")
	
	if (tableName="PHC_Instruc"){ //User.PHCInstruc
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^PHCIN(TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^PHCIN(TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}
		}
	} 
	elseif (tableName="PHC_Poison"){ //User.PHCPoison
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^PHCPO(TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^PHCPO(TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}	
		}
	}	
	/*elseif (tableName="PHC_DrgForm"){ //User.PHCDrgForm不维护明细
		
	}*/
	elseif (tableName="DHC_TarAC"){ //User.DHCTarAC
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^DHCTarC("TAC",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^DHCTarC("TAC",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}	
		}
	}	
	elseif (tableName="DHC_TarAcctCate"){ //User.DHCTarAcctCate
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^DHCTarC("AC",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^DHCTarC("AC",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}	
		}
	}	
	elseif (tableName="DHC_TarEC"){ //User.DHCTarEC
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^DHCTarC("TEC",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^DHCTarC("TEC",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}	
		}
	}	
	elseif (tableName="DHC_TarEMCCate"){ //User.DHCTarEMCCate
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^DHCTarC("EC",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^DHCTarC("EC",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}	
		}
	}	
	elseif (tableName="ARC_BillGrp"){ //User.ARCBillGrp
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^ARCBG(TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^ARCBG(TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}	
		}
	}	
	elseif (tableName="ARC_BillSub"){ //User.ARCBillSub
		s RowID=0
		for  
		{	
			s RowID=$o(^ARCBG(RowID)) q:RowID="" 
			s TypeRowID=0
			for{
				s TypeRowID=$o(^ARCBG(RowID,"SG",TypeRowID)) q:TypeRowID=""
				s TypeName=$p($g(^ARCBG(RowID,"SG",TypeRowID)),"^",2) 
				s TypeNameU=$ZCONVERT(TypeName,"U")
				i (TypeNameU[desc){  
					d OutputRow		
				}		
			} 		
		}
	}	
	elseif (tableName="OEC_OrderCategory"){ //User.OECOrderCategory
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^OEC("ORCAT",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^OEC("ORCAT",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}			
		}
	}
	elseif (tableName="ARC_ItemCat"){ //User.ARCItemCat
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^ARC("IC",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^ARC("IC",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}		
		}
	}	
	elseif (tableName="DHC_TarCate"){ //User.DHCTarCate
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^DHCTarC("CC",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^DHCTarC("CC",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}	
		}
	}		
	elseif (tableName="DHC_TarSubCate"){ //User.DHCTarSubCate
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^DHCTarC("SC",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^DHCTarC("SC",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}	
		}
	}
	elseif (tableName="DHC_TarOC"){ //User.DHCTarOC
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^DHCTarC("TOC",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^DHCTarC("TOC",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}	
		}
	}		
	elseif (tableName="DHC_TarOutpatCate"){ //User.DHCTarOutpatCate
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^DHCTarC("OC",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^DHCTarC("OC",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}	
		}
	}	
	elseif (tableName="DHC_TarIC"){ //User.DHCTarIC
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^DHCTarC("TIC",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^DHCTarC("TIC",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}	
		}
	}
	elseif (tableName="DHC_TarInpatCate"){ //User.DHCTarInpatCate
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^DHCTarC("IC",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^DHCTarC("IC",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}	
		}
	}	
	elseif (tableName="DHC_TarMC"){ //User.DHCTarMC
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^DHCTarC("TMC",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^DHCTarC("TMC",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}	
		}
	}
	elseif (tableName="DHC_TarMRCate"){ //User.DHCTarMRCate
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^DHCTarC("MC",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^DHCTarC("MC",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}		
		}
	}	
	elseif (tableName="ARC_ItmMast"){ //User.ARCItmMast
		s Subscript=0
		for{
			s Subscript=$o(^ARCIM(Subscript)) q:Subscript=""
			s TypeRowID=0
			for  
			{	
				s TypeRowID=$o(^ARCIM(Subscript,TypeRowID)) q:TypeRowID="" 
				s TypeName=$p($g(^ARCIM(Subscript,TypeRowID,1)),"^",2)  
				s TypeNameU=$ZCONVERT(TypeName,"U")
				i (TypeNameU[desc){  
					d OutputRow		
				}	
			}
		}
		
	}	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(TypeRowID,TypeName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator:高姗姗
/// CreatDate: 2015-2-27
/// Description：查询知识库度量明细
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.KBaseConfig","GetList","3")
Query GetList(parref As %String) As %Query(ROWSPEC = "KBCRowId,TypeRowID,TypeName,ADMType,StartDate,EndDate")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, parref As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (parref'=""){
		s KBDRowId=parref,Childsub=0
		for {
			s Childsub=$o(^IHBI.KBaseDefineD(KBDRowId,"KBDChild",Childsub))  q:Childsub=""
			s KBCRowId=KBDRowId_"||"_Childsub
			s TypeRowID = $listget($g(^IHBI.KBaseDefineD(KBDRowId,"KBDChild",Childsub)),1)
			s TypeName = $listget($g(^IHBI.KBaseDefineD(KBDRowId,"KBDChild",Childsub)),2)
			s ADMType = $listget($g(^IHBI.KBaseDefineD(KBDRowId,"KBDChild",Childsub)),3)
			s StartDate = $listget($g(^IHBI.KBaseDefineD(KBDRowId,"KBDChild",Childsub)),4)
			s:StartDate'="" StartDate=$zd(StartDate,1)
			s EndDate = $listget($g(^IHBI.KBaseDefineD(KBDRowId,"KBDChild",Childsub)),5)
			s:EndDate'="" EndDate=$zd(EndDate,1)
			if (Childsub>0)
			{
				d OutputRow
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(KBCRowId,TypeRowID,TypeName,ADMType,StartDate,EndDate)
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

/// Creator:高姗姗
/// CreatDate: 2015-2-27
/// Description：添加知识库度量明细
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.KBaseConfig).SaveData("2^2^口服^I")
ClassMethod SaveData(config As %String) As %String
{
	s result = ""
	s KBDParRef=$p(config,"^",1) //KBDParRef
	s TypeRowID=$p(config,"^",2) //TypeRowID
    s TypeName=$p(config,"^",3) //TypeName
    s ADMType=$p(config,"^",4) //ADMType
    
    s id = $o(^IHBI.KBaseConfigI("TypeRowIDIndex",TypeRowID,KBDParRef,0))
	i id '="" Quit "{success:'false',info:'该记录已存在'}" 
	Ts
	
	s obj=##class(%IHBI.KBaseConfig).%New(KBDParRef)
	d obj.KBDParRefSetObjectId(KBDParRef)
	s obj.TypeRowID = TypeRowID
	s obj.TypeName = TypeName
	s obj.ADMType = ADMType

	s logJson="{TypeRowID:"_$c(34)_TypeRowID_$c(34)_",TypeName:"_$c(34)_TypeName_$c(34)_",ADMType:"_$c(34)_ADMType_$c(34)_"}"
	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("%IHBI.KBaseConfig","%IHBI.KBaseConfig","知识库度量明细",id,TypeName,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
	}
	q result
}

/// Creator:高姗姗
/// CreatDate: 2015-2-27
/// Description：知识库度量明细修改
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.KBaseConfig).Save("8^9^LAB")
ClassMethod Save(id As %String, ADMType As %String, StartDate As %String, EndDate As %String) As %String
{
	s result = ""
	Ts
	s obj=##class(%IHBI.KBaseConfig).%OpenId(id)
	s obj.ADMType = ADMType
	if (StartDate'=""){
		s obj.StartDate = $zdh(StartDate,15)
	}else{
		s obj.StartDate = ""	
	}
	if (EndDate'=""){
		s obj.EndDate = $zdh(EndDate,15)	
	}else{
		s obj.EndDate = ""	
	}

	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
	}else{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
	}
	q result
}

/// Creator:高姗姗
/// CreatDate: 2015-2-27
/// Description：根据ID删除知识库度量明细表的内容
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	s pobj=##class(%IHBI.KBaseConfig).%OpenId(id)
	s eobj = ##class(web.Entity.KB.KBaseConfig).%New()
	s eobj.KBCRowId = id
	s eobj.TypeRowID=$p(id,"||",1)
	s eobj.TypeName=pobj.TypeName
	s eobj.ADMType=pobj.ADMType
	s eobj.StartDate=pobj.StartDate
	s eobj.EndDate=pobj.EndDate
	
	d pobj.%Close()
	Tstart
	s sc=##class(%IHBI.KBaseConfig).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.KBaseConfig","%IHBI.KBaseConfig","知识库度量明细",id,eobj.TypeName,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
	}
	q result
}

}
