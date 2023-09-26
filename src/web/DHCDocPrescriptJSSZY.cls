/// 适应医院:江苏省中医
/// 建类原因:这边药房不是我们的,标准版的数据是直接获取的配药表的相关配药和审核记录
Class web.DHCDocPrescriptJSSZY Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// /每一页能显示多少行数据
Parameter DefaultOnePageNum = 19;

Parameter DefaultPYOnePageNum = 24;

/// Description:得到打印的基本信息
/// Input:
/// Output:输出对应XML打印的inpara数据串
/// Other:w ##class(web.DHCDocPrescriptJSSZY).GetPrescBaseInfo("I15122200001")
/// /w ##class(web.DHCDocPrescriptJSSZY).GetPrescBaseInfo("O16031600487")
ClassMethod GetPrescBaseInfo(PrescNo As %String) As %String
{
	s inpara=""
	Q:PrescNo="" ""
    s PrescData=..GetPrescInfoByOrd(PrescNo)
    Q:PrescData="" ""
    s patinfo = $p(PrescData, "!!",1)
    
    s PatNo = $p(patinfo,"^",1)
    s PatientName = $p(patinfo,"^",2)
    s PatientSex = $p(patinfo,"^",3)
    s PatientAge = $p(patinfo,"^",4)
    ;诊断,以逗号分隔
    s diag = $p(patinfo,"^",5)
    s ReclocDesc = $p(patinfo,"^",12)
    s AdmDate = $p(patinfo,"^",14) //就诊日期
    s Path = $p(patinfo,"^",6)
    s PyName = $p(patinfo,"^",7)
    s FyName = $p(patinfo,"^",8)
    s PatientCompany = $p(patinfo,"^",13)  //工作单位
    s PatientMedicareNo = $p(patinfo,"^",15) //医保编号
    s PrescNo = $p(patinfo,"^",16)
    s AdmDepDesc = $p(patinfo,"^",24)
    s Doctor = $p(patinfo,"^",25)
    s Paddress = $p(patinfo,"^",20)
    s TelNo = $p(patinfo,"^",19)
    s OrdDate = $p(patinfo,"^",32)
    s PayDate = $p(patinfo,"^",33)
    s PrtDate = $p(patinfo,"^",11)
    s DMFlag = $p(patinfo,"^",23)
    If DMFlag '= "" s DMFlag = "[" _DMFlag_"]"
    s BillType = $p(patinfo,"^",34)
    
    s BillFlag = "["_BillType_"]"
    s BillAuditFlag = $p(patinfo,"^",35)
    s PoliticalLevel = $p(patinfo,"^",37)
    s orddoctdr= $p(patinfo,"^",38)
    s ExpInfo=""
    s PrescType=..IsPrescType(PrescNo)
    if (PrescType="1"){
		s retstr=..Getpaque(PrescNo)
		s ExpInfo=$p(retstr,"^",8)_" "_$p(retstr,"^",9)_" "_$p(retstr,"^",3)_" "_$p(retstr,"^",1)_" "_$p(retstr,"^",7)
	}
    s PrescInfo=""
    if (BillType["市医保"){
		s PrescInfo="处方当天有效"
	}else{
		s PrescInfo="处方三天有效"
	}
    s PrescTitle="",zf="",MRNo="",barcode=""
    
    s inpara = "PrescTitle"_$c(2)_PrescTitle
    ;MyPara = MyPara + '^zf' + chr(2) + zf
    s inpara = inpara_"^"_"zf"_$c(2)_zf
    ;MyPara = MyPara + '^PresType' + chr(2) + '处方笺'
    s inpara = inpara_"^"_"PresType"_$c(2)_"处方笺"
    
    s inpara = inpara_"^"_"PatientMedicareNo"_$c(2)_PatientMedicareNo
    s inpara = inpara_"^"_"PrescNo"_$c(2)_PrescNo
    s inpara = inpara_"^"_"MRNo"_$c(2)_MRNo
    s inpara = inpara_"^"_"PANo"_$c(2)_PatNo
    s inpara = inpara_"^"_"PANoBarCode"_$c(2)_"*"_PatNo_"*"
    
    s inpara = inpara_"^"_"RecLoc"_$c(2)_ReclocDesc
    s inpara = inpara_"^"_"Name"_$c(2)_PatientName
    s inpara = inpara_"^"_"PoliticalLevel"_$c(2)_PoliticalLevel
    s inpara = inpara_"^"_"Sex"_$c(2)_PatientSex
    s inpara = inpara_"^"_"Age"_$c(2)_PatientAge
    s inpara = inpara_"^"_"Address"_$c(2)_Paddress
    s inpara = inpara_"^"_"AdmDep"_$c(2)_AdmDepDesc
    s inpara = inpara_"^"_"Path"_$c(2)_Path
    s inpara = inpara_"^"_"PyName"_$c(2)_PyName
    s inpara = inpara_"^"_"FyName"_$c(2)_FyName
    s inpara = inpara_"^"_"barcode"_$c(2)_barcode
    s inpara = inpara_"^"_"OrdDate"_$c(2)_OrdDate
    s inpara = inpara_"^"_"PayDate"_$c(2)_PayDate
    s inpara = inpara_"^"_"PrtDate"_$c(2)_PrtDate
    s inpara = inpara_"^"_"DMFlag"_$c(2)_DMFlag
    s inpara = inpara_"^"_"BillFlag"_$c(2)_BillFlag
    s inpara = inpara_"^"_"TelNo"_$c(2)_TelNo
    ;MyPara=MyPara + '^PrtRemark' + chr(2) + "说明:药品名称前有"
    s inpara = inpara_"^"_"PrtRemark"_$c(2)_"说明:药品名称前有"
    ;MyPara=MyPara + '^PrtRemark1' + chr(2) + chr(9650) + "表示需皮试药品"
    ;PatientInfo(PrtRemark1) s inpara = inpara_"^"_"PrtRemark1"_$c(2)_Chr(9650) & "表示需皮试药品"
    s inpara = inpara_"^"_"BillAuditFlag"_$c(2)_BillAuditFlag
    s inpara = inpara_"^"_"BillType"_$c(2)_BillType
    s inpara = inpara_"^"_"Company"_$c(2)_PatientCompany
    s inpara = inpara_"^"_"AdmDep"_$c(2)_AdmDepDesc
    s inpara = inpara_"^"_"UserAddName"_$c(2)_Doctor
    s inpara = inpara_"^"_"UserGif"_$c(2)_orddoctdr
    s inpara = inpara_"^"_"Diagnose"_$c(2)_diag
    s inpara = inpara_"^"_"ExpInfo"_$c(2)_ExpInfo
    ;得到总金额
    s medinfo = $p(PrescData, "!!",2)
    s TotleSum=$$GetTotleSum(medinfo)
    s inpara = inpara_"^"_"Sum"_$c(2)_TotleSum
    s inpara = inpara_"^"_"CurrDate"_$c(2)_$ZD(+$H,3)_" "_..%ZT(..%SysTime())
    s inpara = inpara_"^"_"PrescInfo"_$c(2)_PrescInfo
    
    Q inpara
GetTotleSum(medinfo)
	s sum=0
	s mlength = $l(medinfo,"@")
    for h=0:1:mlength {
	    s onemedinfo=$p(medinfo,"@",h)
        s totalprice = $p(onemedinfo,"^",9)
        s sum=sum+totalprice
    }
    
    Q sum
}

/// Description:得到打印的基本信息
/// Input:
/// Output:输出对应XML打印的inlist数据串
/// Other:w ##class(web.DHCDocPrescriptJSSZY).GetPrescListInfo("O16032200794")
ClassMethod GetPrescListInfo(PrescNo As %String, PrintFlag As %String = "Y") As %String
{
	s inlist=""
	Q:PrescNo="" ""
    s PrescData=..GetPrescInfoByOrd(PrescNo)
    Q:PrescData="" ""
    s PrescType=..IsPrescType(PrescNo)
    s medinfo = $p(PrescData, "!!",2)
    if (medinfo=""){q ""}
    
    ///设置打印时间
    if (PrintFlag'="N"){
	    s ^DHCPrescNoPrint(PrescNo)="Y"
	    s ^DHCPrescNoPrint(PrescNo,"Time")=$ZD(+$H,3)_" "_..%ZT(..%SysTime())
    }
    s sum = 0
    s mlength = $l(medinfo,"@")
    s cmRowStr=""
    for h=1:1:mlength {
	    s onemedinfo=$p(medinfo,"@",h)
        s OrderName = $p(onemedinfo,"^",1)
		s PackQtyUom=$p(onemedinfo,"^",3)
		s PackQtyUom=$P(PackQtyUom,"(",1)
        s PackQty = $p(onemedinfo,"^",2)_PackQtyUom
        s DoseQty = $p(onemedinfo,"^",4)
        s Inst = $p(onemedinfo,"^",5)
        s Freq = $p(onemedinfo,"^",6)
        s Lc = $p(onemedinfo,"^",7)
        s totalprice = $p(onemedinfo,"^",9)
        s Ordremark = $p(onemedinfo,"^",11)
        s Testflag = $p(onemedinfo,"^",10)
        s Seqno = $p(onemedinfo,"^",12)
        s GenericName=$p(onemedinfo,"^",14)
        s Format=$p(onemedinfo,"^",15)
        if (Testflag '= "") {
            s Seqno = Seqno_$c(9650)
        }
        if ($l(Ordremark) > 10) {
            s Ordremark = $e(Ordremark,0,10)_"..."
        }
		
		if PrescType=1 {
			s retstr=..Getpaque(PrescNo)
			s OrderName=$P(OrderName,"[",1)
			s factor=$p(retstr,"^",2)
			s Oneqty=$p(onemedinfo,"^",2)/factor
			s OneUom=$p(onemedinfo,"^",3)
			s specinst=$p(onemedinfo,"^",13)
			s specinst=##Class(web.UDHCPrescript).PhSpecInstrDesc(specinst)
			i specinst'="" s specinst="["_specinst_"]"
			if (h#2)=0 {
				s cmRowStr=cmRowStr_OrderName_" "_Oneqty_OneUom_" "_specinst
				i inlist="" {
					s inlist=cmRowStr
				}else{
					s inlist = inlist_$c(2)_cmRowStr
				}
				s cmRowStr=""
			}else{
				s cmRowStr=OrderName_" "_Oneqty_OneUom_" "_specinst_"^"
			}
		}else{
	        s OrderName = Seqno_" "_GenericName_" "_Format
			///项目要求在备注存在用法：的时候使用备注覆盖单次计量
	        s firstdesc = OrderName_" X "_PackQty_" "_Testflag_"^"
	        s inststring = "   	        用法:每次"_DoseQty_"     "_Freq_"     "_Inst_"     "_Ordremark_"^"
	        s firstdesc = firstdesc_$c(2)_inststring
	        if (inlist = "") {
		        s inlist=firstdesc
	        } else {
	            s inlist = inlist_$c(2)_firstdesc
	        }
		}

        s sum=sum+totalprice
    }
    i cmRowStr'="" {
	    i inlist="" {
			s inlist=cmRowStr
		}else{
			s inlist = inlist_$c(2)_cmRowStr
		}
    }
    q:inlist="" ""
    ////按照设置的行数量进行每页的分配
    s DefaultOnePageNum=..#DefaultOnePageNum
    s Length=$Length(inlist,$C(2))
    s TotaPage=(Length\DefaultOnePageNum)+$S((Length#DefaultOnePageNum)>0:1,1:0)
    s NewList=""
    f i=1:1:TotaPage{
		if (NewList=""){
			s NewList=$p(inlist,$c(2),(i-1)*DefaultOnePageNum+1,i*DefaultOnePageNum)
		}else{
			s NewList=NewList_"PageDlim"_$p(inlist,$c(2),(i-1)*DefaultOnePageNum+1,i*DefaultOnePageNum)
		}
	}
	s NewList=TotaPage_"TotaDlim"_NewList
	s NewList=$replace(NewList,$C(9),"")
    Q NewList
}

/// //
/// /w ##class(web.DHCDocPrescriptJSSZY).GetPrescInfoForPY("O16012000243")
ClassMethod GetPrescInfoForPY(PrescNo As %String, PrintFlag As %String = "Y") As %String
{
	s PrescData=..GetPrescInfoByOrd(PrescNo)
	s PrescType=..IsPrescType(PrescNo)
    Q:PrescData="" ""
    ////
    ///设置打印时间
    if (PrintFlag'="N"){
	    s ^DHCPrescNoPrint(PrescNo)="Y"
	    s ^DHCPrescNoPrint(PrescNo,"Time")=$ZD(+$H,3)_" "_..%ZT(..%SysTime())
    }
    
    s inlist=""
    s medinfo = $p(PrescData, "!!",2)
    s sum = 0
    s mlength = $l(medinfo,"@")
    s cmRowStr=""
    for h=1:1:mlength {
	    s onemedinfo=$p(medinfo,"@",h)
        s OrderName = $p(onemedinfo,"^",1)
		
		
        s PackQty = $p(onemedinfo,"^",2)_$p(onemedinfo,"^",3)
        s DoseQty = $p(onemedinfo,"^",4)
        s Inst = $p(onemedinfo,"^",5)
        s Freq = $p(onemedinfo,"^",6)
        s Lc = $p(onemedinfo,"^",7)
        s totalprice = $p(onemedinfo,"^",9)
        s Ordremark = $p(onemedinfo,"^",11)
        s Testflag = $p(onemedinfo,"^",10)
        s Seqno = $p(onemedinfo,"^",12)
        s GrameName = $p(onemedinfo,"^",16)
        s Spec = $p(onemedinfo,"^",15)
        
        if (Testflag '= "") {
            s Seqno = Seqno_$c(9650)
        }
        if ($l(Ordremark) > 10) {
            s Ordremark = $e(Ordremark,0,10)_"..."
        }
		if PrescType=1 {
			 s retstr=..Getpaque(PrescNo)
			 s OrderName=$P(OrderName,"[",1)
		     s factor=$p(retstr,"^",2)
		     s Oneqty=$p(onemedinfo,"^",2)/factor
		     s OneUom=$p(onemedinfo,"^",3)
	         s specinst=$p(onemedinfo,"^",13)
	         s specinst=##Class(web.UDHCPrescript).PhSpecInstrDesc(specinst)
	         i specinst'="" s specinst="["_specinst_"]"
			if (h#2)=0 {
				s cmRowStr=cmRowStr_OrderName_"^"_Oneqty_OneUom_"^"_specinst
				i inlist="" {
					s inlist=cmRowStr
				}else{
					s inlist = inlist_$c(2)_cmRowStr
				}
				s cmRowStr=""
			}else{
				s cmRowStr="^"_OrderName_"^"_Oneqty_OneUom_"^"_specinst_"^"
			}
		}else{
			///项目要求在备注存在用法：的时候使用备注覆盖单次计量
	        s firstdesc = GrameName_"^^^^^^"_$c(2)_"^"_Spec_"^^^"_PackQty_"^^"
	        s inststring = "^"_Inst_"^"_Freq_"^"_DoseQty_"^^^"
	        s firstdesc = firstdesc_$c(2)_inststring
	        if (inlist = "") {
		        s inlist=firstdesc
	        } else {
	            s inlist = inlist_$c(2)_firstdesc
	        }
		}

        s sum=sum+totalprice
    }
    i cmRowStr'="" {
	    i inlist="" {
			s inlist=cmRowStr_"^^"
		}else{
			s inlist = inlist_$c(2)_cmRowStr_"^^"
		}
    }
    q:inlist="" ""
	if ($G(PrescType)=1){
		//带煎(中药)^14^200ml^2015-12-31^2016-01-13^^水煎^14付^每日1剂 每日1次
		s inlist=inlist_$c(2)_$P(retstr,"^",7)_" "_$P(retstr,"^",8)_" "_$P(retstr,"^",9)_"^^^^^^"
		s inlist=inlist_$c(2)_$P(retstr,"^",1)_" "_$P(retstr,"^",3)_"^^^^^^"
	}
	////页尾
	if ($G(PrescType)=1){
		s LastPage="^药师提示:^^^^^"
		s LastPage=LastPage_$c(2)_"^1.为保证药品安全,按卫生部规定,药品一经^^^^^"
		s LastPage=LastPage_$c(2)_"^  发出不得退换。^^^^^"
		s LastPage=LastPage_$c(2)_"^2.本单元仅供复核及用法用量的告知。^^^^^"
	}else{
		s LastPage="^药师提示:^^^^^"
		s LastPage=LastPage_$c(2)_"^1.请在窗口清点药品。^^^^^"
		s LastPage=LastPage_$c(2)_"^2.为保证药品安全,按卫生部规定,药品一经^^^^^"
		s LastPage=LastPage_$c(2)_"^  发出不得退换。^^^^^"
		s LastPage=LastPage_$c(2)_"^3.本单元仅供复核及用法用量的告知。^^^^^"
	}
	if ($G(PrescType)=1){
		////按照设置的行数量进行每页的分配
	    s DefaultOnePageNum=..#DefaultPYOnePageNum
	    s Length=$Length(inlist,$C(2))
	    s TotaPage=(Length\DefaultOnePageNum)+$S((Length#DefaultOnePageNum)>0:1,1:0)
	    s NewList=""
	    b
	    f i=1:1:TotaPage{
			if (NewList=""){
				s NewList=$p(inlist,$c(2),(i-1)*DefaultOnePageNum+1,i*DefaultOnePageNum)_$C(2)_LastPage
			}else{
				s NewList=NewList_"PageDlim"_$p(inlist,$c(2),(i-1)*DefaultOnePageNum+1,i*DefaultOnePageNum)_$C(2)_LastPage
			}
		}
		s NewList=TotaPage_"TotaDlim"_NewList
	}else{
		s NewList="1TotaDlim"_inlist_$C(2)_LastPage
	}
	
	
    Q NewList
}

/// Description:门诊打印统一方法调用,适用于配药,发药,直接发药,查询等界面打印处方,摆药单
/// Input:处方号,科室
/// Output:打印所需内容
/// Other:d ##class(web.DHCDocPrescriptJSSZY).GetPrescInfoByOrd("O16031800013","","")
ClassMethod GetPrescInfoByOrd(PrescNo As %String, phdphl = "", prt = "") As %String
{
	s ^tmpgry("GetPrescInfoByOrd")=PrescNo_","_ phdphl_","_prt
   //是否需要考虑判断接收科室 1 考虑 0不考虑
   s chkreclocflag=0
   s patstring=""  //处方信息(含患者基本信息)
   s medstring=""  //医嘱信息
   s reclocdr="",recloc=""
   Q:PrescNo="" "OK"
   s:phdphl'="" reclocdr=$p(^DHCPHLOC(phdphl),"^",1)
   s ord="" 
   f  s ord=$o(^OEORD(0,"PrescNo",PrescNo,ord)) q:ord=""  d
   .s adm=$p(^OEORD(ord),"^",1)
   .s papmi=+$p(^PAADM(adm),"^",1)
   .s perno=$p(^PAPER(papmi,"PAT",1),"^",2)
   .s pname=$p(^PAPER(papmi,"ALL"),"^",1)
   .s ptel=$p(^PAPER(papmi,"PER",1),"^",11)
   .s homeTel=$p($g(^PAPER(papmi,"PER",1)),"^",11)   //家庭电话
   .s workTel=$p($g(^PAPER(papmi,"PER",1)),"^",9)    //工作电话
   .s handtel=$p($g(^PAPER(papmi,"PER",4)),"^",21)   //手机
   .i handtel'="" s ptel=handtel
   .s paddress=$p($g(^PAPER(papmi,"PER",4)),"^",18)
   .s paddress=$g(^PAPER(papmi,"PER","ADD",1)) // 住址
   .s getage=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",papmi,adm)
   .s sexdr=$p(^PAPER(papmi,"ALL"),"^",7)
   .s sex=$p(^CT("SEX",sexdr),"^",2)
   .s company=$p(^PAPER(papmi,"PER",4),"^",18) //工作单位
   .s cfRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,""),-1)
   .s cardNo=""
   .s:cfRowId'="" cardNo=$p($g(^DHCCARD("CF",cfRowId)),"^",2)
   .s admord=$o(^OEORD(0,"PrescNo",PrescNo,""))
   .s adm=$p(^OEORD(admord),"^",1)
   .s admdate=""
   .s admdate=$p(^PAADM(adm),"^",6)
   .i admdate'="" s admdate=$zd(admdate,3)
   .;s diagnodesc=##class(web.DHCOutPhCommon).GetMRDiagnosDesc(adm,",")
   .s MRAdm=$p(^PAADM(adm),"^",61)
   .
   .s PrescType=..IsPrescType(PrescNo)
   .s diagnodesc=##Class(web.UDHCPrescript).GetMRDiagnosByPrescNo(PrescNo)
   .s diagnodesc=$replace(diagnodesc,"^"," ")
   .;if PrescType=1 d
   ..;s diagnodesc=$replace($P(diagnodesc,"||",2),"^"," ")
   .;e  d
   ..;s diagnodesc=$replace($P(diagnodesc,"||",1),"^"," ")
   .s patW=##class(web.DHCOutPhCommon).GetPatWeight(adm)
   .s deplocdr=$p(^PAADM(adm),"^",4)
   .s deplocdesc=$p(^CTLOC(deplocdr),"^",2)
   .i deplocdesc["-" s deplocdesc=$p(deplocdesc,"-",2)
   .//配药信息
   .s pyname="",fyname="",pydate="",fydate="",phloc="",phwindesc=""
   .s phdrow=$$getphdrow(PrescNo,phdphl,prt)
   .i phdrow'="" d
   ..s pyname=""
   ..s pyuserdr=$p(^DHCPHDISP(phdrow,1),"^",3)
   ..i pyuserdr'="" s pyname=$p(^DHCPHPER(pyuserdr),"^",2)
   ..s fyname=""
   ..s fyuserdr=$p(^DHCPHDISP(phdrow,1),"^",2)
   ..i fyuserdr'="" s fyname=$p(^DHCPHPER(fyuserdr),"^",2)
   ..;
   ..s pydate=$p(^DHCPHDISP(phdrow,1),"^",5)
   ..i pydate'="" s pydate=$zd(pydate,3)
   ..s pytime=$p(^DHCPHDISP(phdrow,1),"^",7)
   ..i pytime'="" s pytime=..%ZT(pytime,1)
   ..s pydate=pydate_" "_pytime
   ..; 
   ..s fydate=$p(^DHCPHDISP(phdrow),"^",3)
   ..i fydate'="" s fydate=$zd(fydate,3)
   ..s fytime=$p(^DHCPHDISP(phdrow),"^",5)
   ..i fytime'="" s fytime=..%ZT(fytime,1)
   ..s fydate=fydate_" "_fytime
   ..;
   ..s phl=$p(^DHCPHDISP(phdrow,1),"^",1)
   ..s phlocdr=$p(^DHCPHLOC(phl),"^",1)
   ..s phloc=$p(^CTLOC(phlocdr),"^",2)
   ..;
   ..s phwindesc=""
   ..s phwdr=$p(^DHCPHDISP(phdrow),"^",4)
   ..i phwdr'="" d 
   ...i $D(^DHCPHWIN(phwdr)) d
   ....s phwindesc=$p(^DHCPHWIN(phwdr),"^",1)
   ..
   .
   .s sysdate=$zd(+$h,3)_" "_$p(..%ZT(..%SysTime(),1),":",1,2) 
   .s retstr=..Getpaque(PrescNo)
   .s queinst=$p(retstr,"^",1)
   .s quefac=$p(retstr,"^",2) 
   .s queqty=$p(retstr,"^",3)
   .s quedate=$p(retstr,"^",4)
   .s quexdate=$p(retstr,"^",5)
   .s quenote=$p(retstr,"^",6)  
   .s quecook=$p(retstr,"^",7)
   .s queDur=$p(retstr,"^",8)
   .s queFreq=$p(retstr,"^",9)
   .s docstr=##class(web.DHCOutPhCommon).GetOrdDoc(PrescNo,reclocdr)
   .s docctloc=$p(docstr,"^",1)
   .s doctor=$p(docstr,"^",2)
   .s orddate=$p(docstr,"^",3)
   .s orddoctdr=$p(docstr,"^",4)
   .s orddate=orddate
   .s paydtae=..GetOrdPayDate(prt)
   .s billtype=..GetPrescType(PrescNo)
   .
   .;s prescbillchk=##class(web.DHCOutPhCommon).GetPrescBillAuditDesc(PrescNo)
   .s prescbillchk=""
   .s presctitle=..GetPrescPrtTitle(PrescNo)
   .s lgflag=..ChkLGFlagByPrescNo(PrescNo)
   .;
   .s itmSub=$o(^OEORD(0,"PrescNo",PrescNo,ord,0))
   .s:reclocdr="" reclocdr=$P($G(^OEORD(ord,"I",itmSub,3)),"^",6) ;OEORI_RecDep_DR接收科室
   .s:reclocdr'="" recloc=$p(^CTLOC(reclocdr),"^",2)
   .i $F(recloc,"-") s recloc=$p(recloc,"-",2)
   .s EmployeeFunction=""
   .s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,.ErrMsg)
   .i PatEncryptLevel'="" s EmployeeFunction=$p(PatEncryptLevel,"^",2)
   .
   .s tmppatstring=perno_"^"_pname_"^"_sex_"^"_getage_"^"_diagnodesc_"^"_patW_"^"_pyname_"^"_fyname_"^"_pydate_"^"_fydate_"^"_sysdate_"^"_recloc_"^"_company_"^"_admdate_"^"_cardNo_"^"_PrescNo_"^"_deplocdesc_"^"_phwindesc_"^"_ptel_"^"_paddress_"^"_quecook_"^"_queqty_"^"_presctitle_"^"_docctloc_"^"_doctor
   .s tmppatstring=tmppatstring_"^"_queinst_"^"_quefac_"^"_queqty_"^"_quedate_"^"_quexdate_"^"_quenote_"^"_orddate_"^"_paydtae_"^"_billtype_"^"_prescbillchk_"^"_lgflag_"^"_EmployeeFunction_"^"_orddoctdr
   .;
   .s itm=""
   .f  s itm=$o(^OEORD(0,"PrescNo",PrescNo,ord,itm)) q:itm=""  d
   ..s tmpreclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
   ..q:(tmpreclocdr'=reclocdr)&(chkreclocflag'=0)
   ..s oeori=ord_"||"_itm
   ..//---scl---
   ..s OrdStatusDR=$P($G(^OEORD(ord,"I",itm,1)),"^",13) 
   ..s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
   ..s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
   ..Q:((OrdStatusCode'="V")&(OrdStatusCode'="E"))   ;不显示停止的医嘱
   ..//----end----
   ..s nouseitm=""
   ..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,"")) 
   ..s qty=$p(^DHCOEDISQTY(dsp),"^",2)
   ..s freq=$p(^PHCFR(+$p(^OEORD(ord,"I",itm,2),"^",4)),"^",1)  ;用药频率
   ..s freq2=$p(^PHCFR(+$p(^OEORD(ord,"I",itm,2),"^",4)),"^",2)  ;用药频率
   ..s freq=$p(^PHCFR(+$p(^OEORD(ord,"I",itm,2),"^",4)),"^",4)  ;用药频率
   ..;b //00
   ..s inst=$p(^PHCIN(+$p(^OEORD(ord,"I",itm,2),"^",7)),"^",2)  ;用法 
   ..s inst2=$p(^PHCIN(+$p(^OEORD(ord,"I",itm,2),"^",7)),"^",3)  ;用法 
   ..s phdur=$p(^PHCDU(+$p(^OEORD(ord,"I",itm,2),"^",6)),"^",1) ;用药疗程
   ..s dosage=$p(^OEORD(ord,"I",itm,2),"^",1) ;用药剂量
   ..s dosageuomdr=$p(^OEORD(ord,"I",itm,2),"^",3)
   ..s dosageuom=""
   ..s:dosageuomdr'="" dosageuom=$p(^CT("UOM",dosageuomdr),"^",2)   ;剂量单位 
   ..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2) 
   ..;协议单位
   ..s ARCIMBillingUOM=$P(^ARCIM(+arcimid,$P(arcimid,"||",2),8),"^",14) 
   ..s ProtocolPackUOMDR=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
   ..if ProtocolPackUOMDR'="" s ARCIMBillingUOM=ARCIMBillingUOM
   ..s totalprice=0
   ..s price=0
   ..s price=totalprice/qty
   ..s price=$fn(price,"",4)
   ..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""
   ..;s GrameName=$P(^ARCIM(+arcimid,$P(arcimid,"||",2),8),"^",21)
   ..s GrameName=$P(^ARCIM(+arcimid,$P(arcimid,"||",2),1),"^",3)
   ..s GenericName=##class(web.UDHCPrescript).GetDrugCommonNameByArcimId(arcimid)
   ..s Spec=##Class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci) 
   ..s incidsec=$p(^INCI(inci,1),"^",2)
   ..s unit=""
   ..s qtyinfo=##class(web.DHCOutPhCommon).getPackQty(inci,qty)
   ..s qty=$p(qtyinfo,"^",1)
   ..s unit=$p(qtyinfo,"^",2)
   ..s skintest=""
   ..s skinflag=##class(web.DHCOutPhCommon).SkinTest(ord_"||"_itm)
   ..i (skinflag'<0)&(skinflag'="") s skintest="(-)"
   ..i skinflag=-1 s skintest="(+)"
   ..i skinflag=-6 s skintest="( )"
   ..i skinflag=-5 s skintest="(原液)"
   ..s ordremark=##class(web.DHCOutPhCommon).GetOrdRemark(ord_"||"_itm)
   ..i prt="" d
   ...s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(tmpreclocdr)
   ...s hospdr=$p(HospString,"^",1)
   ...s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci,+$h,ARCIMBillingUOM,hospdr)
   ...;w incidsec_","_price_","_qty,!
   ...s totalprice=price*qty
   ...s OrderMesage=##class(web.DHCDocOrderCommon).GetOrderMesage(oeori)
   ...s totalprice=$P(OrderMesage,"^",3)
   ...;w incidsec_","_totalprice,!
   ..e  d
   ...s ordpriceinfo=##class(web.DHCOutPhCommon).GetBasPriceByInv(prt,oeori)
   ...s price=$p(ordpriceinfo,"^",1)
   ...s price=$Fn(price,"",6)
   ...s totalprice=$p(ordpriceinfo,"^",2)
   ...;s:totalprice=0 nouseitm=0
   ...s OrderMesage=##class(web.DHCDocOrderCommon).GetOrderMesage(oeori)
   ...s totalprice=$P(OrderMesage,"^",3)
   ..q:$g(nouseitm)=0
   ..s seqno=$p(^OEORD(ord,"I",itm,3),"^",4)
   ..s moeori=..GetMainOeori(oeori)
   ..s chkgl=..ChkOrdGL(moeori)
   ..i chkgl=0 d
   ...s tseqno=+$g(tseqno)+1
   ...s prtno=tseqno
   ..
   ..i chkgl=1 d
   ...i oeori'=moeori d
   ....i $g(tseqno)="" s tseqno=1
   ....s tseq=+$g(tseq)+1
   ....s prtno=tseqno_"."_tseq
   ...e  d
   ....s tseq=0
   ....s tseqno=+$g(tseqno)+1
   ....s prtno=tseqno
   ..
   ..s patstring=tmppatstring
   ..s specinst=$p(^OEORD(ord,"I",itm,2),"^",8)
   ..s tmpsting=incidsec_"^"_qty_"^"_unit_"^"_dosage_""_dosageuom_"^"_inst2_"^"_freq_"^"_phdur_"^"_price_"^"_totalprice_"^"_skintest_"^"_ordremark_"^"_prtno_"^"_specinst_"^"_GenericName_"^"_Spec_"^"_GrameName
   ..i medstring="" d
   ...s medstring=tmpsting
   ..e  d
   ...s medstring=medstring_"@"_tmpsting
   ..
   ..
   q patstring_"!!"_medstring
   
