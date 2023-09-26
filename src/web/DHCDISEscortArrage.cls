Import SQLUSER

/// Creator:    congyue
/// CreateDate: 2017-02-15
/// Descript:   陪送申请查询安排
Class web.DHCDISEscortArrage Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Descript:	陪送申请单列表查询
/// Creator:    congyue
/// CreateDate: 2017-02-15
/// Table: 		DHC_DisRequest
/// Input:  	开始日期、截止日期、申请科室id、登记号、任务id、状态id
/// Return： 	陪送申请单 数据
/// Others:		w ##class(web.DHCDISEscortArrage).listDisRequest("1","10","2017-05-10^2017-05-10^^^^")
ClassMethod listDisRequest1(page = 1, rows = 10, param = "")
{
	n (page,rows,param)
	s End = page*rows
	s Start=(page-1)*rows+1
	s StDate=$p(param,"^",1)
	s EndDate=$p(param,"^",2)
	s ApplyLoc=$p(param,"^",3)
	s PatNo=$p(param,"^",4)
	s TaskID=$p(param,"^",5)
	s AffirmStatus=$p(param,"^",6)
	S WardDr=$p(param,"^",7)
	s StDate=$case(+StDate,0:+$h-100,:##class(web.DHCDISCommonDS).DateHtmlToLogical(StDate))  ;##class(web.DHCDISCommon).DateHtmlToLogical(StDate) $zdh(StDate,3)
	s EndDate=$case(+EndDate,0:+$h,:##class(web.DHCDISCommonDS).DateHtmlToLogical(EndDate))   ; $zdh(EndDate,3))
	s count=0
	w "{""rows"":["
	f date=StDate:1:EndDate d
	.s disreq=""
	.f  s disreq=$o(^DHCDISRE("0","CreateDate",date,disreq)) q:disreq=""  d
	..s disReqPatID=$p(^DHCDISRE(disreq),"^",5)
	..s disReqPatNo=""
	..s:disReqPatID'="" disReqPatNo=$p(^PAPER(disReqPatID,"PAT",1),"^",1)  //登记号
	..s disRecLoc=$p(^DHCDISRE(disreq),"^",6)
	..s disStatus=$p(^DHCDISRE(disreq),"^",16)
	..s disTaskID=$p(^DHCDISRE(disreq),"^",1)
	..s diswarddr=$p(^DHCDISRE(disreq),"^",2)
	..s distypeID=$p(^DHCDISRE(disreq),"^",18) //zhaowuqiang 陪送类型
	..s disWard="",disReqLoc=""
	..s:diswarddr'="" disWard=$p(^PAWARD(diswarddr),"^",2) //申请病区
	..s:diswarddr'="" disReqLoc=$p(^PAWARD(diswarddr),"^",5) //申请科室
	..s diswardBeddr=$p(^DHCDISRE(disreq),"^",3)
	..s disWardBed=""
	..s:diswardBeddr'="" disWardBed=$p(^PAWARD(+diswardBeddr,"BED",$p(diswardBeddr,"||",2)),"^",1) //病人床号
	..s disEscortTypedr=$p(^DHCDISRE(disreq),"^",9)
	..s disEscortType=""
	..s:disEscortTypedr'="" disEscortType=$p(^DHCDISTY(disEscortTypedr),"^",2) //陪送类型
	..s disEscortTooldr=$p(^DHCDISRE(disreq),"^",10)
	..s disEscortTool=""
	..s:disEscortTooldr'="" disEscortTool=$p(^DHCDISTO(disEscortTooldr),"^",2) //陪送工具
	..s disCreateUserdr=$p(^DHCDISRE(disreq),"^",15)
	..s disCreateUser=""
	..s:disCreateUserdr'="" disCreateUser=$p(^SSU("SSUSR",disCreateUserdr),"^",2) //创建人
	..s DisREQLocUser="",DPRowid=""
	..f  s DPRowid=$o(^DHCDISPE("0","TypePointer",distypeID,disreq,DPRowid)) q:DPRowid=""  d
	...s DPUserDr=$p(^DHCDISPE(DPRowid),"^",3)
	...s DPUser=$p(^SSU("SSUSR",DPUserDr),"^",2)
	...s:DPUser'="" DisREQLocUser=DPUser_"，"_DisREQLocUser
   	..q:(ApplyLoc'="")&&(disReqLoc'="")&&(ApplyLoc'=disReqLoc)
	..q:(PatNo'="")&&(PatNo'=disReqPatNo)
	..q:(TaskID'="")&&(TaskID'=disTaskID)
	..q:(AffirmStatus'="")&&(AffirmStatus'=disStatus)
	..q:(WardDr'="")&&(WardDr'=diswarddr)
    ..s count=count+1
	..q:count<Start
	..q:count>End
	..w $case(count,Start:"",:",")
	..s jsonObj=##class(web.DHCAPPJsonObject).%New()
	..d jsonObj.Put("DisREQ",disreq)
	..d jsonObj.Put("DisREQNo",disTaskID) //申请单号/ID
	..d jsonObj.Put("DisREQWard",disWard) //申请病区
	..d jsonObj.Put("DisREQWardBed",disWardBed) //病人床号
	..d jsonObj.Put("DisREQAdm",$p(^DHCDISRE(disreq),"^",4)) //病人就诊id
	..d jsonObj.Put("DisREQPatNo",disReqPatNo) //病人登记号
	..d jsonObj.Put("DisREQLoc", $p(^CTLOC(disRecLoc),"^",2)) //接收科室
	..d jsonObj.Put("DisREQExeDate",##class(web.DHCDISCommonDS).DateLogicalToHtml($p(^DHCDISRE(disreq),"^",7))) //陪送日期 $zd($p(^DHCDISRE(disreq),"^",7),3)
	..d jsonObj.Put("DisREQExeTime",$zt($p(^DHCDISRE(disreq),"^",8))) //陪送时间
	..d jsonObj.Put("DisREQEscortType",disEscortType) //陪送类型
	..d jsonObj.Put("DisREQEscortTool",disEscortTool) //陪送工具
	..d jsonObj.Put("DisREQNums",$p(^DHCDISRE(disreq),"^",11)) //陪送人数
	..d jsonObj.Put("DisREQRemarks",$p(^DHCDISRE(disreq),"^",12)) //备注
	..d jsonObj.Put("DisREQCreateDate",##class(web.DHCDISCommonDS).DateLogicalToHtml($p(^DHCDISRE(disreq),"^",13))) //创建日期 $zd($p(^DHCDISRE(disreq),"^",13),3)
	..d jsonObj.Put("DisREQCreateTime",$zt($p(^DHCDISRE(disreq),"^",14))) //创建时间
	..d jsonObj.Put("DisREQCreateUser",disCreateUser) //创建人
	..i +disStatus'=0 d jsonObj.Put("DisREQCurStatus",$p(^DHCDISSA(disStatus),"^",2)) //陪送状态
	..d jsonObj.Put("DisREQLocUser",DisREQLocUser) //陪送人员
	..w jsonObj.Json()
	w "],""total"":"_count_"}"
	q ""
}

/// Descript:	陪送申请单明细列表查询
/// Creator:    congyue
/// CreateDate: 2017-02-15
/// Table: 		DHC_DisRequestItm
/// Input:  	主表id
/// Return： 	陪送申请单 数据
/// Others:		w ##class(web.DHCDISEscortArrage).listGoodsRequestItm("1","10","97")
ClassMethod listGoodsRequestItm(page = 1, rows = 10, disreq = "")
{
	n (page,rows,disreq)
	s End = page*rows
	s Start=(page-1)*rows+1
	s count=0
	Q:disreq="" "{""rows"":[],""total"":"_count_"}"
	w "{""rows"":["
	s disreqi=""
	f  s disreqi=$o(^DHCDISRE(disreq,"Itm",disreqi)) q:disreqi=""  d
    .s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.s jsonObj=##class(web.DHCAPPJsonObject).%New()
	.s itemdr=$p(^DHCDISRE(disreq,"Itm",disreqi),"^",1)
	.s itemType=$p(^DHCDISRE(disreq,"Itm",disreqi),"^",2)
	.s item=""
	.i itemType="Ord" d
	..s ord=+itemdr
	..s orditm=$p(itemdr,"||",2)
	..s arcitm=$p(^OEORD(ord,"I",orditm,1),"^",2)
	..s item=$p(^ARCIM(+arcitm,$p(arcitm,"||",2),1),"^",2)
	.s:itemType="Oth" item=$p(^DHCDISLI(itemdr),"^",2)
	.s recloc=$p(^DHCDISRE(disreq,"Itm",disreqi),"^",3)
	.s LocDesc=""
	.s:recloc'="" LocDesc=$p(^CTLOC(recloc),"^",2)
	.s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)
	.i LocDesc=""  d
	..s LocDR=$p(^DHCDISRE(disreq),"^",6)
	..s:LocDR'="" LocDesc=$p(^CTLOC(LocDR),"^",2)
	.d jsonObj.Put("DISREQI",disreq_"||"_disreqi)
	.d jsonObj.Put("ItemDR",itemdr)
	.d jsonObj.Put("ExeLocDR",recloc)
	.d jsonObj.Put("Item",item)
	.d jsonObj.Put("ExeLoc",LocDesc)
	.d jsonObj.Put("ItemType",itemType)
	.w jsonObj.Json()
	w "],""total"":"_count_"}"
	q ""
}

/// Descript:	陪送申请查询安排 所在病区护工列表
/// Creator:    congyue
/// CreateDate: 2017-02-21
/// Table: 		
/// Input:  	locId StatusType:0 空闲，1 忙碌
/// Return： 	所在病区护工列表 数据
/// Others:		w ##class(web.DHCDISEscortArrage).QueryWardNurList("1","10","114","1","18")
ClassMethod QueryWardNurList(page = 1, rows = 10, locId, StatusType, Typeid)
{
	n (page,rows,locId,StatusType,Typeid)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	s h=0,count=0
    S pid=..NewPid()
    K ^TMP("DHCDIS","web.DHCDISEscortArrage","QueryWardNurList",pid)
    ;s typeID=$o(^DHCDISTA(0,"Code","陪送",""))
    s:Typeid="" Typeid=0
	s LURowid="" ,AllNum=0 // 陪送科室人员表 id
	f  s LURowid=$o(^DHCDISLU(0,"Loc",locId,LURowid)) q:LURowid=""  d
	.q:+LURowid=0
	.s jsonObj=##class(web.DHCAPPJsonObject).%New()
	.s LULocDr=$p(^DHCDISLU(LURowid),"^",1)
	.s LUUserDr=$p(^DHCDISLU(LURowid),"^",2)
	.s LUUserCode=$p(^SSU("SSUSR",LUUserDr),"^",1)
	.s LUUser=$p(^SSU("SSUSR",LUUserDr),"^",2)
	.s LUStatus=$p(^DHCDISLU(LURowid),"^",4)
	.s AllNum=$p(^DHCDISLU(LURowid),"^",5)
	.q:LULocDr'=locId
	.q:LUStatus'=StatusType
	.s DPRowid="" ,DPPointer="" ,AllSorces=0, ReqCreateDate="",Num=0  //配送 陪送人员表 id
	.f  s DPPointer=$o(^DHCDISPE("0","TypePointer",Typeid,DPPointer)) q:DPPointer=""  d
	..q:'$d(^DHCDISRE(DPPointer))
	..f  s DPRowid=$o(^DHCDISPE("0","TypePointer",Typeid,DPPointer,DPRowid)) q:DPRowid=""  d
	...s DPUserDr=$p(^DHCDISPE(DPRowid),"^",3)
	...s REQCurStatusDr=$p(^DHCDISRE(DPPointer),"^",16)
	...s REQCurStatus=""
	...S:REQCurStatusDr'="" REQCurStatus=$p(^DHCDISSA(REQCurStatusDr),"^",1)
	...q:DPUserDr'=LUUserDr
	...q:REQCurStatus="15" ;报告已完成状态 
	...s ReqCreateDate=$p(^DHCDISRE(DPPointer),"^",13)
	...s:ReqCreateDate'="" ReqCreateDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(ReqCreateDate) //hxy 2017-03-29 $zd(ReqCreateDate,3)
	...s Num=Num+1
	..s RARowid="",Sorce=0  //评价表 id
	..f  s RARowid=$o(^DHCDISRA(0,"TypePointer",Typeid,+DPPointer,RARowid)) q:RARowid=""  d
	...q:+RARowid=0 
	...s Sorce=$p(^DHCDISRA(RARowid),"^",3)
	...s:Sorce'="" AllSorces=Sorce+AllSorces
	...
	.S UserList=""
	.S:StatusType=1 UserList=LUUser_"("_Num_"个)"
	.S:StatusType=0 UserList=LUUser 
	.S h=h+1
	.S TempStr=LURowid_"^"_AllSorces_"^"_LUUserCode_"^"_UserList_"^"_ReqCreateDate_"^"_AllNum_"^"_LUUserDr
	.S ^TMP("DHCDIS","web.DHCDISEscortArrage","QueryWardNurList",pid,AllNum,h)=TempStr

	Q:h=0 "{""rows"":[],""total"":"_count_"}" //输出json结尾符，如果这个h为0的时候补输出回去，结果回事datagrid显示有误
	
	///转换数据为Json格式
	S Title="id^Score^UserCode^User^Desc^AllNum^UserDr"
	s h=0,count=0
	S index="",AllNum=""
	w "{""rows"":["
	F  S AllNum=$o(^TMP("DHCDIS","web.DHCDISEscortArrage","QueryWardNurList",pid,AllNum)) Q:AllNum=""  D
	.F  S index=$o(^TMP("DHCDIS","web.DHCDISEscortArrage","QueryWardNurList",pid,AllNum,index)) Q:index=""  D
	..S mdate=$g(^TMP("DHCDIS","web.DHCDISEscortArrage","QueryWardNurList",pid,AllNum,index))
	..S count = count+1
	..I count=1 D   //有开始值和结束值
	...W ##class(web.DHCAPPJsonCommon).getJsonData(Title,mdate)
	..E  D
	...W ","_##class(web.DHCAPPJsonCommon).getJsonData(Title,mdate) //逗号在这加着呢
	..
	.
	w "],""total"":"_count_"}"

	K ^TMP("DHCDIS","web.DHCDISEscortArrage","QueryWardNurList",pid)
	Q ""
}

/// Descript:	陪送申请查询安排 其他护工列表
/// Creator:    congyue
/// CreateDate: 2017-02-22
/// Table: 		
/// Input:  	locId 
/// Return： 	其他护工列表 数据
/// Others:		w ##class(web.DHCDISEscortArrage).QueryOthNurList("1","10","144","0","18")
ClassMethod QueryOthNurList(page = 1, rows = 10, locId, StatusType, Typeid)
{
	n (page,rows,req,locId, StatusType,Typeid)
	s End = page*rows
	s Start=(page-1)*rows+1
	s h=0,count=0
    S pid=..NewPid()
    K ^TMP("DHCDIS","web.DHCDISEscortArrage","QueryOthNurList",pid)
    ;s typeID=$o(^DHCDISTA(0,"Code","陪送",""))
    s:Typeid="" Typeid=0
	s LURowid="" ,AllNum=0 // 陪送科室人员表 id
	f  s LURowid=$o(^DHCDISLU(LURowid)) q:LURowid=""  d
	.q:+LURowid=0
	.s jsonObj=##class(web.DHCAPPJsonObject).%New()
	.s LULocDr=$p(^DHCDISLU(LURowid),"^",1)
	.s LUUserDr=$p(^DHCDISLU(LURowid),"^",2)
	.s LUUserCode=$p(^SSU("SSUSR",LUUserDr),"^",1)
	.s LUUser=$p(^SSU("SSUSR",LUUserDr),"^",2)
	.s LUStatus=$p(^DHCDISLU(LURowid),"^",4)
	.s AllNum=$p(^DHCDISLU(LURowid),"^",5)
	.q:LULocDr=locId
	.q:LUStatus'=StatusType
	.s DPRowid="" ,DPPointer="" ,AllSorces=0, ReqCreateDate="",Num=0 //配送 陪送人员表 id
	.f  s DPPointer=$o(^DHCDISPE("0","TypePointer",Typeid,DPPointer)) q:DPPointer=""  d
	..q:'$d(^DHCDISRE(DPPointer))
	..f  s DPRowid=$o(^DHCDISPE("0","TypePointer",Typeid,DPPointer,DPRowid)) q:DPRowid=""  d
	...s DPUserDr=$p(^DHCDISPE(DPRowid),"^",3)
	...s REQCurStatusDr=$p(^DHCDISRE(DPPointer),"^",16)
	...s REQCurStatus=""
	...S:REQCurStatusDr'="" REQCurStatus=$p(^DHCDISSA(REQCurStatusDr),"^",1)
	...q:DPUserDr'=LUUserDr
	...q:REQCurStatus="15" ;报告已完成状态 
	...s ReqCreateDate=$p(^DHCDISRE(DPPointer),"^",13)
	...s:ReqCreateDate'="" ReqCreateDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(ReqCreateDate) //$zd(ReqCreateDate,3)
	...s Num=Num+1
	..s RARowid="",Sorce=0  //评价表 id
	..f  s RARowid=$o(^DHCDISRA(0,"TypePointer",Typeid,+DPPointer,RARowid)) q:RARowid=""  d
	...q:+RARowid=0 
	...s Sorce=$p(^DHCDISRA(RARowid),"^",3)
	...s:Sorce'="" AllSorces=Sorce+AllSorces
	..
	.S UserList=""
	.S:StatusType=1 UserList=LUUser_"("_Num_"个)"
	.S:StatusType=0 UserList=LUUser 
	.S h=h+1
	.S TempStr=LURowid_"^"_AllSorces_"^"_LUUserCode_"^"_UserList_"^"_ReqCreateDate_"^"_AllNum_"^"_LUUserDr
	.S ^TMP("DHCDIS","web.DHCDISEscortArrage","QueryOthNurList",pid,AllNum,h)=TempStr
	
	Q:h=0 "{""rows"":[],""total"":"_count_"}" //输出json结尾符，如果这个h为0的时候补输出回去，结果回事datagrid显示有误
	
	///转换数据为Json格式
	S Title="id^Score^UserCode^User^Desc^AllNum^UserDr"
	s h=0,count=0
	S index="",AllNum=""
	w "{""rows"":["
	F  S AllNum=$o(^TMP("DHCDIS","web.DHCDISEscortArrage","QueryOthNurList",pid,AllNum)) Q:AllNum=""  D
	.F  S index=$o(^TMP("DHCDIS","web.DHCDISEscortArrage","QueryOthNurList",pid,AllNum,index)) Q:index=""  D
	..S mdate=$g(^TMP("DHCDIS","web.DHCDISEscortArrage","QueryOthNurList",pid,AllNum,index))
	..S count = count+1
	..I count=1 D   //有开始值和结束值
	...W ##class(web.DHCAPPJsonCommon).getJsonData(Title,mdate)
	..E  D
	...W ","_##class(web.DHCAPPJsonCommon).getJsonData(Title,mdate) //逗号在这加着呢
	..
	.
	w "],""total"":"_count_"}"

	K ^TMP("DHCDIS","web.DHCDISEscortArrage","QueryOthNurList",pid)
	Q ""
}

/// Descript:	陪送申请查询安排 指定人员(下拉框)
/// Creator:    congyue
/// CreateDate: 2017-02-23
/// Table: 		
/// Input:  	
/// Return： 	combobox科室配送人员 
/// Others:		w ##class(web.DHCDISEscortArrage).LocUserCombo()
ClassMethod LocUserCombo(q = "")
{
	n (q)	
	s End = 10
	s Start=1
	s Count=0
	s q=$ZCONVERT(q,"U")
	w "["
	s su=0
	f  s su = $o(^DHCDISLU(su)) q:su=""  d
	.s status=$p(^DHCDISLU(su),"^",3)
	.q:status'="Y"
	.s id=$p(^DHCDISLU(su),"^",2)
	.s name=$p(^SSU("SSUSR",id),"^",2)
	.s name=$ZCONVERT(name,"U")
	.q:(q'="")&&($f(name,q)=0)
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",id_"^"_name)
	w "]"
	q ""
}

/// Descript:	陪送申请查询安排 指定人员(下拉数据表格)
/// Creator:    congyue
/// CreateDate: 2017-02-23
/// Table: 		
/// Input:  	
/// Return： 	combogrid科室配送人员 
/// Others:	w ##class(web.DHCDISEscortArrage).LocUserComboGrid("6","1","10")
ClassMethod LocUserComboGrid(q, page = 1, rows = 10)
{
	n (q,page, rows)
	s End = page*rows
	s Start=(page-1)*rows+1
	s Count=0
	s q=$ZCONVERT(q,"U")
	w "{""rows"":["
	s su=0
	f  s su = $o(^DHCDISLU(su)) q:su=""  d
	.s status=$p(^DHCDISLU(su),"^",3)
	.q:status'="Y"
	.s id=$p(^DHCDISLU(su),"^",2)
	.s UserCode=$p(^SSU("SSUSR",id),"^",1)
	.s name=$p(^SSU("SSUSR",id),"^",2)
	.s name=$ZCONVERT(name,"U")
	.s UserCode=$ZCONVERT(UserCode,"U")
	.q:(q'="")&&(($f(name,q)=0)&&($f(UserCode,q)=0))
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
	.s tmp=id_"^"_UserCode_"^"_name
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^UserCode^name",tmp)
	w "],""total"":"_Count_"}"
	q ""
}

/// Descript:	陪送申请查询安排 已选护工列表
/// Creator:    congyue
/// CreateDate: 2017-02-23
/// Table: 		
/// Input:  	disreqID:申请单id     reqtype:0 陪送，1 配送
/// Return： 	已选护工列表 
/// Others:	w ##class(web.DHCDISEscortArrage).QueryLocUserList("1","6","294","陪送")
ClassMethod QueryLocUserList(page = 1, rows = 10, disreqID, reqtypeid)
{
	n (page,rows,disreqID, reqtypeid)
	s End = page*rows
	s Start=(page-1)*rows+1
	;s typeID=$o(^DHCDISTA(0,"Code","陪送",""))
	s count=0
	Q:disreqID=""||reqtypeid="" "{""rows"":[],""total"":"_count_"}"
	w "{""rows"":["
	s DPRowid="" //配送 陪送人员表 id
	f  s DPRowid=$o(^DHCDISPE("0","TypePointer",reqtypeid,disreqID,DPRowid)) q:DPRowid=""  d
	.q:+DPRowid=0
	.s jsonObj=##class(web.DHCAPPJsonObject).%New()
	.s DPUserDr=$p(^DHCDISPE(DPRowid),"^",3)
	.s UserCode=$p(^SSU("SSUSR",DPUserDr),"^",1)
	.s User=$p(^SSU("SSUSR",DPUserDr),"^",2)
    .s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.d jsonObj.Put("DPRowid",DPRowid)
	.d jsonObj.Put("ID",DPUserDr)
	.d jsonObj.Put("UserCode",UserCode)
	.d jsonObj.Put("User",User)
	.w jsonObj.Json()
	w "],""total"":"_count_"}"
	q ""
}

/// Descript:	接受,拒绝操作
/// Creator:    congyue
/// CreateDate: 2017-02-21
/// Table: 		
/// Input:  	pointer:陪送id, type:陪送id, status:状态Code 12 接受,98 拒绝, lgUser:操作用户id, reason:拒绝原因id, locId:操作科室id
/// Return： 	0 操作成功 非0 操作失败
/// Others:		w ##class(web.DHCDISEscortArrage).StatusOperat(157,"陪送",12,4)
ClassMethod StatusOperat(pointer, typeid, status, lgUser)
{
	n (pointer,typeid,status,lgUser)
	Q:(pointer="")||(typeid="")||(status="")||(lgUser="") -99 //入参不可为空
	;s typeID=$o(^DHCDISTA(0,"Code",type,""))
	q:typeid="" "无操作权限"
	s statusid=$o(^DHCDISSA("0","TypeCode",typeID,"Y","Y",status,""))
	q:statusid="" "无权限"
	s ret=##class(web.DHCDISRequestCom).updateStatus(pointer,typeID,statusid,lgUser)
	q:ret'=0 ret
	q 0
}

/// Descript:	安排指定人员操作
/// Creator:    congyue
/// CreateDate: 2017-02-24
/// Table: 		
/// Input:  	pointer:陪送id, type:0陪送, status:状态Code 12 接受,98 拒绝, lgUser:操作用户id, reason:拒绝原因id, locId:操作科室id, 
/// 			LocUserList:指定人员列表 以$c(1)分割, 人员id^人员工号^人员姓名
/// Return： 	0 操作成功 非0 操作失败
/// Others:		w ##class(web.DHCDISEscortArrage).ArrangeDisReq(277,9,11,4,"Y","","83^239^何明$c(1)82^717^庞琳","待处理")
ClassMethod ArrangeDisReq(pointer, type, statuscode, lgUser, EmFlag, reason = "", LocUserList, curStatus)
{
	n (pointer,type,statuscode,lgUser,EmFlag,reason,LocUserList,curStatus)
	s ret=0
	Q:(pointer="")||(type="")||(statuscode="")||(lgUser="") -99 //入参不可为空
	;s statusid=""
	;s typeID=$o(^DHCDISTA(0,"Code",type,""))
	;q:typeID="" "无操作权限"
	;s statusid=$o(^DHCDISSA("0","TypeCode",typeID,"Y","Y",status,""))
	;q:statusid="" "无权限"
	TS
	i LocUserList'=""  d
	.s len=$L(LocUserList,"$c(1)")
	.f i=1:1:len d
	..s TmpStr=$p(LocUserList,"$c(1)",i)
	..s ret=..insDisPeople(pointer,type,TmpStr)
	i ret'=0 tro
	q:ret'=0 "安排人员保存失败"
	
	i curStatus'="拒绝"  d
	.s ret=##class(web.DHCDISRequestCom).updateStatus(pointer,type,statuscode,lgUser,EmFlag,reason)
	.i ret'=0 tro
	.q:ret'=0 
	e  d
	.s ret=..refuseUpdateStatus(pointer,type,statuscode,lgUser,EmFlag,reason)
	.i ret'=0 tro
	.q:ret'=0
	
	q:ret'=0 ret

	TC
	q ret
}

ClassMethod refuseUpdateStatus(pointer, type, statuscode, lgUser, reason)
{
	n (pointer,type,statuscode,lgUser,reason)
	
	s status=##class(web.DHCDISRequestCom).GetStatusID(statuscode,type)
	/// 保存操作流水表
	s ret=##class(web.DHCDISRequestCom).saveRequestSta(pointer,type,status,lgUser,reason)
	q:ret'=0 "-1^保存操作流水表失败"
	/// 更新配送配送表状态
 	s ret=##class(web.DHCDISRequestCom).updateRequestStatus(pointer,type,status)
	q:ret'=0 "-2^更新配送配送表状态失败"
	/// 更新配送陪送人员忙碌空闲状态
 	s ret=##class(web.DHCDISRequestCom).updatePeopleStatus(pointer,type,status)
	q:ret'=0 "-3^更新人员状态失败"
	q 0
}

/// Descript:	保存安排指定人员
/// Creator:    congyue
/// CreateDate: 2017-02-24
/// Table: 		
/// Input:  	pointer:陪送id, type:0陪送, TmpStr:人员id^人员工号^人员姓名
/// Return： 	0 操作成功 非0 操作失败
/// Others:		w ##class(web.DHCDISEscortArrage).insDisPeople(32,0,"")
ClassMethod insDisPeople(pointer, type, TmpStr)
{
	n (pointer,type,TmpStr)
	s Userdr=$p(TmpStr,"^",1)
	;s:type="陪送" type=0
	s Err=0
	TS
	s LURowId=""
 	f  s LURowId=$o(^DHCDISLU("0","User",Userdr,LURowId)) q:LURowId=""  d
 	.s LUStatus=1
 	.s LUWorkload=$p(^DHCDISLU(LURowId),"^",5)
 	.s LUWorkload=LUWorkload+1
 	.&SQL(UPDATE DHC_DisLocUser SET LU_Status=:LUStatus,LU_Workload=:LUWorkload where LU_RowId=:LURowId)
	.i SQLCODE'=0 tro
	.s:+$g(SQLCODE)'=0 Err=SQLCODE
 	.q:+$g(Err)'=0
 	q:Err'=0 Err
	
	s DPRowid="",DPflag=0 ;cy  DPflag -1该申请单表示陪送人员重复
	f  s DPRowid=$o(^DHCDISPE("0","TypePointer",type,pointer,DPRowid)) q:(DPRowid="")  d 
	.s DPUserDr=$p(^DHCDISPE(DPRowid),"^",3)
	.s:DPUserDr=Userdr DPflag=-1
	.q:DPflag=-1
	i DPflag'=-1  d
 	.&SQL(INSERT INTO DHC_DisPeople(DP_ReqType,DP_Pointer,DP_User_Dr) VALUES(:type,:pointer,:Userdr))
	.i +$g(SQLCODE)'=0 tro
	.s:+$g(SQLCODE)'=0 Err=SQLCODE
	.q:+$g(Err)'=0
 	q:Err'=0 Err
	TC
	q 0
}

/// Descript:	陪送申请单列表查询
/// Creator:    congyue
/// CreateDate: 2017-02-15
/// Table: 		DHC_DisRequest
/// Input:  	开始日期、截止日期、申请科室id、登记号、任务id、状态id
/// Return： 	陪送申请单 数据
/// Others:		w ##class(web.DHCDISEscortArrage).listDisRequest("1","10","19/11/2018^19/11/2018^^^^1^^")
ClassMethod listDisRequest(page, rows, param = "")
{
	n (page,rows,param)
	s Start=(page-1)*rows+1
	s End = page*rows
    S pid=..NewPid()
    K ^TMP("DHCDIS","web.DHCDISEscortArrage","listDisRequest",pid)
	s StDate=$p(param,"^",1)
	s EndDate=$p(param,"^",2)
	s ApplyLoc=$p(param,"^",3)
	s PatNo=$p(param,"^",4)
	s TaskID=$p(param,"^",5)
	s AffirmStatus=$p(param,"^",6)
	S WardDr=$p(param,"^",7)
	;S TypeID=$p(param,"^",8)
	S HosNo=$p(param,"^",8)
	s HospID=$p(param,"^",9)
	;s StDate=##class(web.DHCDISCommonDS).DateHtmlToLogical(StDate)
	;s EndDate=##class(web.DHCDISCommonDS).DateHtmlToLogical(EndDate)
	s StDate=$case(+StDate,0:+$h-100,:##class(web.DHCDISCommonDS).DateHtmlToLogical(StDate))  ; $zdh(StDate,3)
	s EndDate=$case(+EndDate,0:+$h,:##class(web.DHCDISCommonDS).DateHtmlToLogical(EndDate))   ; $zdh(EndDate,3))
	s count=0
	s h=0
	f date=EndDate:-1:StDate d
	.s disreq=""
	.f  s disreq=$o(^DHCDISRE("0","CreateDate",date,disreq),-1) q:disreq=""  d
	..s disReqPatID=$p(^DHCDISRE(disreq),"^",5)
	..s AdmDr=$p(^DHCDISRE(disreq),"^",4) //病人就诊id 
	..s Papmi=$p(^PAADM(AdmDr),"^",1)
	..s DisHosNo="",DisREQPatNo=""
	..;s:Papmi'="" DisHosNo=$p(^PAPER(Papmi,"PAT",1),"^",22)  //住院号
	..s DisHosNo=##class(web.DHCDISInterface).GetMrNoByEpisodeID(AdmDr)  //sufan 20200507
	..s:Papmi'="" DisREQPatNo=$p(^PAPER(Papmi,"PAT",1),"^",1)        //登记号
	..q:(HosNo'="")&&(DisHosNo'=HosNo)
	..s disRecLoc=$p(^DHCDISRE(disreq),"^",6)
	..s disStatus=$p(^DHCDISRE(disreq),"^",16)
	..s disTaskID=$p(^DHCDISRE(disreq),"^",1)
	..s diswarddr=$p(^DHCDISRE(disreq),"^",2)
	..s distypeID=$p(^DHCDISRE(disreq),"^",18) //zhaowuqiang 陪送类型
	..s disWard="",disReqLoc=""
	..s:diswarddr'="" disWard=$p(^PAWARD(diswarddr),"^",2) //申请病区
	..s:diswarddr'="" disReqLoc=$p(^PAWARD(diswarddr),"^",5) //申请科室
	..s diswardBeddr=$p(^DHCDISRE(disreq),"^",3)
	..s disWardBed=""
	..s disWardBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(AdmDr) //病人床号
	..s disEscortTypedr=""
	..s disEscortTypedr=$p(^DHCDISRE(disreq),"^",9)
	..q:disEscortTypedr=""
	..s disEscortType=""
	..s:disEscortTypedr'="" disEscortType=$p($g(^DHCDISTY(disEscortTypedr)),"^",2) //陪送类型
	..s disEscortTooldr=$p(^DHCDISRE(disreq),"^",10)
	..s disEscortTool=""
	..s:disEscortTooldr'="" disEscortTool=$p(^DHCDISTO(disEscortTooldr),"^",2) //陪送工具
	..s disCreateUserdr=$p(^DHCDISRE(disreq),"^",15)
	..s disCreateUser=""
	..s:disCreateUserdr'="" disCreateUser=$p(^SSU("SSUSR",disCreateUserdr),"^",2) //创建人
	..s disStatusDesc=""
	..s:disStatus'="" disStatusDesc=$p(^DHCDISSA(disStatus),"^",2)
	..s AsseId=$o(^DHCDISRA(0,"TypePointer",distypeID,disreq,""))
	..s AssNumber=""
	..s AssRemarks=""
	..i AsseId'="" s AssNumber=$p(^DHCDISRA(AsseId),"^",3)
	..i AsseId'="" s AssRemarks=$p(^DHCDISRA(AsseId),"^",4)
	..s ReqHospID=$p(^DHCDISRE(disreq),"^",20)
	..q:(HospID'="")&&(ReqHospID'=HospID)
	..i disStatusDesc'="待处理"  d
	...s DPRowid="",DisREQLocUser="",DisREQLocUser="",Phone="",DPUserDr=""  //待处理的申请单默认护工 zwq
	...f  s DPRowid=$o(^DHCDISPE("0","TypePointer",distypeID,disreq,DPRowid)) q:DPRowid=""  d
	....s DPUserStatus=$p(^DHCDISPE(DPRowid),"^",4)
	....q:DPUserStatus=-1   //过滤掉撤销安排的人员
	....s DPUserDr=$p(^DHCDISPE(DPRowid),"^",3)
	....s DisREQLocUser=""
	....s:DPUserDr'="" DisREQLocUser=$p(^SSU("SSUSR",DPUserDr),"^",2)  //陪送人员
	....s CareProvDR=$p(^SSU("SSUSR",DPUserDr),"^",14)
	....s:CareProvDR'="" Phone=$p($g(^CTPCP(CareProvDR,3)),"^",6)      //陪送人员电话
	....
	..e  d
	...s UserBack=..GetThisLocUser(disReqLoc)
	...i UserBack'=""  d
	....s DPUserDr=UserBack
	....s DisREQLocUser=$p(^SSU("SSUSR",DPUserDr),"^",2)  //陪送人员
	....s CareProvDR=$p(^SSU("SSUSR",DPUserDr),"^",14)
	....s Phone=""
	....s:CareProvDR'="" Phone=$p($g(^CTPCP(CareProvDR,3)),"^",6)      //陪送人员电话
	...e  d
	....s DPUserDr=""
	....s DisREQLocUser=""
	....s Phone=""
	...
   	..;q:(ApplyLoc'="")&&(disReqLoc'="")&&(ApplyLoc'=disReqLoc)
   	..q:(ApplyLoc'="")&&(ApplyLoc'=disReqLoc)
	..q:(PatNo'="")&&(PatNo'=DisREQPatNo)
	..q:(TaskID'="")&&(TaskID'=disTaskID)
	..q:((AffirmStatus'="")&&(AffirmStatus'="0"))&&(AffirmStatus'=disStatus)
	..q:(WardDr'="")&&(WardDr'=diswarddr)
	..S DisREQAdm=$p(^DHCDISRE(disreq),"^",4) //病人就诊id
	..S Papmi=$p(^PAADM(DisREQAdm),"^",1)
	..S disName=$p(^PAPER(Papmi,"ALL"),"^",1)
	..S DisREQLoc=""
	..S:disRecLoc'="" DisREQLoc=$p(^CTLOC(disRecLoc),"^",2) //接收科室
	..S DisREQExeDate=##class(web.DHCDISCommonDS).DateLogicalToHtml($p(^DHCDISRE(disreq),"^",7)) //陪送日期 $zd($p(^DHCDISRE(disreq),"^",7),3)
	..S DisREQExeTime=$zt($p(^DHCDISRE(disreq),"^",8)) //陪送时间
	..S DisREQExeTimePoint=$p(^DHCDISRE(disreq),"^",19)  //陪送时间段
	..S DisREQExeDate=DisREQExeDate_" "_DisREQExeTimePoint //_" "_DisREQExeTime
	..S DisREQNums=$p(^DHCDISRE(disreq),"^",11) //陪送人数
	..S DisREQRemarks=$p(^DHCDISRE(disreq),"^",12) //备注
	..S DisREQCreateDate=##class(web.DHCDISCommonDS).DateLogicalToHtml($p(^DHCDISRE(disreq),"^",13)) //创建日期 $zd($p(^DHCDISRE(disreq),"^",13),3)
	..S DisREQCreateTime=$zt($p(^DHCDISRE(disreq),"^",14)) //创建时间
	..S TimeHour=$p(DisREQCreateTime,":",1)
	..S TimeMunite=$p(DisREQCreateTime,":",2)
	..S DisREQCreateTime=TimeHour_":"_TimeMunite
	..S DisREQCreateDate=DisREQCreateDate_" "_DisREQCreateTime   //优化日期和时间的显示方式  zwq
	..S DisREQCreateUser=$p(^SSU("SSUSR",+$p(^DHCDISRE(disreq),"^",15)),"^",2) //创建人
	..S DisREQCurStatus="",DisREQCurStatusCode=""
	..i +disStatus'=0 d 
	...S DisREQCurStatusCode=$p(^DHCDISSA(disStatus),"^",1)
	...S DisREQCurStatus=$p(^DHCDISSA(disStatus),"^",2)
	..s CH=$o(^DHCDISRE(disreq,"Itm",""))				//项目子表ID  sufan  2017-12-14
	..s ItemType=$p(^DHCDISRE(disreq,"Itm",CH),"^",2)	//类型
	..s Item=$p(^DHCDISRE(disreq,"Itm",CH),"^",1)  //其他项目ID
	..i ItemType="Oth" d
	...s EcortDesc=$p($g(^DHCDISLI(Item)),"^",4)				///陪送类型
	...s EcortType=EcortDesc
	..e  s EcortType=""
	..S h=h+1
	..S TempStr=disreq_"^"_disTaskID_"^"_disReqPatID_"^"_disName_"^"_DisHosNo_"^"_DisREQPatNo_"^"_DisREQLoc_"^"_disWard_"^"_diswarddr_"^"_disWardBed_"^"_DisREQAdm_"^"_DisREQExeDate_"^"_DisREQExeTime_"^"_distypeID
	..S TempStr=TempStr_"^"_disEscortType_"^"_disEscortTool_"^"_DisREQNums_"^"_DisREQRemarks_"^"_DisREQCreateDate_"^"_DisREQCreateTime_"^"_DisREQCreateUser_"^"_DisREQCurStatus_"^"_DisREQLocUser_"^"_DisREQCurStatusCode
	..S TempStr=TempStr_"^"_Phone_"^"_DPUserDr_"^"_EcortType_"^"_AssNumber_"^"_AssRemarks
	..S ^TMP("DHCDIS","web.DHCDISEscortArrage","listDisRequest",pid,disStatus,disEscortTypedr,$p(DisREQExeDate," ",1),h)=TempStr
	
	Q:h=0 "{""rows"":[],""total"":"_count_"}" //输出json结尾符，如果这个h为0的时候补输出回去，结果回事datagrid显示有误
	
	///转换数据为Json格式
	S Title="DisREQ^DisREQNo^disReqPatID^DisName^DisHosNo^DisREQPatNo^DisREQLoc^DisREQWard^WardDr"
	S Title=Title_"^DisREQWardBed^DisREQAdm^DisREQExeDate^DisREQExeTime^DisREQTypeID^DisREQEscortType^DisREQEscortTool"
	S Title=Title_"^DisREQNums^DisREQRemarks^DisREQCreateDate^DisREQCreateTime^DisREQCreateUser^DisREQCurStatus^DisREQLocUser"
	S Title=Title_"^DisREQCurStatusCode^PhoneStr^UserDr^EcortType^AssNumber^AssRemarks"
	s h=0
	S index="",Type="",status="",date=""
	w "{""rows"":["
	F  S status=$o(^TMP("DHCDIS","web.DHCDISEscortArrage","listDisRequest",pid,status)) Q:status=""  D
	.F  s Type=$o(^TMP("DHCDIS","web.DHCDISEscortArrage","listDisRequest",pid,status,Type)) Q:Type=""  D
	..F  S date=$o(^TMP("DHCDIS","web.DHCDISEscortArrage","listDisRequest",pid,status,Type,date)) Q:date=""  D
	...f  s index=$o(^TMP("DHCDIS","web.DHCDISEscortArrage","listDisRequest",pid,status,Type,date,index)) Q:index=""  D
	....S mdate=$g(^TMP("DHCDIS","web.DHCDISEscortArrage","listDisRequest",pid,status,Type,date,index))
	....s count=count+1
	....q:(count<Start)||(count>End)	 ///sufan 判断每页加载的数据的条数
	....;w $case(count,1:"",:",")
	....;W ##class(web.DHCAPPJsonCommon).getJsonData(Title,mdate)
	....I count=Start d
	.....w ##class(web.DHCAPPJsonCommon).getJsonData(Title,mdate)
	....e  d
	.....w ","_##class(web.DHCAPPJsonCommon).getJsonData(Title,mdate)
	..
	.
	w "],""total"":"_count_"}"
	K ^TMP("DHCDIS","web.DHCDISEscortArrage","listDisRequest",pid)
	Q ""
}

/// Description:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCDIS("DHCDISEscortArrage"))
}

/// Others:		w ##class(web.DHCDISEscortArrage).GetThisLocUser("114")
ClassMethod GetThisLocUser(DisReqLoc)
{
	n (DisReqLoc)
	
	s LUWorkload="",UserDr="",Flag=""
	f  s LUWorkload=$o(^DHCDISLU(0,"Workload",LUWorkload))  q:(LUWorkload="")||(Flag=1)  d
	.s LocUserID=""
	.f  s LocUserID=$o(^DHCDISLU(0,"Workload",LUWorkload,LocUserID)) q:(LocUserID="")||(Flag=1)  d
	..q:LocUserID=0
	..s ReqLoc=$p(^DHCDISLU(LocUserID),"^",1)
	..q:ReqLoc'=DisReqLoc
	..s Active=$p(^DHCDISLU(LocUserID),"^",3)				//激活标志
	..q:Active'="Y"
	..s UserDr=$p(^DHCDISLU(LocUserID),"^",2)
	..s Flag=1
	
	q UserDr
}

/// Descript:	陪送申请单未安排病区列表查询
/// Creator:    congyue
/// CreateDate: 2017-03-20
/// Table: 		DHC_DisRequest
/// Input:  	开始日期、截止日期、申请科室id、登记号、任务id、状态id
/// Return： 	陪送申请单 数据
/// Others:		w ##class(web.DHCDISEscortArrage).listWard("1","10","2018-11-01^2018-11-21")
ClassMethod listWard(page = 1, rows = 10, param = "")
{
	
	n (page,rows,param)
	s ^tempsufan("page")=$lb(page,rows,param)
	s Start=(page-1)*rows+1
	s End = page*rows
    S pid=..NewPid()
    K ^TMP("DHCDIS","web.DHCDISEscortArrage","listWard",pid)
	s StDate=$p(param,"^",1)
	s EndDate=$p(param,"^",2)
	s ApplyLoc=$p(param,"^",3)
	s PatNo=$p(param,"^",4)
	s TaskID=$p(param,"^",5)
	s AffirmStatus=$p(param,"^",6)
	S WardDr=$p(param,"^",7)
	s HospID=$p(param,"^",9)
	s StDate=$case(+StDate,0:+$h-100,:##class(web.DHCDISCommonDS).DateHtmlToLogical(StDate))  ; $zdh(StDate,3)
	s EndDate=$case(+EndDate,0:+$h,:##class(web.DHCDISCommonDS).DateHtmlToLogical(EndDate))   ; $zdh(EndDate,3))
	s count=0
	s h=0
	f date=StDate:1:EndDate d
	.s disreq=""
	.f  s disreq=$o(^DHCDISRE("0","CreateDate",date,disreq),-1) q:disreq=""  d
	..s disReqPatID=$p(^DHCDISRE(disreq),"^",5)
	..s DisREQPatNo=""
	..s:disReqPatID'="" DisREQPatNo=$p(^PAPER(disReqPatID,"PAT",1),"^",1)  //登记号
	..s disRecLoc=$p(^DHCDISRE(disreq),"^",6)
	..s disStatus=$p(^DHCDISRE(disreq),"^",16)
	..q:((AffirmStatus'="")&&(AffirmStatus'="0"))&&(AffirmStatus'=disStatus)
	..s ReqHospID=$p(^DHCDISRE(disreq),"^",20)
	..q:(HospID'="")&&(ReqHospID'=HospID)
	..s disTaskID=$p(^DHCDISRE(disreq),"^",1)
	..s diswarddr=$p(^DHCDISRE(disreq),"^",2)
	..q:diswarddr=""
	..s disWard=$p(^PAWARD(diswarddr),"^",2) //申请病区
	..S h=h+1
	..S TempStr=diswarddr_"^"_disWard
	..S:'$d(^TMP("DHCDIS","web.DHCDISEscortArrage","listWard",pid,diswarddr)) ^TMP("DHCDIS","web.DHCDISEscortArrage","listWard",pid,diswarddr)=TempStr
	Q:h=0 "{""rows"":[],""total"":"_count_"}" //输出json结尾符，如果这个h为0的时候补输出回去，结果回事datagrid显示有误
	
	///转换数据为Json格式
	S Title="WardDr^WardDesc"
	s h=0,count=0
	S index="",WardDr=""
	w "{""rows"":["
	F  S WardDr=$o(^TMP("DHCDIS","web.DHCDISEscortArrage","listWard",pid,WardDr)) Q:WardDr=""  D
	.S mdate=$g(^TMP("DHCDIS","web.DHCDISEscortArrage","listWard",pid,WardDr))
	.S count = count+1
	.I count=1 D   //有开始值和结束值
	..W ##class(web.DHCAPPJsonCommon).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(Title,mdate) //逗号在这加着呢
	.
	w "],""total"":"_count_"}"

	K ^TMP("DHCDIS","web.DHCDISEscortArrage","listWard",pid)
	Q ""
}

/// Descript:	申请单撤销安排
/// Creator:    zwq
/// CreateDate: 2017-05-26
/// Table: 		DHC_DisRequest
/// Input:  	
/// Return： 	
/// Others:		w ##class(web.DHCDISEscortArrage).CancelArrange("137","18","17","575")
ClassMethod CancelArrange(pointer, typeid, statuscode, lgUser)
{
	TS
	s status=##class(web.DHCDISRequestCom).GetStatusID(statuscode,typeid)
	i status="" tro  q "获取状态ID失败!"
	s ret=..UpdateDpPeopleStatue(pointer,typeid)
	i ret'=0 tro  q "更新陪送人员表状态失败!"
	s ret=..UpdateReqStatue(pointer,status,typeid)
	i ret'=0 tro  q "更新申请主表状态失败!"
	s ret=##class(web.DHCDISRequestCom).updatePeopleStatus(pointer,typeid,status)
	i ret'=0 tro  q "更新人员状态失败"
	s ret=##class(web.DHCDISRequestCom).saveRequestSta(pointer,typeid,status,lgUser)
	i ret'=0 tro  q "插入流水表失败"
	
	s ret=##class(web.DHCDISRequestCom).updWorkLoad(pointer,typeid,status)
	i ret'=0 tro  q "更新护工工作量失败"
	TC
	
	q 0
}

ClassMethod UpdateDpPeopleStatue(pointer, typeid)
{
	s PeopleID="",CancelStatue=-1,err=0
	f  s PeopleID=$o(^DHCDISPE(0,"TypePointer",typeid,pointer,PeopleID)) q:(PeopleID="")||(err'=0)  d
	.q:PeopleID=0
	.&sql(update DHC_DisPeople set DP_Status=:CancelStatue where DP_RowID=:PeopleID)
	.s err=SQLCODE
	
	q err
}

ClassMethod UpdateReqStatue(pointer, status, typeid)
{
	s err=0
	&sql(update DHC_DisRequest set REQ_CurStatus=:status where REQ_RowID=:pointer)
	s err=SQLCODE
	
	q err
}

ClassMethod UpdateUserStatue(pointer, typeid, status)
{
	s PeopleID="",FreeFlag=0
	f  s PeopleID=$o(^DHCDISPE(0,"TypePointer",typeid,pointer,PeopleID)) q:(PeopleID="")||(err'=0)  d  //获取申请单护工表ID
	.q:PeopleID=0
	.s UserDr=$p(^DHCDISPE(PeopleID),"^",3)
	.s LocUserID=""
	.i UserDr'=""  d
	..s LocUserID=$o(^DHCDISLU(0,"User",UserDr,LocUserID))   //获取护工表ID
	..&sql(update DHC_DisLocUser set LU_Status=:FreeFlag where LU_RowId=:LocUserID)
	..s err=SQLCODE
	
	q err
}

/// Descript:	护工combobox
/// Creator:    zwq
/// CreateDate: 2017-05-31
/// Table: 		DHC_DisLocUser
/// Input:  	
/// Return：    护工ID^护工姓名
/// w ##class(web.DHCDISEscortArrage).SelectUser()
ClassMethod SelectUser()
{
	
	s Count=0
	w "["
	s LuID=""
	f  s LuID=$o(^DHCDISLU(LuID)) q:LuID=""  d
	.q:LuID=0
	.s UserDr=$p(^DHCDISLU(LuID),"^",2)
	.s UserName=$p(^SSU("SSUSR",UserDr),"^",2)
	.s DpType="",Num=0
	.f  s DpType=$o(^DHCDISPE("0","TypePointer",DpType)) q:DpType=""  d
	..s ReqID=""
	..f  s ReqID=$o(^DHCDISPE("0","TypePointer",DpType,ReqID)) q:ReqID=""  d
	...s DpID=""
	...f  s DpID=$o(^DHCDISPE("0","TypePointer",DpType,ReqID,DpID)) q:DpID=""  d
	....s DpUser=$p(^DHCDISPE(DpID),"^",3)
	....q:DpUser'=UserDr
	....s DpStatus=$p(^DHCDISPE(DpID),"^",4)
	....q:DpStatus=-1
	....s CurStatusID=$p(^DHCDISRE(ReqID),"^",16)
	....s CurStatusCode=$p(^DHCDISSA(CurStatusID),"^",1)
	....q:(CurStatusCode="完成确认")||(CurStatusCode="空趟")||(CurStatusCode="撤销安排")||(CurStatusCode="已撤销")
	....s Num=Num+1
	.s:Num'=0 UserName=UserName_"("_Num_"个)"
	.s Count=Count+1
	.i Count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",UserDr_"^"_UserName)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",UserDr_"^"_UserName)
	w "]"
	q ""
}

/// Descript:	申请单安排护工
/// Creator:    zwq
/// CreateDate: 2017-05-31
/// Table: 		DHC_DisLocUser、DHC_DisRequest、DHC_DisPeople、DHC_DisRequestSta
/// Input:  	申请单ID,任务类型,护工ID,状态代码,操作人
/// Return：    
/// w ##class(web.DHCDISEscortArrage).ArrangeToo(8,6,5026,11,9)
ClassMethod ArrangeToo(pointer, typeid, user, statuscode, lgUser)
{
	n (pointer,typeid,user,statuscode,lgUser)
	s ^TempSUFAN(11)=$lb(pointer,typeid,user,statuscode,lgUser)
	TS
	s status=##class(web.DHCDISRequestCom).GetStatusID(statuscode,typeid)
	i status="" tro  q "获取状态ID失败!"
	i '$d(^DHCDISPE(0,"TypePointer",typeid,pointer))  d
	.s ret=..insertDpUser(pointer, typeid, user, status, lgUser)
	e  d
	.s ret=..updateDpUser(pointer, typeid, user, status, lgUser)
	i ret'=0 TRO  Q ret
	TC
	//调用自动发消息的接口
	//d ##class(web.DHCDISSOAP.SendMessage).SendMessage(typeid,pointer)    //sufan  2017-12-04
	q ret
}

ClassMethod insertDpUser(pointer, typeid, user, status, lgUser)
{

	s DpID=0,ret=0,DPstatus=0
	f  s DpID=$o(^DHCDISPE(0,"TypePointer",typeid,pointer,DpID)) q:(DpID="")||(ret'=0)  d
	&SQL(INSERT INTO DHC_DisPeople(DP_ReqType,DP_Pointer,DP_User_Dr,DP_Status) VALUES(:typeid,:pointer,:user,:DPstatus))
	s ret=SQLCODE
	q:ret'=0 ret
	s ret=..UpdateReqStatue(pointer,status,typeid)
	q:ret'=0 "更新申请主表状态失败!"
	s ret=..AddUserWork(user,typeid,pointer,1)
	q:ret'=0 "更新陪送人员工作量失败!"
	s ret=##class(web.DHCDISRequestCom).updatePeopleStatus(pointer,typeid,status)
	q:ret'=0 "更新人员状态失败"
	s ret=##class(web.DHCDISRequestCom).saveRequestSta(pointer,typeid,status,lgUser)
	q:ret'=0 "插入流水表失败"
	
	
	q ret
}

ClassMethod updateDpUser(pointer, typeid, user, status, lgUser)
{
	s DpID="",ret=0,DPstatus=0
	
	s ret=..AddUserWork(user,typeid,pointer,2)
	q:ret'=0 "更新陪送人员工作量失败!"
	s ret=..UpdateReqStatue(pointer,status,typeid)
	q:ret'=0 "更新申请主表状态失败!"
	s ret=##class(web.DHCDISRequestCom).updatePeopleStatus(pointer,typeid,status)
	q:ret'=0 "更新人员状态失败"
	s ret=##class(web.DHCDISRequestCom).saveRequestSta(pointer,typeid,status,lgUser)
	q:ret'=0 "插入流水表失败"
	f  s DpID=$o(^DHCDISPE(0,"TypePointer",typeid,pointer,DpID)) q:(DpID="")||(ret'=0)  d
	.q:DpID=0
	.&SQL(update DHC_DisPeople set DP_User_Dr=:user,DP_Status=:DPstatus where DP_RowID=:DpID)
	.s ret=SQLCODE
	q:ret'=0 ret
	q ret
}

ClassMethod AddUserWork(User, typeid, pointer, flag)
{
	s LuUserID="",err=0,UserWork=0
	s PeoPleId=$o(^DHCDISPE("0","TypePointer",typeid,pointer,""))
	s OldUserId=$p(^DHCDISPE(PeoPleId),"^",3)
	i flag=2  d
	.f  s LuUserID=$o(^DHCDISLU(LuUserID)) q:(LuUserID="")||(err'=0)  d
	..q:LuUserID=0
	..s UserID=$p(^DHCDISLU(LuUserID),"^",2)
	..s UserWork=$p(^DHCDISLU(LuUserID),"^",5)
	..q:UserID'=OldUserId
	..s UserWork=UserWork-1
	..&sql(update DHC_DisLocUser set LU_Workload=:UserWork where LU_RowId=:LuUserID)
	..s err=SQLCODE
	
	f  s LuUserID=$o(^DHCDISLU(LuUserID)) q:(LuUserID="")||(err'=0)  d
	.q:LuUserID=0
	.s UserID=$p(^DHCDISLU(LuUserID),"^",2)
	.s UserWork=$p(^DHCDISLU(LuUserID),"^",5)
	.q:UserID'=User
	.s UserWork=UserWork+1
	.&sql(update DHC_DisLocUser set LU_Workload=:UserWork where LU_RowId=:LuUserID)
	.s err=SQLCODE
	
	q err
}

/// CreateDate: 2017-12-27
/// Creator:    sufan
/// Descript:   取人员信息
/// Return： 	重复项目的描述
/// W ##Class(web.DHCDISEscortArrage).GetSSUser("",197)   
ClassMethod GetSSUser(q = "", LocID = "")
{
	n (q,LocID)
	s CodeFlag=$$ALPHAUP^SSUTIL4(q)
	s Count=0,Num=0
	s Hosp="",locid=""
	s pid=..NewPid()
	i (LocID'="")&&($p(^CTLOC(LocID),"^",2)["陪送中心") s LocID=""    ///sufan 2018-01-05
	k ^TMP("DHCDIS","web.DHCDISEscortArrage","GetSSUser",pid)
	s userId=0
	f  s userId = $o(^SSU("SSUSR",userId)) q:userId=""  d
	.i $d(^DHCDISLU("0","User",userId)) d    ///此处对姓名按照姓氏排序
	.s UserName = $p(^SSU("SSUSR",userId),"^",2)
	.s QuitCode=##class(web.DHCINSUPort).GetCNCODE(UserName,4,"")
	.s QuitCode=QuitCode_$$ALPHAUP^SSUTIL4(UserName)
	.q:(CodeFlag'="")&&(QuitCode'[CodeFlag)
	.s NameCode=##class(web.DHCINSUPort).GetCNCODE(UserName,4,"^")
	.s FirCode=$p(NameCode,"^",1)
	.s CodeAII=$ASCII(FirCode)
	.s Num=Num+1
	.s ^TMP("DHCDIS","web.DHCDISEscortArrage","GetSSUser",pid,CodeAII,Num)=userId_"^"_UserName
	

	w "["
	s CodeNum=0
	f  s CodeNum=$o(^TMP("DHCDIS","web.DHCDISEscortArrage","GetSSUser",pid,CodeNum)) q:CodeNum=""  d
	.s index=""
	.f  s index=$o(^TMP("DHCDIS","web.DHCDISEscortArrage","GetSSUser",pid,CodeNum,index))  q:index=""  d
	..s mdata=^(index)
	..s EsUserId=$p(mdata,"^",1)
	..s EsUserName=$p(mdata,"^",2)
	..s CareProvDR="",Phone=""
	..s:EsUserId'="" CareProvDR=$p(^SSU("SSUSR",EsUserId),"^",14)
	..s:CareProvDR'="" Phone=$p($g(^CTPCP(CareProvDR,3)),"^",6)      //陪送人员电话
	..q:'$d(^DHCDISLU("0","User",EsUserId))
	..s LuRowID=$o(^DHCDISLU("0","User",EsUserId,""))		//科室人员表
	..s Workload=..getDisWorkload(EsUserId)			//$p(^DHCDISLU(LuRowID),"^",5)			//工作量
	..s Active=$p(^DHCDISLU(LuRowID),"^",3)				//激活标志
	..q:Active'="Y"
	..s LuLocID=$p(^DHCDISLU(LuRowID),"^",1)			//科室ID
	..Q:(LocID'="")&&(..getUserByLoc(LocID)'[EsUserId)
	..i Workload=0 s Workload=""
	..;e  s Workload=""
	..s FromDate=$p(^SSU("SSUSR",EsUserId),"^",96)
	..s EndDate=$p(^SSU("SSUSR",EsUserId),"^",97)
	..q:(FromDate>+$h)&(FromDate'="")
	..q:(EndDate<+$h)&(EndDate'="")
	..s Hosp=$p(^SSU("SSUSR",EsUserId),"^",90)
	..s locid=$p(^SSU("SSUSR",EsUserId),"^",4)
	..q:locid=""
	..;q:((LocId'=locid)&(LocId'=""))			//sufan 注释，人员取默认登录科室为后勤管理科的人员
	..s LocDesc=$p(^CTLOC(locid),"^",2)			//取科室描述
	..s EsUserName=EsUserName_" "_Workload
	..s Count=Count+1
	..s tmp = EsUserId_"^"_EsUserName_"^"_Phone
	..i Count=1 d
	...w ##class(web.DHCAPPJsonCommon).getJsonData("value^text^telphone",tmp)
	..e  d
	...w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^telphone",tmp)
	w "]"
	k ^TMP("DHCDIS","web.DHCDISEscortArrage","GetSSUser",pid)
	q ""
}

/// Descript：取人员工未完成工作
/// Creator：sufan
/// CreateDate:2020-04-28 
/// w ##class(web.DHCDISEscortArrage).getDisWorkload(1101)
ClassMethod getDisWorkload(UserId)
{
	n (UserId)
	s TypeId=$o(^DHCDISTA(0,"Code","陪送",""))
	s RowId="",count=""
	for  s RowId=$o(^DHCDISPE("0","User",UserId,TypeId,RowId)) Q:RowId=""  d
	.s RepId=$p(^DHCDISPE(RowId),"^",2)
	.s RepStuId=$p(^DHCDISRE(RepId),"^",16)			//当前状态
	.Q:RepStuId=""
	.s StatusCode=$p(^DHCDISSA(RepStuId),"^",1)
	.Q:(StatusCode="12")||(StatusCode="13")||(StatusCode="14")||(StatusCode="99")	//过滤掉确认完成，空趟，完成，撤销安排
	.s count=count+1
	Q count
}

/// 取科室关联的陪送人员
/// w ##class(web.DHCDISEscortArrage).getUserByLoc(197)
ClassMethod getUserByLoc(LocId)
{
	n (LocId)
	s LuRowId="",UserList=""
	for  s LuRowId=$o(^DHCDISLU(0,"Loc",LocId,LuRowId))  Q:LuRowId=""  d
	.s LuUerId=$p(^DHCDISLU(LuRowId),"^",2)
	.i UserList=""  s UserList=LuUerId
	.e  s UserList=UserList_"^"_LuUerId
	Q UserList
}

}
