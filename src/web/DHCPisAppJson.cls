Class web.DHCPisAppJson Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// w ##class(web.DHCPisAppJson).SpeInfo2JSON(0,3,"87","503","30","")

ClassMethod SpeInfo2JSON(Start, Limit, Locdr As %String, Paadmdr As %String, tclscode As %String, TMrowid As %String) As %String
{
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s Locdr=$g(Locdr)
	s Paadmdr=$g(Paadmdr)
	s tclscode=$g(tclscode)
	s tmrowid=$g(TMrowid)
	s rtn=""
	s end = Start+Limit
	s count=0	
	s:tmrowid=0 tmrowid=""
	if (tmrowid=""){
			i (Paadmdr="")||(tclscode="") q "{SpeItem:[]}"
			//s tclscode2=$g(tclscode2)
			s SpePos="",SpeNum="",SpeRemark2="",SpeRemark3="",SpeRemark="",SpeInfo=",{SpeItem:["							
			i $o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,""))="" q "{SpeItem:[]}"
			e  d
			.s tmrowid=0 f  s tmrowid=$o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,tmrowid)) q:tmrowid=""  d
			..;i $d(^DHCPISTestMaster(tmrowid,"TS",0))=0 q		// s SpeInfo="{SpeItem:[]}"  tmrowid
			..s classDr=0 f  s classDr=$o(^DHCPISClassDicti("LOCCODE",Locdr,tclscode,classDr)) q:classDr=""  d
			...i (($p($g(^DHCPISTestMaster(tmrowid)),"^",11)=tclscode) && ($p($g(^DHCPISTestMaster(tmrowid)),"^",41)="")) d			
			....i $d(^DHCPISTestMaster(tmrowid,"TS",0))'="" d
			.....s SpeRowid=0 f  s SpeRowid=$o(^DHCPISTestMaster(tmrowid,"TS",SpeRowid)) q:SpeRowid=""  d
			......s info=$g(^DHCPISTestMaster(tmrowid,"TS",SpeRowid))
			......s SpeRowid1=tmrowid_"||"_SpeRowid			
			......s SpePos=$p(info,"^",3)
			......;s SpeNum=$P($p(info,"^",6),"~",1)
			......s SpeNo=$p(info,"^",1)
			......s SpeRemark2=$P($p(info,"^",6),"~",2) 
			......s SpeRemark=$P($p(info,"^",6),"~",1)     //2013-12-3 
			......s SpeRemark3=$p(info,"^",7)  //2016-12-30 
			......s count=count+1				
			......q:count<(Start+1)			
			......q:count>end
			......i ($e(SpeInfo,$l(SpeInfo))="[") d
			.......s SpeInfo=SpeInfo_"{id:'"_SpeRowid1_"',"_"SpePos:'"_SpePos_"',"_"SpeNo:'"_SpeNo_"',"_"SpeRemark:'"_SpeRemark_"',"_"SpeRemark2:'"_SpeRemark2_"',"_"SpeRemark3:'"_SpeRemark3_"',leaf:false}"
			......e  d
			.......s SpeInfo=SpeInfo_",{id:'"_SpeRowid1_"',"_"SpePos:'"_SpePos_"',"_"SpeNo:'"_SpeNo_"',"_"SpeRemark:'"_SpeRemark_"',"_"SpeRemark2:'"_SpeRemark2_"',"_"SpeRemark3:'"_SpeRemark3_"',leaf:false}"		
			i count=0 s count=1		
			s SpeInfo=SpeInfo_"],results:"_count_"}"
			
		}ElseIf (tmrowid'=""){
			s SpePos="",SpeNum="",SpeRemark="",SpeRemark2="",SpeRemark3="",SpeInfo="{SpeItem:["											
			i $d(^DHCPISTestMaster(tmrowid,"TS",0))'="" d
			.s SpeRowid=0 f  s SpeRowid=$o(^DHCPISTestMaster(tmrowid,"TS",SpeRowid)) q:SpeRowid=""  d
			..s info=$g(^DHCPISTestMaster(tmrowid,"TS",SpeRowid))
			
			..s SpeRowid1=tmrowid_"||"_SpeRowid	
			..s SpePos=$p(info,"^",3)
			..;s SpeNum=$P($p(info,"^",6),"~",1)
			..s SpeNo=$p(info,"^",1)
			..s SpeRemark2=$P($p(info,"^",6),"~",2)
			..s SpeRemark=$P($p(info,"^",6),"~",1)  //2013-12-3 
			..s SpeRemark3=$p(info,"^",7)  //2016-12-30 
			..s count=count+1				
			..q:count<(Start+1)
			..q:count>end
			..i ($e(SpeInfo,$l(SpeInfo))="[") d
			...s SpeInfo=SpeInfo_"{id:'"_SpeRowid1_"',"_"SpePos:'"_SpePos_"',"_"SpeNo:'"_SpeNo_"',"_"SpeRemark:'"_SpeRemark_"',"_"SpeRemark2:'"_SpeRemark2_"',"_"SpeRemark3:'"_SpeRemark3_"',leaf:false}"
			..e  d
			...s SpeInfo=SpeInfo_",{id:'"_SpeRowid1_"',"_"SpePos:'"_SpePos_"',"_"SpeNo:'"_SpeNo_"',"_"SpeRemark:'"_SpeRemark_"',"_"SpeRemark2:'"_SpeRemark2_"',"_"SpeRemark3:'"_SpeRemark3_"',leaf:false}"						
			i count=0 s count=1
			s SpeInfo=SpeInfo_"],results:"_count_"}"
			}
	d ##class(Src.PIS3Common).SetWebSourceNameSpace()
	q SpeInfo
}

// 获取病理检查类别信息

ClassMethod PISCheckSortJSON() As %String
{
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	//q:Rowid="" "{rows:[]}"  就相当于 // i Rowid="" q:"{rows:[]}"
	//下面的依据也可以声明为：s PISSort="{rows:["
	//s PISSort="["
	s PISSort="{rows:["
	s rowid=0 f  s rowid=$o(^DHCPISClassDict(rowid)) q:rowid=""  d
	.s info=$g(^DHCPISClassDict(rowid))
	.q:info=""
	.s name=$p(info,"^",2)
	.;如果上面用根节点的方式，下面写为：.if ($e(PISSort,$l(PISSort))="[") d
	.;i PISSort="[" d
	.if ($e(PISSort,$l(PISSort))="[") d
	..s PISSort=PISSort_"{id:'"_rowid_"',"_"name:'"_name_"',leaf:false}"
	.e  d
	..s PISSort=PISSort_",{id:'"_rowid_"',"_"name:'"_name_"',leaf:false}"
	
	d ##class(Src.PIS3Common).SetWebSourceNameSpace()
	q PISSort_"]}"
	///另外附加，比较的话，M比较方便，如//q:$ZCVT(Desc,"U")'[$ZCVT(groupCode,"U")  ;转换为大写比较
}

// w ##class(Src.DHCPisInterface).GetTypeDesc("I")

// 获取病人在院类型

ClassMethod GetTypeDesc(type) As %String
{
	s type=$g(type)
	i type="" q -901
	s Desc=""
	I type="I" d
	.s Desc="住院病人"
	else  i type="O" d 
	.s Desc="门诊病人"
	else  i type="E" d 
	.s Desc="急诊病人"
	else  i type="H" d
	.s Desc="体检病人" d
	else
	.s Desc="其他病人"
   q Desc
}

// w ##Class(web.DHCPisAppJson).FinBLKID()

ClassMethod FinBLKID() As %String
{
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
    s sysid="" f  s sysid=$o(^User.DHCPISSYSTEMSETD(sysid))  q:sysid=""  d
	.i '$d(^User.DHCPISSYSTEMSETD(sysid)) q
    .s sysInfo=##class(User.DHCPISSYSTEMSET).%OpenId(sysid)
	.s Locdr=sysInfo.SYSDEPTCODE
	d ##class(Src.PIS3Common).SetWebSourceNameSpace()  
    q:Locdr="" -902
	q Locdr
}

// w ##Class(web.DHCPisAppJson).GenTmrowid(23,"10",503)

// creator：CYQ

/*function:
 *首次打开申请单，向主表插入数据
 *如果存在保存了，但未发送的申请单，则输出申请单号
 *另外：可以输出已发送申请单的申请单号； 可以统计为做任何填写和刷新 所走的号码
 */
ClassMethod GenTmrowid(Locdr As %String, tclscode As %String, Paadmdr As %String) As %String
{
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s data=##class(Src.PIS3AppInterface).GenTmrowid(Locdr,tclscode,Paadmdr)
	d ##class(Src.PIS3Common).SetWebSourceNameSpace() 
	q data
	/*
	s Locdr=$g(Locdr)
    s tclscode=$g(tclscode)
    s Paadmdr=$g(Paadmdr)
    i Paadmdr="" d
    .s sysid="" f  s sysid=$o(^User.DHCPISSYSTEMSETD(sysid))  q:sysid=""  d
	..i '$d(^User.DHCPISSYSTEMSETD(sysid)) q
	..d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
    ..s sysInfo=##class(User.DHCPISSYSTEMSET).%OpenId(sysid)
	..s Locdr=sysInfo.SYSDEPTCODE
	..d ##class(Src.PIS3Common).SetWebSourceNameSpace()  
	..q:LocDr=""
    i tclscode="" q -901
    s data=""  //2013-11-27修改
    q:Paadmdr="" -902
    
    s clsId=""
    s clsId=$o(^DHCPISClassDicti("LOCCODE",Locdr,tclscode,clsId))
    q:clsId="" "-915"
   	
    s Info="", sentTMrowid="" ,usingTMrowid="",allowInsert=0
    s classDr=0 f  s classDr=$o(^DHCPISClassDicti("LOCCODE",Locdr,tclscode,classDr)) q:classDr=""  d    //2013-11-27修改
	.;i $d(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr))=0 d
	.i $o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,""))="" d	//如果从来不存在adm这个病人的记录，那么果断插入数据
    ..d ##class(web.DHCPisApplicationSheet).SetPISNameSpace() 
    ..d ##class(Src.PIS3Register).TestMasterAdd(.data,Locdr_"^"_tclscode)  //2013-11-27修改
    ..s Info=data 
    ..d ##class(Src.PIS3Common).SetWebSourceNameSpace()  //2013-11-27修改
    .e  d	//tmmaster中存在这个病人此类型的申请数据
    ..s tmrowid="" f  s tmrowid=$o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,tmrowid),-1) q:(tmrowid="")  d  // && ($p($h,",",1)-$p(^DHCPISTestMaster(tmrowid),"^",26)<2) 
    ...i (($p($g(^DHCPISTestMaster(tmrowid)),"^",11)=tclscode) && (tclscode'=""))	d //判断检查类别，如果类型一致
    ....i ($p($g(^DHCPISTestMaster(tmrowid)),"^",41)>=1)&&($p($g(^DHCPISTestMaster(tmrowid)),"^",41)'="") d  ///一致，且已发送
    .....i sentTMrowid="" d
    ......s sentTMrowid=tmrowid
    .....e  d
    ......s sentTMrowid=sentTMrowid_"^"_tmrowid
    ....e  d	//一致，但未发送(包括已保存 和 是插入的新数据 两种情况)   
    .....i ($p($g(^DHCPISTestMaster(tmrowid)),"^",41)="")&&($p($g(^DHCPISTestMaster(tmrowid)),"^",14)'="") d   
    ......s usingTMrowid=tmrowid	//已保存数据的rowid
    ...e  d			//判断检查类别，如果类型不一致    
    ....s allowInsert=1
    ..;下面判断
    ..i usingTMrowid'="" d
    ...s Info=usingTMrowid
    ..e  d    
    ...d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
    ...d ##class(Src.PIS3Register).TestMasterAdd(.data,Locdr_"^"_tclscode) //2013-11-27修改
    ...s Info=data
    ...;s $p(^DHCPISTestMaster(Info),"^",26)=$p($h,",",1)
    ...;s $p(^DHCPISTestMaster(Info),"^",27)=$p($h,",",2)
    ...d ##class(Src.PIS3Common).SetWebSourceNameSpace() //2013-11-27修改
    
    ;说明：如果存在已发送的申请单，其tmrowid已经拼成了串，这里不再输出，需要时候随时输出即可。
    ;另外：allowInsert换成累加的话，也可以知道此病人存在多少打开而没有做任何操作的申请单数量 和打开后刷新产生的申请单数量之和
    q Info
    */
}

