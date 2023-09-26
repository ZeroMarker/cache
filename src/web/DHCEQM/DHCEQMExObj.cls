/// --------------------------------------------
/// Description:在设备维护菜单下新增故障现象子菜单,实现对故障现象信息的管理.
/// --------------------------------------------
Class web.DHCEQM.DHCEQMExObj Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter GlobalLen = 15;

ClassMethod CreateCbo(name, width) As %String
{
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=1>设备</option>"
	w "<option value=9>其他</option>"
	w "</select>",!
}

ClassMethod ExObjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ExObjExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod ExObjExecute(ByRef qHandle As %Binary, Name As %String = "", No As %String = "", ExType As %String = "", ExID As %String = "", TypeDR As %String = "", Remark As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s Name=$ZCONVERT(Name ,"U")		//转换为大写?
	s No=$ZCONVERT(No ,"U")
	s ExType=$ZCONVERT(ExType ,"U")
	s ExID=$ZCONVERT(ExID ,"U")
	s TypeDR=$ZCONVERT(TypeDR ,"U")
	s Remark=$ZCONVERT(Remark ,"U") 		
	s TRow=0
	s index=1
	s rowid=0
	d BuildDataGetExObj
	Quit $$$OK
BuildDataGetExObj	
	///^DHCEQCCode("DHCEQMExObj",6)=a^x^^1^a^2^z^^^^^^^N
	f  s rowid=$o(^DHCEQMExObj(rowid))  quit:rowid=""  d
	.d ResetVariablesGetExObj
	.s TRowID = rowid	
	.s TName=$p($g(^DHCEQMExObj(TRowID)),"^",1)
	.s TNo=$p($g(^DHCEQMExObj(TRowID)),"^",2)
	.//修改 by GR0002 2014-08-22 begin
	.//s TExLocDR=$p($g(^DHCEQMExObj(TRowID)),"^",3)
	.//i TExLocDR'=""  s TExLoc=$Piece($Get(^CTLOC(TExLocDR)),"^",2)   
	.s TExObjLocDR=$p($g(^DHCEQMExObj(TRowID)),"^",3)
	.;i TExObjLocDR'=""  s TExObjLoc=$Piece($Get(^CTLOC(TExObjLocDR)),"^",2)   //modify by jyp 2019-10-18 CTLOC调整
	.i TExObjLocDR'=""  s TExObjLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TExObjLocDR)  //modify by jyp 2019-10-18 CTLOC调整
	.//修改 by GR0002 2014-08-22 end
	.s TExType=$p($g(^DHCEQMExObj(TRowID)),"^",4) 
	.s TExType=##Class(web.DHCEQM.DHCEQMExObj).GetExTypeDesc(TExType)
	.s TExID=$p($g(^DHCEQMExObj(TRowID)),"^",5) 
	.s TTypeDR=$p($g(^DHCEQMExObj(TRowID)),"^",6)
	.i TTypeDR'="" s TType=$p($g(^DHCEQCCode("DHCEQMCObjType",TTypeDR)),"^",2)	
	.s TRemark=$p($g(^DHCEQMExObj(TRowID)),"^",7) 
	.s TInvalidFlag=$p($g(^DHCEQMExObj(TRowID)),"^",14) 	
	.q:TInvalidFlag="Y"
	.q:($ZCONVERT(TName,"U")'[Name)&(Name'="")
	.q:($ZCONVERT(TNo,"U")'[No)&(No'="")
	.q:($ZCONVERT(TExType,"U")'[ExType)&(ExType'="")
	.q:($ZCONVERT(TExID,"U")'[ExID)&(ExID'="")
	.q:($ZCONVERT(TypeDR,"U")'[TypeDR)&(TypeDR'="")
	.q:($ZCONVERT(TRemark,"U")'[Remark)&(Remark'="")
	.//q:($ZCONVERT(TInvalidFlag,"U")'[InvalidFlag)&(InvalidFlag'="")
	.//q:($ZCONVERT(TType,"U")'[Type)&(Type'="")	
	.d OutputRowGetExObj	
	quit
OutputRowGetExObj
	s TRow=TRow+1
 	s Data=$lb(TRowID,TName,TNo,TExObjLocDR,TExObjLoc,TExType,TExID,TTypeDR,TRemark,TInvalidFlag,TType,TRow) //add
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetExObj
	s (TRowID,TName,TNo,TExObjLocDR,TExObjLoc,TExType,TExID,TTypeDR,TRemark,TInvalidFlag,TType)="" //add
	//修改 by GR0002 2014-08-22 end
	quit
}

