Class web.DHCPE.NetPre.OrdSetsInfo Extends %RegisteredObject
{

ClassMethod SaveSetsItemType(ID, StrInfo)
{
	q:StrInfo="" "-1^"
	
	s PID=$P(StrInfo,"^",1)
	s ItemType=$ZCVT($P(StrInfo,"^",2),"U")
	q:((PID="")||(ItemType="")) "-1^"
	
	q:$d(^User.DHCPENetSetsItemTypeI("TypeIndex",ItemType,PID)) "-2^已有该项目类型请勿重复添加！"
	
	i ID="" d
	.s obj=##class(User.DHCPENetSetsItemType).%New()
	.d obj.NSITParRefSetObjectId($P(StrInfo,"^",1))
	e  d
	.s obj=##class(User.DHCPENetSetsItemType).%OpenId(ID)
	d obj.NSITItemTypeIDSetObjectId($P(StrInfo,"^",2))
	s obj.NSITSort=$P(StrInfo,"^",3)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod DeleteSetsItemType(ID)
{
	&SQL(Delete From Sqluser.DHCPENetSetsItemType where ID=:ID)
	q SQLCODE
}

ClassMethod SaveSetsItem(ID, StrInfo)
{
	q:StrInfo="" "-1^"
	
	s PID=$P(StrInfo,"^",1)
	s ItemDesc=$ZCVT($P(StrInfo,"^",2),"U")
	q:((PID="")||(ItemDesc="")) "-1^"
	
	q:$d(^User.DHCPENetSetsItemI("DescIndex",ItemDesc,$p(PID,"||",1),$p(PID,"||",2))) "-2^已有该项目请勿重复添加！"
	
	i ID="" d
	.s obj=##class(User.DHCPENetSetsItem).%New()
	.d obj.NSIParRefSetObjectId($P(StrInfo,"^",1))
	e  d
	.s obj=##class(User.DHCPENetSetsItem).%OpenId(ID)
	s obj.NSIItemDesc=$P(StrInfo,"^",2)
	s obj.NSISort=$P(StrInfo,"^",3)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod DeleteSetsItem(ID)
{
	&SQL(Delete From Sqluser.DHCPENetSetsItem where ID=:ID)
	q SQLCODE
}

ClassMethod SaveSetsItemDetail(ID, StrInfo)
{
	q:StrInfo="" "-1^"
	
	s PID=$P(StrInfo,"^",1)
	s Desc=$ZCVT($P(StrInfo,"^",2),"U")
	q:((PID="")||(Desc="")) "-1^"
	
	q:$d(^User.DHCPENetSetsItemDetailI("DescIndex",Desc,$p(PID,"||",1),$p(PID,"||",2),$p(PID,"||",3))) "-2^已有该细项请勿重复添加！"
	
	i ID="" d
	.s obj=##class(User.DHCPENetSetsItemDetail).%New()
	.d obj.NSIDParRefSetObjectId($P(StrInfo,"^",1))
	e  d
	.s obj=##class(User.DHCPENetSetsItemDetail).%OpenId(ID)
	s obj.NSIDDesc=$P(StrInfo,"^",2)
	s obj.NSIDIntent=$P(StrInfo,"^",3)
	s obj.NSIDSort=$P(StrInfo,"^",4)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod DeleteSetsItemDetail(ID)
{
	&SQL(Delete From Sqluser.DHCPENetSetsItemDetail where ID=:ID)
	q SQLCODE
}

ClassMethod SaveOrdSets(ID, StrInfo)
{
	i ID="" d
	.s obj=##class(User.DHCPENetOrdSets).%New()
	e  d
	.s obj=##class(User.DHCPENetOrdSets).%OpenId(ID)
	s obj.NOSHisSetsID=$P(StrInfo,"^",1)
	s obj.NOSDesc=$P(StrInfo,"^",2)
	s obj.NOSPrice=$P(StrInfo,"^",3)
	s obj.NOSVIPLevel=$P(StrInfo,"^",4)
	s Sex=$P(StrInfo,"^",5)
	//i Sex'="" s Sex=$P(^CT("SEX",Sex),"^",2)
	s obj.NOSSex=Sex
	s obj.NOSRemak=$P(StrInfo,"^",6)
	s obj.NOSSort=$P(StrInfo,"^",7)
	s obj.NOSGIFlag=$P(StrInfo,"^",8)
	s obj.NOSLocID=$P(StrInfo,"^",9)
	s obj.NOSActive=$P(StrInfo,"^",10)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod DeleteOrdSets(ID)
{
	&SQL(Delete From Sqluser.DHC_PE_NetOrdSets where ID=:ID)
	q SQLCODE
}

ClassMethod GetHisSetsInfo(SetsID, LocID)
{
	;d ##class(web.DHCPE.NetPre.OrdSetsInfo).GetHisSetsInfo(SetsID)
	s ret=""
	q:SetsID="" ret
	s ID=..GetNetSetsID(SetsID,LocID)
	i ID="" d
	.s Desc=$P(^ARCOS(SetsID),"^",2)
	.s Price=##class(web.DHCPE.Handle.ARCOrdSets).GetPrice(SetsID_"&O","","")
	.s Code=$P(^ARCOS(SetsID),"^",1)
	.s VIPLevel=""
	.s Sex=$g(^DHCPEDataEx("DHCPEBaseData","Sex",SetsID))
	.s Remark=""
	.s Sort=""
	.s GIFlag="I"
	.s ActiveFlag=""
	e  d
	.s Desc=$LG(^User.DHCPENetOrdSetsD(ID),3)
	.s Price=$LG(^User.DHCPENetOrdSetsD(ID),4)
	.s VIPLevel=$LG(^User.DHCPENetOrdSetsD(ID),5)
	.s Sex=$LG(^User.DHCPENetOrdSetsD(ID),6)
	.s:Sex'="" Sex=$O(^CT("SEX",0,"Desc",Sex,0))
	.s Remark=$LG(^User.DHCPENetOrdSetsD(ID),7)
	.s Sort=$LG(^User.DHCPENetOrdSetsD(ID),10)
	.s GIFlag=$LG(^User.DHCPENetOrdSetsD(ID),12)
	.s ActiveFlag=$LG(^User.DHCPENetOrdSetsD(ID),13)
	q ID_"^"_Desc_"^"_Price_"^"_VIPLevel_"^"_Sex_"^"_Remark_"^"_Sort_"^"_GIFlag_"^"_ActiveFlag
}

ClassMethod GetHisSetsInfoNew(SetsID, LocID)
{
	;d ##class(web.DHCPE.NetPre.OrdSetsInfo).GetHisSetsInfoNew(SetsID)
	s ret=""
	q:SetsID="" ret
	s OSEx=$o(^DHCPEOSE(0,"OrdSets",SetsID,""))
	q:OSEx="" ret
	s OSExData=$g(^DHCPEOSE(OSEx))
	s ID=..GetNetSetsID(SetsID,LocID)
	i ID="" d
	.s Code=$P(^ARCOS(SetsID),"^",1)
	.s Desc=$P(^ARCOS(SetsID),"^",2)
	.s Price=+$p(OSExData,"^",4)
	.s Sex=$p(OSExData,"^",3)
	.s VIPLevel=$p($p(OSExData,"^",6),",",1)
	.;s VIPLevel=""
	.s Remark=""
	.s Sort=""
	.;s PGBId=$p(OSExData,"^",10)
	.s GIFlag="I"
	.s ActiveFlag=""
	e  d
	.s Desc=$LG(^User.DHCPENetOrdSetsD(ID),3)
	.s Price=$LG(^User.DHCPENetOrdSetsD(ID),4)
	.s VIPLevel=$LG(^User.DHCPENetOrdSetsD(ID),5)
	.s Sex=$LG(^User.DHCPENetOrdSetsD(ID),6)
	.;s:Sex'="" Sex=$O(^CT("SEX",0,"Desc",Sex,0))
	.s Remark=$LG(^User.DHCPENetOrdSetsD(ID),7)
	.s Sort=$LG(^User.DHCPENetOrdSetsD(ID),10)
	.s GIFlag=$LG(^User.DHCPENetOrdSetsD(ID),12)
	.s ActiveFlag=$LG(^User.DHCPENetOrdSetsD(ID),13)
	
	s data="{"
	s data=data_"""ID"":"""_ID_""","
	s data=data_"""HisID"":"""_SetsID_""","
	s data=data_"""Desc"":"""_Desc_""","
	s data=data_"""Price"":"""_Price_""","
	s data=data_"""VIPLevel"":"""_VIPLevel_""","
	s data=data_"""Sex"":"""_Sex_""","
	s data=data_"""Remark"":"""_Remark_""","
	s data=data_"""Sort"":"""_Sort_""","
	s data=data_"""GIFlag"":"""_GIFlag_""","
	s data=data_"""ActiveFlag"":"""_ActiveFlag_""""
	s data=data_"}"
	
	q data
}

ClassMethod GetNetSetsID(HisSetsID, LocID)
{
	s ret=""
	s ID=""
	f  s ID=$O(^User.DHCPENetOrdSetsI("HisSetsIndex",HisSetsID,ID)) q:ID=""  d
	.s CurLocID=$LG(^User.DHCPENetOrdSetsD(ID),11)
	.q:CurLocID'=LocID
	.s ret=ID
	q ret
}

ClassMethod OutItemTypeToHTML(ContrlWidth As %String = "", DefaultValue As %String = "", tabIndex As %String = "0") As %String
{
  	;d ##class(web.DHCPE.NetPre.OrdSetsInfo).OutItemTypeToHTML(130,"")
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='ItemType' id='ItemType' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex="_tabIndex_">",!
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^User.DHCPENetItemTypeD(id)) q:id=""  d
	.s selected=""
	.s:DefaultValue=id selected="selected"
	.w "<option value='"_id_"'>"_$LG(^User.DHCPENetItemTypeD(id),2)_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.NetPre.OrdSetsInfo","GetItemType")
Query GetItemType(Show As %String = "") As websys.Query(ROWSPEC = "TID:%String,TDesc:%String,TActive:%String")
{
}

ClassMethod GetItemTypeExecute(ByRef qHandle As %Binary, Show As %String = "") As %Status
{
  	Set repid=$I(^CacheTemp)
 	s ind=1
	
	s id=0
	f  s id=$O(^User.DHCPENetItemTypeD(id)) q:id=""  d
	.q:((Show'="ALL")&&("Y"'=$LG(^User.DHCPENetItemTypeD(id),3)))  // 不使用的过滤
	.s desc=$LG(^User.DHCPENetItemTypeD(id),2)
	.s active=$LG(^User.DHCPENetItemTypeD(id),3)
 	.d ItemTypeOut
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ItemTypeOut      
	set Data=$lb(id,desc,active)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit
}

/// w ##class(web.DHCPE.NetPre.OrdSetsInfo).UpdItemType("","影像检查3","Y")
ClassMethod UpdItemType(ID As %String = "", Desc As %String = "", Active As %String = "") As %String
{
	q:(Desc="") "-1^描述不能为空！"
	if (ID="") {
		q:$d(^User.DHCPENetItemTypeI("NITDescIndex"," "_Desc)) "-1^已存在该类型描述，请重新输入！"
		
		&sql(INSERT INTO SQLUser.DHC_PE_NetItemType (NIT_Desc, NIT_UseFlag) VALUES (:Desc, :Active))
		i SQLCODE=0 s SQLCODE=SQLCODE_"^"_%ROWID
		q SQLCODE
	} else {
		q:'$d(^User.DHCPENetItemTypeD(ID)) "-1^不存在该类型无法修改！"
		q:($d(^User.DHCPENetItemTypeI("NITDescIndex"," "_Desc))&&(ID'=$o(^User.DHCPENetItemTypeI("NITDescIndex"," "_Desc,0)))) "-1^已存在该类型描述，请重新输入！！"
		
		&sql(UPDATE SQLUser.DHC_PE_NetItemType SET NIT_Desc=:Desc, NIT_UseFlag=:Active WHERE ID=:ID)
		i SQLCODE=100 s SQLCODE=0
		q SQLCODE
	}
}

Query SearchSetsItemType(ParRef As %Library.String = "") As %SQLQuery(ROWSPEC = "TID:%String,TItemTypeID:%String, TItemTypeDesc:%String, TSort:%String")
{
 select ID,NSIT_ItemTypeID,NSIT_ItemTypeID->NIT_Desc,NSIT_Sort from Sqluser.DHCPENetSetsItemType where NSITParRef=:ParRef
}

Query SearchSetsItem(ParRef As %Library.String = "") As %SQLQuery(ROWSPEC = "TID:%String,TDesc:%String, TSort:%String")
{
 select ID,NSI_ItemDesc,NSI_Sort from Sqluser.DHCPENetSetsItem where NSIParRef=:ParRef
}

Query SearchSetsItemDetail(ParRef As %Library.String = "") As %SQLQuery(ROWSPEC = "TID:%String,TDesc:%String,TIntent:%String,TSort:%String")
{
 select ID,NSID_Desc,NSID_Intent,NSID_Sort from Sqluser.DHCPENetSetsItemDetail where NSIDParRef=:ParRef
}

}
