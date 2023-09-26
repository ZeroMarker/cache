/// -------------------------------
/// 修改：zy 2009-11-20   ZY0017
/// 修改方法：GetChangeStockDetail,GetChangeStock
/// 描述:增加了变动信息的打印导出功能
/// -------------------------------
/// 修改：zy 2009-07-22   zy0008
/// 修改方法：UpdateData
/// 描述:设备入库单提交时判断科室类型是否属于库房类型，不是则不能提交
/// -------------------------------
/// Update by jdl 2009-06-05 For DJ0001
/// Added Method:GetOpenCheck,SaveData
/// --------------------------------
Class web.DHCEQInStock Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 369;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "IS_RowID";

Parameter SQLDESCRIPTION = "IS_RowID";

Parameter SQLROWID = "IS_RowID";

/// -------------------------------
/// 修改：zy 2009-07-22   zy0008
/// 描述:设备入库单提交时判断科室类型是否属于库房类型，不是就返回-1004。
/// 备注:科室类型：1，库房；0，科室
/// -------------------------------
ClassMethod UpdateData(val, Type)
{
	//Type=0 新增、更新
	//Type=1 提交
	//Type=2 入库审核
	//Type=3 反提交
	//Type=4 删除
	//Type=5 账物审核
	s Date=+$H
	s RowID=$P(val,"^",1)
	s PLIST(11)=Type
	s InsertStep=##class(web.DHCEQCommon).GetSysInfo("301004")
	TSTART
	if +Type=0
	{
		s PLIST(1) = $p(val,"^",1)	;RowID
		s PLIST(2) = $p(val,"^",2)	;InDate
 		i $p(val,"^",2)'=""  s PLIST(2) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",2),"date")	;InDate
 		s PLIST(3) = $p(val,"^",3)	;LocDR
 		//s PLIST(4) = $p(val,"^",4)	;RejectReasonDR
 		s PLIST(5) = $p(val,"^",13)	;RequestUserDR
 		s PLIST(6) = Date	;RequestDate
 		//i $p(val,"^",6)'=""  s PLIST(6) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"date")	;RequestDate
 		//s PLIST(7) = $p(val,"^",7)	;AuditUserDR
 		//s PLIST(8) = $p(val,"^",8)	;AuditDate
 		//i $p(val,"^",8)'=""  s PLIST(8) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"date")	;AuditDate
 		//s PLIST(9) = $p(val,"^",9)	;RejectUserDR
 		//s PLIST(10) = $p(val,"^",10)	;RejectDate
 		//i $p(val,"^",10)'=""  s PLIST(10) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"date")	;RejectDate
 		//s PLIST(11) = $p(val,"^",11)	;Status
 		s PLIST(12) = $p(val,"^",12)	;Remark
 		s PLIST(13) = $p(val,"^",13)	;BillAuditUserDR
 		s PLIST(14) = $p(val,"^",14)	;BillAuditDate
 		i $p(val,"^",14)'=""  s PLIST(14) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",14),"date")	;BillAuditDate
 		s PLIST(15) = $p(val,"^",15)	;InStockNo
 		s PLIST(16) = $p(val,"^",16)	;OriginDR
 		s PLIST(17) = $p(val,"^",17)	;FromDeptDR
 		s PLIST(18) = $p(val,"^",18)	;ProviderDR
 		s PLIST(19) = $p(val,"^",20)	;BuyLocDR
 		s PLIST(20) = $p(val,"^",21)	;BuyUserDR
 		s PLIST(21) = $p(val,"^",22)	;EquipTypeDR
 		s PLIST(22) = $p(val,"^",23)	;StatCatDR
 		k PLIST(1)
 		if RowID=""
 		{
	 		i PLIST(15)="" s PLIST(15)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQInStock",+$H)
	 		&SQL(insert into sqluser.DHC_EQInStock values :PLIST())
	 		s RowID=$G(%ROWID)
 		}
 		else
 		{
	 		&SQL(update sqluser.DHC_EQInStock values :PLIST() where IS_RowID=:RowID)
 		}
	}
	s User=$P(val,"^",3)
	s StatCatID=$P(val,"^",5)
	if +Type=1
	{
		;Modified by ZY 2009-07-22 ZY0008
		s LocDR=$p($g(^DHCEQInStock(RowID)),"^",2)
  		i '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",1,LocDR)) q -1005   //判断入库单中的科室类型是否属于库房
		s ReturnType=..StatCatIsUniqueNew(RowID, StatCatID)
		i ReturnType<0 q ReturnType
		i ReturnType=0 s ReturnType=""
		s PLIST(22)=ReturnType
		s PLIST(5)=User
		s PLIST(6)=Date
		&SQL(update sqluser.DHC_EQInStock values :PLIST() where IS_RowID=:RowID)
	}
	if +Type=2
	{
		s ReturnType=..StatCatIsUniqueNew(RowID, StatCatID)
		i ReturnType<0 q ReturnType
		i ReturnType=0 s ReturnType=""
		s PLIST(22)=ReturnType
		s PLIST(7)=User
		s PLIST(8)=Date
		&SQL(update sqluser.DHC_EQInStock values :PLIST() where IS_RowID=:RowID)
		i SQLCODE
 		{
			TROLLBACK
			q SQLCODE
 		}
 		if InsertStep="0" d
 		.s SQLCODE=..InsertOtherData(RowID,User,Date,InsertStep)
		
	}
	if +Type=3
	{
		s PLIST(9)=User
		s PLIST(4)=$P(val,"^",2)
		s PLIST(10)=Date
		s PLIST(11)="0"
		s PLIST(12)=$P(val,"^",4)
		&SQL(update sqluser.DHC_EQInStock values :PLIST() where IS_RowID=:RowID)
	}
	if +Type=4
	{
		&SQL(delete from sqluser.DHC_EQInStockList where ISL_InStockDR=:RowID)
		i SQLCODE=100 s SQLCODE=0
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		&SQL(delete from  sqluser.DHC_EQInStock where IS_RowID=:RowID)
		
	}
	if +Type=5
	{
		s ReturnType=..StatCatIsUniqueNew(RowID, StatCatID)
		i ReturnType<0 q ReturnType
		i ReturnType=0 s ReturnType=""
		s PLIST(22)=ReturnType
		s PLIST(11)="3"
		s PLIST(13)=User
		s PLIST(14)=Date
		&SQL(update sqluser.DHC_EQInStock values :PLIST() where IS_RowID=:RowID)
		i SQLCODE
 		{
			TROLLBACK
			q SQLCODE
 		}
		s SQLCODE=..BillUpdateInvoice(RowID)
		i SQLCODE
 		{
			TROLLBACK
			q SQLCODE
 		}
 		s EquipHasIn=..EquipHasIn(RowID)
 		if (InsertStep="1")&&(EquipHasIn="0") d
 		.s SQLCODE=..InsertOtherData(RowID,User,Date,InsertStep)
 		e  d
		.s SQLCODE=..UpdateChangeStock(RowID,Date)
	}
	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	s ID=RowID
 	TCOMMIT
 	q ID
}

/// 判断入库单是否已经修改设备信息,1已修改
ClassMethod EquipHasIn(ISRowID)
{
	new ISLRowID,LocID
	i ISRowID="" q "0"
	s ISLRowID=0
	s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,0))
	i ISLRowID="" q "0"
	s LocID=0
	s LocID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,0))
	i LocID="" q "0"
	i LocID'="" q "1"
}

