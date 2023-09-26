Class web.DHCCTLocMajor Extends DHCDoc.Util.RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod DeleteMajorLoc(ID As %String) As %Boolean
{
 
 Quit:((ID="")||(+ID=0)) 0 
 Set IsDeleted=##class(User.DHCCTLocMajor).%DeleteId(ID)
 Quit:IsDeleted=1 1
 Quit:IsDeleted=0 0
}

ClassMethod UpdateMajor(ID As %String, Code, Desc, StartDate, EndDate) As %Boolean
{
	 q:(ID=""||(+ID=0)) 0
	 i StartDate'="" s StartDate=..%ZDH(StartDate)
     i EndDate'="" s EndDate=..%ZDH(EndDate)
     s HospDr=$p(^DHCCTLoc(ID),"^",5)
     s count=0
	 &sql(select count(CTLMJ_RowID) into:count from SQLUser.DHC_CTLoc_Major where (CTLMJ_Code=:Code or CTLMJ_Name=:Desc) and CTLMJ_Hosp_Dr=:HospDr and CTLMJ_RowID<>:ID)
	 Q:count>0 "repeat"
	 s SaveResult=0
	 Set Obj=##class(User.DHCCTLocMajor).%OpenId(ID)
	 i $IsObject(Obj){
	 	Set Obj.CTLMJCode=Code
	 	Set Obj.CTLMJName=Desc
	 	s Obj.CTLMJStartDate=StartDate
	 	s Obj.CTLMJEndDate=EndDate
	 	Set SaveResult=Obj.%Save()
	 }
	 Quit:SaveResult=1 1
	 Quit:SaveResult'=1 0
}

/// w ##class(web.DHCCTLocMajor).InsertMajor("分院外科","01","24/03/2020","","3")
ClassMethod InsertMajor(Code, Desc, StartDate, EndDate, HospId As %String = "") As %Boolean
{
	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
	if ((+StartDate'=0)&&(+EndDate'=0)){
		q:StartDate>EndDate 0
	}
	s count=0
	&sql(select count(CTLMJ_RowID) into:count from SQLUser.DHC_CTLoc_Major where (CTLMJ_Code=:Code or CTLMJ_Name=:Desc) and CTLMJ_Hosp_Dr=:HospId)
	Q:count>0 "repeat"
	 Set Obj=##class(User.DHCCTLocMajor).%New()
	 Set Obj.CTLMJCode=Code
	 Set Obj.CTLMJName=Desc
	 Set Obj.CTLMJStartDate=StartDate
	 Set Obj.CTLMJEndDate=EndDate
	 do Obj.CTLMJHospDrSetObjectId(HospId)
	 Set SaveResult=Obj.%Save()
	 Quit:SaveResult=1 1
	 Quit:SaveResult'=1 0
}

Query GetMajorLocLis1t() As %SQLQuery(CONTAINID = 1, ROWSPEC = "RowID:%String,Name:%String,Code:%String,StartDate:%String,EndDate:%String")
{
SELECT CTLMJ_RowID,CTLMJ_Name, CTLMJ_Code, CTLMJ_StartDate,CTLMJ_EndDate
FROM SQLUser.DHC_CTLoc_Major 
where CTLMJ_Code is not null 
ORDER BY  CTLMJ_StartDate
}

Query GetMajorLocList(CTLocID As %String, Doctor As %String, HospId As %String = "") As %Query(ROWSPEC = "RowID:%String,Name:%String,Code:%String,StartDate:%String,EndDate:%String,HospDesc:%String")
{
}

ClassMethod GetMajorLocListExecute(ByRef QHandle As %Binary, CTLocID As %String, Doctor As %String, HospId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s MajorID=0
    f  s MajorID=$o(^DHCCTLoc(MajorID)) q:MajorID=""  d
     .s RowID=MajorID
     .s HospDr=$p(^DHCCTLoc(MajorID),"^",5)
     .Q:(HospId'="")&&(HospId'=HospDr)
     .s HospDesc=$p(^CT("HOSP",HospDr),"^",2)
     .s Name=$p(^DHCCTLoc(MajorID),"^",2)
     .s Code=$p(^DHCCTLoc(MajorID),"^",1)
     .s StartDate=$p(^DHCCTLoc(MajorID),"^",3)
     .i StartDate'="" s StartDate=..%ZD(StartDate) //$zd(StartDate,4)
     .s EndDate=$p(^DHCCTLoc(MajorID),"^",4)
     .i EndDate'="" s EndDate=..%ZD(EndDate) //$zd(EndDate,4)
	 .s ^CacheTemp(repid,ind)=$lb(RowID,Name,Code,StartDate,EndDate,HospDesc)
	 .s ind=ind+1
	Quit $$$OK
}

