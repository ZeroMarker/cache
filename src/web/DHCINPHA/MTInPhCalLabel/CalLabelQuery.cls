/// Description:护士病区签收查询相关
/// Creator:    hulihua
/// CreateDate: 2017-04-25
/// Table:      DHC_PHBox、DHC_PHDraw、DHC_InPhReq
Class web.DHCINPHA.MTInPhCalLabel.CalLabelQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:获取时间段内有装箱签的科室列表
/// Creator:	hulihua
/// CreateDate:	2017-04-25
/// Table:      DHC_PHBox
/// Input:		每页行数、页数、箱号
/// Output:		计数器、病区科室ID、病区科室名称
/// Return：
/// Others:     
/// w ##class(web.DHCINPHA.MTInPhCalLabel.CalLabelQuery).GetLabelWardList("50","1","26/03/2017^^26/04/2017^94")
ClassMethod GetLabelWardList(rows, page, params) As %String
{
	n (rows, page,params)
	//s ^hlh($h)=$lb(rows, page,params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(params,"^",1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,"^",3)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s PhLoc=$p(params,"^",5)
	s ChkCancel=$p(params,"^",6)
	s pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"BoxList")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"DrawInci")
	s n=0,i=0
	f Date=StartDate:1:EndDate d
	.s WardLocId=""
	.f  s WardLocId=$o(^DHCPHBOXi(0,"CreateDatePhLocWrad",Date,PhLoc,WardLocId)) q:WardLocId=""  d 
	..s phbid=""
	..f  s phbid=$o(^DHCPHBOXi(0,"CreateDatePhLocWrad",Date,PhLoc,WardLocId,phbid)) q:phbid=""  d
	...s NoUseFlag=$p(^DHCPHBOX(phbid),"^",14)
	...q:NoUseFlag'=ChkCancel
	...s PhbStatus=$p(^DHCPHBOX(phbid),"^",13)
	...q:PhbStatus'=10
	...s phbno=$p(^DHCPHBOX(phbid),"^",1)
	...s phbnum=$p(^DHCPHBOX(phbid),"^",2)
	...s phaw=""
	...f  s phaw=$o(^DHCPHDRAWi("Box",phbid,phaw))  q:phaw=""  d
	....s ch=""
	....f  s ch=$o(^DHCPHDRAW(phaw,"INC",ch))  q:ch=""  d
	.....s inci=$p(^DHCPHDRAW(phaw,"INC",ch),"^",1)
	.....s CompPackFlag=$p(^DHCPHDRAW(phaw,"INC",ch),"^",12)
	.....q:CompPackFlag'="Y"
	.....i '$d(^TMP("DHCINPHA","web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"DrawInci",inci))  d
	......s ^TMP("DHCINPHA","web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"DrawInci",inci)=""
	......s i=i+1
	.....
	....
	...s incnum=i
	...s CreateDate=$p(^DHCPHBOX(phbid),"^",18)
	...s CreateDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CreateDate)	
	...s CreateTime=$p(^DHCPHBOX(phbid),"^",19)
	...s CreateTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(CreateTime)
	...s CreateDate=CreateDate_" "_CreateTime
	...s ReMark=$p(^DHCPHBOX(phbid),"^",20)
	...s n=n+1
	...s data1=$g(phbid)_"^"_$g(phbno)_"^"_$g(phbnum)_"^"_$g(CreateDate)_"^"_$g(incnum)
	...s data2=$g(PhLoc)_"^"_$g(ReMark)
	...s data=data1_"^"_data2
	...s index=WardLocId
	...s ^TMP("DHCINPHA","web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"BoxList",index,n)=data
	..
	.
	i n=0 d
	.d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"BoxList")
	.d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"DrawInci")
    q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
    w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
    s maxrow=n
    s count=0
    s index=""
    f  s index=$o(^TMP("DHCINPHA","web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"BoxList",index)) q:index=""  d
    .s WardLocId=index
    .s WardLoc=$p(^CTLOC(WardLocId),"^",2)
    .s mdata=pid_"^"_WardLocId_"^"_WardLoc
    .s count = count+1
	.s Title1="ProcessID^TWardLocId^TWardLoc"
	.s Title=Title1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"DrawInci")
	q ""
}