ClassMethod StatCatIsUnique(ISRowID, StatCatID)
{
	s ISLRowID=0
	s ReturnType=1
	s StatCatDR=StatCatID
	s StatID=""
	f  s ISLRowID=$O(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID)) q:(ISLRowID="")||(ReturnType'=1)  d
	.s EquipDR=$P(^DHCEQInStockList(ISLRowID),"^",2)
	.i EquipDR'="" d
	..s StatCat=$P(^DHCEQEquip(EquipDR),"^",75)
	..i (StatCat'="")&&(StatID="") s StatID=StatCat
	..i (StatCat'="")&&(StatID'="")&&(StatID'=StatCat) s ReturnType=2
	.q:EquipDR'=""
	.s ItemDR=$P(^DHCEQInStockList(ISLRowID),"^",16)
	.i ItemDR'="" d
	..s StatCat=$P(^DHCEQCCode("DHCEQCMasterItem",ItemDR),"^",5)
	..i (StatCat'="")&&(StatID="") s StatID=StatCat
	..i (StatCat'="")&&(StatID'="")&&(StatID'=StatCat) s ReturnType=2
	q:ReturnType=2 -1001
	q:(StatCatID'="")&&(StatID'="")&&(StatCatID'=StatID) -1002
	q:(StatCatID'="")&&(StatID="") StatCatID
	q:(StatCatID="")&&(StatID'="") StatID
	q:(StatCatID="")&&(StatID="") 0
	q StatCatID
}

ClassMethod BillUpdateInvoice(ISRowID)
{
	new ISLRowID
	s ISLRowID=0
	s SQLCODE=0
	f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID))  quit:(ISLRowID="")||SQLCODE'=0  d
	.s InvoiceID=$o(^DHCEQInvoiceUseMap(0,"Source","1",ISLRowID,0))
	.i InvoiceID'="" d 
	..s InvoiceDR=$p(^DHCEQInvoiceUseMap(InvoiceID),"^",2)
	..&SQL(update sqluser.DHC_EQInvoice set IV_Status='1' where IV_RowID=:InvoiceDR)
	q SQLCODE
}

ClassMethod UpdateChangeStock(RowID, Date)
{
	s ISLRowID=0
	s CSCode=0
	f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",RowID,ISLRowID))  quit:(ISLRowID="")||(SQLCODE'=0)  d
	.&SQL(update sqluser.DHC_EQChangeStock set CS_BillChangeDate=:Date where CS_SourceID=:ISLRowID and CS_ChangeType='0')
	.s CSCode=SQLCODE
	q CSCode
}

ClassMethod InsertAppendFee(ISLRowID, EquipID, user)
{
	s Date=+$H
	s val=""  ;AppendFeeID 1
	s val=val_"^"_EquipID ;EquipID 2
	s val=val_"^" ;AppendFeeType 3
	s val=val_"^"_$P($G(^DHCEQInStockList(ISLRowID)),"^",13) ;AppendFee 4
	s val=val_"^"_$ZD($H,4) ;occdate 5
	s val=val_"^" ;PayUserDR
	;s InvoiceInfo=##class(web.DHCEQInStockList).GetInvoiceInfo(ISLRowID)
	s val=val_"^" ;_$P(InvoiceInfo,"^",1) ;InvoiceNo
	s val=val_"^" ;_##Class(web.DHCEQCommon).TransValueFromPage($P(InvoiceInfo,"^",2),"date") ;InvoiceDate
	s val=val_"^"
	s val=val_"^^^^^^^"
	s Return=##class(web.DHCEQAppendFee).SaveData("","",val,user,"0")
	i Return>0 s Return=0
	q Return
}

ClassMethod EquipHaveInStocked(RowID)
{
	i RowID="" q 0
	s ISLRowID=0
	s Count=0
	f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",RowID,ISLRowID))  quit:ISLRowID=""  d
	.s EquipDR=$P(^DHCEQInStockList(ISLRowID),"^",2)
	.q:EquipDR=""
	.s InStockFlag=$P(^DHCEQEquip(EquipDR),"^",60)
	.q:(InStockFlag="0")&&(InStockFlag'="") 
	.s Count=Count+1
	q Count
}

ClassMethod InsertOtherData(RowID, User, Date, InsertStep)
{
	new EquipNum,OclRowID,SourceType
	s CSSQLCODE=0
	s ISLRowID=0
	f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",RowID,ISLRowID))  quit:(ISLRowID="")||(CSSQLCODE'=0)  d
	.s SourceType=$P(^DHCEQInStockList(ISLRowID),"^",18)	//SourceType 0:设备 1:设备项 2:验收单
	.i $P(^DHCEQInStockList(ISLRowID),"^",18)=2  d
	..s EquipNum=$P(^DHCEQInStockList(ISLRowID),"^",8)
	..s OclRowID=$P(^DHCEQInStockList(ISLRowID),"^",19)
	..s EQRowID=0
	..
	..f  s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",OclRowID,EQRowID))  quit:(EQRowID="")||(CSSQLCODE'=0)||(EquipNum<1)  d
	...q:$p($g(^DHCEQEquip(EQRowID)),"^",60)'="0"		//过滤已入库数据
	...
	...s CSSQLCODE=..InSertChangeStockByEquip(ISLRowID,User,Date,InsertStep,EQRowID)
	...s EquipNum=EquipNum-1
	..i EquipNum>0 s CSSQLCODE=-1006
	.else  if (SourceType=1)  d
	..s CSSQLCODE=..InsertChangeStockByBatch(ISLRowID,User,Date,InsertStep)
	.e  d
	..s CSSQLCODE=..InSertChangeStockByEquip(ISLRowID,User,Date,InsertStep)
	
	q CSSQLCODE
}

/// 批次录入的判断是否手工录入，1手工录入、0不是手工录入
ClassMethod IsInput(ISLRowID)
{
	s Flag=1
	s EquipDR=$P(^DHCEQInStockList(ISLRowID),"^",2)
	s BuyPlanListDR=$P(^DHCEQInStockList(ISLRowID),"^",4)
	i EquipDR'="" s Flag=0
	q Flag
}

ClassMethod InsertChangeStockByBatch(ISLRowID, User, Date, InsertStep)
{
	s SQLCODE=0
	s Time=$P($H,",",2)
	k EQPL,CSPLIST,EQAF
	s EQPL(71)=ISLRowID //入库明细
	s EQPL(2)=$P(^DHCEQInStockList(ISLRowID),"^",5) //设备名称
	s EQPL(27)=$P(^DHCEQInStockList(ISLRowID),"^",6) //生产厂商
	s EQPL(28)=$P(^DHCEQInStockList(ISLRowID),"^",7) //设备原值
	s EQPL(29)=$P(^DHCEQInStockList(ISLRowID),"^",7) //设备净值
	s EQPL(4)=$P(^DHCEQInStockList(ISLRowID),"^",9) //设备机型
	s EQPL(6)=$P(^DHCEQInStockList(ISLRowID),"^",10) //设备单位
	s ISRowID=$P(^DHCEQInStockList(ISLRowID),"^",1) //入库单号
	s EQPL(44)=$P(^DHCEQInStockList(ISLRowID),"^",13) //附加费用
	s EQPL(21)=$P(^DHCEQInStock(ISRowID),"^",15) //设备来源
	s EQPL(22)=$P(^DHCEQInStock(ISRowID),"^",16) //来源部门
	s EQPL(68)=$P(^DHCEQInStock(ISRowID),"^",2) //库房
	s EQPL(26)=$P(^DHCEQInStock(ISRowID),"^",17) //供应商
	s EQPL(5)=$P(^DHCEQInStockList(ISLRowID),"^",14) //设备分类
	s EQPL(32)=$P(^DHCEQInStockList(ISLRowID),"^",15) //使用年限
	s EQPL(8)=$P(^DHCEQInStockList(ISLRowID),"^",16) //设备项
	i EQPL(8)'="" s EQPL(7)=$P($G(^DHCEQCCode("DHCEQCMasterItem",EQPL(8))),"^",2) //Code
	s EQPL(39)="0" //设备状态
	s EQPL(48)="N" //直接手工录入
	s EQPL(61)="1" //库房状态
	s EQPL(60)="N" //无效标志
	s EQPL(53)=User //新增人
	s EQPL(54)=Date //新增时间
	//s EQPL(32)=##class(web.DHCEQCommon).GetSysInfo("301001")   //使用年限
	s EQPL(34)=##class(web.DHCEQCommon).GetSysInfo("301002")   //折旧方法
	s EQPL(64)=$P(^DHCEQInStock(ISRowID),"^",20) //类组
	s EQPL(76)=$P(^DHCEQInStock(ISRowID),"^",21) //设备类别
	
	//add by jdl 2009-9-16 JDL0033  TransAssetDate
	s EQPL(46)=$P(^DHCEQInStock(ISRowID),"^",1) //S_InDate
		
	s CSPLIST(5)=ISLRowID //原ID
	s CSPLIST(6)="0" //变动类型
	s CSPLIST(7)=Date
	s CSPLIST(8)=User
	s CSPLIST(9)=Date
	i InsertStep="1" d
	.s CSPLIST(10)=Date
	//s CSPLIST(3)=$P(^DHCEQInStock(ISRowID),"^",2) 
	s CSPLIST(4)=$P(^DHCEQInStock(ISRowID),"^",2) 
	s EquipNum=$P(^DHCEQInStockList(ISLRowID),"^",8) //设备数量
	s Flag=$P(^DHCEQInStockList(ISLRowID),"^",3)
	i Flag="Y"
	{
		s BPLID=$P(^DHCEQInStockList(ISLRowID),"^",4)
		i BPLID'=""
		{
			s SQLCODE=##class(web.DHCEQOpenCheck).UpdateBPLArriveNum(EquipNum,BPLID)
			if SQLCODE
			{
			 	TROLLBACK
	 			q -1003
			}
		}
	}
	For i = 1:1:EquipNum
	{
		&SQL(insert into sqluser.DHC_EQEquip values :EQPL())
		q:SQLCODE'=0
		s EQRowID=$G(%ROWID)
		d ##class(web.DHCEQEquip).UpdateEquipNo(EQRowID,+$H)	 	
		s CSPLIST(2)=EQRowID //设备
		&SQL(insert into sqluser.DHC_EQChangeStock values :CSPLIST())
		q:SQLCODE'=0
		i EQPL(44)="" s EQPL(44)=0
		i EQPL(44)'=0
		{
			s SQLCODE=..InsertAppendFee(ISLRowID,EQRowID,User)
		}
		q:SQLCODE'=0
		
	}
	q SQLCODE
}

/* 已作废，web.DHCEQCommon中有公共方法 JDL 20150902
ClassMethod GetSysInfo(code)
{
	new rowid,Info
	s Info=""
	s rowid=$o(^DHCEQCCode("DHCEQCSysSet",0,"Code",code,0))
	i rowid'="" s Info=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",2)
	q Info
}
*/
ClassMethod InSertChangeStockByEquip(ISLRowID, User, Date, InsertStep, EQRowID As %Library.String = "")
{
	k EQPL,CSPLIST
	s CSPLIST(5)=ISLRowID
	s CSPLIST(6)="0"
	s CSPLIST(7)=Date
	s CSPLIST(8)=User
	s CSPLIST(9)=Date
	i InsertStep="1" d
	.s CSPLIST(10)=Date
	s ISRowID=$P(^DHCEQInStockList(ISLRowID),"^",1) //入库单号
	//s CSPLIST(3)=$P(^DHCEQInStock(ISRowID),"^",2) 
	s CSPLIST(4)=$P(^DHCEQInStock(ISRowID),"^",2) 
	i EQRowID="" s EQRowID=$P(^DHCEQInStockList(ISLRowID),"^",2) //设备
	s CSPLIST(2)=EQRowID
	s EQPL(61)="1"
	s EQPL(71)=ISLRowID
	s DepreMehtod=##class(web.DHCEQCommon).GetSysInfo("301002")
	s OldDepreMehtod=$P(^DHCEQEquip(EQRowID),"^",33)
	i OldDepreMehtod="" s EQPL(34)=DepreMehtod
	s EQPL(68)=$P(^DHCEQInStock(ISRowID),"^",2) //库房
	s EQPL(76)=$P(^DHCEQInStock(ISRowID),"^",21) //设备类别
	s EQPL(5)=$P(^DHCEQInStockList(ISLRowID),"^",14) //设备分类
	s EQPL(32)=$P(^DHCEQInStockList(ISLRowID),"^",15) //使用年限
	s EQPL(8)=$P(^DHCEQInStockList(ISLRowID),"^",16) //设备项
	s EQPL(44)=$P(^DHCEQInStockList(ISLRowID),"^",13) //附加费用
	
	//add by jdl 2009-9-16 JDL0033  TransAssetDate
	s EQPL(46)=$P(^DHCEQInStock(ISRowID),"^",1) //S_InDate
	
	&SQL(insert into sqluser.DHC_EQChangeStock values :CSPLIST())
	q:SQLCODE'=0
	&SQL(update sqluser.DHC_EQEquip values :EQPL() where EQ_RowID=:EQRowID)
	q:SQLCODE'=0
	i EQPL(44)="" s EQPL(44)=0
	i EQPL(44)'=0
	{
		//s SQLCODE=..InsertAppendFee(ISLRowID,EQRowID,User)
		//q:SQLCODE'=0
	}
	
	q SQLCODE ;+CSCode+AFCode+LFCode
}

ClassMethod IsHaveDetail(RowID)
{
	&sql(select ISL_RowID from sqluser.DHC_EQInStockList where ISL_InStockDR=:RowID)
	q SQLCODE
}

ClassMethod GetOneInStock(rowid)
{
	new result,resultex
	s (result,resultex,LocCode)=""
	s result= ^DHCEQInStock(rowid)
	s $p(result,"^",1)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",1),"date")	;InDate
	s resultex=resultex_"^"	;LocDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",2))
	.s LocCode=$p($g(^CTLOC($p(result,"^",2))),"^",1)
	s resultex=resultex_"^"	;RejectReasonDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCRejectReason",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;RequestUserDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",4))
	s $p(result,"^",5)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")	;RequestDate
	s resultex=resultex_"^"	;AuditUserDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",6))
	s $p(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")	;AuditDate
	s resultex=resultex_"^"	;RejectUserDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",8))
	s $p(result,"^",9)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")	;RejectDate
	s resultex=resultex_"^"	;BillAuditUserDR
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",12))
	s $p(result,"^",13)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",13),"date")	;BillAuditDate
	s resultex=resultex_"^"	;OriginDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCOrigin",$p(result,"^",15))),"^",2)
	s resultex=resultex_"^"	;FromDeptDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFromToDept",$p(result,"^",16))),"^",2)
	s resultex=resultex_"^"	;ProviderDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",17))
	.//s ProviderCode=$P($G(^APC("APCVM",$p(result,"^",17))),"^",3)
	s resultex=resultex_"^"	;BuyLocDR
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",18))
	s resultex=resultex_"^"	;BuyUserDR
	i $p(result,"^",19)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",19))
	s resultex=resultex_"^"	;EquipTypeDR
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",20))),"^",2)
	s resultex=resultex_"^"	;StatCatDR
	i $p(result,"^",21)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCStatCat",$p(result,"^",21))),"^",2)
	s Total=..GetOneInStockTotalFeeNum(rowid)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex_"^"_Total_"^"_LocCode
}

Query GetInStock(QXType, LocDR, Status, StartDate, EndDate, Type) As %Query(ROWSPEC = "TRowID:%String,TInDate:%String,TLocDR:%String,TRejectReasonDR:%String,TRequestUserDR:%String,TRequestDate:%String,TAuditUserDR:%String,TAuditDate:%String,TRejectUserDR:%String,TRejectDate:%String,TStatus:%String,TRemark:%String,TBillAuditUserDR:%String,TBillAuditDate:%String,TInStockNo:%String,TOriginDR:%String,TFromDeptDR:%String,TProviderDR:%String,TLoc:%String,TRejectReason:%String,TRequestUser:%String,TAuditUser:%String,TRejectUser:%String,TBillAuditUser:%String,TOrigin:%String,TFromDept:%String,TProvider:%String,TBuyLoc:%String,TBuyUser:%String,TEquipTypeDR:%String,TEquipType:%String,TStatCatDR:%String,TStatCat:%String,TNum:%String,TFee:%String")
{
}

ClassMethod GetInStockExecute(ByRef qHandle As %Binary, QXType, LocDR, Status, StartDate, EndDate, Type) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetInStock
	Quit $$$OK
BuildDataGetInStock
	f  s rowid=$o(^DHCEQInStock(rowid))  quit:rowid=""  d
	.d ResetVariablesGetInStock
	.s TRowID = rowid
	.i StartDate="" s StartDate=0
	.i EndDate="" s EndDate=+$h
	.q:($p($g(^DHCEQInStock(rowid)),"^",1)>EndDate)||($p($g(^DHCEQInStock(rowid)),"^",1)<StartDate)
	.s TInDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(rowid)),"^",1),"date")
	.s TLocDR = $p($g(^DHCEQInStock(rowid)),"^",2)
	.q:(LocDR'="")&&(LocDR'=TLocDR)
	.q:(1=(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
	.i TLocDR '=""  d
	..s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.s TRejectReasonDR = $p($g(^DHCEQInStock(rowid)),"^",3)
	.i TRejectReasonDR '=""  d
	..s TRejectReason = $p($g(^DHCEQCCode("DHCEQCRejectReason",TRejectReasonDR)),"^",2)
	.s TRequestUserDR = $p($g(^DHCEQInStock(rowid)),"^",4)
	.i TRequestUserDR '=""  d
	..s TRequestUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
	.s TRequestDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(rowid)),"^",5),"date")
	.s TAuditUserDR = $p($g(^DHCEQInStock(rowid)),"^",6)
	.i TAuditUserDR '=""  d
	..s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	.s TAuditDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(rowid)),"^",7),"date")
	.s TRejectUserDR = $p($g(^DHCEQInStock(rowid)),"^",8)
	.i TRejectUserDR '=""  d
	..s TRejectUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TRejectUserDR)
	.s TRejectDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(rowid)),"^",9),"date")
	.s TStatus = $p($g(^DHCEQInStock(rowid)),"^",10)
	.q:(Type="1")&&(TStatus="0")
	.q:(Type="2")&&(TStatus="0")
	.q:(Type="2")&&(TStatus="1")
	.q:(Status'="")&&(Status'=TStatus)
	.s TStatus=..GetInStockStatus(TStatus)
	.s TRemark = $p($g(^DHCEQInStock(rowid)),"^",11)
	.s TBillAuditUserDR = $p($g(^DHCEQInStock(rowid)),"^",12)
	.i TBillAuditUserDR '=""  d
	..s TBillAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TBillAuditUserDR)
	.s TBillAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(rowid)),"^",13),"date")
	.s TInStockNo = $p($g(^DHCEQInStock(rowid)),"^",14)
	.s TOriginDR = $p($g(^DHCEQInStock(rowid)),"^",15)
	.i TOriginDR '=""  d
	..s TOrigin = $p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	.s TFromDeptDR = $p($g(^DHCEQInStock(rowid)),"^",16)
	.i TFromDeptDR '=""  d
	..s TFromDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",TFromDeptDR)),"^",2)
	.s TProviderDR = $p($g(^DHCEQInStock(rowid)),"^",17)
	.i TProviderDR '=""  d
	..s TProvider = ##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.s TBuyLocDR = $p($g(^DHCEQInStock(rowid)),"^",18)
	.i TBuyLocDR '=""  d
	..s TBuyLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBuyLocDR)
	.s TBuyUserDR = $p($g(^DHCEQInStock(rowid)),"^",19)
	.i TBuyUserDR '=""  d
	..s TBuyUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TBuyUserDR)
	.s TEquipTypeDR=$p($g(^DHCEQInStock(rowid)),"^",20)
	.s result=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.q:+result'=0
	.i TEquipTypeDR '=""  d
	..s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.s TStatCatDR=$p($g(^DHCEQInStock(rowid)),"^",21)
	.i TStatCatDR '=""  d
	..s TStatCat = $p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.s TTotal=..GetOneInStockTotalFeeNum(rowid)
	.s TNum=$P(TTotal,"^",1)
	.s TFee=$P(TTotal,"^",2)
	.s TFee=##Class(web.DHCEQCommon).FormatNumber(TFee,"",2)
	.d OutputRowGetInStock
	quit
