Class web.UDHCJFFindErr Extends %RegisteredObject
{

ClassMethod geterr(bill)
{
	s ord=0
	f  s ord=$o(^DHCPB(bill,"O",ord)) q:(ord="")  d
	.s ordamt=$p(^DHCPB(bill,"O",ord),"^",8)
	.s arcim=$p(^DHCPB(bill,"O",ord),"^",3)
	.s arcimdesc=$p(^ARCIM(+arcim,1,1),"^",2)
	.s ordamt=ordamt
	.s det="0"
	.s detamt=0
	.f  s det=$o(^DHCPB(bill,"O",ord,"D",det))  q:(det="")  d
	..s detamt=detamt+$p(^DHCPB(bill,"O",ord,"D",det),"^",7)
	.s detamt=detamt
	.i (ordamt'=detamt) d
	..w !,arcimdesc_"^"_ordamt_"^"_detamt
}

ClassMethod finderr(jkdr)
{
	s prtrowid=""
	f  s prtrowid=$o(^DHCINVPRTZY(0,"JK",jkdr,prtrowid)) q:(prtrowid="")  d
	.s acount=$p(^DHCINVPRTZY(prtrowid),"^",6)
	.s billno=$p(^DHCINVPRTZY(prtrowid),"^",5) 
	.s billpatfee=$p(^DHCPB(billno),"^",8)
	.i (acount'=billpatfee) d
	..w !,prtrowid_"^"_acount_"^"_billpatfee
	q
}

ClassMethod getqtyhr(OEExecRowID)
{
	s stdat=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",1)
	s sttim=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",2)

	s dcdat=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",35)
	s dctim=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",36)
	s:+$g(dcdat)=0 dcdat=+$h
	s:+$g(dctim)=0 dctim=$p($h,",",2)
	s period=dcdat-stdat
	s:period'=0 dcnt=period*24
	s hourchk=dctim-sttim/60
	s tcnt=$fn((dctim-sttim)/60/60,"",2)
	s qty=+$g(dcnt)+tcnt
	;i period<0 s qty=0
	;i priorcode'="S" s qty=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",12) old
	;i priorcode'="S" s qty=+$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",5)
	;i (priorcode'="S")&(statcode="D") s qty=0
	q +$g(qty)
}

/// w ##class(web.UDHCJFFindErr).TestP()
ClassMethod TestP()
{
    k ^timelogeeeeee
    
    s ^timelogeeeeeeh(1)=$zts
    
    set n=0
    set bill=1941146
    for i=1:1:20 do
    .set adm=$p(^DHCPB(bill),"^",1)
    .set pboSub="0" 
    .for  set pboSub=$o(^DHCPB(bill,"O",pboSub)) quit:pboSub=""  do
    ..set oeori=$p(^DHCPB(bill,"O",pboSub),"^",4)
    ..set oeore=$p(^DHCPB(bill,"O",pboSub),"^",20)
    ..set arcim=$p(^DHCPB(bill,"O",pboSub),"^",3)
    ..set RCDRowID=""
    ..set regLoc=""
    ..set itmPriceExpStr=RCDRowID_"^"_oeori_"^"_oeore_"^"_adm_"^"_regLoc_"^"_""
    ..;
    ..set ^timelogeeeeee(n,1)=$zts
    ..set str= ##class(web.UDHCJFPRICE).GetOrderPrice("",1,arcim,+$h,"","","","","",itmPriceExpStr)
    ..set ^timelogeeeeee(n,2)=$zts
    ..set n=n+1
    ..w !,n
    
    s ^timelogeeeeeeh(2)=$zts
}

/// w ##class(web.UDHCJFFindErr).TestP3()
ClassMethod TestP3()
{
    k ^timelogeeeeee
    
    s ^timelogeeeeeeh(1)=$zts
    
    set n=0
    set bill=""
    for  set bill=$o(^DHCPB(bill),-1) quit:(bill="")!(n>10000)  do
    .quit:'$d(^DHCPB(bill))
    .quit:$d(^DHCPB(bill))=10
    .set adm=$p(^DHCPB(bill),"^",1)
    .set pboSub="0" 
    .for  set pboSub=$o(^DHCPB(bill,"O",pboSub)) quit:pboSub=""  do
    ..quit:$d(^DHCPB(bill,"O",pboSub))=10
    ..set oeori=$p(^DHCPB(bill,"O",pboSub),"^",4)
    ..set oeore=$p(^DHCPB(bill,"O",pboSub),"^",20)
    ..set arcim=$p(^DHCPB(bill,"O",pboSub),"^",3)
    ..set RCDRowID=""
    ..set regLoc=""
    ..set itmPriceExpStr=RCDRowID_"^"_oeori_"^"_oeore_"^"_adm_"^"_regLoc_"^"_""
    ..;
    ..set ^timelogeeeeee(n,1)=$zts
    ..set str=##class(web.UDHCJFPRICE).GetOrderPrice("",1,arcim,+$h,"","","","","",itmPriceExpStr)
    ..set ^timelogeeeeee(n,2)=$zts
    ..;w !,str
    ..set n=n+1
    ..w !,n
    
    s ^timelogeeeeeeh(2)=$zts
}

/// w ##class(web.UDHCJFFindErr).TestGetAgeFun()
ClassMethod TestGetAgeFun()
{
	s ^timelogdddd(1)=$zts
	set n=0
	set adm=""
	for  set adm=$o(^PAADM(adm),-1) quit:(adm="")||(n>100)  do	
	.set papmi=$p(^PAADM(adm),"^",1)
	.set age=##class(web.DHCBillInterface).GetPapmiAge(papmi,adm)
	.set n=n+1
	.w !,n
	s ^timelogdddd(2)=$zts
}

/// w ##class(web.UDHCJFFindErr).TestGetAgeFun3()
ClassMethod TestGetAgeFun3()
{
	s ^timelogdddd(1)=$zts
	s n=0
	for i=1:1:10000 d
	.set papmi=568
	.set adm=997
	.set age=##class(web.DHCBillInterface).GetPapmiAge(papmi,adm)
	.set n=n+1
	.w !,n
	s ^timelogdddd(2)=$zts
}

/// w ##class(web.UDHCJFFindErr).TestGetAgeFun4()
ClassMethod TestGetAgeFun4()
{
	s ^timelogdddd(1)=$zts
	s n=0
	for i=1:1:100 d
	.set papmi=568
	.set adm=997
	.set dob=$p(^PAPER(papmi,"ALL"),"^",6)
	.set age=##class(web.DHCDTHealthCommon).GetAgeDesc(dob,+$h)
	.set n=n+1
	.w !,n_"--"_age
	s ^timelogdddd(2)=$zts
}

/// d ##class(web.Util.DHCJFClassGlobal).ExportTblNew("BILLINSU","/home/INSU001/1.csv") 
/// d ##class(web.UDHCJFFindErr).ExportTblNew("BILLINSU","/dthealth/app/dthis/web/temp/excel/1.csv")
ClassMethod ExportTblNew(OwnerGroup = "", PathFileName)
{
	Set file = ##class(%FileCharacterStream).%New()
	Set file.Filename=PathFileName
 	Set clsname = "A"
 	Set Data=$lb("所属产品组","是否已删除","类名","表名","字段名","字段中文名","数据类型","KingbaseES数据类型","长度","是否必填","主键","关联表","描述","值域定义")
 	Do file.WriteLine($lts(Data,","))
 	for {
	 	Set clsname=$o(^oddCOM(clsname))
	 	Quit:clsname=""
	 	continue:$e(clsname,1)="%"
	 	
	 	
	 	//If $g(^oddCOM(clsname,45))["~%Library.Persistent~"{
		If ($G(^oddCOM(clsname,23))="persistent"){
			//If sname'="" Set gname = $e($g(^oddDEF(clsname,"s",sname,21)),2,)
			;Set pkgname = $p(clsname,".",1,$l(clsname,".")-1)
			;Set gname = ..getMasterIndexName(pkgname,$p(clsname,".",$l(clsname,".")))
			
			Set gname = ""
			Set ss = "" For  Set ss =$O(^oddDEF(clsname,"s",ss)) Q:ss=""  d
			.Set stoType = $G(^oddDEF(clsname,"s",ss,5)) ; %Library.CacheStorage
			.if (stoType["CacheStorage")||(stoType["%Storage.Persistent")  d 
			. . Set gname=$G(^oddDEF(clsname,"s",ss,24))
			.else  d
			
			. . Set si="" For  Set si=$O(^oddDEF(clsname,"s",ss,"S",si)) Q:si=""  d
			. . .Set type = $G(^oddDEF(clsname,"s",ss,"S",si,5))
			. . .if type="data" Set gname = $G(^oddDEF(clsname,"s",ss,"S",si,24))
			. . 
			
			
			;if clsname="User.DHCCTPayModeExp" b
			Set gname = $e(gname,2,)
			
			set MyOwnerGroup=""
			set IsDelete=""
			If (gname'=""){
				Set GlobalWLRowId = $O(^BSP.SMP.GlobalWhiteListI("GBL",gname,0))
				If (GlobalWLRowId>0){
					Set MyOwnerGroup = $Lg(^BSP.SMP.GlobalWhiteListD(GlobalWLRowId),5)
					Set IsDelete = $Lg(^BSP.SMP.GlobalWhiteListD(GlobalWLRowId),13)
				}
			}
		
			//If ..IsOwnerGlobal(gname,OwnerGroup){
			If 1 {
				// 导出表结构
				set packgName=$g(^oddCOM(clsname,57))
				set tbName=$g(^oddCOM(clsname,58))
				if (packgName'="SQLUser"){
					set tbName=$g(^oddCOM(clsname,53))
				}
				set PriKey=""
				set StorageStrategy=$g(^oddCOM(clsname,59))
				if (StorageStrategy'=""){
					set PriKey=$g(^oddCOM(clsname,"s",StorageStrategy,29))
				}
	
			
				Set Data = $lb(MyOwnerGroup,IsDelete,clsname,tbName,PriKey,"主键","","bigint","","Y","是")
				Do file.WriteLine($lts(Data,","))
				;W clsname,",",gname,!
				//Do file.WriteLine("表名,"_clsname_","_gname)
				Set proname="A" for {
					Set proname = $O(^oddCOM(clsname,"a",proname))
					Quit:proname=""
					Continue:$e(proname,1)="%"	
					Set Cardinality=$g(^oddDEF(clsname,"a",proname,24))	
					//Continue:($zcvt(Cardinality,"L")="children")
					//Continue:($zcvt(Cardinality,"L")="parent")	
					Set Note = $g(^oddDEF(clsname,"a",proname,4))
					Set DataType = $g(^oddDEF(clsname,"a",proname,5))
					
					Set Field = $g(^oddDEF(clsname,"a",proname,47))
					Set MaxLen = $g(^oddDEF(clsname,"a",proname,"P","MAXLEN"))
					Set Caption = $g(^oddDEF(clsname,"a",proname,"P","CAPTION"))
					Set Accuracy=""		;精度
					Set Required=$case($g(^oddDEF(clsname,"a",proname,37)),1:"Y",:"N")		;是否必填
					continue:PriKey=Field
					Set PriKeyFlag=""	
					Set Remarks=""
					Set RalationTB=""
					if (##class(%Dictionary.ClassDefinition).%ExistsId(DataType)&&($G(^oddCOM(DataType,23))="persistent")){
						set RalationTB=$g(^oddCOM(DataType,53))
						Set KingbaseESDataType="bigint"
					}else{
						Set DataType=$replace(DataType,"Library.","")
						Set KingbaseESDataType=$case($tr($zcvt(DataType,"L"),"%",""),"binary":"blob",
							"decimal":"decimal","double":"double","float":"float","numeric":"numeric",
							"string":"varchar","date":"date","time":"time","timestamp":"timestamp",
							"boolean":"boolean","integer":"integer","list":"SET",:"")
					}
					
				
					if Field="" set Field=proname
					Set ValueList = $g(^oddDEF(clsname,"a",proname,"P","VALUELIST")) ;值域
					
					if ($zcvt(Cardinality,"L")="children") set Caption="孩子指针"
					if ($zcvt(Cardinality,"L")="parent") set Caption="父指针"
					//Set Data=$lb("所属产品组","是否已删除","类名","表名","字段名","字段中文名","数据类型","KingbaseES数据类型","长度","是否必填","主键","关联表","描述","值域定义")
					Set Data = $lb(MyOwnerGroup,IsDelete,clsname,tbName,Field,Caption,DataType,KingbaseESDataType,MaxLen,Required,PriKeyFlag,RalationTB,Note,ValueList)
					for index=1:1:$ll(Data) do
					.set Data=$lu(Data,index,..FormatStr($lg(Data,index)))
					Do file.WriteLine($lts(Data,","))
				}
			}			
	 	}
 	}
 	Do file.Flush()
	Do file.%Save()
	Do file.%Close()
	Set file=""
}

ClassMethod FormatStr(Str)
{
	set Str=$replace(Str,",","/") 
	set Str=$replace(Str,$c(10),".")
	set Str=$replace(Str,$c(13),"/") 
	quit Str
}

/// Creator: ZhYW
/// CreatDate: 2022-12-01
/// Description: 删除医嘱账单表记录
/// Input: PBO:DHC_PatBillOrder.RowId
/// Return: 0:成功, <>0:失败
/// Others: 只针对住院账单的删除
/// Debug: w ##class(web.UDHCJFFindErr).DELPBO()
ClassMethod DELPBO(PBO As %String) As %String
{
	set $zt="ERROR"
	
	//校验能否删除
	set BILL=+PBO
	set PayedFlag=$p(^DHCPB(+BILL),"^",16)
	if (PayedFlag="P") {
		set IsCloseAcount=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(BILL)
		quit:(IsCloseAcount="Y") -1_"^"_"账单已封账，不能删除"
		quit -1_"^"_"账单已结算，不能删除"
	}
	
	set insuUpFlag=##class(web.DHCINSUPort).GetInsuUpFlag(BILL, "")
	if (+insuUpFlag>0) {    //医保未上传、未医保结算时重新生成账单
		quit -1_"^"_$case(insuUpFlag,1:"医保已上传",2:"医保已结算",:"")_"，不能删除"
	}
	
	set OEORE=$p($g(^DHCPB(+BILL,"O",$p(PBO,"||",2))),"^",20)   //执行记录
	quit:(OEORE="") -1_"^"_"执行记录为空，不能删除"
	
	set BillFlag=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)    //执行记录的计费状态
	quit:(BillFlag="P") -1_"^"_"执行记录计费状态为已结算，不能删除"
	
	ts
	
	do ##class(web.UDHCJFBILLIP).SetDetPatBillDetails(PBO)
	
	//删除账单医嘱表和账单明细表
	kill PLIST
	set rtn=##class(web.UDHCJFPBO).SELECT(PBO)
	if (+rtn) tro  quit rtn
	set TotalAmount=-PLIST(8)
	set DiscAmount=-PLIST(9)
	set PayorShare=-PLIST(10)
	set PatientShare=-PLIST(11)
	set rtn=##class(web.UDHCJFPBO).PBODEL(PBO)
	if (+rtn) tro  quit rtn
	
	//找平主账单
	kill PLIST
  	set rtn=##class(web.UDHCJFPB).SELECT(BILL)
  	if (+rtn) tro  quit rtn
	set PLIST(9)=PLIST(9)+TotalAmount
	set PLIST(10)=PLIST(10)+DiscAmount
	set PLIST(12)=PLIST(12)+PayorShare
	set PLIST(13)=PLIST(13)+PatientShare
	set rtn=##class(web.UDHCJFPB).UPDATE(BILL)
	if (+rtn) tro  quit rtn
	
	//更新指向记录状态
	&SQL(
		UPDATE OE_OrdExec
		SET OEORE_Billed = 'TB'
		WHERE %ID = :OEORE
	)
    set rtn=SQLCODE
    if (+rtn) tro  quit rtn_"^"_$g(%msg)
    
	set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3),"BILL"),"^",2)=""   //OEORE_PBO_DR
	
    //如果是新版申请单，需要把中间表的账单状态也改为TB
    set IsAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder($p(OEORE,"||",1,2))
    if (IsAppRep="Y") {
   		set rtn=##class(web.UDHCJFBILLIP).UpdateAppRepTarItmBillStatus($p(OEORE,"||",1,2), "B", "TB", OEORE)
   		if (+rtn) tro  quit rtn
    }
	
	//日志记录
	set ^BILL.IP("DELPBO",PBO)=$lb(OEORE, $zdt($zdth($zts,-3),3,1,6))
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	set $zt=""
	if ($tl>0) tro
	lock
	quit -1_"^"_$ze
}

}