/// Description:获取装箱签详细信息
/// Creator:	hulihua
/// CreateDate:	2017-04-25
/// Table:      DHC_PHBox
/// Input:		每页行数、页数、计数器^病区科室ID
/// Output:		物流箱ID、箱号、箱数、装箱日期、药品品种数、计数器、病区科室ID、病区科室、发药科室ID
/// Return：
/// Others:     
/// w ##class(web.DHCINPHA.MTInPhCalLabel.CalLabelQuery).GetLabelInfoList("50","1","7^114")
ClassMethod GetLabelInfoList(rows, page, params) As %String
{
	n (rows, page, params)
	//s ^hlh($h)=$lb(rows, page,params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s pid=$p(params,"^",1)
	s WardLocId=$p(params,"^",2)
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(0) //输出json前缀串
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"BoxList",WardLocId,h)) q:h=""  d
	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"BoxList",WardLocId,h)
	.s phbid=$p(mdata,"^",1)
	.s phbno=$p(mdata,"^",2)
	.s phbnum=$p(mdata,"^",3)
	.s CreateDate=$p(mdata,"^",4)
	.s InciNum=$p(mdata,"^",5)
	.s DispLoc=$p(mdata,"^",6)
	.s ReMark=$p(mdata,"^",7)
	.s WardLoc=$p(^CTLOC(WardLocId),"^",2)
	.s listdata1=phbid_"^"_phbno_"^"_phbnum_"^"_CreateDate_"^"_InciNum
	.s listdata2=pid_"^"_WardLocId_"^"_WardLoc_"^"_DispLoc_"^"_ReMark
	.s listdata=listdata1_"^"_listdata2
	.s count = count+1
	.s Title1="TPhbId^TBoxNo^TPhbNum^TCreateDate^TInciNum"
	.s Title2="PID^TWardLocId^TWardLoc^TDispLoc^TReMark"
	.s Title=Title1_"^"_Title2
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,listdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,listdata)
	.
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	q ""
}

/// Description:撤销封箱贴表结构处理
/// Creator:	hulihua
/// CreateDate:	2017-04-26
/// Table:      DHC_PHBox、DHC_PHDraw、DHC_InPhReq
/// Input:		药房科室ID#物流箱ID
/// Output:
/// Return：    0-成功，非0-失败
/// Others:    
/// w ##class(web.DHCINPHA.MTInPhCalLabel.SqlDbCalLabel).HandleCalPhbox("")
ClassMethod HandleCalPhbox(params) As %String
{
	n (params)
	s phloc=$p(params,"#",1)
	s phboxid=$p(params,"#",2)
	q:(phloc="")||(phboxid="") -1
	s UserId=$p(params,"#",3)
	s NoUseFlag=$p(^DHCPHBOX(phboxid),"^",14)
	q:NoUseFlag="Y" -2
	s PhbStatus=$p(^DHCPHBOX(phboxid),"^",13)
	q:PhbStatus>10 -3
	s phawid="",phawidstr="",inpheqstr="",err=0
	f  s phawid=$o(^DHCPHDRAWi("Box",phboxid,phawid))  q:phawid=""  d
	.s phawstatu=$p(^DHCPHDRAW(phawid),"^",5)
	.q:phawstatu'=50
	.s phawidstr=$s(phawidstr="":phawid,1:phawidstr_"^"_phawid)
	.s inphreqid=""
	.f  s inphreqid=$o(^DHCINPHREQi("DispLocDrawId",phloc,phawid,inphreqid))  q:inphreqid=""  d
	..s inphreqstatu=$p(^DHCINPHREQ(inphreqid),"^",8)
	..q:inphreqstatu'=50
	..s inpheqstr=$s(inpheqstr="":inphreqid,1:inpheqstr_"^"_inphreqid)
	.
	q:(phawidstr="")||(inpheqstr="") -4
	s listdata=phboxid_"#"_phawidstr_"#"_inpheqstr
	s err=##class(web.DHCINPHA.MTInPhCalLabel.SqlDbCalLabel).HandleCalPhboxInfo(listdata)
	q:err'=0 err
	//以下为调用撤销配送接口
	s HospId=$p($g(^CTLOC(phloc)),"^",22)
	s Params="^"_phloc_"^"_inpheqstr_"^"_HospId
	s ParamPropStr=##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetParamProp(Params)
	s InvokPatchFlag=$p(ParamPropStr,"^",6)
	i InvokPatchFlag="Y"  d
	.s ret=##class(web.DHCSTInterfacePH).CancleDispatch(phboxid,UserId)
	.s:ret'=0 err=-5
	q err
}

/// Description:获取该装箱签的打印信息
/// Creator:	hulihua
/// CreateDate:	2017-04-26
/// Table:      DHC_PHBox、DHC_PHDraw
/// Input:		物流箱ID
/// Output:
/// Return：    箱号^箱信息^科室名称^封箱日期^药品品种数
/// Others:    
/// w ##class(web.DHCINPHA.MTInPhCalLabel.CalLabelQuery).GetPrintPhBoxInfo("4")
ClassMethod GetPrintPhBoxInfo(params As %String) As %String
{
	n (params)
	q:params="" ""
	s phbid=params
	s PhbNo=$p(^DHCPHBOX(phbid),"^",1)
	s PhbNum=$p(^DHCPHBOX(phbid),"^",2)
	s PhLoc=$p(^DHCPHBOX(phbid),"^",15)
	s WardLocId=$p(^DHCPHBOX(phbid),"^",16)
	s WardLoc=$p(^CTLOC(WardLocId),"^",1)
	s CreateDate=$p(^DHCPHBOX(phbid),"^",18)
	s CreateDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CreateDate)
	s pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"DrawInci")
    s phaw="",i=0
	f  s phaw=$o(^DHCPHDRAWi("Box",phbid,phaw))  q:phaw=""  d
	.s ch=0
	.f  s ch=$o(^DHCPHDRAW(phaw,"INC",ch))  q:ch=""  d
	..s inci=$p(^DHCPHDRAW(phaw,"INC",ch),"^",1)
	..i '$d(^TMP("DHCINPHA","web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"DrawInci",inci))  d
	...s ^TMP("DHCINPHA","web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"DrawInci",inci)=""
	...s i=i+1
	..
	.
	s InciNum=i
	S phboxid="",j=0
	F  S phboxid=$O(^DHCPHBOXi(0,"CreateDatePhLocWrad",+$h,PhLoc,WardLocId,phboxid))  Q:phboxid=""  D
	.S PhBoxUseFlag=$p(^DHCPHBOX(phboxid),"^",14)
	.Q:PhBoxUseFlag="Y"
	.S j=j+1
	S PbBoxNum=j
	S Data=PhbNo_"^"_PhbNum_"^"_WardLoc_"^"_CreateDate_"^"_InciNum_"^"_PbBoxNum
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"DrawInci")
	Q Data
}

