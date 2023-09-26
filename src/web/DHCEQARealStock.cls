Class web.DHCEQARealStock Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SaveStock(Date)
{

	i Date="" q 0

	d ##Class(web.DHCEQARealStock).GetRealStock(Date)
	
	
	q ##Class(web.DHCEQARealStock).SaveRealStock(Date)
}

/// Add By DJ 2013-06-21
/// 描述:获取配件实时库存数据
/// d ##Class(web.DHCEQARealStock).GetRealStock()
ClassMethod GetRealStock(Date)
{
	k ^DHCEQTemp("GetRealStock")
	s StockDate=""
    s AInStockListDR=0
    f  s AInStockListDR=$o(^DHCEQAChangeStock(0,"SourceType",0,AInStockListDR))  q:AInStockListDR=""  d
    .s AInRowID=0
    .f  s AInRowID=$o(^DHCEQAChangeStock(0,"SourceType",0,AInStockListDR,AInRowID))  q:AInRowID=""  d
    ..s (LocDR,ItemDR,Price)=""
 	..q:$p($g(^DHCEQAChangeStock(AInRowID)),"^",8)=""
 	..q:$p($g(^DHCEQAChangeStock(AInRowID)),"^",14)'=Date
    ..s LocDR=$p($g(^DHCEQAChangeStock(AInRowID)),"^",2)
    ..s ItemDR=$p($g(^DHCEQAChangeStock(AInRowID)),"^",3)
    ..s Price=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAInStockList(AInStockListDR)),"^",8),"")
	..s ^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price)=""
    ..s ^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price,"Stock")=$g(^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price,"Stock"))+$p($g(^DHCEQAInStockList(AInStockListDR)),"^",9)
    
    s AMoveStockListDR=0
    f  s AMoveStockListDR=$o(^DHCEQAChangeStock(0,"SourceType",1,AMoveStockListDR))  q:AMoveStockListDR=""  d
    .s AMoveRowID=0
    .f  s AMoveRowID=$o(^DHCEQAChangeStock(0,"SourceType",1,AMoveStockListDR,AMoveRowID))  q:AMoveRowID=""  d
    ..s (LocDR,ItemDR,Price,MoveDR)=""
 	..q:$p($g(^DHCEQAChangeStock(AMoveRowID)),"^",8)=""
 	..q:$p($g(^DHCEQAChangeStock(AMoveRowID)),"^",14)'=Date
    ..s ItemDR=$p($g(^DHCEQAChangeStock(AMoveRowID)),"^",3)
    ..s Price=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAMoveStockList(AMoveStockListDR)),"^",10),"")
	..s MoveDR=$p($g(^DHCEQAMoveStockList(AMoveStockListDR)),"^",1)
	..i $p($g(^DHCEQAMoveStock(MoveDR)),"^",14)=0 d
	...s LocDR=$p($g(^DHCEQAMoveStock(MoveDR)),"^",4)
	...s ^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price)=""
    ...s ^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price,"Stock")=$g(^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price,"Stock"))-$p($g(^DHCEQAMoveStockList(AMoveStockListDR)),"^",11)
    ..e  d
    ...s LocDR=$p($g(^DHCEQAMoveStock(MoveDR)),"^",5)
    ...s ^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price)=""
    ...s ^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price,"Stock")=$g(^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price,"Stock"))+$p($g(^DHCEQAMoveStockList(AMoveStockListDR)),"^",11)
    
    s ARRowID=0
    f  s ARRowID=$o(^DHCEQAReduce(ARRowID))  q:ARRowID=""  d
    .q:$p($g(^DHCEQAReduce(ARRowID)),"^",23)'=2
    .q:$p($g(^DHCEQAReduce(ARRowID)),"^",16)'=Date
    .s ARLRowID=0
    .f  s ARLRowID=$o(^DHCEQAReduceList(0,"Reduce",ARRowID,ARLRowID))  q:ARLRowID=""  d
    ..s (LocDR,ItemDR,Price,MoveDR)=""
 	..q:$p($g(^DHCEQAReduceList(ARLRowID)),"^",9)=""
    ..s LocDR=$p($g(^DHCEQAReduce(ARRowID)),"^",4)
    ..s ItemDR=$p($g(^DHCEQAReduceList(ARLRowID)),"^",2)
    ..s Price=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAReduceList(ARLRowID)),"^",9),"")
	..s ^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price)=""
    ..s ^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price,"Stock")=$g(^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price,"Stock"))-$p($g(^DHCEQAReduceList(ARLRowID)),"^",10)
	
	s StockDate=Date-1
	i $d(^DHCEQARealStock(0,"AduitDate",StockDate)) d
    .s ASRowID=0
    .f  s ASRowID=$o(^DHCEQARealStock(0,"AduitDate",StockDate,ASRowID)) q:(ASRowID="")  d 
    ..s (LocDR,ItemDR,Price,StockEnd)=""
    ..s LocDR=$p($g(^DHCEQARealStock(ASRowID)),"^",1)
    ..s ItemDR=$p($g(^DHCEQARealStock(ASRowID)),"^",2)
    ..s Price=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQARealStock(ASRowID)),"^",3),"")
    ..s StockEnd=$p($g(^DHCEQARealStock(ASRowID)),"^",5)
	..s ^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price)=""
    ..s ^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price,"Stock")=$g(^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price,"Stock"))+StockEnd
    ..s ^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price,"StockBegin")=$g(^DHCEQTemp("GetRealStock",LocDR,ItemDR,Price,"StockBegin"))+StockEnd
}

ClassMethod SaveRealStock(Date)
{
    Set $ZT="ERRORSave"
    k PLIST
    s PLIST(7) = Date

    TSTART  
    s SQLCODE=0
	
	s Loc=0
	f  s Loc=$o(^DHCEQTemp("GetRealStock",Loc)) q:((Loc="")||(SQLCODE'=0))  d
	.s Item=0
	.f  s Item=$o(^DHCEQTemp("GetRealStock",Loc,Item)) q:((Item="")||(SQLCODE'=0))  d
	..s Price=0
	..f  s Price=$o(^DHCEQTemp("GetRealStock",Loc,Item,Price)) q:((Price="")||(SQLCODE'=0))  d
	...s (StockBegin,StockEnd)=0
	...s StockEnd=$g(^DHCEQTemp("GetRealStock",Loc,Item,Price,"Stock"))
	...q:StockEnd<0
	...s StockBegin=$g(^DHCEQTemp("GetRealStock",Loc,Item,Price,"StockBegin"))
	...s PLIST(2)=Loc
	...s PLIST(3)=Item
	...s PLIST(4)=Price
	...s PLIST(5)=StockBegin
	...s PLIST(6)=StockEnd
	...&SQL(Insert Into SQLUSER.DHC_EQARealStock Values :PLIST())
	...q:SQLCODE'=0 
	
	i SQLCODE'=0
	{	TRollBack}
	else
	{	TCommit}
	q SQLCODE
ERRORSave 
    TRollBack   
    Set ErrorMsg=$ZE         //得到系统返回的错误消息
    Quit "<ERRORSave>"_ErrorMsg     //返回错误消息 ;
}

}
