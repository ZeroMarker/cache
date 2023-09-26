Class web.DHCBL.Register.PrintInfo Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod DevoiceStr(str, flag) As %String
{
	
	set M=170
	if (flag=1){set str="   "_str}	
	set strlen=$Length(str)
	//w str,!
	if (strlen>17)
	{	
	    set tempstr=str
	    set n=0
	    set L=0	
	    for i=1:1:strlen
	    {		
		   if ($Ascii($E(str,i))<300){set L=L+5}
		   else{set L=(+L)+(+10)}		
		   if ((L=M)||((L+5)=M))
		   {				
			  set tempstr=$E(tempstr,1,i+n)_$C(2)_$E(tempstr,i+n+1,strlen)
		      set L=0
		      set n=n+1
		    }
	     }	    
		 set str=tempstr
		 //w str,!
		 //if ($G(^yjm("str",strlen))'=""){set ^yjm("str",strlen_"a")=str}
		 //else {set ^yjm("str",strlen)=str}
	}		
	Quit str
}

ClassMethod DevoiceStr1(str, flag) As %String
{
	kill ^tempGbl
	set M=17
	if (flag=1){set str="    "_str}	
	set strlen=$Length(str)
	if (strlen>M)
	{	set LC=strlen\M
		if (LC*M<strlen){set LC=LC+1}
		set i=0	
		if (flag=0)	{
			set ^tempGbl($j,i)=$E(str,i*M+1,i*M+M+2)
			for i=1:1:LC-1 { set ^tempGbl($j,i)=$E(str,i*M+3,i*M+M+2)}}
		else{ for i=0:1:LC-1 { set ^tempGbl($j,i)=$E(str,i*M+1,i*M+M)}}		
		set tempstr=""
		for i=0:1:LC-1
		{	if (tempstr="")	{   set tempstr=$G(^tempGbl($j,i))}
			else {set tempstr=tempstr_$C(2)_$G(^tempGbl($j,i))}
		}
		set str=tempstr
	}
	//elseif (flag=1) {set str="   "_str}		
	Quit str
}

