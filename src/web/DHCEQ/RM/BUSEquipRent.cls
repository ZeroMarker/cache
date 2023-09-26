/// 名称: web.DHCEQ.RM.BUSEquipRent
/// 描述: 设备租赁定价
/// 编写者：ZX
/// 编写日期: 2019-03-02
/// 产品组：设备管理
Class web.DHCEQ.RM.BUSEquipRent Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQ.RM.BUSEquipRent).SaveData("^2^40^^1^^^","0")
ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "")
{
	k PLIST,rowid
	s flag=""
 	s rowid=$p(val,"^",1)
 	
 	Set $ZT="ERROR"
 	TSTART
 	if (+isDel=1)
 	{
 		&SQL(Delete From SQLUSER.DHC_EQSEquipRent where ER_RowID = :rowid)
 	}
 	elseif (+isDel=0)
 	{
 		s PLIST(2) = $p(val,"^",2)	;SourceType
 		s SourceType= $p(val,"^",2)
 		s PLIST(3) = $p(val,"^",3)	;SourceID
 		s SourceID= $p(val,"^",3)
 		s PLIST(4) = $p(val,"^",4) ;Modeldr
 		s PLIST(5) = $p(val,"^",5)	;mode
 		s PLIST(6) = $p(val,"^",6)  //uomdr
		s PLIST(7) = $p(val,"^",7)  //price
		s PLIST(11) = $p(val,"^",8)  ////add by wy 2017-8-18 WorkloadUOMDR
	
		;检测是否重复 SourceType,SourceID,Model
		s ERRowID=0
		s Flag=0
		f  s ERRowID=$o(^DHCEQSEquipRent(0,"SourceID",SourceType,SourceID,ERRowID))  quit:(ERRowID="")  d
		.i (SourceType=1)&&(ERRowID'=rowid) s Flag=1
		.;机型也一致,且非修改原数据,则为重复数据,不能修改
		.i ($p(val,"^",4)=$p($g(^DHCEQSEquipRent(ERRowID)),"^",3))&&(ERRowID'=rowid) s Flag=1
		i Flag=1 q "重复记录"
		i (rowid="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQSEquipRent Values :PLIST())
		} 
		else
		{
			&SQL(Update SQLUSER.DHC_EQSEquipRent Values :PLIST() where ER_RowID = :rowid) 	 
		}
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	Set ID=$g(%ROWID)
 	q ID
ERROR
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERROR"_ErrorMsg     //返回错误消息 ;
}

ClassMethod GetDataByID(rowid As %Library.String = "")
{
	
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQSEquipRent(rowid)
	s resultex=resultex_"^"	
	i $p(result,"^",2)'=""  d  //spurceid
	.s Desc=""
	.i $p(result,"^",1)'=""  d
	.i $p(result,"^",1)=2 d
	..s Desc=$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",2))),"^",1)
	.e  i $p(result,"^",1)=1 d
	..s Desc=$p($g(^DHCEQSShareResource($p(result,"^",2))),"^",10)
	.s resultex=resultex_Desc //描述
	s resultex=resultex_"^"	
	i $p(result,"^",3)'=""  d  //model
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	//7
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",5))
	s resultex=resultex_"^"
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",10))
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_"^"_resultex
}

Query EquipRent(SourceTypeDR As %String = "", SourceIDDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TName:%String,TModel:%String,TModelDR:%String,TMode:%String,TUOM:%String,TUOMDR:%String,TPrice:%String,TNo:%String,TFileNo:%String,TLeaveFactoryNo:%String,TRow:%String,TWorkLoadUOMDR:%String,TWorkLoadUOM:%String")
{
}

ClassMethod EquipRentExecute(ByRef qHandle As %Binary, SourceTypeDR As %String = "", SourceIDDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetEquipRent
	Quit $$$OK
BuildDataGetEquipRent
	f  s rowid=$o(^DHCEQSEquipRent(rowid))  quit:rowid=""  d
	.d ResetVariablesGetEquipRent
	.s TRowID = rowid										//rowid
	.s TSourceType=$p($g(^DHCEQSEquipRent(rowid)),"^",1) 	//代码
	.q:(TSourceType'=SourceTypeDR)&(SourceTypeDR'="")
	.i TSourceType'="" s TSourceType=$CASE(TSourceType,"1":"共享资源","2":"设备项")
	.s TSourceID=$p($g(^DHCEQSEquipRent(rowid)),"^",2) 		//描述
	.q:(TSourceID'=SourceIDDR)&(SourceIDDR'="")
	.i (TSourceID'="")&($p($g(^DHCEQSEquipRent(rowid)),"^",1)=2) s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TSourceID)),"^",1)
	.i (TSourceID'="")&($p($g(^DHCEQSEquipRent(rowid)),"^",1)=1) d
	..//Modify by zx 2020-03-11
	..s TName=$p($g(^DHCEQSShareResource(TSourceID)),"^",10)
	..s TNo=$p($g(^DHCEQSShareResource(TSourceID)),"^",11)
	..s TLeaveFactoryNo=$p($g(^DHCEQSShareResource(TSourceID)),"^",13)
	.s TModelDR=$p($g(^DHCEQSEquipRent(rowid)),"^",3) 	//
	.i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TMode=$p($g(^DHCEQSEquipRent(rowid)),"^",4) 	//代码
	.i TMode'="" s TMode=$CASE(TMode,"1":"租赁时长","2":"工作量")
	.s TUOMDR=$p($g(^DHCEQSEquipRent(rowid)),"^",5) 	//
	.i TUOMDR'="" s TUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUOMDR)
	.s TWorkLoadUOMDR=$p($g(^DHCEQSEquipRent(rowid)),"^",10)
	.i TWorkLoadUOMDR'="" s TWorkLoadUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUOMDR)
	.s TPrice=$p($g(^DHCEQSEquipRent(rowid)),"^",6) 			
	.s TPrice=##Class(web.DHCEQCommon).FormatNumber(TPrice)
	.d OutputRowGetEquipRent
	quit
OutputRowGetEquipRent
	s TRow=index     //add by HHM 2015-12-24 序号
    s Data=$lb(TRowID,TSourceType,TSourceID,TName,TModel,TModelDR,TMode,TUOM,TUOMDR,TPrice,TNo,TFileNo,TLeaveFactoryNo,TRow,TWorkLoadUOMDR,TWorkLoadUOM)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipRent
	s (TRowID,TSourceType,TSourceID,TName,TModel,TModelDR,TMode,TUOM,TUOMDR,TPrice,TNo,TFileNo,TLeaveFactoryNo,TRow,TWorkLoadUOMDR,TWorkLoadUOM)=""
	quit
}

ClassMethod EquipRentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EquipRentExecute ]
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

ClassMethod EquipRentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EquipRentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetSourceType(name, width, Type) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"") ;add by csj 20180929 Hisui下拉列表改造
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=2>设备项</option>"
	w "<option value=1>共享资源</option>"
	w "</select>",!
}

/// Add By zx 2020-03-13
/// 描述:取租赁设备的价格定义信息
/// 入参：ShareResourceDR 资源ID
/// 返回：未找到对应的租赁价格定义,则返回""
/// 	  否则返回相应信息	EquipRentID
/// w ##Class(web.DHCEQ.RM.BUSEquipRent).GetEquipRentInfo("1")
ClassMethod GetEquipRentInfo(ShareResourceDR)
{
	n EquipRentID,Item,Model,ERRowID
	s (EquipRentID,Item,Model,ERRowID)=""	
	i ShareResourceDR="" q ""
	;取设备定义的租赁价格
	s EquipRentID=$o(^DHCEQSEquipRent(0,"SourceID",1,ShareResourceDR,0))
	i EquipRentID'="" q EquipRentID
	
	;如果未定义,则取设备项上的定义
	s EquipDR=$p($g(^DHCEQSShareResource(ShareResourceDR)),"^",3)
	i EquipDR'="" d
	.s Item=$p($g(^DHCEQEquip(EquipDR)),"^",7)
	.s Model= $p($g(^DHCEQEquip(EquipDR)),"^",3)
	.q:Item=""
	.s ERRowID=0
	.s Flag=0
	.f  s ERRowID=$o(^DHCEQEquipRent(0,"SourceID",2,Item,ERRowID))  quit:((ERRowID="")||(EquipRentID'=""))  d
	..s ERModel=$p($g(^DHCEQEquipRent(ERRowID)),"^",3)
	..q:(ERModel'="")&&(ERModel'=Model)
	..s EquipRentID=ERRowID
	
	;如果未定义,则取资源项目上的定义
	
	q EquipRentID
}

}
