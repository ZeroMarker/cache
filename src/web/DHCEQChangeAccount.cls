Import SQLUser

/// Modified By HZY 2012-02-06 HZY0022
/// Desc:修改函数:SaveData :增加删除相应资金来源记录的功能.
///      修改函数:AuditData
/// -------------------------------
/// Modified by DJ 2010-03-15 DJ0041
/// Description:附件与调账单关联并打印附件入库单及附件出库单.
/// -------------------------------
/// Modified by jdl 2009-06-02 JDL0004
/// Add Method:GetInfosByEquip
/// --------------------------------
Class web.DHCEQChangeAccount Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter GlobalLen = 27;

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", user As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
	 //删除对应附件记录 2010-03-15 党军 DJ0041 begin
	 TSTART
	//Function:Funds	2012-2-16 生成资金来源信息
	//删除对应资金来源记录 Add By HZY 2012-02-06 HZY0022
	&SQL(Update SQLUSER.DHC_EQFunds Set F_InvalidFlag='Y' where F_SourceType=7 and F_SourceID=:rowid )
	if (SQLCODE'=0)&&(SQLCODE'=100)
	{
		TROLLBACK
		q SQLCODE
	}	
	//End By HZY 2012-02-06 HZY0022
	;Function:Funds	2012-2-28 生成资金来源信息
	;Modified by JDL 2012-2-27 JDL0117
	&SQL(Update SQLUSER.DHC_EQAffix Set AF_ChangeAccountAddDR=null Where AF_ChangeAccountAddDR=:rowid)
	if (SQLCODE'=0)&&(SQLCODE'=100)
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(Update SQLUSER.DHC_EQAffix Set AF_ChangeAccountReduceDR=null Where AF_ChangeAccountReduceDR=:rowid)
	if (SQLCODE'=0)&&(SQLCODE'=100)
	{
		TROLLBACK
		q SQLCODE
	}
	 
	 //2010-03-15 党军 DJ0041 end
 	&SQL(Delete From SQLUSER.DHC_EQChangeAccount where CA_RowID = :rowid and CA_Status<2)
 	
 	if SQLCODE //2010-03-15 党军 DJ0041 Begin
 	{
	 	TROLLBACK
	 	if (SQLCODE=100) s SQLCODE=-2022
	 	q SQLCODE
 	}
 	TCOMMIT //2010-03-15 党军 DJ0041 end
 	q rowid
 }
 s PLIST(1) = $p(val,"^",1)	;RowID
 s PLIST(2) = $p(val,"^",2)	;EquipDR
 s PLIST(3) = $p(val,"^",3)	;ChangeFee
 s PLIST(4) = $p(val,"^",4)	;ChangedOriginalFee
 s PLIST(5) = $p(val,"^",5)	;ChangedNetFee
 s PLIST(6) = $p(val,"^",6)	;TotalDepreFee
 s PLIST(7) = $p(val,"^",7)	;ChangeItem
 s PLIST(8) = $p(val,"^",8)	;ChangeReasonDR
 s PLIST(9) = $p(val,"^",9)	;ChangeReason
 s PLIST(10) = $p(val,"^",10)	;ChangeDate
 i $p(val,"^",10)'=""  s PLIST(10) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"date")	;ChangeDate
 s PLIST(11) = $p(val,"^",11)	;Remark
 s PLIST(12) = $p(val,"^",12)	;Status
 i (PLIST(12)="")  s PLIST(12)=0 
 /*
 s PLIST(13) = $p(val,"^",13)	;AddUserDR
 s PLIST(14) = $p(val,"^",14)	;AddDate
 i $p(val,"^",14)'=""  s PLIST(14) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",14),"date")	;AddDate
 s PLIST(15) = $p(val,"^",15)	;AddTime
 s PLIST(16) = $p(val,"^",16)	;UpdateUserDR
 s PLIST(17) = $p(val,"^",17)	;UpdateDate
 i $p(val,"^",17)'=""  s PLIST(17) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",17),"date")	;UpdateDate
 s PLIST(18) = $p(val,"^",18)	;UpdateTime
 s PLIST(19) = $p(val,"^",19)	;SubmitUserDR
 s PLIST(20) = $p(val,"^",20)	;SubmitDate
 i $p(val,"^",20)'=""  s PLIST(20) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",20),"date")	;SubmitDate
 s PLIST(21) = $p(val,"^",21)	;SubmitTime
 s PLIST(22) = $p(val,"^",22)	;AuditUserDR
 s PLIST(23) = $p(val,"^",23)	;AuditDate
 i $p(val,"^",23)'=""  s PLIST(23) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",23),"date")	;AuditDate
 s PLIST(24) = $p(val,"^",24)	;AuditTime
 */
 s PLIST(25) = $p(val,"^",25)	;OriginalFee
 s PLIST(26) = $p(val,"^",26)	;NetFee
 s PLIST(27) = $p(val,"^",27)	;NetRemainFee
 s PLIST(28) = $p(val,"^",28)	;ChangedNetRemainFee
 
 s AddChange =##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",29),"bool")	;AddChange //2010-03-15 党军 DJ0041 
 s CAAffixIDS= $p(val,"^",30)	;CAAffixIDS //2010-03-15 党军 DJ0041 
 
 if $p(val,"^",2)'=""  d
 .s PLIST(29)=$p($g(^DHCEQEquip($p(val,"^",2))),"^",67)	;StoreLocDR
 .s PLIST(30)=$p($g(^DHCEQEquip($p(val,"^",2))),"^",19)	;UseLocDR
 .s PLIST(31)=$p($g(^DHCEQEquip($p(val,"^",2))),"^",63)	;EquipTypeDR
 .s PLIST(32)=$p($g(^DHCEQEquip($p(val,"^",2))),"^",75)	;StatCatDR
 Set PLIST(34) = $Piece(val,"^",31)		;CA_Hold2	ChangeDepreTotalFee	///Mozy0148		调整的累计折旧
 //2014-12-16 DJ DJ0131 begin
 //变动后净值不能小于变动后净残值
 s RemainFeeRate=##class(web.DHCEQCommon).GetSysInfo("990029")
 i ##Class(web.DHCEQCommon).FormatNumber($p(val,"^",5),"",2)<##Class(web.DHCEQCommon).FormatNumber($p(val,"^",4)*RemainFeeRate/100,"",2) q -3002	//2014-12-16 DJ DJ0131 end
 
 //add by zy 20150610 ZY0128  //增加的折旧月份数
 Set PLIST(33)=$Piece(val,"^",32)	;Hold1
 Set PLIST(35)=$Piece(val,"^",33)	;Hold3
 Set PLIST(36)=$Piece(val,"^",34)	;Hold4
 Set PLIST(37)=$Piece(val,"^",35)	;Hold5
 k PLIST(1)
 TSTART
 if (rowid'="") 
 {
	 s ID=rowid
	 s PLIST(16) = user
	 s PLIST(17) = +$H
	 s PLIST(18) = $P($H,",",2)
	 &SQL(Update SQLUSER.DHC_EQChangeAccount Values :PLIST() where CA_RowID = :rowid and CA_Status<2) 	 
	 if SQLCODE
	 {
		 TROLLBACK
		 q SQLCODE
	 }
	 if (%ROWCOUNT<1)  q -2021
 }
 else
 {
	 s PLIST(13) = user
	 s PLIST(14) = +$H
	 s PLIST(15) = $P($H,",",2)
	 &SQL(Select CA_RowID from SQLUSER.DHC_EQChangeAccount Where CA_EquipDR=:PLIST(2) and CA_Status<2)
	 if (%ROWCOUNT>0)  q -1003
	 &SQL(Insert Into SQLUSER.DHC_EQChangeAccount Values :PLIST())
	 if SQLCODE //2010-03-15 党军 DJ0041 Begin
	 {
		 TROLLBACK
		 q SQLCODE
	 }
	 Set ID=$g(%ROWID)
 }
 ;Function:Funds	2012-2-28 生成资金来源信息
 ;Modified by JDL 2012-2-27 JDL0117
 ;先清除历史关联附件信息,避免在增减值转换过程中,残留垃圾关联数据
 s ChangeFee=+$p($g(^DHCEQChangeAccount(ID)),"^",2)
 if (rowid'="")
 {
	 ;非增值,或者有传入CAAffixIDS,则清掉之前的关联附件
	 if (ChangeFee'>0)||(CAAffixIDS'="")
	 {
		 &SQL(Update SQLUSER.DHC_EQAffix Set AF_ChangeAccountAddDR=null Where AF_ChangeAccountAddDR=:rowid)
		 if SQLCODE=100 s SQLCODE=0
		 if (SQLCODE'=0)
		 {
			 TROLLBACK
			 q SQLCODE
		 }
	 }
	 ;非增值,或者有传入CAAffixIDS,则清掉之前的关联附件
	 if (ChangeFee'<0)||(CAAffixIDS'="")
	 {
		 &SQL(Update SQLUSER.DHC_EQAffix Set AF_ChangeAccountReduceDR=null Where AF_ChangeAccountReduceDR=:rowid)
		 if SQLCODE=100 s SQLCODE=0
		 if (SQLCODE'=0)
		 {
			 TROLLBACK
			 q SQLCODE
		 }
	 }
 } 
 
 if CAAffixIDS'=""
 {	 
	 s Count=$l(CAAffixIDS,",")-1
	 for i=2:1:Count
	 {
		K PLIST
		s Affix=$p(CAAffixIDS,",",i)
		s AffixID=$p(Affix,":",1)
		s Flag=$p(Affix,":",2)
		if Flag="Y"
		{
			;Function:Funds	2012-2-28 生成资金来源信息
			;Modified by jdl 2012-2-28 JDL0117
			if ChangeFee>0
			{
				s PLIST(23)=ID
			}
			elseif ChangeFee<0
			{
				s PLIST(24)=ID
			}
			else
			{
				;调账金额为0,不能关联附件!
				s i=Count+1				
				s SQLCODE=-1004
				q
			}

			&SQL(Update DHC_EQAffix Values :PLIST() Where AF_RowID=:AffixID)
			if SQLCODE
			{
				s i=Count+1
			}
		}
	 }
 } //2010-03-15 党军 DJ0041 end
 if SQLCODE //2010-03-15 党军 DJ0041 begin
 {
	 TROLLBACK
	 q SQLCODE
 }
 TCOMMIT //2010-03-15 党军 DJ0041 end
 q ID
}

/// Function:Funds	2012-2-28 生成资金来源信息
/// Modified by JDL 2012-2-27 JDL0117
/// 返回值:0正常 1调账金额与关联附件金额不符 2调账未关联附件 3调账金额为0,却有关联附件
/// -----------------------------------------------------------
/// 新增:2010-03-15 党军 DJ0041 begin
/// 描述:判断调账金额是否与关联附件总金额相等
ClassMethod CheckFee(rowid)
{
 	s ChangeFee=+$p($g(^DHCEQChangeAccount(rowid)),"^",2)
 	;if ChangeFee<0 s ChangeFee=$fn(0-ChangeFee,"",2)
 	
 	;Modified by JDL 2012-2-27 JDL0117
 	s AffixCount=0
 	s AffixFee=0
 	if ChangeFee>0
 	{
 		&SQL(Select Count(*) Into:AffixCount From DHC_EQAffix Where AF_ChangeAccountAddDR=:rowid)
 		if AffixCount=0 q 2
 		&SQL(Select Sum(Round(AF_QuantityNum*AF_PriceFee,2)) Into:AffixFee From DHC_EQAffix Where AF_ChangeAccountAddDR=:rowid)
 	}
 	elseif ChangeFee<0
 	{
	 	&SQL(Select Count(*) Into:AffixCount From DHC_EQAffix Where AF_ChangeAccountReduceDR=:rowid)
	 	if AffixCount=0 q 2
	 	&SQL(Select Sum(Round(AF_QuantityNum*AF_PriceFee,2)) Into:AffixFee From DHC_EQAffix Where AF_ChangeAccountReduceDR=:rowid)
	}
	else
	{
		&SQL(Select Count(*) Into:AffixCount From DHC_EQAffix Where AF_ChangeAccountAddDR=:rowid or AF_ChangeAccountReduceDR=:rowid)
	 	if AffixCount>0 q 3
	}
 	if ChangeFee<0 s ChangeFee=##Class(web.DHCEQCommon).FormatNumber(0-ChangeFee,"",2)  //add by zx005
 	if (+ChangeFee'=+AffixFee) q 1		//Modify DJ 2015-09-14 DJ0164
 	q 0
}

/// ;Modified By JDL 2012-2-15 JDL0116
/// Modified By HZY 2012-02-09 HZY0022 
/// d ##class(web.DHCEQChangeAccount).AuditData("","",4,1,5)
ClassMethod AuditData(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "", user As %Library.String = "", changetype As %Library.String = "")
{
	///Mozy0148
	new updDate,updTime,EQStatus,NetFee,OriginalFee,DepreTotal,DepreSetID,DSDepreTotalFee
	new EQDepreTotalFee,ChangeDepreTotalFee,Fee,CADepreTotal
 	s updDate=+$H
 	s updTime=$P($H,",",2)
 	s RemainFeeRate=##class(web.DHCEQCommon).GetSysInfo("990029")		//2014-12-16 DJ DJ0131
 	if (changetype'="")  s changetype=$o(^DHCEQCCode("DHCEQCChangeType",0,"CTType",changetype,0))
 	;Modified by JDL 2012-1-4 JDL0108
 	k ^DHCEQTemp("ChangeAccount","Audit",$j,rowid)
 	Set $ZT="ERRORAudit"
 	
 	//通过附件调账,并且有附件有资金来源
 	s ChangeFee=$p($g(^DHCEQChangeAccount(rowid)),"^",2)
 	s ChangeEquipDR=$p($g(^DHCEQChangeAccount(rowid)),"^",1)
 	Set CADepreTotal=+$Piece($Get(^DHCEQChangeAccount(rowid)),"^",33)	;CA_Hold2	调账进行调整累计折旧值	Mozy0148
 	s CADepreTotalNum=+$Piece($Get(^DHCEQChangeAccount(rowid)),"^",34)	;CA_Hold3 	调整月数
 	s OriginalFee=$p($g(^DHCEQEquip(ChangeEquipDR)),"^",27)
 	s NetFee=$p($g(^DHCEQEquip(ChangeEquipDR)),"^",28)
 	Set EQDepreTotalFee=+$Piece($Get(^DHCEQEquip(ChangeEquipDR)),"^",35)
 	s EQStatus=$p($g(^DHCEQEquip(ChangeEquipDR)),"^",38)
 	if (EQStatus=3)
 	{
	 	TRollback
	 	q -2005
 	}
 	if ($p($g(^DHCEQChangeAccount(rowid)),"^",11)=2)
 	{
	 	TRollback
	 	q -2023
 	}
 	s SQLCODE=0
 	TStart 	
	//Function:Funds	2012-2-16 生成资金来源信息
 	s SQLCODE=##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew(7,rowid,ChangeFee)
 	if SQLCODE
 	{
	 	TROLLBACK
	 	q SQLCODE
 	}
 	
 	k PLIST
 	s PLIST(15)="1"			;SourceType
 	s PLIST(16)=ChangeEquipDR		;SourceID
 	s PLIST(2)=ChangeEquipDR
 	s PLIST(7)="0"
 	s PLIST(8)=user
	s PLIST(9)=updDate
	s PLIST(10)=updTime
	s PLIST(11)="N"
 		
	s CAFundsRowID=0
	f  s CAFundsRowID=$o(^DHCEQFunds("0","Source","7",rowid,CAFundsRowID))  q:((CAFundsRowID="")||(SQLCODE'=0))  d
	.q:$p($g(^DHCEQFunds(CAFundsRowID)),"^",10)="Y"
	.s TFundsRowID=""  //Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	.s FTypeDR=$p($g(^DHCEQFunds(CAFundsRowID)),"^",2)	;FundsType
	.s PLIST(3)=FTypeDR	;FundsType
	.//Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	.s FinaceItemDR = $Piece($Get(^DHCEQFunds(CAFundsRowID)),"^",20)	
	.s FunctionCatDR = $Piece($Get(^DHCEQFunds(CAFundsRowID)),"^",21)
	.s EQFundsRowID=0
	.f  s EQFundsRowID=$o(^DHCEQFunds("0","Source","1",ChangeEquipDR,EQFundsRowID))  q:((EQFundsRowID="")||(SQLCODE'=0))  d
	..q:$p($g(^DHCEQFunds(EQFundsRowID)),"^",10)="Y"
	..q:FTypeDR'=$p($g(^DHCEQFunds(EQFundsRowID)),"^",2)
	..q:FinaceItemDR'=$Piece($Get(^DHCEQFunds(EQFundsRowID)),"^",20)
	..q:FunctionCatDR'=$Piece($Get(^DHCEQFunds(EQFundsRowID)),"^",21)
	..s TFundsRowID=EQFundsRowID
	..	
	.//End By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	.Set TFee=+$Piece($Get(^DHCEQFunds(CAFundsRowID)),"^",3)	;Mozy0077	2012-2-22	调账审核时更新设备资金来源信息取值错误
	.Set TDepreTotalFee=+$Piece($Get(^DHCEQFunds(CAFundsRowID)),"^",13)		///Mozy0148
	.;Modify by zx 2020-02-24 调整错误修复
	.i TFundsRowID'=""  d
	..Set TFee=+$Piece($Get(^DHCEQFunds(TFundsRowID)),"^",3)+TFee
	..Set TDepreTotalFee=+$p($g(^DHCEQFunds(TFundsRowID)),"^",13)+TDepreTotalFee
	.i TFee<0 s SQLCODE=-3001
	.q:SQLCODE'=0
	.s PLIST(4)=TFee
	.Set PLIST(14)=TDepreTotalFee			///Mozy0148
	.Set PLIST(21) =FinaceItemDR    //Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	.Set PLIST(22) =FunctionCatDR   //Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	.i TFundsRowID'=""  d
	..&SQL(Update SQLUSER.DHC_EQFunds Values :PLIST() where F_RowID = :TFundsRowID)
	.e  d
	..&SQL(Insert Into SQLUSER.DHC_EQFunds Values :PLIST())
 	if SQLCODE 
 	{
	 	TRollback
	 	q SQLCODE
 	}
 	
 	;Mozy0088	2012-9-10	在进行调账后按资金比例重新均分各资金来源的累计折旧
 	;当进行增值和减值调账后,各资金来源的累计折旧会增多和减少一部分
 	If (ChangeFee=0)&(CADepreTotal=0)
 	{
	 	Set FundsRowID=0
		For  Set FundsRowID=$Order(^DHCEQFunds("0","Equip",ChangeEquipDR,FundsRowID)) Quit:((FundsRowID="")||(SQLCODE'=0))  Do
		.Quit:$Piece($Get(^DHCEQFunds(FundsRowID)),"^",10)="Y"
	 	.Set TFee=+$Piece($Get(^DHCEQFunds(FundsRowID)),"^",3)
		.Set TDepreTotalFee=+$Piece($Get(^DHCEQFunds(FundsRowID)),"^",13)
	 	.Set ChangeDepreTotalFee=TFee*EQDepreTotalFee/OriginalFee
	 	.Set ChangeDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(ChangeDepreTotalFee,"",2)
	 	.s FinaceItemDR=$Piece($Get(^DHCEQFunds(FundsRowID)),"^",20)   //Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
		.s FunctionCatDR=$Piece($Get(^DHCEQFunds(FundsRowID)),"^",21)  //Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	 	.;存储变动的累计折旧值
	 	.Set FTypeDR=$Piece($Get(^DHCEQFunds(FundsRowID)),"^",2)
	 	.Set id=""
		.//Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	 	.&SQL(Select f_rowid into :id from SQLUSER.DHC_EQFunds where F_FundsTypeDR=:FTypeDR and F_SourceType=7 and F_SourceID=:rowid and F_Hold4=:FinaceItemDR and F_Hold5=:FunctionCatDR)
	 	.If (SQLCODE=100) Set SQLCODE=0
	 	.If (id'="") Do
	 	..Set ChangeDepreTotalFee=+$Piece($Get(^DHCEQFunds(id)),"^",13)
	 	..If (ChangeDepreTotalFee=0) Do
	 	...;调整资金来源
	 	...Set TFee=+$Piece($Get(^DHCEQFunds(FundsRowID)),"^",3)
		...Set TDepreTotalFee=+$Piece($Get(^DHCEQFunds(FundsRowID)),"^",13)
	 	...Set ChangeDepreTotalFee=TFee*EQDepreTotalFee/OriginalFee
	 	...Set ChangeDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(ChangeDepreTotalFee,"",2)
	 	...
	 	...Set Fee=ChangeDepreTotalFee-TDepreTotalFee
	 	...&SQL(Update SQLUSER.DHC_EQFunds Set F_DepreTotal=:Fee where F_RowID = :id)
	 	...Quit:SQLCODE'=0
	 	...&SQL(Update SQLUSER.DHC_EQFunds Set F_DepreTotal=:ChangeDepreTotalFee where F_RowID = :FundsRowID)
	 	
	 	If SQLCODE 
	 	{
		 	TRollback
		 	Quit SQLCODE
	 	}
 	}
 	/*s OriginalFee=OriginalFee+ChangeFee
 	s NetFee=NetFee+ChangeFee
 	s NetRemainFee=##Class(web.DHCEQCommon).FormatNumber(OriginalFee*RemainFeeRate/100,"",2)	//2014-12-16 DJ DJ0131
 	i NetFee<0 s NetFee=0
	///Mozy0148
 	Set DepreTotal=OriginalFee-NetFee
 	If CADepreTotal'=0
 	{
 		Set DepreTotal=OriginalFee-NetFee+CADepreTotal
 		Set NetFee=NetFee-CADepreTotal
 	}*/
 	//modified by wy 2021-3-4 更新调账计算方式 WY0085
 	Set OriginalFee=OriginalFee+ChangeFee
 	Set DepreTotal=EQDepreTotalFee+CADepreTotal
 	Set NetFee=OriginalFee-DepreTotal
 	Set NetRemainFee=##Class(web.DHCEQCommon).FormatNumber(OriginalFee*RemainFeeRate/100,"",2)	//2014-12-16 DJ DJ0131
 	i (NetFee<0)||(OriginalFee<0)||(DepreTotal<0) s SQLCODE=-3004
	If SQLCODE 
	 {
		 	TRollback
		 	Quit SQLCODE
	 }
 	;Modified by JDL 2011-6-17 JDL0084
 	&SQL(Update SQLUSER.DHC_EQChangeAccount set CA_Status=2,CA_AuditUserDR=:user,CA_AuditDate=:updDate,CA_AuditTime=:updTime,CA_Hold1=:EQStatus where CA_RowID = :rowid)
 	if SQLCODE 
 	{
	 	TRollback
	 	q SQLCODE
 	}
 	
 	/*  From V4.0 JDL20150827  DHC_EQChangeInfo 旧表已经无效，变动信息记在LifeInfo里，DHC_EQChangeInfo新表用于设备启用、停用等变动记录。
 	&SQL(Insert Into SQLUSER.DHC_EQChangeInfo 
 			(CI_EquipDR,CI_ChangeTypeDR,CI_ChangeReason,CI_ChangeDate,CI_MainID,CI_Remark,CI_AuditFlag,CI_ChangeDesc,CI_InvalidFlag,CI_AddUserDR,CI_AddDate,CI_AddTime,CI_AuditUserDR,CI_AuditDate,CI_AuditTime)
 		 Select CA_EquipDR,:changetype,CA_ChangeReason,CA_ChangeDate,:rowid,CA_Remark,'Y','','N',CA_AddUserDR,CA_AddDate,CA_AddTime,CA_AuditUserDR,CA_AuditDate,CA_AuditTime
 		 from SQLUSER.DHC_EQChangeAccount where CA_RowID=:rowid)
 	if SQLCODE 
 	{
	 	TRollback
	 	q SQLCODE
 	}
 	*/
 	
 	/**************************************************************/ //2009-08-10 党军 begin DJ0023
 	s LI(2)=ChangeEquipDR  //设备
	s LI(4)=$p($g(^DHCEQEquip(LI(2))),"^",19)   //原使用科室
	s LI(5)=$p($g(^DHCEQEquip(LI(2))),"^",17) //原管理科室
	s LI(6)=$p($g(^DHCEQEquip(LI(2))),"^",67)  //原库房
	s LI(7)=$p($g(^DHCEQEquip(LI(2))),"^",27)  //原值
	s LI(8)=$p($g(^DHCEQEquip(LI(2))),"^",28)  //原净值
	s LI(14)=$p($g(^DHCEQChangeAccount(rowid)),"^",8)  //变动原因
	s LI(15)=$p($g(^DHCEQChangeAccount(rowid)),"^",6)  //变动描述
	s LI(16)=updDate	//变动日期
	s LI(17)=updTime	//变动时间
	s LI(19)="C"	//生命周期类型
	s LI(20)=51	//来源类型
	s LI(21)=rowid	//来源ID
	s LI(23)=$p($g(^DHCEQChangeAccount(rowid)),"^",10)  //备注
	s LI(27)=user	//更新人
	s LI(28)=updDate	//更新日期
	s LI(29)=updTime	//更新时间
 	/**************************************************************/
 	//2014-12-16 DJ DJ0131
 	&SQL(Update SQLUSER.DHC_EQEquip set EQ_NetFee=:NetFee,EQ_OriginalFee=:OriginalFee,EQ_NetRemainFee=:NetRemainFee,EQ_DepreTotalFee=:DepreTotal where EQ_RowID = :ChangeEquipDR)
 	if SQLCODE 
 	{
	 	TRollback
	 	q SQLCODE
 	}
 	/**************************************************************/
	s LI(9)=$p($g(^DHCEQEquip(LI(2))),"^",19)   //变动后使用科室
	s LI(10)=$p($g(^DHCEQEquip(LI(2))),"^",17) //变动后管理科室
	s LI(11)=$p($g(^DHCEQEquip(LI(2))),"^",67)  //变动后库房
	s LI(12)=$p($g(^DHCEQEquip(LI(2))),"^",27)  //变动后原值
	s LI(13)=$p($g(^DHCEQEquip(LI(2))),"^",28)  //变动后净值
	&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	///Mozy0148
	if SQLCODE
	{
		TRollBack
		q SQLCODE
	}
	
	Set DepreSetID=$Order(^DHCEQDepreSet(0,"Source",1,0,ChangeEquipDR,0))
	
	
	i DepreSetID'=""
	{
		Set DSDepreTotalFee=CADepreTotal+$Piece($Get(^DHCEQDepreSet(DepreSetID)),"^",23)
		Set DSDepreTotalNum=CADepreTotalNum+$Piece($Get(^DHCEQDepreSet(DepreSetID)),"^",22)
		&SQL(update sqluser.DHC_EQDepreSet set DS_DepreTotalFee=:DSDepreTotalFee,DS_DepreTotal=:DSDepreTotalNum where DS_RowID=:DepreSetID)
	 	if SQLCODE
		{
			TRollBack
			q SQLCODE
		}
	}
	
 	;Mozy0089	2012-10-17
 	Set SQLCODE=##Class(web.DHCEQBusinessCommon).GetBillInfoStr(7, rowid)
 	If SQLCODE
	{
		TRollBack
		Quit SQLCODE
	}
 	TCommit
 	q rowid

ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
	q -2201		;操作失败
 	;Quit "ERRORAudit"_ErrorMsg     //返回错误消息 ;
}

ClassMethod GetChangeAccountByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex,i,count
	s (result,resultex)=""
	s result= ^DHCEQChangeAccount(rowid)
	set count=..#GlobalLen-$l(result,"^")
	for i=count:-1:1 { s result=result_"^"}	
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;ChangeReasonDR
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCValueChangeReason",$p(result,"^",7))),"^",2)
	s $p(result,"^",9)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")	;ChangeDate
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",12))
	s $p(result,"^",13)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",13),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",15))
	s $p(result,"^",16)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",16),"date")	;UpdateDate
	s resultex=resultex_"^"	;SubmitUserDR
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",18))
	s $p(result,"^",19)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",19),"date")	;SubmitDate
	s resultex=resultex_"^"	;AuditUserDR
	i $p(result,"^",21)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",21))
	s $p(result,"^",22)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",22),"date")	;AuditDate
	
	s resultex=resultex_"^"_##class(web.DHCEQCommon).GetEditStatusDisplay($p(result,"^",12))
	
	//Function:Funds	2012-2-16 生成资金来源信息
	;Modified by jdl 2012-2-15 JDL0116
	s LinkAffixFlag=0
	if $p(result,"^",2)>0
	{
		if ($o(^DHCEQAffix("0","ChangeAccountAdd",rowid,0))>0) s LinkAffixFlag=1
	}
	elseif $p(result,"^",2)<0
	{
		if ($o(^DHCEQAffix("0","ChangeAccountReduce",rowid,0))>0) s LinkAffixFlag=1
	}
	;Modified By QW20210629 BUG:QW0129 增加维修单据 begin
	s RequestNo=""
	i $p(result,"^",35)'=""  d
	.s RequestNo=$Piece($Get(^DHCEQMMaintRequest($p(result,"^",35))),"^",1)
	s result=result_resultex_"^"_LinkAffixFlag_"^"_RequestNo
	;Modified By QW20210629 BUG:QW0129 增加维修单据 end
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

Query GetChangeAccount(EquipDR As %String) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TChangeFee:%String,TChangedOriginalFee:%String,TChangedNetFee:%String,TTotalDepreFee:%String,TChangeItem:%String,TChangeReasonDR:%String,TChangeReason:%String,TChangeDate:%String,TRemark:%String,TStatus:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TOriginalFee:%String,TNetFee:%String,TNetRemainFee:%String,TChangedNetRemainFee:%String,TEquip:%String,TChangeReason:%String,TAddUser:%String,TUpdateUser:%String,TSubmitUser:%String,TAuditUser:%String,TChangeDepreTotalFee:%String,TRow:%String")
{
}

ClassMethod GetChangeAccountExecute(ByRef qHandle As %Binary, EquipDR As %String) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	Set TRow=0
	d BuildDataGetChangeAccount
	Quit $$$OK
BuildDataGetChangeAccount
	f  s rowid=$o(^DHCEQChangeAccount(0,"Equip",EquipDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetChangeAccount
	.s TRowID = rowid
	.s TEquipDR = $p($g(^DHCEQChangeAccount(rowid)),"^",1)
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TChangeFee = $p($g(^DHCEQChangeAccount(rowid)),"^",2)
	.s TChangedOriginalFee = $p($g(^DHCEQChangeAccount(rowid)),"^",3)
	.s TChangedNetFee = $p($g(^DHCEQChangeAccount(rowid)),"^",4)
	.s TTotalDepreFee = $p($g(^DHCEQChangeAccount(rowid)),"^",5)
	.s TChangeItem = $p($g(^DHCEQChangeAccount(rowid)),"^",6)
	.s TChangeReasonDR = $p($g(^DHCEQChangeAccount(rowid)),"^",7)
	.i TChangeReasonDR '=""  d
	..s TChangeReason = $p($g(^DHCEQCCode("DHCEQCValueChangeReason",TChangeReasonDR)),"^",2)
	.s TChangeReason = $p($g(^DHCEQChangeAccount(rowid)),"^",8)
	.s TChangeDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeAccount(rowid)),"^",9),"date")
	.s TRemark = $p($g(^DHCEQChangeAccount(rowid)),"^",10)
	.s TStatus = $p($g(^DHCEQChangeAccount(rowid)),"^",11)
	.s TStatus = ##class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	.s TAddUserDR = $p($g(^DHCEQChangeAccount(rowid)),"^",12)
	.i TAddUserDR '=""  d
	..s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	.s TAddDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeAccount(rowid)),"^",13),"date")
	.s TAddTime = $p($g(^DHCEQChangeAccount(rowid)),"^",14)
	.s TUpdateUserDR = $p($g(^DHCEQChangeAccount(rowid)),"^",15)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeAccount(rowid)),"^",16),"date")
	.s TUpdateTime = $p($g(^DHCEQChangeAccount(rowid)),"^",17)
	.s TSubmitUserDR = $p($g(^DHCEQChangeAccount(rowid)),"^",18)
	.i TSubmitUserDR '=""  d
	..s TSubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	.s TSubmitDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeAccount(rowid)),"^",19),"date")
	.s TSubmitTime = $p($g(^DHCEQChangeAccount(rowid)),"^",20)
	.s TAuditUserDR = $p($g(^DHCEQChangeAccount(rowid)),"^",21)
	.i TAuditUserDR '=""  d
	..s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	.s TAuditDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeAccount(rowid)),"^",22),"date")
	.s TAuditTime = $p($g(^DHCEQChangeAccount(rowid)),"^",23)
	.s TOriginalFee = $p($g(^DHCEQChangeAccount(rowid)),"^",24)
	.s TNetFee = $p($g(^DHCEQChangeAccount(rowid)),"^",25)
	.s TNetRemainFee = $p($g(^DHCEQChangeAccount(rowid)),"^",26)
	.s TChangedNetRemainFee = $p($g(^DHCEQChangeAccount(rowid)),"^",27)
	.Set TChangeDepreTotalFee=$Piece($Get(^DHCEQChangeAccount(rowid)),"^",33)	///Mozy0148
	.Set TChangedNetFee=##Class(web.DHCEQCommon).FormatNumber(TChangedNetFee,"",2)	//Modify DJ 2015-09-14 DJ0164 begin
	.Set TTotalDepreFee=##Class(web.DHCEQCommon).FormatNumber(TTotalDepreFee,"",2)
	.Set TChangedOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TChangedOriginalFee,"",2)
	.Set TChangeFee=##Class(web.DHCEQCommon).FormatNumber(TChangeFee,"",2)
	.Set TChangeDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TChangeDepreTotalFee,"",2)	//Modify DJ 2015-09-14 DJ0164 end
	.d OutputRowGetChangeAccount
	quit