getphdrow(PrescNo,phdphl,prt)
   s phdrow="",tmpphdrow=""
   f  s phdrow=$o(^DHCPHDISPi("PRESCNO",PrescNo,phdrow)) q:phdrow=""  d
   .s tmpphdphl=$p(^DHCPHDISP(phdrow,1),"^",1)
   .q:(tmpphdphl'=phdphl)&(chkreclocflag='0)&(phdphl'="")
   .s tmpptr=$p(^DHCPHDISP(phdrow),"^",2)
   .q:(tmpptr'="")&(tmpptr'=prt)&(prt'="")
   .s tmpphdrow=phdrow
   q tmpphdrow
}

ClassMethod Getpaque(prescno As %String) As %String
{
   ;获得中草药信息 PA_Que1 
    
   q:prescno="" ""
   s queid=""
   s questr=""
   f  s queid=$o(^PAQUE1(0,"PrescNo",prescno,queid)) q:queid=""  d
   .q:'$d(^PAQUE1(queid,"DHC"))
   .s insdr=$p(^PAQUE1(queid,"DHC"),"^",11)
   .s Instruc=$p(^PHCIN(insdr),"^",2) ;用法
   .s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
   .s facotor=$p(^PHCDU(durdr),"^",2) ;剂数
   .s durdesc=$p(^PHCDU(durdr),"^",3)
   .s orderqty=$p(^PAQUE1(queid,"DHC"),"^",13) ;用量
   .s quedate=$p(^PAQUE1(queid,"DHC"),"^",6) ;开始时间
   .s quexdate=quedate+facotor-1
   .i $g(quedate)'="" s quedate=$zd(quedate,3)
   .i $g(quexdate)'="" s quexdate=$zd(quexdate,3)
   .s preno=$p(^PAQUE1(queid),"^",14) ;处方号
   .s type=$p(^PAQUE1(queid,"DHC"),"^",15) ;方式
   .s notes=$p(^PAQUE1(queid,"DHC"),"^",21) ;备注
   .i type'="" d
   ..s type=##Class(web.UDHCPrescript).CookModeDesc(type)
   .s FreqRowid=$P(^PAQUE1(queid,"DHC"),"^",9)
   .s FreqDesc=$p(^PHCFR(FreqRowid),"^",3)
   .s questr=Instruc_"^"_facotor_"^"_orderqty_"^"_$g(quedate)_"^"_$g(quexdate)_"^"_notes_"^"_type_"^"_durdesc_"^"_FreqDesc
   .
   q $g(questr)
}

/// 获取处方收费日期
ClassMethod GetOrdPayDate(prt As %String) As %String
{
  q:prt="" ""
  s phar=""
  f  s phar=$o(^DHCPHARi("PRT",prt,phar)) q:phar=""  d
  .s phardate=$p(^DHCPHARW(phar),"^",2)
  .i phardate'="" d
  ..s phardate=$zd(phardate,3)
  .s phartime=$p(^DHCPHARW(phar),"^",5)
  .i phartime'="" d
  ..s phartime=..%ZT(phartime,1)
  ..s phartime=$p(phartime,":",1,2)
  q $g(phardate)_" "_$g(phartime)
}

/// Description:得到处方类型(医保,自费)
/// Creator:郭荣勇
/// CreatDate:2014-08-31
/// /w ##class(web.DHCDocPrescriptJSSZY).GetPrescType("O16012000220")
ClassMethod GetPrescType(prescno)
{
  s presctypedesc=""
   s ord=$o(^OEORD(0,"PrescNo",prescno,"")) 
   s itm=$o(^OEORD(0,"PrescNo",prescno,ord,"") ) 
   s preason=$p(^OEORD(ord,"I",itm,11),"^",18)
   s EpisodeID=$P(^OEORD(ord),"^",1)
   if (preason=""){
	s preason=$p($g(^PAADM(EpisodeID,1)),"^",7)
   }
   q:preason="" ""
   s presctypedesc=$p($G(^PAC("ADMREA",preason,"DOC")),"^",1)
   i presctypedesc=""  s presctypedesc=$p(^PAC("ADMREA",preason),"^",2)
   
   ;北京地区医保病人打印分:医保(内),医保(外)
   s AdmId=$p(^OEORD(ord),"^",1)
   s PatientID=$p(^PAADM(AdmId),"^",1)
   s AdmType=$p(^PAADM(AdmId),"^",2)
   s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
   s DefaultBillTypeId=..GetDefaultBillType(PatCatDr)
   s InsurFlag=##class(web.DHCDocOrderCommon).GetInsurFlag(DefaultBillTypeId,AdmType)
   i InsurFlag=1 {
	   i presctypedesc="自费"  ;s presctypedesc="医保(外)"
   }
   
   q presctypedesc
}

ClassMethod GetDefaultBillType(PatCatDr As %String) As %String
{
	set AdmReason=""
	i PatCatDr'="" set DHCPACADMDr=$o(^DHCPACADM(0,"Social",PatCatDr,""))
	i $g(DHCPACADMDr)'="" set AdmReason=$p(^DHCPACADM(DHCPACADMDr),"^",2)
	Q AdmReason
}

/// Description:得到处方打印类型(毒麻,精神一类,精神二类)
/// Creator:Liang Qiang
/// CreatDate:2011-08-31
ClassMethod GetPrescPrtTitle(presc)
{
	s prescord="",prescitm="",retval=""
	s prescord=$o(^OEORD(0,"PrescNo",presc,""))
	i prescord="" q ""
	s prescitm=$o(^OEORD(0,"PrescNo",presc,prescord,""))
	s prescitmmast=""
    s prescitmmast=$p(^OEORD(prescord,"I",prescitm,1),"^",2)
    s prescdrgform="",prescdrgmast=""
    s prescdrgform=$p(^ARCIM($p(prescitmmast,"||",1),$p(prescitmmast,"||",2),1),"^",12)
    s prescdrgmast=$p(prescdrgform,"||",1)
    s prescpoisondr=""
    i prescdrgmast'=0 s prescpoisondr=+$p(^PHCD(prescdrgmast,1),"^",4)
    i prescpoisondr'="" s poisondesc=$p(^PHCPO(prescpoisondr),"^",2)
    s prescitmcat="",oeccat="",oecatdesc=""
    s prescitmcat=$p(^ARCIM($p(prescitmmast,"||",1),$p(prescitmmast,"||",2),1),"^",10)
	s oeccat=$p(^ARC("IC",prescitmcat),"^",8)
	s oecatdesc=$p(^OEC("ORCAT",oeccat),"^",2)
	s poisonflag=0
	s poisonflag=..CheckPoison(poisondesc)
	i poisonflag=1 s retval=poisondesc
	e  s retval=""
	q retval
}

ClassMethod CheckPoison(poisondesc)
{
	 i poisondesc="" q 0
	 i poisondesc["毒" q 1
	 i poisondesc["麻" q 1
	 i poisondesc["精" q 1
	 q 0
}

/// 判断该处方是否留观  0 非  1 是
ClassMethod ChkLGFlagByPrescNo(prescno) As %String
{
	q:prescno="" 0
	s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	q:ord="" 0 
	s itm=$o(^OEORD(0,"PrescNo",prescno,ord,"")) 
    q:ord="" 0                   	
    s lgflag=$p($g(^OEORD(+ord,"I",itm,"DHC")),"^",17)
    q:lgflag="" 0
	q 1
}

/// 取主医嘱Rowid
ClassMethod GetMainOeori(oeori As %String) As %String
{
	//N (oeori)
	Q:oeori="" ""
 	S ord=$p(oeori,"||",1) Q:ord="" ""
 	S chl=$p(oeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	Q:'$D(^OEORD(ord,"I",chl,11)) ""
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	Q:loeori'="" loeori
 	Q oeori
}

/// 检查是否关联医嘱，1 -是 ，0- 否
ClassMethod ChkOrdGL(moeori)
{
   s mord=+moeori
   s m=0
   s lchl=""
   f  s lchl=$O(^OEORDi(0,"OEORI",mord,moeori,lchl))	q:lchl=""  d
   .s m=m+1
   i m>1 q 1
   q m
}

/// 判断处方是否为草药处方
/// 入参：   PrescNo:     处方号
ClassMethod IsPrescType(PrescNo As %String) As %String
{
	Q:PrescNo="" 0
	s PrescRowId=$O(^PAQUE1(0,"PrescNo",PrescNo,0))
	Q:PrescRowId="" 0
	s PrescType=$p($G(^PAQUE1(PrescRowId,"DHC")),"^",2)
	Q:PrescType=3 1
	Q 0
}

/// Creator:郭荣勇
/// date:2014-08-26
/// desc:得到是否毒麻处方
/// output:1 毒麻,0 非毒麻
/// d ##class(web.DHCDocPrescriptJSSZY).IsDMPresc("OJE14092400002")
ClassMethod IsDMPresc(PrescNo As %String) As %String
{
	Q:PrescNo="" 0
	s Ord=$O(^OEORD(0,"PrescNo",PrescNo,0))
	i Ord'="" s Chl=$O(^OEORD(0,"PrescNo",PrescNo,Ord,0))
	Q:$g(Chl)="" 0
	s ARCIMRowid=$p($g(^OEORD(Ord,"I",Chl,1)),"^",2)
	s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ARCIMRowid)
	i PoisonRowid'="" {
		s PoisonCode=$p($g(^PHCPO(PoisonRowid)),"^",1)
		i " J1 DM DX MZ J2 "[ PoisonCode  Q 1
	}
	Q 0
}

/// Creator:郭荣勇
/// date:2014-08-26
/// desc:得到XML模版打印的ID
ClassMethod GetXMLTemplateId(XMLTemplateName As %String) As %String
{
	Q:XMLTemplateName="" ""
	s XMLTemplateName=$zcvt(XMLTemplateName,"U")
	s XMLTemplateName=" "_XMLTemplateName
	s Id=$O(^User.DHCXMLPConfigI("XPCFlagIndex",XMLTemplateName,0))
	Q Id
}

/// Creator:郭荣勇
/// date:2014-08-26
/// desc:输出csp中的空格
ClassMethod OutSpace(Num As %String) As %String
{
	s OutStr=""
	for i=1:1:+Num {
		s OutStr=OutStr_"&nbsp"
	}
	Q OutStr
}

/// Creator:lxz
/// date:2014-12-01
/// desc:创建患者就诊的处方列表
ClassMethod PrescNoList(itmjs As %String, EpisodeID As %String, PresStr As %String = "", CurLogonHosp As %String = "") As %String
{
 s ReturnStr=""	
 s PrescNo="", TransDate="", TransTime="", RecLoc=""
 &sql(DECLARE EmpCur2 CURSOR FOR
 SELECT distinct OEORI_PrescNo,to_Date(OEORI_Date,'YYYY-MM-DD'),cast(OEORI_Time AS TIMESTAMP),OEORI_RecDep_DR->CTLOC_Desc
	  INTO :PrescNo,:TransDate,:TransTime,:RecLoc
	  from SQLUser.OE_OrdItem 
	 Where OEORI_OEORD_Parref->OEORD_ADM_DR=:EpisodeID and OEORI_PrescNo<>""
	  Order By OEORI_PrescNo)
 &sql(OPEN EmpCur2)
 for  &SQL(FETCH EmpCur2) QUIT:SQLCODE  do
 .Q:((PresStr'="")&&(("^"_PresStr_"^")'[("^"_PrescNo_"^")))
 .s Count=##class(web.DHCOEOrdItem).GetPrescItemCount(EpisodeID,PrescNo)
 .i (Count>0) Do
 ..s OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,""))
 ..s itemsub=$O(^OEORD(0,"PrescNo",PrescNo,OrderRowid,0))
 ..s ArcimRowid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
 ..s SttDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)
 ..s TransDate=$zd(SttDate,3)
 ..i ArcimRowid'="" s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
 ..s PatientID=$P(^PAADM(EpisodeID),"^",1)
 ..s PatientDOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
 ..;1:普通  2:毒麻  3:精二  4:小儿
 ..s PrescType="",PrescTypeDesc=""
 ..i PatientDOB'="" d
 ...i (((+$H)-PatientDOB)/365.25)<15 s PrescType=3
 ..s IsDMPresc=..IsDMPresc(PrescNo)
 ..if IsDMPresc  d
 ...s PrescType=2
 ..i PrescType="" s PrescType=1
 ..i PrescType=1 s PrescTypeDesc="普通"
 ..i PrescType=2 s PrescTypeDesc=..GetPrescPrtTitle(PrescNo)
 ..i PrescType=3 s PrescTypeDesc="小儿"
 ..i ItemCatDR'="" s ItemCatDR="^"_ItemCatDR_"^"
 ..s CNMedItemCat=..%GetConfig("CNMedItemCat",CurLogonHosp)
 ..i CNMedItemCat'="" s CNMedItemCat="^"_CNMedItemCat_"^"
 ..s Desc=PrescNo_"   "_TransDate_"   "_RecLoc_"   "_PrescTypeDesc
 ..if (itmjs'="")  d
 ...s Desc=PrescNo_"   "_TransDate_"   "_RecLoc_"   "_PrescTypeDesc
 ...s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(PrescNo,"O","JS")_"');"
 ...&javascript<#(retval)#>
 ..if ReturnStr="" s ReturnStr=Desc_"!"_PrescNo
 ..else  s ReturnStr=ReturnStr_"^"_Desc_"!"_PrescNo
 &sql(CLOSE EmpCur2)
 q ReturnStr
}

/// Creator:lxz
/// date:2014-12-01
/// desc:获取患者所有的医嘱列表
/// w ##class(web.DHCDocPrescriptJSSZY).GetAllPrescNo(713)
ClassMethod GetAllPrescNo(EpisodeID As %String) As %String
{
	s PrescNoStr=""
	s OEOrdRowID=+$o(^OEORD(0,"Adm",+EpisodeID,0))
	if OEOrdRowID'=0  d
	.s QUERowID=0
	.f  s QUERowID=$O(^PAQUE1(0,"QUE1_PAADM_DR",EpisodeID,QUERowID)) Q:QUERowID=""  d
	..s QUENO=$P($G(^PAQUE1(QUERowID)),"^",14)
	..Q:QUENO=""
	..s PrescNo=QUENO
	..s Have="0"
	..s ord=0
	..f  s ord=$o(^OEORD(0,"PrescNo",PrescNo,OEOrdRowID,ord)) q:((ord="")||(Have=1))  d
	...s Stat=$P($G(^OEORD(OEOrdRowID,"I",ord,1)),"^",13) 
	...s statcode="V"
	...i Stat'="" d
	...s statcode=$p($g(^OEC("OSTAT",Stat)),"^",1)
	...s statDesc=$p($g(^OEC("OSTAT",Stat)),"^",2) 
	...s statcode=$ZCVT(statcode,"U")
	...Q:((statcode="C")||(statcode="U")||(statcode="D"))
	...s Have="1"
	..Q:Have=0
	..if PrescNoStr=""  s PrescNoStr=PrescNo
	..else  s PrescNoStr=PrescNoStr_"^"_PrescNo
    q PrescNoStr
}

ClassMethod GetPrescEventLogInfo(AdmId)
{
	s ret=""
	s papmiId=$P(^PAADM(AdmId),"^",1)
	s papmiNo=$P(^PAPER(papmiId,"PAT",1),"^",1)
	s SecretCode=""
	s PAPMISecretLevelDR=$p($g(^PAPER(papmiId,"DHC")),"^",30)
	if PAPMISecretLevelDR'="" s SecretCode=$List(^User.DHCSecretLevelD(PAPMISecretLevelDR),2)

	s ret=papmiNo_"^"_AdmId_"^"_SecretCode
	q ret
}

ClassMethod ReadXML(CFlag As %String, ExpandXML As %String = "") As %String
{
	////%Stream
	////Test    d ##class(web.DHCDocPrescriptJSSZY).ReadXML("DHCOPAdmRegPrint")
	s CFlag=$g(CFlag)
	s RepId=$I(^tmpReadXML(CFlag))
	
	s stream= ##class(web.DHCDataStream).ReadServerXML(CFlag)
	
	
	d stream.Rewind()
	s count=0
	While (stream.AtEnd = 0) {
		s IOStrLen=2000
		s mystr=stream.Read(.IOStrLen)
		if (ExpandXML'="")&&(mystr["</PLData>") {
			s mystr=$P(mystr,"</PLData>",1)_ExpandXML_"</PLData>"_$P(mystr,"</PLData>",2,$Length(mystr,"</PLData>"))
		}
		s count=count+1
		s ^tmpReadXML(CFlag,RepId,count)=mystr
	}
	b ;111
	q count_"^"_RepId
}

ClassMethod ReadOneRecordXML(CFlag As %String, RepId As %String, Ind As %String) As %String
{
	s CFlag=$g(CFlag),RepId=$g(RepId)
	s Str=$g(^tmpReadXML(CFlag,RepId,Ind))
	
	k ^tmpReadXML(CFlag,RepId,Ind)
	q Str
}

Query FindCMOrdList(PatientNo As %String, SttDate As %String, EndDate As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "EpisodeID:%String,PatientName:%String,PatSex:%String,Age:%String,PAADMDate:%String,AdmDepDesc:%String,AdmDocDesc:%String,PrintFlag:%String")
{
}

ClassMethod FindCMOrdListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCMOrdListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCMOrdListExecute(ByRef qHandle As %Binary, PatientNo As %String, SttDate As %String, EndDate As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocPrescriptJSSZY","FindCMOrdList","13","2016-1-11","2016-1-11")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^tan("FindCMOrdListExecute")=PatientNo_","_SttDate_","_ EndDate
	if (SttDate="") s SttDate=$ZD(+$H,3)
	if (EndDate="") s EndDate=$ZD(+$H,3)
	if (PatientNo=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s PatinetID=$O(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),0))
	if (PatinetID=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s SttDate=$ZDH(SttDate,3)
	s EndDate=$ZDH(EndDate,3)
	s PatientName=$p($g(^PAPER(PatinetID,"ALL")),"^",1)
	s PatSex=""
	s PatSexDR=$p($g(^PAPER(PatinetID,"ALL")),"^",7)
	i PatSexDR'="" s PatSex=$p(^CT("SEX",PatSexDR),"^",2)
	s Age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatinetID,"")
	
	s PAADMType=0
	for {
		s PAADMType=$O(^PAPERdr(PatinetID,"ADM",PAADMType))
		q:PAADMType=""
		s EpisodeID=0
		for {
			s EpisodeID=$O(^PAPERdr(PatinetID,"ADM",PAADMType,EpisodeID))
			q:EpisodeID=""
			s PAADMDate=$P(^PAADM(EpisodeID),"^",6)
			continue:(PAADMDate<SttDate)||(PAADMDate>EndDate)
			s PAADMDate=$ZD(PAADMDate,3)
			s PAADMAdmTime=$P(^PAADM(EpisodeID),"^",7)
			s PAADMAdmTime=..%ZT(PAADMAdmTime)
			
			s PAADMDate=PAADMDate_" "_PAADMAdmTime
			s AdmDepDesc=""
			s AdmDep=$P(^PAADM(EpisodeID),"^",4)
			s:AdmDep'="" AdmDepDesc=$P(^CTLOC(AdmDep),"^",2)
			
			s AdmDocDesc=""
			s AdmDoc=$P(^PAADM(EpisodeID),"^",9)
			s:AdmDoc'="" AdmDocDesc=$P(^CTPCP(AdmDoc,1),"^",2)
			s PrintFlag=$G(^DHCOrdListPrint(EpisodeID))
			if (PrintFlag="Y"){
				s PrintFlag="已打印"
			}else{
				s PrintFlag="未打印"
			}
			s PrescNoList=..GetCMPrescNoList(EpisodeID)
			continue:PrescNoList=""
			
			d OutputRow6
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	Set Data=$LB(EpisodeID,PatientName,PatSex,Age,PAADMDate,AdmDepDesc,AdmDocDesc,PrintFlag)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindCMOrdListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCMOrdListExecute ]
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

ClassMethod FindOrderItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrderItemsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// //w ##class(web.DHCDocPrescriptJSSZY).GetCMPrescNoList("971")
ClassMethod GetCMPrescNoList(EpisodeID As %String) As %String
{
	s PrescNoList=""
	s OrderRowid=$O(^OEORD(0,"Adm",EpisodeID,0))
	q:OrderRowid="" ""
	s SubChild=0
	for {
		s SubChild=$O(^OEORD(OrderRowid,"I",SubChild))
		q:SubChild=""
		s PrescNo=$p($G(^OEORD(OrderRowid,"I",SubChild,1)),"^",14)
		continue:PrescNo=""
		continue:..IsValiPrescNo(PrescNo)=0
		s PrescRowid=$O(^PAQUE1(0,"PrescNo",PrescNo,""),-1)
		continue:PrescRowid=""
		
		s PascType=$P($G(^PAQUE1(PrescRowid,"DHC")),"^",2)
		continue:PascType'=3
		s Dat=$P(^PAQUE1(PrescRowid,"DHC"),"^",4)
		s Time=$P(^PAQUE1(PrescRowid,"DHC"),"^",5)
		s Dat=$ZD(Dat,3)_" "_..%ZT(Time,2)
		if (PrescNoList[PrescNo) continue
		
		if PrescNoList="" {
			s PrescNoList=PrescNo_"||"_Dat
		}else{
			s PrescNoList=PrescNoList_"^"_PrescNo_"||"_Dat
		}
		
	}
	q PrescNoList
}

ClassMethod GetWMPrescNoList(EpisodeID As %String) As %String
{
	s PrescNoList=""
	s OrderRowid=$O(^OEORD(0,"Adm",EpisodeID,0))
	q:OrderRowid="" ""
	s SubChild=0
	for {
		s SubChild=$O(^OEORD(OrderRowid,"I",SubChild))
		q:SubChild=""
		s PrescNo=$p($G(^OEORD(OrderRowid,"I",SubChild,1)),"^",14)
		continue:PrescNo=""
		continue:..IsValiPrescNo(PrescNo)=0
		s PrescRowid=$O(^PAQUE1(0,"PrescNo",PrescNo,""),-1)
		if (PrescRowid'=""){
			s PascType=$P($G(^PAQUE1(PrescRowid,"DHC")),"^",2)
			continue:PascType=3
		}
		s Dat=$P($G(^OEORD(OrderRowid,"I",SubChild,1)),"^",9)
		s Time=$P($G(^OEORD(OrderRowid,"I",SubChild,1)),"^",10)
		s Dat=$ZD(Dat,3)_" "_..%ZT(Time,2)
		if (PrescNoList[PrescNo) continue
		
		if PrescNoList="" {
			s PrescNoList=PrescNo_"||"_Dat
		}else{
			s PrescNoList=PrescNoList_"^"_PrescNo_"||"_Dat
		}
		
	}
	q PrescNoList
}

ClassMethod IsValiPrescNo(PrescNo As %String) As %String
{
	s Have="0"
	s OEOrdRowID=$O(^OEORD(0,"PrescNo",PrescNo,""),-1)
	s ord=0
	f  {
		s ord=$o(^OEORD(0,"PrescNo",PrescNo,OEOrdRowID,ord))
		q:((ord="")||(Have=1))  d
		s Stat=$P($G(^OEORD(OEOrdRowID,"I",ord,1)),"^",13) 
		s statcode="V"
		i Stat'="" d
		.s statcode=$p($g(^OEC("OSTAT",Stat)),"^",1)
		.s statDesc=$p($g(^OEC("OSTAT",Stat)),"^",2) 
		.s statcode=$ZCVT(statcode,"U")
		continue:((statcode="C")||(statcode="U")||(statcode="D"))
		s Have="1"
	}
	q Have
}

ClassMethod SetPrint(EpisodeID As %String) As %String
{
	q:EpisodeID="" ""
	s ^DHCOrdListPrint(EpisodeID)="Y"
	q 0
}

Query FindCMPrescList(PatientNo As %String, SttDate As %String, EndDate As %String, RecLocStr As %String = "") As %Library.Query(CONTAINID = "", ROWSPEC = "EpisodeID:%String,PatientName:%String,PatSex:%String,Age:%String,PAADMDate:%String,AdmDepDesc:%String,AdmDocDesc:%String,PrintFlag:%String,PrescNo:%String,SaveDat:%String,PrintDat:%String,RowNum:%String")
{
}

ClassMethod FindCMPrescListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCMPrescListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCMPrescListExecute(ByRef qHandle As %Binary, PatientNo As %String, SttDate As %String, EndDate As %String, SelType As %String, RecLocStr As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocPrescriptJSSZY","FindCMPrescList","Z04453713","2016-03-22","2016-03-22","ALL","0^0^0")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	///SelType-"CM","WM","ALL"
	if (SelType="") s SelType="ALL"
	s ^tan("FindCMPrescListExecute")=PatientNo_","_SttDate_","_ EndDate_","_SelType_","_RecLocStr
	if (SttDate="") s SttDate=$ZD(+$H,3)
	if (EndDate="") s EndDate=$ZD(+$H,3)
	if (PatientNo=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s PatinetID=$O(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),0))
	if (PatinetID=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s SttDate=$ZDH(SttDate,3)
	s EndDate=$ZDH(EndDate,3)
	s RowNum=0
	
	s PAADMType=0
	for {
		s PAADMType=$O(^PAPERdr(PatinetID,"ADM",PAADMType))
		q:PAADMType=""
		s EpisodeID=0
		for {
			s EpisodeID=$O(^PAPERdr(PatinetID,"ADM",PAADMType,EpisodeID))
			q:EpisodeID=""
			s PAADMDate=$P(^PAADM(EpisodeID),"^",6)
			continue:(PAADMDate<SttDate)||(PAADMDate>EndDate)
			s PAADMDate=$ZD(PAADMDate,3)
			s PAADMAdmTime=$P(^PAADM(EpisodeID),"^",7)
			s PAADMAdmTime=..%ZT(PAADMAdmTime)
			
			s PAADMDate=PAADMDate_" "_PAADMAdmTime
			s AdmDepDesc=""
			s AdmDep=$P(^PAADM(EpisodeID),"^",4)
			s:AdmDep'="" AdmDepDesc=$P(^CTLOC(AdmDep),"^",2)
			
			s AdmDocDesc=""
			s AdmDoc=$P(^PAADM(EpisodeID),"^",9)
			s:AdmDoc'="" AdmDocDesc=$P(^CTPCP(AdmDoc,1),"^",2)
			if (SelType="CM"){
				s PrescNoList=..GetCMPrescNoList(EpisodeID)
				
			}elseif (SelType="WM"){
				s PrescNoList=..GetWMPrescNoList(EpisodeID)
			}else{
				s PrescNoList=..GetCMPrescNoList(EpisodeID)
				s PrescNoList=PrescNoList_"^"_..GetWMPrescNoList(EpisodeID)
			}
			s PatientName=$p($g(^PAPER(PatinetID,"ALL")),"^",1)
			s PatSex=""
			s PatSexDR=$p($g(^PAPER(PatinetID,"ALL")),"^",7)
			i PatSexDR'="" s PatSex=$p(^CT("SEX",PatSexDR),"^",2)
			s Age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatinetID,"")
			
			for i=1:1:$length(PrescNoList,"^") {
				s PrescNoStr=$P(PrescNoList,"^",i)
				s PrescNo=$P(PrescNoStr,"||",1)
				s Dat=$P(PrescNoStr,"||",2)
				continue:PrescNo=""
				s PayFlag=..CheckPrescNoPayFlag(PrescNo)
				continue:PayFlag'="Y"
				s Flag=..CheckPrescNoRecLocFlag(PrescNo,RecLocStr)
				continue:Flag'="Y"
				s OrderPrintFlag=""
				i $G(^DHCPrescNoPrint(PrescNo))="Y" s OrderPrintFlag="已打印"
				s PrintDat=$G(^DHCPrescNoPrint(PrescNo,"Time"))
				s RowNum=RowNum+1
				d OutputRow7
				s (PatientName,PatSex,Age)=""
					
			}
			
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	Set Data=$LB(EpisodeID,PatientName,PatSex,Age,PAADMDate,AdmDepDesc,AdmDocDesc,OrderPrintFlag,PrescNo,Dat,PrintDat,RowNum)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindCMPrescListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCMPrescListExecute ]
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

ClassMethod CheckPrescNoPayFlag(PrescNo As %String) As %String
{
	///OrderRowid,"I",SubChild
	///^OEORD(0,"PrescNo",{OEORI_PrescNo},{OE_Order.OEORD_RowId},{OEORI_Childsub})
	s PayFlag="N"
	q:PrescNo="" PayFlag
	s OrderRowid=0
	for {
		s OrderRowid=$O(^OEORD(0,"PrescNo",PrescNo,OrderRowid))
		q:OrderRowid=""
		s SubChild=0
		for {
			s SubChild=$O(^OEORD(0,"PrescNo",PrescNo,OrderRowid,SubChild))
			q:SubChild=""
			s OrdStatusDR=$P($G(^OEORD(OrderRowid,"I",SubChild,1)),"^",13) 
			s OrdStatusCode=""
   			s:$g(OrdStatusDR)'="" OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
   			continue:((OrdStatusCode'="V")&(OrdStatusCode'="E"))   ;不显示停止的医嘱
   			
   			s BiiFlag=$P($G(^OEORD(OrderRowid,"I",SubChild,3)),"^",5)
   			if (BiiFlag="P"){
	   			s PayFlag="Y"
	   		}
		}
	}
	q PayFlag
}

/// //w ##Class(web.DHCDocPrescriptJSSZY).CheckPrescNoRecLocFlag("O16032200060","1^0^1")
ClassMethod CheckPrescNoRecLocFlag(PrescNo As %String, CheckPrescNoRecLocFlag As %String) As %String
{
	///OrderRowid,"I",SubChild
	///^OEORD(0,"PrescNo",{OEORI_PrescNo},{OE_Order.OEORD_RowId},{OEORI_Childsub})
	s RecLocFlag="N"
	q:PrescNo="" RecLocFlag
	s CheckGR=+$P(CheckPrescNoRecLocFlag,"^",1)
	s CheckZY=+$P(CheckPrescNoRecLocFlag,"^",2)
	s CheckKL=+$P(CheckPrescNoRecLocFlag,"^",3)
	if (CheckGR=0)&&(CheckZY=0)&&(CheckKL=0){
		s RecLocFlag="Y"
		q RecLocFlag
	}
	s OrderRowid=0
	for {
		s OrderRowid=$O(^OEORD(0,"PrescNo",PrescNo,OrderRowid))
		q:OrderRowid=""
		s SubChild=0
		for {
			s SubChild=$O(^OEORD(0,"PrescNo",PrescNo,OrderRowid,SubChild))
			q:SubChild=""
   			s RecDepDR=$P($G(^OEORD(OrderRowid,"I",SubChild,3)),"^",6)
   			///w RecDepDR,!
   			///609	12	GRZYF-感染中药房
   			if (RecDepDR=609)&&(CheckGR=1){
	   			s RecLocFlag="Y"
	   		}
	   		//598	20	ZYF3L-中药房3楼
			//599	21	ZYF4L-中药房4楼
			//605	8	ZYF2L-中药房2楼
	   		if ((RecDepDR=598)||(RecDepDR=599)||(RecDepDR=605))&&(CheckZY=1){
	   			s RecLocFlag="Y"
	   		}
	   		///601	13	KLJYF-颗粒剂药房
	   		if ((RecDepDR=601))&&(CheckKL=1){
	   			s RecLocFlag="Y"
	   		}
		}
	}
	q RecLocFlag
}

/// /w ##Class(web.DHCDocPrescriptJSSZY).GetExpandXML(2,"DHCOPCMEXEPrint")
ClassMethod GetExpandXML(LineLength As %String, TemplateName As %String) As %String
{
	s (StartX,StartY,EndX,EndY)=""
	s ^tan("GetExpandXML")=LineLength_","_TemplateName
	q:+LineLength=0 ""
	s Slope=8
	if (TemplateName="DHCOPCMEXEPrint"){
		s LineHeight=5	///行高
		s StartP=48		///线起始位置
		
		s StartX=15	//线的左起位置
		s EndX=95		///线的右结束位置
	}
	s EndY=StartP+(LineHeight*LineLength)
	s StartY=EndY+(LineHeight*Slope)
	
	
	s ExpandXML = "<PLine name = ""null"" BeginX = """_StartX_""" BeginY = """_StartY_""" EndX = """_EndX_""" EndY = """_EndY_"""  ></PLine>"
	
	q ExpandXML
}

ClassMethod SetCMPrintSet(UserID As %String, RecLocStr As %String) As %String
{
	s ^DHCDocConfig("SSCMPrintSet",UserID)=RecLocStr
	q 0
}

}
