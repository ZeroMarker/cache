Class web.DHCEQChangeInfo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modifed by ZY20221115 增加会话变量
/// Modify by Mozy 2019-09-14
/// 修改设备状态为0:在库|1:启用|2:停用|3:报废|4:其他,根据设备的状态来判断记录在库或在用
/// ChangeTypeDR:1,设备状态变动 9,其他变动
/// w ##Class(web.DHCEQChangeInfo).StopEquipBySource(31,11)
ClassMethod StopEquipBySource(SourceType, SourceID, StopFalg As %Library.String = "1", ChangeTypeDR As %Library.String = "1", WeUser As %Library.String = "")
{
	new EquipIDs,Len,SQLCODE,Reason,i
	s SQLCODE=0
	i StopFalg=1  d
	.s ToStatus=2
	e  d
	.s ToStatus=1
	If (SourceType=31)&&($Piece($Get(^DHCEQMMaintRequest(SourceID)),"^",63)=1)
	{
		s Reason="报    修"
		s EquipIDs = $Piece($Get(^DHCEQMMaintRequest(SourceID)),"^",5)
		d StopEquipList
	}
	elseif SourceType=34
	{
		s Reason="报废提交"
		s EquipIDs=##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(SourceID)
		d StopEquipList
	}
	Quit SQLCODE
StopEquipList
	s Len=$l(EquipIDs,",")
	for i=1:1:Len q:(SQLCODE'=0)  d
	.s EquipID=$p(EquipIDs,",",i)
	.s FromStatus=$P($g(^DHCEQEquip(EquipID)),"^",38)
	.q:(ChangeTypeDR=1)&&(ToStatus=FromStatus)	;状态未发生变动无需更新
	.s val="^"_EquipID_"^^"_ChangeTypeDR_"^^"_SourceType_"^"_SourceID_"^^"_FromStatus_"^"_ToStatus_"^^^^"_Reason_"^"
	.s SQLCODE=##Class(web.DHCEQChangeInfo).SaveData(val,"2",WeUser)
	q SQLCODE
}

/// modifed by ZY20221115 增加会话变量
/// 20150922  Mozy0166	增加生命周期信息
/// modified by kdf 2019-05-31 测试组需求920954 920964 在库设备不停用 增加控制参数EQStatus
/// w ##Class(web.DHCEQChangeInfo).SaveData(31,11)
ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "", WeUser As %Library.String = "")
{
	new User,Date,Time,SQLCODE,ESRowID,EquipID,ToStatus
	
	i $p(val,"^",9)="0" q 0    ;add by kdf 2019-05-31 测试组需求920954 920964
	
	s SQLCODE=0
	s ESRowID=$p(val,"^",1)
	s User=$p(val,"^",16) 
	i User="" s User=WeUser
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	k PL
	
	TSTART
	i (+isDel=1)
	{
		//Mozy		2019-9-14	无效/删除
		s PL(16)="Y"
		s PL(17)=User
		s PL(18)=Date
		s PL(19)=Time
		&SQL(Update SQLUSER.DHC_EQChangeInfo Values :PL() where CI_RowID = :ESRowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	else
	{
		s PL(2)=$p(val,"^",2)
		s EquipID=$p(val,"^",2)
		s PL(3)=$p(val,"^",3)
		s PL(4)=$p(val,"^",4)
		s PL(5)=$p(val,"^",5)
		i PL(5)="" s PL(5)=Date
		s PL(6)=$p(val,"^",6)
		s PL(7)=$p(val,"^",7)
		s PL(8)=isDel	//$p(val,"^",8) 	//Status	0,新增;1,提交;2,审核;3,作废
		s PL(9)=$p(val,"^",9)
		s PL(10)=$p(val,"^",10)
		s ToStatus=$p(val,"^",10)
		s PL(11)=$p(val,"^",11)
		s PL(12)=$p(val,"^",12)
		s PL(13)=$p(val,"^",13)
		s PL(14)=$p(val,"^",14)
		s PL(15)=$p(val,"^",15)
		s PL(16)="N"
		s PL(17)=User
		s PL(18)=Date
		s PL(19)=Time
		//s PL(20)=User
		//s PL(21)=Date
		//s PL(22)=Time
		if (+isDel=2)
		{
			s PL(23)=User
			s PL(24)=Date
			s PL(25)=Time
		}
		if (ESRowID'="")
		{
			&SQL(Update SQLUSER.DHC_EQChangeInfo Values :PL() where CI_RowID = :ESRowID)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
		else
		{
			&SQL(Insert Into SQLUSER.DHC_EQChangeInfo Values :PL())
		}
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s ChangeInfoDR=$G(%ROWID)
		k LI
		s LI(2)=EquipID  //设备
		s LI(4)=$p($g(^DHCEQEquip(EquipID)),"^",19)   	//原使用科室
		s LI(5)=$p($g(^DHCEQEquip(EquipID)),"^",17) 	//原管理科室
		s LI(6)=$p($g(^DHCEQEquip(EquipID)),"^",67)  	//原库房
		s LI(7)=$p($g(^DHCEQEquip(EquipID)),"^",27)  	//原值
		s LI(8)=$p($g(^DHCEQEquip(EquipID)),"^",28)  	//原净值
		s LI(9)=$p($g(^DHCEQEquip(EquipID)),"^",19)  	//变动后使用科室
 		s LI(10)=$p($g(^DHCEQEquip(EquipID)),"^",17) 	//变动后管理科室
 		s LI(11)=$p($g(^DHCEQEquip(EquipID)),"^",67)  	//变动后库房
 		s LI(12)=$p($g(^DHCEQEquip(EquipID)),"^",27)  	//变动后原值
 		s LI(13)=$p($g(^DHCEQEquip(EquipID)),"^",28)  	//变动后净值
 		if ToStatus=1 d
		.s LI(14)="启用" //原因
		else  d
		.s LI(14)="停用"
		s LI(16)=Date	//变动日期
		s LI(17)=Time	//变动时间
		;s LI(18)=depreFee //折旧费用
		s LI(19)="C"	//生命周期类型
		s LI(20)=41		//来源类型
		s LI(21)=ChangeInfoDR	//来源ID
		s LI(27)=User	//更新人
		s LI(28)=Date	//更新日期
		s LI(29)=Time	//更新时间
		&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		//EQ_Status	设备状态是否需要停用
		if (+isDel=2)
		{
			&SQL(Update SQLUser.DHC_EQEquip set EQ_Status=:ToStatus where EQ_RowID=:EquipID)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
	}
	TCOMMIT
	q SQLCODE
}

/// 31:维修、32保养、33检查、34报废
/// w ##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus(34,4,5,18) 
ClassMethod UpdateEquipUnusualStatus(EquipIDs, UnusualStatus, Remark)
{
	new Len,i,EquipID,SQLCODE
	s SQLCODE=0
	s Len=$l(EquipIDs,",")
	for i=1:1:Len q:(SQLCODE'=0)  d
	.s EquipID=$p(EquipIDs,",",i)
	.q:SQLCODE'=0
	.&SQL(Update SQLUser.DHC_EQEquip Set EQ_AdvanceDisFlag=:UnusualStatus,EQ_Hold1=:Remark where EQ_RowID=:EquipID)
	q SQLCODE
}

/// w ##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus()
ClassMethod GetEquipUnusualStatus(status As %Library.String) As %Status
{
	i status=""  q ""
	i +status=1  q "报废提交"
	i +status=2  q "预 报 废"
	i +status=3  q "报    修"
	i +status=4  q "受    理"
	i +status=6  q "无维修价值,建议报废"   // Modefied by zc 2022-4-8
	q "未定义"
}

ClassMethod StopStatusList(name, width, type) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")   //hisui改造 add by lmm 2018-08-18
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	i type=2 w "<option value=1>启用</option>"
	i type<2 w "<option value=2>停用</option>"
	w "</select>",!
}

/// 20150922  Mozy0166
/// 调整表结构的索引
/// d ##class(%ResultSet).RunQuery("web.DHCEQChangeInfo","GetEquipStopList","47","","Y")
Query GetEquipStopList(EquipID, StartFlag, StopFlag, CIRowID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TStatus:%String,TFromStatus:%String,TToStatus:%String,TApproveListDR:%String,TReason:%String,TRemark:%String,TUpdateUser:%String,TUpdateDate:%String,TSourceTypeDR:%String,TFromStatusDR:%String,TToStatusDR:%String,TRow:%String")
{
}

ClassMethod GetEquipStopListExecute(ByRef qHandle As %Binary, EquipID, StartFlag, StopFlag, CIRowID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i EquipID="" Quit $$$OK
 	
	s index=1
	s ChangeTypeDR=0
	f  s ChangeTypeDR=$o(^DHCEQChangeInfo(0,"EquipChangeType",EquipID,ChangeTypeDR))  quit:ChangeTypeDR=""  d
	.s SourceType=""
	.f  s SourceType=$o(^DHCEQChangeInfo(0,"EquipChangeType",EquipID,ChangeTypeDR,SourceType))  quit:SourceType=""  d
	..s SourceTypeid=""
	..f  s SourceTypeid=$o(^DHCEQChangeInfo(0,"EquipChangeType",EquipID,ChangeTypeDR,SourceType,SourceTypeid))  quit:SourceTypeid=""  d
	...s rowid=""
	...f  s rowid=$o(^DHCEQChangeInfo(0,"EquipChangeType",EquipID,ChangeTypeDR,SourceType,SourceTypeid,rowid))  quit:rowid=""  d
	....d ResetVariablesGetEquipStopList
	....q:(CIRowID'="")&&(CIRowID'=rowid)
	....s TRowID = rowid
	....s DataList=$G(^DHCEQChangeInfo(rowid))
	....q:$p(DataList,"^",15)="Y"
	....s TGroupDR = $p(DataList,"^",2)
	....i TGroupDR '="" s TGroup = $p($g(^DHCEQGroup(TGroupDR)),"^",2)
	....s TChangeTypeDR = $p(DataList,"^",3)
	....i TChangeTypeDR '=""  s TChangeType = $p($g(^DHCEQCCode("DHCEQCChangeType",TChangeTypeDR)),"^",2)
	....i TChangeTypeDR'=""   s LFChangeTypeidDR=$p($g(^DHCEQCCode("DHCEQCChangeType",TChangeTypeDR)),"^",4)
	....s TSourceTypeDR = $p(DataList,"^",5)
	....s TSourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(TSourceTypeDR)
	....i TSourceTypeDR="" d
	.....s TSourceType="手动修改"
	....s TSourceID = $p(DataList,"^",6)
	....s TStatus = $p(DataList,"^",7)
	....s TStatus = $Case(TStatus,"0":"新增","1":"提交","2":"审核","":"未定义")
	....s TFromStatusDR = $p(DataList,"^",8)
	....s TFromStatus =##Class(web.DHCEQEquip).GetEquipStatusDisplay(TFromStatusDR)
	....s TToStatusDR = $p(DataList,"^",9)
	....q:(StartFlag="Y")&&(TToStatusDR'="1")
	....q:(StopFlag="Y")&&(TToStatusDR'="2")
	....s TToStatus =##Class(web.DHCEQEquip).GetEquipStatusDisplay(TToStatusDR)
	....s TFromOther = $p(DataList,"^",10)
	....s TToOther = $p(DataList,"^",11)
	....s TApproveListDR = $p(DataList,"^",12)
	....s TReason = $p(DataList,"^",13)
	....s TRemark = $p(DataList,"^",14)
	....s TUpdateUserDR = $p(DataList,"^",16)
	....s TUpdateUser =##Class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	....s TUpdateDate = $p(DataList,"^",17)_","_$p(DataList,"^",18)
	....;s TUpdateDate = $ZDT(TUpdateDate,3)  ////日期格式同意调整 add by 吴月
	....s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage(TUpdateDate,"date")
	....s TSubmitUserDR = $p(DataList,"^",19)
	....s TSubmitUser =##Class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	....s TSubmitDate = $p(DataList,"^",20)_","_$p(DataList,"^",21)
	....;s TSubmitDate = $ZDT(TSubmitDate,3)  ////日期格式同意调整 add by 吴月
	....s TSubmitDate = ##Class(web.DHCEQCommon).TransValueToPage(TSubmitDate,"date")
	....s TAuditUserDR = $p(DataList,"^",22)
	....s TAuditUser =##Class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	....s TAuditDate = $p(DataList,"^",23)_","_$p(DataList,"^",24)
	....;s TAuditDate = $ZDT(TAuditDate,3) ////日期格式同意调整 add by 吴月
	....s TAuditDate =##Class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")
	....d OutputRowGetEquipStopList
	Quit $$$OK
OutputRowGetEquipStopList
	Set TRow=index
	Set Data=$lb(TRowID,TSourceType,TSourceID,TStatus,TFromStatus,TToStatus,TApproveListDR,TReason,TRemark,TUpdateUser,TUpdateDate,TSourceTypeDR,TFromStatusDR,TToStatusDR,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipStopList
	s (DataList,TRowID,TSourceType,TSourceID,TStatus,TFromStatus,TToStatus,TApproveListDR,TReason,TRemark,TUpdateUser,TUpdateUserDR,TUpdateDate,TSourceTypeDR,TFromStatusDR,TToStatusDR,TRow)=""
	quit
}

ClassMethod GetEquipStopListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipStopListExecute ]
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

ClassMethod GetEquipStopListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipStopListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQChangeInfo).NeedChange(SourceID)
ClassMethod NeedChange(SourceType, SourceID, StopFalg As %Library.String = "1", ChangeTypeDR As %Library.String = "1")
{
	new Flag,EquipIDs,Len,i
	s Flag=0
	i StopFalg=1  d
	.s ToStatus=2
	e  d
	.s ToStatus=1
	If (SourceType=31)&&($Piece($Get(^DHCEQMMaintRequest(SourceID)),"^",63)=1)
	{
		s EquipIDs = $Piece($Get(^DHCEQMMaintRequest(SourceID)),"^",5)
		d CheckEquipList
	}
	elseif SourceType=34
	{
		s EquipIDs=##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(SourceID)
		d CheckEquipList
	}
	Quit Flag
CheckEquipList
	s Len=$l(EquipIDs,",")
	for i=1:1:Len q:(Flag=1)  d
	.s EquipID=$p(EquipIDs,",",i)
	.q:(ChangeTypeDR=1)&&(ToStatus=$P($g(^DHCEQEquip(EquipID)),"^",38))	;状态未发生变动无需更新
	.s Flag=1
	Quit
}

}