OutputRowGetChangeAccount
	Set TRow=TRow+1
	Set Data=$lb(TRowID,TEquipDR,TChangeFee,TChangedOriginalFee,TChangedNetFee,TTotalDepreFee,TChangeItem,TChangeReasonDR,TChangeReason,TChangeDate,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TOriginalFee,TNetFee,TNetRemainFee,TChangedNetRemainFee,TEquip,TChangeReason,TAddUser,TUpdateUser,TSubmitUser,TAuditUser,TChangeDepreTotalFee,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetChangeAccount
	Set (TRowID,TEquipDR,TChangeFee,TChangedOriginalFee,TChangedNetFee,TTotalDepreFee,TChangeItem,TChangeReasonDR,TChangeReason,TChangeDate,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TOriginalFee,TNetFee,TNetRemainFee,TChangedNetRemainFee,TEquip,TChangeReason,TAddUser,TUpdateUser,TSubmitUser,TAuditUser,TChangeDepreTotalFee)=""
	quit
}

ClassMethod GetChangeAccountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChangeAccountExecute ]
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

ClassMethod GetChangeAccountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChangeAccountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQChangeAccount).GetInfosByEquip(1)
ClassMethod GetInfosByEquip(EquipDR)
{
	new rowid,infos
	if EquipDR="" q ""
	s infos=""
	s rowid=0
	f  s rowid=$o(^DHCEQChangeAccount(0,"Equip",EquipDR,rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQChangeAccount(rowid)),"^",11)'=2
	.if infos'="" s infos=infos_"&"
	.s infos=infos_..GetChangeAccountByID("","",rowid)
	
	q infos
}