OutputRowGetInStock
	s Data=$lb(TRowID,TInDate,TLocDR,TRejectReasonDR,TRequestUserDR,TRequestDate,TAuditUserDR,TAuditDate,TRejectUserDR,TRejectDate,TStatus,TRemark,TBillAuditUserDR,TBillAuditDate,TInStockNo,TOriginDR,TFromDeptDR,TProviderDR,TLoc,TRejectReason,TRequestUser,TAuditUser,TRejectUser,TBillAuditUser,TOrigin,TFromDept,TProvider,TBuyLoc,TBuyUser,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TNum,TFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStock
	s (TRowID,TInDate,TLocDR,TRejectReasonDR,TRequestUserDR,TRequestDate,TAuditUserDR,TAuditDate,TRejectUserDR,TRejectDate,TStatus,TRemark,TBillAuditUserDR,TBillAuditDate,TInStockNo,TOriginDR,TFromDeptDR,TProviderDR,TLoc,TRejectReason,TRequestUser,TAuditUser,TRejectUser,TBillAuditUser,TOrigin,TFromDept,TProvider,TBuyLocDR,TBuyLoc,TBuyUserDR,TBuyUser,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TNum,TFee)=""
	quit
}

ClassMethod GetInStockFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockExecute ]
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

ClassMethod GetInStockClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetStock(LocDR, EquipDR) As %Query(ROWSPEC = "TRowID:%String,TLocDR:%String,TEquipDR:%String,TLoc:%String,TEquip:%String")
{
}

