/// add by HHM 20151023 HHM0027
/// add by zx 20171107 ZX0047
/// 机组维护明细
/// modified by kdf 2018-02-05 需求号：540509 ；增加输出参数：TRow
Class web.DHCEQGroupList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##Class(%ResultSet).RunQuery("web.DHCEQGroupList","GroupList","12")
Query GroupList(GroupDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TGroup:%String,TEquipDR:%String,TEquip:%String,TMainFlag:%String,TSort:%String,TRemark:%String,TFromDate:%String,TToDate:%String,TIncomeRate:%String,TExpendRate:%String,TUpdateDate:%String,TUpdateTime:%String,TUpdateUserDR:%String,TInvalidFlag:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TEuipNo:%String ,TRow:%String")
{
}

ClassMethod GroupListExecute(ByRef qHandle As %Binary, GroupDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s TRow=1
	s rowid=0
	f  s rowid=$o(^DHCEQGroupList(rowid)) q:rowid=""  d 
	.d ResetVariablesGroupList
	.s InvalidFlag=$p($g(^DHCEQGroupList(rowid)),"^",13)
	.i InvalidFlag'="Y" d
	..s TRowID=rowid
	..s TGroup=$p($g(^DHCEQGroup(GroupDR)),"^",2)
	..s TGroupDR=$p($g(^DHCEQGroupList(rowid)),"^",1)
	..i TGroupDR=GroupDR  d
	...s TEquipDR=$p($g(^DHCEQGroupList(rowid)),"^",2)
	...i TEquipDR'="" d
	....s TEquip=$P($g(^DHCEQEquip(TEquipDR)),"^",1) ;设备名称
	....s TEuipNo=$P($g(^DHCEQEquip(TEquipDR)),"^",71)
	...s TMainFlag=$p($g(^DHCEQGroupList(rowid)),"^",3) ;MainFlag
	...s TSort=$p($g(^DHCEQGroupList(rowid)),"^",4)
	...s TRemark=$p($g(^DHCEQGroupList(rowid)),"^",5)
	...s TFromDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQGroupList(rowid)),"^",6),"date")  ;FromDate
	...s TToDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQGroupList(rowid)),"^",7),"date")  ;ToDate
	...s TIncomeRate=$p($g(^DHCEQGroupList(rowid)),"^",8)  ;IncomeRate
	...s TExpendRate=$p($g(^DHCEQGroupList(rowid)),"^",9)  ;ExpendRate
	...s TUpdateDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQGroupList(rowid)),"^",10),"date") ;UpdateDate
	...s TUpdateTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQGroupList(rowid)),"^",11),"time") ;UpdateTime
	...s TUpdateUserDR=$p($g(^DHCEQGroupList(rowid)),"^",12) ;UpdateUserDR
	...s TInvalidFlag=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQGroupList(rowid)),"^",13),"bool")  ;InvalidFlag
	...s THold1=$p($g(^DHCEQGroupList(rowid)),"^",14)
	...s THold2=$p($g(^DHCEQGroupList(rowid)),"^",15)
	...s THold3=$p($g(^DHCEQGroupList(rowid)),"^",16)
	...s THold4=$p($g(^DHCEQGroupList(rowid)),"^",17)
	...s THold5=$p($g(^DHCEQGroupList(rowid)),"^",18)
	...d OutputRowGroupList
	Quit $$$OK
OutputRowGroupList
	s Data=$lb(TRowID,TGroup,TEquipDR,TEquip,TMainFlag,TSort,TRemark,TFromDate,TToDate,TIncomeRate,TExpendRate,TUpdateDate,TUpdateTime,TUpdateUserDR,TInvalidFlag,THold1,THold2,THold3,THold4,THold5,TEuipNo,TRow)
	S ^CacheTemp(repid,index)=Data
	S index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGroupList
	s (TRowID,TGroup,TEquipDR,TEquip,TMainFlag,TSort,TRemark,TFromDate,TToDate,TIncomeRate,TExpendRate,TUpdateDate,TUpdateTime,TUpdateUserDR,TInvalidFlag,THold1,THold2,THold3,THold4,THold5,TEuipNo)=""
	quit
}