/*****************************************************************/
/// 2010-03-15 党军 begin DJ0041
ClassMethod ChangeAccountAffixClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ChangeAccountAffixExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ChangeAccountAffixExecute(ByRef qHandle As %Binary, EquipDR As %Library.String = "", ChangeAccountDR As %Library.String = "", AddChange As %Library.String = "", CAAffixIDS As %Library.String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetChangeAccountAffix
	Quit $$$OK
BuildDataGetChangeAccountAffix
	s AddChange=##class(web.DHCEQCommon).TransValueFromPage(AddChange,"bool")
	f  s rowid=$o(^DHCEQAffix(0,"Equip",EquipDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetChangeAccountAffix
	.s TFlag=0  //modify by lmm 2018-09-10 hisui改造：修改勾选框输出值
	.s TAffixDR=rowid
	.s flag=0
	.s CARowAddID=$p($g(^DHCEQAffix(rowid)),"^",22)
	.s CARowReduceID=$p($g(^DHCEQAffix(rowid)),"^",23)
	.i (ChangeAccountDR'="")&&((ChangeAccountDR=CARowAddID)||(ChangeAccountDR=CARowReduceID)) s flag=1
	.i (CAAffixIDS'="")&&(CAAffixIDS[(","_rowid_":Y,")) s flag=1
	.s DisUseFlag=$p($g(^DHCEQAffix(rowid)),"^",14)
	.q:(flag=0)&&(DisUseFlag="Y")
	.s InvalidFlag=$p($g(^DHCEQAffix(rowid)),"^",15)
	.q:(flag=0)&&(InvalidFlag="Y")
	.q:(flag=0)&&(AddChange="Y")&&((CARowAddID'="")||(CARowReduceID'=""))
	.q:(flag=0)&&(AddChange="N")&&(CARowReduceID'="")
	.i flag=1 s TFlag="1"  //modify by lmm 2018-09-10 hisui改造：修改勾选框输出值
	.s TAffix=$p($g(^DHCEQAffix(rowid)),"^",4)
	.s TModel=$p($g(^DHCEQAffix(rowid)),"^",5)
	.s TManuFacturer=$p($g(^DHCEQAffix(rowid)),"^",6)
	.s TManuFacturer=##class(web.DHCEQCommon).GetTrakNameByID("manufacture",TManuFacturer)    //modified by myl 20210917 1875522 	 
	.s TUnit=$p($g(^DHCEQAffix(rowid)),"^",13)
	.i TUnit'="" s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	.s TLeaveFactoryNo=$p($g(^DHCEQAffix(rowid)),"^",9)
	.i $d(^DHCEQAffix(rowid,"EX")) s TLeaveFactoryNo=$g(^DHCEQAffix(rowid,"EX"))	//Add By DJ 2016-11-30
	.s TPrice=$p($g(^DHCEQAffix(rowid)),"^",11)
	.s TNum=$p($g(^DHCEQAffix(rowid)),"^",7)
	.s TAmount=##Class(web.DHCEQCommon).FormatNumber(TPrice*TNum,"",2)
	.s TRemark=$p($g(^DHCEQAffix(rowid)),"^",12)
	.s TProvider=$p($g(^DHCEQAffix(rowid)),"^",24)
	.i TProvider'="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
	.d OutputRowGetChangeAccountAffix
	quit
OutputRowGetChangeAccountAffix
	s Data=$lb(TAffix,TModel,TManuFacturer,TUnit,TLeaveFactoryNo,TPrice,TNum,TAmount,TRemark,TFlag,TAffixDR,TProvider)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetChangeAccountAffix
	s (TAffix,TModel,TManuFacturer,TUnit,TLeaveFactoryNo,TPrice,TNum,TAmount,TRemark,TFlag,TAffixDR,TProvider)=""
	quit
}

ClassMethod ChangeAccountAffixFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ChangeAccountAffixExecute ]
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

Query ChangeAccountAffix(EquipDR As %Library.String = "", ChangeAccountDR As %Library.String = "", AddChange As %Library.String = "", CAAffixIDS As %Library.String = "") As %Query(ROWSPEC = "TAffix:%String,TModel:%String,TManuFacturer:%String,TUnit:%String,TLeaveFactoryNo:%String,TPrice:%String,TNum:%String,TAmount:%String,TRemark:%String,TFlag:%String,TAffixDR:%String,TProvider:%String")
{
}

/*****************************************************************/
ClassMethod UpdateCAAffix(IDS As %Library.String = "", ChangeAccountDR As %Library.String = "")
{
	s ChangeFee=+$p($g(^DHCEQChangeAccount(ChangeAccountDR)),"^",2)
	s Count=$l(IDS,",")-1
	TSTART
	for i=1:1:Count
	{
		s ID=$p($p(IDS,",",i),":",1)
		s Flag=$p($p(IDS,",",i),":",2)
		if ChangeFee>0
		{
			if Flag="Y"
			{
				s PLIST(23)=ChangeAccountDR
			}
			else
			{
				s PLIST(23)=""
			}
		}
		else
		{
			if Flag="Y"
			{
				s PLIST(24)=ChangeAccountDR
			}
			else
			{
				s PLIST(24)=""
			}
		}
		&SQL(Update DHC_EQAffix Values :PLIST() Where AF_RowID=:ID)
		if SQLCODE
		{
			s i=Count+1
		}
	}
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q ChangeAccountDR
}

/*****************************************************************/
ClassMethod GetOneChangeAccount(CARowID)
{
	s EquipName=""
	s EquipNo=""
	s UseLoc=""
	Set Model=""
	Set Unit=""
	Set LeaveFactoryNo=""
	s EquipDR=$p($g(^DHCEQChangeAccount(CARowID)),"^",1)
	i EquipDR'=""  d
	.s EquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	.s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	.s UseLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",19)
	.i UseLocDR'="" s UseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)
	.Set Model=$Piece($Get(^DHCEQEquip(EquipDR)),"^",3)
	.If Model'="" Set Model=##class(web.DHCEQCommon).GetTrakNameByID("model",Model)
	.Set Unit=$Piece($Get(^DHCEQEquip(EquipDR)),"^",5)
	.If Unit'="" Set Unit=##class(web.DHCEQCommon).GetTrakNameByID("uom",Unit)
	.Set LeaveFactoryNo=$Piece($Get(^DHCEQEquip(EquipDR)),"^",10)
	.//Mozy	2017-2-2
	.Set Expenditures=$Piece($Get(^DHCEQEquip(EquipDR)),"^",95)
	.i Expenditures'="" s Expenditures=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",Expenditures)),"^",2)
	.Set Location=$Piece($Get(^DHCEQEquip(EquipDR)),"^",72)
	.i Location'="" s Location=##Class(web.DHCEQCommon).GetTrakNameByID("location", Location)
	s ChangeDate=$p($g(^DHCEQChangeAccount(CARowID)),"^",9)
	s ChangeDate=##class(web.DHCEQCommon).TransValueToPage(ChangeDate,"date")
	s OldOriginalFee=$p($g(^DHCEQChangeAccount(CARowID)),"^",24)
	s NewOriginalFee=$p($g(^DHCEQChangeAccount(CARowID)),"^",3)
	s OldOriginalFee=##Class(web.DHCEQCommon).FormatNumber(OldOriginalFee,"",2)
	s NewOriginalFee=##Class(web.DHCEQCommon).FormatNumber(NewOriginalFee,"",2)
	
	q EquipNo_"^"_EquipName_"^"_ChangeDate_"^"_OldOriginalFee_"^"_NewOriginalFee_"^"_UseLoc_"^"_Model_"^"_Unit_"^"_LeaveFactoryNo_"^"_Expenditures_"^"_Location
}

ClassMethod GetList(EquipDR, CARowID)
{
	s rowid=0
	s Count=0
	s Amount=0
	s Data=""
	f  s rowid=$o(^DHCEQAffix(0,"Equip",EquipDR,rowid)) q:rowid=""  d
	.s CAAddID=$p($g(^DHCEQAffix(rowid)),"^",22)
	.s CAReduceID=$p($g(^DHCEQAffix(rowid)),"^",23)
	.q:(CAAddID'=CARowID)&&(CAReduceID'=CARowID)
	.s Count=Count+1
	.s TAffix=$p($g(^DHCEQAffix(rowid)),"^",4)
	.s TModel=$p($g(^DHCEQAffix(rowid)),"^",5)
	.s TPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAffix(rowid)),"^",11),"",2)
	.s TNum=$p($g(^DHCEQAffix(rowid)),"^",7)
	.s TAmount=##Class(web.DHCEQCommon).FormatNumber(TPrice*TNum,"",2)
	.s Amount=Amount+TAmount
	.s TRemark=$p($g(^DHCEQAffix(rowid)),"^",12)
	.s Data=Data_":"_TAffix_"^"_TModel_"^"_TPrice_"^"_TNum_"^"_TAmount_"^"_TRemark
	q Data_"_"_Count
}

/*****************************************************************/
///                                        2010-03-15 党军 end DJ0041
/// modified by ZY0242 折旧方法计算中增加数据调整那里的增加的月份和原值的计算
/// add by zy 20150610 ZY0128  增加的折旧月份数
/// w ##Class(web.DHCEQChangeAccount).GetAddDepreTotalNum(1629)
ClassMethod GetAddDepreTotalNum(EquipDR, vDate As %Library.String = "")
{
	new rowid, Num,PreOriginalFee,AuditDate,OriginalFee
	if EquipDR="" q ""
	s PreOriginalFee=""
	s (rowid,Num)=0
	f  s rowid=$o(^DHCEQChangeAccount(0,"Equip",EquipDR,rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQChangeAccount(rowid)),"^",11)'=2
	.s Num=Num+$p($g(^DHCEQChangeAccount(rowid)),"^",34)
	.s AuditDate=$p($g(^DHCEQChangeAccount(rowid)),"^",22)
	.s OriginalFee=$p($g(^DHCEQChangeAccount(rowid)),"^",24)
	.q:vDate=""
	.i ##Class(web.DHCEQReport).GetReportMonthByDate(AuditDate)=##Class(web.DHCEQReport).GetReportMonthByDate(vDate) d
	..i PreOriginalFee="" s PreOriginalFee=OriginalFee
	q Num_"^"_PreOriginalFee
}

///  add by sjh 2019-11-28 附件入出库单润乾打印  BUG00018
///  d ##Class(%ResultSet).RunQuery("web.DHCEQChangeAccount","AffixRunQianPrint","1")
/// TRowID,TAffix,TModel,TPrice,TNum,TAmount,TRemark
Query AffixRunQianPrint(RowID As %String) As %Query(ROWSPEC = "TRowID:%String,TAffix:%String,TModel:%String,TPrice:%String,TNum:%String,TAmount:%String,TRemark:%String") [ SqlProc ]
{
}

ClassMethod AffixRunQianPrintExecute(ByRef qHandle As %Binary, RowID As %String) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1

	q:RowID=""
	s EquipDR=$p($g(^DHCEQChangeAccount(RowID)),"^",1)
	s rowid=0 
	f  s rowid=$o(^DHCEQAffix(0,"Equip",EquipDR,rowid)) q:rowid=""  d
	.d ResetVariablesAffixRunQian
	.s CAAddID=$p($g(^DHCEQAffix(rowid)),"^",22)
	.s CAReduceID=$p($g(^DHCEQAffix(rowid)),"^",23)
	.q:(CAAddID'=RowID)&&(CAReduceID'=RowID)
	.s TAffix=$p($g(^DHCEQAffix(rowid)),"^",4)
	.s TModel=$p($g(^DHCEQAffix(rowid)),"^",5)
	.s TPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAffix(rowid)),"^",11),"",2)
	.s TNum=$p($g(^DHCEQAffix(rowid)),"^",7)
	.s TAmount=##Class(web.DHCEQCommon).FormatNumber(TPrice*TNum,"",2)
	.s TRemark=$p($g(^DHCEQAffix(rowid)),"^",12) 
	.s TRowID=rowid
	.d OutputRowAffixRunQianPrint
	quit $$$OK
