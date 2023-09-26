Import SQLUser

Class web.DHCVISRegShow Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCVISRegShow).GetInterval()
ClassMethod GetInterval() As %String
{
	s ret=5000
	i $G(^DHCVISRegShowSet("Time"))'=""  s ret=$G(^DHCVISRegShowSet("Time"))
	q ret
}

/// w ##class(web.DHCVISRegShow).GetScreenLocation()
ClassMethod GetScreenLocation() As %String
{
	s ret=1
	i $G(^DHCVISRegShowSet("Location"))'=""  s ret=$G(^DHCVISRegShowSet("Location"))
	q ret
}

/// w ##class(web.DHCVISRegShow).GetRegResouce()
ClassMethod GetRegResouce(ServerIP As %String = "") As %String
{
	s retStr=""
	s LocStr=""
	s max=4
	s UserId=2
	s GroupRowId=5
	i ServerIP'="" d
	.s LocStr=""
	.s LocStr=$G(^DHCVISRegShowSet("IP",ServerIP))
	i LocStr="" d
	.s LocId=""
	.f  s LocId=$O(^CTLOC(0,"LocType","E",LocId)) q:LocId=""  d
	..i LocStr="" s LocStr=LocId
	..e  s LocStr=LocStr_"^"_LocId
	i ServerIP="" {	
	s CreatFlag=0
	i $D(^DHCVISRegShow(+$H))=0 s CreatFlag=1
	f i=1:1:$L(LocStr,"^") {
		s LocRowId=$P(LocStr,"^",i)
		s TimeRange=1
		i $P($H,",",2)>43200 s TimeRange=2
		i TimeRange=1 s TimeRange=""
		s val=LocRowId_"^"_UserId_"^^^"_TimeRange_"^^"_GroupRowId_"^^false"
		s rs=##Class(%ResultSet).%New("web.DHCOPAdmReg:OPDocList")
		i rs.QueryIsValid() { 
			Set Status=rs.Execute(val)
			Set columns = rs.GetColumnCount()
			If 'Status Quit
			While rs.Next() {
				//科室^号别^时段^挂号费^可挂数
				s CTLocDesc=rs.GetData(20)
				i $P(CTLocDesc,"-",2)'="" s CTLocDesc=$P(CTLocDesc,"-",2)
				s MarkDesc=rs.GetData(2)
				s TypeDesc=rs.GetData(10)   //职称
				s RegFee=rs.GetData(11)    
				s ExamFee=rs.GetData(13)
				s RegFee=RegFee+ExamFee
				//i RegFee<9 continue
				//s RegFee=rs.GetData(24)
				s AvailSeqNo=rs.GetData(6)
				s AppLoad=rs.GetData(4)
				s TimeRangeDesc=rs.GetData(28)
				s MarkDesc=MarkDesc   //_"("_TimeRangeDesc_")"
				s AvailSeqNo=AvailSeqNo-AppLoad
				i AvailSeqNo<0 s AvailSeqNo=0
				i (CTLocDesc'="")&(RegFee>0) d
				.i CreatFlag=1 s ^DHCVISRegShow(+$H,CTLocDesc,MarkDesc,TimeRangeDesc)=CTLocDesc_"^"_MarkDesc_"^"_TypeDesc_"^"_RegFee_"^"_AvailSeqNo_"^"_RegFee
				.e  d
				..i $D(^DHCVISRegShow(+$H,CTLocDesc,MarkDesc,TimeRangeDesc))>0 s ^DHCVISRegShow(+$H,CTLocDesc,MarkDesc,TimeRangeDesc)=CTLocDesc_"^"_MarkDesc_"^"_TypeDesc_"^"_RegFee_"^"_AvailSeqNo_"^"_RegFee
				.//s rowvalue=CTLocDesc_"^"_MarkDesc_"^"_TypeDesc_"^"_RegFee_"^"_AvailSeqNo
				.//if retStr="" s retStr=rowvalue
				.//else  s retStr=retStr_"!"_rowvalue
				.
			}
		}		
		
	}
	s sum=1
	s CTLocDesc=""
	f  s CTLocDesc=$O(^DHCVISRegShow(+$H,CTLocDesc)) q:(CTLocDesc="")!(sum>max)  d
	.s MarkDesc=""
	.f  s MarkDesc=$O(^DHCVISRegShow(+$H,CTLocDesc,MarkDesc)) q:(MarkDesc="")!(sum>max)  d
	..s TimeRangeDesc=""
	..f  s TimeRangeDesc=$O(^DHCVISRegShow(+$H,CTLocDesc,MarkDesc,TimeRangeDesc)) q:(TimeRangeDesc="")!(sum>max)  d
	...s rowvalue=$G(^DHCVISRegShow(+$H,CTLocDesc,MarkDesc,TimeRangeDesc))
	...if retStr="" s retStr=rowvalue
	...else  s retStr=retStr_"!"_rowvalue
	...s sum=sum+1
	...k ^DHCVISRegShow(+$H,CTLocDesc,MarkDesc,TimeRangeDesc)	
	}
	i ServerIP'="" {	
	s CreatFlag=0
	i $D(^DHCVISRegShow(+$H,ServerIP))=0 s CreatFlag=1
	f i=1:1:$L(LocStr,"^") {
		s LocRowId=$P(LocStr,"^",i)
		s TimeRange=1
		i $P($H,",",2)>43200 s TimeRange=2
		i TimeRange=1 s TimeRange=""
		s val=LocRowId_"^"_UserId_"^^^"_TimeRange_"^^"_GroupRowId_"^^false"
		s rs=##Class(%ResultSet).%New("web.DHCOPAdmReg:OPDocList")
		i rs.QueryIsValid() { 
			Set Status=rs.Execute(val)
			Set columns = rs.GetColumnCount()
			If 'Status Quit
			While rs.Next() {
				//科室^号别^职称^挂号费^可挂数
				s CTLocDesc=rs.GetData(20)
				i $P(CTLocDesc,"-",2)'="" s CTLocDesc=$P(CTLocDesc,"-",2)
				s MarkDesc=rs.GetData(2)
				s TypeDesc=rs.GetData(10)
				s RegFee=rs.GetData(11)
				s ExamFee=rs.GetData(13)
				s RegFee=RegFee+ExamFee
				//i RegFee<9 continue
				//s RegFee=rs.GetData(24)
				s AvailSeqNo=rs.GetData(6)
				s AppLoad=rs.GetData(4)
				s TimeRangeDesc=rs.GetData(28)
				s MarkDesc=MarkDesc   //_"("_TimeRangeDesc_")"
				s AvailSeqNo=AvailSeqNo-AppLoad    //当前剩号=剩号-预约号
				i AvailSeqNo<0 s AvailSeqNo=0
				i (CTLocDesc'="")&(RegFee>0) d
				.i CreatFlag=1 s ^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc)=CTLocDesc_"^"_MarkDesc_"^"_TypeDesc_"^"_RegFee_"^"_AvailSeqNo_"^"_TimeRangeDesc
				.e  d
				..i $D(^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc))>0 s ^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc)=CTLocDesc_"^"_MarkDesc_"^"_TypeDesc_"^"_RegFee_"^"_AvailSeqNo_"^"_TimeRangeDesc
				.//s rowvalue=CTLocDesc_"^"_MarkDesc_"^"_TypeDesc_"^"_RegFee_"^"_AvailSeqNo
				.//if retStr="" s retStr=rowvalue
				.//else  s retStr=retStr_"!"_rowvalue
				.
			}
		}		
		
	}
	s sum=1
	s CTLocDesc=""
	f  s CTLocDesc=$O(^DHCVISRegShow(+$H,ServerIP,CTLocDesc)) q:(CTLocDesc="")!(sum>max)  d
	.s MarkDesc=""
	.f  s MarkDesc=$O(^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc)) q:(MarkDesc="")!(sum>max)  d
	..s TimeRangeDesc=""
	..f  s TimeRangeDesc=$O(^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc)) q:(TimeRangeDesc="")!(sum>max)  d
	...s rowvalue=$G(^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc))
	...if retStr="" s retStr=rowvalue
	...else  s retStr=retStr_"!"_rowvalue
	...s sum=sum+1
	...k ^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc)	
	}
	s TableStr="科室@1500^号别@1500^职称@1500^时段@800^可挂数@1000^就诊地点@1500"
	s retStr=TableStr_"!"_retStr
	q retStr
}