ClassMethod GetGuidInfoByInv(JSFunName As %String, PrtXMLName As %String = "", InvRowID As %String, UseID As %String, PayMode As %String, ExpStr As %String) As %String
{
	if (PrtXMLName="") Quit ""
	if ((InvRowID="")||(InvRowID=0)) Quit ""
	set Sign="?"
	set SNmb="?^?^?^?^?^?^?^?^?^?"	   ///serial number
	set PayInfo=""  //记录支付方式及支付金额
	set tempPayInfo=""
	set PrintStr=""  //记录医嘱项的信息
	set tempListStr=""
	set prtTxtInfo=""
	set prtListInfo=""	
	set selectedInvID=""
	set YBBanlence=0
	set YBBanlName=""
	set TotalAmount=0	
	//set InvRowID=$Piece(InvRowID,$C(1),1)	
	set len=$Length(InvRowID,"^")
	set f=0		
	for l=1:1:len
	{
		set selectedInvID=$Piece(InvRowID,"^",l)
		if ((selectedInvID'="")&&(selectedInvID'=0)&&($G(^DHCINVPRT(selectedInvID))'=""))
		{
		    set OldInv=$p(^DHCINVPRT(selectedInvID),"^",29)
		    set InitInv=$p(^DHCINVPRT(selectedInvID),"^",13)
		    if ((OldInv'="")||(InitInv'="")) {set f=1}
		}
	}	
	if (f=1){Quit ""}					
	for j=1:1:len
	{		
		set selectedInvID=$Piece(InvRowID,"^",j)
		if ((selectedInvID'="")&&(selectedInvID'=0)&&($G(^DHCINVPRT(selectedInvID))'=""))
		{
			set prtTxtInfo=$$GetTxtInfo(selectedInvID)
			//w prtTxtInfo,!
			set YBBanlence=$$GetYBBanlence(selectedInvID)
			//set ^yjm("YBBanlence")=YBBanlence			
		    do GetPayInfo(selectedInvID)		    	
		    do GetListInfo(selectedInvID)
		    //w prtListInfo,!		    		    
		}				
	}
	///设置支付金额的格式
	set len=$Length(PayInfo,$C(2))	
	for i=1:1:len {
		 set tempf=$Piece(PayInfo,$C(2),1,i-1)
		 set tempb=$Piece(PayInfo,$C(2),i+1,len)
		 set tempm=$Piece(PayInfo,$C(2),i)		 
		 if (($Piece(tempm,":",1)="医保个人帐户")&&((+YBBanlence)>0)) 
		 {
			 set YBBanlence=(+YBBanlence)-$Piece(tempm,":",2)
			 //set ^yjm("YBBanlenceye")=YBBanlence
		     set YBBanlName="医保余额?"
		 }
		 set tempAmt=$Piece(tempm,":",2)
		 set TotalAmount=(+TotalAmount)+(+tempAmt)
		 if (+tempAmt=0)	{set tempm=""}
		 else {	 set tempm=$Piece(tempm,":",1)_"支付"_":"_$Justify((+tempAmt),3,2)_"元"	}		 
		 if ((tempf="")&&(tempb'="")){set PayInfo=tempm_$C(2)_tempb}
		 if ((tempf'="")&&(tempb="")){set PayInfo=tempf_$C(2)_tempm}
		 if ((tempf'="")&&(tempb'="")){set PayInfo=tempf_$C(2)_tempm_$C(2)_tempb}
		 if ((tempf="")&&(tempb="")){set PayInfo=tempm}		 	 
	}
	if (YBBanlName'=""){set PayInfo=PayInfo_$C(2)_YBBanlName_$Justify((+YBBanlence),3,2)_"元"}
	set PayInfo=PayInfo_$C(2)_"合计?"_$Justify((+TotalAmount),3,2)_"元"		
	///设置打印时间
 set d=$p($H,",",1),t=$p($H,",",2)
 set date=$ZD(d,3)
 set time=$p($ZT(t,1),":",1,2)
 set dt=date_" "_time
 ////设置List内容(存放在Globe里的数据)
 set i=0
 set DepDr=0   
 set DepDr=$O(^GuidData($j,"ARC",DepDr))
 while (DepDr'="")
 {	    
	    set i=i+1	    
	    set TimeDr=$O(^GuidData($j,"ARC",DepDr,0)) 
	    set PrtStr=$G(^GuidData($j,"ARC",DepDr,TimeDr))
	    if (PrtStr'="")
	    {
		    set PrtStr=i_Sign_PrtStr
		    set PrtStr=..DevoiceStr(PrtStr,0)
		    //w "PrtStr=",PrtStr,!
		    if (tempListStr=""){set tempListStr=PrtStr}
		    else { set tempListStr=tempListStr_$C(2)_PrtStr }
		    
		    set ItmDR=0
		    set ItmDR=$O(^GuidData($j,"ARC",DepDr,TimeDr,ItmDR))
		    while(ItmDR'="")
		    {   set ItmStr=$G(^GuidData($j,"ARC",DepDr,TimeDr,ItmDR))
		        //w "ItmStr=",ItmStr,!
		        if (ItmStr'="")
		        {   set ItmStr=..DevoiceStr(ItmStr,1)
			        set tempListStr=tempListStr_$C(2)_ItmStr 
		        }		        
		        set ItmDR=$O(^GuidData($j,"ARC",DepDr,TimeDr,ItmDR))
		    }
	    }
	    set DepDr=$O(^GuidData($j,"ARC",DepDr))
	}
	set DepDr=0
	set DepDr=$O(^GuidData($j,"MDC",DepDr))
 while (DepDr'="")
 {
	    set i=i+1	    
	    set TimeDr=$O(^GuidData($j,"MDC",DepDr,0)) 
	    set PrtStr=$G(^GuidData($j,"MDC",DepDr,TimeDr))
	    if (PrtStr'="")
	    {
		    set PrtStr=i_Sign_PrtStr
		    set PrtStr=..DevoiceStr(PrtStr,0)
		    //w "PrtStr=",PrtStr,!
		    if (tempListStr=""){set tempListStr=PrtStr}
		    else { set tempListStr=tempListStr_$C(2)_PrtStr }
		}
	    set DepDr=$O(^GuidData($j,"MDC",DepDr))
	}
	//w "tempListStr=",tempListStr,!	
	set prtListInfo=tempListStr_$C(2)_"--------------------------------"
	set prtListInfo=prtListInfo_$C(2)_PayInfo_$C(2)_"打印时间?"_dt_$C(2)_"收费导诊单作为接受医疗服务的重要"_$C(2)_"依据?请妥善保管!"
	set ^PatInfo($j,"prtTxtInfo")=prtTxtInfo
	set ^PatInfo($j,"prtListInfo")=prtListInfo
	do ..SaveGuidInfo()	  //保存导诊单信息
			
	set rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>	
	kill ^GuidData($j)
	kill ^PatInfo($j)
	kill ^tempARCOSRowId($j)	
	Quit "0"
GetYBBanlence(InvID)    
 set insuDR=$O(^DHCINDIV("0","DHCInvPrt",InvID,0))    
 if (insuDR'="")
 {   set AdmInfoDR=$P(^DHCINDIV(insuDR),"^",2)
	    Quit $P(^DHCINADM(AdmInfoDR),"^",31)
 }
 else{ quit 0}
GetTxtInfo(InvID)    
 Set PatDr=$p(^DHCINVPRT(InvID),"^",15)
 set INVDate=$p(^DHCINVPRT(InvID),"^",5)
 set INVTime=$p(^DHCINVPRT(InvID),"^",20)
 set INVNo=$p(^DHCINVPRT(InvID),"^",14)	
	Quit:$g(PatDr)="" ""
 Set PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
	Set PatNo=$p(^PAPER(PatDr,"PAT",1),"^",2)
	set CFDR=$O(^DHCCARDi("CF",0,"PAPMIDR",PatDr,0))
	set CardNo=$P(^DHCCARD("CF",CFDR),"^",2)     
 set DOB=$p(^PAPER(PatDr,"ALL"),"^",6)
 set Age=$Piece($ZD($H,3),"-",1)-$Piece($ZD(DOB,3),"-",1)_"岁"
 set SexDr=$p(^PAPER(PatDr,"ALL"),"^",7)
 set Sex=$P(^CT("SEX",SexDr),"^",2)
 set BarCodeNo=PatNo   
 set txtInfo="PatInfo"_$c(2)_PatName_"     "_Sex_"      "_Age_"      "_PatNo_"^"_"PatNo"_$c(2)_"*"_PatNo_"*"  

 set ^PatInfo($j,"PatName")=PatName
 set ^PatInfo($j,"CardNo")=CardNo
 set ^PatInfo($j,"PatNo")=PatNo
 if ($G(^PatInfo($j,"INVNo"))'=""){ set ^PatInfo($j,"INVNo")=^PatInfo($j,"INVNo")_"^"_INVNo}
 else {set ^PatInfo($j,"INVNo")=INVNo}
 if ($G(^PatInfo($j,"INVRowDR"))'=""){ set ^PatInfo($j,"INVRowDR")=^PatInfo($j,"INVRowDR")_"^"_InvID}
 else {set ^PatInfo($j,"INVRowDR")=InvID}
 set ^PatInfo($j,"INVDate")=INVDate    
 //set ^PatInfo($j,"UserId")=$G(%session("LOGON.USERID"))    
 Quit txtInfo	
GetPayInfo(sltInvID)
	set IPMSub=0	
	set IPMSub=$O(^DHCINVPRT(sltInvID,"P",IPMSub))	
	while (IPMSub'="")
	{
		set PMDR=$P(^DHCINVPRT(sltInvID,"P",IPMSub),"^",1)
		set PMDesc=$P(^CT("CTPM",PMDR),"^",2)
		set IPMAmt=$P(^DHCINVPRT(sltInvID,"P",IPMSub),"^",3)
		//修改
		if (IPMAmt=0){set IPMSub=$O(^DHCINVPRT(sltInvID,"P",IPMSub))}
		else
		{	
		    if (PayInfo=""){set PayInfo=PMDesc_":"_IPMAmt}
		    else
		    {   
		       set len=$Length(PayInfo,$C(2))
		       set flag=0		    
		       for i=1:1:len
		       {
			       ///需要合并相同支付方式的金额			    			    
			       set tempPMDesc=$Piece($Piece(PayInfo,$C(2),i),":",1)			   
			       if (PMDesc=tempPMDesc)
			       {
				      set flag=1
				      set tempf=$Piece(PayInfo,$C(2),1,i-1)				   
				      set tempb=$Piece(PayInfo,$C(2),i+1,len) 	   ///发票的收费方式不可能大于10项
				      set tempAmt=$Piece($Piece(PayInfo,$C(2),i),":",2)
				      set tempAmt=(+tempAmt)+(+IPMAmt)
				      set tempm=tempPMDesc_":"_tempAmt
				      if ((tempf="")&&(tempb'="")){set PayInfo=tempm_$C(2)_tempb}
				      if ((tempf'="")&&(tempb="")){set PayInfo=tempf_$C(2)_tempm}
				      if ((tempf'="")&&(tempb'="")){set PayInfo=tempf_$C(2)_tempm_$C(2)_tempb}
				      if ((tempf="")&&(tempb="")){set PayInfo=tempm}			   
			       }			    		    
		       }
		       if (flag=0){set PayInfo=PayInfo_$C(2)_PMDesc_":"_IPMAmt}
		    }		
		    set IPMSub=$O(^DHCINVPRT(sltInvID,"P",IPMSub))
		}
	}
	
GetListInfo(sltInvID)
 set BCIRowId=0   	
	set BCIRowId=$Order(^DHCBCI(0,"INV", sltInvID,BCIRowId))
	while(BCIRowId'="")
	{
		do GetListInfoByBCI(BCIRowId)
		set BCIRowId=$Order(^DHCBCI(0,"INV", sltInvID,BCIRowId))
	}
GetListInfoByBCI(BCIRowId)
 kill ^tempARCOSRowId($j)
 set PBRowId=$p(^DHCBCI(BCIRowId),"^",2)    
	if (PBRowId'="")
	{				
		set PctTime="",DepAddress="",DepDesc="",ARCIMName="",PHWin=""
		set PBORowID=0
		set PBORowID=$Order(^DHCPB(PBRowId,"O",PBORowID))
		set i=0
		while (PBORowID'="")
		{
			set PctTime="",DepAddress="",DepDesc="",ARCIMName="",PHWin=""
			set i=+i+1		    				
			set OEOIRowId=$Piece(^DHCPB(PBRowId,"O",PBORowID),"^",4)								
			//set ^yjm("OEOIRowId=")=OEOIRowId
			set OEORowId=$Piece(OEOIRowId,"||",1)
			set OEOISubId=$Piece(OEOIRowId,"||",2)
			//科室名称
			set RepDep=$Piece(^OEORD(OEORowId,"I",OEOISubId,3),"^",6)
			set DepDesc=$Piece(^CTLOC(RepDep),"^",2)    			
			//科室地址
			set AddrRowId=$Order(^CTLOC(RepDep,"ADDR",0))			
			if (AddrRowId'=""){ set DepAddress=^CTLOC(RepDep,"ADDR",AddrRowId) }  			
			///处方号?处方号不为空的代表是药物医嘱?  ////获得取药窗口
			
			set PrescNo=$Piece(^OEORD(OEORowId,"I",OEOISubId,1),"^",14) 			
			//set ^yjm("PrescNo="_PBORowID)=PrescNo
			if (PrescNo'="") 
			{
				set PHWin=##class(web.DHCMZYFXTYW02).GetPhwFrPrt(sltInvID, PrescNo)
			    //set ^yjm("PHWin="_PBORowID)=PHWin
			    set PctTime=$P($zd($p($H,",",1),3),"-",2,3)
			    set PctTime=$P(PctTime,"-",1)_"月"_$P(PctTime,"-",2)_"日"
			}  //格式调整
			else
			{
				set PctTime1=##class(web.DHCOEOrdItem).GetEQASInfo(OEOIRowId) //预约时间	
			    if (PctTime1=""){set PctTime=$P($ZD($P($H,",",1),3),"-",2,3)}
			    else {set PctTime=$P($P(PctTime1,"^",1),"-",2,3)}
			    set PctTime=$P(PctTime,"-",1)_"月"_$P(PctTime,"-",2)_"日"_$P(PctTime1,"^",2)			    
			    //该处方的医嘱套   ///医嘱名称
			    set ARCOSRowId=$Piece(^OEORD(OEORowId,"I",OEOISubId,3),"^",10)
			    		    
			    if (ARCOSRowId'="") 
			    {
				    if ($G(^tempARCOSRowId($j,ARCOSRowId))="")
				    {
					    set ^tempARCOSRowId($j,ARCOSRowId)=ARCOSRowId
					    set ARCIMName=$Piece(^ARCOS(ARCOSRowId),"^",2)
					}
			        else {set PctTime=""}
				    
				}
			    else 
			    {				    
			        set ARCIMRowId=$Piece(^OEORD(OEORowId,"I",OEOISubId,1),"^",2)
			        set ARCIMId=$Piece(ARCIMRowId,"||",1)
			        set ARCIMSubId=$Piece(ARCIMRowId,"||",2)
			        set ARCItemCatDR=$Piece(^ARCIM(ARCIMId,ARCIMSubId,1),"^",10)
			        set ARCICName=$p(^ARC("IC",ARCItemCatDR),"^",2)
			        if (ARCICName["材料"){set PctTime=""}
			        else
			        {
			            set ARCIMName=$Piece(^ARCIM(ARCIMId,ARCIMSubId,1),"^",2)
			            set ARCIMOEM=$G(^ARCIM(ARCIMId,ARCIMSubId,"OEM",1))
			            //w ARCIMOEM,!
			            if (ARCIMOEM'=""){set ARCIMName=ARCIMName_"("_ARCIMOEM_")"}	
			        }	
			   }
			}
			if (PctTime'="")
			{ 
			   if ($G(^GuidData($j,"ARC",DepDesc,PctTime))'="")
			   {
				   set c2=0
				   set c1=$O(^GuidData($j,"ARC",DepDesc,PctTime,0))
				   while (c1)
				   {
					   set c2=c1
					   set c1=$O(^GuidData($j,"ARC",DepDesc,PctTime,c1))
				   }
				   set c2=c2+1			
				   set ^GuidData($j,"ARC",DepDesc,PctTime,c2)=$p(SNmb,"^",c2)_Sign_ARCIMName				   				
			   }
			   elseif(PHWin'="")
			   { set ^GuidData($j,"MDC",DepDesc,PctTime)="请在20分钟后到 "_DepAddress_DepDesc_PHWin_"取药"      } 
			   else {set ^GuidData($j,"ARC",DepDesc,PctTime)="请在"_PctTime_"到"_DepAddress_DepDesc_":"
				     set ^GuidData($j,"ARC",DepDesc,PctTime,1)=$p(SNmb,"^",1)_Sign_ARCIMName }
			}			
			set PBORowID=$Order(^DHCPB(PBRowId,"O",PBORowID))
		}		
	}
}

ClassMethod GetLisInfo(LisStr As %String) As %String
{
	k ^yjm
	//set LisStr="12:07:26 0559167700|0559167700^3^1172444^杜福林^男^9^心血管17.心血管17^00^生化^赁可.赁可^3030-红管^200802270079^22^|血清:3ml静脉血|生化5,|周一至六?7:00?16:00|门诊采血大厅|2?4 小时后出报告|门诊报告室,护士站报告处||打印:08-03-07 12:07:26|;= "
	set ^yjm($J,"InvRowID")=LisStr
	if (LisStr="") Quit
	//^TMPOPCTSeviceInfo临时Globle存储LIS条码信息
	if ($G(^TMPOPCTSeviceInfo(LisStr))'="")
	{set LisStr=$G(^TMPOPCTSeviceInfo(LisStr)) }
	set ^yjm($J,"LisStr")=LisStr 
	set LisStr=$Piece(LisStr,"<BarCode>",2)
	set ^yjm($J,"LisStr1")=LisStr 
	set LisStr=$Piece(LisStr,"</BarCode>",1)
	set ^yjm($J,"LisStr2")=LisStr 
	quit LisStr
	/* 
	Quit:$g(LisStr)="" ""		
	//set len=$Length(LisStr,"^")
	set prtTxtInfo=""
	set prtListInfo=""
	
	//12:07:26 0559167700|0559167700^3^1172444^杜福林^男^9^心血管17.心血管17^00^生化^赁可.赁可^3030-红管^200802270079^22^|血清:3ml静脉血|生化5,|周一至六?7:00?16:00|门诊采血大厅|2?4 小时后出报告|门诊报告室,护士站报告处||打印:08-03-07 12:07:26|;= 
 //打印时间  条码号      ^病人类别^住院号^xm^xb^nl^病区.科室名称^?^实验室^医生^合并标记^流水号^金额^|要求|项目|采样时间|地点|报告时间|地点|
 set PrtTime="",BarCode="",PatType="",InPatNo="",PatName="",PatSex="",PatAge="",AreaLoc="",Unknown="",Lab="",DocName="",ComFlag="",SerialNo="",Amt=""

 set len=$Length(LisStr,"|")                
 set tempStr1=$Piece(LisStr,"|",2)                                                                           
 set tempStr2=$Piece(LisStr,"|",3,len)  //88046668 
 ////取各字段值
 set BarCode=$Piece(tempStr1,"^",1)   ///0559167700
 set PatType=$Piece(tempStr1,"^",2)              //3
 set InPatNo=$Piece(tempStr1,"^",3)   //1172444
 set PatName=$Piece(tempStr1,"^",4)   ///杜福林
 set PatSex=$Piece(tempStr1,"^",5)    ///男
 set PatAge=$Piece(tempStr1,"^",6)    ///9
 set AreaLoc=$Piece(tempStr1,"^",7)   //心血管17.心血管17
 set Unknown=$Piece(tempStr1,"^",8)   //00
 set Lab=$Piece(tempStr1,"^",9)       ///生化
 set DocName=$Piece(tempStr1,"^",10)  //赁可.赁可
 set ComFlag=$Piece(tempStr1,"^",11)  ///3030-红管
 set ComFlag=$Piece(ComFlag,"-",2)
 Set SerialNo=$Piece(tempStr1,"^",12) ///200802270079
 set Amt=$Piece(tempStr1,"^",13)      //22
	/////
	//|血清:3ml静脉血|生化5,|周一至六?7:00?16:00|门诊采血大厅|2?4 小时后出报告|门诊报告室,护士站报告处||打印:08-03-07 12:07:26|;= 
	set Request="",Item="",SampTime="",SampAddr="",GetReptTime="",GetReptAddr="",BarCodeType=""
	set Request=$Piece(tempStr2,"|",1)     ///血清:3ml静脉血
	set Item=$Piece(tempStr2,"|",2)        //生化5,
	set Item=$Piece(Item,",",1) 
	set SampTime="采样时间?"_$Piece(tempStr2,"|",3)    ///周一至六?7:00?16:00
	set SampAddr="采样地点?"_$Piece(tempStr2,"|",4)    ///门诊采血大厅
	set GetReptTime="取单时间?"_$Piece(tempStr2,"|",5) ///2?4 小时后出报告
	set GetReptAddr="取单地点?"_$Piece(tempStr2,"|",6) ///门诊报告室,护士站报告处
	set BarCodeType=$Piece(tempStr2,"|",7) //门诊挂号
	set PrtTime=$Piece(tempStr2,"|",8)     ////打印:08-03-07 12:07:26
	
	set PatInfo=BarCode_" "_PatName_" "_PatSex_" "_PatAge_" "
	
	
	set prtTxtInfo="BarCode"_$c(2)_BarCode
	set prtTxtInfo=prtTxtInfo_"^"_"Lab"_$c(2)_Lab
	set prtTxtInfo=prtTxtInfo_"^"_"ComFlag"_$c(2)_ComFlag
	set prtTxtInfo=prtTxtInfo_"^"_"Type"_$c(2)_"门诊"
	set prtTxtInfo=prtTxtInfo_"^"_"PatInfo"_$c(2)_PatInfo
	if (PayMode=1)
	{	    
	    set prtTxtInfo=prtTxtInfo_"^"_"Item"_$c(2)_Item
	    set prtTxtInfo=prtTxtInfo_"^"_"SampTime"_$c(2)_SampTime
	    set prtTxtInfo=prtTxtInfo_"^"_"SampAddr"_$c(2)_SampAddr
	    set prtTxtInfo=prtTxtInfo_"^"_"GetReptTime"_$c(2)_GetReptTime
	    set prtTxtInfo=prtTxtInfo_"^"_"GetReptAddr"_$c(2)_GetReptAddr
	    set prtTxtInfo=prtTxtInfo_"^"_"SerialNo"_$c(2)_SerialNo_"  门诊"
	    set prtTxtInfo=prtTxtInfo_"^"_"PrtTime"_$c(2)_PrtTime
	}
	else
	{
		set prtTxtInfo=prtTxtInfo_"^"_"Request"_$c(2)_Request
		set prtTxtInfo=prtTxtInfo_"^"_"Item"_$c(2)_Item
		set prtTxtInfo=prtTxtInfo_"^"_"SerialNo"_$c(2)_SerialNo_"  门诊"
	    set prtTxtInfo=prtTxtInfo_"^"_"PrtTime"_$c(2)_PrtTime
	}
	
	//w prtTxtInfo,!
	set rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnval)#>
	Quit "0"
	*/
}

/// 发票打印
ClassMethod GetOPPrtData(JSFunName As %String, PrtXMLName As %String = "", InvRowID As %String, UseID As %String, PayMode As %String, ExpStr As %String) As %String
{
	//set InvRowID=$Piece(InvRowID,$C(1),1)	
	Quit:$g(InvRowID)="" ""			
	set len=$Length(InvRowID,"^")	
	for j=1:1:len
	{
		set PatDr=""
		set SelectPrtDr=$Piece(InvRowID,"^",j)
		if ((SelectPrtDr'="")&&(SelectPrtDr'=0)&&($G(^DHCINVPRT(SelectPrtDr))'=""))
		{  Set PatDr=$p(^DHCINVPRT(SelectPrtDr),"^",15)
		   Set CardRowID=$O(^DHCCARDi("CF",0,"PAPMIDR",PatDr,0))
		}		
	    set prtListInfo=""	
	    set prtTxtInfo=""
	    if ((PatDr'="")&&(CardRowID'=""))
	    {
		   Set CardNo=$E($P(^DHCCARD("CF",CardRowID),"^",2),4,15)		   		   
	       Set PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
	       Set PatNo=$p(^PAPER(PatDr,"PAT",1),"^",2)
	       set PatNo=CardNo  //打印卡号?不打登记号
	       Set Date=$p(^DHCINVPRT(SelectPrtDr),"^",5)
	       set myInvNo=$p(^DHCINVPRT(SelectPrtDr),"^",14)
	       set myUserDR=$p(^DHCINVPRT(SelectPrtDr),"^",21)
	       set myUserName=""
	       if (myUserDR'="") {s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)}
	       /////读取该发票的支付类型
	       set CurPay=""
	       set CurPayName=""
	       set AccountPay=""
	       set AccountPayName=""
	       set IPMSub=0
	       set IPMSub=$O(^DHCINVPRT(SelectPrtDr,"P",IPMSub))	
	       while (IPMSub'="")
	       {
		        set PMDR=$P(^DHCINVPRT(SelectPrtDr,"P",IPMSub),"^",1)
		        set PMCode=$P(^CT("CTPM",PMDR),"^",1)
		        if (PMCode="CASH") {set CurPay=$P(^DHCINVPRT(SelectPrtDr,"P",IPMSub),"^",3) }
		        else { set AccountPayTemp=$P(^DHCINVPRT(SelectPrtDr,"P",IPMSub),"^",3)
			           //set ^yjm("AccountPayTemp"_IPMSub)= AccountPayTemp
			           if ((+AccountPayTemp)>0)
			           {
				           set AccountPayName=$P(^CT("CTPM",PMDR),"^",2)
				           //set ^yjm("AccountPayName"_IPMSub)= AccountPayName 
			               set AccountPay=AccountPayTemp
			           }  
		             }		
		        set IPMSub=$O(^DHCINVPRT(SelectPrtDr,"P",IPMSub))
	       }
	       
	       set ISCoucher=$p(^DHCINVPRT(SelectPrtDr),"^",18)
	       if ((+ISCoucher)'=0){set AccountPayName="记帐"
		       set AccountPay=ISCoucher}
	       if ((+ISCoucher)<0) 
	       {
		       set Costs=$p(^DHCINVPRT(SelectPrtDr),"^",16)
		       set AccountPayName="记帐"
		       set AccountPay=ISCoucher
		   } 
	       else {set Costs=$p(^DHCINVPRT(SelectPrtDr),"^",1)} ;PRT_PatientShare	       			
	       set round=$p(^DHCINVPRT(SelectPrtDr),"^",37)
	       set Costs=Costs+round
	       set CostsUpper=##class(web.UDHCOPINVPrtIF).RMBConvert(Costs)
		   set prtTxtInfo="InvNo"_$c(2)_myInvNo
	       set prtTxtInfo=prtTxtInfo_"^"_"PatNo"_$c(2)_PatNo
	       set prtTxtInfo=prtTxtInfo_"^"_"PatName"_$c(2)_PatName
	       set prtTxtInfo=prtTxtInfo_"^"_"Costs"_$c(2)_$Justify(Costs,3,2)
	       set prtTxtInfo=prtTxtInfo_"^"_"CostsUpper"_$c(2)_CostsUpper
	       set prtTxtInfo=prtTxtInfo_"^"_"AddUser"_$c(2)_myUserName
	       set prtTxtInfo=prtTxtInfo_"^"_"PrtDate"_$c(2)_$P($zd(Date,3),"-",1)_"  "_$P($zd(Date,3),"-",2)_"   "_$P($zd(Date,3),"-",3)	       
	       if ((+CurPay)=0){set prtTxtInfo=prtTxtInfo_"^"_"CurPay"_$c(2)_""}
	       else { set prtTxtInfo=prtTxtInfo_"^"_"CurPay"_$c(2)_$Justify(CurPay,3,2)}
	       set prtTxtInfo=prtTxtInfo_"^"_"AccountPayName"_$c(2)_AccountPayName
	       if ((+AccountPay)=0){set prtTxtInfo=prtTxtInfo_"^"_"AccountPay"_$c(2)_""}
	       else {set prtTxtInfo=prtTxtInfo_"^"_"AccountPay"_$c(2)_$Justify(AccountPay,3,2)}
	       //set ^yjm("prtTxtInfo")= prtTxtInfo
	       ///"InvNo"_"PatNo"_"PatName"_"Costs"_"CostsUpper"_"AddUser"_"PrtDate"_"CurPayName"_"AccountPayName"_"AccountPay"_
	       set prtListInfo=$$GetDetails(SelectPrtDr)
	       //set ^yjm("prtListInfo")= prtListInfo
	       //b
	       set rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	       &javascript<#(rtnval)#>	       
	    }	    
	}		
	Quit "0"  

GetDetails(SelectPrtDr) 	
	set myList=""
	set BCIRowId=0	
	set BCIRowId=$Order(^DHCBCI(0,"INV", SelectPrtDr,BCIRowId))
	while (BCIRowId'="")
	{
		set PBDR=$p(^DHCBCI(BCIRowId),"^",2)
 set PBODR=0
 set PBODR=$Order(^DHCPB(PBDR,"O",PBODR))
 while (PBODR'="")
 {	   
	       set PBDDR=0
	       set PBDDR=$Order(^DHCPB(PBDR,"O",PBODR,"D",PBDDR))
	       while(PBDDR'="")
	       {		    
		       set Amount=$Piece(^DHCPB(PBDR,"O",PBODR,"D",PBDDR),"^",7)  ///金额
		       set TIDR=$Piece(^DHCPB(PBDR,"O",PBODR,"D",PBDDR),"^",3)
		       set TOCDR=$Piece(^DHCTARI(TIDR),"^",15)
		       set TarOCDR=$Piece(^DHCTarC("OC",TOCDR),"^",3)
		       set CatName=$Piece(^DHCTarC("TOC",TarOCDR),"^",2)		    
		       set Item=CatName_":"_$Justify(Amount,3,2)		    
		       if (myList=""){set myList=Item}
		       else
		       {
			       set flag=0
			       set len=$Length(myList,"^")
			       for i=1:1:len
			       {
				       //w "i=",i," ","PBDDR=",PBDDR,"  ","PBODR=",PBODR,!
				       set tempItem=$Piece(myList,"^",i)
				       set tempName=$Piece(tempItem,":",1)
				       set tempAmt=$Piece(tempItem,":",2)
				       if (tempName=CatName)
				       {					    
					       set flag=1
					       set tempAmt=(+tempAmt)+(+Amount)
					       set listF=$Piece(myList,"^",1,i-1)					    
					       set listB=$Piece(myList,"^",i+1,len)					   
					       set listM=CatName_":"_$Justify(tempAmt,3,2)					   
					       if ((listF="")&&(listB'="")){set myList=listM_"^"_listB}
					       if ((listF'="")&&(listB="")){set myList=listF_"^"_listM}
					       if ((listF="")&&(listB="")){set myList=listM}
					       if ((listF'="")&&(listB'="")){set myList=listF_"^"_listM_"^"_listB}					   					    
				       }
			       }
			       if (flag=0){set myList=myList_"^"_Item }
		       }		    
		       set PBDDR=$Order(^DHCPB(PBDR,"O",PBODR,"D",PBDDR))
	       }
	       set PBODR=$Order(^DHCPB(PBDR,"O",PBODR))	    
 }
 set BCIRowId=$Order(^DHCBCI(0,"INV", SelectPrtDr,BCIRowId))
	}	
 set len=$Length(myList,"^")
 if ((len=0)||(len=2)){q myList}
 if (len=1){q myList_"^"}   
 if (len=3){set myList=$Piece(myList,"^",1,2)_$c(2)_$Piece(myList,"^",3)_"^"}
 if (len=4){set myList=$Piece(myList,"^",1,2)_$c(2)_$Piece(myList,"^",3,4)}
 if (len=5){set myList=$Piece(myList,"^",1,2)_$c(2)_$Piece(myList,"^",3,4)_$c(2)_$Piece(myList,"^",5)_"^"}
 if (len=6){set myList=$Piece(myList,"^",1,2)_$c(2)_$Piece(myList,"^",3,4)_$c(2)_$Piece(myList,"^",5,6)}
		
	q myList
}

ClassMethod GetPatInfoByCard(CardNo As %String = "") As %String
{
	set PName=""
	&sql(select PAPMI_Name into :PName from SQLUSER.DHC_CardRef,SQLUSER.PA_PatMas where
 DHC_CardRef.CF_CardNo=:CardNo and CF_PAPMI_DR=PAPMI_RowId1)	
	q PName
}

ClassMethod GetPayMode() As %String
{
	set PMCode="",PMDesc="",PMAmt=0
	set PMRowId=0
	set PMRowId=$Order(^CT("CTPM",PMRowId))
	set ModeInfo=""
	while (PMRowId)
	{
 set PMCode=$Piece(^CT("CTPM",PMRowId),"^",1)
 set PMDesc=$Piece(^CT("CTPM",PMRowId),"^",2)
 set PMAmt=0
 if (ModeInfo=""){set ModeInfo=PMCode_"^"_PMDesc_"^"_PMAmt}
 else {set ModeInfo=ModeInfo_"|"_PMCode_"^"_PMDesc_"^"_PMAmt}
 set PMRowId=$Order(^CT("CTPM",PMRowId))
	}
	Quit ModeInfo
}

ClassMethod GetReprtGuidInfo(PatName As %String = "", PatCardNo As %String = "", INVNos As %String = "", INVDate As %String = "") As %String
{
}

ClassMethod LisPrt() As %String
{
	w "<OBJECT ID='clsRePrint' CLASSID='41AB5558-79F9-40B5-8345-E107226E69FA' CODEBASE='../addins/client/RePrint.CAB#version=1,0,0,0'></OBJECT>"
}

ClassMethod PrintBarCode(JSFunName As %String, PrintDeviceDR As %String, InvRowID As %String, ExpStr As %String) As %String
{
	;前面需要写参数值
	;后面
	s myInPara1="2"
	s myInPara2=""
	s myInPara3="1"
	
	//k ^yjm	
	
	if (InvRowID="") Quit ""	
	if ($p($G(^TMPOPCTSeviceInfo(InvRowID)),$c(1),1)'="")
	{
		set LisStr=$G(^TMPOPCTSeviceInfo(InvRowID))	
	    set LisStr=$Piece(LisStr,"<BarCode>",2)
	    //set ^yjm($J,"LisStr1")=LisStr 
	    set LisStr=$Piece(LisStr,"</BarCode>",1)
	    //set ^yjm($J,"LisStr2")=LisStr 
	    set myInPara2=LisStr	
	
	    s rtnval=JSFunName_"('"_$ZCVT($g(PrintDeviceDR),"O","JS")_"','"_$ZCVT($g(myInPara1),"O","JS")_"','"_$ZCVT($g(myInPara2),"O","JS")_"','"
	    s rtnval=rtnval_$ZCVT($g(myInPara3),"O","JS")_"');"	    
	    &javascript<#(rtnval)#>
	    //set ^yjm($J,"InvRowID")=InvRowID 
	}
}

ClassMethod PutReprtInfo(JSFunName As %String, PrtXMLName As %String = "", GuidID As %String, UseID As %String, PayMode As %String, ExpStr As %String) As %String
{
	if ((GuidID'="")&&($g(^User.DHCREPRTGUIDD(GuidID))'=""))
	{
	   set prtListInfo=$LISTGET(^User.DHCREPRTGUIDD(GuidID),7)
	   set prtTxtInfo=$LISTGET(^User.DHCREPRTGUIDD(GuidID),8) 
	  
	   set rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	   &javascript<#(rtnval)#>
	}
	Quit "0"
}

ClassMethod ReadCard()
{
	w "<object id='HXSpecialCard' classid='CLSID:2F593576-E694-46B5-BF4F-9F23C1020642' width=0 height=0 codebase='../addins/client/MagDLL.cab#version=1,0,0,2'></object>"
}

ClassMethod ReprtGuidInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReprtGuidInfoExecute ]
{
	Set repid=$li(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReprtGuidInfoExecute(ByRef qHandle As %Binary, PatName As %String = "", PatCardNo As %String = "", INVNos As %String = "", INVDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 If $g(ind)=""  Set ind=1     

 set pPatName=PatName,pPatCardNo=PatCardNo,pINVNos=INVNos,tINVDate=INVDate
 set flagName=0,flagCard=0,flagINVNo=0,flagDate=0
 set pPatName=PatName,pPatCardNo=PatCardNo,pINVNos=INVNos,pINVDate=INVDate
 set flagName=0,flagCard=0,flagINVNo=0,flagDate=0
 if (pINVDate'="")
 {   set RPGRowId=0         
	    set RPGRowId=$O(^User.DHCREPRTGUIDI("INVDateIndex"," "_pINVDate,RPGRowId))
	    while (RPGRowId'="")
 {
	        set flagName=0,flagCard=0,flagINVNo=0,flagDate=0
	        set flagDate=1
	        set tINVDate=pINVDate	        	        
	        do GetData(RPGRowId)
	        set RPGRowId=$O(^User.DHCREPRTGUIDI("INVDateIndex"," "_pINVDate,RPGRowId))

 }
 }

 elseif (pPatName'="")
 {
	    set RPGRowId=0
	    set RPGRowId=$O(^User.DHCREPRTGUIDI("PatNameIndex"," "_pPatName,RPGRowId))
	    while(RPGRowId'="")
	    {
		    set flagName=0,flagCard=0,flagINVNo=0,flagDate=0
		    set flagName=1
	        set tPatName=pPatName	        	        
	        do GetData(RPGRowId)		    
		    set RPGRowId=$O(^User.DHCREPRTGUIDI("PatNameIndex"," "_pPatName,RPGRowId))
	    }
 }

 elseif (pPatCardNo'="")
 {
	    set RPGRowId=0
	    set RPGRowId=$O(^User.DHCREPRTGUIDI("PatCardNoIndex"," "_pPatCardNo,RPGRowId))
	    while(RPGRowId'="")
	    {
		    set flagName=0,flagCard=0,flagINVNo=0,flagDate=0
		    set flagCard=1
	        set tPatCardNo=pPatCardNo	        	        
	        do GetData(RPGRowId)		    
		    set RPGRowId=$O(^User.DHCREPRTGUIDI("PatCardNoIndex"," "_pPatCardNo,RPGRowId))
	    }
 }
 elseif (pINVNos'="")
 {
	    set RPGRowId=""
 set RPGRowId=$O(^User.DHCREPRTGUIDI("INVNosIndex",RPGRowId))
 while (RPGRowId'="")
 {
	        set flagName=0,flagCard=0,flagINVNo=0,flagDate=0
	         set tINVNos=$LISTGET(^User.User.DHCREPRTGUIDD(RPGRowId),3)
	         for i=1:1:$Length(tINVNos,"^")
	         {
	             if (pINVNos=$P(tINVNos,"^",i))
	             {
		             set flagINVNo=1
	                 set pINVNos=tINVNos	        	        
	                 do GetData(RPGRowId)
	                 Quit		             
	             }
	         }
	         if (flagINVNo=1) {Quit}
	         set RPGRowId=$O(^User.DHCREPRTGUIDI("INVNosIndex",RPGRowId))
	    }
 }    
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK

GetData(RPGRowId)
 set tINVDate=$TR($LISTGET(^User.DHCREPRTGUIDD(RPGRowId),2)," ")
 set tINVNos=$TR($LISTGET(^User.DHCREPRTGUIDD(RPGRowId),3)," ")    
	set tPatCardNo=$TR($LISTGET(^User.DHCREPRTGUIDD(RPGRowId),4)," ")
	set tPatName=$TR($LISTGET(^User.DHCREPRTGUIDD(RPGRowId),5)," ")
	set tPatNo=$TR($LISTGET(^User.DHCREPRTGUIDD(RPGRowId),6)," ")
	//set tprtListInfo=$LISTGET(^User.DHCREPRTGUIDD(RPGRowId),7)
	//set prtTxtInfo=$LISTGET(^User.DHCREPRTGUIDD(RPGRowId),8) 
	if ((tINVDate=INVDate)||(INVDate="")){set flagDate=1}
	for i=1:1:$Length(tINVNos,"^")
	{
	    if ((INVNos=$P(tINVNos,"^",i))||(INVNos="")) { set flagINVNo=1}
	}
	if ((tPatCardNo=PatCardNo)||(PatCardNo="")){set flagCard=1}
	if ((tPatName=PatName)||(PatName="")){set flagName=1}
	if ((flagDate=1)&&(flagINVNo=1)&&(flagCard=1)&&(flagName=1))
	{
		do AddData(RPGRowId,tPatName,tPatCardNo,tINVNos,tINVDate)
	}

AddData(RPGRowId,PatName,PatCardNo,INVNos,INVDate)
 set INVDate=$zd(INVDate,3)
 Set Data=$ListBuild(RPGRowId,PatName,PatCardNo,INVNos,INVDate)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod ReprtGuidInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReprtGuidInfoExecute ]
{
	Set AtEnd=$li(qHandle,1)
	Set repid=$li(qHandle,2)
	Set ind=$li(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SaveGuidInfo() As %Status
{
		
	set GuidInfo=##class(User.DHCREPRTGUID).%New()	
	set GuidInfo.PatName=^PatInfo($j,"PatName")
	set GuidInfo.PatCardNo=^PatInfo($j,"CardNo")
	set GuidInfo.PatNo=^PatInfo($j,"PatNo")
	if (^PatInfo($j,"INVNo")="") {set GuidInfo.INVNos="wu"}
	else {	set GuidInfo.INVNos=^PatInfo($j,"INVNo")}
	set GuidInfo.INVRowDR=^PatInfo($j,"INVRowDR")
	set GuidInfo.INVDate=^PatInfo($j,"INVDate")	
	//set GuidInfo.UserId=^PatInfo($j,"UserId")
	set GuidInfo.PrtTxtInfo=^PatInfo($j,"prtTxtInfo")
	set GuidInfo.PrtListInfo=^PatInfo($j,"prtListInfo")
	Set sc =GuidInfo.%Save()		 
 If $$$ISERR(sc) {  Do $System.Status.DisplayError(sc) }
}

Query ReprtGuidInfo(PatName As %String = "", PatCardNo As %String = "", INVNos As %String = "", INVDate As %String = "") As %Query(ROWSPEC = "RPGRowID:%String,PatName:%String,PatCardNo:%String,INVNos:%String,INVDate:%String")
{
}

}
