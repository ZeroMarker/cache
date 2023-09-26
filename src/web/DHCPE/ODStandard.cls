Import SQLUser

Class web.DHCPE.ODStandard Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 90;

// ODR_RowId,ODR_ARCIM_DR,ODR_OD_DR

/// 
/// 提供给Web页面 显示所有检验细项的查询 页面测试使用 
Query QueryAll() As %SQLQuery(ROWSPEC = "ODS_ParRef:%String, ODS_RowId:%String, ODS_ChildSub:%String, ODS_Sex:%String, ODS_AgeMin:%String, ODS_AgeMax:%String, ODS_TextVal:%String, ODS_Unit:%String, ODS_Min:%String, ODS_Max:%String, ODS_NatureValue:%String, ODS_ParRef_Name:%String, ODS_Template:%String")
{
 
 select od.ODS_ParRef, od.ODS_RowId, od.ODS_ChildSub, od.ODS_Sex, ODS_AgeMin, ODS_AgeMax, od.ODS_TextVal, od.ODS_Unit, od.ODS_Min, od.ODS_Max, od.ODS_NatureValue
        , o.OD_Desc as ODS_ParRef_Name, od.ODS_Template
 from DHC_PE_ODStandard as od
 inner join DHC_PE_OrderDetail as o on o.OD_RowId= od.ODS_ParRef
}

/// 提供给Web页面 查询指定检验细项的体检标准
Query SearchODStandard(ParRef As %Library.String = "") As %SQLQuery(ROWSPEC = "ODS_ParRef:%String, ODS_RowId:%String, ODS_ChildSub:%String, ODS_Sex:%String, ODS_AgeMin:%String, ODS_AgeMax:%String, ODS_TextVal:%String, ODS_Unit:%String, ODS_Min:%String, ODS_Max:%String, ODS_NatureValue:%String, ODS_ParRef_Name:%String, ODS_Template:%String")
{
  
 select od.ODS_ParRef, od.ODS_RowId, od.ODS_ChildSub, od.ODS_Sex, ODS_AgeMin, ODS_AgeMax, od.ODS_TextVal, od.ODS_Unit, od.ODS_Min, od.ODS_Max, od.ODS_NatureValue
        , o.OD_Desc as ODS_ParRef_Name, od.ODS_Template
 from DHC_PE_ODStandard as od
 inner join DHC_PE_OrderDetail as o on o.OD_RowId= od.ODS_ParRef
 where od.ODS_ParRef=:ParRef
 order by od.ODS_Template
}

Query SearchODStandardNew(ParRef As %Library.String = "") As websys.Query(ROWSPEC = "ODS_ParRef:%String,ODS_RowId:%String,ODS_ChildSub:%String,TSex:%String,TSexDesc:%String,TTextVal:%String,TUnit:%String,TMin:%String,TMax:%String,TNatureValue:%String,TAgeMin:%String,TAgeMax:%String,TSort:%String,THDValue:%String,TEyeSee:%String,TNoPrint:%String,TSummary:%String,TDefault:%String")
{
}

