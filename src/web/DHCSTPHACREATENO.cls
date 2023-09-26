Import Sqluser

Class web.DHCSTPHACREATENO Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 2;

/// Description: 根据exe名称取单号规则，可供外部程序调用
/// Input:AppName-应用程序名称
/// Output:
/// Return:返回规则字符串
/// 
ClassMethod GetAppCounter(AppName) As %String
{
	
 N (AppName)
 Q:AppName="" ""
 S AppName=$$ALPHAUP^SSUTIL4(AppName)
 S ssa=$O(^DHCSSA(0,"ACODE",AppName,""))
 Q:ssa="" ""
 S sscsub=$O(^DHCSSA(ssa,"SSC","0"))
 Q:sscsub="" ""
 S retstr=^DHCSSA(ssa,"SSC",sscsub)
 Q retstr
}

/// Description: 根据exe名称,及参数字符串取前缀
/// Input:		AppName-程序名称，PrePara-医院代码^科室代码^前缀
/// Return:		单号的前缀
ClassMethod GetAppPrefix(AppName, PrePara) As %String
{
 N (AppName,PrePara)
 S Prefix=""
 S Counter=..GetAppCounter(AppName)
 S HospCode=$P(PrePara,"^",1)
 S LocCode=$P(PrePara,"^",2)
 S CatGrp=$P(PrePara,"^",3)
 I $P(Counter,"^",1)="Y" S Prefix=HospCode	//医院代码
 I $P(Counter,"^",2)="Y" S Prefix=Prefix_LocCode	//科室代码
 I $P(Counter,"^",3)="Y" S Prefix=Prefix_CatGrp	//类组代码
 S Prefix=Prefix_$P(Counter,"^",4)	//前缀
 S sdate=$ZD(+$H,3)
 I $P(Counter,"^",5)="Y" S Prefix=Prefix_$P(sdate,"-",1)
 I $P(Counter,"^",6)="Y" S Prefix=Prefix_$P(sdate,"-",2)
 I $P(Counter,"^",7)="Y" S Prefix=Prefix_$P(sdate,"-",3)
 Q Prefix
}

/// Description: 取业务单号-可供外部程序调用
/// Input:		AppName-程序名称，PrePara-医院代码^科室代码^前缀
/// Return:		业务单号
ClassMethod GetAppNoM(AppName, PrePara) As %String
{
 N (AppName,PrePara)
 S Prefix=..GetAppPrefix(AppName,PrePara)
 S CurNo=..GetAppNo(AppName,Prefix)
 Q CurNo
}

/// Description: 取业务单号-可供外部程序调用
/// Input:		AppName-程序名称，Prefix-单号前缀
/// Return:		单号
ClassMethod GetAppNo(AppName, Prefix) As %String
{
 N (AppName,Prefix)
 Q:Prefix="" -1
 S coustr=..GetAppCounter(AppName)
 Q:coustr="" -2
 S NoLen=+$P(coustr,"^",8)
 Q:NoLen=0 -3
 S MaxSuffix=9
 S flen=NoLen-1
 F i=1:1:flen S MaxSuffix=MaxSuffix_"9"
 S MaxNo=Prefix_MaxSuffix	//最大单号
 S MinSuffix=1
 F i=1:1:flen S MinSuffix="0"_MinSuffix
 S MinNo=Prefix_MinSuffix	//最小单号
 S AppName=$$ALPHAUP^SSUTIL4(AppName)
 S PreNo=..GetPreNo(AppName,MaxNo)
 S CurNo=..GetCurNo(PreNo,MinNo,Prefix,NoLen)
 Q CurNo
}

