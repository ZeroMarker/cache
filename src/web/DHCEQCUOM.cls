Import SQLUser

/// modified by GR 2014-09-24 
/// 缺陷号3053 代码维护-设备单位-选择一条设备单位记录，直接点击【更新】按钮，提示"记录已存在，不能重复插入"
/// 修改位置Savedata()
/// -----------------------------------------------------------------------
Class web.DHCEQCUOM Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 10;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

// 设备单位

Parameter SQLDESCRIPTION = "UOM_RowID";

Parameter SQLCODE = "UOM_RowID";

Parameter SQLROWID = "UOM_RowID";

Parameter SQLFILTER = " (UOM_RowID > 0) ";

ClassMethod UOMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UOMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod UOMExecute(ByRef qHandle As %Binary, Uomtype As %String, Desc As %String, Code As %String, Remark As %String) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetUOM
	Quit $$$OK
BuildDataGetUOM
	f  s rowid=$o(^DHCEQCCode("DHCEQCUOM",rowid))  quit:rowid=""  d
	.d ResetVariablesGetUOM
	.s LTRowID = rowid	//rowid
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",5) //
	.i TInvalidFlag'="Y" d   ;add By HHM 20150831 HHM0012 ;筛选有效数据
	..s LTOmdr1=$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",1) //结果
	..;i LTOmdr1'="" s LTOmdr=$p($g(^CT("UOM",LTOmdr1)),"^",2) //结果	;Modified By jdl 20150906 v4.1.0 取消使用CT_UOM
	..s LTUomtype=$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",2) //类型
	..q:(LTUomtype'=Uomtype)&(Uomtype'="")
	..;modify by zc0096 20210121 添加单位类型 begin
	..;i LTUomtype="1" s LTUomtype="工作量单位"
	..;i LTUomtype="2" s LTUomtype="设备单位"
	..s LTUomtype=$case(LTUomtype,1:"工作量单位",2:"设备单位",3:"时长单位",4:"能耗单位",:"")
	..;modify by zc0096 20210121 添加单位类型 end
	..s LCode=$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",3) //代码  ;add By HHM 20150831 HHM0012
	..q:(LCode'[Code)&(Code'="")
	..s LDesc=$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",4) //描述  ;
	..q:(LDesc'[Desc)&(Desc'="")
	..s LRemark=$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",6) //备注 ;
	..q:(LRemark'[Remark)&(Remark'="")
	..d OutputRowGetUOM
	quit
OutputRowGetUOM
   s Data=$lb(LTRowID,LTOmdr,LTUomtype,LCode,LDesc,TInvalidFlag,LRemark,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetUOM
	s (LTRowID,LTOmdr,LTUomtype)=""
	quit
}

ClassMethod UOMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UOMExecute ]
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

/// modified by sjh sjh0042 2020-12-16 增加查询入参和过滤
Query UOM(Uomtype As %String, Desc As %String, Code As %String, Remark As %String) As %Query(ROWSPEC = "TRowID:%String,TUom:%String,TUomtype:%String,TCode:%String,TDesc:%String,TInvalidFlag:%String,TRemark:%String,TRow:%String")
{
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
	n PLIST,rowid
	s rowid=$p(val,"^",1)	
	i (+isDel=1)
	{
		&SQL(Update SQLUSER.DHC_EQCUOM set UOM_InvalidFlag='Y' where UOM_RowID=:rowid)
		;&SQL(Delete From SQLUSER.DHC_EQCUOM where UOM_RowID = :rowid)
		if SQLCODE  q SQLCODE
		q rowid
	} 
	else
	{
		;i $p(val,"^",2)'="" 
		s PLIST(2) = $p(val,"^",2)	;单位引用
		s Code= $p(val,"^",4)
		s Desc= $p(val,"^",5)
		s PLIST(3) = $p(val,"^",3)	;类型
		s UOMType= $p(val,"^",3)

		;add By HHM  20150828  HHM0012
		;添加：代码、描述、备注、无效标志
		;优化结构
		s PLIST(4)=$p(val,"^",4)   ;代码
		s PLIST(5)=$p(val,"^",5)   ;描述
		s PLIST(7)=$p(val,"^",6)   ;备注
		s PLIST(6)="N" ;
 
		&SQL(select UOM_RowID into :tmpRowID from DHC_EQCUOM where (UOM_Code=:Code and UOM_Desc=:Desc) and UOM_UOMType=:UOMType and UOM_InvalidFlag<>'Y')
		if (tmpRowID'="")&(tmpRowID'=rowid) q -3001
		i rowid=""
 		{
 			&SQL(Insert Into SQLUSER.DHC_EQCUOM Values :PLIST())		
 		} 
 		else
 		{
 			 &SQL(Update SQLUSER.DHC_EQCUOM Values :PLIST() where UOM_RowID = :rowid)  			
 		}
	}
	if SQLCODE  q SQLCODE
	Set ID=$g(%ROWID)
	q ID
}