ClassMethod SearchODStandardNewExecute(ByRef qHandle As %Binary, ParRef As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    if (ParRef=""){
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
    }

    s id=0
	f  s id=$o(^DHCPEST($P(ParRef,"||",1),"OD",$P(ParRef,"||",2),"ODS",id)) q:(id="")  d
	.s Data=$g(^DHCPEST($P(ParRef,"||",1),"OD",$P(ParRef,"||",2),"ODS",id))
	.s Sex=$p(Data,"^",1)
	.S SexDesc=""
	.i Sex="M" S SexDesc="男"
	.i Sex="F" S SexDesc="女"
	.i Sex="N" S SexDesc="不限"
	.S TextVal=$p(Data,"^",2)
	.S Unit=$p(Data,"^",3)
	.s Min=$p(Data,"^",4)
	.s Max=$p(Data,"^",5)
	.s NatureValue=$p(Data,"^",6)
	.i NatureValue="Y" S NatureValue="是"
	.e  s NatureValue="否"
	.s AgeMin=$p(Data,"^",7)
	.i ($p(AgeMin,".",1)="")&&(AgeMin[".") s AgeMin=0_AgeMin
	.s AgeMax=$p(Data,"^",8)
	.i ($p(AgeMax,".",1)="")&&(AgeMax[".") s AgeMax=0_AgeMax

	.s Sort=$p(Data,"^",9)
	.S ODSRowId=ParRef_"||"_id
	.s HDValue=$g(^DHCPECTDataEx("DHCPEODStandard","HDValue",ODSRowId))
	.i HDValue="Y" S HDValue="是"
	.e  s HDValue="否"
	.s EyeSee=$g(^DHCPECTDataEx("DHCPEODStandard","EyeSee",ODSRowId))
	.s NoPrint=$g(^DHCPECTDataEx("DHCPEODStandard","NoPrint",ODSRowId))
	.i NoPrint="Y" S NoPrint="是"
	.e  s NoPrint="否"
	.s Summary=$g(^DHCPECTDataEx("BaseData","ODStandard","ODS_Summary",ODSRowId))
	.i Summary="Y" S Summary="是"
	.e  s Summary="否"
	.s Default=$g(^DHCPECTDataEx("DHCPEODStandard","Default",ODSRowId))
	.i Default="Y" S Default="是"
	.e  s Default="否"

	.s ^CacheTemp(repid,ind)=$lb(ParRef,ODSRowId,id,Sex,SexDesc,TextVal,Unit,Min,Max,NatureValue,AgeMin,AgeMax,Sort,HDValue,EyeSee,NoPrint,Summary,Default)
	.s ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetTextName(TextValID)
{
	i TextValID="" q ""
    s STID="",ODChildSub="",ODSChildSub=""
    s STID=$P(TextValID,"||",1)
    s ODChildSub=$P(TextValID,"||",2)
    s ODSChildSub=$P(TextValID,"||",3)
   
   Q $p(^DHCPEST(STID,"OD",ODChildSub,"ODS",ODSChildSub),"^",2)          
 
	//q $P(^DHCPEED(EDId,"1"),"^",1)
}

Query ODStandardByOD(OrderDetailRowId As %Library.String = "") As %SQLQuery(ROWSPEC = " ODS_TextVal:%String,ODS_Min:%String, ODS_Max:%String,  ODS_NatureValue:%String, ODS_RowId:%String, ODS_Unit:%String")
{
 select ODS_TextVal,ODS_Min,ODS_Max, ODS_Unit, ODS_NatureValue,ODS_RowId
 from DHC_PE_ODStandard
 where ODS_ParRef=:OrderDetailRowId
}

/// 更新函数 具有跟新（修改）和插入的功能 
ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
    s ^xwmTemp("Save")=InString
    // ODS_ParRef
    s PLIST(0)=$p(InString,"^",1)
    
    // ODS_RowId
    //s PLIST(1)=$p(InString,"^",2)    //无法传入 特殊处理 位置预留
    
    // ODS_ChildSub
    
    s value=$p(InString,"^",3)    
    s:(""'=value) PLIST(2)=value
    
    s:(0'=$D(PLIST(2))) PLIST(1)=PLIST(0)_"||"_PLIST(2)

    // ODS_TextVal	文本值
    s PLIST(3)=$p(InString,"^",4)
    
    // 	ODS_Unit	单位
    s PLIST(4)=$p(InString,"^",5)
    
    // ODS_Sex	适用性别
    s PLIST(5)=$p(InString,"^",6)
    	
    // 	ODS_Min	下限
    s PLIST(6)=$p(InString,"^",7)

    // 	ODS_Max	上限
    s PLIST(7)=$p(InString,"^",8)

    // 	ODS_NatureValue	是否正常值
    s PLIST(9)=$p(InString,"^",10)
      
    // ODS_AgeMin	年龄下限
    s PLIST(10)=$p(InString,"^",11)

    // ODS_AgeMax	年龄上限
    s PLIST(11)=$p(InString,"^",12)
    
    // 	ODS_Template	模版
    s PLIST(12)=$p(InString,"^",13)  
    
    //ODS_Summary      是否进入小结
    s PLIST(13)=$p(InString,"^",14)  
	s NoPrint=$p(InString,"^",15)  
	s HighRisk=$p(InString,"^",17)
	s EyeSee=$p(InString,"^",18)        			//add
    s ret=..ISave($g(PLIST(0)),$g(PLIST(2)),$g(PLIST(13)))
    s HDValue=$p(InString,"^",19)
       //默认
    s Default=$p(InString,"^",20)

    if ret=0
    {
	    s RowId=%ROWID
	    s ^DHCPECTDataEx("DHCPEODStandard","NoPrint",RowId)=NoPrint
	    s ^DHCPECTDataEx("DHCPEODStandard","HighRiskFlag",RowId)=HighRisk  //add
	    s ^DHCPECTDataEx("DHCPEODStandard","EyeSee",RowId)=EyeSee
	    s ^DHCPECTDataEx("DHCPEODStandard","HDValue",RowId)=HDValue
	    s ^DHCPECTDataEx("DHCPEODStandard","Default",RowId)=Default
    }
	q ret
}

/// 删除函数 
ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", ParRef As %Library.String = "", ChildSub As %Library.String = "")
{
	s RowId=ParRef_"||"_ChildSub
    k ^DHCPECTDataEx("BaseData","ODStandard","ODS_Summary",RowId) 
    k ^DHCPECTDataEx("DHCPEODStandard","NoPrint",RowId)
	k ^DHCPECTDataEx("DHCPEODStandard","HighRiskFlag",RowId)
	k ^DHCPECTDataEx("DHCPEODStandard","EyeSee",RowId)
    k ^DHCPECTDataEx("DHCPEODStandard","HDValue",RowId)  
    k ^DHCPECTDataEx("DHCPEODStandard","Default",RowId) 
	  &sql(delete from DHC_PE_ODStandard 
	     where ODS_ParRef=:ParRef and ODS_ChildSub=:ChildSub 
	)
	q SQLCODE
}

ClassMethod ISave(ParRef As %Library.String = "", ChildSub As %Library.String = "", Summary As %Library.String = "")
{
	s ReturnFlag=""
	i 0=$D(PLIST(1)) d
	.s ReturnFlag=..Insert(ParRef,ChildSub,Summary)
	e  d
	.s ReturnFlag=..Update(ParRef,ChildSub,Summary)

	q ReturnFlag
}

ClassMethod Insert(ParRef As %Library.String = "", ChildSub As %Library.String = "", Summary As %Library.String = "")
{
	k PLIST(1)
	k PLIST(2)
	&sql(insert into DHC_PE_ODStandard
	     values :PLIST()
	     )
	     
	 //zl
	i Summary="Y"  d
	.s ^DHCPECTDataEx("BaseData","ODStandard","ODS_Summary",%ROWID)=Summary    
	q SQLCODE
}

ClassMethod Update(ParRef As %String, RowId As %String, ChildSub As %String, Sex As %String, AgeMin As %String, AgeMax As %String, TextVal As %String, Unit As %String, Min As %String, Max As %String, NatureValue As %String, Summary As %String)
{
	s ParRef=PLIST(0)
	s ChildSub=PLIST(2)
	s summary=PLIST(13)
	s RowId=ParRef_"||"_ChildSub
	k PLIST(0)
	k PLIST(1)
	k PLIST(2)
	
	//STORD_ParRef=:ParRef and STORD_Childsub=:ChildSub
	//zl
  s ^DHCPECTDataEx("BaseData","ODStandard","ODS_Summary",ParRef_"||"_ChildSub)=summary
  i summary'="Y"  d
  .k ^DHCPECTDataEx("BaseData","ODStandard","ODS_Summary",ParRef_"||"_ChildSub)
	&sql(update DHC_PE_ODStandard
	     values :PLIST()
	     where ODS_ParRef=:ParRef and ODS_ChildSub=:ChildSub
	     )
	     
	 q SQLCODE
}

ClassMethod GetNorInfo(String)
{
	s ID=$p(String,"^",3)
	s ts=$p(String,"^",2),ret=""
	//日期取最后一次维护的
	s tsdata=$o(^TTAB("TC",ts,4,""),-1),trange="",N=0
	/// 检验没维护的
	q:(tsdata="") "性别:"_"男"_""_20_"范围:"_##class(web.DHCPE.ResultEdit).GetNormal(ID,"M","20")_$c(13,10)_"性别:"_"女"_""_20_"范围:"_##class(web.DHCPE.ResultEdit).GetNormal(ID,"F","20")_$c(13,10)_"性别:"_"不限"_""_20_"范围:"_##class(web.DHCPE.ResultEdit).GetNormal(ID,"N","20")
	;s trange=$o(^TTAB("TC",ts,4,tsdata,trange))
	f  s trange=$o(^TTAB("TC",ts,4,tsdata,trange))  q:trange=""  d
	.s order=0
   .f  s order=$o(^TTAB("TC",ts,4,tsdata,trange,order))  q:order=""  d
   ..s N=N+1
   ..q:(N>3) //防止取到多余数据
   ..;w !,tsdata_"a"_trange_"b"_order_"c"_$g(^TTAB("TC",ts,4,tsdata,trange,order))
   ..s Lrange=$p(^TTAB("TC",ts,4,tsdata,trange,order),"\",1)  //最高值
   ..s Hrange=$p(^TTAB("TC",ts,4,tsdata,trange,order),"\",2)   //最小值
   ..s gaoweizhi=$p(^TTAB("TC",ts,4,tsdata,trange,order),"\",17)  //高危值
   ..s diweizhi=$p(^TTAB("TC",ts,4,tsdata,trange,order),"\",18)    //低危值
   ..s ass=$p(^TTAB("TC",ts,4,tsdata,trange,order),"\",22)    //标记
   ..s bss=$p(^TTAB("TC",ts,4,tsdata,trange,order),"\",23)   //
   ..;s Sex=$p(^DHCPEST(Station,"OD",Sub,"ODS",NSub),"^")
   ..s Lrange=$fn(Lrange,",")
   ..s Hrange=$fn(Hrange,",")
	..i ass="N"  s Sex="不限"
	..e  s Sex=$p(^CT("SEX",$o(^CT("SEX",0,"Code",ass,""))),"^",2)
	..s OneInfo="性别:"_Sex_""_bss_"范围:"_Lrange_"-"_Hrange
	..;w !,"OneInfo"_OneInfo
	..s:(ret'="") ret=ret_$c(13,10)_OneInfo
	..s:(ret="") ret=OneInfo
	i ret=""  d
	.s ret="性别:"_"男"_""_20_"范围:"_##class(web.DHCPE.ResultEdit).GetNormal(ID,"M","20")_$c(13,10)_"性别:"_"女"_""_20_"范围:"_##class(web.DHCPE.ResultEdit).GetNormal(ID,"F","20")_$c(13,10)_"性别:"_"不限"_""_20_"范围:"_##class(web.DHCPE.ResultEdit).GetNormal(ID,"N","20")
	.
   
   q ret
}

/// 根据细项ID以及细项选择描述获取细项选择检查所见
ClassMethod GetEyeSeeInfo(ODID, ODSStr)
{
	s EyeSeeInfo=""
	s ODSSub=""
	f  s ODSSub=$O(^DHCPEST(+ODID,"OD",$P(ODID,"||",2),"ODS",ODSSub)) q:(ODSSub="")||(EyeSeeInfo'="")  d
	.s TextInfo=$P(^DHCPEST(+ODID,"OD",$P(ODID,"||",2),"ODS",ODSSub),"^",2)
	.i TextInfo=ODSStr d
	..s EyeSeeInfo=$G(^DHCPECTDataEx("DHCPEODStandard","EyeSee",ODID_"||"_ODSSub))
	q EyeSeeInfo
}

/// function:判断细项选择是否存在正常值
/// debug:w ##class(web.DHCPE.ODStandard).GetODSNatureValue()
ClassMethod GetODSNatureValue(ParRef, Child)
{
	s Sub="",flag=0
	f  s Sub=$o(^DHCPEST($p(ParRef,"||",1),"OD",$p(ParRef,"||",2),"ODS",Sub)) q:(Sub="")||(flag=1)  d
	.s NatureValue=$p($g(^DHCPEST($p(ParRef,"||",1),"OD",$p(ParRef,"||",2),"ODS",Sub)),"^",6)
	.i NatureValue="Y" s flag=1
	q flag
}

/// function:判断细项选择是否存在默认值
/// debug:w ##class(web.DHCPE.ODStandard).IsExistDefault()
ClassMethod IsExistDefault(ODParRef)
{
	s flag=0
	S ODSub=""
	f  s ODSub=$o(^DHCPEST($P(ODParRef,"||",1),"OD",$P(ODParRef,"||",2),"ODS",ODSub)) q:(ODSub="")||(flag=1)  d
	.s ODSRowId=ODParRef_"||"_ODSub
	.q:'$d(^DHCPECTDataEx("DHCPEODStandard","Default",ODSRowId))
	.i $g(^DHCPECTDataEx("DHCPEODStandard","Default",ODSRowId))="Y" s flag=1 
	q flag
}

}