// w ##Class(web.DHCPisAppJson).ShowTmrowid("87",10,"14")

ClassMethod ShowTmrowid(AppLocdr As %String, tclscode As %String, Paadmdr As %String) As %String
{
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s tclscode=$g(tclscode)
    s Paadmdr=$g(Paadmdr)
    ;s AppLocdr=%session.Get("LOGON.CTLOCID")
    s AppLocdr=6
    i tclscode="" q -901
    s Info=""
    q:Paadmdr="" -902 	
  
   
   	s Locdr="" f  s Locdr=$o(^DHCPISClassDicti("LOCCODE",Locdr)) q:Locdr=""  d   
    .s classDr=0 f  s classDr=$o(^DHCPISClassDicti("LOCCODE",Locdr,tclscode,classDr)) q:classDr=""  d    //2013-11-27修改
	..i $o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,""))="" //如果从来不存在adm这个病人的记录,返回空数据
	..else  d
	...s tmrowid="" f  s tmrowid=$o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,tmrowid),-1) q:(tmrowid="")  d  // && ($p($h,",",1)-$p(^DHCPISTestMaster(tmrowid),"^",26)<2) 
    ....i (($p($g(^DHCPISTestMaster(tmrowid)),"^",11)=tclscode) && (tclscode'=""))	d //判断检查类别，如果类型一致
    .....s AppDeptDr=$p(^DHCPISTestMaster(tmrowid),"^",29)
    .....q:(AppLocdr'="")&(AppLocdr'=AppDeptDr)
    .....i ($p($g(^DHCPISTestMaster(tmrowid)),"^",41)>=1)&&($p($g(^DHCPISTestMaster(tmrowid)),"^",41)'="") q  ///一致，且已发送     
    .....else  d
    ......s Info=tmrowid   
    ....else  q 
    d ##class(Src.PIS3Common).SetWebSourceNameSpace()
    q Info
}

/*ClassMethod ShowTmrowid(Locdr As %String, tclscode As %String, Paadmdr As %String) As %String
{
	s tclscode=$g(tclscode)
    s Paadmdr=$g(Paadmdr)
    i tclscode="" q -901
    s data=""  //2013-11-27修改
    q:Paadmdr="" -902
  
    s Info="", sentTMrowid="" ,usingTMrowid="",allowInsert=0
    s classDr=0 f  s classDr=$o(^DHCPISClassDicti("LOCCODE",Locdr,tclscode,classDr)) q:classDr=""  d    //2013-11-27修改
	.i $o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,""))="" s Info=""	//如果从来不存在adm这个病人的记录,返回空数据
	.else  d
	..s tmrowid="" f  s tmrowid=$o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,tmrowid),-1) q:(tmrowid="")  d  // && ($p($h,",",1)-$p(^DHCPISTestMaster(tmrowid),"^",26)<2) 
    ...i (($p($g(^DHCPISTestMaster(tmrowid)),"^",11)=tclscode) && (tclscode'=""))	d //判断检查类别，如果类型一致
    ....i ($p($g(^DHCPISTestMaster(tmrowid)),"^",41)>=1)&&($p($g(^DHCPISTestMaster(tmrowid)),"^",41)'="") q  ///一致，且已发送     
    ....else  d
    .....s Info=tmrowid   
    ...else  q   
    q Info
}*/

// w ##Class(web.DHCPisAppJson).GetAppItems(30,40)

// creator：CYQ

// function:获取病人做过的此类申请信息，包括已发送和正在填写的

// other：拼成json串

ClassMethod GetAppItems(tclscode As %String, Paadmdr As %String) As %String
{
	 s data="{AppItems:[]}"
	 s ^SYLCESHUJU=tclscode_","_Paadmdr
	 d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	 s data=##class(Src.PIS3AppInterface).GetAppItems(tclscode,Paadmdr)
	 d ##class(Src.PIS3Common).SetWebSourceNameSpace()
	 q data
	/*
	s ^appitem("11")=tclscode_"^"_Paadmdr
	s tclscode=$g(tclscode)
    s Paadmdr=$g(Paadmdr)    
    q:tclscode="" "{AppItems:[]}"
    q:Paadmdr="" "{AppItems:[]}"   
    s Info="{AppItems:[" ,Pname="",status="",statusDesc="",appDate="",appTime="",appLocDR=""
   	i tclscode="10" s ^tclscode("code")=10_"^"_11
    else  i tclscode="23" s ^tclscode("code")=23_"^"_24_"^"_25  
    else  i tclscode="20" s ^tclscode("code")=20_"^"_21_"^"_22
    else  i tclscode="30" s ^tclscode("code")=30
    else  i tclscode="31" s ^tclscode("code")=31_"^"_32_"^"_33
    else  i tclscode="40" s ^tclscode("code")=40 
    else  i tclscode="62" s ^tclscode("code")=62
  
        
    s Locdr=0 f  s Locdr=+$o(^DHCPISTestMasteri("LOC",Locdr)) q:Locdr=0  d   
    .f i=1:1:$l($g(^tclscode("code")),"^") s tclscode=$p(^tclscode("code"),"^",i)  d   
    ..s classDr=0 f  s classDr=$o(^DHCPISClassDicti("LOCCODE",Locdr,tclscode,classDr)) q:classDr=""  d     
    ...i $o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,""))="" d
    ....q
    ...e  d
    ....s tmrowid="" f  s tmrowid=$o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,tmrowid)) q:(tmrowid="")  d   
    .....q:($p($g(^DHCPISTestMaster(tmrowid)),"^",14)="") ;保证，如果是TestMaster中c的空记录的话，退出
    .....q:($p($g(^DHCPISTestMaster(tmrowid)),"^",11)'=tclscode) ;保证 如果不是这个类型的话,不显示   
    .....s Pname=$p($g(^DHCPISTestMaster(tmrowid)),"^",14)
    .....s appDate=$zd($p(^DHCPISTestMaster(tmrowid),"^",26),3)
    .....s appTime=$zt($p(^DHCPISTestMaster(tmrowid),"^",27),2)
    .....s appLocDR=$p($g(^DHCPISTestMaster(tmrowid)),"^",57)   
    .....i appLocDR'="" s appLocDR=##class(web.DHCPisApplicationSheet).GetLocName(appLocDR)    
    .....s status=$p($g(^DHCPISTestMaster(tmrowid)),"^",41)
    .....i status="" s statusDesc="正在填写" 
    .....i status'="" d
    ......s statusRowid="" f  s statusRowid=$O(^DHCPISResultStatusi("CODE",status,statusRowid)) q:statusRowid=""  d
    .......s statusDesc=$p($g(^DHCPISResultStatus(statusRowid)),"^",2)
    .....i ($e(Info,$l(Info))="[") d
    ......s Info=Info_"{Pname:'"_Pname_"',tmrowid:'"_tmrowid_"',statusDesc:'"_statusDesc_"',appDate:'"_appDate_"',appTime:'"_appTime_"',appLocDR:'"_appLocDR_"'}"
    .....e  d
    ......s Info=Info_",{Pname:'"_Pname_"',tmrowid:'"_tmrowid_"',statusDesc:'"_statusDesc_"',appDate:'"_appDate_"',appTime:'"_appTime_"',appLocDR:'"_appLocDR_"'}"
    s Info=Info_"]}"
    i Info="{AppItems:[" s Info="{AppItems:[]}"
    q Info
    */
}

// w ##class(web.DHCPisAppJson).GetClinicalDiag("87",503,"10","")

ClassMethod GetClinicalDiag(Locdr As %String, adm As %String, tclscode As %String, TMrowid As %String) As %String
{
	s Locdr=$g(Locdr)
	s Paadmdr=$g(adm)
	s tclscode=$g(tclscode)
	s tmrowid=$g(TMrowid)
	s rtn=""
	s:tmrowid=0 tmrowid=""
	
	if (tmrowid=""){
			s rtn=##Class(web.DHCPisApplicationSheet).GetMainDiaginfo(Paadmdr)
		}ElseIf (tmrowid'=""){
			d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
			s rtn=$p($g(^DHCPISTestMaster(tmrowid)),"^",24)
			d ##class(Src.PIS3Common).SetWebSourceNameSpace()
			}
	q rtn
}

// w ##Class(web.DHCPisAppJson).getRowidByPadm("",40,"30","10")

// creator：CYQ

/*说明：
 *如果TestMaster表中不存在此病人数据，则从HIS中获取
 *如果TestMaster表中存在病人数据，且是已保存状态，从TestMaster表中取
 *如果TestMaster表中存在病人数据，但是已经发送状态或者是一条只有时间的空数据，则从HIS中取
 */
ClassMethod getRowidByPadm(Locdr As %String, Paadmdr As %String, tclscode As %String, TMrowid As %String) As %String
{

	s ^SYLCESHParam=Locdr_","_Paadmdr_","_tclscode_","_TMrowid
	s Locdr=$g(Locdr)
    s tclscode=$g(tclscode)
    s Paadmdr=$g(Paadmdr)
    s tmrowid=$g(TMrowid)
    s data="" //2013-11-27修改PIS3
    s:tmrowid=0 tmrowid=""  
    s CurrentNameSpace =$ZNSPACE  
	if (tmrowid=""){ //2013-11-27	选择申请单后执行此处
	
		s Info="GetFromHIS"_"^"_##Class(web.DHCPisApplicationSheet).GetPaadmInfo(Paadmdr)
		}ElseIf (TMrowid'=""){				
			d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
			s papatmasmdr=$p(^PAADM(Paadmdr),"^",1)
			s DOB=$p(^PAPER(papatmasmdr,"ALL"),"^",6)
			s strDOB=$ZD(DOB,3)
			s strToday=$ZD(+$h,3)						
			s otherInfo=##class(Src.DPIS3InInterface).GetPaadmInfo(Paadmdr) //2013-11-27修改PIS3			
			s outInfo=$p(otherInfo,"^",6)_"^"_$p(otherInfo,"^",12)_"^"_$p(otherInfo,"^",17)_"^"_$p(otherInfo,"^",23)_"^"_$p(otherInfo,"^",24)_"^"_$p(otherInfo,"^",8)_"^"_$p(otherInfo,"^",18)	
			s info57=$p(^DHCPISTestMaster(tmrowid),"^",57)
			s info32=$p(^DHCPISTestMaster(tmrowid),"^",32)
   	 		s $NAMESPACE=CurrentNameSpace	 	   	 		
			s Info=tmrowid_"^"_##class(web.DHCPisApplicationSheet).GetPatInfoByTmRowId(tmrowid)_"^"_outInfo_"^"_info32_"^"_info57				  
			}
    q Info
}

// d ##Class(web.DHCPisAppJson).DelSpeInfo("27,28","1")

ClassMethod DelSpeInfo(ids As %String, TMrowid As %String) As %String
{
		
	s ids=$g(ids)
	q:ids="" -901
	s TMrowid=$g(TMrowid)
	q:TMrowid="" -902	///2013-12-1
	s start=$p(ids,",",1)
	s start1=$p(start,"||",2)	
	s length=$l(ids,",")	
	for item=start1:1:(start1+length-1) d	
	.i item'="" d ##class(web.DHCPisApplicationSheet).TestSpeciDel(TMrowid_"||"_item)
}

// w ##Class(web.DHCPisAppJson).getWomanInfo(35,23,"1")

ClassMethod getWomanInfo(Locdr As %String, Paadmdr As %String, tclscode As %String, tmrowid As %String) As %String
{
	s Locdr=$g(Locdr)
	s Paadmdr=$g(Paadmdr)
	s tclscode=$g(tclscode)
	s tmrowid=$g(tmrowid)
	s rtn=""
	s:tmrowid=0 tmrowid=""
	
	if (tmrowid=""){
		i (Paadmdr="")||(tclscode="") q ""		
		i $o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,""))="" q rtn
		e  d
		.s tmrowid=0 f  s tmrowid=$o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,tmrowid)) q:tmrowid=""  d
		..s classDr=0 f  s classDr=$o(^DHCPISClassDicti("LOCCODE",Locdr,tclscode,classDr)) q:classDr=""  d
		...i (($p($g(^DHCPISTestMaster(tmrowid)),"^",11)=tclscode) && ($p($g(^DHCPISTestMaster(tmrowid)),"^",41)="")) d
		....s rtn=##Class(web.DHCPisApplicationSheet).GetWomenAllInfoByTmRowId(tmrowid)	
		}ElseIf (tmrowid'=""){
			s rtn=##Class(web.DHCPisApplicationSheet).GetWomenAllInfoByTmRowId(tmrowid)			
			}
	q rtn
}

