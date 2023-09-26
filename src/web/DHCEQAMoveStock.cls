/// Created By HZY 2012-11-05	HZY0035
/// Desc:配件转移
Class web.DHCEQAMoveStock Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter GlobalLen = 34;

ClassMethod SaveData(val, valList, DelRowid)
{
	new RowID
	k PLIST
	Set $ZT="ERRORSave"
	s Date=+$H
	s Time=$P($H,",",2)
	//RowID,AccessoryTypeDR,FromLocDR,ToLocDR,MoveType,ReciverDR,Remark,LOGON.USERID,CancelToFlowDR,ApproveSetDR,Job
	s RowID = $p(val,"^",1)	;RowID
	s User=$p(val,"^",8)
	s PLIST(3) = $p(val,"^",2)	;AccessoryTypeDR
	s PLIST(5) = $p(val,"^",3)	;FromLocDR
	s PLIST(6) = $p(val,"^",4)	;ToLocDR
	s PLIST(15) = $p(val,"^",5)	;MoveType
	s PLIST(16) = $p(val,"^",6)	;ReciverDR
	s PLIST(25) = ""
	s PLIST(29) = "0"			;Status
	s PLIST(30) = $p(val,"^",7)	;Remark
	Set PLIST(31) = "N"			;Hold1	Mozy0189	2017-5-26	自动建单未编辑标志
	s Job = $p(val,"^",11) 		;job

	TSTART
	if RowID=""
	{
		s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQAMoveStock",+$H,"",$p(val,"^",2))	// Mozy	2016-10-21
		s PLIST(7) = User			;MakerDR
		s PLIST(8) = Date			;MakeDate
		s PLIST(9) = Time  			;MakeTime
		&SQL(insert into sqluser.DHC_EQAMoveStock values :PLIST())
	}
	else
	{
		i $g(^DHCEQAMoveStock(RowID,"NoInfo"))="" s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQAMoveStock",+$H,"",$p(val,"^",2))	// Mozy	2016-10-21
		&SQL(update sqluser.DHC_EQAMoveStock values :PLIST() where AMS_RowID=:RowID)
	}
	s RowID=$G(%ROWID)
	Set ^DHCEQAMoveStock(RowID,"NoInfo")=$p($g(^DHCEQAMoveStock(RowID)),"^",1)		;Mozy	转移单号存储(维修配件)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
		
 	s Flag=..JudgeAMSLQuantityNum(RowID,Job,valList)
 	i Flag
 	{
		TROLLBACK
		q Flag
 	}
 	s SQLCODE=..DeleteAMoveStockList(RowID,DelRowid)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	s SQLCODE=..SaveAMoveStockList(RowID,Job,valList)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	// 检查配件是否已经被其他单据占用
 	s result=..CheckOrder(RowID)
 	i result
 	{
		TROLLBACK
		q result
 	}
 	
 	TCOMMIT
 	q RowID
ERRORSave 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// 描述:判断按序列号转移的配件数量与选择的RowIDs是否一致
/// w ##Class(web.DHCEQAMoveStock).JudgeAMSLQuantityNum("13","2780","1^^1^PJLZ^配件1^^41^1^false^true^50^1^50^^34^^^^")
ClassMethod JudgeAMSLQuantityNum(AMSRowID, Job, val)
{
	new (AMSRowID, Job, val)
	i AMSRowID="" q -1
	i val="" q 0
	s Flag=0
	s StoreLocDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",4)		;StoreLocDR
	s MoveType=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",14)		;MoveType
	s Length=$l(val,"&")
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=$p(val,"&",i)
		i ("true"'=$p(valList,"^",10))	continue //过滤掉不是按序列号管理的配件qw0005-2014-06-03
		s index=$p(valList,"^",1)  		//index
		s AMSLRowID=$p(valList,"^",2)  	//AMSLRowID
		s StockDetailDR=$p(valList,"^",15)
		; Modify by :qw0005 2014-06-03 
		; 序列号管理
		if ($p(valList,"^",12)=1)
		{			
			if AMSLRowID=""  //新增明细
			{
				s ^TEMPEQ("AMXList","EX",Job,index)=$p(valList,"^",15)
			}
			else
			{
				s ^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs")=$p(valList,"^",15)
				k ^TEMPEQ("AMXList",Job,AMSLRowID)
			}		
			//continue //单台设备不处理
		}
		else
		{
			;Modify by :QW0005 2014-5-8原为8，改为12
			s QuantityNum=$p(valList,"^",12)  	;SML_TQuantityNum=1序列号管理非批量所以不适用以下判断：需累加
	 		s RowIDs=""
			s Len=0
	 		if AMSLRowID=""  //新增明细
	 		{
		 			s RowIDs=$g(^TEMPEQ("AMXList","EX",Job,index))
	 		}
	 		else
	 		{
			 		s RowIDs=$g(^TEMPEQ("AMXList",Job,AMSLRowID))
		 		; 当InStockListDR相同时,才取原来的rowids
	 			i (RowIDs="") s RowIDs=$g(^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs"))
		 	}
		 	if RowIDs'="" s Len=$l(RowIDs,",")
		 	if (Len'=QuantityNum)
		 	{
			 	s Flag=##Class(web.DHCEQUpdateAccessoryByList).GetRowIDsByQuantityNum(StockDetailDR,QuantityNum,AMSLRowID,StoreLocDR,Job,index,"1") 	//Modify DJ 2014-09-10
			}
			else
			{
				if (AMSLRowID'="")&&($Data(^TEMPEQ("AMXList",Job,AMSLRowID)))
				{
					s ^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs")=$g(^TEMPEQ("AMXList",Job,AMSLRowID))
					k ^TEMPEQ("AMXList",Job,AMSLRowID)
				}
			}
		}
	}
	q Flag
}

ClassMethod DeleteAMoveStockList(AMSRowID, DelRowid)
{
	new Length,AMSLRowID,Flag,i
	s Flag=0
	i AMSRowID="" q -1
	i DelRowid="" q 0
	s Length=$l(DelRowid,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s AMSLRowID=$p(DelRowid,",",i)
		if (AMSLRowID>0)
		{
			&SQL(delete from  sqluser.DHC_EQAMoveStockList where AMSL_RowID=:AMSLRowID)
			i SQLCODE 
			{
				s Flag=AMSLRowID_"^删除操作失败!"
			}
			else
			{
				k ^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs")
			}
		}
	}
	q Flag
}

ClassMethod SaveAMoveStockList(AMSRowID, Job, val)
{
	new (AMSRowID, Job, val)
	i AMSRowID="" q -1
	i val="" q 0
	s Flag=0
	s PLISTMX(2)=AMSRowID
	s Length=$l(val,"&")
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=$p(val,"&",i)
		s index=$p(valList,"^",1)  			;index
		s AMSLRowID=$p(valList,"^",2)  		;AMSL_RowID
		s PLISTMX(2)=AMSRowID				;AMSL_MoveStockDR
		s PLISTMX(3)=$p(valList,"^",3)  	;AMSL_ItemDR
		s PLISTMX(4)=$p(valList,"^",4)		;AMSL_Code
		s PLISTMX(5)=$p(valList,"^",5)		;AMSL_Desc
		s PLISTMX(6)=$p(valList,"^",6)		;AMSL_Model
		s PLISTMX(7)=$p(valList,"^",7)  	;AMSL_BaseUOMDR
		s PLISTMX(8)=$p(valList,"^",8)  	;AMSL_ManuFactoryDR
		i $p(valList,"^",9)="true" d
		.s PLISTMX(9)="Y"  					;AMSL_BatchFlag
		e  d
		.s PLISTMX(9)="N"
		i $p(valList,"^",10)="true" d
		.s PLISTMX(10)="Y"  				;AMSL_SerialFlag
		e  d
		.s PLISTMX(10)="N"
		s PLISTMX(11)=$p(valList,"^",11)  	;AMSL_Price
		s PLISTMX(12)=$p(valList,"^",12)  	;AMSL_QuantityNum
		s PLISTMX(13)=$p(valList,"^",13)  	;AMSL_Amount
		s PLISTMX(14)=$p(valList,"^",14)  	;AMSL_Remark
		s PLISTMX(15)=$p(valList,"^",15)  	;AMSL_StockDetailDR
		/// 2017-2-7	Mozy	调整配件出库明细表结构
		; TAInStockListDR+"^"+TEquipDR+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5;
		s PLISTMX(16)=$p(valList,"^",16)  	;AMSL_AISListDR
 		s PLISTMX(17)=$p(valList,"^",17)	;AMSL_EquipDR
 		;s PLISTMX(18)=$p(valList,"^",18)	;AMSL_MaintPartDR
 		s PLISTMX(19)=$p(valList,"^",18)	;AMSL_Hold1
		s PLISTMX(20)=$p(valList,"^",19)  	;AMSL_Hold2
		s PLISTMX(21)=$p(valList,"^",20)  	;AMSL_Hold3
		s PLISTMX(22)=$p(valList,"^",21)  	;AMSL_Hold4
		s PLISTMX(23)=$p(valList,"^",22)  	;AMSL_Hold5
		//检查明细与总单的类组是否相同
		s result=..AccessoryTypeIsUnique(AMSRowID,PLISTMX(15))
		i result 
		{
			s Flag=index_"^明细与总单的类组不相同,更新明细记录失败!"
			q
		}
		if (AMSLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQAMoveStockList Values :PLISTMX())
			i SQLCODE 
			{
				s Flag=index_"^更新明细记录失败!"
				q
			}
			s AMSLRowID=$G(%ROWID)
			//qw0005-2014-06-03
 			if ($p(valList,"^",10)="true")  //序列号管理
			{
	 			i $d(^TEMPEQ("AMXList","EX",Job,index))
	 			{
		 			s ^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs")=$g(^TEMPEQ("AMXList","EX",Job,index))
		 		}
		 		else
		 		{
			 		s ^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs")=$g(^TEMPEQ("AMXList",Job,AMSLRowID))
			 	}
 			}
		}
		else
		{
			&SQL(update sqluser.DHC_EQAMoveStockList values :PLISTMX() where AMSL_RowID=:AMSLRowID)
		}
		
		i SQLCODE s Flag=index_"^更新明细记录失败!"
	}
	q Flag
}

/// 检查明细与总单的类组是否相同
ClassMethod AccessoryTypeIsUnique(AMSRowID, ASDRowID)
{
	s AMSaccessoryTypeDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",2)
	s AMSLAccessoryTypeDR=$p($g(^DHCEQAStockDetail(ASDRowID)),"^",11)
	if (AMSaccessoryTypeDR=AMSLAccessoryTypeDR)
	{
		q 0
	}
	else{
		q -1
	}
}

/// 检查单据数据是否有效,配件是否已经被其他单据占用
/// 参数:SourceID:对应业务单据ID
ClassMethod CheckOrder(SourceID)
{
	n ListID,AccessoryID,Len,i,Flag,FromLocDR,Index
	s Index=0
	s Flag=0
	s ListID=0
	i SourceID="" q "0"
	s AccessoryType=$p($g(^DHCEQAMoveStock(SourceID)),"^",2)
	s FromLocDR=$p($g(^DHCEQAMoveStock(SourceID)),"^",4)
	
	///检查是否已被转移单占用
	f  s ListID=$o(^DHCEQAMoveStockList(0,"MoveStock",SourceID,ListID))  quit:(ListID="")||(Flag'=0)  d
	.s Index=Index+1
	.i $p($g(^DHCEQAMoveStockList(ListID)),"^",9)="Y"	d
	..s AStockDetailDR = $p($g(^DHCEQAMoveStockList(ListID)),"^",14)
	..s Flag=..CheckAccessoryDR(ListID,"",AStockDetailDR,FromLocDR)
	..i Flag'=0 s Flag=Index_"^"_$p($g(^DHCEQAMoveStockList(ListID)),"^",4)_" 配件已经重复占用,请检查本单据或其他单据!"
	
	i Flag'=0
	{
		q Flag
	}
	///检查是否已被减少单占用
	s Status=""
	f Status=0:1:1  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQAReduce(0,"StatusReturnloc",Status,FromLocDR,rowid))  quit:(rowid="")||(Flag'=0)  d
	..q:(AccessoryType'=$p($g(^DHCEQAReduce(rowid)),"^",2))
	..s Lrowid=0
	..f  s Lrowid=$o(^DHCEQAReduceList(0,"Reduce",rowid,Lrowid))  quit:(Lrowid="")||(Flag'=0)  d
	...s Index=Index+1
	...i $p($g(^DHCEQAReduceList(rowid)),"^",8)="Y" d
	....s AStockDetailDR = $p($g(^DHCEQAReduceList(Lrowid)),"^",5)
	....s Flag=..CheckAccessoryDR("",Lrowid,AStockDetailDR,FromLocDR)	//Modify DJ 2014-09-10
	....i Flag'=0 s Flag=Index_"^"_" 配件已经重复占用,请检查本单据或其他单据!"
	
	q Flag
}

/// 查看配件是不是已经存在其他的转移单或减少单中，是，返回1；否则，返回0
/// MXRowID 转移明细ID
/// 	Modify by:GBX GBX0030 判断增加退货明细ID，
/// ReduceListID 减少明细ID
ClassMethod CheckAccessoryDR(MXRowID, ReduceListID, AStockDetailDR, FromLocDR)
{
	new (MXRowID, ReduceListID, AStockDetailDR, FromLocDR)
	i AStockDetailDR="" q 0
	s Flag=0
	//检测来源科室新增，提交状态转移单据是否已存在当前设备（不包括当前转移明细记录）
	s rowid=0 
	f  s rowid=$o(^DHCEQAMoveStock(0,"FromLoc",FromLocDR,rowid))  q:(rowid="")||(Flag'=0)  d
	.s Status=$p($g(^DHCEQAMoveStock(rowid)),"^",28)
	.q:(Status>1)		//过滤掉非'新增','提交' 状态的单据.
	.s mrowid=0 
	.f  s mrowid=$o(^DHCEQAMoveStockList(0,"MoveStock",rowid,mrowid))  q:(mrowid="")||(Flag'=0)  d
	..q:(MXRowID'="")&&(MXRowID=mrowid)
	..s DetailIDs=$g(^DHCEQAMoveStockList(mrowid,"EX","RowIDs")) 
	..s TSerialFlag=$p($g(^DHCEQAMoveStockList(mrowid)),"^",9) //// modify BY:GBX 2014-8-29 11:04:17增加序列号标志判断
	..i TSerialFlag="Y" d
	...i DetailIDs'=""  d  //不为空时存的为库存详细表ID,取ID的数量
	....s DetailLen=$L(DetailIDs,",")
	....s idx=1
	....f  s DetailDR=$p(DetailIDs,",",idx) q:idx>DetailLen  d
	.....s idx=idx+1
	.....i AStockDetailDR=DetailDR  s Flag=1
	...e  d
	....s mStockDetailDR=$p($g(^DHCEQAMoveStockList(mrowid)),"^",14)
	....i mStockDetailDR=AStockDetailDR  s Flag=1
	..e  d
	...s mStockDetailDR=$p($g(^DHCEQAMoveStockList(mrowid)),"^",14)
	...i mStockDetailDR=AStockDetailDR  s Flag=1
	i Flag'=0 q Flag
	
	//检测来源科室新增，提交状态减少单据是否已经存在当前设备(不包括当前退货减少明细记录)
	s Status=""
	f  s Status=$o(^DHCEQAReduce(0,"StatusReturnloc",Status))  q:(Status="")||(Flag'=0)  d
	.q:(Status>1)
	.s rowid=0
	.f  s rowid=$o(^DHCEQAReduce(0,"StatusReturnloc",Status,FromLocDR,rowid)) q:(rowid="")||(Flag'=0)  d
	..s mxrowid=0
	..f  s mxrowid=$o(^DHCEQAReduceList(0,"Reduce",rowid,mxrowid)) q:(mxrowid="")||(Flag'=0)  d
	...q:(ReduceListID'="")&&(ReduceListID=mxrowid)
	...s DetailIDs=$g(^DHCEQAReduceList(mxrowid,"EX","RowIDs")) 
	...s TSerialFlag=$p($g(^DHCEQAReduceList(mxrowid)),"^",8) //// modify BY:GBX 2014-8-29 11:04:17增加序列号标志判断
	...i TSerialFlag="Y" d
	....i DetailIDs'=""  d  //不为空时存的为库存详细表ID,取ID的数量
	.....s DetailLen=$L(DetailIDs,",")
	.....s idx=1
	.....f  s DetailDR=$p(DetailIDs,",",idx) q:idx>DetailLen  d
	......s idx=idx+1
	......i AStockDetailDR=DetailDR  s Flag=1
	....e  d
	.....s mStockDetailDR=$p($g(^DHCEQAReduceList(mxrowid)),"^",5)
	.....i mStockDetailDR=AStockDetailDR  s Flag=1
	...e  d
	....s mStockDetailDR=$p($g(^DHCEQAReduceList(mxrowid)),"^",5)
	....i mStockDetailDR=AStockDetailDR  s Flag=1
	q Flag
}

/// d ##class(web.DHCEQAMoveStock).GetOneMoveStock(10)
ClassMethod GetOneMoveStock(rowid)
{
	new (rowid)
	s (result,resultex,FromLocCode,ToLocCode)=""
	s result= ^DHCEQAMoveStock(rowid)
	set count=..#GlobalLen-$l(result,"^")
	for i=count:-1:1 { s result=result_"^"}
	s resultex=resultex_"^"	//AMS_AccessoryTypeDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAccessoryType",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	;FromLocDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",4))
	.;s FromLocCode=$p($g(^CTLOC($p(result,"^",4))),"^",1)		//Modify DJ 2016-12-01   //modify by jyp 2019-10-18 CTLOC调整
	.s FromLocCode=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",$p(result,"^",4))    //modify by jyp 2019-10-18 CTLOC调整
	s resultex=resultex_"^"	;ToLocDR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",5))
	.;s ToLocCode=$p($g(^CTLOC($p(result,"^",5))),"^",1)			//Modify DJ 2016-12-01   //modify by jyp 2019-10-18 CTLOC调整
	.s ToLocCode=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",$p(result,"^",5))       //modify by jyp 2019-10-18 CTLOC调整
	s resultex=resultex_"^"	;MakerDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",6))
	s $p(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")	;MakeDate
	s resultex=resultex_"^"	;SubmitUserDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",11))
	s $p(result,"^",12)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"date") ;SubmitDate
	s resultex=resultex_"^"	;ReciverDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",15))
	s resultex=resultex_"^"	;AuditUserDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",16))
	s $p(result,"^",17)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",17),"date") ;AuditDate
	s resultex=resultex_"^"		//RejectUserDR
	i $p(result,"^",25)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",25))
	s $p(result,"^",26)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",26),"date") //RejectDate

	s apprInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("11",rowid)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex_"^"_FromLocCode_"^"_ToLocCode_"^"_$CASE($p(result,"^",14),"0":"出库","1":"库房调配","2":"退库",:"没有定义")_"^"_apprInfo
}

/// Mozy		888605	2019-5-21	Hisui改造
ClassMethod StatusList(name, width, Type, Value As %Library.String = "") As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	s selectedone=$case(Value,0:"selected",:"")
	s selectedtwo=$case(Value,1:"selected",:"")
	s selectedthree=$case(Value,2:"selected",:"")
	
	w "<option value=></option>"
	i (Type="")||(Type="0") w "<option value=0 "_selectedone_">"_##Class(web.DHCEQAInStock).GetAInStockStatusList(0)_"</option>"
	i Type'="2" w "<option value=1 "_selectedtwo_">"_##Class(web.DHCEQAInStock).GetAInStockStatusList(1)_"</option>"
	w "<option value=2 "_selectedthree_">"_##Class(web.DHCEQAInStock).GetAInStockStatusList(2)_"</option>"
	
	w "</select>",!
}

ClassMethod MoveTypeList(name, width, Type) As %String
{
	;;下拉列表
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"") //add hly 2019-04-26
	w "<option value=></option>"
	w "<option value=0>出    库</option>"
	//w "<option value=1>库房调配</option>"
	w "<option value=2>退    库</option>"
	w "</select>",!
}

ClassMethod CheckMoveStockLoc(RowID)
{
	n (RowID) 
	s MoveType=$p($g(^DHCEQAMoveStock(RowID)),"^",14)
	s FromLocDR=$p($g(^DHCEQAMoveStock(RowID)),"^",4)
	s ToLocDR=$p($g(^DHCEQAMoveStock(RowID)),"^",5)
	i FromLocDR="" q "供给部门未保存,请先更新数据"
	i ToLocDR="" q "接收部门未保存,请先更新数据"
	i FromLocDR=ToLocDR q "供给部门与接收部门相同!"
	s FromLocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",FromLocDR)
	s ToLocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",ToLocDR)
	i ((MoveType="0")||(MoveType="1")) // 出库 或 库房分配 ;2014-4-9 10:36:59 BY:GBX
	{
		s Flag=##Class(web.DHCEQCommon).CheckLocType("0101",FromLocDR)
		i Flag'=0 q "供给部门不是库房"
	}
	else
	{
		s Flag=##Class(web.DHCEQCommon).CheckLocType("0102",FromLocDR)
		i Flag'=0 q "供给部门不是科室"
	}
	i ((MoveType="2")||(MoveType="1")) //退库 或 库房分配
	{
		s Flag=##Class(web.DHCEQCommon).CheckLocType("0101",ToLocDR)
		i Flag'=0 q "接收部门不是库房"
	}
	else
	{
		s Flag=##Class(web.DHCEQCommon).CheckLocType("0102",ToLocDR)
		i Flag'=0 q "接收部门不是科室"
	}
	s CheckFlag=##class(web.DHCEQCommon).GetSysInfo("990012")
	i (CheckFlag="")||(CheckFlag=0) q ""
	//判断当前库房管理科室
	i MoveType="0"
	{
		s Flag=$D( ^DHCEQCCode("DHCEQCStoreManageLoc",0,"Loc",ToLocDR,FromLocDR))
		i Flag=0 q ToLocDesc_"不在"_FromLocDesc_"管理范围内"
	}
	/*
	i MoveType="1" //判断科室调配时供给部门与接收部门是否属于同一库房
	{
		s FromStore=$o( ^DHCEQCCode("DHCEQCStoreManageLoc",0,"Loc",FromLocDR,0))
		i FromStore="" q "库房管理科室中未设置供给部门的所属管理库房"
		s ToStore=$o( ^DHCEQCCode("DHCEQCStoreManageLoc",0,"Loc",ToLocDR,0))
		i ToStore="" q "库房管理科室中未设置接收部门的所属管理库房"
		i FromStore'=ToStore q FromLocDesc_" 和 "_ToLocDesc_"不在同一库房管理下"
	}
	*/
	i MoveType="2"
	{
		s Flag=$D( ^DHCEQCCode("DHCEQCStoreManageLoc",0,"Loc",FromLocDR,ToLocDR))
		i Flag=0 q FromLocDesc_"不在"_ToLocDesc_"管理范围内"
	}
	q ""
}

/// 得到转移单据总金额
ClassMethod GetAMSTotalFee(AMSRowID)
{
	i AMSRowID="" q ""
	s AMSLRowID=0 , Fee=0
	f  s AMSLRowID=$o(^DHCEQAMoveStockList(0,"MoveStock",AMSRowID,AMSLRowID)) q:AMSLRowID=""  d
	.s Amount=$P($G(^DHCEQAMoveStockList(AMSLRowID)),"^",12)
	.s Fee=Fee+Amount
	q Fee
}

/// 得到转移明细单对应配件的总库存
ClassMethod GetAMSLTotalStock(AMSLRowID)
{
	i AMSLRowID="" q ""
	s TotalStock=0
	s serialFlag=$P($G(^DHCEQAMoveStockList(AMSLRowID)),"^",9)
	i serialFlag="Y"
	{
		s detailDRs=$G(^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs"))
		s count=$l(detailDRs,",")
		f i=1:1:count
		{
			s detailDR=$p(detailDRs,",",i)
			i detailDR'=""
			{
				s TotalStock=TotalStock+$P($G(^DHCEQAStockDetail(detailDR)),"^",17)
			}
		}
	}
	else{
		s detailDR=$P($G(^DHCEQAMoveStockList(AMSLRowID)),"^",14)
		i detailDR'=""
		{
			s TotalStock=+$P($G(^DHCEQAStockDetail(detailDR)),"^",17)
		}
	}
	q TotalStock
}

/// ----------------------------------
ClassMethod SubmitData(val)
{
	new (val, %session)  //ZX0035 清空session值后,影响消息生成
	k PLIST
	s Date=+$H
	s Time=$P($H,",",2)
	Set $ZT="ERRORSubmit"
	s RowID = $p(val,"^",1)	
	i RowID="" q ""
	s Status=$p($g(^DHCEQAMoveStock(RowID)),"^",28)
	i Status="3" q -1015
	i $p($g(^DHCEQAMoveStock(RowID)),"^",30)="Y" q -1	;Hold1	Mozy0189	2017-5-26	自动建单未编辑不能提交
	s User=$p(val,"^",8)
	;s Job = $p(val,"^",11) 		
	s AccessoryTypeDR=$p($g(^DHCEQAMoveStock(RowID)),"^",2)
	s MoveType=$p($g(^DHCEQAMoveStock(RowID)),"^",14)
	s PLIST(12) = User 	
 	s PLIST(13) = Date
 	s PLIST(14) = Time
	s PLIST(29) = "1"	

	s ApproveCondition="MoveType,DHCEQAMoveStock,"_MoveType
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("11")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, AccessoryTypeDR, "", "", "","",ApproveCondition)
	i ApproveSet="" q -4007
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfoStatus="1"
	//检测是否最后一步,是则自动审核 
	s AuditFlag=0
	i (AutoAuditFlag="Y")&&(NextStep="")
	{
		s PLIST(17)=User   //begin add by zx 2015-03-24
		s PLIST(18)=Date
		s PLIST(19)=Time   //end add by zx 2015-03-24
		s PLIST(29)="2"
		s AppInfoStatus="2"
	}
	
	TSTART	
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"11",User)
	i SQLCODE
	{
		TROLLBACK
	 	q SQLCODE
	}
	
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}	
	&SQL(update sqluser.DHC_EQAMoveStock values :PLIST() where AMS_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//最终审核调用 
	i NextStep="" 
	{
		s SQLCODE=..LastStepAction(RowID,User)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	//add by zx 2016-03-03 消息处理 ZX0035
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("A02", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
 	TCOMMIT
 	q RowID
ERRORSubmit 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息 ;
}

/// 描述:审核
/// w ##Class(web.DHCEQAMoveStock).AuditData("4^1^410^204^0^^^1^122^34^5912",8,3,"")
ClassMethod AuditData(val, CurRole, RoleStep, editFieldsInfo)
{
	new (val, CurRole,RoleStep, editFieldsInfo, %session)  //ZX0035 清空session值后,影响消息生成
	n RowID,User,Date
	n ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole
	Set $ZT="ERRORAudit"
	k PLIST
	s RowID=$P(val,"^",1)
	s User=$P(val,"^",8)
	s Date=+$H
	s Time=$p($H,",",2)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("11")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("11", RowID)
	i ApproveSet="" q -4007	
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfoStatus="1"
	
	TSTART	
	s AuditFlag=0 //add by zx 2016-03-03 最后审核步骤标志  bug ZX0035
	i ((NextStep="")||(LastFlag="Y"))
	{
		i ("2"=$p($g(^DHCEQAMoveStock(RowID)),"^",28))
		{
			TROLLBACK
			q -1010
		}
		s AuditFlag=1 //bug ZX0035
		s AppInfoStatus="2"
		s Date=+$H
		s PLIST(17)=User
		s PLIST(18)=Date
		s PLIST(19)=Time
		s PLIST(29)="2"
		&SQL(update sqluser.DHC_EQAMoveStock values :PLIST() where AMS_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	//转移审核增加保存生成审批的记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep,User)
	If SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	//可编辑字段更新 
	i editFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	if Actions'=""				//执行当前角色要执行的动作
	{
		s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions,editFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	//最终审核调用 
	i AuditFlag=1  // bug ZX0035
	{
		s SQLCODE=..LastStepAction(RowID,User)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	//add by zx 2016-03-03 消息处理 ZX0035
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("A02", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	Quit RowID
ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg     //返回错误消息 ;
}

ClassMethod LastStepAction(RowID, User)
{
	s SQLCODE=..InsertAChangeStock(RowID,User)		//写入变动信息
	i SQLCODE q SQLCODE
	s SQLCODE=..UpdateAStockDetailInfo(RowID,User)	//更新配件库存明细信息
	q SQLCODE
}

/// 描述:库房变动信息
ClassMethod InsertAChangeStock(RowID, User)
{
	new (RowID, User) 
	q:RowID=""
	k ACSPL,ACSDPL
	s Date=+$H
	s Flag=0,ACSRowID="",DetailIDs=""
	s AccessoryTypeDR=$P($g(^DHCEQAMoveStock(RowID)),"^",2)
	s FromLoc=$P($g(^DHCEQAMoveStock(RowID)),"^",4)
	s ToLoc=$P($g(^DHCEQAMoveStock(RowID)),"^",5)
	s SubmitDate=$P($g(^DHCEQAMoveStock(RowID)),"^",12)
	s AuditDate=$P($g(^DHCEQAMoveStock(RowID)),"^",17)
	s AMSLRowID=0
	f  s AMSLRowID=$o(^DHCEQAMoveStockList(0,"MoveStock",RowID,AMSLRowID))  quit:(AMSLRowID="")||(Flag'=0)  d
	.s ACSPL(2)=FromLoc		//ACS_FromLocDR
	.s ACSPL(3)=ToLoc		//ACS_ToLocDR
	.s ACSPL(4)=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",2)	//ACS_ItemDR
	.s ACSPL(5)=AccessoryTypeDR		//ACS_AccessoryTypeDR
	.s ACSPL(6)=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",7)	//ACS_BaseUOMDR
	.//s ACSPL(7)=		//ACS_UOMDR
	.//s ACSPL(8)=		//ACS_BaseStock
	.s ACSPL(9)=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",10)	//ACS_Price
	.s ACSPL(10)="1"		//ACS_SourceType
	.s ACSPL(11)=AMSLRowID	//ACS_SourceID
	.s ACSPL(12)=..GetAMSLTotalStock(AMSLRowID)		//ACS_Stock
	.s ACSPL(13)=User		//ACS_AuditUserDR
	.s ACSPL(14)=SubmitDate	//ACS_OutDate
	.s ACSPL(15)=AuditDate	 //ACS_AuditDate
	.&SQL(Insert into sqluser.DHC_EQAChangeStock values :ACSPL())
	.i SQLCODE 
	..s Flag=SQLCODE q
	.s ACSRowID=$G(%ROWID)	
	.s BatchFlag=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",8)
	.i BatchFlag="Y" d
	..s DetailIDs=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",14)		//批号管理
	.e  d
	..s DetailIDs=$G(^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs"))		//序列号管理
	.s count=$l(DetailIDs,",")
	.f i=1:1:count d
	..q:Flag'=0
	..s DetailID=$p(DetailIDs,",",i)
	..i DetailID'=""  d
	...s ACSDPL(2)=ACSRowID		//ACSD_ChangeStockDR
	...s ACSDPL(3)=DetailID		//ACSD_StockDetailDR
	...s ToSourceID=..GetToAStockDR(ToLoc, ACSPL(4), DetailID)
	...s ACSDPL(4)=$p(ToSourceID,"^",2)	//ACSD_ToStockDetailDR
	...//s ACSDPL(5)=	//ACSD_BaseStock
	...s ACSDPL(6)=+$P($G(^DHCEQAStockDetail(DetailID)),"^",17)	//ACSD_Stock
	...s SQLCODE=0
	...&SQL(Insert into sqluser.DHC_EQAChangeStockDetail values :ACSDPL())
	...i SQLCODE s Flag=SQLCODE
	q Flag
}

/// 更新配件库存信息.
ClassMethod UpdateAStockDetailInfo(RowID, User)
{
	new (RowID, User)
	k ASPL,ASDPL
	s Flag=0,AStockDetailDR="",ASDList="",ASRowID="",ASList="",ToSourceID="",Status="",NewRowID=""
	s FromLoc=$P($g(^DHCEQAMoveStock(RowID)),"^",4)
	s ToLoc=$P($g(^DHCEQAMoveStock(RowID)),"^",5)
	s AccessoryTypeDR=$P($g(^DHCEQAMoveStock(RowID)),"^",2)
	s MoveType=$P($g(^DHCEQAMoveStock(RowID)),"^",14)
	i MoveType="2"  d
	.s Status="0"
	e  d
	.s Status="1"
	s AMSLRowID=0
	f  s AMSLRowID=$o(^DHCEQAMoveStockList(0,"MoveStock",RowID,AMSLRowID))  q:(AMSLRowID="")||(Flag'=0)  d
	.k ASPL,ASDPL
	.s QuantityNum=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",11)
	.s ItemDR=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",2)
	.s BatchFlag=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",8)
	.s SerialFlag=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",9)		//Add By DJ 2016-04-01
	.//批号管理
	.i SerialFlag'="Y" d
	..s AStockDetailDR=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",14)
	..s ASDList=$g(^DHCEQAStockDetail(AStockDetailDR))
	..s ASRowID=$p(ASDList,"^",21)
	..i ASRowID'="" s ASList=$g(^DHCEQAStock(ASRowID))
	..s Amount=+$p(ASList,"^",7)*QuantityNum	//AS_Amount
	..s ToSourceID=..GetToAStockDR(ToLoc,ItemDR,AStockDetailDR)
	..s ARowID=$p(ToSourceID,"^",1)
	..s ADRowID=$p(ToSourceID,"^",2)
	..i ARowID=""  d
	...d AddAStockValues
	...q:Flag
	...d AddAStockDetailValues
	...q:Flag
	..e  d
	...i ADRowID=""  d
	....s NewRowID=ARowID  //add by zx 2014-12-16
	....d AddAStockDetailValues
	....q:Flag
	...e  d
	....&SQL(Update SQLUSER.DHC_EQAStockDetail Set ASD_Stock=ASD_Stock+:QuantityNum where ASD_RowID=:ADRowID)
	....s AID=$Get(%ROWID)  //add by zx 2014-12-16
	....i SQLCODE  d
	.....s Flag=SQLCODE q
	....i AMSLRowID'="" d  //add by zx 2014-12-15 begin
	.....&SQL(Update SQLUSER.DHC_EQAMoveStockList Set AMSL_StockDetailDR=:AID Where AMSL_RowID=:AMSLRowID)
	.....i SQLCODE d
	......s Flag=SQLCODE q  //add by zx 2014-12-15 end
	....&SQL(Update SQLUSER.DHC_EQAStockDetail Set ASD_Stock=ASD_Stock-:QuantityNum where ASD_RowID=:AStockDetailDR)
	....i SQLCODE  d
	.....s Flag=SQLCODE q
	...&SQL(Update SQLUSER.DHC_EQAStock Set AS_Amount=AS_Amount-:Amount,AS_Stock=AS_Stock-:QuantityNum  Where AS_RowID=:ASRowID)	
	...i SQLCODE  d
	....s Flag=SQLCODE q
	...&SQL(Update SQLUSER.DHC_EQAStock Set AS_Amount=AS_Amount+:Amount,AS_Stock=AS_Stock+:QuantityNum  Where AS_RowID=:ARowID)	
	...i SQLCODE  d
	....s Flag=SQLCODE q
	.e  d //序列号管理
	..s DetailIDs=$G(^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs"))	//HZY
	..s length=$l(DetailIDs,",")
	..f i=1:1:length  d
	...q:Flag
	...k ASPL,ASDPL
	...s AStockDetailDR=$p(DetailIDs,",",i)
	...s ASDList=$g(^DHCEQAStockDetail(AStockDetailDR))
	...s ASRowID=$p(ASDList,"^",21)
	...s Bprice=$p(ASDList,"^",8)	//ASD_Bprice
	...s ASList=$g(^DHCEQAStock(ASRowID))
	...s ToSourceID=..GetToAStockDR(ToLoc,ItemDR,AStockDetailDR)
	...s ARowID=$p(ToSourceID,"^",1)
	...s ADRowID=$p(ToSourceID,"^",2)
	...i ARowID=""  d
	....d AddAStockValues
	....q:Flag
	...e  d
	....s NewRowID=ARowID
	....&SQL(Update SQLUSER.DHC_EQAStock Set AS_Stock=AS_Stock+1,AS_Amount=AS_Amount+:Bprice Where AS_RowID=:ARowID)
	....i SQLCODE  d
	.....s Flag=SQLCODE q
	....&SQL(Update SQLUSER.DHC_EQAStock Set AS_Stock=AS_Stock-1,AS_Amount=AS_Amount-:Bprice Where AS_RowID=:ASRowID)
	....i SQLCODE  d
	.....s Flag=SQLCODE q
	...&SQL(Update SQLUSER.DHC_EQAStockDetail Set ASD_LocDR=:ToLoc,ASD_StockDR=:NewRowID,ASD_Status=:Status Where ASD_RowID=:AStockDetailDR ) //qw0005-2014-06-11:AStockDetailDR
	...i SQLCODE  d
	....s Flag=SQLCODE q
	
	Quit Flag
	
AddAStockValues
	s ASPL(2)=ToLoc				//AS_LocDR
	s ASPL(3)=$p(ASList,"^",2)	//AS_ItemDR
	s ASPL(4)=$p(ASList,"^",3)	//AS_Code
	s ASPL(5)=$p(ASList,"^",4)	//AS_Desc
	s ASPL(6)=$p(ASList,"^",5)	//AS_AccessoryTypeDR
	s ASPL(8)=+$p(ASList,"^",7)	//AS_FinalBPrice
	s ASPL(10)=+$p(ASList,"^",7)*QuantityNum	//AS_Amount
	s ASPL(11)=QuantityNum		//AS_Stock
	&SQL(Insert Into SQLUSER.DHC_EQAStock Values :ASPL())	//插入新的库存记录
	i SQLCODE d
	.s Flag=SQLCODE q
	s NewRowID=$G(%ROWID)
	&SQL(Update SQLUSER.DHC_EQAStock Set AS_Amount=AS_Amount-:ASPL(10),AS_Stock=AS_Stock-:ASPL(11)  Where AS_RowID=:ASRowID)	//更新旧的库存记录
	i SQLCODE d
	.s Flag=SQLCODE q
	quit
AddAStockDetailValues
	s ASDPL(2)=ToLoc					//ASD_LocDR
	s ASDPL(3)=$p(ASDList,"^",2)		//ASD_ItemDR
	s ASDPL(4)=$p(ASDList,"^",3)		//ASD_AInStockListDR
	s ASDPL(5)=$p(ASDList,"^",4)		//ASD_Code
	s ASDPL(6)=$p(ASDList,"^",5)		//ASD_Desc
	s ASDPL(7)=$p(ASDList,"^",6)		//ASD_BatchNo
	s ASDPL(8)=$p(ASDList,"^",7)		//ASD_ExpiryDate
	s ASDPL(9)=$p(ASDList,"^",8)		//ASD_Bprice
	s ASDPL(10)=$p(ASDList,"^",9)		//ASD_SerialNo
	s ASDPL(11)=$p(ASDList,"^",10)		//ASD_No
	s ASDPL(12)=$p(ASDList,"^",11)		//ASD_AccessoryTypeDR
	s ASDPL(13)=Status					//ASD_Status
	s ASDPL(14)=$p(ASDList,"^",13)		//ASD_BaseUOMDR
	s ASDPL(15)=$p(ASDList,"^",14)		//ASD_ManuFactoryDR
	s ASDPL(16)=$p(ASDList,"^",15)		//ASD_Model
	s ASDPL(17)=$p(ASDList,"^",16)		//ASD_ProviderDR
	s ASDPL(18)=QuantityNum				//ASD_Stock
	s ASDPL(22)=NewRowID				//ASD_StockDR
	&SQL(Insert Into SQLUSER.DHC_EQAStockDetail Values :ASDPL())
	s AID=$Get(%ROWID)
	i SQLCODE d
	.s Flag=SQLCODE q  
	i AMSLRowID'="" d  //add by zx 2014-12-15 begin
	.&SQL(Update SQLUSER.DHC_EQAMoveStockList Set AMSL_StockDetailDR=:AID Where AMSL_RowID=:AMSLRowID)
	.i SQLCODE d
	..s Flag=SQLCODE q  //add by zx 2014-12-15 end
	&SQL(Update SQLUSER.DHC_EQAStockDetail Set ASD_Stock=ASD_Stock-:ASDPL(18) Where ASD_RowID=:AStockDetailDR)
	i SQLCODE d
	.s Flag=SQLCODE q
	quit
}

/// 获取将要转入到的库房的AStockDR和AStockDetailDR . 若没有 则返回空.
ClassMethod GetToAStockDR(ToLocDR, FromItemDR, FromStockDetailDR)
{
	new (ToLocDR,FromItemDR,FromStockDetailDR)
	s FromAISLDR=$p($g(^DHCEQAStockDetail(FromStockDetailDR)),"^",3)	//ASD_AInStockListDR
	s rowid=0,findFlag=0,findARowID="",findADRowID=""
	f  s rowid=$o(^DHCEQAStock(0,"Loc",ToLocDR,rowid)) q:(rowid="")||(findFlag=1)  d
	.q:$p($g(^DHCEQAStock(rowid)),"^",2)'=FromItemDR
	.s findARowID=rowid
	.s Drowid=0
	.f  s Drowid=$o(^DHCEQAStockDetail(0,"AStock",rowid,Drowid)) q:(Drowid="")||(findFlag=1)  d
	..q:$p($g(^DHCEQAStockDetail(Drowid)),"^",2)'=FromItemDR
	..s ToAISLDR=$p($g(^DHCEQAStockDetail(Drowid)),"^",3) 	//ASD_AInStockListDR
	..i FromAISLDR=ToAISLDR  d
	...s findFlag=1
	...s findADRowID=Drowid
	
	q findARowID_"^"_findADRowID
}

ClassMethod CancelSubmitData(val, CurRole)
{
	new (val,CurRole, %session)  //ZX0035 清空session值后,影响消息生成
	Set $ZT="ERRORCancel"
	k PLIST
	s RowID=$P(val,"^",1)
	s User=$P(val,"^",8)
	s CancelToFlowDR=$P(val,"^",9)
	s ApproveSet=$P(val,"^",10)
	s Date=+$H
	s Time=$p($H,",",2)
	s PLIST(25) = $P(val,"^",12)	//AMS_RejectReason
	s PLIST(26) = User 	//AMS_RejectUserDR
 	s PLIST(27) = Date	//AMS_RejectDate
 	s PLIST(28) = Time	//AMS_RejectTime
 	s ApproveRoleDR=""
 	s Step=""
 	s Status="0"
	TSTART
	if (CancelToFlowDR'="")
	{
	 	s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
	 	s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s Status="1"
	}
	s PLIST(29)=Status
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("11")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("11", RowID)
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	&SQL(update sqluser.DHC_EQAMoveStock values :PLIST() where AMS_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//add by zx 2016-03-03 ZX0035 取消提交生成消息
	else
	{
		s ApproveFlow=""
		i CancelToFlowDR'=""
		{
			s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
			
		}
		s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("A02", RowID, User, ApproveFlow, "Y",CurRole)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
 	TCOMMIT
 	q RowID
ERRORCancel 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息 ;
}

ClassMethod DeleteData(RowID)
{
	i RowID="" 
	{
		q -1
	}
	else
	{
		&SQL(Update SQLUSER.DHC_EQAMoveStock Set AMS_Status='3' where AMS_RowID=:RowID)
 		q SQLCODE
	}
}

/// w ##class(web.DHCEQAMoveStock).GetList(2)
ClassMethod GetList(Arowid As %Library.String = "")
{
	s Data=""
	s (Num,Rowid,sumFee,sumQty)=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set SplitNumCode=##class(web.DHCEQCommon).GetSysInfo("990026")
	if Arowid'=""
	{
		f  s Rowid=$o(^DHCEQAMoveStockList(0,"MoveStock",Arowid,Rowid))  quit:Rowid=""  d
		.s (TRowID,TNos,TCode,TDesc,TItemDR,TMoveStockDR,TBatchFlag,TQuantityNum,TModel,TBaseUOMDR,TBaseUOM,TRemark,TAmount,TManuFactory,TManuFactoryDR,TStockDetailDR,TSerialFlag,TPrice,THold2,THold3,THold4,THold5,TAInNo)=""
		.s TRowID = Rowid
		.s TMoveStockDR = Arowid
		.s TItemDR = $p($g(^DHCEQAMoveStockList(Rowid)),"^",2)
		.s TCode= $p($g(^DHCEQAMoveStockList(Rowid)),"^",3)
		.s TDesc= $p($g(^DHCEQAMoveStockList(Rowid)),"^",4)
		.s TModel= $p($g(^DHCEQAMoveStockList(Rowid)),"^",5)
		.s TBaseUOMDR= $p($g(^DHCEQAMoveStockList(Rowid)),"^",6)
		.i TBaseUOMDR '=""  d
		..s TBaseUOM = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TBaseUOMDR)
		.s TManuFactoryDR= $p($g(^DHCEQAMoveStockList(Rowid)),"^",7)
		.i TManuFactoryDR'="" d
		..s TManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
		.s TBatchFlag = $p($g(^DHCEQAMoveStockList(Rowid)),"^",8)
		.s TSerialFlag= $p($g(^DHCEQAMoveStockList(Rowid)),"^",9)
		.i TSerialFlag="Y" d
		..s TNos=$g(^DHCEQAMoveStockList(Rowid,"EX","RowIDs"))
		.s TPrice= $p($g(^DHCEQAMoveStockList(Rowid)),"^",10)
		.s TQuantityNum = $p($g(^DHCEQAMoveStockList(Rowid)),"^",11)
		.s TQuantityNum=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum,"",2)	// 2017-2-7	Mozy	格式化小数
		.s sumQty=sumQty+TQuantityNum
		.if sumQty'="" s sumQty=##Class(web.DHCEQCommon).FormatNumber(sumQty,"",2)	// 2017-2-7	Mozy	格式化小数
		.s TAmount=$p($g(^DHCEQAMoveStockList(Rowid)),"^",12)
		.s sumFee=sumFee+TAmount
		.if sumFee'="" s sumFee=##Class(web.DHCEQCommon).FormatNumber(sumFee,"",2)	// 2017-2-7	Mozy	格式化小数
		.s TRemark=$p($g(^DHCEQAMoveStockList(Rowid)),"^",13)
		.s TStockDetailDR=$p($g(^DHCEQAMoveStockList(Rowid)),"^",14)
		.s TAInStockListDR=$p($g(^DHCEQAMoveStockList(Rowid)),"^",15)	;THold2
		.s THold3=$p($g(^DHCEQAMoveStockList(Rowid)),"^",16)
		.s THold4=$p($g(^DHCEQAMoveStockList(Rowid)),"^",17)
		.s THold5=$p($g(^DHCEQAMoveStockList(Rowid)),"^",18)
		.;TInNo 获取入库单号
		.i TAInStockListDR'="" d
		..s TAInStockDR=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",1)
		..i TAInStockDR'="" s TAInNo = $p($g(^DHCEQAInStock(TAInStockDR)),"^",6)
		.
		.s Data=Data_SplitRowCode_TRowID_"^"_TMoveStockDR_"^"_TItemDR_"^"_TCode_"^"_TDesc_"^"_TModel_"^"_TBaseUOMDR_"^"_TManuFactoryDR_"^"_TBatchFlag_"^"_TSerialFlag_"^"_TPrice_"^"_TQuantityNum_"^"_TAmount_"^"_TRemark_"^"_TStockDetailDR_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TNos_"^"_TBaseUOM_"^"_TManuFactory_"^"_TAInNo
		.s Num=Num+1
	}
	i Data'=""  d
	.s Data=Data_SplitRowCode_"^^^^"_"合计"_"^^^^^^^"_sumQty_"^"_sumFee_"^^^^^^^^^^"
	.s Num=Num+1
	
	q Data_SplitNumCode_Num
}

/// Creator：      WL
/// CreatDate：    2019-11-21
/// Description:   润乾打印(配件转移单)
/// Input：        ASMRowID:配件转移ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQAMoveStock","GetAStoreMovePrint","20") 
Query GetAStoreMovePrint(AMSRowID As %String = "") As %Query(ROWSPEC = "AMSMoveNo:%String,AMSToLocDR_DeptDesc:%String,AMSMakeDate:%String,AMSMoveType:%String,title:%String,NoDesc:%String,ASMReciverDR_UName") [ SqlProc ]
{
}

ClassMethod GetAStoreMovePrintExecute(ByRef qHandle As %Binary, AMSRowID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 	s (TMoveNo,TToLocDR,TToLoc,TMakeDate,TMoveType,title,NoDesc,TReciverDR,TReciver)=""
 	i AMSRowID'="" D
	.s TMoveNo=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",1)
	.s TToLocDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",5)
	.i TToLocDR'="" s TToLoc=##class(DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
	.s TMakeDate=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",7)
	.i TMakeDate'="" s TMakeDate=##Class(web.DHCEQCommon).TransValueToPage(TMakeDate,"datetime")
	.s TMoveType=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",14)
	.s TReciverDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",15)
	.i TReciverDR'="" s TReciver=##class(DHCEQCommon).GetTrakNameByID("user",TReciverDR)
	.i TMoveType="0"  d 
	..s title="配件出库单" 
	..s NoDesc="出库单号:"_TMoveNo
	.i TMoveType="1"  d 
	..s title="配件调配单" 
	..s NoDesc="调配单号:"_TMoveNo 
	.i TMoveType="2"  d 
	..s title="配件退库单" 
	..s NoDesc="退库单号:"_TMoveNo
	.d OutputRowGetAStoreMovePrint	
 	
	

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK	 
OutputRowGetAStoreMovePrint
 set Data=$lb(TMoveNo,TToLoc,TMakeDate,TMoveType,title,NoDesc,TReciver) 
 set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetAStoreMovePrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAStoreMovePrintExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind=""
	 {
	  //if there are no more rows,finish fetching...
	  Set AtEnd=1
	  Set Row=""
	 }
	 Else
	 {
	  Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod GetAStoreMovePrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAStoreMovePrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      WL
/// CreatDate：    2019-11-21
/// Description:   润乾打印(配件转移单明细)
/// Input：        ASMRowID:配件转移ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQAMoveStock","GetAStoreMoveListPrint","20") 
Query GetAStoreMoveListPrint(AMSRowID As %String = "") As %Query(ROWSPEC = "AMSLDesc:%String,AMSLModel:%String,AMSLBaseUOMDR_UOMDesc:%String,AMSLQuantityNum:%String,AMSLPrice:%String,AMSLAmount:%String,AMSLAISListDR_AISInStockNo:%String") [ SqlProc ]
{
}

ClassMethod GetAStoreMoveListPrintExecute(ByRef qHandle As %Binary, AMSRowID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 	s Rowid=0
	f  s Rowid=$o(^DHCEQAMoveStockList(0,"MoveStock",AMSRowID,Rowid))  quit:Rowid=""  d
	.s (TRowID,TDesc,TModel,TBaseUOM,TQuantityNum ,TPrice,TAmount,TAInNo)=""
	.s TRowID = Rowid //配件转移明细ID
	.s TDesc= $p($g(^DHCEQAMoveStockList(Rowid)),"^",4)  //配件名称
	.s TModel= $p($g(^DHCEQAMoveStockList(Rowid)),"^",5) //型号
	.s TBaseUOMDR= $p($g(^DHCEQAMoveStockList(Rowid)),"^",6)
	.i TBaseUOMDR '=""  d
	..s TBaseUOM = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TBaseUOMDR) //单位
	.s TQuantityNum = $p($g(^DHCEQAMoveStockList(Rowid)),"^",11)	//数量
	.s TQuantityNum=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum,"","")
	.s TPrice= $p($g(^DHCEQAMoveStockList(Rowid)),"^",10)	//单价
	.i TPrice'="" s TPrice=##class(web.DHCEQCommon).FormatNumber(TPrice,"")
	.s TAmount=$p($g(^DHCEQAMoveStockList(Rowid)),"^",12) //出库金额
	.i TAmount'="" s TAmount=##class(web.DHCEQCommon).FormatNumber(TAmount,"")
	.s TAInStockListDR=$p($g(^DHCEQAMoveStockList(Rowid)),"^",15)	
	.i TAInStockListDR'="" d
	..s TAInStockDR=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",1)
	..i TAInStockDR'="" s TAInNo = $p($g(^DHCEQAInStock(TAInStockDR)),"^",6)	//入库单号
	
 	.d OutputRowGetAStoreMoveListPrint	
	
 	
	

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK	 
OutputRowGetAStoreMoveListPrint
 set Data=$lb(TDesc,TModel,TBaseUOM,TQuantityNum ,TPrice,TAmount,TAInNo) 
 set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetAStoreMoveListPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAStoreMoveListPrintExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind=""
	 {
	  //if there are no more rows,finish fetching...
	  Set AtEnd=1
	  Set Row=""
	 }
	 Else
	 {
	  Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod GetAStoreMoveListPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAStoreMoveListPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQAMoveStock","GetAMoveStock","","","","","","","","","","","")
Query GetAMoveStock(QXType, WaitAD, FromLocDR, ToLocDR, StartDate, EndDate, Status, MoveType, ApproveRole, AMoveStockNo, InvalidFlag As %String = "N") As %Query(ROWSPEC = "TRowID:%String,TFromLocDR:%String,TFromLoc:%String,TToLocDR:%String,TToLoc:%String,TMoveStockNo:%String,TAccessoryTypeDR:%String,TAccessoryType:%String,TType:%String,TMaker:%String,TMakerDR:%String,TMakeDate:%String,TMakeTime:%String,TToType:%String,TToSourceID:%String,TSubmitUserDR:%String,TSubmitUser:%String,TSubmitDate:%String,TSubmitTime:%String,TMoveType:%String,TMoveTypeID:%String,TReciverDR:%String,TReciver:%String,TAuditUserDR:%String,TAuditUser:%String,TAuditDate:%String,TAuditTime:%String,THold6:%String,THold7:%String,THold8:%String,THold9:%String,THold10:%String,TRejectReason:%String,TRejectUserDR:%String,TRejectUser:%String,TRejectDate:%String,TRejectTime:%String,TStatus:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String,TBackGroupColor:%String,TApprovals:%String")
{
}

ClassMethod GetAMoveStockExecute(ByRef qHandle As %Binary, QXType, WaitAD, FromLocDR, ToLocDR, StartDate, EndDate, Status, MoveType, ApproveRole, AMoveStockNo, InvalidFlag As %String = "N") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("11")
	s index=1
	s TRow=1 //add by zx 2015-09-15 BugZX0032
	s rowid=0
	// Mozy	888605	2019-5-21	Hisui改造
	s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	d BuildDataGetAMoveStock
	Quit $$$OK
BuildDataGetAMoveStock
	f  s rowid=$o(^DHCEQAMoveStock(rowid))  quit:rowid=""  d
	.d ResetVariablesGetAMoveStock
	.s TRowID = rowid
	.s TMoveStockNo = $p($g(^DHCEQAMoveStock(rowid)),"^",1)	//转移单号
	.q:(AMoveStockNo'="")&&($e(TMoveStockNo,1,$l(AMoveStockNo))'=AMoveStockNo)
	.// Mozy	888605	2019-5-21	Hisui改造
	.s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(rowid)),"^",2)	//配件类组
	.q:(##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)'=0)
	.s TAccessoryType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR)
	.s TFromLocDR = $p($g(^DHCEQAMoveStock(rowid)),"^",4)
	.q:(FromLocDR'="")&&(FromLocDR'=TFromLocDR)
	.s TToLocDR = $p($g(^DHCEQAMoveStock(rowid)),"^",5)
	.q:(ToLocDR'="")&&(ToLocDR'=TToLocDR)	
	.s Flag=0
	.i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromLocDR))) s Flag=Flag+1 
	.i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TToLocDR))) s Flag=Flag+1 
	.q:Flag=2
	.s TMakeDate=$p($g(^DHCEQAMoveStock(rowid)),"^",7)
	.q:(TMakeDate>EndDate)||(TMakeDate<StartDate)	
	.s TMoveType = $p($g(^DHCEQAMoveStock(rowid)),"^",14)
	.q:(MoveType'="")&&(MoveType'=TMoveType)	
	.s TStatus = $p($g(^DHCEQAMoveStock(rowid)),"^",28)
	.q:((Status'="")&&(TStatus'=Status))||(TStatus="3")
	.q:(WaitAD="on")&&(TStatus="0")	
	.i TFromLocDR '=""  d
	..s TFromLoc =  ##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
	.i TToLocDR '=""  d
	..s TToLoc =  ##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
	.s TMakerDR = $p($g(^DHCEQAMoveStock(rowid)),"^",6)
	.i TMakerDR '=""  d
	..s TMaker = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TMakerDR)
	.s TMakeDate = ##class(web.DHCEQCommon).TransValueToPage(TMakeDate,"date")
	.s TMakeTime = $p($g(^DHCEQAMoveStock(rowid)),"^",8)
	.s TToType = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAMoveStock(rowid)),"^",9),"date")
	.s TToSourceID = $p($g(^DHCEQAMoveStock(rowid)),"^",10)
	.s TSubmitUserDR = $p($g(^DHCEQAMoveStock(rowid)),"^",11)
	.i TSubmitUserDR '=""  d
	..s TSubmitUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TSubmitUserDR)
	.s TSubmitDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAMoveStock(rowid)),"^",12),"date")
	.s TSubmitTime = $p($g(^DHCEQAMoveStock(rowid)),"^",13)
	.s TMoveType = $CASE(TMoveType,"0":"出库","1":"库房调配","2":"退库",:"没有定义") 
	.s TStatus = ##Class(web.DHCEQAInStock).GetAInStockStatusList(TStatus)
	.s TReciverDR=$p($g(^DHCEQAMoveStock(rowid)),"^",15)
	.i TReciverDR'="" s TReciver=##Class(web.DHCEQCommon).GetTrakNameByID("user", TReciverDR)
	.s TAuditUserDR=$p($g(^DHCEQAMoveStock(rowid)),"^",16)
	.i TAuditUserDR'="" s TAuditUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", TAuditUserDR)
	.s TAuditDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAMoveStock(rowid)),"^",17),"date")
	.s TAuditTime=$p($g(^DHCEQAMoveStock(rowid)),"^",18)
	.s THold6=$p($g(^DHCEQAMoveStock(rowid)),"^",19)
	.s THold7=$p($g(^DHCEQAMoveStock(rowid)),"^",20)
	.s THold8=$p($g(^DHCEQAMoveStock(rowid)),"^",21)
	.s THold9=$p($g(^DHCEQAMoveStock(rowid)),"^",22)
	.s THold10=$p($g(^DHCEQAMoveStock(rowid)),"^",23)
	.s TRejectReason=$p($g(^DHCEQAMoveStock(rowid)),"^",24)
	.s TRejectUserDR=$p($g(^DHCEQAMoveStock(rowid)),"^",25)
	.i TRejectUserDR'="" s TRejectUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", TRejectUserDR)
	.s TRejectDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAMoveStock(rowid)),"^",26),"date")
	.s TRejectTime=$p($g(^DHCEQAMoveStock(rowid)),"^",27)
	.s TRemark=$p($g(^DHCEQAMoveStock(rowid)),"^",29)
	.s THold1=$p($g(^DHCEQAMoveStock(rowid)),"^",30)
	.s THold2=$p($g(^DHCEQAMoveStock(rowid)),"^",31)
	.s THold3=$p($g(^DHCEQAMoveStock(rowid)),"^",32)
	.s THold4=$p($g(^DHCEQAMoveStock(rowid)),"^",33)
	.s THold5=$p($g(^DHCEQAMoveStock(rowid)),"^",34)
	.s result=0		// Mozy0231	访问资金来源类型
	.;设置行背景色	Mozy	2016-6-14
	.s lrowid=""
	.For  Set lrowid=$Order(^DHCEQAMoveStockList(0,"MoveStock",rowid,lrowid)) Quit:(lrowid="")||(TBackGroupColor'="")  Do
	..i ($d(^DHCEQMMaintPart(0,"AMoveStockList",lrowid)))&&(##Class(web.DHCEQM.DHCEQMMaintPart).BussPrintInfo("A02",rowid)=0) s TBackGroupColor="#00ffff"
	..s result=##class(web.DHCEQCommon).FundsTypeIsIn(11,lrowid)
	.q:+result'=0
	.s TApprovals="无"
	.s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	.s CurRole=""
	.i AIRowID'="" d
	..s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	..s TApproveRoleDR=$Piece(^DHCEQApproveInfo(AIRowID),"^",7)
	..i TApproveRoleDR'="" s TApprovals=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR),"^",2)	//add by CZF0080 2020-02-24
	.i $p($g(^DHCEQAMoveStock(rowid)),"^",28)=0 s TApprovals="" //modified by czf 1214221 2020-03-05
	.q:((WaitAD="on")&&(CurRole'="")&&(CurRole'=ApproveRole))
	.d OutputRowGetAMoveStock
	quit
OutputRowGetAMoveStock
	s Data=$lb(TRowID,TFromLocDR,TFromLoc,TToLocDR,TToLoc,TMoveStockNo,TAccessoryTypeDR,TAccessoryType,TType,TMaker,TMakerDR,TMakeDate,TMakeTime,TToType,TToSourceID,TSubmitUserDR,TSubmitUser,TSubmitDate,TSubmitTime,TMoveType,TMoveTypeID,TReciverDR,TReciver,TAuditUserDR,TAuditUser,TAuditDate,TAuditTime,THold6,THold7,THold8,THold9,THold10,TRejectReason,TRejectUserDR,TRejectUser,TRejectDate,TRejectTime,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,TRow,TBackGroupColor,TApprovals)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetAMoveStock
	s (TRowID,TFromLocDR,TFromLoc,TToLocDR,TToLoc,TMoveStockNo,TAccessoryTypeDR,TAccessoryType,TType,TMaker,TMakerDR,TMakeDate,TMakeTime,TToType,TToSourceID,TSubmitUserDR,TSubmitUser,TSubmitDate,TSubmitTime,TMoveType,TMoveTypeID,TReciverDR,TReciver,TAuditUserDR,TAuditUser,TAuditDate,TAuditTime,THold6,THold7,THold8,THold9,THold10,TRejectReason,TRejectUserDR,TRejectUser,TRejectDate,TRejectTime,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,TBackGroupColor,TApprovals)=""
	quit
}

ClassMethod GetAMoveStockFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAMoveStockExecute ]
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

ClassMethod GetAMoveStockClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAMoveStockExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// modify BY:GBX THold2->TAInStockListDR 入库单明细ID

/// modified by kdf 2018-01-31 需求号：542709，增加供应商的输出列：TProvider
Query GetAMoveStockList(RowID) As %Query(ROWSPEC = "TRowID:%String,TRow:%String,TMoveStockDR:%String,TItemDR:%String,TCode:%String,TDesc:%String,TManuFactoryDR:%String,TManuFactory:%String,TQuantityNum:%String,TBaseUOM:%String,TSerialFlag:%String,TBaseUOMDR:%String,TAmount:%String,TModel:%String,TPrice:%String,TRemark:%String,TBatchFlag:%String,TStockDetailDR:%String,TAInStockListDR:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TJob:%String,TFlag:%String,TMRRowID:%String,TEquipDR:%String,TEquipName:%String,TFileNo:%String,TRequestNo:%String,TMoveNum:%String ,TProvider:%String")
{
}

ClassMethod GetAMoveStockListExecute(ByRef qHandle As %Binary, RowID) As %Status
{
	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s Job=$J
 	i RowID'="" s StoreLoc=$p($g(^DHCEQAMoveStore(RowID)),"^",2)
	s (TotalQty,TotalAmount,TotalLoc)=0
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")	//..
	i TotalFlag="1"  s index=2
	s TRow=0
	d BuildDataGetAMoveStoreList
	Quit $$$OK
BuildDataGetAMoveStoreList
	i RowID'=""
	{
		f  s rowid=$o(^DHCEQAMoveStockList(0,"MoveStock",RowID,rowid))  quit:rowid=""  d
		.d ResetVariablesGetAMoveStoreList
		.s TRowID=rowid
		.s TRow=TRow+1
		.s TItemDR = $p($g(^DHCEQAMoveStockList(rowid)),"^",2)
		.s TCode = $p($g(^DHCEQAMoveStockList(rowid)),"^",3)
		.s TDesc = $p($g(^DHCEQAMoveStockList(rowid)),"^",4)
		.s TModel= $p($g(^DHCEQAMoveStockList(rowid)),"^",5)
		.s TBaseUOMDR=$p($g(^DHCEQAMoveStockList(rowid)),"^",6)
		.i TBaseUOMDR '=""  d
		..s TBaseUOM = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TBaseUOMDR)
		.s TManuFactoryDR = $p($g(^DHCEQAMoveStockList(rowid)),"^",7)
		.i TManuFactoryDR '=""  d
		..s TManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
		.s TBatchFlag=$p($g(^DHCEQAMoveStockList(rowid)),"^",8)
		.i TBatchFlag="Y" d
		..s TBatchFlag=1
		.e  d
		..s TBatchFlag=0
		.s TSerialFlag=$p($g(^DHCEQAMoveStockList(rowid)),"^",9)
		.i TSerialFlag="Y" d
		..s TSerialFlag=1
		.e  d
		..s TSerialFlag=0
		.s TPrice=$p($g(^DHCEQAMoveStockList(rowid)),"^",10)
		.s TQuantityNum=$p($g(^DHCEQAMoveStockList(rowid)),"^",11)
		.i (TQuantityNum'=1&&TSerialFlag=1)  d //qw0005-2014-06-12
		..s TFlag=1
		.e  d
		..s TFlag=0
		.s TQuantityNum=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum,"",2)	//2017-2-7	Mozy格式化小数
		.s TotalQty=TotalQty+TQuantityNum
		.s TAmount=$p($g(^DHCEQAMoveStockList(rowid)),"^",12)
		.s TotalAmount=TotalAmount+TAmount
		.s TRemark=$p($g(^DHCEQAMoveStockList(rowid)),"^",13)
		.s TStockDetailDR = $p($g(^DHCEQAMoveStockList(rowid)),"^",14)
		.s TAInStockListDR = $p($g(^DHCEQAMoveStockList(rowid)),"^",15)
		./// 2017-2-7	Mozy	增加设备信息及维修单号
		.s TEquipDR = $p($g(^DHCEQAMoveStockList(rowid)),"^",16)
		.;s TMaintPartDR = $p($g(^DHCEQAMoveStockList(rowid)),"^",17)
		.;add by kdf 2018-01-31 需求号：542709 ，获取供应商 begin
		.s TAInStockListDR="",TAInStockDR="",TProviderDR=""
		.s TAInStockListDR = $p($g(^DHCEQAMoveStockList(rowid)),"^",15)
		.i TAInStockListDR'="" s TAInStockDR = $p($g(^DHCEQAInStockList(TAInStockListDR)),"^",1)
		.i TAInStockDR'="" s TProviderDR = $p($g(^DHCEQAInStock(TAInStockDR)),"^",8)
		.i TProviderDR'="" s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
		.;add by kdf 2018-01-31 需求号：542709 ，获取供应商 end
		.s THold1 = $p($g(^DHCEQAMoveStockList(rowid)),"^",18)
		.s THold2 = $p($g(^DHCEQAMoveStockList(rowid)),"^",19)
		.s THold3 = $p($g(^DHCEQAMoveStockList(rowid)),"^",20)
		.s THold4 = $p($g(^DHCEQAMoveStockList(rowid)),"^",21)
		.s THold5 = $p($g(^DHCEQAMoveStockList(rowid)),"^",22)	;库存数
		.;Mozy	2017-1-10
		.s id=$o(^DHCEQMMaintPart(0,"AMoveStockList",rowid,""))
		.;i (id="")&&(TAInStockListDR'="") s id=$o(^DHCEQMMaintPart(0,"AInStockList",TAInStockListDR,""))		;Mozy	566354	2018-3-16	注释
		.i id'="" d
		..s TMRRowID=$p($g(^DHCEQMMaintPart(id)),"^",9)	;MTP_MaintRequestDR
		..s TRequestNo=$p($g(^DHCEQMMaintRequest(TMRRowID)),"^",1)
		.
		.i (TMRRowID'="")&&(TEquipDR="") d
		..;获取维修单的设备DR
		..i $Piece($Get(^DHCEQMMaintRequest(TMRRowID)),"^",63)=1 Set TEquipDR=$Piece($Get(^DHCEQMExObj($Piece($Get(^DHCEQMMaintRequest(TMRRowID)),"^",5))),"^",5)	;Mozy0189	2017-5-26
		.
		.i TEquipDR'="" d
		..s TEquipName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
		..s TFileNo=$p($g(^DHCEQEquip(TEquipDR)),"^",85)
		.
		.s TJob=Job
		.
		.;;;;	Mozy	2017-1-11	可转移数量
		.s TStock=THold5
		.s FreezeNum=0
		.i TBatchFlag="Y" d
		..s TStock=$p($g(^DHCEQAStockDetail(TStockDetailDR)),"^",17)
		..s TFromLocDR=$p($g(^DHCEQAMoveStore(RowID)),"^",4)
		..s FreezeNum=##class(web.DHCEQAReduce).CheckAccessoryDR(TStockDetailDR,TFromLocDR,rowid,1)      ///被占用的数量
		.s TMoveNum=TStock-FreezeNum
		.
		.d OutputRowGetAMoveStoreList
	}
	i TRow=0 d
	.d ResetVariablesGetAMoveStoreList
	.s TRow=1
	.s TJob=Job
	.d OutputRowGetAMoveStoreList
	i TotalFlag="1" s TotalLoc=1
	i TotalFlag="2" s TotalLoc=index+1
	i TotalLoc'=0
	{
		d ResetVariablesGetAMoveStoreList
		s TRowID=-1
		s TRow="合计"
		s TQuantityNum=TotalQty
		s TAmount=TotalAmount
		s index=TotalLoc
		s TJob=Job
		d OutputRowGetAMoveStoreList
	}
	quit
OutputRowGetAMoveStoreList
	i TPrice'="" s TPrice=##Class(web.DHCEQCommon).FormatNumber(TPrice,"",4)
	i TQuantityNum'="" s TQuantityNum=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum,"",2)
	s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"",2)
	s Data=$lb(TRowID,TRow,TMoveStockDR,TItemDR,TCode,TDesc,TManuFactoryDR,TManuFactory,TQuantityNum,TBaseUOM,TSerialFlag,TBaseUOMDR,TAmount,TModel,TPrice,TRemark,TBatchFlag,TStockDetailDR,TAInStockListDR,THold1,THold2,THold3,THold4,THold5,TJob,TFlag,TMRRowID,TEquipDR,TEquipName,TFileNo,TRequestNo,TMoveNum ,TProvider)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAMoveStoreList
	s (TRowID,TMoveStockDR,TItemDR,TCode,TDesc,TManuFactoryDR,TManuFactory,TQuantityNum,TBaseUOM,TSerialFlag,TBaseUOMDR,TAmount,TModel,TPrice,TRemark,TBatchFlag,TStockDetailDR,TAInStockListDR,THold1,THold2,THold3,THold4,THold5,TSerialNo,TFlag,TMRRowID,TEquipDR,TEquipName,TFileNo,TRequestNo,TMoveNum ,TProvider)=""
	quit
}

ClassMethod GetAMoveStockListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAMoveStockListExecute ]
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

ClassMethod GetAMoveStockListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAMoveStockListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class("web.DHCEQAMoveStock").Execute("2,11,13,14,15,18")
ClassMethod Execute(valRowIDs As %Library.String = "")
{
	i valRowIDs="" Q 0
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s len=$l(valRowIDs,",")
	
	s SQLCODE=0
	for i=1:1:len q:SQLCODE<0  d
	.s val = $p(valRowIDs,",",i)_"^^^^^^^"_User
	.s SQLCODE=##Class(web.DHCEQAMoveStock).SubmitData(val)
	q len
}

}