OutputRowAffixRunQianPrint
	Set Data=$lb(TRowID,TAffix,TModel,TPrice,TNum,TAmount,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesAffixRunQian
	Set (TRowID,TAffix,TModel,TPrice,TNum,TAmount,TRemark)=""
	quit
}

ClassMethod AffixRunQianPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AffixRunQianPrintExecute ]
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

ClassMethod AffixRunQianPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AffixRunQianPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

///  add by sjh 2019-11-28 附件入出库单润乾打印  BUG00018
///  d ##Class(%ResultSet).RunQuery("web.DHCEQChangeAccount","AffixRunQianPrintA","1")
/// TEquipNo,TEquipName,TChangeDate,TOriginalFee,TChangedOriginalFee,TUseLoc
Query AffixRunQianPrintA(RowID As %String) As %Query(ROWSPEC = "TEquipNo:%String,TEquipName:%String,TChangeDate:%String,TOriginalFee:%String,TChangedOriginalFee:%String,TUseLoc:%String") [ SqlProc ]
{
}

ClassMethod AffixRunQianPrintAExecute(ByRef qHandle As %Binary, RowID As %String) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1

	q:RowID=""
	s EquipDR=$p($g(^DHCEQChangeAccount(RowID)),"^",1)
	d ResetVariablesAffixRunQianPrintA
	s TEquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	s TEquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	s UseLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",19)
	i UseLocDR'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)
	s TChangeDate=$p($g(^DHCEQChangeAccount(RowID)),"^",9)
	s TChangeDate=##class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	s TOriginalFee=$p($g(^DHCEQChangeAccount(RowID)),"^",24)
	s TChangedOriginalFee=$p($g(^DHCEQChangeAccount(RowID)),"^",3)	//modified by csj 2020-02-17
	d OutputRowAffixRunQianPrintA
	quit $$$OK
