Class web.DHCEQ.Plat.DHCEQCManageLimit Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by lmm 2018-10-17
/// 描述：根据类型来控制内容的显示
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.DHCEQCManageLimit","GetValue","2","","","","off")
/// add by lmm 2019-10-29 LMM0048 增加入参 ValueIDStr:制定id串 InFlag:控制ValueIDStr是否显示标记
Query GetValue(Type As %String = "", Desc As %String = "", Equiptypestr As %String = "", ValueIDStr As %String = "", InFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TInvalidFlag:%String,TDesc:%String,TRemark:%String")
{
}

ClassMethod GetValueExecute(ByRef qHandle As %Binary, Type As %String = "", Desc As %String = "", Equiptypestr As %String = "", ValueIDStr As %String = "", InFlag As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s group=%session.Get("LOGON.GROUPID")
	;s User=%session.Get("LOGON.USERID")
	if Type="1"
	{
		s EquipTypeDR=""
		f  s EquipTypeDR=$o(^DHCEQCCode("DHCEQCGroupEquipType",0,"Group",group,EquipTypeDR))  quit:EquipTypeDR=""  d
		.d ResetVariablesGetValue
		.s invalidFlag=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",4)
		.q:invalidFlag="Y"
		.q:(InFlag="")&&(ValueIDStr'="")&&((","_ValueIDStr_",")'[(","_EquipTypeDR_","))
		.q:(InFlag'="")&&(ValueIDStr'="")&&((","_ValueIDStr_",")[(","_EquipTypeDR_","))
		.s desc=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
		.q:(Desc'="")&&(desc'[Desc)
		.s remark=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",1)
		.s rowid=EquipTypeDR
		.d OutputRowValue
	}
	if Type="2"
	{
		s equipinfo=##Class(web.DHCEQCManageLimit).Chanage(##Class(web.DHCEQCommon).GetEquipTypesByGroup(group))
		i Equiptypestr="" s Equiptypestr=equipinfo	// MZY0073	1837696		2021-04-26
		;modify by lmm 2018-05-09 begin
		s hold1str=""
		s EquipTypeDR=0
		f  s EquipTypeDR=$o(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)) q:EquipTypeDR=""  d
		.q:(0=(##Class(web.DHCEQCommon).Find(Equiptypestr,EquipTypeDR,"Y")))
		.s hold1=""
		.s hold1=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",9)
		.i hold1str=""  d
		..s hold1str=hold1
		.e  d
		..s hold1str=hold1str_","_hold1
		;modify by lmm 2018-05-09 end
		
		
		s csrowid=0
		f  s csrowid=$o(^DHCEQCCode("DHCEQCStatCat",csrowid)) q:csrowid=""  d
		.d ResetVariablesGetValue
		.s invalidFlag=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",4)
		.q:invalidFlag="Y"
		.q:(InFlag="")&&(ValueIDStr'="")&&((","_ValueIDStr_",")'[(","_csrowid_","))
		.q:(InFlag'="")&&(ValueIDStr'="")&&((","_ValueIDStr_",")[(","_csrowid_","))
		.s code=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",1)
		.s code=$e($p(code,"-",1),2,$l($p(code,"-",1)))
		.;q:(0=(##Class(web.DHCEQCommon).Find(equipinfo,code,"N")))	// MZY0073	1837696		2021-04-26	注释
		.;modify by lmm 2018-05-09 begin
		.s hold4=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",12)
		.q:(hold1str'="")&&((","_hold1str_",")'[(","_hold4_","))
		.;modify by lmm 2018-05-09 end
		.s desc=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",2)
		.s remark=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",1)
		.q:(Desc'="")&&(desc'[Desc)&&(remark'[Desc)		//Add By DJ 2017-02-17
		.s rowid=csrowid
		.d OutputRowValue
	}
	if Type="3"
	{
		s cerowid=0
		f  s cerowid=$o(^DHCEQCCode("DHCEQCEquipeCat",cerowid)) q:cerowid=""  d
		.d ResetVariablesGetValue
		.s invalidFlag=$p($g(^DHCEQCCode("DHCEQCEquipeCat",cerowid)),"^",7)
		.q:invalidFlag="Y"
		.s desc=$p($g(^DHCEQCCode("DHCEQCEquipeCat",cerowid)),"^",2)
		.s remark=$p($g(^DHCEQCCode("DHCEQCEquipeCat",cerowid)),"^",1)
		.q:(Desc'="")&&(desc'[Desc)&&(remark'[Desc)			//Add By DJ 2017-02-17
		.s rowid=cerowid
		.d OutputRowValue
	}
	if Type="4"
	{		
		s crowid=0
		f  s crowid=$o(^DHCEQCCode("DHCEQCDepartment",crowid)) q:crowid=""  d
		.d ResetVariablesGetValue
		.s invalidFlag=$p($g(^DHCEQCCode("DHCEQCDepartment",crowid)),"^",19)
		.q:'$d(^DHCEQEquip("0","UseLoc",crowid))	;过滤台账无设备的科室
		.s TName=##class(web.DHCEQCommon).GetTrakNameByID("dept",crowid)
		.s TCode=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",crowid)
		.q:(Desc'="")&&(TName'[Desc)&&(TCode'[Desc)		//Add By DJ 2017-02-17
		.s TRowID=crowid
		.d OutputRowValue
		/*  //modify by jyp 2019-10-18 CTLOC调整
		s crowid=0
		f  s crowid=$o(^CTLOC(crowid)) q:crowid=""  d
		.d ResetVariablesGetValue
		.s invalidFlag=$p($g(^CTLOC(crowid)),"^",10)
		.q:'$d(^DHCEQEquip("0","UseLoc",crowid))	;过滤台账无设备的科室
		.s desc=##Class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^CTLOC(crowid)),"^",2),"-")
		.s remark=$p($g(^CTLOC(crowid)),"^",1)
		.q:(Desc'="")&&(desc'[Desc)&&(remark'[Desc)		//Add By DJ 2017-02-17
		.s rowid=crowid
		.d OutputRowValue
		*/  //modify by jyp 2019-10-18 CTLOC调整

	}
	if Type="5"
	{
		s eqrowid=0
		f  s eqrowid=$o(^DHCEQEquip(eqrowid)) q:eqrowid=""  d
		.d ResetVariablesGetValue
		.s invalidFlag=$p($g(^DHCEQEquip(eqrowid)),"^",59)
		.q:invalidFlag="Y"
		.s desc=$p($g(^DHCEQEquip(eqrowid)),"^",1)
		.s desc=desc_","_$p($g(^DHCEQEquip(eqrowid)),"^",6)
		.s desc=desc_","_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(eqrowid)),"^",19))
		.s remark=$p($g(^DHCEQEquip(eqrowid)),"^",71)_","_$p($g(^DHCEQEquip(eqrowid)),"^",85)
		.q:(Desc'="")&&($ZCONVERT(desc,"U")'[$ZCONVERT(Desc,"U"))&&($ZCONVERT(remark,"U")'[$ZCONVERT(Desc,"U"))		//Add By DJ 2017-02-17
		.s rowid=eqrowid
		.d OutputRowValue
	}
	if Type="6"
	{
		s TEquipTypeDR=0
		f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR)) quit:TEquipTypeDR=""  d
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
		.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
		.s ItemID=0
		.f  s ItemID=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR,ItemID)) quit:ItemID=""  d
		..s invalidFlag=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",8)
		..q:invalidFlag="Y"
		..s desc = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",1)
		..s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",2)
		..q:(Desc'="")&&(($ZCONVERT(desc ,"U")'[$ZCONVERT(Desc,"U"))&&($ZCONVERT(TCode,"U")'[$ZCONVERT(Desc,"U")))
		..s remark=TCode
		..s rowid=ItemID
		..d OutputRowValue
	}
	Quit $$$OK
OutputRowValue
	set Data=$lb(rowid,invalidFlag,desc,remark)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetValue
	Set (rowid,invalidFlag,desc,remark,hold4)=""
	Quit
}

ClassMethod GetValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetValueExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetValueExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
