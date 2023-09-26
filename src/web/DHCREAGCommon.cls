/// 试剂公共程序
Class web.DHCREAGCommon Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 157;

/// Creator：      huhm
/// CreatDate：    20100830
/// Description:： 试剂消耗
/// Table：       
/// Input：     科室,试剂,模块,批号,数量,处理单号,用户,来源科室,操作类型,生成日期,有效期,位置,单价   
///             Module:I入库,O出库,T领用,D报损,C退货,B盘点(未用)
/// Output：       
/// Return：       0:无,1:有
/// Others：
/// , ProdDate As %String, ExpDate As %String, PosiDr As %String, Price As %String
ClassMethod SaveTransaction(DepId As %String, ReagId As %String, Module As %String, LotNo As %String, Quan As %Float, TransNo As %String, User As %String, FromDepId As %String, OpType As %String) As %String
{
	New (DepId,ReagId,LotNo,Quan,Module,TransNo,User,FromDepId,OpType,ProdDate,ExpDate,PosiDr,Price)
	//Set ProdDate=$Get(ProdDate),ExpDate=$Get(ExpDate),PosiDr=$Get(PosiDr),Price=$Get(Price)
	Set DepId=$Get(DepId),ReagId=$Get(ReagId),LotNo=$Get(LotNo),Module=$Get(Module)
	//Set LotNo=$p(LotNoId,"||",1),LotCount=$p(LotNoId,"||",2)
	Set TransNo=$Get(TransNo),User=$get(User),FromDepId=$g(FromDepId),OpType=$Get(OpType)
	s ^TMP($zn,"para",ReagId)=DepId_","_ReagId_","_Module_","_TransNo_","_FromDepId_","_OpType //_","_ProdDate_","_ExpDate_","_PosiDr_","_Price
	Set RetValue="0"
	///计算试剂库存并保存
	If Module="I" Set RetStr=..CalculateStock(DepId,ReagId,LotNo,User,Quan,TransNo,"I1",OpType)
	//If Module="I" Set RetStr=..CalculateStock(DepId,ReagId,LotNo,User,Quan,TransNo,"I1",OpType,ProdDate,ExpDate,PosiDr,Price)
	//If Module="B" Set RetStr=..CalculateStock(DepId,ReagId,LotNo,User,Quan,TransNo,"I3",OpType,ProdDate,ExpDate,PosiDr,Price)
	If Module="O" Set RetStr=..CalculateStock(DepId,ReagId,LotNo,User,Quan,TransNo,"O1",OpType)
	If Module="T" {
		///
		If (OpType="3"){
			//库存转移
			Set RetStr=..CalculateStock(DepId,ReagId,LotNo,User,Quan,TransNo,"I2",OpType) 
			//Set RetStr=..CalculateStock(DepId,ReagId,LotNo,User,Quan,TransNo,"I2",OpType,ProdDate,ExpDate,PosiDr,Price) 
			If RetStr'=0 Quit RetStr
			If $Length(FromDepId) Set RetStr=..CalculateStock(FromDepId,ReagId,LotNo,User,Quan,TransNo,"O2",OpType)
		}
		else
		{
			//库存不转移
			If $Length(FromDepId) Set RetStr=..CalculateStock(FromDepId,ReagId,LotNo,User,Quan,TransNo,"O5",OpType)
		}
	}
	If Module="D" Set RetStr=..CalculateStock(DepId,ReagId,LotNo,User,Quan,TransNo,"O3",OpType)
	If Module="C" Set RetStr=..CalculateStock(DepId,ReagId,LotNo,User,Quan,TransNo,"O4",OpType)
    If RetStr'=0 Quit RetStr
	///保存处理明细
	//&sql(insert into lab.DHCREAGTrace(DepartmentDR,TransDate,ReagentDR,TransTime,Type,TransUserDR,LotNo,Quantity,TransNo)
	//values(:DepId,:chkDate,:ReagId,:chkTime,"I",:User,:LotNo,:Quan,:TransNo))
	//If SQLCODE Set RetValue="处理明细保存失败:"_SQLCODE Quit RetValue	
	Quit RetValue
}

/// Creator：      huhm
/// CreatDate：    20100902
/// Description:： 取消处理
/// Table：       
/// Input：     科室,试剂,模块,批号ID,数量,处理单号,用户,来源科室,操作类型   
///             Module:I,O,T,D,C,B
/// Output：       
/// Return：       0:无,1:有
/// Others：
/// 
ClassMethod SaveReturnTrans(DepId As %String, ReagId As %String, Module As %String, LotNo As %String, Quan As %Float, TransNo As %String, User As %String, FromDepId As %String, OpType As %String) As %String
{
	New (DepId,ReagId,LotNo,Quan,Module,TransNo,User,FromDepId,OpType)
	Set DepId=$Get(DepId),ReagId=$Get(ReagId),LotNo=$Get(LotNo),Module=$Get(Module)
	Set RetValue="0"
	Set TransNo=$Get(TransNo),User=$get(User),FromDepId=$g(FromDepId),OpType=$Get(OpType)
	If Module="O" Set RetStr=..CalculateStock(DepId,ReagId,LotNo,User,Quan,TransNo,"O11",OpType)	
	Quit RetValue
}