/// Description: 取业务单号
/// Creator:zhouyg
/// CreatDate:2009-08-18
/// Table:
/// Input:PreNo-前一个单号,MinNo-此前缀的最小单号,Prefix-前缀,NoLen-序号长度
/// Output:PLIST-科室描述列表
/// Return:科室数量
ClassMethod GetCurNo(PreNo, MinNo, Prefix, NoLen) As %String
{
 N (PreNo,MinNo,Prefix,NoLen)
 I PreNo="" D
 .S CurNo=MinNo
 E  D
 .S PreLen=$L(Prefix)		//前缀长度
 .S CurLen=PreLen+NoLen	//单号长度
 .I $E(PreNo,1,PreLen)=Prefix D
 ..S Suffix=$E(PreNo,PreLen+1,CurLen)+1
 ..S slen=$L(Suffix)
 ..S flen=NoLen-slen
 ..F i=1:1:flen S Suffix="0"_Suffix
 ..S CurNo=Prefix_Suffix
 .E  D
 ..S CurNo=MinNo
 Q CurNo
}

/// Description:最大码的前一个码
ClassMethod GetPreNo(AppName, MaxNo) As %String
{
 N (AppName,MaxNo)
 If (AppName="DHCSTADJSP")!(AppName="DHCSTADJSP2") D
 .S PreNo=$O(^INASP(0,"ASPNO",MaxNo),-1)
 Else  If (AppName="DHCSTIMPORT")!(AppName="DHCSTIMPORT2") D
 .S PreNo=$O(^DHCINGR(0,"No",MaxNo),-1)
 Else  If (AppName="DHCSTINDISP")!(AppName="DHCSTINDISP2") D
 .S PreNo=$O(^INDS(0,"No",MaxNo),-1)
 Else  If (AppName="DHCSTkTkFREEZESTOCK")!(AppName="DHCSTkTkFREEZESTOCK2") D
 .S PreNo=$O(^DHCINST(0,"NO",MaxNo),-1)
 Else  If (AppName="DHCSTMAKEIMP")!(AppName="DHCSTMAKEIMP2") D
 .S PreNo=$O(^DHCINGR(0,"No",MaxNo),-1)
 Else  If (AppName="DHCSTPAY")!(AppName="DHCSTPAY2") D
 .S PreNo=$O(^DHCPAY(0,"NO",MaxNo),-1)
 Else  If (AppName="DHCSTPO")!(AppName="DHCSTPO2") D
 .S PreNo=$O(^INPO(0,"No",MaxNo),-1)
 Else  If (AppName="DHCSTPURPLANAUDIT")!(AppName="DHCSTPURPLANAUDIT2") D
 .S PreNo=$O(^INPP(0,"NO",MaxNo),-1)
 Else  If (AppName="DHCSTRETURN")!(AppName="DHCSTRETURN2") D
 .S PreNo=$O(^INGRT(0,"RETNO",MaxNo),-1)
 Else  If (AppName="DHCSTSTOCKADJ")!(AppName="DHCSTSTOCKADJ2") D
 .S PreNo=$O(^DHCINAD(0,"No",MaxNo),-1)
 Else  If (AppName="DHCSTSTOCKTRANSFER")!(AppName="DHCSTSTOCKTRANSFER2") D
 .S PreNo=$O(^DHCINIT(0,"No",MaxNo),-1)
 Else  If (AppName="DHCSTTRREQUEST")!(AppName="DHCSTTRREQUEST2") D
 .S PreNo=$O(^INRQ(0,"No",MaxNo),-1)
 Else  If (AppName="DHCSTDRUGMANU") D
 .S PreNo=$O(^DHCINMAN(0,"NO",MaxNo),-1)
 Else  If (AppName="DHCSTPHARETREQ") D
 .S PreNo=$O(^RETRQ(0,"RETRQNO",MaxNo),-1)
 Else  If (AppName="DHCSTPHARETURN") D
 .S PreNo=$O(^PHARET(0,"NO",MaxNo),-1)
 Else  If (AppName="DHCSTORDDISP") D
 .S PreNo=$O(^DHCPHAC(0,"NO",MaxNo),-1)
 Else  D
 .S PreNo=""
 Q PreNo
}

Storage Default
{
<Data name="DHCSTPHACREATENODefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCSTPHACREATENOD</DataLocation>
<DefaultData>DHCSTPHACREATENODefaultData</DefaultData>
<IdLocation>^web.DHCSTPHACREATENOD</IdLocation>
<IndexLocation>^web.DHCSTPHACREATENOI</IndexLocation>
<StreamLocation>^web.DHCSTPHACREATENOS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
