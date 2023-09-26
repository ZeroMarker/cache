Class DHCENS.BaseCode.AddOrderItem Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// Parameter XMLIGNORENULL = 1;
Parameter XMLNAME = "AddOrderItemReturn";

/// 就诊日期	YYYY-MM-DD
Property AdmDate As %String(TRUNCATE = 1);

/// 就诊号   PAADM_RowId
Property AdmNo As %String(TRUNCATE = 1);

/// 就诊时间	HH:MM:SS
Property AdmTime As %String(TRUNCATE = 1);

/// 医嘱字典代码
Property ArcimCode As %String(TRUNCATE = 1);

/// 医嘱字典名称
Property ArcimDesc As %String(TRUNCATE = 1);

/// 床号
Property BedNo As %String(TRUNCATE = 1);

/// 收费状态?P?已收?N?未收
Property BillStatus As %String(TRUNCATE = 1);

/// 诊断?最后一个诊断?
Property Diagnose As %String(TRUNCATE = 1);

/// 费别         Code@Desc
Property FeeType As %String(TRUNCATE = 1);

/// 备注
Property Notes As %String(TRUNCATE = 1);

Property OrdID As %String(TRUNCATE = 1);

/// 开单日期
Property OrderDate As %String(TRUNCATE = 1);

/// 开医嘱科室   Code@Desc
Property OrderDept As %String(TRUNCATE = 1);

/// 开医嘱人     Code@Desc
Property OrderDoctor As %String(TRUNCATE = 1);

/// 数量
Property OrderQty As %String(TRUNCATE = 1);

/// 接受科室     Code@Desc
Property OrderRecDep As %String(TRUNCATE = 1);

/// 医嘱状态 E-执行?V-核实
Property OrderStatus As %String(TRUNCATE = 1);

/// 要求执行医嘱日期   YYYY-MM-DD
Property OrderSttDat As %String(TRUNCATE = 1);

/// 要求执行医嘱时间   HH:MM:SS
Property OrderSttTim As %String(TRUNCATE = 1);

/// 开单时间
Property OrderTime As %String(TRUNCATE = 1);

/// 录入人       Code@Desc
Property OrderUser As %String(TRUNCATE = 1);

/// 患者所在病区	Code@Desc
Property PatientWard As %String(TRUNCATE = 1);

/// 0:成功  1:失败
Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

/// 标本类型
Property SpecimenType As %String(TRUNCATE = 1);

/// 价格
Property TSPrice As %String(TRUNCATE = 1);

/// 急诊标记
Property Priority As %String(TRUNCATE = 1);

