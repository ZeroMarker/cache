Class web.DHCLabResult Extends %RegisteredObject
{

//Query GetResultsByOrder(OrderId As %String) As %Query(ROWSPEC = "EpisNo:%String,CheckTime:%String,PatName:%String,Mark:%String,TestName:%String,TestType:%String,TestCode:%String,TestName:%String,Value:%String,Unit:%String,Ranges:%String,Remark:%String,CollDate:%String,CollTime:%String,Specimen:%String,TCSyn:%String,SpecDate:%String")

/// 输入格式医嘱号
/// Creator：     李军
/// CreatDate：   2014-05-28
/// Description:：通过医嘱号返回检验结果信息
/// Table：       
/// Input：       输入格式:医嘱ID
/// Output：      
/// Return：      0     
/// Others：  d ##Class(%ResultSet).RunQuery("web.DHCLabResult","GetResultsByOrder","413||3")
Query GetResultsByOrder(OrderId As %String) As %Query(ROWSPEC = "EpisNo:%String,CheckTime:%String,PatName:%String,Mark:%String,TestName:%String,TestType:%String,TestCode:%String,TestName:%String,Value:%String,Unit:%String,Ranges:%String,Remark:%String,Specimen:%String,SpecDate:%String")
{
}

ClassMethod GetResultsByOrderExecute(ByRef qHandle As %Binary, OrderId As %String) As %Status
{
	s OrderId=$g(OrderId)
	//S ^TMPRESORD=OrderId
	Set repid=$i(^CacheTemp)	
 	Set ind=1
 	//报告ID= 样品号||医嘱||医嘱序号100932||A001||1
 	s ReportID=$p(^OEORD($p(OrderId,"||",1),"I",$p(OrderId,"||",2),3),"^",35)
    i '$l(ReportID){
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
    s Sample=$p(ReportID,"||",1) //100932 样品号
    s LabNo=$p(^OEORD($p(OrderId,"||",1),"I",$p(OrderId,"||",2),3),"^",20)
    i LabNo'=Sample Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;b //
    S PatientName=$p(^TEPI(Sample),"\",1) //患者名称
    s DebtorNo=$p(^TEPI(Sample),"\",18)      //病人标识=登记号
    s TSName=""
    s OrdId="" f  s OrdId=$o(^OEORD(0,"EpisNo",LabNo,OrdId)) q:OrdId=""  d
    .s OrdSub="" f  s OrdSub=$o(^OEORD(0,"EpisNo",LabNo,OrdId,OrdSub)) q:OrdSub=""  d
    ..s OrdStatus=$p(^OEORD(OrdId,"I",OrdSub,1),"^",13)
    ..i OrdStatus'="6" q
    ..s ArcimId=$p(^OEORD(OrdId,"I",OrdSub,1),"^",2)
    ..s ArcName=$P($G(^ARCIM($P(ArcimId,"||",1),$P(ArcimId,"||",2),1)),"^",2)
    ..s TSName=TSName_ArcName_"+"
    s TSName=$p(TSName,"+",1,$l(TSName,"+")-1)
    ;b //
    k ^TMP($zn,$j)
    s TestSetDR="" f  s TestSetDR=$o(^TEPI(Sample,1,TestSetDR)) q:TestSetDR=""  d
    .s TSCnt="" f  s TSCnt=$o(^TEPI(Sample,1,TestSetDR,TSCnt)) q:TSCnt=""   d
    ..s Status=$Piece(^TEPI(Sample,1,TestSetDR,TSCnt),"\",31)
    ..i Status'="A" q
    ..//S TSName=TSName_$P(^TTAB("TS",TestSetDR),"\",1)_"+" //医嘱组合
    ..//b
    ..s TestItem="" f  s TestItem=$o(^TEPI(Sample,1,TestSetDR,TSCnt,"DATA",TestItem)) q:TestItem=""  d
    ...//
    ...s TestName=$p(^TTAB("TC",TestItem),"\",1)  //项目名称 
    ...s Synonym=$p(^TTAB("TC",TestItem),"\",12) //英文缩写
    ...s Value=$p(^TEPI(Sample,1,TestSetDR,TSCnt,"DATA",TestItem),"\",1) //测定值
    ...;s Unit=$p(^TEPI(Sample,1,TestSetDR,TSCnt,"DATA",TestItem,"DHC"),"\",1) //测定单位
    ...s Unit="" ;;$p(^TEPI(Sample,1,TestSetDR,1,"DATA",TestItem,"DHC"),"\",1) //测定单位
    ...//i $d(^TEPI(Sample,1,TestSetDR,TSCnt,"DATA",TestItem,"Unit"))=0 q
    ...s Unit=$g(^TEPI(Sample,1,TestSetDR,TSCnt,"DATA",TestItem,"Unit"))
    ...s Ranges=$p(^TEPI(Sample,1,TestSetDR,TSCnt,"DATA",TestItem,"Ranges"),"\",1) //测定范围
    ...s Remark=" "                   //备注
    ...s CheckDate=$p(^TEPI(Sample,1,TestSetDR,1),"\",4)
    ...s:$l(CheckDate) CheckDate=$zd(CheckDate,3)
    ...s CheckTime=$p(^TEPI(Sample,1,TestSetDR,1),"\",5)
    ...s:$l(CheckTime) CheckTime=$zt(CheckTime*60,2) 
    ...s Specimen=""
    ...s SpecDR=$p(^TEPI(Sample,1,TestSetDR,TSCnt),"\",46) ;标本类型
    ...i SpecDR'="" s Specimen=$p($g(^TTAB("SPEC",SpecDR)),"\",1)
    ...s ^TMP($zn,$j,"TC",TestItem)=$lb(Sample,CheckDate_" "_CheckTime,PatientName,DebtorNo,TSName,Specimen,TestName,Synonym,Value,Unit,Ranges,Remark)
    //
    s TC="" f  s TC=$o(^TMP($zn,$j,"TC",TC)) q:TC=""  d
    .s Data=$g(^TMP($zn,$j,"TC",TC))
    .//w !,TSName
    .s $li(Data,5)=TSName
	.Do OutPut
	k ^TMP($zn,$j)
	///
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
	//
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetResultsByOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResultsByOrderExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetResultsByOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResultsByOrderExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