/// Description:获取该装箱签的箱数用于C#循环打印的签数
/// Creator:	hulihua
/// CreateDate:	2017-04-26
/// Table:      DHC_PHBox
/// Input:		物流箱ID
/// Output:
/// Return：    该装箱签的箱数
/// Others:    
/// w ##class(web.DHCINPHA.MTInPhCalLabel.CalLabelQuery).GetPhBoxNum("4")
ClassMethod GetPhBoxNum(phbid As %String) As %String
{
	n (phbid)
	Q:phbid="" 0
	s PhbNum=$p(^DHCPHBOX(phbid),"^",2)
	Q PhbNum
}

/// Description:获取该装箱签的打印信息(C#版本用)
/// Creator:	hulihua
/// CreateDate:	2017-04-26
/// Table:      DHC_PHBox、DHC_PHDraw
/// Input:		物流箱ID#箱序号
/// Output:
/// Return：    箱号@箱信息@科室名称@封箱日期@药品品种数@补打标识
/// Others:    
/// w ##class(web.DHCINPHA.MTInPhCalLabel.CalLabelQuery).GetPrintPhBoxInfoC("7")
ClassMethod GetPrintPhBoxInfoC(params As %String) As %String
{
	n (params)
	q:params="" ""
	s phbid=$p(params,"#",1)
	s PhBoxNumber=$p(params,"#",2)
	s PhbNo=$p(^DHCPHBOX(phbid),"^",1)
	s PhbNum=$p(^DHCPHBOX(phbid),"^",2)
	s BarCode=$e(PhbNo,3,$l(PhbNo))_PhBoxNumber
	s PhLoc=$p(^DHCPHBOX(phbid),"^",15)
	s WardLocId=$p(^DHCPHBOX(phbid),"^",16)
	s WardCode=$p(^CTLOC(WardLocId),"^",87)
	s CreateDate=$p(^DHCPHBOX(phbid),"^",18)
	s CreateDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CreateDate)
	s pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"DrawInci")
    s phaw="",i=0
	f  s phaw=$o(^DHCPHDRAWi("Box",phbid,phaw))  q:phaw=""  d
	.s ch=0
	.f  s ch=$o(^DHCPHDRAW(phaw,"INC",ch))  q:ch=""  d
	..s inci=$p(^DHCPHDRAW(phaw,"INC",ch),"^",1)
	..i '$d(^TMP("DHCINPHA","web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"DrawInci",inci))  d
	...s ^TMP("DHCINPHA","web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"DrawInci",inci)=""
	...s i=i+1
	s InciNum=i_"笔"
	S phboxid="",j=0
	F  S phboxid=$O(^DHCPHBOXi(0,"CreateDatePhLocWrad",+$h,PhLoc,WardLocId,phboxid))  Q:phboxid=""  D
	.S PhBoxUseFlag=$p(^DHCPHBOX(phboxid),"^",14)
	.Q:PhBoxUseFlag="Y"
	.S j=j+1
	S PbBoxNum=j
	s PbBoxInfo=PhBoxNumber_"/"_PhbNum_"箱--"_PbBoxNum_"批"
	s RePrint="[补]"
	S Data="PhbNo@"_BarCode_"^PbBoxInfo@"_PbBoxInfo_"^WardLoc@"_WardCode_"^CreateDate@"_CreateDate_"^InciNum@"_InciNum_"^RePrint@"_RePrint
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"DrawInci")
	Q Data
}

/// Description:Kill临时global
/// Creator:	hulihua
/// CreateDate:	2017-04-27
/// Table:      
/// Input: 		pid-计数器     
/// Output:		
/// Return：
/// w ##class(web.DHCINPHA.MTInPhCalLabel.CalLabelQuery).KillTmp()
ClassMethod KillTmp(pid)
{
	n (pid)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetLabelWardList",pid,"BoxList")
	q ""
}

Storage Default
{
<Data name="CalLabelQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINPHAD043.CalLabelQueryD</DataLocation>
<DefaultData>CalLabelQueryDefaultData</DefaultData>
<IdLocation>^web.DHCINPHAD043.CalLabelQueryD</IdLocation>
<IndexLocation>^web.DHCINPHAD043.CalLabelQueryI</IndexLocation>
<StreamLocation>^web.DHCINPHAD043.CalLabelQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