/// w ##class(web.DHCVISRegShow).GetRegResouceCDYY()
ClassMethod GetRegResouceCDYY(ServerIP As %String = "", WindowNo As %String = "") As %String
{
	s retStr=""
	s LocStr=""
	s WindowNo=+WindowNo
	s max=4
	s UserId=1  //7289
	s GroupRowId=1  //53
	i ServerIP'="" d
	.s LocStr=""
	.s LocStr=$G(^DHCVISRegShowSet("IP",ServerIP))
	i LocStr="" d
	.s LocId=""
	.f  s LocId=$O(^CTLOC(0,"LocType","E",LocId)) q:LocId=""  d
	..i LocStr="" s LocStr=LocId
	..e  s LocStr=LocStr_"^"_LocId	
	s CreatFlag=0
	//i $D(^DHCVISRegShow(+$H,ServerIP))=0 
	s CreatFlag=1
	i WindowNo>0 k ^DHCVISRegShow
	f i=1:1:$L(LocStr,"^") {
		s LocRowId=$P(LocStr,"^",i)
		s TimeRange=7
		i $P($H,",",2)>43200 s TimeRange=8
		i TimeRange=7 s TimeRange=""
		s val="^"_UserId_"^^^"_TimeRange_"^^"_GroupRowId_"^"_LocRowId_"^^^0^"
		//s val=LocRowId_"^"_UserId_"^^^"_TimeRange_"^^"_GroupRowId_"^^false"
		s rs=##Class(%ResultSet).%New("web.DHCOPAdmRegA:OPDocList")
		i rs.QueryIsValid() { 
			Set Status=rs.Execute(val)
			Set columns = rs.GetColumnCount()
			If 'Status Quit
			While rs.Next() {
				s CTLocDesc=rs.GetData(20)
				i $P(CTLocDesc,"-",2)'="" s CTLocDesc=$P(CTLocDesc,"-",2)
				s MarkDesc=rs.GetData(2)
				s TypeDesc=rs.GetData(10)
				s RegFee=rs.GetData(11)
				s ExamFee=rs.GetData(13)
				s RegFee=RegFee+ExamFee
				//i RegFee<9 continue
				//s RegFee=rs.GetData(24)
				s AvailSeqNo=rs.GetData(21)
				s AppLoad=rs.GetData(4)
				s TimeRangeDesc=rs.GetData(28)
				s MarkDesc=MarkDesc   //_"("_TimeRangeDesc_")"
				//s AvailSeqNo=AvailSeqNo-AppLoad    //当前剩号=剩号-预约号
				i AvailSeqNo<0 s AvailSeqNo=0
				s RoomSite=""
				s RoomDr=""
				s ASRowId=rs.GetData(1)
				s ResRowId=$P(ASRowId,"||",1)
	 			s ASChildSub=$P(ASRowId,"||",2)
	 			i (ResRowId'="")&&(ASChildSub'="") s RoomDr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",5)
				i RoomDr'="" d
				.s RoomSite=$g(^CTLOC(RoomDr,"ADDR",1))
				.s RoomSite=$$ALPHAUP^SSUTIL4(RoomSite)
				.s CTLocDesc=$P($G(^CTLOC(RoomDr)),"^",2)
				i (CTLocDesc'="") d
				.i CreatFlag=1 	s ^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc)=CTLocDesc_"^"_MarkDesc_"^"_TypeDesc_"^"_TimeRangeDesc_"^"_AvailSeqNo_"^"_RoomSite
				.e  d
				..i $D(^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc))>0 s ^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc)=CTLocDesc_"^"_MarkDesc_"^"_TypeDesc_"^"_TimeRangeDesc_"^"_AvailSeqNo_"^"_RoomSite
			}
		}
	}
	k ^DHCVISRegShowQueue
	s index=1
	s CTLocDesc=""
	f  s CTLocDesc=$O(^DHCVISRegShow(+$H,ServerIP,CTLocDesc)) q:(CTLocDesc="")  d
	.s MarkDesc=""
	.f  s MarkDesc=$O(^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc)) q:(MarkDesc="")  d
	..s TimeRangeDesc=""
	..f  s TimeRangeDesc=$O(^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc)) q:(TimeRangeDesc="")  d
	...s rowvalue=$G(^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc))
	...q:rowvalue="" 
	...s ^DHCVISRegShowQueue(index)=rowvalue
	...s index=index+1
	s sum=1
	s index=""
	s index=$G(^DHCVISRegIndex(WindowNo))
	i $O(^DHCVISRegShowQueue(index))="" s index=""
	f  s index=$O(^DHCVISRegShowQueue(index)) q:(index="")!(sum>max)  d
	.s rowvalue=$G(^DHCVISRegShowQueue(index))
	.q:rowvalue=""
	.if retStr="" s retStr=rowvalue
	.else  s retStr=retStr_"!"_rowvalue
	.//s index=index+1
	.s ^DHCVISRegIndex(WindowNo)=index
	.s ^DHCVISRegIndex(0)=index
	.s sum=sum+1
	
	/*s sum=1
	s CTLocDesc=""
	f  s CTLocDesc=$O(^DHCVISRegShow(+$H,ServerIP,CTLocDesc)) q:(CTLocDesc="")!(sum>max)  d
	.s MarkDesc=""
	.f  s MarkDesc=$O(^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc)) q:(MarkDesc="")!(sum>max)  d
	..s TimeRangeDesc=""
	..f  s TimeRangeDesc=$O(^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc)) q:(TimeRangeDesc="")!(sum>max)  d
	...s rowvalue=$G(^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc))
	...if retStr="" s retStr=rowvalue
	...else  s retStr=retStr_"!"_rowvalue
	...s sum=sum+1
	...k ^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc)*/
		
	s TableStr="科室@1700^号别@1000^职称@1700^时段@600^已挂数@800^就诊地点@1880"
	s retStr=TableStr_"!"_retStr
	q retStr
}