ClassMethod GroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GroupListExecute ]
{
	s AtEnd=$LIST(qHandle,1)
 	s repid=$LIST(qHandle,2)
 	s ind=$LIST(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		s AtEnd=1
 		s Row=""
 		}
 	Else      {
 		s Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "")
{
	k PLIST,rowid
 	s rowid=$p(val,"^",1)
 	s SQLCODE=0
 	s MainFlag=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",4),"bool")  ;
 	s GroupDR=$p(val,"^",2)
 	s EquipDR=$p(val,"^",3)
 	
 	i (+isDel=1)
 	{
	 	&SQL(update sqluser.DHC_EQGroupList set GL_InvalidFlag='Y' where GL_RowID=:rowid)
	 	;&SQL(delete sqluser.DHC_EQGroupList where GL_RowID=:rowid)
	 	s flag=..doSort(GroupDR)
	 	i flag<0 q rowid_"^"_"序号排序错误！"
	 	i SQLCODE q rowid_"^"_SQLCODE
	 	q rowid_"^"_SQLCODE
	}
	s PLIST(2)=$p(val,"^",2) ;GroupDR
	
	;控制不能重复输入相同的设备，主设备要唯一
	s tmpid=0
	s flag=""
	s mainID=0
	f  s tmpid=$o(^DHCEQGroupList(tmpid)) q:((tmpid="")||(flag'=""))  d
	.s tmpGroupDR=$p($g(^DHCEQGroupList(tmpid)),"^",1)
	.s tmpEquipDR=$p($g(^DHCEQGroupList(tmpid)),"^",2)
	.s tmpMainFlag=$p($g(^DHCEQGroupList(tmpid)),"^",3)
	.s tmpInvalidFlag=$p($g(^DHCEQGroupList(tmpid)),"^",13)
	.q:((tmpGroupDR'=GroupDR)||(tmpInvalidFlag="Y")) ;过滤机组、无效的数据
	.i (tmpEquipDR=EquipDR) d
	..i (tmpid'=rowid) d
	...s mainID=tmpid
	...s flag="1"
	.i ((tmpMainFlag="Y")&(MainFlag="Y")) d     ;录入数据为"Y"时需要判断是否已经存在主设备
	..i (tmpid'=rowid) s flag="2"
	s Sort=$p($g(^DHCEQGroupList(mainID)),"^",4)
	i (flag="1") q rowid_"^"_"设备已录入序号为:"_Sort_" 的维护明细序中!"
	i (flag="2") q rowid_"^"_"主设备已存在!"
	
	s PLIST(3)=$p(val,"^",3) ;EquipDR
	i $p(val,"^",4)'=""  s PLIST(4) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",4),"bool") ;MainFlag
	s PLIST(5)=$p(val,"^",5) ;Sort
	s PLIST(6)=$p(val,"^",6) ;Remark
	
	;开始、结束日期必须在机组维护日期段内
	s GFromDate=$p($g(^DHCEQGroup(GroupDR)),"^",8)
	s GToDate=$p($g(^DHCEQGroup(GroupDR)),"^",9)
	s tmpFromDate=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",7),"date")
	s tmpToDate=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"date")
	i ((tmpFromDate<GFromDate)||(tmpToDate>GToDate)) q rowid_"^"_"日期段不在机组维护日期段内!"
	i (tmpFromDate>tmpToDate) q rowid_"^"_"开始日期不能大于结束日期!"
	i $p(val,"^",7)'=""  s PLIST(7) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",7),"date") ;FromDate
	i $p(val,"^",8)'="" s PLIST(8) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"date") ;ToDate
	
	;控制收入分摊比例
	s flag=""
	s IncomeRate=$p(val,"^",9)
	s flag=..SumData(GroupDR,rowid,IncomeRate) 
	i flag<0 q flag_"^"_"收入分摊比例>100!"
	
	;控制支出占比
	s ExpendRate=$p(val,"^",10) 
	i (ExpendRate>100) q rowid_"^"_"单个设备支出占比>100!"
	
	s IncomeRate=##Class(web.DHCEQCommon).FormatNumber(IncomeRate)  ;格式化数字，取2位小数点
	s ExpendRate=##Class(web.DHCEQCommon).FormatNumber(ExpendRate)  ;格式化数字，取2位小数点
	s PLIST(9)=IncomeRate ;IncomeRate
	s PLIST(10)=ExpendRate ;ExpendRate
	
 	s PLIST(11)=+$H            ;UpdateDate
	s PLIST(12)=$p($H,",",2)	;UpdateTime
	s PLIST(13)=1 ;##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))   ;UpdateUserDR
	;i $p(val,"^",14)'=""  s PLIST(14) = ..TransValueFromPage($p(val,"^",14),"bool") ;InvalidFlag
	s PLIST(15)=$p(val,"^",15)  ;Hold1
	s PLIST(16)=$p(val,"^",16)
	s PLIST(17)=$p(val,"^",17)
	s PLIST(18)=$p(val,"^",18)
	s PLIST(19)=$p(val,"^",19)  ;Hold5
	
	i rowid=""
	{
		s PLIST(14)="N"
		&SQL(insert into sqluser.DHC_EQGroupList Values:PLIST())
		s flag=..doSort(GroupDR)
	 	i flag<0 q rowid_"^"_"序号排序错误！"
	}
	else
	{
		&SQL(update sqluser.DHC_EQGroupList Values:PLIST() where GL_RowID=:rowid)
	}
	i SQLCODE q rowid_"^"_SQLCODE
	s rowid=$g(%ROWID)
	q rowid_"^"_SQLCODE
}

ClassMethod GetGroupList(rowid)
{
	s GroupList=""
	s GroupList=$g(^DHCEQGroupList(rowid))
	s InvalidFlag=$p(GroupList,"^",13)
	i InvalidFlag'="Y"  d  ;过滤无效标志的数据
	.s Info=rowid
	.s GroupDR=$p(GroupList,"^",1)
	.s Info=Info_"^"_GroupDR  ;GroupDR
	.s Info=Info_"^"_$p($g(^DHCEQGroup(GroupDR)),"^",2)  ;GroupName
	.s EquipDR=$p( GroupList,"^",2)
	.s Info=Info_"^"_EquipDR      ;EquipDR
	.s Info=Info_"^"_$p($g(^DHCEQEquip(EquipDR)),"^",1)  ;EqName
	.s Info=Info_"^"_##Class(web.DHCEQCommon).TransValueToPage($p(GroupList,"^",3),"bool")
	.s Info=Info_"^"_$p(GroupList,"^",4)  ;Sort
	.s Info=Info_"^"_$p(GroupList,"^",5)      ;Remark
	.s Info=Info_"^"_##Class(web.DHCEQCommon).TransValueToPage($p(GroupList,"^",6),"date")  ;FromDate
	.s Info=Info_"^"_##Class(web.DHCEQCommon).TransValueToPage($p(GroupList,"^",7),"date")  ;ToDate
	.s Info=Info_"^"_$p(GroupList,"^",8)  ;IncomeRate
	.s Info=Info_"^"_$p(GroupList,"^",9)  ;ExpendRate
	.s Info=Info_"^"_##Class(web.DHCEQCommon).TransValueToPage($p(GroupList,"^",10),"date") ;UpdateDate
	.s Info=Info_"^"_##Class(web.DHCEQCommon).TransValueToPage($p(GroupList,"^",11),"time") ;UpdateTime
	.s Info=Info_"^"_$p(GroupList,"^",12)    ;UpdateUserDR
	.s Info=Info_"^"_$p(GroupList,"^",13) ;InvalidFlag
	.s Info=Info_"^"_$p(GroupList,"^",14)
	.s Info=Info_"^"_$p(GroupList,"^",15)
	.s Info=Info_"^"_$p(GroupList,"^",16)
	.s Info=Info_"^"_$p(GroupList,"^",17)
	.s Info=Info_"^"_$p(GroupList,"^",18)
	q Info
}

/// 对Sort进行重新排序
/// d ##Class(web.DHCEQGroupList).doSort(2)
ClassMethod doSort(GroupDR)
{
	s tmpid=0
	s Sort=0
	f  s tmpid=$o(^DHCEQGroupList(tmpid))  q:tmpid=""  d
	.s InvalidFlag=$p($g(^DHCEQGroupList(tmpid)),"^",13)
	.s tmpGroupDR=$p($g(^DHCEQGroupList(tmpid)),"^",1)
	.q:tmpGroupDR'=GroupDR
	.i InvalidFlag'="Y"  d   ;过滤无效标志的数据
	..s Sort=Sort+1
	.. &SQL(update sqluser.DHC_EQGroupList set GL_Sort=:Sort where GL_RowID=:tmpid)
	i SQLCODE q -1
	q 0
}

/// 对收入分摊比例进行求和
/// 控制：<=100
/// w ##Class(web.DHCEQGroupList).SumData(1,'',90)
ClassMethod SumData(GroupDR, rowid, IncomeRate)
{
	s Totol=0
	s tmpid=0
	s flag=""
	f  s tmpid=$o(^DHCEQGroupList(tmpid)) q:tmpid=""  d
	.s tmpGroupDR=$p($g(^DHCEQGroupList(tmpid)),"^",1)
	.s tmpInvalidFlag=$p($g(^DHCEQGroupList(tmpid)),"^",13)
	.q:((tmpGroupDR'=GroupDR)||(tmpInvalidFlag="Y")) 
	.q:tmpid=rowid
	.s Totol=Totol+$p($g(^DHCEQGroupList(tmpid)),"^",8)
	
	s Totol=Totol+IncomeRate
	i Totol>100 q -1
	q 0
}

}