ClassMethod GetStockExecute(ByRef qHandle As %Binary, LocDR, EquipDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetStock
	Quit $$$OK
BuildDataGetStock
	f  s rowid=$o(^DHCEQStock(rowid))  quit:rowid=""  d
	.d ResetVariablesGetStock
	.s TRowID = rowid
	.s TLocDR = $p($g(^DHCEQStock(rowid)),"^",1)
	.q:(LocDR'="")&&(LocDR'=TLocDR)
	.i TLocDR '=""  d
	..s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.s TEquipDR = $p($g(^DHCEQStock(rowid)),"^",2)
	.q:(EquipDR'="")&&(EquipDR'=TEquipDR)
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.d OutputRowGetStock
	quit
OutputRowGetStock
	s Data=$lb(TRowID,TLocDR,TEquipDR,TLoc,TEquip)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStock
	s (TRowID,TLocDR,TEquipDR,TLoc,TEquip)=""
	quit
}

ClassMethod GetStockFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStockExecute ]
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

ClassMethod GetStockClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStockExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// -------------------------------
/// 修改：zy 2009-11-20   ZY0017
/// 描述:保存查询的信息到临时Global中,为保存导出提供数据
/// -------------------------------
Query GetChangeStock(StoreLocDR, EquipDR, ChangeType, StartDate, EndDate) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TStoreLocDR:%String,TFromToLoc:%String,TSourceID:%String,TChangeType:%String,TChangeDate:%String,TAuditUserDR:%String,TAuditDate:%String,TEquip:%String,TStoreLoc:%String,TAuditUser:%String,TChangeTypeDR:%String,TParSourceID:%String,TBillChangeDate:%String,TJob:%String,TEquipNo:%String")
{
}

ClassMethod GetChangeStockExecute(ByRef qHandle As %Binary, StoreLocDR, EquipDR, ChangeType, StartDate, EndDate) As %Status
{
 	new repid, index,rowid,PNum  //Modified By ZY 2009-11-18 ZY0017
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	d ##Class(web.DHCEQCommon).KillTempGlobal("ChangeStock")  //Modified By ZY 2009-11-18 ZY0017
	s PNum=1                    //Modified By ZY 2009-11-18 ZY0017
	s index=1
	s rowid=0
	s TJob=$J
	d BuildDataGetChangeStock
	Quit $$$OK
BuildDataGetChangeStock
	f  s rowid=$o(^DHCEQChangeStock(rowid))  quit:rowid=""  d
	.d ResetVariablesGetChangeStock
	.s TRowID = rowid
	.s TEquipDR = $p($g(^DHCEQChangeStock(rowid)),"^",1)
	.q:(EquipDR'="")&&(TEquipDR'=EquipDR)
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TStoreLocDR = $p($g(^DHCEQChangeStock(rowid)),"^",2)
	.q:(StoreLocDR'="")&&(TStoreLocDR'=StoreLocDR)
	.i TStoreLocDR '=""  d
	..s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	.s TChangeType = $p($g(^DHCEQChangeStock(rowid)),"^",5)
	.s TFromToLoc = $p($g(^DHCEQChangeStock(rowid)),"^",3)
	.i TFromToLoc'="" s TFromToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TFromToLoc)  ;Modified By QW20190312 BUG:846347
	.s TSourceID = $p($g(^DHCEQChangeStock(rowid)),"^",4)
	.q:(ChangeType'="")&&(TChangeType'=ChangeType)
	.s TChangeTypeDR=TChangeType
	.s TChangeType = $CASE(TChangeType,"0":"新增入库","1":"转移","2":"退库","3":"调拨出库","4":"转让出库",:"没有定义")
	.s TParSourceID=..GetParSourceID(TChangeTypeDR,TSourceID)
	.i StartDate="" s StartDate=0
	.i EndDate="" s EndDate=+$h
	.q:($p($g(^DHCEQChangeStock(rowid)),"^",6)>EndDate)||($p($g(^DHCEQChangeStock(rowid)),"^",6)<StartDate)
	.s TChangeDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeStock(rowid)),"^",6),"date")
	.s TAuditUserDR = $p($g(^DHCEQChangeStock(rowid)),"^",7)
	.i TAuditUserDR '=""  d
	..s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	.s TAuditDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeStock(rowid)),"^",8),"date")
	.s TBillChangeDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeStock(rowid)),"^",9),"date")
	.d OutputRowGetChangeStock
	quit