// w ##Class(web.DHCPisAppJson).GetTumourInfo(105,10)

ClassMethod GetTumourInfo(Locdr As %String, Paadmdr As %String, tclscode As %String, TMrowid As %String) As %String
{
	s Locdr=$g(Locdr)
	s Paadmdr=$g(Paadmdr)
	s tclscode=$g(tclscode)
	s tmrowid=$g(TMrowid)
	s:tmrowid=0 tmrowid=""
	s rtn=""
	
	if (tmrowid=""){
			i (Paadmdr="")||(tclscode="") q ""		
			i $o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,""))="" q rtn
			e  d
			.s tmrowid=0 f  s tmrowid=$o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,tmrowid)) q:tmrowid=""  d
			..s classDr=0 f  s classDr=$o(^DHCPISClassDicti("LOCCODE",Locdr,tclscode,classDr)) q:classDr=""  d
			...i (($p($g(^DHCPISTestMaster(tmrowid)),"^",11)=tclscode) && ($p($g(^DHCPISTestMaster(tmrowid)),"^",41)="")) d
			....s rtn=##Class(web.DHCPisApplicationSheet).GetTumourInfoByTmRowId(tmrowid)
		}ElseIf (tmrowid'=""){
			s rtn=##Class(web.DHCPisApplicationSheet).GetTumourInfoByTmRowId(tmrowid)			
			}
	q rtn
}

// w ##Class(web.DHCPisAppJson).getDiagInfo("","67","10","")

ClassMethod getDiagInfo(Locdr As %String, Paadmdr As %String, tclscode As %String, TMrowid As %String) As %String
{
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
    s data=##class(Src.PIS3AppInterface).getDiagInfo(Locdr,Paadmdr,tclscode,TMrowid)
    d ##class(Src.PIS3Common).SetWebSourceNameSpace()
    q data
	/*
	s Locdr=$g(Locdr)
	s Paadmdr=$g(Paadmdr)
	s tclscode=$g(tclscode)
	s tmrowid=$g(TMrowid)
	
	s rtn=""
	s:tmrowid=0 tmrowid=""	
	if (tmrowid=""){	
		if Locdr'="" d	
		.i (Paadmdr="")||(tclscode="")  q 			
		.i $o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,""))="" q
		.e  d
		..s tmrowid=0 f  s tmrowid=$o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,tmrowid),-1) q:tmrowid=""  d
		...s classDr=0 f  s classDr=$o(^DHCPISClassDicti("LOCCODE",Locdr,tclscode,classDr)) q:classDr=""  d
		....i (($p($g(^DHCPISTestMaster(tmrowid)),"^",11)=tclscode) && (tclscode'="")) d
		.....i (($p($g(^DHCPISTestMaster(tmrowid)),"^",41)=""))	d
		......s rtn=##Class(web.DHCPisApplicationSheet).GetAppInfoByTmRowId(tmrowid)
		else  d			
		.i (Paadmdr="")||(tclscode="")  q 			
		.e  d			
		..f  s Locdr=$o(^DHCPISTestMasteri("LOC",Locdr),-1) q:Locdr=""   d	
		...i $o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,""))="" q		
		...s tmrowid=0 f  s tmrowid=$o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,tmrowid)) q:tmrowid=""  d	
		....s classDr=0 f  s classDr=$o(^DHCPISClassDicti("LOCCODE",Locdr,tclscode,classDr)) q:classDr=""  d	
		.....i (($p($g(^DHCPISTestMaster(tmrowid)),"^",11)=tclscode) && (tclscode'="")) d				
		......i (($p($g(^DHCPISTestMaster(tmrowid)),"^",41)=""))	d		
		.......s rtn=##Class(web.DHCPisApplicationSheet).GetAppInfoByTmRowId(tmrowid)
		}ElseIf (tmrowid'=""){
			s rtn=##Class(web.DHCPisApplicationSheet).GetAppInfoByTmRowId(tmrowid)
			}
	q rtn
	*/
}

// w ##Class(web.DHCPisAppJson).GetSpeInfo("1404",10,"65")

ClassMethod GetSpeInfo(Locdr As %String, Paadmdr As %String, tclscode As %String, TMrowid As %String) As %String
{
	s Locdr=$g(Locdr)
	s Paadmdr=$g(Paadmdr)
	s tclscode=$g(tclscode)
	s tmrowid=$g(TMrowid)
	;s ^TMP(29)=Locdr_"^"_Paadmdr_"^"_tclscode_"^"_TMrowid
	s:tmrowid=0 tmrowid=""
	s rtn="",data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	if (tmrowid=""){
			i (Paadmdr="")||(tclscode="") q ""			
			i $o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,""))="" q rtn
			e  d			
			.s tmrowid=0 f  s tmrowid=$o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,tmrowid)) q:tmrowid=""  d			
			..s classDr=0 f  s classDr=$o(^DHCPISClassDicti("LOCCODE",Locdr,tclscode,classDr)) q:classDr=""  d			
			...i (($p($g(^DHCPISTestMaster(tmrowid)),"^",11)=tclscode) && ($p($g(^DHCPISTestMaster(tmrowid)),"^",41)="")) d		
			....s child=0 f  s child=$o(^DHCPISTestMaster(tmrowid,"TS",child)) q:child=""  d
			.....i '$d(^DHCPISTestMaster(tmrowid,"TS",child)) q		
			.....s data=$p(^DHCPISTestMaster(tmrowid,"TS",child),"^",3)
			.....i rtn="" s rtn=data
			.....else  i rtn'=""  s rtn=rtn_"&"_data
		}ElseIf (tmrowid'=""){			
			s child=0 f  s child=$o(^DHCPISTestMaster(tmrowid,"TS",child)) q:child=""  d
			.i '$d(^DHCPISTestMaster(tmrowid,"TS",child)) q
			.s data=$p(^DHCPISTestMaster(tmrowid,"TS",child),"^",3)
			.i rtn="" s rtn=data
			.else  i rtn'=""  s rtn=rtn_"&"_data
			}
	d ##class(Src.PIS3Common).SetWebSourceNameSpace()
	q rtn
}

// w ##Class(web.DHCPisAppJson).GetSpeNum("4")

ClassMethod GetSpeNum(tmrowid As %String) As %String
{
	s tmrowid=$g(tmrowid)
	 s sum=0
	 d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	 s sum=##class(Src.PIS3AppInterface).GetSpeNum(tmrowid)
	 d ##class(Src.PIS3Common).SetWebSourceNameSpace()
	 q sum
	/*
	s tmrowid=$g(tmrowid)
	q:tmrowid="" -901
	s rtn="",rtnNum=""
	q:'$d(^DHCPISTestMaster(tmrowid)) -902
	s num=0 f  s num=$o(^DHCPISTestMaster(tmrowid,"TS",num)) q:num=""  d
	.s rtnNum=$p(^DHCPISTestMaster(tmrowid,"TS",num),"^",1)	
	s rtn=rtnNum+1
	q rtn
	*/
}

// w ##Class(web.DHCPisAppJson).InsertOrderItem(72,"10312||1^^5^","^^1^87^1^10312||1^^^^^^^^^^^N^^Y^^^^^^^N^^^^^^^^^^N^^^^^^^^N^^",105,6,1102)

// w ##Class(web.DHCPisAppJson).InsertOrderItem(72,"10312||1^^5^","^^1^87^1^^^^^^^^^^^1^N^^Y^^^^^^^N^^^^^^^^^^N^^^^^^^^N^^",105,6,1102)

// w ##Class(web.DHCPisAppJson).InsertOrderItem(318,"12114||1^^5^^^^1^87^1^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^",105,6,6,9842||1,87,1)