/// 计算试剂库存 操作类型I1:入库,I2:转入,I3:盘点,O1:出库,O2:转出,O3:报废,O4:退货,O5:直接出库
/// , ProdDate As %String, ExpDate As %String, PosiDr As %String, Price As %String
ClassMethod CalculateStock(DepId As %String, ReagId As %String, LotNo As %String, User As %String, Quan As %Float, TransNo As %String, Type As %String, OpType As %String) As %String
{
	New (DepId,ReagId,LotNo,User,Quan,TransNo,Type,OpType) //,ProdDate,ExpDate,PosiDr,Price)
	Set DepId=$Get(DepId),ReagId=$Get(ReagId),LotNo=$Get(LotNo),User=$Get(User)
	Set Quan=$Get(Quan),TransNo=$Get(TransNo),Type=$Get(Type),OpType=$Get(OpType)
	//Set ProdDate=$Get(ProdDate),ExpDate=$Get(ExpDate),Price=$g(Price)
	Set RetValue=0
	Set StkQuan=0
	&sql(select ID,Quantity into :StkRowId,:StkQuan  from lab.DHCREAGStock where DepartmentDR=:DepId and ReagentDR=:ReagId)
	If $e(Type,1)="I"{
		Set StkSum=StkQuan+Quan
	}
	If $e(Type,1)="O"{
		Set StkSum=StkQuan-Quan
	}
	///保存试剂库存
	If SQLCODE{
		&sql(insert into lab.DHCREAGStock(DepartmentDR,ReagentDR,Quantity) values(:DepId,:ReagId,:Quan))
	}
	else{
		&sql(update lab.DHCREAGStock Set Quantity=:StkSum where ID=:StkRowId)
	}
	If SQLCODE Set RetValue="库存保存失败:"_SQLCODE Quit RetValue
	///按批号保存明细
	Set LotId=$p(LotNo,"||",1),LotCnt=$p(LotNo,"||",2)
	If '$Length(StkRowId) Set StkRowId=$Order(^lab.DHCREAGStockI("MasterIndex",DepId,ReagId,""))
	Set ItmId=""
	w !,"err1:",ItmId,":",StkRowId
	Set (Sum,QuanS,QuanC,QuanD,QuanO,QuanB)=0
	&sql(select ID,Quantity,CancelQty,DiscardQty,OutQty,BalanceQty,SumQty into :ItmId,:QuanS,:QuanC,:QuanD,:QuanO,:QuanB,:Sum
	from lab.DHCREAGStockItems where ParRef=:StkRowId and LotNo=:LotId and LotCount=:LotCnt )
	//w !,"err:",Sum
	s ^TMPSTOK(DepId,ReagId,1)=ItmId_":"_SQLCODE_","_Type_":"_Sum_","_QuanS_","_QuanD_","_QuanC_","_QuanO_","_QuanB
	//w !,Type
	//I:入库
	If $e(Type,1)="I"{
		Set QuanS=QuanS+Quan
	}
	//出库
	If Type="O1"{
		Set QuanO=QuanO+Quan
	}
	//转出(库存转移)
	If Type="O2"{
		Set QuanO=QuanO+Quan
	}
	//转出(库存不转移)
	If Type="O5"{
		Set QuanO=QuanO+Quan
	}
	//报废
	If Type="O3"{
		Set QuanD=QuanD+Quan
	}
	//退货
	If Type="O4"{
		Set QuanC=QuanC+Quan
	}
	///取消操作
	//取消出库
	If Type="O11"{
		Set QuanO=QuanO+Quan
	}
	Set Sum=QuanS-QuanC-QuanD-QuanO-QuanB
	///保存试剂库存明细
	s ^TMPSTOK(DepId,ReagId,2)=ItmId_":"_SQLCODE_","_Sum_","_QuanS_","_QuanD_","_QuanC_","_QuanO_","_QuanB
	Set (ProdDate,ExpDate,PosiDr,Price)=""
	//得到有效期,生产日期,价格,位置,I1入库,I2库存转移,I3盘点
	If Type="I1"
	{
		Set RecId=$Order(^lab.DHCREAGStockInI("MasterIndex"," "_TransNo,""))
		set RecSubId=""
		If $Length(RecId) Set RecSubId=$Order(^lab.DHCREAGStockInItemsI("LotNoIndex",ReagId," "_$zcvt(LotId,"U"),LotCnt,RecId,""))
		If $Length(RecSubId),$Data(^lab.DHCREAGStockInD(RecId,"Items",RecSubId))
		{
			Set ProdDate=$li(^lab.DHCREAGStockInD(RecId,"Items",RecSubId),6)
			Set ExpDate=$li(^lab.DHCREAGStockInD(RecId,"Items",RecSubId),7)
			Set Price=$li(^lab.DHCREAGStockInD(RecId,"Items",RecSubId),9)
			Set PosiDr=$li(^lab.DHCREAGStockInD(RecId,"Items",RecSubId),11)
		}
	}
	If Type="I2"
	{
		//^lab.DHCREAGTransferI("MasterIndex"," LY2010080017",101)=
		Set TransId=$Order(^lab.DHCREAGTransferI("MasterIndex"," "_TransNo,""))
		Set TransSubId=""
		If $Length(TransId) Set TransSubId=$Order(^lab.DHCREAGTransferItemsI("MasterIndex",TransId,ReagId," "_LotId,LotCnt,""))
		If $Length(TransSubId),$Data(^lab.DHCREAGTransferD(TransId,"Items",TransSubId))
		{
			Set ProdDate=$li(^lab.DHCREAGTransferD(TransId,"Items",TransSubId),6)
			Set ExpDate=$li(^lab.DHCREAGTransferD(TransId,"Items",TransSubId),7)
			Set Price=$li(^lab.DHCREAGTransferD(TransId,"Items",TransSubId),9)
			//Set PosiDr=$li(^lab.DHCREAGTransferD(TransId,"Items",TransSubId),11)
		}
	}
	//s ^TMPREC=SQLCODE_","_StkRowId_","_PosiDr
	if SQLCODE{
		&sql(insert into lab.DHCREAGStockItems(ParRef,LotNo,LotCount,Quantity,CancelQty,DiscardQty,OutQty,SumQty,BalanceQty,ProductDate,ExpireDate,PositionDR,Price) 
		Values(:StkRowId,:LotId,:LotCnt,:QuanS,:QuanC,:QuanD,:QuanO,:Sum,:QuanB,:ProdDate,:ExpDate,:PosiDr,:Price))
	}else{
		//入库更新价格,有效期,位置
		if $e(Type,1)="I"
		{
			&sql(update lab.DHCREAGStockItems Set Quantity=:QuanS,CancelQty=:QuanC,DiscardQty=:QuanD,OutQty=:QuanO,
			SumQty=:Sum,BalanceQty=:QuanB,ExpireDate=:ExpDate,ProductDate=:ProdDate,Price=:Price where ID=:ItmId)
		}
		else
		{
			&sql(update lab.DHCREAGStockItems Set Quantity=:QuanS,CancelQty=:QuanC,DiscardQty=:QuanD,OutQty=:QuanO,
			SumQty=:Sum,BalanceQty=:QuanB where ID=:ItmId)
		}
	}
	//b 14
	If SQLCODE Set RetValue="库存明细保存失败:"_SQLCODE	 Quit RetValue
	//保存处理明细	
	Set RetValue=..SaveTransItem(DepId,ReagId,LotNo,User,Quan,TransNo,Type,OpType)
	Quit RetValue
}