/// /////////////////////////////////////////////////
ClassMethod GetUOMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUOMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modified By jdl 20150906 v4.1.0 单位改为存储DHC_EQCUOM表中，不再存储CT_UOM中
ClassMethod GetUOMExecute(ByRef qHandle As %Binary, desc As %String, type As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCUOM","0","UOMType",type,rowid)) q:rowid=""  d
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",5)		//Add By DJ 2016-11-30
	.q:InvalidFlag="Y"
	.s id=rowid				;s id=$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",1)
	.;q:id=""
	.s unitdesc=$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",4)			;s unitdesc=$p($g(^CT("UOM",id)),"^",2)
	.s unitcode=$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",3)			;s unitcode=$p($g(^CT("UOM",id)),"^",1)
	.q:unitdesc'[desc
 	.Do OutputRowGetGetUOM	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetGetUOM
	set Data=$lb(unitdesc,id,unitcode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetUOMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUOMExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetUOM(desc As %String, type As %String) As %Query(ROWSPEC = "UOMDesc:%String:描述,Hidden:%String,UOMCode:%String:编码")
{
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCUOM",rowid)
	s resultex=rowid
	s resultex=resultex_"^"	//结果
	;;Modified By jdl 20150906 v4.1.0 取消使用CT_UOM,直接用DHCEQCUOM
	;i $p(result,"^",1)'=""  d
	;.s resultex=resultex_$p($g(^CT("UOM",$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",1))),"^",2)
	s resultex=resultex_"^"	//类型
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",2)
	.s resultex=resultex_"^"	//单位代码
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",1)
	.s resultex=resultex_"^"_$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",3)  ;代码 add By HHM 20150831 HHM0012
	.s resultex=resultex_"^"_$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",4)  ;描述
	.s resultex=resultex_"^"_$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",6)  ;备注
	;i $p(result,"^",2)'=""  d
	q resultex
}

ClassMethod OmdrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OmdrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OmdrExecute(ByRef qHandle As %Binary, Uom As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetOmdr
	Quit $$$OK
BuildDataGetOmdr
	f  s rowid=$o(^CT("UOM",rowid))  quit:rowid=""  d
	.d ResetVariablesGetOmdr
	.s LROWID=rowid	//rowid
	.s LCODE=$p(^CT("UOM",rowid),"^",2)
	.q:(LCODE'[Uom)
	.d OutputOmdr
	quit
OutputOmdr
   s Data=$lb(LCODE,LROWID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOmdr
	s (LCODE,LROWID)=""
	quit
}

ClassMethod OmdrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OmdrExecute ]
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

Query Omdr(Uom As %String = "") As %Query(ROWSPEC = "CODE:%String,ROWID:%String")
{
}

ClassMethod Uomtype(name, width) As %String
{
	;;下拉列表
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	;modify by lmm 2019-09-05 修改下拉列表必填提示
	if (width="")||(width=0) s width=155	//modified by czf 20181211
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"px;HEIGHT:30px;;' class='hisui-combobox' data-required=true data-options="""_"prompt:"_"'必填项'"_""">"
	//w "<option value=>  </option>"
	w "<option value=1>工作量单位</option>"
	w "<option value=2>设备单位</option>"
	;modify by zc0096 20210121 添加单位类型 begin
	w "<option value=3>时长单位</option>"
	w "<option value=4>能耗单位</option>"
	;modify by zc0096 20210121 添加单位类型 end
	w "</select>",!
}

}