OutputRowAffixRunQianPrintA
	Set Data=$lb(TEquipNo,TEquipName,TChangeDate,TOriginalFee,TChangedOriginalFee,TUseLoc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesAffixRunQianPrintA
	Set (TEquipNo,TEquipName,TChangeDate,TOriginalFee,TChangedOriginalFee,TUseLoc)=""
	quit
}

ClassMethod AffixRunQianPrintAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AffixRunQianPrintAExecute ]
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

ClassMethod AffixRunQianPrintAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AffixRunQianPrintAExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by sjh 2019-11-28 调帐单润乾打印  BUG00018
///  d ##Class(%ResultSet).RunQuery("web.DHCEQChangeAccount","ChangeAccountPrint","1")
///  EquipNo,EquipName,ChangeDate,OldOriginalFee,NewOriginalFee,UseLoc,Model,Unit,LeaveFactoryNo,Expenditures,Location,ChangeFee,NetFee,OriginalFee,ChangedOriginalFee,ChangedNetFee,ChangeReason,ChangeItem,Remark
Query ChangeAccountPrint(RowID As %String) As %Query(ROWSPEC = "TRowID:%String,TEquipNo:%String,EquipName:%String,ChangeDate:%String,OldOriginalFee:%String,NewOriginalFee:%String,UseLoc:%String,Model:%String,Unit:%String,LeaveFactoryNo:%String,Expenditures:%String,Location:%String,ChangeFee:%String,NetFee:%String,OriginalFee:%String,ChangedOriginalFee:%String,ChangedNetFee:%String,ChangeReason:%String,ChangeItem:%String,Remark:%String,Hold2:%String,Hold3:%String") [ SqlProc ]
{
}