/// w ##class(web.DHCVISRegShow).GetQQData()
/// ///s data = "{ [1]={"_a11_", "_a12_", "_a13_"},"_"row=1}"
ClassMethod GetQQData() As %String
{
    s n=0,j=0,i=1,oneData=""
    s n=$$GetResourceInfoZYYQQ^ShowReg("")
    s j=n
	s data=""
	s head="{"
	s oneHead="["
	s oneMiddle="]={"
	s oneTail="},"
	s tail="row="_n_"}"
	for i=1:1:j  d
	.s oneData=oneHead_i_oneMiddle_PLIST(i-1)_oneTail
	.if data="" s data=oneData
	.e  s data=data_oneData
	s data=head_data_tail
	q data
}

ClassMethod GetRR() As %String
{
	s i=0
	s data=""
	s head="{"
	s oneHead="["
	s oneMiddle="]={"
	s oneTail="},"
	s tail="row="+j+"}"
	for i=0:1:i+1 {
	s oneData=oneHead_i_oneMiddle_data[i]_oneTail	
	s data = "{ [1]={"_a11_", "_a12_", "_a13_"},"_"row=1}"
	}
    q data
}

ClassMethod GetDurgShow(orderType As %String = "R") As %String
{
    s n=0,j=0,i=1,oneData=""
    k ^DHCDurgItemTemp($j)
    s n=..GetDurgItemInfo(orderType)
    s j=n
	s data=""
	s head="{"
	s oneHead="["
	s oneMiddle="]={"
	s oneTail="},"
	s tail="row="_n_"}"
	for i=1:1:j  d
	.s oneData=oneHead_i_oneMiddle_^DHCDurgItemTemp($j,i)_oneTail
	.if data="" s data=oneData
	.e  s data=data_oneData
	s data=head_data_tail
	q data
}