ClassMethod InsertOrderItem(adm As %String, OrdItemStr As %String, User As %String, AppLoc As %String, TMrowid As %String, INIid As %String, Locdr As %String, OrderNum As %String) As %String
{
	s CurrentNameSpace =$ZNSPACE
	s ^ttt=adm_"^"_User_"^"_AppLoc_"^"_TMrowid_"^"_INIid_"^"_OrderNum_"^"_Locdr 
	s pattype=$p(^PAADM(adm,1),"^",7) 	
	s orderitemDr=INIid
	s priceinfo=$$GetOrderPrice^DHCPRICE(pattype,"",orderitemDr,+$h,"","","","")
	s Price=$p(priceinfo,"^",1)
    s total=Price*OrderNum
	s flag=##class(web.DHCPisApplicationSheet).GetinibyLocdr(Locdr,INIid)
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	s INfo=adm_"^"_User_"^"_AppLoc_"^"_TMrowid_"^"_INIid_"^"_OrderNum_"^"_Locdr 
	if OrderNum=1 d
	.d ##class(Src.PIS3Interface).InsertOrdItems(.rtn,INfo)
	.d ##class(Src.PIS3Register).UpdateTmOrderDr(.data,rtn,TMrowid)	
	.d ##class(Src.PIS3Register).UpdateCost(.data,total,TMrowid)
	.d ##class(Src.PIS3Register).UpdateStatus(.data,1,TMrowid)
	.s rtn=$p(rtn,"^",1)
	
	else  if (OrderNum'=1)&(flag="1")  d
	.d ##class(Src.PIS3Interface).InsertOrdItems(.rtn,INfo)
	.s rtn=$p(rtn,"^",1)	
	.s OrderDr=$p(^DHCPISTestMaster(TMrowid),"^",32)
	.s rtnValue=OrderDr_"-"_rtn
	.d ##class(Src.PIS3Register).UpdateTmOrderDr(.data,rtnValue,TMrowid)
	.s totalprice=$p(^DHCPISTestMaster(TMrowid),"^",48)
	.s total=totalprice+total
	.d ##class(Src.PIS3Register).UpdateCost(.data,total,TMrowid)
	.d ##class(Src.PIS3Common).SetWebSourceNameSpace() 
	.s Ret=##class(web.DHCPisApplicationSheet).UpdateLinkOrd(OrderDr,rtn)	
	s $NAMESPACE=CurrentNameSpace
	q rtn
}

/*
ClassMethod InsertOrderItem(adm As %String, OrdItemStr As %String, User As %String, AppLoc As %String, TMrowid As %String, INIid As %String, Locdr As %String) As %String
{
	
	s adm=$g(adm)
	s OrdItemStr=$g(OrdItemStr)
	s User=$g(User)
	s AppLoc=$g(AppLoc)
	s TMrowid=$g(TMrowid)
	s INIid=$g(INIid)
	s Doc="" ,rtnValue="",pattype="",orderitemDr="",rscodedr="",tclscode="",tclscode2="",iniRowid="",iniInfo="",codeValue="",frostyn=0 ,iflag=0 , eflag=0
	s Doc=$P($g(^SSU("SSUSR",User)),"^",14)	
	s pattype=$p(^PAADM(adm,1),"^",7) 	
	s orderitemDr=INIid
	s priceinfo=$$GetOrderPrice^DHCPRICE(pattype,"",orderitemDr,+$h,"","","","")
	s Price=$p(priceinfo,"^",1)
    s total=Price*1
	s tclscode=$p(^DHCPISTestMaster(TMrowid),"^",11)
	s Dept=$p(^DHCPISTestMaster(TMrowid),"^",57)	
	
	s $p(OrdItemStr,"^",1)=INIid	
	s $p(OrdItemStr,"^",3)=$O(^OECPR(0,"Code","NORM",0))
	s $p(OrdItemStr,"^",4)=$zd($p($h,",",1),4)
	s $p(OrdItemStr,"^",5)=$zt($p($h,",",2),2)
	s $p(OrdItemStr,"^",7)=total		
	s $p(OrdItemStr,"^",8)=Locdr
	s $p(OrdItemStr,"^",9)=pattype
	s $p(OrdItemStr,"^",20)=1
	s ^orderPrice(0)=OrdItemStr
	s ^orderPrice(2)=total
	s ^orderPrice(3)=orderitemDr_"^"_priceinfo
	
	ts
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()	
	s rtn=##class(Src.DPIS3InInterface).SaveOrderItems(adm,OrdItemStr,User,AppLoc,Doc) //调用公司接口，插入医嘱
 	
	i (rtn="0" || rtn="-999") TRollback  q rtn
	tc
	
	s rtnValue=$p(rtn,"*",2)	
	s data=""	
	s BillInfo=TMrowid_"^"_rtnValue_"^"_"1"_"^"_Price_"^"_total_"^"_AppLoc_"^^^^^1^^"_INIid
	d ##class(Src.PIS3Register).UpdateTmOrderDr(.data,rtnValue,TMrowid)	
	d ##class(Src.PIS3Register).UpdateCost(.data,total,TMrowid)
	d ##class(Src.PIS3Register).UpdateStatus(.data,1,TMrowid)
	d ##class(Src.PIS3Register).BillItemAdd(.data,BillInfo)
	d ##class(Src.PIS3Common).SetWebSourceNameSpace() 
	
	q rtnValue
}*/

// w ##Class(web.DHCPisAppJson).getloc("601","10273||1")

ClassMethod getloc(adm As %String, IniId As %String) As %String
{
	s ^tmp("3###3")=adm_IniId
	s LOcdr="",locString=""
	s adm=$g(adm)
	s IniId=$g(IniId)
	s Loc=$$GetRecloc^DHCDocOrderCommonNew(adm,IniId)
	q Loc
}

ClassMethod GetRecLoc() As %String
{
}

// w ##Class(web.DHCPisAppJson).GetSpecimenOtherDate(35,10,"")

ClassMethod GetSpecimenOtherDate(Paadmdr As %String, tclscode As %String, TMrowid As %String) As %String
{
	s Paadmdr=$g(Paadmdr)
	s tclscode=$g(tclscode)
	s tmrowid=$g(TMrowid)
	s:tmrowid=0 tmrowid=""
	s rtnValue=""
	if (tmrowid=""){
		i (Paadmdr="")||(tclscode="") q ""
		;s LocDR=$o(^CTLOC(0,"Desc","BLK病理科",""))
		s sysid="" f  s sysid=$o(^User.DHCPISSYSTEMSETD(sysid))  q:sysid=""  d
	    .i '$d(^User.DHCPISSYSTEMSETD(sysid)) q
	    .d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	    .s sysInfo=##class(User.DHCPISSYSTEMSET).%OpenId(sysid)
	    .s Locdr=sysInfo.SYSDEPTCODE
	    .d ##class(Src.PIS3Common).SetWebSourceNameSpace()  
	    .q:LocDR=""
		i $o(^DHCPISTestMasteri("PAADM",LocDR,Paadmdr,""))="" q ""  //不存在此记录，返回空
		s rtnValue="",speExsomatizeDate="",speExsomatizeTime="",beginFixDate="",beginFixTime=""
		s tmpValue="" 
		s tmrowid=0 f  s tmrowid=$o(^DHCPISTestMasteri("PAADM",LocDR,Paadmdr,tmrowid)) q:tmrowid=""  d	
		.s classDr=0 f  s classDr=$o(^DHCPISClassDicti("LOCCODE",LocDR,tclscode,classDr)) q:classDr=""  d
		..i (($p($g(^DHCPISTestMaster(tmrowid)),"^",11)=tclscode) && ($p($g(^DHCPISTestMaster(tmrowid)),"^",41)="")) d
		...s timeInfo="" f  s timeInfo=$o(^DHCPISTestMaster(tmrowid,"TS",timeInfo)) q:(timeInfo="")  d	
		....s info=$g(^DHCPISTestMaster(tmrowid,"TS",timeInfo))		
		....i $p(info,"^",21)'="" s speExsomatizeDate=$zd($p(info,"^",21),3)
		....i $p(info,"^",22)'="" s speExsomatizeTime=$zt($p(info,"^",22))
		....i $p(info,"^",23)'="" s beginFixDate=$zd($p(info,"^",23),3)
		....i $p(info,"^",24)'="" s beginFixTime=$zt($p(info,"^",24))
		....s rtnValue=speExsomatizeDate_"^"_speExsomatizeTime_"^"_beginFixDate_"^"_beginFixTime
		}ElseIf (tmrowid'=""){
			s rtnValue="",speExsomatizeDate="",speExsomatizeTime="",beginFixDate="",beginFixTime=""
			s timeInfo="" f  s timeInfo=$o(^DHCPISTestMaster(tmrowid,"TS",timeInfo)) q:(timeInfo="")  d
			.s info=$g(^DHCPISTestMaster(tmrowid,"TS",timeInfo))
			.i $p(info,"^",21)'="" s speExsomatizeDate=$zd($p(info,"^",21),3)
			.i $p(info,"^",22)'="" s speExsomatizeTime=$zt($p(info,"^",22))
			.i $p(info,"^",23)'="" s beginFixDate=$zd($p(info,"^",23),3)
			.i $p(info,"^",24)'="" s beginFixTime=$zt($p(info,"^",24))
			.s rtnValue=speExsomatizeDate_"^"_speExsomatizeTime_"^"_beginFixDate_"^"_beginFixTime
			}
	q rtnValue
}

// s iniRowid=0 f  s iniRowid=$o(^DHCPISIniDict("")) q:iniRowid=""  d

// w ##Class(web.DHCPisAppJson).test(72)

ClassMethod test(Paadmdr As %String) As %String
{
	s wuliao=$g(Paadmdr)
	s iflag=0 , eflag=0 ,tclscode=10
	s iniRowid=0 f  s iniRowid=$o(^DHCPISIniDict(iniRowid)) q:iniRowid=""  d
	.s iflag=iflag+1
	.s iniInfo=$p(^DHCPISIniDict(iniRowid),"^",3)
	.s codeValue=$p(iniInfo,";",1)
	.i codeValue=tclscode d
	..s $p(OrdItemStr,"^",1)=$p(^DHCPISIniDict(iniRowid),"^",4)
	.e  s eflag=eflag+1
	q:iflag=eflag "Get orderItemDR failed ,pls check this"
	
	
	
	q wuliao
}

ClassMethod EvalJSON(instr As %String) As %String
{
	;w ##class(ext.util.String).EvalJSON("a\")
	s mystr = instr
	
	q:(mystr="") mystr
	
	s mystr = ..Replace(mystr,"\", "\\")
	
	s mystr = ..Replace(mystr,"'", "\'")
	
	s mystr = ..Replace(mystr,$c(13), "")
	
	s mystr = ..Replace(mystr,$c(10), "")
	
	q mystr
}

/// 要求被替换的内容不能=""
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	;
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

// w ##class(web.DHCPisAppJson).GetOrder(50,"","","I")

ClassMethod GetOrder(tclscode As %String, OrderCode As %String, Dept As %String, Ptype As %String) As %String
{
	
	s hospitalID=%session.Get("LOGON.HOSPID")
	s ^te0630("0630")=tclscode_"^"_Ptype
	//s hospitalID=2	
   	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	Set result = ##class(%ResultSet).%New()
    Set result.ClassName = "Src.PIS3LocInit"
    Set result.QueryName = "QueryInidictByCode"
    s count="" 
    s OrderInfo=Dept_"^"_OrderCode_"^"_""  
    Do result.Execute(.count,-1,-1,"ASC",OrderInfo) 
         
    s count = 0	
 	//构造json数据
 	s resultString="{rows:["
 	while(result.Next())
 	{
	 s code=$P(result.Data("INID_NAME"),";",1) 
	 s PatientType=$P(result.Data("INID_NAME"),";",2)
	 s bak=$P(result.Data("INID_NAME"),";",4)
	 continue:((hospitalID'="")&&(hospitalID'=bak)) 	
	 i (code=tclscode)&(PatientType[Ptype) d
	 .s NAME=$P(result.Data("INID_NAME"),";",3)  //取数据		
	 .s VALUE=result.Data("INID_VALUE")  //取数据	 
	 .s tmp="{NAME"_":"_"'"_..EvalJSON(NAME)_"'"_","_"VALUE"_":"_"'"_VALUE_"'"_"}" 
	 .i resultString = "{rows:[" d
	 ..s resultString = resultString_tmp
	 .e  d
	 ..s resultString = resultString_","_tmp
					
	 .s count=count+1	
	}	
	 d result.Close()
	s resultString = resultString_"]}"
	d ##class(Src.PIS3Common).SetWebSourceNameSpace()   
	q resultString  	//返回数据
}

// w ##class(web.DHCPisAppJson).GetQuCaiLoc()

ClassMethod GetQuCaiLoc() As %String
{
	
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	Set result = ##class(%ResultSet).%New()
    Set result.ClassName = "Src.DPIS3InInterface"
    Set result.QueryName = "QueryHISLoc"
    Do result.Execute("","")
    s count = 0	
    s hospitalID=%session.Get("LOGON.HOSPID")
    //s hospitalID="2"
    
 	//构造json数据
 	s resultString="{rows:["
 	while(result.Next())
 	{ 
 	 if (hospitalID=""){
 	 f  s hospitalID=$o(^CTLOC(0,"Hosp",hospitalID)) 	q:hospitalID=""  d 
 	 .s Locdr=""  f  s Locdr=$o(^CTLOC(0,"Hosp",hospitalID,Locdr)) q:Locdr=""  d
	 ..s NAME=result.Data("DEPT_NAME")  //取数据
	 ..s ID=result.Data("ID")  //取数据
	 ..q:Locdr'=ID 
	 ..s tmp="{NAME"_":"_"'"_..EvalJSON(NAME)_"'"_","_"ID"_":"_"'"_ID_"'"_"}"	
	 ..i resultString = "{rows:[" d
	 ...s resultString = resultString_tmp
	 ..e  d
	 ...s resultString = resultString_","_tmp
					
	 ..s count=count+1	
	 }
	 else
	 {
	 continue:'$d(^CTLOC(0,"Hosp",hospitalID)) 	
 	 s Locdr=""  f  s Locdr=$o(^CTLOC(0,"Hosp",hospitalID,Locdr)) q:Locdr=""  d
	 .s NAME=result.Data("DEPT_NAME")  //取数据
	 .s ID=result.Data("ID")  //取数据	
	 .q:Locdr'=ID 
	 .s tmp="{NAME"_":"_"'"_..EvalJSON(NAME)_"'"_","_"ID"_":"_"'"_ID_"'"_"}"	
	 .i resultString = "{rows:[" d
	 ..s resultString = resultString_tmp
	 .e  d
	 ..s resultString = resultString_","_tmp					
	 .s count=count+1
		}
	}
 
    d result.Close()
	s resultString = resultString_"]}"
	d ##class(Src.PIS3Common).SetWebSourceNameSpace()   
	q resultString 	//返回数据
}

/*ClassMethod GetQuCaiLoc() As %String
{
	
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	Set result = ##class(%ResultSet).%New()
    Set result.ClassName = "Src.DPIS3InInterface"
    Set result.QueryName = "QueryHISLoc"
    Do result.Execute("","")
    s count = 0	
 	//构造json数据
 	s resultString="{rows:["
 	while(result.Next())
 	{
	 s NAME=result.Data("DEPT_NAME")  //取数据
	 s ID=result.Data("ID")  //取数据	 
	 s tmp="{NAME"_":"_"'"_..EvalJSON(NAME)_"'"_","_"ID"_":"_"'"_ID_"'"_"}" 
	 i resultString = "{rows:[" d
	 .s resultString = resultString_tmp
	 e  d
	 .s resultString = resultString_","_tmp
					
	 s count=count+1	
	}
    d result.Close()
	s resultString = resultString_"]}"
	d ##class(Src.PIS3Common).SetWebSourceNameSpace()   
	q resultString 	//返回数据
}*/

// w ##class(web.DHCPisAppJson).GetQuCaiDoc("6")

ClassMethod GetQuCaiDoc(Locrowid As %String) As %String
{
	s ^test=Locrowid
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	Set result = ##class(%ResultSet).%New()
    Set result.ClassName = "Src.DPIS3InInterface"
    Set result.QueryName = "QueryHISUser"
    Do result.Execute(Locrowid)
    s count = 0	
 	//构造json数据
 	s resultString="{rows:["
 	while(result.Next())
 	{
	 s NAME=result.Data("USER_NAME")  //取数据
	 s CODE=result.Data("USER_CODE")  //取数据	 
	 s tmp="{NAME"_":"_"'"_..EvalJSON(NAME)_"'"_","_"CODE"_":"_"'"_CODE_"'"_"}" 
	 i resultString = "{rows:[" d
	 .s resultString = resultString_tmp
	 e  d
	 .s resultString = resultString_","_tmp
					
	 s count=count+1	
	}
    d result.Close()
	s resultString = resultString_"]}"
	d ##class(Src.PIS3Common).SetWebSourceNameSpace()   
	q resultString 	//返回数据
}

// 查询标本交接记录

// w ##class(web.DHCPisAppJson).GetRecSpeR("87^2014-08-27^2014-08-27^^^87")

/*
ClassMethod GetRecSpeR(info As %String) As %String
{
	 s info=$g(info)	
  	 s dept=$p(info,"^",1)
  	 q:dept="" $$$OK  	 	  
  	 s startDate=$p(info,"^",2)
  	 s endDate=$p(info,"^",3)
  	 i startDate="" d
  	 .s startDate=+$h
  	 else  d
  	 .s startDate=$zdh(startDate,3) 
  	 i endDate="" d
	 .s endDate=+$h
	 else  d
	 .s endDate=$zdh(endDate,3)
	 s AppHandLoc=$p(info,"^",4)
	 s RecStatus=$p(info,"^",5)
	  s Info="{RecSperR:[",PatName="",PSexDr="",statusDesc="",SpeRecLoc="",SpeRecDesc=""
	  s ADept="",BirthDate="",count=0,VrId="",VrDesc=""
  		
 	 i startDate'="" d  	  
     .f prtdate=startDate:1:endDate  d        
	 ..s tmid=0 f  s tmid=$o(^DHCPISTestMasteri("APPDATE",dept,prtdate,tmid)) q:tmid=""  d
	 ...i '$d(^DHCPISTestMaster(tmid)) q	
	 ...s tmInfo=^DHCPISTestMaster(tmid)
	 ...s VrDate="",VrTime="",VrRecDoc="",VrProDoc=""		
	 ...s SpeRecLoc=$p(tmInfo,"^",22)
	 ...s PatName=$p(tmInfo,"^",14) 
	 ...s PSexDr=$p(tmInfo,"^",17)
	 ...i PSexDr'="" s PSexDr=##class(web.DHCPisApplicationSheet).GetSexDescByCode(PSexDr)
	 ...s BirthDate=$p(tmInfo,"^",18)
	 ...i BirthDate'="" s BirthDate=$zd(BirthDate,3)	 
	 ...q:(SpeRecLoc'="")&&(AppHandLoc'=SpeRecLoc)	
	 ...i SpeRecLoc'="" s SpeRecDesc=$p(##class(web.DHCPisApplicationSheet).GetLocName(SpeRecLoc),"-",2) 		
	 ...s child=0  s child=$o(^DHCPISTestMaster(tmid,"TS",child)) q:(child="") 	 	 	 
	 ...q:'$d(^DHCPISTestMaster(tmid,"TS",child))	 
	 ...s VrId=$p(^DHCPISTestMaster(tmid,"TS",child),"^",12)  q:(((VrId'="")&&(RecStatus=1))||((VrId="")&&(RecStatus=2)))   //q:(((VrId="")&&(RecStatus'=""))||((VrId'="")&&(RecStatus=""))) 只区分"未接收"和"已接收"，两者不能同时包含	
	 ...i VrId'="" d
	 ....q:'$d(^DHCPISVerifyRecord(VrId))	 	
	 ....s vrInfo=^DHCPISVerifyRecord(VrId)
	 ....s ADept=$p(vrInfo,"^",1)
	 ....s VrType=$p(vrInfo,"^",2)
	 ....q:VrType'="01"
	 ....s VrDate=$p(vrInfo,"^",3)
	 ....i VrDate '="" s VrDate=$zd(VrDate,3)
	 ....s VrTime=$p(vrInfo,"^",4)
	 ....i VrTime'="" s VrTime=$zt(VrTime,1)
	 ....s VrRecDoc=$p(vrInfo,"^",5)
	 ....s VrProDoc=$p(vrInfo,"^",6)
	 ...s count=count+1	
	 ...i VrId'="" s VrDesc="已交接"
	 ...e  s VrDesc="未交接"
	 ...i ($e(Info,$l(Info))="[") d
     ....s Info=Info_"{tmrowid:'"_tmid_"',Pname:'"_PatName_"',Sex:'"_PSexDr_"',Birthdate:'"_BirthDate_"',statusDesc:'"_VrDesc_"',appLocDR:'"_SpeRecDesc_"',appHandDoc:'"_VrRecDoc_"',RecDoc:'"_VrProDoc_"',RecDate:'"_VrDate_"',RecTime:'"_VrTime_"',leaf:false}"
     ...e  d
     ....s Info=Info_",{tmrowid:'"_tmid_"',Pname:'"_PatName_"',Sex:'"_PSexDr_"',Birthdate:'"_BirthDate_"',statusDesc:'"_VrDesc_"',appLocDR:'"_SpeRecDesc_"',appHandDoc:'"_VrRecDoc_"',RecDoc:'"_VrProDoc_"',RecDate:'"_VrDate_"',RecTime:'"_VrTime_"',leaf:false}"
     i count=0 s count=1	 
     s Info=Info_"],results:"_count_"}"
     i Info="{RecSperR:[" s Info="{RecSperR:[]}"    
     q Info
}*/

// w ##class(web.DHCPisAppJson).GetRecSpeR("87^2014-08-24^2014-08-25^6^^6")

/*
ClassMethod GetRecSpeR(info As %String) As %String
{
	 s info=$g(info)	
  	 s dept=$p(info,"^",1)
  	 q:dept="" $$$OK  	 	  
  	 s startDate=$p(info,"^",2)
  	 s endDate=$p(info,"^",3)
  	 i startDate="" d
  	 .s startDate=+$h
  	 else  d
  	 .s startDate=$zdh(startDate,3) 
  	 i endDate="" d
	 .s endDate=+$h
	 else  d
	 .s endDate=$zdh(endDate,3)
	 s AppHandLoc=$p(info,"^",4)
	 s RecStatus=$p(info,"^",5)
	 s AppLocDr=$p(info,"^",6)
	  s Info="{RecSperR:[",PatName="",PSexDr="",statusDesc="",SpeRecLoc="",SpeRecDesc=""
	  s ADept="",BirthDate="",count=0,VrId="",VrDesc=""
  		
 	 i startDate'="" d  	  
     .f prtdate=startDate:1:endDate  d        
	 ..s tmid=0 f  s tmid=$o(^DHCPISTestMasteri("APPDATE",dept,prtdate,tmid)) q:tmid=""  d
	 ...i '$d(^DHCPISTestMaster(tmid)) q	
	 ...s tmInfo=^DHCPISTestMaster(tmid)	
	 ...s VrDate="",VrTime="",VrRecDoc="",VrProDoc="",memo="",SpeRecLoc="",VrDesc=""		
	 ...s SpeRecLoc=$p(tmInfo,"^",22)
	 ...q:SpeRecLoc=""
	 ...s PatName=$p(tmInfo,"^",14) 
	 ...s PSexDr=$p(tmInfo,"^",17)
	 ...i PSexDr'="" s PSexDr=##class(web.DHCPisApplicationSheet).GetSexDescByCode(PSexDr)
	 ...s BirthDate=$p(tmInfo,"^",18)
	 ...i BirthDate'="" s BirthDate=$zd(BirthDate,3)	
	 ...i (SpeRecLoc'="")&&(AppLocDr=SpeRecLoc) d		//手术室查询	
	 ....i SpeRecLoc'="" s SpeRecDesc=$p(##class(web.DHCPisApplicationSheet).GetLocName(SpeRecLoc),"-",2) 		
	 ....s child=0  s child=$o(^DHCPISTestMaster(tmid,"TS",child)) q:(child="") 	 	 	 
	 ....q:'$d(^DHCPISTestMaster(tmid,"TS",child))	
	 ....s VrId=$p(^DHCPISTestMaster(tmid,"TS",child),"^",12)   q:(((VrId'="")&&(RecStatus=1))||((VrId="")&&(RecStatus=2)))   //q:(((VrId="")&&(RecStatus'=""))||((VrId'="")&&(RecStatus=""))) 只区分"未接收"和"已接收"，两者不能同时包含	
	 ....i VrId'="" d
	 .....q:'$d(^DHCPISVerifyRecord(VrId))	 	
	 .....s vrInfo=^DHCPISVerifyRecord(VrId)
	 .....s ADept=$p(vrInfo,"^",1)
	 .....s VrType=$p(vrInfo,"^",2)
	 .....q:VrType'="01"
	 .....s VrDate=$p(vrInfo,"^",3)
	 .....i VrDate '="" s VrDate=$zd(VrDate,3)
	 .....s VrTime=$p(vrInfo,"^",4)
	 .....i VrTime'="" s VrTime=$zt(VrTime,1)
	 .....s VrRecDoc=$p(vrInfo,"^",5)
	 .....s VrProDoc=$p(vrInfo,"^",6)
	 .....s memo=$p(vrInfo,"^",7)
	 ....s count=count+1		
	 ....i VrId'="" s VrDesc="已交接"
	 ....e  s VrDesc="未交接"	 	 
	 ....i ($e(Info,$l(Info))="[") d
     .....s Info=Info_"{tmrowid:'"_tmid_"',Pname:'"_PatName_"',Sex:'"_PSexDr_"',Birthdate:'"_BirthDate_"',statusDesc:'"_VrDesc_"',appLocDR:'"_SpeRecDesc_"',appHandDoc:'"_VrRecDoc_"',RecDoc:'"_VrProDoc_"',RecDate:'"_VrDate_"',RecTime:'"_VrTime_"',memo:'"_memo_"',leaf:false}"
     ....e  d
     .....s Info=Info_",{tmrowid:'"_tmid_"',Pname:'"_PatName_"',Sex:'"_PSexDr_"',Birthdate:'"_BirthDate_"',statusDesc:'"_VrDesc_"',appLocDR:'"_SpeRecDesc_"',appHandDoc:'"_VrRecDoc_"',RecDoc:'"_VrProDoc_"',RecDate:'"_VrDate_"',RecTime:'"_VrTime_"',memo:'"_memo_"',leaf:false}"
     
     
     ...else  i (SpeRecLoc'="")&&(AppLocDr'=SpeRecLoc) d  //病理科查询界面	
	 ....i SpeRecLoc'="" s SpeRecDesc=$p(##class(web.DHCPisApplicationSheet).GetLocName(SpeRecLoc),"-",2) 		
	 ....s child=0  s child=$o(^DHCPISTestMaster(tmid,"TS",child)) q:(child="") 	 	 	 
	 ....q:'$d(^DHCPISTestMaster(tmid,"TS",child))	
	 ....s VrId=$p(^DHCPISTestMaster(tmid,"TS",child),"^",12)   q:VrId=""
	 ....i VrId'="" d
	 .....q:'$d(^DHCPISVerifyRecord(VrId))	 	
	 .....s vrInfo=^DHCPISVerifyRecord(VrId)
	 .....s ADept=$p(vrInfo,"^",1)
	 .....s VrType=$p(vrInfo,"^",2)
	 .....q:VrType'="01"
	 .....s VrDate=$p(vrInfo,"^",3)
	 .....i VrDate '="" s VrDate=$zd(VrDate,3)
	 .....s VrTime=$p(vrInfo,"^",4)
	 .....i VrTime'="" s VrTime=$zt(VrTime,1)
	 .....s VrRecDoc=$p(vrInfo,"^",5)
	 .....s VrProDoc=$p(vrInfo,"^",6)
	 .....s memo=$p(vrInfo,"^",7)	 
	 ....q:(((memo'="")&&(RecStatus=1))||((memo="")&&(RecStatus=2)))
	 ....s count=count+1		
	 ....i memo'="" s VrDesc="已交接"
	 ....e  s VrDesc="未交接"
	 ....i ($e(Info,$l(Info))="[") d
     .....s Info=Info_"{tmrowid:'"_tmid_"',Pname:'"_PatName_"',Sex:'"_PSexDr_"',Birthdate:'"_BirthDate_"',statusDesc:'"_VrDesc_"',appLocDR:'"_SpeRecDesc_"',appHandDoc:'"_VrRecDoc_"',RecDoc:'"_VrProDoc_"',RecDate:'"_VrDate_"',RecTime:'"_VrTime_"',memo:'"_memo_"',leaf:false}"
     ....e  d
     .....s Info=Info_",{tmrowid:'"_tmid_"',Pname:'"_PatName_"',Sex:'"_PSexDr_"',Birthdate:'"_BirthDate_"',statusDesc:'"_VrDesc_"',appLocDR:'"_SpeRecDesc_"',appHandDoc:'"_VrRecDoc_"',RecDoc:'"_VrProDoc_"',RecDate:'"_VrDate_"',RecTime:'"_VrTime_"',memo:'"_memo_"',leaf:false}"
     
     i count=0 s count=1	 
     s Info=Info_"],results:"_count_"}"
     i Info="{RecSperR:[" s Info="{RecSperR:[]}"    
     q Info
}*/

// w ##Class(web.DHCPisAppJson).GetAppItemsByBtDateAndIpno("^2015-5-19^2015-5-19^")

ClassMethod GetAppItemsByBtDateAndIpno(serch As %String) As %String
{
	s ^temp20150519=serch
    s AppLoc=$p(serch,"^",1)
	s StartDate=$p(serch,"^",2)	
	s EndDate=$p(serch,"^",3)	 
	s ipno=$p(serch,"^",4)
    i StartDate'="" d
    .s StartDate=$zdh(StartDate,3)
    i EndDate="" d
    .s EndDate=+$h
    else  d
    .s EndDate=$zdh(EndDate,3)	
	i ipno'="" d	    
    .s Info="{AppItems:[" ,Pname="",status="",statusDesc="",appDate="",appTime="",appLocDR="",Ipno="",tempLocDr="",i=0
	.s Locdr=0 f  s Locdr=+$o(^DHCPISTestMasteri("LOC",Locdr)) q:Locdr=0  d	
	..i i=0 s tempLocDr=Locdr
    ..i ((i>0)&(tempLocDr=Locdr)) q
    ..s i=i+1
	..s tmrowid="" f  s tmrowid=$o(^DHCPISTestMasteri("IPNO",Locdr,ipno,tmrowid)) q:tmrowid=""  d
	...i '$d(^DHCPISTestMaster(tmrowid))  q
	...s tmInfo=^DHCPISTestMaster(tmrowid)
	...s Ipno=$p(tmInfo,"^",33)
	...i (ipno'="")&(ipno'=Ipno) q 
	...s Pname=$p(tmInfo,"^",14)
	...s appDate=$zd($p(tmInfo,"^",26),3)
	...s appTime=$zt($p(tmInfo,"^",27),2)
	...s appLocDR=$p(tmInfo,"^",29)
	...i ((AppLoc'="")&(AppLoc'=appLocDR)) q
	...i appLocDR'="" s appLocDR=##class(web.DHCPisApplicationSheet).GetLocName(appLocDR)
	...s status=$p(tmInfo,"^",41)	
	...i status'="" d 
	....s statusRowid="" f  s statusRowid=$O(^DHCPISResultStatusi("CODE",status,statusRowid)) q:statusRowid=""  d
	.....s statusDesc=$p($g(^DHCPISResultStatus(statusRowid)),"^",2)
	...i ($e(Info,$l(Info))="[") d
	....s Info=Info_"{Pname:'"_Pname_"',tmrowid:'"_tmrowid_"',statusDesc:'"_statusDesc_"',appDate:'"_appDate_"',appTime:'"_appTime_"',appLocDR:'"_appLocDR_"',Ipno:'"_Ipno_"'}"
	...e  d
	....s Info=Info_",{Pname:'"_Pname_"',tmrowid:'"_tmrowid_"',statusDesc:'"_statusDesc_"',appDate:'"_appDate_"',appTime:'"_appTime_"',appLocDR:'"_appLocDR_"',Ipno:'"_Ipno_"'}"
	else  d
	.s Info="{AppItems:[" ,Pname="",status="",statusDesc="",appDate="",appTime="",appLocDR="",Ipno="",tempLocDr="",i=0
	.s Locdr=0 f  s Locdr=$o(^DHCPISTestMasteri("LOC",Locdr)) q:Locdr=""  d
    ..i i=0 s tempLocDr=Locdr
    ..i ((i>0)&(tempLocDr=Locdr)) q
    ..s i=i+1
	..f SDate=StartDate:1:EndDate d	
	...s tmrowid=0 f  s tmrowid=$o(^DHCPISTestMasteri("APPDATE",Locdr,SDate,tmrowid)) q:tmrowid=""  d
	....i '$d(^DHCPISTestMaster(tmrowid))  q
	....s tmInfo=^DHCPISTestMaster(tmrowid)
	....s Ipno=$p(tmInfo,"^",33)

	....i ((ipno'="")&(ipno'=Ipno)) q 
  
	....s Pname=$p(tmInfo,"^",14)  
	....s appDate=$zd($p(tmInfo,"^",26),3)
	....s appTime=$zt($p(tmInfo,"^",27),2)
	....s appLocDR=$p(tmInfo,"^",29)

	....i ((AppLoc'="")&&(AppLoc'=appLocDR)) q

	....i appLocDR'="" s appLocDR=##class(web.DHCPisApplicationSheet).GetLocName(appLocDR)
	....s status=$p(tmInfo,"^",41)	
	....i status'="" d 
	.....s statusRowid="" f  s statusRowid=$O(^DHCPISResultStatusi("CODE",status,statusRowid)) q:statusRowid=""  d
	......s statusDesc=$p($g(^DHCPISResultStatus(statusRowid)),"^",2)
	....i ($e(Info,$l(Info))="[") d
	.....s Info=Info_"{Pname:'"_Pname_"',tmrowid:'"_tmrowid_"',statusDesc:'"_statusDesc_"',appDate:'"_appDate_"',appTime:'"_appTime_"',appLocDR:'"_appLocDR_"',Ipno:'"_Ipno_"'}"
	....e  d
	.....s Info=Info_",{Pname:'"_Pname_"',tmrowid:'"_tmrowid_"',statusDesc:'"_statusDesc_"',appDate:'"_appDate_"',appTime:'"_appTime_"',appLocDR:'"_appLocDR_"',Ipno:'"_Ipno_"'}"
	s Info=Info_"]}"
	i Info="{AppItems:["  s Info="{AppItems:[]}"
	q Info
}

// w ##class(web.DHCPisAppJson).GetRecDept()

ClassMethod GetRecDept(tclscode As %String) As %String
{
	
	s hospitalID=%session.Get("LOGON.HOSPID")	
	//s hospitalID=2
   	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	Set result = ##class(%ResultSet).%New()
    Set result.ClassName = "Src.PIS3SystemInit"
    Set result.QueryName = "QueryGetSystem"
    s count=""     
    Do result.Execute(.count,-1,-1,"ASC","^") 
         
    s count = 0	
 	//构造json数据
 	s resultString="{rows:["
 	while(result.Next())
 	{
	
	 s hsID=result.Data("SYS_AUTHORIZED_KEY")	
	 continue:((hospitalID'="")&&(hospitalID'=hsID)) 
	 s VALUE=result.Data("SYS_DEPT_CODE"),NAME=""	
	 d ##class(Src.PIS3SystemInit).GetLocNameByCode(.NAME,VALUE)
	 s NAME=$p(NAME,"*",1)	 
	
	 s tmp="{NAME"_":"_"'"_..EvalJSON(NAME)_"'"_","_"VALUE"_":"_"'"_VALUE_"'"_"}" 
	 i resultString = "{rows:[" d
	 .s resultString = resultString_tmp
	 e  d
	 .s resultString = resultString_","_tmp
					
	 s count=count+1	
	}	
	 d result.Close()
	s resultString = resultString_"]}"
	d ##class(Src.PIS3Common).SetWebSourceNameSpace()   
	q resultString  	//返回数据
}

// w ##class(web.DHCPisAppJson).Getcharge()

ClassMethod Getcharge() As %String
{
	
 	//构造json数据
 	s resultString="{rows:["
 	s i=1
 	f i=1:1:3 d
 	.s NAME="自费"_""_i
 	.s VALUE=i+1
    .s tmp="{NAME"_":"_"'"_..EvalJSON(NAME)_"'"_","_"VALUE"_":"_"'"_VALUE_"'"_"}" 
	.i resultString = "{rows:[" d
	..s resultString = resultString_tmp
	.e  d
	..s resultString = resultString_","_tmp
	s resultString = resultString_"]}" 
	q resultString  	//返回数据
}

// syl新增修改医嘱状态20160206

// w ##class(web.DHCPisAppJson).updateOrderstate(60,"78||1")

ClassMethod updateOrderstate(TMrowid As %String, OrderId As %String) As %String
{
	s TMrowid=$g(TMrowid)
	s OrderId=$g(OrderId)
	s ^temp28=TMrowid_"^"_OrderId	
	s data=""
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()	
	d ##class(Src.PIS3Register).UpdateTmOrderDr(.sqlcode,OrderId,TMrowid)
	s data=sqlcode
	
	d ##class(Src.PIS3Register).UpdateStatus(.sqlcode,"1",TMrowid)
	d ##class(Src.PIS3Common).SetWebSourceNameSpace()
	q data
}

// ------------------------------------开始-SYL标本交接类方法增加区域请勿在此区域CRUD方法-------------------------------------

// w ##class(web.DHCPisAppJson).GetReceiveLoc()

ClassMethod GetReceiveLoc() As %String
{
	
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	Set result = ##class(%ResultSet).%New()
    Set result.ClassName = "Src.PIS3SystemInit"
    Set result.QueryName = "QueryGetSystem"
    Do result.Execute(.data,"-1","-1","ASC","^")  
    s count = 0	
 	//构造json数据
 	s resultString="{rows:["
 	while(result.Next())
 	{
	 s ID=result.Data("SYS_DEPT_CODE")  //取数据	 
	 d ##class(Src.DPIS3InInterface).GetLocName(.data,ID)	
	 s NAME=$p(data,"*")	 
	 s tmp="{NAME"_":"_"'"_..EvalJSON(NAME)_"'"_","_"ID"_":"_"'"_ID_"'"_"}" 
	 i resultString = "{rows:[" d
	 .s resultString = resultString_tmp
	 e  d
	 .s resultString = resultString_","_tmp
					
	 s count=count+1	
	}
    d result.Close()
	s resultString = resultString_"]}"
	d ##class(Src.PIS3Common).SetWebSourceNameSpace()   
	q resultString 	//返回数据
}

// w ##class(web.DHCPisAppJson).GetQuCaiLoc()

ClassMethod GetQuCaiLoc1() As %String
{
	
	d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	Set result = ##class(%ResultSet).%New()
    Set result.ClassName = "Src.DPIS3InInterface"
    Set result.QueryName = "QueryHISLoc"
    Do result.Execute("","")
    s count = 0
    
 	//构造json数据
 	s resultString="{rows:["
 	while(result.Next())
 	{
 	  s rowid=0  f  s rowid=$o(^CT("LL",rowid))  q:rowid=""  d
 	  .s child=0  f  s child=$o(^CT("LL",rowid,"LOC",child)) q:child=""  d
 	  ..s locdr=$p(^CT("LL",rowid,"LOC",child),"^",1)
 	  ..s ID=result.Data("ID") 
 	  ..q:locdr'=ID  	
 	  ..s NAME=result.Data("DEPT_NAME")  //取数据
	  ..s ID=result.Data("ID")  //取数据	 
	  ..s tmp="{NAME"_":"_"'"_..EvalJSON(NAME)_"'"_","_"ID"_":"_"'"_ID_"'"_"}"	
	  ..i resultString = "{rows:[" d
	  ...s resultString = resultString_tmp
	  ..e  d
	  ...s resultString = resultString_","_tmp					
	  ..s count=count+1	
	 }
    d result.Close()
	s resultString = resultString_"]}"
	d ##class(Src.PIS3Common).SetWebSourceNameSpace()   
	q resultString 	//返回数据
}

// w ##class(web.DHCPisAppJson).GetRecSpeR("87^2016-01-11^2017-03-28^^0^87^0^50")

/// 获取标本交接列表
ClassMethod GetRecSpeR(info As %String) As %String
{
	 s info=$g(info)	 
	 s format = ##class(websys.Conversions).DateFormat()	
  	 s dept=$p(info,"^",1)
  	 q:dept="" $$$OK  	 	  
  	 s startDate=$p(info,"^",2)
  	 s endDate=$p(info,"^",3)
  	 i startDate="" d
  	 .s startDate=+$h
  	 else  d
  	 .s startDate=$zdh(startDate,3) 
  	 i endDate="" d
	 .s endDate=+$h
	 else  d
	 .s endDate=$zdh(endDate,3)
	 s AppHandLoc=$p(info,"^",4)
	 s RecStatus=$p(info,"^",5)
	 s AppLocDr=$p(info,"^",6)
	 s start=$p(info,"^",7)
	 s limit=$p(info,"^",8)
	 s end=start+limit
	  s Info="{RecSperR:[",id="",PatName="",PSexDr="",statusDesc="",SpeRecLoc="",SpeRecDesc=""
	  s ADept="",BirthDate="",count=0,VrId="",VrDesc="",VrId1="",VrId2="",CancelId="",CancelId2="",execCtcpDesc=""
  		
 	 i startDate'="" d  	  
     .f prtdate=startDate:1:endDate  d        
	 ..s tmid=0 f  s tmid=$o(^DHCPISTestMasteri("APPDATE",dept,prtdate,tmid)) q:tmid=""  d
	 ...i '$d(^DHCPISTestMaster(tmid)) q	
	 ...s tmInfo=^DHCPISTestMaster(tmid)	
	 ...s SpeRecLoc="",VrDesc="",execCtcpDesc="",CanNurse="",NuCanDate="",NuCanTime="",CanDoc="",DocCanDate="",DocCanTime=""		
	 ...s SpeRecLoc=$p(tmInfo,"^",22)
	 ...q:SpeRecLoc=""
	 ...s PatName=$p(tmInfo,"^",14) 
	 ...s PSexDr=$p(tmInfo,"^",17)
	 ...s oeorder=$p(tmInfo,"^",32)
	 ...i oeorder'="" d
	 ....s oeordId=$p(oeorder,"||",1),oeoriSub=$p(oeorder,"||",2)
	 ....s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
	 ....q:oeoreSub=""
	 ....s execCTPCP=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",15)
	 ....i execCTPCP'="" s execCtcpDesc=$p($p($g(^CTPCP(execCTPCP,1)),"^",2),$c(0))
	 ....e  s execCtcpDesc=""
	 ...i PSexDr'="" s PSexDr=##class(web.DHCPisApplicationSheet).GetSexDescByCode(PSexDr)
	 ...s BirthDate=$p(tmInfo,"^",18)
	 ...i BirthDate'="" d	 
	 ....i format=3 s BirthDate=$zd(BirthDate,3)
	 ....i format=4	d
	 .....s zhdate=$zd(BirthDate,3)
	 .....b ;查看转化结果
	 .....s BirthDate=$p(zhdate,"-",3)_"/"_$p(zhdate,"-",2)_"/"_$p(zhdate,"-",1)
	 ...i (SpeRecLoc'="")&&(AppLocDr=SpeRecLoc) d			//手术室查询
	 ....b ;手术室查询
	 ....i SpeRecLoc'="" s SpeRecDesc=$p(##class(web.DHCPisApplicationSheet).GetLocName(SpeRecLoc),"-",2) 		
	 ....s child=0  f  s child=$o(^DHCPISTestMaster(tmid,"TS",child))  q:(child="")  d	 	 
	 .....q:'$d(^DHCPISTestMaster(tmid,"TS",child))
	 .....s id=tmid_"||"_child	
	 .....s VrId1=$p(^DHCPISTestMaster(tmid,"TS",child),"^",12)   	//手术室未交接
	 .....s VrId2=$p(^DHCPISTestMaster(tmid,"TS",child),"^",13)	  	//手术室已交接
	 .....s VrId3=$p(^DHCPISTestMaster(tmid,"TS",child),"^",21)	  	//病理科未交接
	 .....s VrId4=$p(^DHCPISTestMaster(tmid,"TS",child),"^",22)	  	//病理科已交接
	 .....q:(((VrId1'="")&&(RecStatus=1))||((VrId1="")&&(RecStatus=2))) //只区分"未接收"和"已接收"，两者不能同时包含	
	 .....s VrDate="",VrTime="",VrRecDoc="",VrProDoc="",memo=""
	 .....s CanNurse="",NuCanDate="",DocCanDate="",CanDoc=""
	 .....i VrId1'="" d
	 ......b ;VrId1不为空
	 ......q:'$d(^DHCPISVerifyRecord(VrId1))	 	
	 ......s vrInfo=^DHCPISVerifyRecord(VrId1)
	 ......s ADept=$p(vrInfo,"^",1)
	 ......s VrType=$p(vrInfo,"^",2)
	 ......b ;查询VrType值
	 ......q:VrType'="01"	
	 ......s VrDate=$p(vrInfo,"^",3)
	 ......i VrDate '="" d	 
	 .......i format=3 s VrDate=$zd(VrDate,3)
	 .......i format=4	s VrDate=$zd(VrDate,4)
	 .......;s VrDate=$zd(VrDate,3)
	 ......s VrDate1=$p(vrInfo,"^",4)
	 ......i VrDate1 '="" s VrDate1=$zt(VrDate1,1)
	 ......s VrDate=VrDate_" "_VrDate1	
	 ......s VrRecDoc=$p(vrInfo,"^",5)
	 ......s VrProDoc=$p(vrInfo,"^",6)
	 .....else  d		 
	 ......b ;VrId1为空
	 ......f  s CancelId=$o(^DHCPISCancelLogi("LOC",AppHandLoc,CancelId)) q:CancelId=""  d
	 .......q:'$d(^DHCPISCancelLog(CancelId))
	 .......s logInfo=^DHCPISCancelLog(CancelId)
	 .......s OrderCode=$p(logInfo,"^",7)
	 .......i OrderCode'=id q
	 .......s canInfo=^DHCPISCancelLog(CancelId)
	 .......s clLocDr=$p(canInfo,"^",8)
	 .......q:(clLocDr'="")&&(AppLocDr'=clLocDr)
	 .......s flag=$p($p(canInfo,"^",6),"&",2)
	 .......q:flag'=0
	 .......b ;交接人信息拼接 
	 .......s CanNurse=$p(canInfo,"^",3)
	 .......s NuCanDate=$p(canInfo,"^",1)	
	 .......i NuCanDate'="" d
	 .......i format=3 s NuCanDate=$zd(NuCanDate,3)
	 .......i format=4	s NuCanDate=$zd(NuCanDate,4)
	 .......;s NuCanDate=$zd(NuCanDate,3)
	 .......s NuCanTime=$p(canInfo,"^",2)
	 .......i NuCanTime'="" s NuCanTime=$zt(NuCanTime,1)
	 .......s NuCanDate=NuCanDate_" "_NuCanTime	
	 .....i VrId2'="" d
	 ......b ;VrId2不为空
	 ......s vrInfo2=^DHCPISVerifyRecord(VrId2)
	 ......s VrTime=$p(vrInfo2,"^",3)
	 ......i VrTime '="" d
	 .......i format=3 s VrTime=$zd(VrTime,3)
	 .......i format=4	s VrTime=$zd(VrTime,4)
	 .......;s VrTime=$zd(VrTime,3)
	 ......s VrTime1=$p(vrInfo2,"^",4)
	 ......i VrTime1 '="" s VrTime1=$zt(VrTime1,1)	
	 ......s VrTime=VrTime_" "_VrTime1		
	 ......s memo=$p(vrInfo2,"^",6)	
	 .....else  d	 
	 ......b ;VrId2为空
	 ......f  s CancelId2=$o(^DHCPISCancelLogi("LOC",dept,CancelId2)) q:CancelId2=""  d
	 .......q:'$d(^DHCPISCancelLog(CancelId2))	
	 .......s logInfo=^DHCPISCancelLog(CancelId2)
	 .......s OrderCode=$p(logInfo,"^",7)
	 .......i OrderCode'=id q
	 .......s canInfo2=^DHCPISCancelLog(CancelId2)
	 .......s clLocDr=$p(canInfo2,"^",8)		
	 .......s flag=$p($p(canInfo2,"^",6),"&",2)	
	 .......q:flag'=0	
	 .......b ;测试断点 
 	 .......s CanDoc=$p(canInfo2,"^",3)
	 .......s DocCanDate=$p(canInfo2,"^",1)
	 .......i DocCanDate'="" d
	 ........i format=3 s DocCanDate=$zd(DocCanDate,3)
	 ........i format=4	s DocCanDate=$zd(DocCanDate,4)
	 ........;s DocCanDate=$zd(DocCanDate,3)
	 .......s DocCanTime=$p(canInfo2,"^",2)
	 .......i DocCanTime'="" s DocCanTime=$zt(DocCanTime,1)	
	 .......s DocCanDate=	DocCanDate_" "_DocCanTime			
	 .....s count=count+1		
	 .....q:count<(start+1)
	 .....q:count>end	
	 .....i VrId3=1  s VrDesc="手术室未交接"
	 .....i VrId3=2  s VrDesc="手术室已交接"
	 .....i VrId4=3  s VrDesc="手术室已交接"
	 .....i VrId4=4	 s VrDesc="病理科已交接" q
	 .....i ($e(Info,$l(Info))="[") d
     ......s Info=Info_"{tmrowid:'"_tmid_"',speid:'"_id_"',Pname:'"_PatName_"',Sex:'"_PSexDr_"',Birthdate:'"_BirthDate_"',statusDesc:'"_VrDesc_"',appLocDR:'"_SpeRecDesc_"',appHandDoc:'"_VrRecDoc_"',RecDoc:'"_VrProDoc_"',RecDate:'"_VrDate_"',RecTime:'"_VrTime_"',memo:'"_memo_"',CanNurse:'"_CanNurse_"',NuCanDate:'"_NuCanDate_"',CanDoc:'"_CanDoc_"',DocCanDate:'"_DocCanDate_"',execCtcpDesc:'"_execCtcpDesc_"',leaf:false}"
     .....e  d
     ......s Info=Info_",{tmrowid:'"_tmid_"',speid:'"_id_"',Pname:'"_PatName_"',Sex:'"_PSexDr_"',Birthdate:'"_BirthDate_"',statusDesc:'"_VrDesc_"',appLocDR:'"_SpeRecDesc_"',appHandDoc:'"_VrRecDoc_"',RecDoc:'"_VrProDoc_"',RecDate:'"_VrDate_"',RecTime:'"_VrTime_"',memo:'"_memo_"',CanNurse:'"_CanNurse_"',NuCanDate:'"_NuCanDate_"',CanDoc:'"_CanDoc_"',DocCanDate:'"_DocCanDate_"',execCtcpDesc:'"_execCtcpDesc_"',leaf:false}"
     
     ...else  i (SpeRecLoc'="")&&(AppLocDr'=SpeRecLoc) d  //病理科查询界面
     ....b ;进去判断
     ....q:(AppHandLoc'="")&&(AppHandLoc'=SpeRecLoc)	
     ....b ;out判断
	 ....i SpeRecLoc'="" s SpeRecDesc=$p(##class(web.DHCPisApplicationSheet).GetLocName(SpeRecLoc),"-",2) 		
	 ....s child=0  f  s child=$o(^DHCPISTestMaster(tmid,"TS",child)) q:(child="")  d 	 	 	 
	 .....q:'$d(^DHCPISTestMaster(tmid,"TS",child))	
	 .....s id=tmid_"||"_child
	 .....s memo="",VrTime=""
	 .....i RecStatus=1 d
	 ......s VrId1=$p(^DHCPISTestMaster(tmid,"TS",child),"^",12)   q:VrId1'=""
	 ......s VrId2=$p(^DHCPISTestMaster(tmid,"TS",child),"^",13)   q:VrId2'=""
	 ......s VrId3=$p(^DHCPISTestMaster(tmid,"TS",child),"^",21)   q:VrId3'=1
	 ......s VrId4=$p(^DHCPISTestMaster(tmid,"TS",child),"^",22)   q:VrId4'=""
	 .....i RecStatus=3 d  
	 ......s VrId1=$p(^DHCPISTestMaster(tmid,"TS",child),"^",12)   q:VrId1=""
	 ......s VrId2=$p(^DHCPISTestMaster(tmid,"TS",child),"^",13)   q:VrId2'=""
	 ......s VrId3=$p(^DHCPISTestMaster(tmid,"TS",child),"^",21)   q:VrId3'=2
	 ......s VrId4=$p(^DHCPISTestMaster(tmid,"TS",child),"^",22)   q:VrId4'=3  
	 .....i RecStatus=4 d
	 ......s VrId1=$p(^DHCPISTestMaster(tmid,"TS",child),"^",12)  
	 ......s VrId2=$p(^DHCPISTestMaster(tmid,"TS",child),"^",13)
	 ......s VrId3=$p(^DHCPISTestMaster(tmid,"TS",child),"^",21)
	 ......s VrId4=$p(^DHCPISTestMaster(tmid,"TS",child),"^",22)    q:VrId4'=4
	 .....i RecStatus=0 d
	 ......s VrId1=$p(^DHCPISTestMaster(tmid,"TS",child),"^",12)
	 ......s VrId2=$p(^DHCPISTestMaster(tmid,"TS",child),"^",13)
	 ......s VrId3=$p(^DHCPISTestMaster(tmid,"TS",child),"^",21)
	 ......s VrId4=$p(^DHCPISTestMaster(tmid,"TS",child),"^",22)
	 .....q:(((VrId2'="")&&(RecStatus=3))||((VrId2="")&&(RecStatus=4))||((VrId1'="")&&(RecStatus=1))||((VrId1="")&&(RecStatus=2)))
     .....s VrDate="",VrTime="",VrRecDoc="",VrProDoc="",memo=""
	 .....s CanNurse="",NuCanDate="",DocCanDate="",CanDoc=""
     .....i VrId1'="" d
	 ......b ;VrId1不为空	
	 ......q:'$d(^DHCPISVerifyRecord(VrId1))	 	
	 ......s vrInfo=^DHCPISVerifyRecord(VrId1)
	 ......s ADept=$p(vrInfo,"^",1)
	 ......s VrType=$p(vrInfo,"^",2)
	 ......s VrDate=$p(vrInfo,"^",3)
	 ......i VrDate '="" d
	 .......i format=3 s VrDate=$zd(VrDate,3)
	 .......i format=4	s VrDate=$zd(VrDate,4)
	 .......;s VrDate=$zd(VrDate,3)
	 ......s VrDate1=$p(vrInfo,"^",4)
	 ......i VrDate1 '="" s VrDate1=$zt(VrDate1,1)
	 ......s VrDate=VrDate_" "_VrDate1		
	 ......q:VrType'="01"
	 ......s VrRecDoc=$p(vrInfo,"^",5)
	 ......s VrProDoc=$p(vrInfo,"^",6)
	 .....else  d	 
	 ......;i (AppHandLoc'="")&&(AppHandLoc'=0) d	
	 ......f  s CancelId=$o(^DHCPISCancelLog(CancelId)) q:CancelId=""  d
	 .......q:'$d(^DHCPISCancelLog(CancelId))
	 .......s logInfo=^DHCPISCancelLog(CancelId)
	 .......s OrderCode=$p(logInfo,"^",7)
	 .......i OrderCode'=id q
	 .......s canInfo=^DHCPISCancelLog(CancelId)
	 .......s clLocDr=$p(canInfo,"^",8)
	 .......q:(clLocDr'="")&&(AppLocDr'="")&&(AppLocDr=clLocDr)
	 .......s flag=$p($p(canInfo,"^",6),"&",2)
	 .......q:flag'=0	
	 .......s CanNurse=$p(canInfo,"^",3)
	 .......s NuCanDate=$p(canInfo,"^",1)	
	 .......i NuCanDate'="" d
	 ........i format=3 s NuCanDate=$zd(NuCanDate,3)
	 ........i format=4	s NuCanDate=$zd(NuCanDate,4)
	 ........;s NuCanDate=$zd(NuCanDate,3)
	 .......s NuCanTime=$p(canInfo,"^",2)
	 .......i NuCanTime'="" s NuCanTime=$zt(NuCanTime,1)
	 .......s NuCanDate=NuCanDate_" "_NuCanTime		
	 .....i VrId2'="" d	
	 ......b ;VrId2不为空
	 ......s vrInfo2=^DHCPISVerifyRecord(VrId2)
	 ......s VrTime=$p(vrInfo2,"^",3)
	 ......i VrTime '="" d
	 .......i format=3 s VrTime=$zd(VrTime,3)
	 .......i format=4	s VrTime=$zd(VrTime,4)
	 .......;s VrTime=$zd(VrTime,3)	
     ......s VrTime1=$p(vrInfo2,"^",4)
	 ......i VrTime1 '="" s VrTime1=$zt(VrTime1,1)	
	 ......s VrTime=VrTime_" "_VrTime1	
	 ......s memo=$p(vrInfo2,"^",6)
	 .....else  d		
	 ......b ;VrId2为空
	 ......f  s CancelId2=$o(^DHCPISCancelLogi("LOC",dept,CancelId2)) q:CancelId2=""  d
	 .......q:'$d(^DHCPISCancelLog(CancelId2))	
	 .......s logInfo=^DHCPISCancelLog(CancelId2)
	 .......s OrderCode=$p(logInfo,"^",7)
	 .......i OrderCode'=id q
	 .......s canInfo2=^DHCPISCancelLog(CancelId2)
	 .......s clLocDr=$p(canInfo2,"^",8)		
	 .......s flag=$p($p(canInfo2,"^",6),"&",2)	
	 .......q:flag'=0	
 	 .......s CanDoc=$p(canInfo2,"^",3)
	 .......s DocCanDate=$p(canInfo2,"^",1)
	 .......i DocCanDate'="" d
	 ........i format=3 s DocCanDate=$zd(DocCanDate,3)
	 ........i format=4	s DocCanDate=$zd(DocCanDate,4)
	 ........;s DocCanDate=$zd(DocCanDate,3)
	 .......s DocCanTime=$p(canInfo2,"^",2)
	 .......i DocCanTime'="" s DocCanTime=$zt(DocCanTime,1)	
	 .......s DocCanDate=	DocCanDate_" "_DocCanTime	
	 .......b ;zwinfo			
	 .....s count=count+1			 
	 .....q:count<(start+1)
	 .....q:count>end		
	 .....i VrId3=1  s VrDesc="手术室未交接"
	 .....i VrId3=2  s VrDesc="病理科未交接"
	 .....i VrId4=3  s VrDesc="病理科未交接"
	 .....i VrId4=4  s VrDesc="病理科已交接"	
	 .....i ($e(Info,$l(Info))="[") d
     ......s Info=Info_"{tmrowid:'"_tmid_"',speid:'"_id_"',Pname:'"_PatName_"',Sex:'"_PSexDr_"',Birthdate:'"_BirthDate_"',statusDesc:'"_VrDesc_"',appLocDR:'"_SpeRecDesc_"',appHandDoc:'"_VrRecDoc_"',RecDoc:'"_VrProDoc_"',RecDate:'"_VrDate_"',RecTime:'"_VrTime_"',memo:'"_memo_"',CanNurse:'"_CanNurse_"',NuCanDate:'"_NuCanDate_"',CanDoc:'"_CanDoc_"',DocCanDate:'"_DocCanDate_"',execCtcpDesc:'"_execCtcpDesc_"',leaf:false}"
     .....e  d
     ......s Info=Info_",{tmrowid:'"_tmid_"',speid:'"_id_"',Pname:'"_PatName_"',Sex:'"_PSexDr_"',Birthdate:'"_BirthDate_"',statusDesc:'"_VrDesc_"',appLocDR:'"_SpeRecDesc_"',appHandDoc:'"_VrRecDoc_"',RecDoc:'"_VrProDoc_"',RecDate:'"_VrDate_"',RecTime:'"_VrTime_"',memo:'"_memo_"',CanNurse:'"_CanNurse_"',NuCanDate:'"_NuCanDate_"',CanDoc:'"_CanDoc_"',DocCanDate:'"_DocCanDate_"',execCtcpDesc:'"_execCtcpDesc_"',leaf:false}"
     i count=0 s count=1	 
     s Info=Info_"],results:"_count_"}"
     i Info="{RecSperR:[" s Info="{RecSperR:[]}"   
     q Info
}

// w ##class(web.DHCPisAppJson).SpeInfoJSON2(0,3,"87","503","30","1||1")

/// 通过条码号获取标本的信息
ClassMethod SpeInfoJSON2(Start, Limit, Locdr As %String, Paadmdr As %String, tclscode As %String, TMrowid As %String) As %String
{
	
	s Locdr=$g(Locdr)
	s Paadmdr=$g(Paadmdr)
	s tclscode=$g(tclscode)
	s tmrowid=$g(TMrowid)
	s rtn=""
	s end = Start+Limit
	s count=0	
	s:tmrowid=0 tmrowid=""
	if (tmrowid=""){
			i (Paadmdr="")||(tclscode="") q "{SpeItem:[]}"
			//s tclscode2=$g(tclscode2)
			s SpePos="",SpeNum="",SpeRemark="",SpeInfo="{SpeItem:["							
			i $o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,""))="" q "{SpeItem:[]}"
			e  d
			.s tmrowid=0 f  s tmrowid=$o(^DHCPISTestMasteri("PAADM",Locdr,Paadmdr,tmrowid)) q:tmrowid=""  d
			..;i $d(^DHCPISTestMaster(tmrowid,"TS",0))=0 q		// s SpeInfo="{SpeItem:[]}"  tmrowid
			..s classDr=0 f  s classDr=$o(^DHCPISClassDicti("LOCCODE",Locdr,tclscode,classDr)) q:classDr=""  d
			...i (($p($g(^DHCPISTestMaster(tmrowid)),"^",11)=tclscode) && ($p($g(^DHCPISTestMaster(tmrowid)),"^",41)="")) d			
			....i $d(^DHCPISTestMaster(tmrowid,"TS",0))'="" d
			.....s SpeRowid=0 f  s SpeRowid=$o(^DHCPISTestMaster(tmrowid,"TS",SpeRowid)) q:SpeRowid=""  d
			......s info=$g(^DHCPISTestMaster(tmrowid,"TS",SpeRowid))
			......s SpeRowid1=tmrowid_"||"_SpeRowid			
			......s SpePos=$p(info,"^",3)
			......;s SpeNum=$P($p(info,"^",6),"~",1)
			......s SpeNo=$p(info,"^",1)
			......s SpeRemark2=$P($p(info,"^",6),"~",2) 
			......s SpeRemark=$P($p(info,"^",6),"~",1)     //2013-12-3 
			......s count=count+1				
			......q:count<(Start+1)			
			......q:count>end
			......i ($e(SpeInfo,$l(SpeInfo))="[") d
			.......s SpeInfo=SpeInfo_"{id:'"_SpeRowid1_"',"_"SpePos:'"_SpePos_"',"_"SpeNo:'"_SpeNo_"',"_"SpeRemark:'"_SpeRemark_"',"_"SpeRemark2:'"_SpeRemark2_"',leaf:false}"
			......e  d
			.......s SpeInfo=SpeInfo_",{id:'"_SpeRowid1_"',"_"SpePos:'"_SpePos_"',"_"SpeNo:'"_SpeNo_"',"_"SpeRemark:'"_SpeRemark_"',"_"SpeRemark2:'"_SpeRemark2_"',leaf:false}"		
			i count=0 s count=1		
			s SpeInfo=SpeInfo_"],results:"_count_"}"
			
		}ElseIf (tmrowid'=""){
			s SpePos="",SpeNum="",SpeRemark="",SpeInfo="{SpeItem:["											
			;i $d(^DHCPISTestMaster(tmrowid,"TS",0))'="" d
			.;s SpeRowid=0 f  s SpeRowid=$o(^DHCPISTestMaster(tmrowid,"TS",SpeRowid)) q:SpeRowid=""  d
			s SpeRowid=$p(tmrowid,"||",2)
			s rowid=$p(tmrowid,"||",1)
			s info=$g(^DHCPISTestMaster(rowid,"TS",SpeRowid))
			
			;s SpeRowid1=tmrowid_"||"_SpeRowid	
			s SpePos=$p(info,"^",3)
			;s SpeNum=$P($p(info,"^",6),"~",1)
			s SpeNo=$p(info,"^",1)
			s SpeRemark2=$P($p(info,"^",6),"~",2)
			s SpeRemark=$P($p(info,"^",6),"~",1)  //2013-12-3 
			s count=count+1				
			q:count<(Start+1)
			q:count>end
			i ($e(SpeInfo,$l(SpeInfo))="[") d
			.s SpeInfo=SpeInfo_"{id:'"_tmrowid_"',"_"SpePos:'"_SpePos_"',"_"SpeNo:'"_SpeNo_"',"_"SpeRemark:'"_SpeRemark_"',"_"SpeRemark2:'"_SpeRemark2_"',leaf:false}"
			e  d
			.s SpeInfo=SpeInfo_",{id:'"_tmrowid_"',"_"SpePos:'"_SpePos_"',"_"SpeNo:'"_SpeNo_"',"_"SpeRemark:'"_SpeRemark_"',"_"SpeRemark2:'"_SpeRemark2_"',leaf:false}"						
			i count=0 s count=1
			s SpeInfo=SpeInfo_"],results:"_count_"}"
			}
	q SpeInfo
}

// ------------------------------------结束-SYL标本交接类方法增加区域请勿在此区域CRUD方法-------------------------------------

}