ClassMethod ChangeAccountPrintExecute(ByRef qHandle As %Binary, RowID As %String) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	d ResetVariablesChangeAccountPrint
	s EquipDR=$p($g(^DHCEQChangeAccount(RowID)),"^",1)
	i EquipDR'=""  d
	.s EquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	.s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	.s UseLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",19)
	.i UseLocDR'="" s UseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)
	.Set Model=$Piece($Get(^DHCEQEquip(EquipDR)),"^",3)
	.If Model'="" Set Model=##class(web.DHCEQCommon).GetTrakNameByID("model",Model)
	.Set Unit=$Piece($Get(^DHCEQEquip(EquipDR)),"^",5)
	.If Unit'="" Set Unit=##class(web.DHCEQCommon).GetTrakNameByID("uom",Unit)
	.Set LeaveFactoryNo=$Piece($Get(^DHCEQEquip(EquipDR)),"^",10)
	.Set Expenditures=$Piece($Get(^DHCEQEquip(EquipDR)),"^",95)
	.i Expenditures'="" s Expenditures=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",Expenditures)),"^",2)
	.Set Location=$Piece($Get(^DHCEQEquip(EquipDR)),"^",72)
	.i Location'="" s Location=##Class(web.DHCEQCommon).GetTrakNameByID("location", Location)
	s ChangeDate=$p($g(^DHCEQChangeAccount(RowID)),"^",9)
	s ChangeDate=##class(web.DHCEQCommon).TransValueToPage(ChangeDate,"date")
	s ChangeReason=$p($g(^DHCEQChangeAccount(RowID)),"^",8)
	s ChangeItem=$p($g(^DHCEQChangeAccount(RowID)),"^",6)
	s ChangeFee=$p($g(^DHCEQChangeAccount(RowID)),"^",2)
	s OriginalFee=$p($g(^DHCEQChangeAccount(RowID)),"^",24)
	s NetFee=$p($g(^DHCEQChangeAccount(RowID)),"^",25)
	s Hold2=$p($g(^DHCEQChangeAccount(RowID)),"^",33) //add by myl 新增调整累计折旧
	s Hold3=$p($g(^DHCEQChangeAccount(RowID)),"^",34)   //add by myl 新增调整折旧月数
	s ChangedOriginalFee=$p($g(^DHCEQChangeAccount(RowID)),"^",3) //modified by csj 2020-02-17
	s ChangedNetFee=$p($g(^DHCEQChangeAccount(RowID)),"^",4)
	s Remark=$p($g(^DHCEQChangeAccount(RowID)),"^",10)
	
	d OutputRowChangeAccountPrint
	quit $$$OK