ClassMethod SaveTransItem(DepId As %String, ReagId As %String, LotNo As %String, User As %String, Quan As %String, TransNo As %String, Type As %String, OpType As %String) As %String
{
	New (DepId,ReagId,LotNo,User,Quan,TransNo,Type,OpType)
	Set DepId=$Get(DepId),ReagId=$Get(ReagId),LotNo=$Get(LotNo),User=$Get(User),Quan=$Get(Quan),TransNo=$Get(TransNo),Type=$Get(Type),OpType=$Get(OpType)
	Set chkDate=+$h //$zd(+$h,3)
	Set chkTime=$p($h,",",2) //$zt($p($h,",",2),2
	Set RetValue="0"
	Set DepId=$Get(DepId),ReagId=$Get(ReagId),LotNo=$Get(LotNo),User=$Get(User),Quan=$Get(Quan),TransNo=$Get(TransNo),Type=$Get(Type)
	&sql(insert into lab.DHCREAGTrace(DepartmentDR,TransDate,ReagentDR,TransTime,Type,TransUserDR,LotNo,Quantity,TransNo,OperateTypeDR)
	values(:DepId,:chkDate,:ReagId,:chkTime,:Type,:User,:LotNo,:Quan,:TransNo,:OpType))
	If SQLCODE Set RetValue="处理明细保存失败:"_SQLCODE
	Quit RetValue
}

/// Creator：      huhm
/// CreatDate：    20101220
/// Description:： 处理规格
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others
ClassMethod TransPackageSize(Package As %String) As %String
{
	s Package=$g(Package)
	i '$l($tr(Package," ")) q "1"_$c(2)
	s Package=$tr(Package,"x","*")
	s Package=$tr(Package,"X","*")
	s NumStr=$p(Package," ",1)
	s Unit=$p(Package," ",2)
	s Volumn=1
	f i=1:1:$l(NumStr,"*") d
	.s Volumn=Volumn*(+$p(NumStr,"*",i))
	q Volumn_$c(2)_Unit
}

}
