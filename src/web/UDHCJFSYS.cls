Import SQLUser

Class web.UDHCJFSYS Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 10;

ClassMethod LOCK(ADM, BILL, USER, COMPU)
{
	;i ADM="" q 100
	i BILL="" q 0
	i ADM="" s ADM=$p(^DHCPB(BILL),"^")
	s order=$o(^OEORD(0,"Adm",ADM,""))
	s err=..SSLOCK("OE_Order",order,USER,COMPU)
	i $d(^DBLock("DHC_PatientBill",BILL))  d
	.s ssid=$p(^DBLock("DHC_PatientBill",BILL),"^")
	.s name=$p(^SSU("SSUSR",ssid),"^",2)
	.s PLIST(1)="抱歉,目前"_name_",机器:"_COMPU_"正在作结算,请等会好吗?"
	.s PLIST=1
	.&js<alert("#(PLIST(1))#");>
	i $d(^DBLock("DHC_PatientBill",BILL)) q 100
	s err=..SSLOCK("DHC_PatientBill",BILL,USER,COMPU)
	q err
}

ClassMethod LOCKCLR(BASETAB, ROWID)
{
	; CLEAR LOCK
	; Parameters
	; BASETAB       Base Table
	; ROWID         Row ID
	; Note Return value for VB true is -1
	
	q:$g(ROWID)="" -1
	;s ind=$o(^zleon($zn,""),-1)+1,^zleon($zn,ind,"c")=BASETAB_"^"_ROWID_"^"_$j
	L -^DBLock(BASETAB,ROWID)
	k ^DBLock(BASETAB,ROWID)
	Q -1
}

ClassMethod SSLOCK(BASETAB, ROWID, User, Comp)
{
	q:$g(ROWID)="" -1
	;s ind=$o(^zleon($zn,""),-1)+1,^zleon($zn,ind,"l")=BASETAB_"^"_ROWID_"^"_User_"^"_Comp_"^"_$j
	s User=$g(User),Comp=$g(Comp)
	n user,name,doc,ext,s
	L +^DBLock(BASETAB,ROWID):0 E  d  Q name_"^"_ext_"^"_comp
	.s ss=$g(^DBLock(BASETAB,ROWID)),user=$p(ss,"^"),comp=$p(ss,"^",2),s=$g(^SSU("SSUSR",+user)),name=$p(s,"^",2),doc=$p(s,"^",14),ext=$p($g(^CTPCP(+doc,2)),"^",2)
	;s ^DBLock(BASETAB,ROWID)=User_"^"_Comp
	s ^DBLock(BASETAB,ROWID)=User_"^"_Comp_"^"_"^"_$j_"^"_$ZU(67,15,$j)     ; by xin,记录客户机IP地址
	Q -1
}

ClassMethod UNLOCK(ADM, BILL, USER, COMPU)
{
    ;i ADM="" q 100
	;i BILL=""  q 100
	i ADM="" s ADM=$p(^DHCPB(BILL),"^")
	s order=$o(^OEORD(0,"Adm",ADM,""))
	s err=..LOCKCLR("OE_Order",order)
	s err=..LOCKCLR("DHC_PatientBill",BILL)
	q err
}

}
