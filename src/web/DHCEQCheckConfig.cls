Class web.DHCEQCheckConfig Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 32;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CC_RowID";

Parameter SQLDESCRIPTION = "CC_RowID";

Parameter SQLROWID = "CC_RowID";

ClassMethod UpdateConfig(val, AppType)
{
	//+AppType=0 插入、更新
	//+AppType=2 删除
	s Date=+$H
	s Time=$P($H,",",2)
	s PLIST(1) = $p(val,"^",1)	;RowID
	s RowID=PLIST(1)
	s PLIST(2) = $p(val,"^",2)  ;ContractListDR
 	s PLIST(3) = $p(val,"^",3)	;ConfigItemDR
 	s PLIST(4) = $p(val,"^",4)	;Value
 	s PLIST(5) = $p(val,"^",5)	;Remark
 	s PLIST(6) = $p(val,"^",6)	;Status
 	i $p(val,"^",6)="" s PLIST(6)="0" //新增配置
 	i $p(val,"^",6)="2" s PLIST(6)="1"  //修改配置
 	s PLIST(7) = $p(val,"^",7)	;UpdateUserDR
 	s PLIST(8) = Date
 	s PLIST(9) = Time
 	/*s PLIST(8) = $p(val,"^",8)	;UpdateDate
 	i $p(val,"^",8)'=""  s PLIST(8) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"date")	;UpdateDate
 	s PLIST(9) = $p(val,"^",9)	;UpdateTime
 	s PLIST(10) = $p(val,"^",10)	;AuditUserDR
 	s PLIST(11) = $p(val,"^",11)	;AuditDate
 	i $p(val,"^",11)'=""  s PLIST(11) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"date")	;AuditDate
 	s PLIST(12) = $p(val,"^",12)	;AuditTime*/
 	k PLIST(1)
 	TSTART
 	if (+AppType=0)
	{
 		i RowID=""
 		{
			&sql(insert into sqluser.DHC_EQCheckConfig values :PLIST())
 		}
 		else
 		{
			&sql(update sqluser.DHC_EQCheckConfig values :PLIST() where CC_RowID=:RowID)
 		}
 	}
	if (+AppType=2)
	{
		&SQL(delete from sqluser.DHC_EQCheckConfig where CC_RowID=:RowID)
	}
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s ID=$G(%ROWID)
 	TCOMMIT
	q ID
}

Query GetCheckConfig(ContractListDR) As %Query(ROWSPEC = "TRowID:%String,TContractListDR:%String,TConfigItemDR:%String,TValue:%String,TRemark:%String,TStatus:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TConfigItem:%String,TUpdateUser:%String")
{
}

ClassMethod GetCheckConfigExecute(ByRef qHandle As %Binary, ContractListDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetConfig
	Quit $$$OK
BuildDataGetConfig
	f  s rowid=$o(^DHCEQCheckConfig(rowid))  quit:rowid=""  d
	.d ResetVariablesGetConfig
	.s TRowID = rowid
	.s TContractListDR = $p($g(^DHCEQCheckConfig(rowid)),"^",1)
	.q:ContractListDR'=TContractListDR
	.i TContractListDR '=""  d
	..s TContractList = $p($g(^DHCEQEquip(TContractListDR)),"^",1)
	.s TConfigItemDR = $p($g(^DHCEQCheckConfig(rowid)),"^",2)
	.i TConfigItemDR '=""  d
	..s TConfigItem = $p($g(^DHCEQCCode("DHCEQCConfigItem",TConfigItemDR)),"^",2)
	..s Unit=$p($g(^DHCEQCCode("DHCEQCConfigItem",TConfigItemDR)),"^",5)
	.s TValue = $p($g(^DHCEQCheckConfig(rowid)),"^",3)_" "_Unit
	.s TRemark = $p($g(^DHCEQCheckConfig(rowid)),"^",4)
	.s TStatus = $p($g(^DHCEQCheckConfig(rowid)),"^",5)
	.s TStatus = ..TransStatusTopage(TStatus)
	.s TUpdateUserDR = $p($g(^DHCEQCheckConfig(rowid)),"^",6)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCheckConfig(rowid)),"^",7),"date")
	.s TUpdateTime = $p($g(^DHCEQCheckConfig(rowid)),"^",8)
	.d OutputRowGetConfig
	quit
OutputRowGetConfig
	s Data=$lb(TRowID,TContractListDR,TConfigItemDR,TValue,TRemark,TStatus,TUpdateUserDR,TUpdateDate,TUpdateTime,TConfigItem,TUpdateUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetConfig
	s (Unit,TRowID,TContractListDR,TConfigItemDR,TValue,TRemark,TStatus,TUpdateUserDR,TUpdateDate,TUpdateTime,TConfigItem,TUpdateUser)=""
	quit
}

ClassMethod GetCheckConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCheckConfigExecute ]
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

ClassMethod GetCheckConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCheckConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod TransStatusTopage(Status)
{
	q $Case(Status,"0":"新增","1":"修改","2":"提交",:"没有定义")
}

ClassMethod GetOneConfig(rowid)
{
	s result= ^DHCEQCheckConfig(rowid)
	s Unit=$p($g(^DHCEQCCode("DHCEQCConfigItem",$p(result,"^",2))),"^",5)
	q result_Unit
}

}