OutputRowChangeAccountPrint
	Set Data=$lb(TRowID,EquipNo,EquipName,ChangeDate,OldOriginalFee,NewOriginalFee,UseLoc,Model,Unit,LeaveFactoryNo,Expenditures,Location,ChangeFee,NetFee,OriginalFee,ChangedOriginalFee,ChangedNetFee,ChangeReason,ChangeItem,Remark,Hold2,Hold3)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesChangeAccountPrint
	Set (TRowID,EquipNo,EquipName,ChangeDate,OldOriginalFee,NewOriginalFee,UseLoc,Model,Unit,LeaveFactoryNo,Expenditures,Location,ChangeFee,NetFee,OriginalFee,ChangedOriginalFee,ChangedNetFee,ChangeReason,ChangeItem,Remark,Hold2,Hold3)=""
	quit
}

ClassMethod ChangeAccountPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ChangeAccountPrintExecute ]
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

ClassMethod ChangeAccountPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ChangeAccountPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by sjh SJH0030 2020-07-15 设备调账查询
/// add by mwz MWZ0043 2020-12-15 增加调整累计折旧 TChangeDepreTotalFee
/// d ##class(%ResultSet).RunQuery("web.DHCEQChangeAccount","GetChangeAccountFind","","燃气灶","","")
Query GetChangeAccountFind(No As %String, Equip As %String, StartDate As %String, EndDate As %String, QXType As %String) As %Query(ROWSPEC = "TRowID:%String,TChangeFee:%String,TChangedOriginalFee:%String,TChangedNetFee:%String,TTotalDepreFee:%String,TChangeItem:%String,TChangeReason:%String,TChangeDate:%String,TRemark:%String,TStatus:%String,TAuditDate:%String,TEquip:%String,TNo:%String,TEquipType:%String,TStatCat:%String,TEquiCat:%String,TRow:%String,TChangeDepreTotalFee:%String")
{
}