ClassMethod AddOrderItem(instr As %String) As %GlobalCharacterStream
{
	
	;s instr="1^400101110001^青霉素钠针(PG)(甲)(80万U/瓶)^E^19^130203^130203^demo^830705^2010-06-14^22:00:00^SGY8"
	s ^input=instr
	s obj=##class(DHCENS.BaseCode.AddOrderItem).%New()
	s obj.AdmNo=$p(instr,"^",1) 			;就诊号	NOT NULL		
	s obj.ArcimCode=$p(instr,"^",2)  	    ;医嘱字典代码	NOT NULL		
    s obj.ArcimDesc=$p(instr,"^",3)   	    ;医嘱字典名称	NOT NULL		
    s obj.OrderStatus=$p(instr,"^",4)       ;医嘱状态	NOT NULL		见医嘱状态表
    s obj.OrderQty=$p(instr,"^",5)      	;数量	NOT NULL		
    s obj.OrderDept=$p(instr,"^",6)		    ;开医嘱科室代码	NOT NULL		
	s obj.OrderRecDep=$p(instr,"^",7)	    ;接受科室代码	NOT NULL		
	s obj.OrderDoctor=$p(instr,"^",8)	    ;开医嘱人	NOT NULL		
	s obj.OrderUser=$p(instr,"^",9)	    	;录入人代码	NOT NULL		
    s obj.OrderSttDat=$p(instr,"^",10)		;要求执行医嘱日期	NOT NULL		
	s obj.OrderSttTim=$p(instr,"^",11)	    ;要求执行医嘱时间	NOT NULL		
	s obj.FeeType=$p(instr,"^",12)	        ;费别	NOT NULL
	s ret=..Insert(obj)
	s objReturn=##class(DHCENS.BaseCode.AddOrderItem).%New()
	
	if (ret'=0)
	{
		s objReturn.OrdID=##class(DHCENS.Method.BaseMethod).ReplaceStr(ret,"||","_")
		s objReturn.ResultCode="0"
		s objReturn.ResultContent="成功"
	}
	else
	{
		s objReturn.OrdID=""
		s objReturn.ResultCode="-1"
		s objReturn.ResultContent="插入失败！！"		
	}
	d objReturn.XMLExportToStream(.Xml)
	s objStream=##class(%GlobalCharacterStream).%New()
    d objStream.Write("<Response>")
    d objStream.CopyFrom(Xml)
    d objStream.Write("</Response>")
	q objStream
}

ClassMethod Insert(obj As DHCENS.BaseCode.AddOrderItem) As %String
{

		s EpisodeID=obj.AdmNo
		s ArcimCode=$ZCVT(obj.ArcimCode,"U")
		s ArcimDesc=obj.ArcimDesc
		s OrderStatus=obj.OrderStatus
		s OrderSttDat=$ZDH(obj.OrderSttDat,3)
		s OrderSttTim=$ZTH(obj.OrderSttTim)
		s OrderQty=obj.OrderQty
		s OrderDept=obj.OrderDept
		s OrderRecDep=$ZCVT(obj.OrderRecDep,"U")
		s OrderDoctor=obj.OrderDoctor
		s OrderUser=obj.OrderUser
		s FeeType=obj.FeeType
		s Price=""
		s Arcim=$O(^ARCIM(0,"Code",ArcimCode,0))
		s ArcimVersion=$O(^ARCIM(0,"Code",ArcimCode,Arcim,0))  
		s ArcimId=Arcim_"||"_ArcimVersion
		s OrderRecDepId=""
		s OrderDeptCode=$ZCVT($P(OrderDept,"@",1),"U")
		s OrderDeptDesc=$P(OrderDept,"@",2)
		if OrderDeptCode'="" s OrderDeptId=$O(^CTLOC(0,"Code",OrderDeptCode,0))
		s OrderRecDepId=""
		s OrderRecDepCode=$ZCVT($P(OrderRecDep,"@",1),"U")
		s OrderRecDepDesc=$P(OrderRecDep,"@",2)
		if OrderRecDepCode'="" s OrderRecDepId=$O(^CTLOC(0,"Code",OrderRecDepCode,0))
		s OrderDoctorId=""
		
		s OrderDoctorCode=$ZCVT($P(OrderDoctor,"@",1),"U")
		s OrderDoctorDesc=$P(OrderDoctor,"@",2)
		if OrderDoctorCode'="" s OrderDoctorId=$O(^SSU("SSUSR",0,"SSUSR_Initials",OrderDoctorCode,0))
		s UserRowId=""
		s UserCode=$ZCVT($P(OrderUser,"@",1),"U")
		s UserName=$P(OrderUser,"@",2)
		if UserCode'="" s UserRowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
		
		s AdmReason=""
		s AdmReasonCode=$ZCVT($P(FeeType,"@",1),"U")
		if AdmReasonCode'="" s AdmReason=$O(^PAC("ADMREA",0,"Code",AdmReasonCode,0))
		
		s AdmDep=$P(^PAADM(EpisodeID),"^",4)

		s ret=$$insertitem()
		q OrderItemRowId
	
insertitem()
	s ordstr=ArcimId_"^"_OrderQty_"^"_OrderRecDepId_"^"_Price_"^"_""_"^"_AdmReason_"^"_OrderSttDat_"^"_OrderSttTim
	s ResValue=..InsertOeOrdItem(EpisodeID,ordstr,UserRowId,AdmDep,OrderDoctorId,"")
	;w ResValue
	;s d=$p(ResValue,"^",1)
	;if d'=0{
	;	Q "100"
	;}
	;s OrderItemRowId=$p(ResValue,"^",2)
	s OrderItemRowId=ResValue
	d ##Class(web.DHCOPCashier).CreatePrescNo(EpisodeID,UserRowId,OrderRecDepId)
	Q OrderItemRowId
}