ClassMethod GetDurgItemInfo(orderType As %String = "R") As %String
{
	s i=1
	s Subscript=""
	s Version=""
	i $G(^DHCVISDrugShow(+$h))'="" s Subscript=$P(^DHCVISDrugShow(+$h),",")
	f  s Subscript=$O(^ARCIM(Subscript)) q:(Subscript="")||(i>10)  d
	.s Version=""
	.i ($G(^DHCVISDrugShow(+$h))'="")&&(Subscript=$P(^DHCVISDrugShow(+$h),",")) d
	..i $P(^DHCVISDrugShow(+$h),",",2)'="" s Version=$P(^DHCVISDrugShow(+$h),",",2)
	.f  s Version=$O(^ARCIM(Subscript,Version)) q:(Version="")||(i>10)  d
	..s ItemDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2)
	..q:ItemDesc=""
	..i $P(ItemDesc,"}",2)'="" s ItemDesc=$P(ItemDesc,"}",2)
	..i $P(ItemDesc,"[",2)'="" s ItemDesc=$P(ItemDesc,"[")
	..i $P(ItemDesc,"(",2)'="" s ItemDesc=$P(ItemDesc,"(")
	..s OrCatDR=$p($g(^ARCIM(Subscript,Version,1)),"^",10)
	..q:OrCatDR=""
	..s EffDateTo=$p($g(^ARCIM(Subscript,Version,7)),"^",1)
	..q:EffDateTo'=""
	..s OrCatType=$p($g(^ARC("IC",OrCatDR)),"^",7)
	..q:OrCatType'=orderType
	..s flag=0
	..i orderType="N" d
	...s OECCatDR=$P($G(^ARC("IC",OrCatDR)),"^",8)
	...q:OECCatDR=""
	...s OECCatDesc=$P($G(^OEC("ORCAT",OECCatDR)),"^",2)
	...i OECCatDesc["材料" s flag=1
	..q:(orderType="N")&&(flag=0)
	..s ItemUomDR=$p($g(^ARCIM(Subscript,Version,8)),"^",14)
	..q:ItemUomDR=""
	..i ItemUomDR="" s ItemUom=""
	..e  s ItemUom=$P($G(^CT("UOM",ItemUomDR)),"^",2)
	..s arcimId=Subscript_"||"_Version
	..s ItemCost=+##CLASS(UDHCJFPRICE).GetOrderPrice("","",arcimId,+$H,"","","","")
	..q:+ItemCost=0
	..s ItemCost=$fn(ItemCost,"",4)
	..i $L(ItemCost)>8 s ItemCost=$E(ItemCost,1,8)
	..s ^DHCDurgItemTemp($j,i)=$c(34)_ItemDesc_$c(34)_","_$c(34)_ItemUom_$c(34)_","_$c(34)_ItemCost_$c(34)
	..s i=i+1
	i Version'="" i Version=$O(^ARCIM(Subscript,Version),-1)
	s ^DHCVISDrugShow(+$h)=Subscript_","_Version
	q i-1
}

ClassMethod GetLabShow() As %String
{
    s n=0,j=0,i=1,oneData=""
    k ^DHCLabItemTemp($j)
    s n=..GetLabItemInfo()
    s j=n
	s data=""
	s head="{"
	s oneHead="["
	s oneMiddle="]={"
	s oneTail="},"
	s tail="row="_n_"}"
	for i=1:1:j  d
	.s oneData=oneHead_i_oneMiddle_^DHCLabItemTemp($j,i)_oneTail
	.if data="" s data=oneData
	.e  s data=data_oneData
	s data=head_data_tail
	q data
}

/// w ##class(web.DHCVISRegShow).GetLabItemInfo()
ClassMethod GetLabItemInfo() As %String
{
	//^["LabData"]
	//^["websrc"]
    //^TEPIi("AUTHORISED",dt,labno)-----dt：日期，labno:标本号
   zn "LabData"
   s dt=+$H,num=1,tDeli=",",count=1,labno=""
   i $G(^["websrc"]DHCVISLabShow(+$h))'="" s labno=^["websrc"]DHCVISLabShow(+$h)
   k ^["websrc"]DHCLabItemTemp($j)
   f  s labno=$o(^TEPIi("AUTHORISED",dt,labno)) q:(labno="")||(num>10)  d
   .q:'$D(^TEPI(labno))  
   .s temstr=$g(^TEPI(labno))
   .;Patname
   .s temPName1=$p(temstr,"\",1),temPName2=$p(temstr,"\",2)
   .s temPName=temPName1
   .i temPName1'=temPName2 s temPName=temPName1_temPName2
   .s temPName=$c(34)_temPName_$c(34)
   .q:'$l(temPName)
   .s patType=$p(temstr,"\",48)
   .//q:patType="Y"  //去掉住院病人
   .s ts="" f  s ts=$o(^TEPIi("AUTHORISED",dt,labno,ts)) q:(ts="")||(num>10)  d
   ..s tscnt="" f  s tscnt=$o(^TEPIi("AUTHORISED",dt,labno,ts,tscnt)) q:(tscnt="")||(num>10)  d
   ...s temstr=$g(^TEPI(labno,1,ts,tscnt))
   ...s temPrint=$p(temstr,"\",28)
   ...q:temPrint="Y"
   ...s TSName=""
   ...i $d(^TTAB("TS",ts)) s TSName=$p(^TTAB("TS",ts),"\",1)
   ...q:TSName=""
   ...s TSName=$c(34)_TSName_$c(34)
   ...s authDate=$P(temstr,"\",4)
   ...s authTime=$P(temstr,"\",5)
   ...i count#2=0 d
   ....s $P(^["websrc"]DHCLabItemTemp($j,num),tDeli,3)=temPName
   ....s $P(^["websrc"]DHCLabItemTemp($j,num),tDeli,4)=TSName
   ....s num=num+1
   ...e  s ^["websrc"]DHCLabItemTemp($j,num)=temPName_tDeli_TSName_tDeli_tDeli
   ...s count=count+1
   s ^["websrc"]DHCVISLabShow(+$h)=labno
   zn "websrc"
   s ret=num-1
   q ret
}

}
