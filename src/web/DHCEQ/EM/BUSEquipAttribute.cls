Class web.DHCEQ.EM.BUSEquipAttribute Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// ----------------------------------
/// 创建:JYP  2019-09-02 
/// 描述:通过JSON对象保存相关来源的设备属性，用于设备界面设备属性按钮
/// 	入参:SourceType:来源类型ID(1:设备项,2:验收单,3:设备,4:合同)
/// 		 SourceID:对应来源ID
/// 		 DataList:JSON串
/// w ##Class(web.DHCEQ.EM.BUSEquipAttribute).SaveEquipAttribute("1","1","")
/// ----------------------------------
ClassMethod SaveEquipAttribute(SourceType, SourceID, DataList)
{
	new (SourceType,SourceID, DataList)
	i DataList="" q 0
	i SourceID="" q -1
	s Flag=0
	s EALRowIDs=""
	s Length=$l(DataList,"&")
	for DataListLength=1:1:Length
	{
		s index=DataListLength
		s valList=	$p(DataList,"&",DataListLength)
		s EALRowID=..SaveEquipAttributeList(SourceType,SourceID,valList)
		if EALRowID<"0"
		{
			s Flag=EALRowID
		}
		else{
			if EALRowID=""
			{
				s EALRowIDs=EALRowID
			}
			else
			{
				s EALRowIDs=EALRowIDs_","_EALRowID
			}
		}
	}
	s EALRowID=0
	///modified by ZY0208 设置效益属性同时写DHC_EQBenefitEquipList
	s SQLCODE=0
	f  s EALRowID=$o(^DHCEQEquipAttributeList(0,"SourceID",SourceType,SourceID,EALRowID))  quit:(EALRowID="")||(SQLCODE'=0)  d //modefied by ZY0206 写效益分析属性的时候,再DHC_EQBenefitEquipList表中写记录
	.i (","_EALRowIDs_",")'[(","_EALRowID_",") d
	..s deleteFlag=1
	..s EARowID=$p($g(^DHCEQEquipAttributeList(EALRowID)),"^",1)
	..i EARowID'=""  d
	...s EACode=$p($g(^DHCEQCCode("DHCEQCEquipAttribute",EARowID)),"^",1)
	...i (EACode="41")&&(SourceType="3") d
	....s BELRowID=$o(^DHCEQBenefitEquipList(0,"Equip",SourceID,0))
	....i (BELRowID'="") d
	.....i $p($g(^DHCEQBenefitEquipList(BELRowID)),"^",2)="" d
	......&SQL(delete from SQLUSER.DHC_EQBenefitEquipList where BEL_RowID = :BELRowID)
	.....e  d
	......s deleteFlag=0
	..i deleteFlag=0 d
	...s SQLCODE="-1"
	..e  d
	...&SQL(delete from SQLUSER.DHC_EQEquipAttributeList where EAL_RowID = :EALRowID)
	i SQLCODE="-1" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"设备已经有效益分析数据,不能去掉属性")
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
}

/// ----------------------------------
/// 创建:JYP  2019-09-02 
/// 描述:通过JSON对象保存相关来源的设备属性，用于设备界面设备属性按钮,保存对应的一个设备属性。
/// 	入参:SourceType:来源类型ID(1:设备项,2:验收单,3:设备,4:合同)
/// 		 SourceID:对应来源ID
/// 		 valList:JSON串
/// w ##Class(web.DHCEQ.EM.BUSEquipAttribute).SaveEquipAttributeList("1","1","{EALCode:01,EALEquipAttributeDR:1,EALFlag:Y,EALRowID:,EALRemark:,EALName:计量设备}")
/// ----------------------------------
ClassMethod SaveEquipAttributeList(SourceType, SourceID, valList)
{
	k PLIST,EALRowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQEquipAttributeList",JsonData,.PLIST)
	s EALRowID = JsonData.%Get("EALRowID")  //modify by jyp 2019-08-26
	//modify by jyp 2019-08-26
	if (JsonData.%Get("EALFlag")'="Y")
	{
		q "-1"
	}
	s PLIST(3)=SourceType
	s PLIST(4)=SourceID
	if (EALRowID="")
	{
		&SQL(Insert Into SQLUSER.DHC_EQEquipAttributeList Values :PLIST())
		i SQLCODE 
		{
			q SQLCODE
		}
		else
		{
			s EALRowID=$G(%ROWID)
		}
	}
	else
	{
		&SQL(update sqluser.DHC_EQEquipAttributeList values :PLIST() where EAL_RowID=:EALRowID)
	}
	//add by ZY0208 写效益分析属性的时候,再DHC_EQBenefitEquipList表中写记录
	i SQLCODE
	{
		q SQLCODE
	}
	
	s EARowID=$p($g(^DHCEQEquipAttributeList(EALRowID)),"^",1)
	i EARowID'=""
	{
		s EACode=$p($g(^DHCEQCCode("DHCEQCEquipAttribute",EARowID)),"^",1)
		i (EACode="41")&&(SourceType="3")
		{
			i $Data(^DHCEQBenefitEquipList(0,"Equip",SourceID))=0
			{
				&SQL(Insert Into SQLUSER.DHC_EQBenefitEquipList set BEL_EquipDR=:SourceID)
				i SQLCODE
				{
					q SQLCODE
				}
			}
		}
	}
	q EALRowID
}

/// ----------------------------------
/// 创建:JYP  2019-09-02 
/// 描述:用于获取一个来源的设备属性。
/// 	入参:SourceType:来源类型ID(1:设备项,2:验收单,3:设备,4:合同)
/// 		 SourceID:对应来源ID
/// 		 ItemFlag:判断是否要取对应设备项的设备属性(暂时未用到)
/// Modify by zx 2020-02-21 BUG ZX0077 增加属性分类
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSEquipAttribute","GetEquipAttributeListData","1","1844")
/// ----------------------------------
Query GetEquipAttributeListData(SourceType As %String = "", SourceID As %String = "", ItemFlag As %String = "") As %Query(ROWSPEC = "TRow:%String,EALRowID:%String,EALEquipAttributeDR:%String,EALCode:%String,EALName:%String,EALFlag:%String,EALRemark:%String,EALSubInfo:%String,EALSubInfoDesc:%String")
{
}

ClassMethod GetEquipAttributeListDataExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", ItemFlag As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	// MZY0023	1306895		2020-05-08
 	i SourceID="" Quit $$$OK
	s index=1
	s TRow=0

	s EquipAttributeList=##class(web.DHCEQCommon).GetSysInfo("990065")
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCEquipAttribute",rowid)) quit:rowid=""  d
	.;q:(SourceType=4)&&($p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",2)'="计量设备")	// MZY0023	1306895		2020-05-08	合同只显示'计量设备'属性 modify by zyq 2023-03-30
	.q:($p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",5)="Y")
	.d ResetVariablesGetEquipAttributeListData
	.s EALGroup = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",3)
	.q:((","_EquipAttributeList_",")'[(","_EALGroup_","))
	.s EARowID = rowid
	.s EALCode = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",1)
	.s EALName = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",2)
	.s Lrowid=0
	.f  s Lrowid=$o(^DHCEQEquipAttributeList(0,"AttributeSource",EARowID,SourceType,SourceID,Lrowid)) quit:Lrowid=""  d
	..i ItemFlag="" s EALRowID=Lrowid
	..s EALRemark = $p($g(^DHCEQEquipAttributeList(Lrowid)),"^",5) ;Modify by zx 2020-02-21 BUG ZX0077
	..s EALflag="Y"
	..;Modify by zx 2020-02-21 BUG ZX0077
	..s EALSubInfo=$p($g(^DHCEQEquipAttributeList(Lrowid)),"^",4)
	..i EALSubInfo'="" s EALSubInfoDesc=$p($g(^DHCEQCCode("DHCEQCInHospitalType",EALSubInfo)),"^",2)
	.d OutputRowGetEquipAttributeListData
	
	Quit $$$OK
OutputRowGetEquipAttributeListData
	Set TRow=TRow+1
	Set Data=$lb(TRow,EALRowID,EARowID,EALCode,EALName,EALflag,EALRemark,EALSubInfo,EALSubInfoDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
ResetVariablesGetEquipAttributeListData
	Set (EALRowID,EARowID,EALCode,EALName,EALflag,EALRemark,EALSubInfo,EALSubInfoDesc)=""
	quit
}

ClassMethod GetEquipAttributeListDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipAttributeListDataExecute ]
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

ClassMethod GetEquipAttributeListDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipAttributeListDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// ----------------------------------
/// 创建:JYP  2019-09-02 
/// 描述:把对应id的验收单的设备属性存入该验收单的一台设备中
/// 	入参:SourceType:来源类型ID(1:设备项,2:验收单,3:设备,4:合同),常规为2
/// 		 OpenCheckListID:验收单ID
/// 		 EquipID:设备ID
/// W ##CLASS(web.DHCEQ.EM.BUSEquipAttribute).SaveEquipAttributeByOpenCheckList(2,29,153)
/// ----------------------------------
ClassMethod SaveEquipAttributeByOpenCheckList(SourceType, OpenCheckListID, EquipID)
{
	&SQL(insert into sqluser.DHC_EQEquipAttributeList (EAL_EquipAttributeDR,EAL_SourceType,EAL_SourceID) select EAL_EquipAttributeDR,'3',:EquipID from sqluser.DHC_EQEquipAttributeList WHERE EAL_SourceType=:SourceType AND EAL_SourceID=:OpenCheckListID)
	q SQLCODE
}

/// ----------------------------------
/// 创建:JYP  2019-09-02 
/// 描述:检查一个来源类型下的来源是否具有该组内的属性
/// 	入参:SourceType:来源类型ID(1:设备项,2:验收单,3:设备,4:合同)
/// 		 SourceID:对应来源ID
/// 		 GroupID:组代码
/// W ##CLASS(web.DHCEQ.EM.BUSEquipAttribute).GetOneEquipAttributeGroup("3",27,"01")
/// ----------------------------------
ClassMethod GetOneEquipAttributeGroup(SourceType, SourceID, GroupID)
{
	s EALflag=0
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCEquipAttribute",0,"Group",GroupID,rowid)) quit:rowid=""  d
	.s Lrowid=0
	.f  s Lrowid=$o(^DHCEQEquipAttributeList(0,"AttributeSource",rowid,SourceType,SourceID,Lrowid)) quit:Lrowid=""  d
	..s EALflag=1	
	q EALflag
}

/// ----------------------------------
/// 创建:JYP  2019-09-02 
/// 描述:获得一个来源类型下的来源具有的属性
/// 	入参:SourceType:来源类型ID(1:设备项,2:验收单,3:设备,4:合同)
/// 		 SourceID:对应来源ID
/// 		 GroupID:组代码
/// 		返回值：id1^id2^id100
/// W ##CLASS(web.DHCEQ.EM.BUSEquipAttribute).GetOneEquipAttribute("3",27,"01")
/// ----------------------------------
ClassMethod GetOneEquipAttribute(SourceType, SourceID)
{
	s IDString=""
	s Lrowid=0
	f  s Lrowid=$o(^DHCEQEquipAttributeList(0,"SourceID",SourceType,SourceID,Lrowid)) quit:Lrowid=""  d
	.s EquipAttributeDR=$p($g(^DHCEQEquipAttributeList(Lrowid)),"^",1)
	.;s EACode=$p($g(^DHCEQCCode("DHCEQCEquipAttribute",EquipAttributeDR)),"^",1)
	.if IDString=""  d
	..s IDString="id"_EquipAttributeDR
	.e  d
	..s IDString=IDString_"^id"_EquipAttributeDR
	
	q IDString
}

/// ----------------------------------
/// 创建:JYP  2019-09-02 
/// 描述:通过id串保存相关来源的设备属性，用于设备界面设备属性按钮
/// 	入参:SourceType:来源类型ID(1:设备项,2:验收单,3:设备,4:合同)
/// 		 SourceID:对应来源ID
/// 		 DataList:id1^id2^id100
/// w ##Class(web.DHCEQ.EM.BUSEquipAttribute).SaveOpenCheckEquipAttribute("2","35","id1")
/// ----------------------------------
ClassMethod SaveOpenCheckEquipAttribute(SourceType, SourceID, DataList)
{
	new (SourceType,SourceID, DataList)
	i SourceID="" q -1
	s Length=$l(DataList,"^")
	i DataList'=""		//modify by wl 2020-03-17 WL0064 非设备属性界面调设备保存方法设备属性会清空
	{
	&SQL(delete from SQLUSER.DHC_EQEquipAttributeList where EAL_SourceType = :SourceType and EAL_SourceID= :SourceID)
	}
	// add by sjh SJH0035 2020-09-22 START 
	i ((DataList="")&&((SourceType=1)||(SourceType=2))) 
	{
		&SQL(delete from SQLUSER.DHC_EQEquipAttributeList where EAL_SourceType = :SourceType and EAL_SourceID= :SourceID)
	}
	// add by sjh SJH0035 2020-09-22 END 
	s EALRowID=0
	if (DataList'="")
	{
		for DataListLength=1:1:Length
		{
			s index=DataListLength
			s valList=	$p(DataList,"^",DataListLength)
			s EALRowID=..SaveOpenCheckEquipAttributeList(SourceType,SourceID,valList)
			q:EALRowID<0
		}
	}
	if (EALRowID<0)
	{
		q EALRowID
	}else
	{
		q 0
	}
}

/// ----------------------------------
/// 创建:JYP  2019-09-02 
/// 描述:通过id串保存相关来源的设备属性，用于设备界面设备属性按钮,保存对应的一个设备属性
/// 	入参:SourceType:来源类型ID(1:设备项,2:验收单,3:设备,4:合同)
/// 		 SourceID:对应来源ID
/// 		 valList:"id1"
/// w ##Class(web.DHCEQ.EM.BUSEquipAttribute).SaveOpenCheckEquipAttributeList("1","1","{EALCode:01,EALEquipAttributeDR:1,EALFlag:Y,EALRowID:,EALRemark:,EALName:计量设备}")
/// ----------------------------------
ClassMethod SaveOpenCheckEquipAttributeList(SourceType, SourceID, valList)
{
	;Modify by zx 2020-02-21 BUG ZX0077 保存时增加属性分类
	k PLIST,EALRowID,ListInfo,EALSubInfo
	;s EARowID =$p(valList,"id",2)
	s ListInfo=$p(valList,"id",2)
	s EARowID=$p(ListInfo,"&",1)
	s EALSubInfo=$p(ListInfo,"&",2)
	s PLIST(2)=EARowID
	s PLIST(3)=SourceType
	s PLIST(4)=SourceID
	s PLIST(5)=EALSubInfo

	&SQL(Insert Into SQLUSER.DHC_EQEquipAttributeList Values :PLIST())
	i SQLCODE 
	{
		q SQLCODE
	}
	s EALRowID=$G(%ROWID)
	
	q EALRowID
}

/// Creator：      JYP
/// CreatDate：    2019-08-31
/// Description:   检查一个来源类型下的来源是否具有该属性  
/// Input：        SourceType:来源类型ID(1:设备项,2:验收单,3:设备,4:合同)
/// 				   SourceID：来源ID
/// 				   AttributeDR：设备属性ID
/// Return：       有：1，没有0
/// w ##Class(web.DHCEQ.EM.BUSEquip).GetOneEquip(1)
/// 检查一个SourceType来源类型(1:设备项,2:验收单,3:设备)下的设备是否具有该属性
/// w ##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttribute("3","156","11")
ClassMethod CheckEquipHaveAttribute(SourceType, SourceID, AttributeCode)
{
	s EALflag=0
	s EARowid=0
	f  s EARowid=$o(^DHCEQCCode("DHCEQCEquipAttribute",0,"Code",AttributeCode,EARowid)) quit:EARowid=""  d
	.s Lrowid=0
	.f  s Lrowid=$o(^DHCEQEquipAttributeList(0,"AttributeSource",EARowid,SourceType,SourceID,Lrowid)) quit:Lrowid=""  d
	..s EALflag=1	
	q EALflag
}

/// Creator：      JYP
/// CreatDate：    2019-08-31
/// Description:   检查一个来源类型下的来源是否具有计量属性  
/// Input：        SourceType:来源类型ID(1:设备项,2:验收单,3:设备,4:合同)
/// 				   SourceID：来源ID
/// 				   AttributeDR：设备属性ID
/// Return：       有：Y，没有:N
/// w ##Class(web.DHCEQ.EM.BUSEquip).GetOneEquip(1)
/// 检查一个SourceType来源类型(1:设备项,2:验收单,3:设备)下的设备是否具有该属性
/// w ##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeYN(rowid)
ClassMethod CheckEquipHaveAttributeYN(Rowid)
{
	IF (##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttribute("3",Rowid,"11")="1") Q "Y"
	ELSE  Q "N"
}

/// Creator：      CSJ
/// CreatDate：    2020-03-25
/// Description:   检查一个来源类型下的来源是否属于某分组 需求号：1238377
/// Input：        AttributeGroup:分组code
/// 			   SourceType:来源类型ID(1:设备项,2:验收单,3:设备,4:合同)
/// 			   SourceID：来源ID
/// Return：       Y:属于 N:不属于
/// Modified By CSJ 2020-03-30 修改错误
/// w ##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("01","3","40")
ClassMethod CheckEquipHaveAttributeGroup(AttributeGroup, SourceType, SourceID)
{
	s Groupflag="N"
	s Lrowid=0
	f  s Lrowid=$o(^DHCEQEquipAttributeList(0,"SourceID",SourceType,SourceID,Lrowid)) quit:(Lrowid="")||(Groupflag="Y")  d
	.s EADR=$p($g(^DHCEQEquipAttributeList(Lrowid)),"^",1)
	.s EARowid=0
	.f  s EARowid=$o(^DHCEQCCode("DHCEQCEquipAttribute",0,"Group",AttributeGroup,EARowid)) q:(EARowid="")||(Groupflag="Y")  d
	..i EARowid=EADR s Groupflag="Y"
	q Groupflag
}

/// 创建:lmm  2020-05-07
/// 描述:通过id串保存相关来源的设备属性，用于设备界面设备属性按钮
/// 	入参:SourceType:来源类型ID(1:设备项,2:验收单,3:设备)
/// 		 SourceID:对应来源ID
/// 		 DataList:id1^id2^id100
/// w ##Class(web.DHCEQ.EM.BUSEquipAttribute).SaveSourIDInfoEquipAttribute("3","21^23","id1&")
/// ----------------------------------
ClassMethod SaveSourIDInfoEquipAttribute(SourceType, SourceIDInfo, DataList, AttributeCode As %String = "")
{
	new (SourceType,SourceIDInfo, DataList,AttributeCode) ;Modified By QW20211224
	i SourceIDInfo="" q -1
	
	;Modified By QW20211224 begin
	i (AttributeCode'="")&&(DataList="")
	{
		s EARowid=0
		f  s EARowid=$o(^DHCEQCCode("DHCEQCEquipAttribute",0,"Code",AttributeCode,EARowid)) quit:EARowid=""  d
		.q:$p($g(^DHCEQCCode("DHCEQCEquipAttribute",EARowid)),"^",5)="Y"
		.s DataList="id"_EARowid_"&"
	}
	;Modified By QW20211224 end
	s Length=$l(SourceIDInfo,"^")

	s EALRowID=0
	if (SourceIDInfo'="")
	{
		for SourceIDInfoLength=1:1:Length
		{
			s SourceID=	$p(SourceIDInfo,"^",SourceIDInfoLength)
			//modify by lmm 2020-05-14 重复添加数据问题解决
		 	s EquipAttributeListID=""
		 	//modify by lmm 2021-06-07 	1827319
		 	s EquipAttributestr=$p(DataList,"&",SourceIDInfoLength)
		 	s EquipAttributeDR=$p(EquipAttributestr,"id",2)
		 	if (EquipAttributeDR'="")
		 	{
			 	&SQL(select EAL_RowID into :EquipAttributeListID from SQLUSER.DHC_EQEquipAttributeList where EAL_SourceType = :SourceType and EAL_SourceID=:SourceID and EAL_EquipAttributeDR=:EquipAttributeDR)
			}
			else
			{
			 	&SQL(select EAL_RowID into :EquipAttributeListID from SQLUSER.DHC_EQEquipAttributeList where EAL_SourceType = :SourceType and EAL_SourceID=:SourceID)
			}
			if (EquipAttributeListID="")
			{
				s EALRowID=..SaveOpenCheckEquipAttributeList(SourceType,SourceID,DataList)
				q:EALRowID<0
			}
		}
	}
	if (EALRowID<0)
	{
		q EALRowID
	}else
	{
		q 0
	}
}

/// 创建:lmm  2020-05-14
/// 描述:通过id串删除相关来源的设备属性
/// 	入参:SourceType:来源类型ID(1:设备项,2:验收单,3:设备)
/// 		 SourceID:对应来源ID
/// w ##Class(web.DHCEQ.EM.BUSEquipAttribute).DeleteEquipAttribute("1","21^23")
/// ----------------------------------
ClassMethod DeleteEquipAttribute(SourceType, SourceIDInfo, DataList)
{
	new (SourceType,SourceIDInfo, DataList)
	i SourceIDInfo="" q -1
	s Length=$l(SourceIDInfo,"^")

	s EALRowID=0
	if (SourceIDInfo'="")
	{
		for SourceIDInfoLength=1:1:Length
		{
			s SourceID=	$p(SourceIDInfo,"^",SourceIDInfoLength)
			&SQL(delete from SQLUSER.DHC_EQEquipAttributeList where EAL_SourceType = :SourceType and EAL_SourceID=:SourceID)

			q:EALRowID<0
		}
	}
	if (EALRowID<0)
	{
		q EALRowID
	}else
	{
		q 0
	}
}

}