ClassMethod InsertOeOrdItem(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, DocUserId As %String, OSRID As %String) As %String
{
	Quit:$g(OrdItemStr)="" 0
	Quit:$g(Adm)="" 0
	Set oeitm=""
	Set admloc=$p(^PAADM(Adm),"^",4)
	Set ord=$o(^OEORD(0,"Adm",Adm,""))
	If ord="" Do
	.Kill PLIST
	.Set PLIST(2)=Adm
	.&SQL(Insert Into SQLUser.OE_Order values :PLIST()) 
	.If SQLCODE Set ord="" ;w "err" 
	.else  Set ord=%ROWID
	Quit:ord="" 100
	Set Err=$$LOCK("OE_Order",ord,User,$g(Machine))
	;
	;insert into OE_OrdEnt  zhaocz
	;k PLIST
	;s PLIST(0)=ord
	;&SQL(Insert Into OE_OrdEnt values :PLIST()) 
	;If SQLCODE Set entrid="" else  Set entrid=%ROWID
	
	Set OrdItemCount=$L(OrdItemStr,$c(1))
	For i=1:1:OrdItemCount	Do
	.Set OrdItem=$p(OrdItemStr,$c(1),i)
	.Quit:OrdItem=""
	.Set arcim=$p(OrdItem,"^",1)
	.Quit:arcim=""
	.Set recloc=$p(OrdItem,"^",3)
	.Quit:recloc=""
	.Set qty=$p(OrdItem,"^",2)
	.if +qty=0 Set qty=1
	.Set oeprice=$p(OrdItem,"^",4)
	.Set specimen=$p(OrdItem,"^",5)
	.Set ordcat=$p(^ARCIM(+arcim,1,1),"^",10)
	.Set ordtype=$p(^ARC("IC",ordcat),"^",7)	;DRUG|R,LABTRAK|L,PRICE|P,NORMAL|N
	.Set arcimdesc=$p(^ARCIM(+arcim,1,1),"^",2)
	.Set ordstatus=$o(^OEC("OSTAT",0,"Code","V",""))
	.If ordstatus="" Set ordstatus=$o(^OEC("OSTAT",0))
	.Set priority=$o(^OECPR(0,"Code","NORM",""))
	.If priority="" Set priority=$o(^OECPR(0))
	.Set doctor=""
	.If $g(DocUserId)'="" Set doctor=$p(^SSU("SSUSR",DocUserId),"^",14)
	.if doctor="" Set doctor=$p(^SSU("SSUSR",User),"^",14)
	.Set AdmReason=$p(OrdItem,"^",6)
	.Do SetCommonPLIST
	.&SQL(Insert Into SQLUser.OE_Orditem values :PLIST())
	.Quit:SQLCODE
	.Set oeitm=%ROWID
	.Set $p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),11),"^",18)=AdmReason
	//Do presno^aOET1(Adm)
	Set err=$$LOCKCLR("OE_Order",ord)
	Q oeitm
	
LOCK(BASETAB,ROWID,User,Comp)     ;
	 q:$g(ROWID)="" -1
	 ;s ind=$o(^zleon($zn,""),-1)+1,^zleon($zn,ind,"l")=BASETAB_"^"_ROWID_"^"_User_"^"_Comp_"^"_$j
	 s User=$g(User),Comp=$g(Comp)
	 n user,name,doc,ext,s
	 L +^DBLock(BASETAB,ROWID):0 E  d  Q name_"^"_ext_"^"_comp
	 .s ss=$g(^DBLock(BASETAB,ROWID)),user=$p(ss,"^"),comp=$p(ss,"^",2),s=$g(^SSU("SSUSR",+user)),name=$p(s,"^",2),doc=$p(s,"^",14),ext=$p($g(^CTPCP(+doc,2)),"^",2)
	 s ^DBLock(BASETAB,ROWID)=User_"^"_Comp
	 Q -1
	 ; CLEAR LOCK
	 ; Parameters
	 ; BASETAB       Base Table
	 ; ROWID         Row ID
	 ; Note Return value for VB true is -1
LOCKCLR(BASETAB,ROWID)     ;
	 q:$g(ROWID)="" -1
	 ;s ind=$o(^zleon($zn,""),-1)+1,^zleon($zn,ind,"c")=BASETAB_"^"_ROWID_"^"_$j
	 L -^DBLock(BASETAB,ROWID)
	 k ^DBLock(BASETAB,ROWID)
	 Q -1
SetCommonPLIST
	KILL PLIST
	set PLIST(0)=ord
	;set PLIST(3)=entrid				;OEORI_OrdEnt_DR
	Set PLIST(4)=arcim
	Set PLIST(6)=admloc		 	 ;OEORI_OrdDept_DR
	Set PLIST(10)=ordstatus		 ;OEORI_ItemStat_DR
	Set PLIST(14)=doctor		 ;OEORI_Doctor_DR
	Set PLIST(17)=+$H			 ;SttDate
	Set PLIST(18)=$p($H,",",2)	 ;SttTime
	Set PLIST(23)=priority		 ;OEC_Priority
	Set PLIST(29)=qty			 ;PhyQtyOrd			
	;Set Price=$$GetOrderPrice^DHCPRICE("","",arcim,+$H,"","","",oeprice)
	;Set PLIST(46)=$p(Price,"^",1) 
	Set PLIST(55)="Y"			 ;CoverMainIns
	Set PLIST(56)="N"			 ;Portable Equviment
	Set PLIST(57)="N"			 ;SkinTest
	Set PLIST(75)=recloc
	set PLIST(76)="TB"
	Set SeqNo=$o(^OEORDi(0,"StDtSeqNo",ord,+$H,""),-1)
	Set SeqNo=+SeqNo+1
	Set PLIST(77)=SeqNo
	Set PLIST(120)=$g(User)	 	 ;UserAdd
	Set PLIST(121)=$g(Loc) 	 	 ;User Dept
	Set PLIST(141)=$g(User)	     ;User Update
	Set PLIST(161)=admloc		 ;OEORI_AdmLoc_Dr
	Quit
}

}