OutputRowGetChangeStock
	s Data=$lb(TRowID,TEquipDR,TStoreLocDR,TFromToLoc,TSourceID,TChangeType,TChangeDate,TAuditUserDR,TAuditDate,TEquip,TStoreLoc,TAuditUser,TChangeTypeDR,TParSourceID,TBillChangeDate,TJob,TEquipNo)
	Set ^CacheTemp(repid,index)=Data
	//Add By ZY 2009-11-18 ZY0017
	Set ^DHCEQTemp("ChangeStock",+$H,TJob,PNum)=TRowID_"^"_TEquipDR_"^"_TStoreLocDR_"^"_TFromToLoc_"^"_TSourceID_"^"_TChangeType_"^"_TChangeDate_"^"_TAuditUserDR_"^"_TAuditDate_"^"_TEquip_"^"_TStoreLoc_"^"_TAuditUser_"^"_TChangeTypeDR_"^"_TParSourceID_"^"_TBillChangeDate_"^"_TEquipNo
	Set PNum=PNum+1
	//End By ZY 2009-11-18 ZY0017
	Set index=index+1
	quit
ResetVariablesGetChangeStock
	s (TRowID,TEquipDR,TStoreLocDR,TFromToLoc,TSourceID,TChangeType,TChangeDate,TAuditUserDR,TAuditDate,TEquip,TStoreLoc,TAuditUser,TChangeTypeDR,TParSourceID,TBillChangeDate,TEquipNo)=""
	quit
}

ClassMethod GetParSourceID(Type, SourceID)
{
 //现在只有新增入库
	if (Type=""||SourceID="") q ""
	if Type="0" 
	{
		if $g(^DHCEQInStockList(SourceID))="" q ""
		q $P(^DHCEQInStockList(SourceID),"^",1)
	}
	if Type="1" 
	{
		if $g(^DHCEQStoreMoveList(SourceID))="" q ""
		q $P(^DHCEQStoreMoveList(SourceID),"^",1)
	}
	if Type="2" 
	{	if $g(^DHCEQReturnList(SourceID))="" q ""
		q $P(^DHCEQReturnList(SourceID),"^",1)}
}

ClassMethod GetChangeStockFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChangeStockExecute ]
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

ClassMethod GetChangeStockClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChangeStockExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ChangeTypeList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>新增入库</option>"
	w "<option value=1>转移</option>"
	w "<option value=2>退库</option>"
	w "<option value=3>调拨出库</option>"
	w "<option value=4>转让出库</option>"
	w "</select>",!
}

ClassMethod StatusList(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	i (Type="0")||(Type="4") w "<option value=0>"_..GetInStockStatus(0)_"</option>"
	i Type'="2" w "<option value=1>"_..GetInStockStatus(1)_"</option>"
	w "<option value=2>"_..GetInStockStatus(2)_"</option>"
	;w "<option value=3>"_..GetInStockStatus(3)_"</option>"
	w "</select>",!
}

ClassMethod GetInStockStatus(Status)
{
	//q $CASE(Status,"0":"新增","1":"提交","2":"实物入库","3":"账物入库",:"没有定义")
	;q $CASE(Status,"0":"新增","1":"提交","2":"采购确认","3":"账物入库",:"没有定义")
	q $CASE(Status,"0":"新增","1":"提交","2":"审核",:"没有定义")
}

ClassMethod GetOneInStockTotalFeeNum(ISRowID)
{
	i ISRowID="" q ""
	new ISLRowID,Fee,Num
	s ISLRowID=0
	s Fee=0
	s Num=0
	f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID)) q:ISLRowID=""  d
	.s QuantityNum=$P(^DHCEQInStockList(ISLRowID),"^",8)
	.s OriginalFee=$P(^DHCEQInStockList(ISLRowID),"^",7)
	.s Fee=Fee+(QuantityNum*OriginalFee)
	.s Num=Num+QuantityNum
	i Fee=0 s Fee=""
	i Num=0 s Num=""
	q Num_"^"_Fee
}