ClassMethod GetMajorLocListClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetMajorLocListExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetMajorLocListFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMajorLocListExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Input：rowid, tableName
/// Other: d ##class(%ResultSet).RunQuery("web.DHCCTLocMajor","GetList","User.DHCCTLocMajor","测试1","","2") 
Query GetList(tableName, type, dir, hospid) As %Query(ROWSPEC = "SortId,RowId,Desc,SortType,SortNum")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, tableName, type, dir, hospid) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^tempqujian("GetList")=tableName_","_type_","_dir_","_ hospid
	
	s tablecode= ##class(web.DHCBL.BDP.BDPTableList).GetCodeByTableName(tableName)
	s HospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
	s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(tablecode)	 //获取数据公有私有类型
	k array
	if (type'=""){
		s n=0
		s SortNum=0     //排序表中内容
		for {
			s SortNum=$o(^User.BDPSortI("SortNumIdx",tableName,type,SortNum)) q:(SortNum="")
			s n=n+1
			s a(n)= SortNum	 	
		}
		
		s left=1,right=n
		if (dir="DESC"){
			d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSortDesc(.a,left,right) //排序 降序
		}
		else{
			d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序 升序
		}
		s count=0
		s SortId=0
		s n=0
		for {
			s n=$o(a(n)) q:n=""
			s SortNum=$g(a(n))
			for {
  				s SortId = $o(^User.BDPSortI("SortNumIdx",tableName,type,SortNum,SortId)) q:SortId=""
  				s count=count+1
  				s array(count)=SortId
  				
  			}
		}
		s SortId=0
		s num=0
		for {
			s num=$o(array(num)) q:num=""
			s SortId=$g(array(num))
			s RowId=$listget($g(^User.BDPSortD(SortId)),3)
			s Desc=""
			
			s DescProName=$o(^User.BDPTableListI("SubProDescIndex",tableName,0))
			s xobjStr="s dataobj=##class("_tableName_").%OpenId("""_RowId_""")"
			if tableName="User.ARCItmMast" s xobjStr="s dataobj=##class("_tableName_").%OpenId("""_RowId_"||1"_""")"  //医嘱项特殊
			x xobjStr
			if (dataobj)&&(DescProName'=""){
				s DescXstr="s Desc=dataobj."_DescProName
				x DescXstr
				d dataobj.%Close()
			}
			if (tableName="User.DHCCTLocMajor") {
				s CTLMJStartDate=$p($g(^DHCCTLoc(RowId)),"^",3)
				continue:(CTLMJStartDate'="")&&(CTLMJStartDate>+$h)
				s CTLMJEndDate=$p($g(^DHCCTLoc(RowId)),"^",4)
				continue:(CTLMJEndDate'="")&&(CTLMJEndDate<=..%SysDate())
			}
			
			continue:Desc=""
			s SortType=$listget($g(^User.BDPSortD(SortId)),4)
			s SortNum=$listget($g(^User.BDPSortD(SortId)),5)
			
			i ($ZCONVERT(SortType,"U")[$ZCONVERT(type,"U")){
				d OutputRow	 
			}
		}
		s RowIdStr = ##class(web.DHCBL.BDP.BDPSort).GetSortReference(tableName,type)
		s BDPTableListid = $o(^User.BDPTableListI("UqIndex"," "_$ZCONVERT(tableName,"U"),0))
		if BDPTableListid'="" {
			S xGlobal=$listget($g(^User.BDPTableListD(BDPTableListid)),9)  
			s DescProName=$o(^User.BDPTableListI("SubProDescIndex",tableName,0))
			if xGlobal'="" {
				s RowId=0            //原表内容
				if $e(xGlobal,$l(xGlobal))=")" s xRowIdStr="s RowId=$o("_$e(xGlobal,1,$l(xGlobal)-1)_",RowId)"_")"
				else  s xRowIdStr="s RowId=$o("_xGlobal_"(RowId)"_")"
				for {		
					x xRowIdStr q:(RowId="")||(RowId'>0)
					s Id = "["_RowId_"]"
					s Desc=""
					if (RowIdStr[Id) continue
					///2020-07-01根据医院过滤非公有数据
					if ((hospid'="")&&(HospAutflag="Y")&&(DataTypeFlag'="G")) {
						s showflag="Y"
						if tableName="User.ARCItmMast"{
							s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(tablecode,RowId_"||1",hospid)
						}elseif (tableName'="User.DHCCTLocMajor"){
							s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(tablecode,RowId,hospid)
						}
						continue:showflag="N"
					}
			
					s xobjStr="s dataobj=##class("_tableName_").%OpenId("""_RowId_""")"
					if tableName="User.ARCItmMast" s xobjStr="s dataobj=##class("_tableName_").%OpenId("""_RowId_"||1"_""")"  //医嘱项特殊
					x xobjStr
					if (dataobj)&&(DescProName'=""){
						s DescXstr="s Desc=dataobj."_DescProName
						x DescXstr
						d dataobj.%Close()
					}
					if (tableName="User.MRCICDDx")  //ICD诊断代码
					{
						continue:(Code="-")||(Desc="-") //屏蔽垃圾数据
						s Valid=$p($g(^MRC("ID",RowId)),"^",27)
						continue:Valid="N"	
					}
					if (tableName="User.DHCCTLocMajor") {
						s CTLMJStartDate=$p($g(^DHCCTLoc(RowId)),"^",3)
						continue:(CTLMJStartDate'="")&&(CTLMJStartDate>+$h)
						s CTLMJEndDate=$p($g(^DHCCTLoc(RowId)),"^",4)
						continue:(CTLMJEndDate'="")&&(CTLMJEndDate<=..%SysDate())
					}
					s SortType = ""
					s SortNum = ""
					continue:Desc=""
					d OutputRow		
				}	
			}
			
		}
		
	}else{
		s BDPTableListid = $o(^User.BDPTableListI("UqIndex"," "_$ZCONVERT(tableName,"U"),0))
		if BDPTableListid'=""
		{
			S xGlobal=$listget($g(^User.BDPTableListD(BDPTableListid)),9)  
			s DescProName=$o(^User.BDPTableListI("SubProDescIndex",tableName,0))
			if xGlobal'=""
			{
				s RowId=0            //原表内容
				if $e(xGlobal,$l(xGlobal))=")" s xRowIdStr="s RowId=$o("_$e(xGlobal,1,$l(xGlobal)-1)_",RowId)"_")"
				else  s xRowIdStr="s RowId=$o("_xGlobal_"(RowId)"_")"
				for 
				{		
					x xRowIdStr q:(RowId="")||(RowId'>0)
					///2020-07-01根据医院过滤非公有数据
			
					s xobjStr="s dataobj=##class("_tableName_").%OpenId("""_RowId_""")"
					if tableName="User.ARCItmMast" s xobjStr="s dataobj=##class("_tableName_").%OpenId("""_RowId_"||1"_""")"  //医嘱项特殊
					x xobjStr
					S Desc=""
					if (dataobj)&&(DescProName'="")
					{
						s DescXstr="s Desc=dataobj."_DescProName
						x DescXstr
						d dataobj.%Close()
					}
					if (tableName="User.MRCICDDx")  //ICD诊断代码
					{
						continue:(Code="-")||(Desc="-") //屏蔽垃圾数据
						s Valid=$p($g(^MRC("ID",RowId)),"^",27)
						continue:Valid="N"	
					}
					if (tableName="User.DHCCTLocMajor") {
						s CTLMJStartDate=$p($g(^DHCCTLoc(RowId)),"^",3)
						continue:(CTLMJStartDate'="")&&(CTLMJStartDate>+$h)
						s CTLMJEndDate=$p($g(^DHCCTLoc(RowId)),"^",4)
						continue:(CTLMJEndDate'="")&&(CTLMJEndDate<=..%SysDate())
					}
					continue:Desc=""
					s SortType = ""
					s SortNum = ""
					d OutputRow		
				}
			}
		}
			
		
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	s HospDr=$p(^DHCCTLoc(RowId),"^",5)
	q:hospid'=HospDr
    set Data=$lb(SortId,RowId,Desc,SortType,SortNum)
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

Query GetDataForCmb1(rowid As %String, desc As %String, tableName As %String, hospid As %String) As websys.Query(ROWSPEC = "ID:%String,SortType:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, tableName As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	s tablecode= ##class(web.DHCBL.BDP.BDPTableList).GetCodeByTableName(tableName)
	if (rowid'=""){
		s SortId=rowid
		s ID=rowid
		s SortType=$listget($g(^User.BDPSortD(SortId)),4)
		d OutputRowCmb
	}
	else{
		k ^TMPSORTTYPE
		s SortId=0
		for{
			s SortId=$o(^User.BDPSortD(SortId)) q:SortId=""
			s TableName=$listget($g(^User.BDPSortD(SortId)),2)
			s SortType=$listget($g(^User.BDPSortD(SortId)),4)
			s RowId=$listget($g(^User.BDPSortD(SortId)),3)
			if (TableName="User.DHCCTLocMajor") {
				s HospDr=$p($g(^DHCCTLoc(RowId)),"^",5)
				continue:HospDr'=hospid
			}
			s Desc=""
			if ($ZCONVERT(TableName,"U")[$ZCONVERT(tableName,"U")){
				s ^TMPSORTTYPE(tableName,SortType)=	SortId
			}
		}
		s SortType = 0
		for { 
			s SortType=$o(^TMPSORTTYPE(tableName,SortType)) q:SortType="" 
			S ID=$g(^TMPSORTTYPE(tableName,SortType))
			d OutputRowCmb 		
		}
		K ^TMPSORTTYPE	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(ID,SortType)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Input：rowid, tableName
/// Other: d ##class(%ResultSet).RunQuery("web.DHCCTLocMajor","GetListSub","User.DHCCTLocMinor","测试","","2","") 
Query GetListSub(tableName, type, dir, hospid, MastRowID) As %Query(ROWSPEC = "SortId,RowId,Desc,SortType,SortNum")
{
}

ClassMethod GetListSubExecute(ByRef qHandle As %Binary, tableName, type, dir, hospid, MastRowID) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^tempqujian("GetList")=tableName_","_type_","_dir_","_ hospid_","_MastRowID
	
	s tablecode= ##class(web.DHCBL.BDP.BDPTableList).GetCodeByTableName(tableName)
	s HospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
	s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(tablecode)	 //获取数据公有私有类型
	k array
	if (type'=""){
		s n=0
		s SortNum=0     //排序表中内容
		for {
			s SortNum=$o(^User.BDPSortI("SortNumIdx",tableName,type,SortNum)) q:(SortNum="")
			s n=n+1
			s a(n)= SortNum	 	
		}
		
		s left=1,right=n
		if (dir="DESC"){
			d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSortDesc(.a,left,right) //排序 降序
		}
		else{
			d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序 升序
		}
		s count=0
		s SortId=0
		s n=0
		for {
			s n=$o(a(n)) q:n=""
			s SortNum=$g(a(n))
			for {
  				s SortId = $o(^User.BDPSortI("SortNumIdx",tableName,type,SortNum,SortId)) q:SortId=""
  				s count=count+1
  				s array(count)=SortId
  				
  			}
		}
		s SortId=0
		s num=0
		for {
			s num=$o(array(num)) q:num=""
			s SortId=$g(array(num))
			s RowId=$listget($g(^User.BDPSortD(SortId)),3)
			s Desc=""
			
			s DescProName=$o(^User.BDPTableListI("SubProDescIndex",tableName,0))
			s dataobj=##class(User.DHCCTLocMinor).%OpenId(RowId)
			s CTLocDR=$p($g(^DHCCTLoc(+RowId,"MINOR",$P(RowId,"||",2))),"^",1)
			s ActiveFlag=$p($g(^DHCCTLoc(+RowId,"MINOR",$P(RowId,"||",2))),"^",2)
			continue:ActiveFlag'=1
			s Desc=$p(^CTLOC(CTLocDR),"^",2)
			s RowID=RowId
			continue:Desc=""
			s SortType=$listget($g(^User.BDPSortD(SortId)),4)
			s SortNum=$listget($g(^User.BDPSortD(SortId)),5)
			
			i ($ZCONVERT(SortType,"U")[$ZCONVERT(type,"U")){
				d OutputRowSub	 
			}
		}
		s RowIdStr = ##class(web.DHCBL.BDP.BDPSort).GetSortReference(tableName,type)
		s RowId=0            //原表内容
		
		for {		
			s RowId=$O(^DHCCTLoc(MastRowID,"MINOR",RowId))
			q:(RowId="")||(RowId'>0)
			s Id = "["_MastRowID_"||"_RowId_"]"
			s RowID=MastRowID_"||"_RowId
			s Desc=""
			if (RowIdStr[Id) continue
			s CTLocDR=$p(^DHCCTLoc(+MastRowID,"MINOR",RowId),"^",1)
			s ActiveFlag=$p(^DHCCTLoc(+MastRowID,"MINOR",RowId),"^",2)
			continue:ActiveFlag'=1
			s Desc=$p(^CTLOC(CTLocDR),"^",2)
			continue:Desc=""
			s SortType = ""
			s SortNum = ""
			continue:Desc=""
			d OutputRowSub		
		}	
		
	}else{
		s RowId=0            //原表内容
		for {		
			s RowId=$O(^DHCCTLoc(MastRowID,"MINOR",RowId)) q:(RowId="")||(RowId'>0)
			///2020-07-01根据医院过滤非公有数据
			s CTLocDR=$p(^DHCCTLoc(+MastRowID,"MINOR",RowId),"^",1)
			s ActiveFlag=$p(^DHCCTLoc(+MastRowID,"MINOR",RowId),"^",2)
			continue:ActiveFlag'=1
			s Desc=$p(^CTLOC(CTLocDR),"^",2)
			s RowID=MastRowID_"||"_RowId
			continue:Desc=""
			s SortType = ""
			s SortNum = ""
			d OutputRowSub		
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowSub
    set Data=$lb(SortId,RowID,Desc,SortType,SortNum)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

Query GetDataForCmb1Sub(rowid As %String, desc As %String, tableName As %String, hospid As %String, MasterRowID) As websys.Query(ROWSPEC = "ID:%String,SortType:%String")
{
}

ClassMethod GetDataForCmb1SubExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, tableName As %String, hospid As %String, MasterRowID) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ^tempqujian("GetDataForCmb1Sub")=rowid_","_desc_","_tableName_","_hospid_","_MasterRowID
	s ind=1
	s tablecode= ##class(web.DHCBL.BDP.BDPTableList).GetCodeByTableName(tableName)
	if (rowid'=""){
		s SortId=rowid
		s ID=rowid
		s SortType=$listget($g(^User.BDPSortD(SortId)),4)
		d OutputRowCmb
	}
	else{
		k ^TMPSORTTYPE
		s SortId=0
		for{
			s SortId=$o(^User.BDPSortD(SortId)) q:SortId=""
			s TableName=$listget($g(^User.BDPSortD(SortId)),2)
			continue:tableName'=TableName
			s SortType=$listget($g(^User.BDPSortD(SortId)),4)
			s RowId=$listget($g(^User.BDPSortD(SortId)),3)
			continue:(MasterRowID'=$P(RowId,"||",1))
			s Desc=""
			if ($ZCONVERT(TableName,"U")[$ZCONVERT(tableName,"U")){
				s ^TMPSORTTYPE(tableName,SortType)=	SortId
			}
		}
		s SortType = 0
		for { 
			s SortType=$o(^TMPSORTTYPE(tableName,SortType)) q:SortType="" 
			S ID=$g(^TMPSORTTYPE(tableName,SortType))
			d OutputRowCmbSub		
		}
		K ^TMPSORTTYPE	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmbSub
    set Data=$lb(ID,SortType)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

}