ClassMethod GetChangeAccountFindExecute(ByRef qHandle As %Binary, No As %String, Equip As %String, StartDate As %String, EndDate As %String, QXType As %String) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	Set TRow=0
	Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date") 
	i StartDate="" s StartDate=0
	Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date") 
	i EndDate="" s EndDate=+$H
	d BuildDataGetChangeAccountFind
	Quit $$$OK
BuildDataGetChangeAccountFind
	f  s rowid=$o(^DHCEQChangeAccount(rowid))  quit:rowid=""  d
	.d ResetVariablesGetChangeAccountFind
	.s TRowID = rowid
	.s EquipDR = $p($g(^DHCEQChangeAccount(rowid)),"^",1)
	.q:EquipDR=""  
	.s TEquip = $p($g(^DHCEQEquip(EquipDR)),"^",1)
	..;i TEquip'="" S TEquip=$p($g(^DHCEQCCode("DHCEQCMasterItem",TEquip)),"^",1)
	.q:(TEquip'=Equip)&&(Equip'="")&&(TEquip'[Equip)
	.s TNo= $p($g(^DHCEQEquip(EquipDR)),"^",71)
	.q:(TNo'=No)&&(No'="")&&(TNo'[No)
	.s EquiCatDR = $p($g(^DHCEQEquip(EquipDR)),"^",4)
	.i EquiCatDR '=""  d
	..s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",EquiCatDR)),"^",2)
	.s EquipTypeDR=$p($g(^DHCEQEquip(EquipDR)),"^",63) 
	.i EquipTypeDR '="" d
	..s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	.s StatCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",75)
	.i StatCatDR'="" d
	..s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2)
	.s TChangeFee = $p($g(^DHCEQChangeAccount(rowid)),"^",2) //调整金额
	.s TChangedOriginalFee = $p($g(^DHCEQChangeAccount(rowid)),"^",3) //调后原值
	.s TChangedNetFee = $p($g(^DHCEQChangeAccount(rowid)),"^",4) //调后净值
	.s TTotalDepreFee = $p($g(^DHCEQChangeAccount(rowid)),"^",5) //调整累计折旧
	.s TChangeItem = $p($g(^DHCEQChangeAccount(rowid)),"^",6) //变动项目
	.s TChangeReason = $p($g(^DHCEQChangeAccount(rowid)),"^",8) //变动原因
	.s TChangeDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeAccount(rowid)),"^",9),"date") //变动日期
	.s TRemark = $p($g(^DHCEQChangeAccount(rowid)),"^",10) //备注
	.s TStatus = $p($g(^DHCEQChangeAccount(rowid)),"^",11)  
	.s TStatus = ##class(web.DHCEQCommon).GetEditStatusDisplay(TStatus) //状态
	.q:TStatus'="审核"
	.s TAuditDate=$p($g(^DHCEQChangeAccount(rowid)),"^",22)
	.q:(TAuditDate>EndDate)||(TAuditDate<StartDate)
	.s TAuditDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeAccount(rowid)),"^",22),"date") //审核日期
	.Set TChangeDepreTotalFee=$Piece($Get(^DHCEQChangeAccount(rowid)),"^",33)	///Mozy0148
	.Set TChangedNetFee=##Class(web.DHCEQCommon).FormatNumber(TChangedNetFee,"",2)	//Modify DJ 2015-09-14 DJ0164 begin
	.Set TTotalDepreFee=##Class(web.DHCEQCommon).FormatNumber(TTotalDepreFee,"",2)
	.Set TChangedOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TChangedOriginalFee,"",2)
	.Set TChangeFee=##Class(web.DHCEQCommon).FormatNumber(TChangeFee,"",2)
	.Set TChangeDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TChangeDepreTotalFee,"",2)	//Modify DJ 2015-09-14 DJ0164 end
	.d OutputRowGetChangeAccountFind
	quit
OutputRowGetChangeAccountFind
	Set TRow=TRow+1
	Set Data=$lb(TRowID,TChangeFee,TChangedOriginalFee,TChangedNetFee,TTotalDepreFee,TChangeItem,TChangeReason,TChangeDate,TRemark,TStatus,TAuditDate,TEquip,TNo,TEquipType,TStatCat,TEquiCat,TRow,TChangeDepreTotalFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetChangeAccountFind
	Set (TRowID,TChangeFee,TChangedOriginalFee,TChangedNetFee,TTotalDepreFee,TChangeItem,TChangeReason,TChangeDate,TRemark,TStatus,TAuditDate,TEquip,TNo,TEquipType,TStatCat,TEquiCat,TChangeDepreTotalFee)=""
	quit
}

ClassMethod GetChangeAccountFindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChangeAccountFindExecute ]
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

ClassMethod GetChangeAccountFindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChangeAccountFindExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