/// 通过入库单生成转移单
/// 
ClassMethod TransInToMove(InStockId, UserID)
{
	new CurDate,RowID,InStockListID,EquipID,LocID
	if InStockId="" q ""
	s CurDate=+$H
	s StoreMoveNo=""
	TStart
	if StoreMoveNo="" s StoreMoveNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQStoreMove",+$H)
	&SQL(insert into sqluser.DHC_EQStoreMove
		(SM_StoreMoveNo,SM_FromLocDR,SM_ToLocDR,SM_MakerDR,SM_MakeDate,SM_MoveType,SM_Status,SM_EquipTypeDR,SM_StatCatDR) 
	select :StoreMoveNo,IS_LocDR,IS_BuyLocDR,:UserID,:CurDate,0,0,IS_EquipTypeDR,IS_StatCatDR from sqluser.DHC_EQInStock where IS_RowID=:InStockId)
	if SQLCODE'=0 
	{	TRollBack 
		quit SQLCODE}
	s RowID=$G(%ROWID)
	s InStockListID=0
	f  s InStockListID=$o(^DHCEQInStockList(0,"InStock",InStockId,InStockListID)) q:((InStockListID="")||(SQLCODE'=0))  d
	.s EquipID=""
	.s Qty=$p($g(^DHCEQInStockList(InStockListID)),"^",8)
	.i Qty=1  d
	..s EquipID=$p($g(^DHCEQInStockList(InStockListID)),"^",2)
	..i EquipID=""  d
	...s LocID=$o(^DHCEQEquip(0,"InStockList",InStockListID,0))
	...i LocID'=""  d
	....s EquipID=$o(^DHCEQEquip(0,"InStockList",InStockListID,LocID,0))
	.&SQL(insert into sqluser.DHC_EQStoreMoveList(SML_StoreMoveDR,SML_EquipDR,SML_BatchFlag,SML_InStockListDR,SML_EquipName,SML_ManuFactoryDR,SML_OriginalFee,SML_QuantityNum,SML_ModelDR,SML_UnitDR,SML_Remark) select :RowID,:EquipID,ISL_BatchFlag,ISL_RowID,ISL_EquipName,ISL_ManuFactoryDR,ISL_OriginalFee,ISL_QuantityNum,ISL_ModelDR,ISL_UnitDR,ISL_Remark from sqluser.DHC_EQinstocklist where ISL_RowID=:InStockListID)
	.
	if SQLCODE'=0 
	{	TRollBack 
		quit SQLCODE}
	
	TCommit
	quit RowID
}

/// 通过入库单生成其他单据
/// ToFlag：1.生成转移分配单  2.生成退货单  3.复制生成入库单
ClassMethod TransFromInStock(InStockId, UserID, ToFlag)
{
	new CurDate,RowID,InStockListID,EquipID,LocID,RequestNo
	if InStockId="" q ""
	s CurDate=+$H
	s RequestNo=""
	TStart
	i ToFlag=1
	{
		s RequestNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQStoreMove",+$H)
		&SQL(insert into sqluser.DHC_EQStoreMove
			(SM_StoreMoveNo,SM_FromLocDR,SM_ToLocDR,SM_MakerDR,SM_MakeDate,SM_MoveType,SM_Status,SM_EquipTypeDR,SM_StatCatDR) 
		select :RequestNo,IS_LocDR,IS_BuyLocDR,:UserID,:CurDate,0,0,IS_EquipTypeDR,IS_StatCatDR from sqluser.DHC_EQInStock where IS_RowID=:InStockId)
	}
	elseif ToFlag=2
	{
		s RequestNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQReturn",+$H)
		&SQL(insert into sqluser.DHC_EQReturn
			(R_ReturnNo,R_ReturnLocDR,R_MakerDR,R_MakeDate,R_ReturnDate,R_ProviderDR,R_Status,R_EquipTypeDR,R_StatCatDR,R_OutTypeDR) 
		select :RequestNo,IS_LocDR,:UserID,:CurDate,:CurDate,IS_ProviderDR,0,IS_EquipTypeDR,IS_StatCatDR,1 from sqluser.DHC_EQInStock where IS_RowID=:InStockId)
	}
	elseif ToFlag=3
	{
		s RequestNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQInStock",+$H)
		&SQL(insert into sqluser.DHC_EQInStock
			(IS_InDate,IS_LocDR,IS_RequestUserDR,IS_RequestDate,IS_Status,IS_Remark,IS_InStockNo,IS_OriginDR,IS_FromDeptDR,IS_ProviderDR,IS_BuyLocDR,IS_BuyUserDR,IS_EquipTypeDR,IS_StatCatDR) 
		select :CurDate,IS_LocDR,IS_RequestUserDR,:CurDate,0,IS_Remark,:RequestNo,IS_OriginDR,IS_FromDeptDR,IS_ProviderDR,IS_BuyLocDR,IS_BuyUserDR,IS_EquipTypeDR,IS_StatCatDR
		 from sqluser.DHC_EQInStock where IS_RowID=:InStockId)
	}
	if SQLCODE'=0 
	{	TRollBack 
		quit SQLCODE}
	s RowID=$G(%ROWID)
	s InStockListID=0
	f  s InStockListID=$o(^DHCEQInStockList(0,"InStock",InStockId,InStockListID)) q:((InStockListID="")||(SQLCODE'=0))  d
	.s EquipID=""
	.s Qty=$p($g(^DHCEQInStockList(InStockListID)),"^",8)
	.i Qty=1  d
	..s EquipID=$p($g(^DHCEQInStockList(InStockListID)),"^",2)
	..i EquipID=""  d
	...s LocID=$o(^DHCEQEquip(0,"InStockList",InStockListID,0))
	...i LocID'=""  d
	....s EquipID=$o(^DHCEQEquip(0,"InStockList",InStockListID,LocID,0))
	.s InvoiceID=$o(^DHCEQInvoiceUseMap(0,"Source",1,InStockListID,0))
	.if InvoiceID'="" s InvoiceID=$p($g(^DHCEQInvoiceUseMap(InvoiceID)),"^",2)
	.i ToFlag=1  d
	..&SQL(insert into sqluser.DHC_EQStoreMoveList(SML_StoreMoveDR,SML_EquipDR,SML_BatchFlag,SML_InStockListDR,SML_EquipName,SML_ManuFactoryDR,SML_OriginalFee,SML_QuantityNum,SML_ModelDR,SML_UnitDR,SML_Remark) select :RowID,:EquipID,ISL_BatchFlag,ISL_RowID,ISL_EquipName,ISL_ManuFactoryDR,ISL_OriginalFee,ISL_QuantityNum,ISL_ModelDR,ISL_UnitDR,ISL_Remark from sqluser.DHC_EQinstocklist where ISL_RowID=:InStockListID)
	.i ToFlag=2  d
	..&SQL(insert into sqluser.DHC_EQReturnList(RL_ReturnDR,RL_EquipDR,RL_BatchFlag,RL_InStockListDR,RL_ReturnQtyNum,RL_ReturnFee) select :RowID,:EquipID,ISL_BatchFlag,ISL_RowID,ISL_QuantityNum,ISL_OriginalFee from sqluser.DHC_EQinstocklist where ISL_RowID=:InStockListID)
	..q:SQLCODE'=0
	..i InvoiceID'=""  d
	...s IUMSourceID=$G(%ROWID)
	...&SQL(Insert into sqluser.DHC_EQInvoiceUseMap (IUM_SourceID,IUM_InvoiceDR,IUM_Type) values(:IUMSourceID,:InvoiceID,2))
	.i ToFlag=3  d
	..&SQL(Insert into sqluser.DHC_EQInStockList (ISL_InStockDR,ISL_EquipDR,ISL_BatchFlag,ISL_BuyPlanListDR,ISL_EquipName,ISL_ManuFactoryDR,ISL_OriginalFee,ISL_QuantityNum,ISL_ModelDR,ISL_UnitDR,ISL_Hold1,ISL_Remark,ISL_AppendFee,ISL_EquipCatDR,ISL_LimitYearsNum,ISL_ItemDR) select :RowID,ISL_EquipDR,ISL_BatchFlag,ISL_BuyPlanListDR,ISL_EquipName,ISL_ManuFactoryDR,ISL_OriginalFee,ISL_QuantityNum,ISL_ModelDR,ISL_UnitDR,ISL_Hold1,ISL_Remark,ISL_AppendFee,ISL_EquipCatDR,ISL_LimitYearsNum,ISL_ItemDR from sqluser.DHC_EQInStockList Where ISL_RowID=:InStockListID)
	..q:SQLCODE'=0
	..i InvoiceID'=""  d
	...s IUMSourceID=$G(%ROWID)
	...&SQL(Insert into sqluser.DHC_EQInvoiceUseMap (IUM_SourceID,IUM_InvoiceDR,IUM_Type) values(:IUMSourceID,:InvoiceID,1))
	.
	if SQLCODE'=0 
	{	TRollBack 
		quit SQLCODE}
	
	TCommit
	quit RowID
}

/// Craetor:Mozy
/// Date:2009-03-27
/// 根据入库单返回设备列表
/// w ##class(web.DHCEQInStock).GetEQRowIDByInStock(3)
ClassMethod GetEQRowIDByInStock(ISRowID)
{
	If ISRowID="" Quit 0
	New ISLRowID,CSRowID,EquipDR,Num,ResulTex
	Set ISRowID=$Get(ISRowID)
	Set ISLRowID=0
	Set CSRowID=0
	Set EquipDR=""
	Set Num=0
	Set ResulTex=""
	//^DHCEQChangeStock(0,"Source",CS_ChangeType,CS_SourceID,CS_RowID)
	For  Set ISLRowID=$Order(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID)) Quit:ISLRowID=""  Do
	.For  Set CSRowID=$Order(^DHCEQChangeStock(0,"Source",0,ISLRowID,CSRowID)) Quit:CSRowID=""  Do
	..Set EquipDR=$Piece($Get(^DHCEQChangeStock(CSRowID)),"^",1)
	..Set ResulTex=ResulTex_"^"_EquipDR
	..Set Num=Num+1
    If Num=0 Do
    .Set ResulTex=0
    Else  Do
    .Set $Piece(ResulTex,"^",1)=Num
	Quit ResulTex
}

/// Craetor:Mozy
/// Date:2009-03-27
/// 根据入库明细返回设备列表
/// w ##class(web.DHCEQInStock).GetEQRowIDByInStockList(4)
ClassMethod GetEQRowIDByInStockList(ISListRowID)
{
	If ISListRowID="" Quit 0
	New ISLRowID,CSRowID,EquipDR,Num,ResulTex
	Set ISListRowID=$Get(ISListRowID)
	Set CSRowID=0
	Set EquipDR=""
	Set Num=0
	Set ResulTex=""
	//^DHCEQChangeStock(0,"Source",CS_ChangeType,CS_SourceID,CS_RowID)
	For  Set CSRowID=$Order(^DHCEQChangeStock(0,"Source",0,ISListRowID,CSRowID)) Quit:CSRowID=""  Do
	.Set EquipDR=$Piece($Get(^DHCEQChangeStock(CSRowID)),"^",1)
	.Set ResulTex=ResulTex_"^"_EquipDR
	.Set Num=Num+1
    If Num=0 Do
    .Set ResulTex=0
    Else  Do
    .Set $Piece(ResulTex,"^",1)=Num
	Quit ResulTex
}

/// 判断入库单设备类型的唯一性 add by jdl 2009-04-13
ClassMethod StatCatIsUniqueNew(ISRowID, StatCatID)
{
	s ISLRowID=0
	s diffrentFlag=0
	s noStatCatFlag=0
	s ReturnType=1
	s ListStatCatID=""
	s StatID=""
	f  s ISLRowID=$O(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID)) q:(ISLRowID="")||(diffrentFlag=1)||(noStatCatFlag=1)  d
	.s StatCat=$P(^DHCEQInStockList(ISLRowID),"^",17)
	.i StatCat="" s noStatCatFlag=1
	.i ListStatCatID="" s ListStatCatID=StatCat
	.i StatCat'=ListStatCatID s diffrentFlag=1
		
	q:diffrentFlag=1 -1001	
	q:noStatCatFlag=1 -1004
	q:(ListStatCatID'=StatCatID)&&(StatCatID'="") -1002
	
	q ListStatCatID
}

/// DJ0001 20090514
/// 根据设备验收单,对已审核但未入库的设备进行选择自动生成入库单
/// d ##class(%ResultSet).RunQuery("web.DHCEQInStock","GetOpenCheck")
Query GetOpenCheck(ISRowID As %String = "") As %Query(ROWSPEC = "Name:%String,Total:%String,AvailableQty:%String, EquipType:%String, StatCat:%String, Vendor:%String, HIDDEN:%String, CheckDate:%String")
{
}

ClassMethod GetOpenCheckExecute(ByRef qHandle As %Binary, ISRowID As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	s groupid=%session.Get("LOGON.GROUPID")
	s vType=##class(web.DHCEQCommon).GetEquipTypesByGroup(groupid) //安全组可访问类组
	s i=$l(vType,"^")
	f  s rowid=$o(^DHCEQOpenCheckRequest(rowid)) q:rowid=""  d
	.s Count=0
	.s Status=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",20)
	.q:Status'="2" //过滤非审核状态
	.
	.s ProviderDR=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",5)
	.
	.//s CheckDate=""
	.//i $p($g(^DHCEQOpenCheckRequest(rowid)),"^",11)'="" s CheckDate=$ZD($p($g(^DHCEQOpenCheckRequest(rowid)),"^",11),3) 
	.s CheckDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckRequest(rowid)),"^",10),"date")
	.
	.s ociRowid=0
	.f  s ociRowid=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,ociRowid)) q:ociRowid=""  d
	..
	..s EquipTypeDR=$p($g(^DHCEQOpenCheckList(ociRowid)),"^",3)
	..s StatCatDR=$p($g(^DHCEQOpenCheckList(ociRowid)),"^",28)
	..
	..s EQName=$p($g(^DHCEQOpenCheckList(ociRowid)),"^",2) 				//设备名称
	..s ETDesc=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2) 	//设备类组
	..s SCDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2) 	//设备类型
	..i ProviderDR'="" s APCVMCode=##class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)			//供应商
	..//s OCRowid=rowid //设备验收单RowID
	..
	..s EquipType=""
	..s StatCat=""
	..s Provider=""
	..i ISRowID'="" d
	...s EquipType=$p($g(^DHCEQInStock(ISRowID)),"^",20)
	...s StatCat=$p($g(^DHCEQInStock(ISRowID)),"^",21)
	...s Provider=$p($g(^DHCEQInStock(ISRowID)),"^",17)
	..q:(EquipType'="")&&(EquipTypeDR'=EquipType)							//显示满足条件的当前类组数据
	..q:(StatCat'="")&&(StatCatDR'=StatCat)								//显示满足条件的当前类型数据
	..q:(Provider'="")&&(ProviderDR'=Provider) 
	..i ISRowID="" d 											//显示满足条件的所有可访问类组数据
	...f j=1:1:i d
	....s EquipType=$p(vType,"^",j)
	....i EquipTypeDR=EquipType d
	.....s Count=Count+1
	..i ISRowID="" q:Count=0
	..
	..
	..s Total=$p($g(^DHCEQOpenCheckList(ociRowid)),"^",16)
	..s AvailableQty=0
	..s FreezeQty=0
	..
	..;s EQEquipDR=0
	..;f  s EQEquipDR=$o(^DHCEQEquip(0,"OpenCheckList",ociRowid,EQEquipDR)) q:EQEquipDR=""  d
	..;.q:$p($g(^DHCEQEquip(EQEquipDR)),"^",60)'="0"		//过滤已入库数据
	..;.s AvailableQty=AvailableQty+1
 	..
 	..s AvailableQty=+..GetOpenCheckCountInfo(ociRowid)
 	..
 	..q:AvailableQty<1
 	..Do OutputRowGetOpenCheck	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowGetOpenCheck
	set Data=$lb(EQName, Total, AvailableQty, ETDesc, SCDesc, APCVMCode, ociRowid,CheckDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/*
ClassMethod GetOpenCheckExecute(ByRef qHandle As %Binary, ISRowID As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	s groupid=%session.Get("LOGON.GROUPID")
	s vType=##class(web.DHCEQCommon).GetEquipTypesByGroup(groupid) //安全组可访问类组
	s i=$l(vType,"^")
	f  s rowid=$o(^DHCEQOpenCheck(rowid)) q:rowid=""  d
	.s Count=0
	.s Status=$p($g(^DHCEQOpenCheck(rowid)),"^",9)
	.q:Status'="2" //过滤非审核状态
	.s EQEquipDR=$p($g(^DHCEQOpenCheck(rowid)),"^",1) //设备DR
	.s ISLStatus=$p($g(^DHCEQEquip(EQEquipDR)),"^",60) //过滤已入库数据
	.q:ISLStatus'="0"
	.s ISLStatus="N"
	.s ISNo=""
	.s EquipType=""
	.s StatCat=""
	.s Provider=""
	.s ISLRowid=$o(^DHCEQInStockList(0, "Equip", EQEquipDR, 0)) //设备入库明细RowID
	.i ISLRowid'="" d
	..s ISNo=$p($g(^DHCEQInStockList(ISLRowid)),"^",1)
	..s ISNo=$p($g(^DHCEQInStock(ISNo)),"^",14)
	..s ISLStatus="Y"
	.s ETDesc=$p($g(^DHCEQOpenCheck(rowid)),"^",47) 			//设备类组DR
	.i ISRowID="" d 											//显示满足条件的所有可访问类组数据
	..f j=1:1:i d
	...s EquipTypeDR=$p(vType,"^",j)
	...i ETDesc=EquipTypeDR d
	.... s Count=Count+1
	.i ISRowID="" q:Count=0
	.s SCDesc=$p($g(^DHCEQOpenCheck(rowid)),"^",49) 				//设备类型DR
	.s APCVMCode=$p($g(^DHCEQOpenCheck(rowid)),"^",43)				//供应商DR
	.i ISRowID'="" d
	..s EquipType=$p($g(^DHCEQInStock(ISRowID)),"^",20)
	..s StatCat=$p($g(^DHCEQInStock(ISRowID)),"^",21)
	..s Provider=$p($g(^DHCEQInStock(ISRowID)),"^",17)
	.q:(EquipType'="")&&(ETDesc'=EquipType)							//显示满足条件的当前类组数据
	.q:(StatCat'="")&&(SCDesc'=StatCat)								//显示满足条件的当前类型数据
	.q:(Provider'="")&&(APCVMCode'=Provider) 						//显示满足条件的当前供应商数据
	.s EQName=$p($g(^DHCEQOpenCheck(rowid)),"^",31) 				//设备名称
	.s ETDesc=$p($g(^DHCEQCCode("DHCEQCEquipType",ETDesc)),"^",2) 	//设备类组
	.s SCDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",SCDesc)),"^",2) 	//设备类型
	.i APCVMCode'="" s APCVMCode=$p($g(^APC("APCVM",APCVMCode)),"^",2) 				//供应商
	.s OCRowid=rowid //设备验收单RowID
 	.Do OutputRowGetOpenCheck	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowGetOpenCheck
	set Data=$lb(EQName, ISLStatus, ISNo, ETDesc, SCDesc, APCVMCode, OCRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}
*/
ClassMethod GetOpenCheckFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpenCheckExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod GetOpenCheckClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpenCheckExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQInStock).SaveData
ClassMethod SaveData(val As %Library.String = "", qty As %Library.String = "")
{
	k PLIST,rowid, PLISTMX
	s oclRowID=$p(val,"^",1)	
	s type=$p(val,"^",2)
	s ISID=""
	TStart
	i type=1 //增加主表和明细表
	{
		s loc=$p(val,"^",3) //库房
		s ISNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQInStock",+$H) //入库单号
		s PLIST(2)=##class(web.DHCEQCommon).TransValueFromPage($ZDate($H,4),"date") //入库日期
		i loc'=""
		{	S PLIST(3)=loc } //库房
		else
		{	S PLIST(3)=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID")) }
		s PLIST(6)=##class(web.DHCEQCommon).TransValueFromPage($ZDate($H,4),"date") //申请日期
		S PLIST(11)="0" //状态
		S PLIST(15)=ISNo
		s ocRowID=$p($g(^DHCEQOpenCheckList(oclRowID)),"^",1)
		i $p($g(^DHCEQOpenCheckRequest(ocRowID)),"^",8)'=""
		{	S PLIST(16)=$p($g(^DHCEQOpenCheckRequest(ocRowID)),"^",8)} //设备来源
		i $p($g(^DHCEQOpenCheckRequest(ocRowID)),"^",9)'=""
		{	S PLIST(17)=$p($g(^DHCEQOpenCheckRequest(ocRowID)),"^",9)} //来源部门
		S PLIST(18)=$p($g(^DHCEQOpenCheckRequest(ocRowID)),"^",5) //供应商
		S PLIST(19)=$p($g(^DHCEQOpenCheckList(oclRowID)),"^",33) //申购部门
		S PLIST(21)=$p($g(^DHCEQOpenCheckList(oclRowID)),"^",3) //设备类组
		S PLIST(22)=$p($g(^DHCEQOpenCheckList(oclRowID)),"^",28) //设备类型
		
		///add by jdl 2010-4-7 将验收的备注记录到入库单的备注
		i $p($g(^DHCEQOpenCheckRequest(ocRowID)),"^",21)'="" s PLIST(12)=$p($g(^DHCEQOpenCheckRequest(ocRowID)),"^",21)	//备注
		
		//主表
	 	&SQL(insert into sqluser.DHC_EQInStock values :PLIST())
	 	if SQLCODE
 		{
	 		TRollBack
	 		q SQLCODE
 		}
	 	s ISID=$G(%ROWID)	 	
	}
	if ISID=""	s ISID=$p(val,"^",3)
	s PLISTMX(2)=ISID
 	//s PLISTMX(3)=oclRowID //设备DR
 	s PLISTMX(4)="Y" //批入库标志
 	s PLISTMX(6)=$p($g(^DHCEQOpenCheckList(oclRowID)),"^",2) //设备名称
 	s PLISTMX(7)=$p($g(^DHCEQOpenCheckList(oclRowID)),"^",15) //生产厂家
 	s PLISTMX(8)=$p($g(^DHCEQOpenCheckList(oclRowID)),"^",17) //设备原值
 	i qty=""
 	{	s PLISTMX(9)=$p($g(^DHCEQOpenCheckList(oclRowID)),"^",16)} //数量
 	else
 	{	s PLISTMX(9)=qty }
 	s PLISTMX(10)=$p($g(^DHCEQOpenCheckList(oclRowID)),"^",5) //机型
 	s PLISTMX(11)=$p($g(^DHCEQOpenCheckList(oclRowID)),"^",7) //单位
 	s PLISTMX(15)=$p($g(^DHCEQOpenCheckList(oclRowID)),"^",6) //设备分类
 	s PLISTMX(16)=$p($g(^DHCEQOpenCheckList(oclRowID)),"^",19)
 	i PLISTMX(16)="" s PLISTMX(16)=##Class(web.DHCEQInStockList).GetYearsByEquipCat(PLISTMX(15)) //使用年限
 	s PLISTMX(17)=$p($g(^DHCEQOpenCheckList(oclRowID)),"^",9) //设备项DR
 	s PLISTMX(18)=$p($g(^DHCEQOpenCheckList(oclRowID)),"^",28) //设备类型
 	
 	s PLISTMX(19)=2 //来源类型  0:设备|1:设备项|2:验收单
 	s PLISTMX(20)=oclRowID
 	
 	&SQL(insert into sqluser.DHC_EQInStockList values :PLISTMX())
 	if SQLCODE
	{
 		TRollBack
 		q SQLCODE
	}
	s ISLRowID=$G(%ROWID)
	s InvoiceNo=""
	s InvoiceNo=$p($g(^DHCEQOpenCheckList(oclRowID)),"^",59)
 	if InvoiceNo'=""
 	{
 		s ISLRowID=$G(%ROWID)
		s SQLCODE=##Class(web.DHCEQInStockList).UpdateInvoiceInfo(ISLRowID, InvoiceNo, "", "")
 		if SQLCODE
 		{
	 		TRollBack
	 		q SQLCODE
 		}
 	}
	
	TCommit
	i type=1 q ISID
	q ISLRowID
}

/*
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
	k PLIST,rowid, PLISTMX
	s opencheckid=$p(val,"^",1)
	s type=$p(val,"^",2)
	s ISID=""
	TStart
	i type=1 //增加主表和明细表
	{
		s loc=$p(val,"^",3) //库房
		s ISNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQInStock",+$H) //入库单号
		s PLIST(2)=##class(web.DHCEQCommon).TransValueFromPage($ZDate($H,4),"date") //入库日期
		S PLIST(3)=loc //库房
		s PLIST(6)=##class(web.DHCEQCommon).TransValueFromPage($ZDate($H,4),"date") //申请日期
		S PLIST(11)="0" //状态
		S PLIST(15)=ISNo
		S PLIST(16)=$p($g(^DHCEQOpenCheck(opencheckid)),"^",41) //设备来源
		S PLIST(17)=$p($g(^DHCEQOpenCheck(opencheckid)),"^",42) //来源部门
		S PLIST(18)=$p($g(^DHCEQOpenCheck(opencheckid)),"^",43) //供应商
		S PLIST(19)=$p($g(^DHCEQOpenCheck(opencheckid)),"^",4) //申购部门
		S PLIST(21)=$p($g(^DHCEQOpenCheck(opencheckid)),"^",47) //设备类组
		S PLIST(22)=$p($g(^DHCEQOpenCheck(opencheckid)),"^",49) //设备类型
		//主表
	 	&SQL(insert into sqluser.DHC_EQInStock values :PLIST())
	 	if SQLCODE
 		{
	 		TRollBack
	 		q SQLCODE
 		}
	 	s ISID=$G(%ROWID)	 	
	}
	if ISID=""	s ISID=$p(val,"^",3)
	s PLISTMX(2)=ISID
 	s PLISTMX(3)=$p($g(^DHCEQOpenCheck(opencheckid)),"^",1) //设备DR
 	s PLISTMX(4)="N" //批入库标志
 	s PLISTMX(6)=$p($g(^DHCEQOpenCheck(opencheckid)),"^",31) //设备名称
 	s PLISTMX(7)=$p($g(^DHCEQOpenCheck(opencheckid)),"^",44) //生产厂家
 	s PLISTMX(8)=$p($g(^DHCEQOpenCheck(opencheckid)),"^",45) //设备原值
 	s PLISTMX(9)="1" //数量
 	s PLISTMX(10)=$p($g(^DHCEQOpenCheck(opencheckid)),"^",32) //机型
 	s PLISTMX(11)=$p($g(^DHCEQOpenCheck(opencheckid)),"^",34) //单位
 	s PLISTMX(15)=$p($g(^DHCEQEquip(PLISTMX(3))),"^",4) //设备分类
 	s PLISTMX(16)=##Class(web.DHCEQInStockList).GetYearsByEquipCat(PLISTMX(15)) //使用年限
 	s PLISTMX(17)=$p($g(^DHCEQOpenCheck(opencheckid)),"^",36) //设备项DR
 	s PLISTMX(18)=$p($g(^DHCEQOpenCheck(opencheckid)),"^",49) //设备类型
 	
 	&SQL(insert into sqluser.DHC_EQInStockList values :PLISTMX())
 	if SQLCODE
	{
 		TRollBack
 		q SQLCODE
	}
	s ISLRowID=$G(%ROWID)
 	s InvoiceNo=$p($g(^DHCEQOpenCheck(opencheckid)),"^",51)
 	if InvoiceNo'=""
 	{
 		s ISLRowID=$G(%ROWID)
		s SQLCODE=##Class(web.DHCEQInStockList).UpdateInvoiceInfo(ISLRowID, InvoiceNo, "", "")
 		if SQLCODE
 		{
	 		TRollBack
	 		q SQLCODE
 		}
 	}
	
	TCommit
	i type=1 q ISID
	q ISLRowID
}
*/
/// 获取批量验收明细的可入库设备数量信息
ClassMethod GetOpenCheckCountInfo(OpenCheckListID)
{
	new Total,AvailableQty,UsedQty,EquipId,RowId,LogicQty
	s Total=$p($g(^DHCEQOpenCheckList(OpenCheckListID)),"^",16)
	s AvailableQty=0	;批量验收单中尚未入库设备数量
	s UsedQty=0			;尚未审核的入库单中已经占用该验收单的设备数量
	
	s EquipId=0
	f  s EquipId=$o(^DHCEQEquip(0,"OpenCheckList",OpenCheckListID,EquipId)) q:EquipId=""  d
	.q:$p($g(^DHCEQEquip(EquipId)),"^",60)'="0"		//过滤已入库数据
	.;尚未入库设备数量
	.s AvailableQty=AvailableQty+1
	
	s RowId=""
	f  s RowId=$o(^DHCEQInStockList(0,"Source",2,OpenCheckListID,RowId)) q:RowId=""  d
	.q:$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(RowId)),"^",1))),"^",10)=3
	.;尚未审核的入库单中已经占用该验收单的设备数量
	.s UsedQty=UsedQty+$p($g(^DHCEQInStockList(RowId)),"^",8)
	
	;入库时可用的逻辑数量，为尚未入库的数量-未审核入库单占用的数量
	s LogicQty=AvailableQty-UsedQty
	i LogicQty<0 s LogicQty=0
	
	q LogicQty_"^"_Total_"^"_AvailableQty_"^"_UsedQty
}

/// -------------------------------
/// 创建：zy 2009-11-18   ZY0017
/// 描述:取到打印导出的查询信息
/// -------------------------------
ClassMethod GetChangeStockDetail(PNum, job)
{
	i PNum=0 q $o(^DHCEQTemp("ChangeStock",+$H,job,""),-1)
	q $g(^DHCEQTemp("ChangeStock",+$H,job,PNum))
}

}