ClassMethod ExObjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ExObjExecute ]
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

ClassMethod GetDataByID(rowid As %Library.String = "")
{
    new result,resultex
	s (result,resultex)=""
	s result=^DHCEQMExObj(rowid)
	set count=..#GlobalLen-$l(result,"^")
	for i=count:-1:1 { s result=result_"^"}
	s resultex=resultex_"^"	//Loc
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",3))
	
	q result_resultex
}

ClassMethod GetExTypeDesc(ExType As %Library.String) As %Status
{
	i ExType=""  q ""
	i +ExType=1  q "设备"
	i +ExType=9  q "其他"
	q "未定义"
}

ClassMethod SaveData(val, isDel As %Library.String = "")
{
	k PLIST,RowID
    s RowID=$p(val,"^",1)
	//s RowID=""
	s PLIST(2)=$p(val,"^",2)
	s Name=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s No=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s ExType=$p(val,"^",5)
	s PLIST(6)=$p(val,"^",6)
	s ExID=$p(val,"^",6)
	s PLIST(7)=$p(val,"^",7)
	s PLIST(8)=$p(val,"^",8)
	s PLIST(15)="N"
	s tmpid=""
	//add by wy 2017-08-1 需求416762 过滤重复数据
	&SQL(select EO_RowID into :tmpid from SQLUSER.DHC_EQMExObj where EO_Name=:Name and EO_No=:No and EO_ExType=:ExType and EO_ExID=:ExID and EO_InvalidFlag!='Y')
	if ((tmpid'="")&(tmpid'=RowID)) q -1001 
	i (+isDel=2)
	{
	  if RowID=""
	  {
	    &SQL(insert into SQLUSER.DHC_EQMExObj values:PLIST())
	  }
	  else 
	  {
	     &SQL(update SQLUSER.DHC_EQMExObj values:PLIST() where EO_RowID=:RowID)
	     i SQLCODE=100 s SQLCODE=0
	  }
	}
	i (+isDel=1)
	{
		i (RowID '="")
	       {
		       &SQL(update SQLUSER.DHC_EQMExObj set EO_InvalidFlag='Y' where EO_RowID=:RowID)
		       i SQLCODE=100 s SQLCODE=0
	      }
	}
	q SQLCODE
}

/// do ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMExObj", "ExObj", "")
/// add 输出变量TExObjLocDR,TExObjLoc by GR0002 2014-08-22
Query ExObj(Name As %String = "", No As %String = "", ExType As %String = "", ExID As %String = "", TypeDR As %String = "", Remark As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TNo:%String,TExObjLocDR:%String,TExObjLoc:%String,TExType:%String,TExID:%String,TTypeDR:%String,TRemark:%String,TInvalidFlag:%String,TType:%String,TRow:%String")
{
}

Query GetTypeBySQL(Name) As %SQLQuery(ROWSPEC = "Hidden:%String,TypeCode:%String,TypeDesc:%String")
{
	SELECT OT_RowID,OT_Code,OT_Desc from SQLUser.DHC_EQMCObjType where OT_Desc like nvl(:name,'')||'%' and OT_InvalidFlag <>'Y'
}

/// add by zx 查找维护对象表中的信息
/// 2014-02-14
/// add by zx 2017-03-20 增加简易台账过滤 BUG ZX0036
/// w ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMExObj","ShortExObj")
Query ShortExObj(ExObj As %Binary, SourceType As %String = "", vUseLocDR As %String = "", CurUserID As %String = "", CurGroupID As %String = "", FacilityFlag As %String = "") As %Query(ROWSPEC = "TName:%String:名称,HIDDEN:%String,TNo:%String:申请单号,HIDDEN:%String,TExLoc:%String:所属科室,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,TModel:%String:型号,HIDDEN:%String,TLocation:%String:存放位置,TFileNo:%String:档案号")
{
}

ClassMethod ShortExObjExecute(ByRef qHandle As %Binary, ExObj As %String = "", SourceType As %String = "", vUseLocDR As %String = "", CurUserID As %String = "", CurGroupID As %String = "", FacilityFlag As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    ;s ^DHCEQZX("ExObj")=ExObj_"^"_SourceType_"^"_vUseLocDR
    s ExObj=##Class(web.DHCEQCommon).UnEscape(ExObj)
    s ExObj=$ZCONVERT(ExObj,"U")
    s index=1
	s rowid=0
	i CurUserID="" s CurUserID = ##Class(web.DHCEQCommon).getMapIDBySource("user",##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))) 
	i CurGroupID="" s CurGroupID = %session.Get("LOGON.GROUPID")
	d BuildDataGetShortExObj
	Quit $$$OK
	
BuildDataGetShortExObj
	i SourceType'=""  d	
	.f  s rowid=$o(^DHCEQMExObj(rowid))  quit:rowid=""  d
	..d ResetVariablesGetShortExObj
	..s TRowID = rowid	
	..s TName=$p($g(^DHCEQMExObj(TRowID)),"^",1)
	..s TNo=$p($g(^DHCEQMExObj(TRowID)),"^",2) 
	..s TExLocDR=$p($g(^DHCEQMExObj(TRowID)),"^",3)
	..q:(vUseLocDR'="")&&(vUseLocDR'=TExLocDR)    //add by zx 2015-04-01
	..i TExLocDR'=""  s TExLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TExLocDR)
	..s TExType=$p($g(^DHCEQMExObj(TRowID)),"^",4) 
	..s TExID=$p($g(^DHCEQMExObj(TRowID)),"^",5)
	..s Status=0
	..i TExType=1  d	//设备 2016-05-11
	...s TModel=$p($g(^DHCEQEquip(TExID)),"^",3)
	...i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	...s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(TExID)),"^",27),"",2)
	...s TLocation=$p($g(^DHCEQEquip(TExID)),"^",72)
	...i TLocation'="" s TLocation=$p($g(^DHCEQCCode("DHCEQCLocation",TLocation)),"^",2)
	...s TFileNo=$p($g(^DHCEQEquip(TExID)),"^",85)
	...s Status=$p($g(^DHCEQEquip(TExID)),"^",38)
	..q:Status'=1
	..s TExType=##Class(web.DHCEQM.DHCEQMExObj).GetExTypeDesc(TExType)
	..s TTypeDR=$p($g(^DHCEQMExObj(TRowID)),"^",6)
	..i TTypeDR'="" s TType=$p($g(^DHCEQCCode("DHCEQMCObjType",TTypeDR)),"^",2)	
	..s TRemark=$p($g(^DHCEQMExObj(TRowID)),"^",7) 
	..s TInvalidFlag=$p($g(^DHCEQMExObj(TRowID)),"^",14) 	
	..q:TInvalidFlag="Y"
	..q:($ZCONVERT(TName,"U")'[ExObj)&(ExObj'="")
	..//q:($ZCONVERT(TInvalidFlag,"U")'[InvalidFlag)&(InvalidFlag'="")
	..//q:($ZCONVERT(TType,"U")'[Type)&(Type'="")	
	..d OutputRowGetShortExObj	
	e  d
	.i FacilityFlag="2" d
	..s UseLocDR=0
	..f  s UseLocDR=$o(^DHCEQEquip(0,"StoreLoc",UseLocDR))  q:UseLocDR=""  d   //add by zx 2015-04-01
	...q:(vUseLocDR'="")&&(vUseLocDR'=UseLocDR)
	...s rowid=0
	...f  s rowid=$o(^DHCEQEquip(0,"StoreLoc",UseLocDR,rowid))  q:rowid=""  d		//Modify DJ 2014-09-21
	....d ResetVariablesGetShortExObj
	....q:(##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(rowid)),"^",63),CurGroupID,"","2")) //modify by mwz 20200908 MWZ0043
	....d EquipListInfo
	..s rowid=0
	..f  s rowid=$o(^DHCEQEquip(0,"ClassFlag","Y",rowid))  q:rowid=""  d
	...d ResetVariablesGetShortExObj
	...q:(##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(rowid)),"^",63),CurGroupID,"","1"))
	...s UseLocDR=$p($g(^DHCEQEquip(rowid)),"^",67)
	...d EquipListInfo
	.e  d 
	..s UseLocDR=0
	..f  s UseLocDR=$o(^DHCEQEquip(0,"StoreLoc",UseLocDR))  q:UseLocDR=""  d   //add by zx 2015-04-01
	...q:(vUseLocDR'="")&&(vUseLocDR'=UseLocDR)
	...s rowid=0
	...f  s rowid=$o(^DHCEQEquip(0,"StoreLoc",UseLocDR,rowid))  q:rowid=""  d		//Modify DJ 2014-09-21
	....d ResetVariablesGetShortExObj
	....q:(##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(rowid)),"^",63),CurGroupID)) 
	....d EquipListInfo
	
	quit
	
EquipListInfo
	;Mozy	2017-5-24	修正原CheckEquipList内处理合并在EquipListInfo过程内
	s TInvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	q:TInvalidFlag="Y"
	s Status=$p($g(^DHCEQEquip(rowid)),"^",38)
	q:Status'=1
	s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	;q:'((StockStatus=1)&&(Status<=2))
	;q:(##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(rowid)),"^",63)))  //modify by mwz 20200908 MWZ0043
	s EQNo=$p($g(^DHCEQEquip(rowid)),"^",71)
	s EQName=$p($g(^DHCEQEquip(rowid)),"^",1)
	s EQCode=$p($g(^DHCEQEquip(rowid)),"^",6)
	s TFileNo=$p($g(^DHCEQEquip(rowid)),"^",85)
	q:(ExObj'="")&&(EQNo'[ExObj)&&($ZCONVERT(EQName,"U")'[ExObj)&&($ZCONVERT(EQCode,"U")'[ExObj)&&($ZCONVERT(TFileNo,"U")'[ExObj)
	s TName=EQName
	s TRowID=rowid
	s TNo=EQNo
	s TExLocDR=UseLocDR
	s TExLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", UseLocDR)
	s TExType=1
	s TExID=rowid
	s TEquipTypeDR=$p($g(^DHCEQEquip(rowid)),"^",63)
	s TTypeDR=$p($g(^DHCEQEquip(rowid)),"^",75)
	i TTypeDR'="" s TType=$p($g(^DHCEQCCode("DHCEQCStatCat",TTypeDR)),"^",2)
	s TModel=$p($g(^DHCEQEquip(rowid)),"^",3)
	i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(rowid)),"^",27),"",2)
	s TLocation=$p($g(^DHCEQEquip(rowid)),"^",72)
	i TLocation'="" s TLocation=$p($g(^DHCEQCCode("DHCEQCLocation",TLocation)),"^",2)
	Quit:(##Class(web.DHCEQCommon).CheckManageLimit(CurUserID,CurGroupID,"",TEquipTypeDR,TTypeDR,$p($g(^DHCEQEquip(rowid)),"^",4),TExLocDR,rowid,$p($g(^DHCEQEquip(rowid)),"^",7)))
	d OutputRowGetShortExObj
	
	quit
OutputRowGetShortExObj
 	s Data=$lb(TName,TRowID,TNo,TExLocDR,TExLoc,TExType,TExID,TTypeDR,TRemark,TInvalidFlag,TType,TEquipTypeDR,TModel,TOriginalFee,TLocation,TFileNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetShortExObj
	s (TName,TRowID,TNo,TExLocDR,TExLoc,TExType,TExID,TTypeDR,TRemark,TInvalidFlag,TType,TEquipTypeDR,TModel,TOriginalFee,TLocation,TFileNo)=""
	quit
}

ClassMethod ShortExObjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ShortExObjExecute ]
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

ClassMethod ShortExObjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ShortExObjExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// Add By DJ 2015-05-22
/// 描述:设备维修时如果选择来源为设备,则自动生成维护对象
ClassMethod AutoSaveExObj(vEQRowID)
{
	s Find=""
	&SQL(Select EO_RowID Into :Find From SQLUSER.DHC_EQMExObj Where EO_ExType='1' and EO_ExID=:vEQRowID and EO_InvalidFlag='N')
	i Find'="" q Find
	K EOPLIST
	s EOPLIST(2)=$p($g(^DHCEQEquip(vEQRowID)),"^",1)	//EQName
	s EOPLIST(3)=$p($g(^DHCEQEquip(vEQRowID)),"^",71)	//EQNo
	s EOPLIST(4)=$p($g(^DHCEQEquip(vEQRowID)),"^",67)	//StoreLocDR
	s EOPLIST(5)="1"
	s EOPLIST(6)=vEQRowID			//Modify DJ 2015-08-14 DJ0156
	s EOPLIST(15)="N"
	&SQL(insert into SQLUSER.DHC_EQMExObj values:EOPLIST())
	i SQLCODE q SQLCODE
	s EORowID=$Get(%ROWID)
	q EORowID		//Modfiy DJ 2015-08-14 DJ0156
}

}
