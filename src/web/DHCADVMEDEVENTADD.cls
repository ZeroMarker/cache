Import Sqluser

/// 医疗不良事件类型维护  20151009
Class web.DHCADVMEDEVENTADD Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 保存[不良反应/事件名称]
/// Table:		 DHC_MedAdrRepEvent
/// Input:  	 DataList: 以字符"^"分割,格式为:id^代码^描述
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).SaveMedAdrEvent("^SDFASDF^ASD")
ClassMethod SaveMedAdrEvent(DataList As %String) As %String
{
	N (DataList)
	S Err=0
	S len=$L(DataList,"&&")
	F i=1:1:len Q:Err'=0  D
	.S TmpStr=$p(DataList,"&&",i)
	.S Err=..CheckRepeatDeal(TmpStr)   /// 重复性判断
	.Q:Err'=0
	.I $p(TmpStr,"^",1)'="" D
	..S Err=..UpdAdrEvent(TmpStr)
	.E  D
	..S Err=..InsAdrEvent(TmpStr)
	Q Err
}

/// Description: 保存[检查代码是否重复]
/// Creator:     CongYue
/// CreateDate:  2016-05-30
/// Table:		 DHC_MedAdrRepEvent
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).CheckRepeatDeal("2^med^医疗")
ClassMethod CheckRepeatDeal(TmpStr As %String) As %String
{
	N (TmpStr)
	S AdrEventID=$p(TmpStr,"^",1)   		///ID
	S AdrEventCode=$p(TmpStr,"^",2)   	///代码	
	
	/// 新记录
	Q:$d(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(AdrEventCode))) "-1"
	Q:(AdrEventID="")&($d(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(AdrEventCode)))) "-1"
	Q:AdrEventID="" 0
	
	/// 修改记录
	S Code=$p($g(^DHCMEDADREVT(AdrEventID)),"^",1)    //代码
	Q:(AdrEventCode'=Code)&($d(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(AdrEventCode)))) "-2"
	Q 0
}

/// Description: 更新[不良反应/事件名称]
/// Table:		 DHC_MedAdrRepEvent
/// Input:  	 DataList: 以字符"^"分割,格式为:id^代码^描述
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).UpdAdrEvent("^SDFASDF^ASD")
ClassMethod UpdAdrEvent(DataList As %String) As %String
{
	N (DataList)
	S AdrEventID=$p(DataList,"^",1)
	S AdrEventCode=$p(DataList,"^",2)
	S AdrEventDesc=$p(DataList,"^",3)
	S AdrActive=$p(DataList,"^",4)
	&SQL(Update DHC_MedAdrRepEvent Set MADREV_Code=:AdrEventCode,MADREV_Desc=:AdrEventDesc,MADREV_ActiveFlag=:AdrActive WHERE MADREV_RowID=:AdrEventID)
 	Q SQLCODE
}

/// Description: 增加[不良反应/事件名称]
/// Table:		 DHC_MedAdrRepEvent
/// Input:  	 DataList: 以字符"^"分割,格式为:id^代码^描述
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCSTPHCMADRDICMAIN).InsAdrEvent("^SDFASDF^ASD")
ClassMethod InsAdrEvent(DataList As %String) As %String
{
	N (DataList)
	S AdrEventCode=$p(DataList,"^",2)
	S AdrEventDesc=$p(DataList,"^",3)
	S AdrActive=$p(DataList,"^",4)
 	&SQL(INSERT INTO DHC_MedAdrRepEvent(MADREV_Code,MADREV_Desc,MADREV_ActiveFlag) VALUES(:AdrEventCode,:AdrEventDesc,:AdrActive))
 	Q SQLCODE
}

/// Description: 删除 [不良反应/事件名称]
/// Creator:     CongYue
/// CreateDate:  2016-05-23
/// Table:		 DHC_MedAdrRepEvent
/// Input:  	 数据id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).DelAdrEvent("")
ClassMethod DelAdrEvent(AdrEventID As %String) As %String
{
	N (AdrEventID)
	Q:$d(^DHCADREVTWF(0,"Event",AdrEventID)) -1 ;判断此事件类型是否存在工作流 //qunianpeng 2017/12/25
	Q:$d(^DHCMEDREPADT(0,"Pointer",AdrEventID)) -1  ;判断此事件类型是否存在报告审批记录
	
	TS
	//先删除相关表
	S Err=..DelAdrEventInfo(AdrEventID)
	I Err'=0 tro
	Q:Err'=0 "-31"
	//再删除表信息
	&SQL(Delete From DHC_MedAdrRepEvent Where MADREV_RowID=:AdrEventID)
	I SQLCODE'=0 tro
	Q:SQLCODE'=0 -3

	TC
	
	Q 0
}

/// Description: 查询[不良反应/事件名称]
/// Table:		 DHC_MedAdrRepEvent
/// Input:  	 DataList: 以字符"^"分割,格式为:代码^描述
/// Return: 	 不良反应/事件名称信息
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).QueryAdrEvent("12","1","")
ClassMethod QueryAdrEvent(rows As %String, page As %String, params As %String, HospDr = "") As %String
{
	N (rows,page,params,HospDr)
	S End = page*rows
	S Start=(page-1)*rows+1
    S pid=##class(web.DHCADVMEDCOMMON).GetPID()
    Q:params'="Root" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出json结尾符
	S h=0,count=0
	S ID="0"
	F  S ID=$o(^DHCMEDADREVT(ID)) Q:ID=""  D
	.S Code=$p(^DHCMEDADREVT(ID),"^",1) //代码
	.Q:##class(web.DHCADVFormName).CheckFormName(Code,HospDr)'=1
	.S Desc=$p(^DHCMEDADREVT(ID),"^",2) //描述
	.S Active=$p(^DHCMEDADREVT(ID),"^",3) //是否可用
	.S Level=1
	.S Levelrowid="Root"
	.S h=h+1
	.S TempStr=ID_"^"_Code_"^"_Desc_"^"_Active_"^"_Level_"^"_Levelrowid
	.S ^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrEvent",pid,h)=TempStr
	
	D:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc^Active^Level^Levelrowid"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrEvent",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrEvent",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	K ^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrEvent",pid)
	Q ""
}

/// Description: 不良反应/事件名称  下拉框
/// Table:		 DHC_MedAdrRepEvent
ClassMethod QueryAdrEventCombo() As %String
{
	
	S count=0
	W "["
	S ID="0"
	F  S ID=$o(^DHCMEDADREVT(ID)) Q:ID=""  D
	.S Code=$p(^DHCMEDADREVT(ID),"^",1) //代码
	.S Desc=$p(^DHCMEDADREVT(ID),"^",2) //描述
	.S tmp=ID_"^"_Desc
	.S count = count+1
	.I count=1 D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("TypeID^Desc",tmp)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("TypeID^Desc",tmp)

	W "]"
}

/// Description: 保存 不良事件权限查看信息表
/// Creator:     CongYue
/// CreateDate:  2016-04-19
/// Table:		 DHC_AdvQuerySec
/// Input:  	 DataList: 以字符"^"分割,格式为:id^报告类型id^类型^指向id^权限值
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).SaveQuerySec("14^11^1^1^2")
ClassMethod SaveQuerySec(DataList As %String) As %String
{
	N (DataList)
	S ret=0
	S len=$L(DataList,"&&")
	F i=1:1:len Q:ret'=0  D
	.S TmpStr=$p(DataList,"&&",i)
	.S ret=..CheckRepeatQuerySec(TmpStr)   /// 重复性判断
	.Q:ret'=0
	.I $p(TmpStr,"^",1)'="" D
	..S ret=..UpdQuerySec(TmpStr)
	.E  D
	..S ret=..InsQuerySec(TmpStr)
	Q ret
}

/// Description: 保存[检查权限是否重复]
/// Table:		 DHC_AdvQuerySec
/// Creator:     CongYue
/// CreateDate:  2020-05-09
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).CheckRepeatQuerySec("208^87^1^1^3^N^N^N^N^N^N^N")
ClassMethod CheckRepeatQuerySec(DataList As %String) As %String
{
	N (DataList)
	S AdvqsID=$p(DataList,"^",1)
	S RepTyepDr=$p(DataList,"^",2)
	S Type=$p(DataList,"^",3)
	S Pointer=$p(DataList,"^",4)
	S SecFlag=$p(DataList,"^",5)
	S AssessFlag=$p(DataList,"^",6)     //wangxuejian 2016/10/18
	S ShareFlag=$p(DataList,"^",7) 			//ylp 2017/12/11 分享权限
	S FocusFlag=$p(DataList,"^",8)			//ylp 2017/12/11 重点关注
	S FileFlag=$p(DataList,"^",9)			// 归档权限
	S CaseShareFlag=$p(DataList,"^",10)			// 案例共享权限
	S DeleteFlag=$p(DataList,"^",11)			// 删除权限
	S CancelFlag=$p(DataList,"^",12)			// 作废权限
	S HospDr=$p(DataList,"^",13)			// 医院id
	
	S ID="",Flag=0
	F  S ID=$o(^DHCADVQUS(0,"RepType",RepTyepDr,Type,Pointer,ID))  Q:+ID=0  D
	.Q:Flag'=0
	.S SecHospDr=$p(^DHCADVQUS(ID),"^",13)			// 医院
	.S:(AdvqsID="")&&(SecHospDr=HospDr) Flag="-1"
	.S:(AdvqsID'="")&&(AdvqsID'=ID)&&(SecHospDr=HospDr) Flag="-2"
	.Q:Flag'=0

	Q Flag
}

/// Description: 更新 不良事件权限查看信息表
/// Creator:     CongYue
/// CreateDate:  2016-04-19
/// Table:		 DHC_AdvQuerySec
/// Input:  	 DataList: 以字符"^"分割,格式为:id^报告类型id^类型^指向id^权限值
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).UpdQuerySec("14^11^1^1^2")
ClassMethod UpdQuerySec(DataList As %String) As %String
{
	N (DataList)
	S AdvqsID=$p(DataList,"^",1)
	S RepTyepDr=$p(DataList,"^",2)
	S Type=$p(DataList,"^",3)
	S Pointer=$p(DataList,"^",4)
	S SecFlag=$p(DataList,"^",5)
	S AssessFlag=$p(DataList,"^",6)         //wangxuejian 2016/10/18
	S ShareFlag=$p(DataList,"^",7) 			//ylp 2017/12/11 分享权限
	S FocusFlag=$p(DataList,"^",8)			//ylp 2017/12/11 重点关注
	S FileFlag=$p(DataList,"^",9)			// 归档权限
	S CaseShareFlag=$p(DataList,"^",10)			// 案例共享权限
	S DeleteFlag=$p(DataList,"^",11)			// 删除权限
	S CancelFlag=$p(DataList,"^",12)			// 作废权限
	S HospDr=$p(DataList,"^",13)			// 医院id
	S AdvqsSecFlag=$p(^DHCADVQUS(AdvqsID),"^",4)
	S AdvqsAssessFlag=$p(^DHCADVQUS(AdvqsID),"^",5) //wangxuejian 2016/10/19
	S ShareFlags=$p(^DHCADVQUS(AdvqsID),"^",7)
	S FocusFlags=$p(^DHCADVQUS(AdvqsID),"^",8)
	S FileFlags=$p(^DHCADVQUS(AdvqsID),"^",9)			// 归档权限
	S CaseShareFlags=$p(^DHCADVQUS(AdvqsID),"^",10)			// 案例共享权限
	S DeleteFlags=$p(^DHCADVQUS(AdvqsID),"^",11)			// 删除权限
	S CancelFlags=$p(^DHCADVQUS(AdvqsID),"^",12)			// 作废权限

	Q:(ShareFlag=ShareFlags)&(FocusFlag=FocusFlags)&(AdvqsAssessFlag=AssessFlag)&(AdvqsSecFlag=SecFlag)&(FileFlag=FileFlags)&(CaseShareFlag=CaseShareFlags)&(DeleteFlag=DeleteFlags)&(CancelFlag=CancelFlags)&($d(^DHCADVQUS(0,"RepType",RepTyepDr,Type,Pointer))) -10 //增加判断（记录是否重复添加）  wangxuejian 2016/10/19
	&SQL(Update DHC_AdvQuerySec Set ADVQS_RepTyep_Dr=:RepTyepDr, ADVQS_Type=:Type,ADVQS_Pointer=:Pointer,ADVQS_SecFlag=:SecFlag,ADVQS_AssessFlag=:AssessFlag, ADVQS_ShareFlag=:ShareFlag,ADVQS_FocusFlag=:FocusFlag,
		ADVQS_FileFlag=:FileFlag, ADVQS_CaseShareFlag=:CaseShareFlag,ADVQS_DeleteFlag=:DeleteFlag,ADVQS_CancelFlag=:CancelFlag,ADVQS_HospDr=:HospDr WHERE ADVQS_RowID=:AdvqsID) //wangxuejian 2016/10/18  增加评估权限字段
 	Q SQLCODE
}

/// Description: 增加 不良事件权限查看信息表
/// Creator:     CongYue
/// CreateDate:  2016-04-19
/// Table:		 DHC_AdvQuerySec
/// Input:  	 DataList: 以字符"^"分割,格式为:id^报告类型id^类型^指向id^权限值
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).InsQuerySec("^11^2^1^2")
ClassMethod InsQuerySec(DataList As %String) As %String
{
	N (DataList)
	S RepTyepDr=$p(DataList,"^",2)
	S Type=$p(DataList,"^",3)
	S Pointer=$p(DataList,"^",4)
	S SecFlag=$p(DataList,"^",5)
	S AssessFlag=$p(DataList,"^",6)     //wangxuejian 2016/10/18
	S ShareFlag=$p(DataList,"^",7) 			//ylp 2017/12/11 分享权限
	S FocusFlag=$p(DataList,"^",8)			//ylp 2017/12/11 重点关注
	S FileFlag=$p(DataList,"^",9)			// 归档权限
	S CaseShareFlag=$p(DataList,"^",10)			// 案例共享权限
	S DeleteFlag=$p(DataList,"^",11)			// 删除权限
	S CancelFlag=$p(DataList,"^",12)			// 作废权限
	S HospDr=$p(DataList,"^",13)			// 医院id
 	&SQL(INSERT INTO DHC_AdvQuerySec(ADVQS_RepTyep_Dr,ADVQS_Type,ADVQS_Pointer,ADVQS_SecFlag,ADVQS_AssessFlag,ADVQS_ShareFlag,ADVQS_FocusFlag,
 		ADVQS_FileFlag,ADVQS_CaseShareFlag,ADVQS_DeleteFlag,ADVQS_CancelFlag,ADVQS_HospDr)       
 	VALUES(:RepTyepDr,:Type,:Pointer,:SecFlag,:AssessFlag,:ShareFlag,:FocusFlag,:FileFlag,:CaseShareFlag,:DeleteFlag,:CancelFlag,:HospDr))                    //wangxuejian 2016/10/18
 	Q SQLCODE
}

/// Description: 删除 不良事件权限查看信息表
/// Creator:     CongYue
/// CreateDate:  2016-04-19
/// Table:		 DHC_AdvQuerySec
/// Input:  	 数据id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).DelQuerySec("^2^1||2^1^1")
ClassMethod DelQuerySec(AdvqsID As %String) As %String
{
	N (AdvqsID)
	&SQL(Delete From DHC_AdvQuerySec Where ADVQS_RowID=:AdvqsID)
	Q SQLCODE
}

/// Description: 查询 不良事件权限查看信息表
/// Creator:     CongYue
/// CreateDate:  2016-04-19
/// Input:  	 报告类别id
/// Table:		 DHC_AdvQuerySec
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).GetQuerySec("")
ClassMethod GetQuerySec(RepTypeDr As %String, HospDr = "") As %String
{
    N (RepTypeDr,HospDr)
    Q:RepTypeDr="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出json结尾符
    S pid=##class(web.DHCADVCOMMON).NewPid()
	K ^TMP("DHCST","web.DHCADVMEDEVENTADD","GetQuerySec",pid) //k掉临时global
	S h=0,count=0
	S AdvqsID="" 
	S TypeID=""
	S PointID=""
	S SecFlag="" S SecFlagID=""
	F  S TypeID=$o(^DHCADVQUS(0,"RepType",RepTypeDr,TypeID)) Q:TypeID=""  D
	.F  S PointID=$o(^DHCADVQUS(0,"RepType",RepTypeDr,TypeID,PointID))  Q:PointID=""  D
	..F  S AdvqsID=$o(^DHCADVQUS(0,"RepType",RepTypeDr,TypeID,PointID,AdvqsID))  Q:AdvqsID=""  D
	...Q:(+AdvqsID=0)||(+AdvqsID<0)
	...S SecFlagID=$p(^DHCADVQUS(AdvqsID),"^",4) //权限
	...S SecFlag=$S(SecFlagID="1":"仅自己",SecFlagID="2":"仅本科室",SecFlagID="3":"全院",1:"")
	...S Pointer =##class(web.DHCADVEVTWORKFLOW).FindPointer(PointID,TypeID)
	...S Type=$S(TypeID="1":"安全组",TypeID="2":"科室",TypeID="3":"人员",TypeID="5":"大科室安全组",1:"")
	...S AssessFlag=$p(^DHCADVQUS(AdvqsID),"^",5)   //评估权限     wangxuejian 2016/10/18
	...S ShareFlag=$p(^DHCADVQUS(AdvqsID),"^",7)   //分享权限     ylp 2017/12/11
	...S FocusFlag=$p(^DHCADVQUS(AdvqsID),"^",8)   //重点关注权限     ylp 2017/12/11
	...S FileFlag=$p(^DHCADVQUS(AdvqsID),"^",9)			// 归档权限
	...S CaseShareFlag=$p(^DHCADVQUS(AdvqsID),"^",10)			// 案例共享权限
	...S DeleteFlag=$p(^DHCADVQUS(AdvqsID),"^",11)			// 删除权限
	...S CancelFlag=$p(^DHCADVQUS(AdvqsID),"^",12)			// 作废权限
	...S SecHospDr=$p(^DHCADVQUS(AdvqsID),"^",13)			// 医院
	...Q:(HospDr'="")&&(SecHospDr'="")&&(HospDr'=SecHospDr)
	...S h=h+1
	...S TempStr=AdvqsID_"^"_RepTypeDr_"^"_TypeID_"^"_Type_"^"_Pointer_"^"_PointID_"^"_SecFlag_"^"_SecFlagID_"^"_AssessFlag_"^"_ShareFlag_"^"_FocusFlag_"^"_FileFlag_"^"_CaseShareFlag_"^"_DeleteFlag_"^"_CancelFlag_"^"_SecHospDr //wangxuejian 2016/10/18
	
	...S ^TMP("DHCST","web.DHCADVMEDEVENTADD","GetQuerySec",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^RepTypeDr^TypeID^Type^Pointer^PointID^SecFlag^SecFlagID^AssessFlag^ShareFlag^FocusFlag^FileFlag^CaseShareFlag^DeleteFlag^CancelFlag^HospDr"  //wangxuejian 2016/10/18
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCADVMEDEVENTADD","GetQuerySec",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCST","web.DHCADVMEDEVENTADD","GetQuerySec",pid,index))
	.S count = count+1
	.I count=1 D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	K ^TMP("DHCST","web.DHCADVMEDEVENTADD","GetQuerySec",pid) //k掉临时global
	Q ""
}

/// Description: 查询 不良事件权限查看科室(下拉框)
/// Creator:     CongYue
/// CreateDate:  2016-09-29
/// Input:  	 报告类别id
/// Table:		 DHC_AdvQuerySec
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).GetQueryLoc("advDevice","")
ClassMethod GetQueryLoc(RepTypeCode As %String, input As %String) As %String
{
	N (RepTypeCode,input)
    Q:RepTypeCode="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出空的json串
	S RepTypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //类别指向
	S RepTypeParref="",RepTypeSub="" ;2021-02-20
	I RepTypeDr=""  D
	.S RepTypeParref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //子表类别指向
	.S:RepTypeParref'="" RepTypeSub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),RepTypeParref,""))
	.S:(RepTypeParref'="")&&(RepTypeSub'="") RepTypeDr=RepTypeParref_"||"_RepTypeSub
    Q:RepTypeDr="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出空的json串
	S:'$d(^DHCADVQUS(0,"RepType",RepTypeDr)) RepTypeDr=+RepTypeDr

	S input=$zcvt(input,"U")
	S count=0
	W "["
	S TypeID=""
	S PointID="",PointerContactName=""
	F  S TypeID=$o(^DHCADVQUS(0,"RepType",RepTypeDr,TypeID)) Q:TypeID=""  D
	.Q:TypeID'=2
	.F  S PointID=$o(^DHCADVQUS(0,"RepType",RepTypeDr,TypeID,PointID))  Q:PointID=""  D
	..S Pointer=$p(^CTLOC(PointID),"^",2)
	..S PointerContactName=$p(^CTLOC(PointID),"^",43) ;获取科室检索码
	..Q:(input'="")&(Pointer'[input)&(PointerContactName'[input)
	..S tmp=PointID_"^"_Pointer
	..S count = count+1
	..I count=1 D
	...W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	W "]"
	Q ""
}

/// Description: 保存[不良反应/事件名称 子类]
/// CreateDate:  2018-05-22
/// Table:		 DHC_MedAdrRepEventItm
/// Input:  	 DataList: 以字符"^"分割,格式为:id^代码^描述
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).SaveMedAdrEventItm("^81^ceshi^ceshi^Y")
ClassMethod SaveMedAdrEventItm(DataList As %String) As %String
{
	N (DataList)
	S Err=0
	S len=$L(DataList,"&&")
	F i=1:1:len Q:Err'=0  D
	.S TmpStr=$p(DataList,"&&",i)
	.S Err=..CheckRepeatDealItm(TmpStr)   /// 重复性判断
	.Q:Err'=0
	.I $p(TmpStr,"^",1)'="" D
	..S Err=..UpdAdrEventItm(TmpStr)
	.E  D
	..S Err=..InsAdrEventItm(TmpStr)
	Q Err
}

/// Description: 保存[检查代码是否重复 子类]
/// Creator:     CongYue
/// CreateDate:  2018-05-22
/// Table:		 DHC_MedAdrRepEventItm
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).CheckRepeatDealItm("81||1^81^ceshi^ceshi1^Y")
ClassMethod CheckRepeatDealItm(TmpStr As %String) As %String
{
	N (TmpStr)
	S AdrEventItmID=$p(TmpStr,"^",1)   		///ID
	S Parref=+$p(TmpStr,"^",2)			///主表ID
	S ChildSub=$p(AdrEventItmID,"||",2)
	S AdrEventItmCode=$p(TmpStr,"^",3)   	///代码
	/// 新记录
	Q:$d(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(AdrEventItmCode))) "-1"
	Q:(AdrEventItmID="")&($d(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(AdrEventItmCode)))) "-1"
	Q:AdrEventItmID="" 0
	
	/// 修改记录
	S Code=$p($g(^DHCMEDADREVTI(Parref,"MADREVI",ChildSub)),"^",1)    //代码
	Q:(AdrEventItmCode'=Code)&($d(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(AdrEventItmCode)))) "-2"
	Q 0
}

/// Description: 更新[不良反应/事件名称 子类]
/// CreateDate:  2018-05-22
/// Table:		 DHC_MedAdrRepEventItm
/// Input:  	 DataList: 以字符"^"分割,格式为:id^代码^描述
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).UpdAdrEventItm("^SDFASDF^ASD")
ClassMethod UpdAdrEventItm(DataList As %String) As %String
{
	N (DataList)
	S AdrEventIDItm=$p(DataList,"^",1)
	S Code=$p(DataList,"^",3)
	S Desc=$p(DataList,"^",4)
	S Active=$p(DataList,"^",7)
	S level=$p(DataList,"^",5)     //级别    wangxuejian 2018-08-20
	S Plevel=$p(DataList,"^",6)   //上一级别
	&SQL(Update DHC_MedAdrRepEventItm Set MADREVI_Code=:Code,MADREVI_Desc=:Desc,MADREVI_ActiveFlag=:Active,MADREVI_Level=:level,MADREVI_LevelRowID=:Plevel WHERE MADREVI_RowID=:AdrEventIDItm)
 	Q SQLCODE
}

/// Description: 增加[不良反应/事件名称 子类]
/// CreateDate:  2018-05-22
/// Table:		 DHC_MedAdrRepEventItm
/// Input:  	 DataList: 以字符"^"分割,格式为:id^代码^描述
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).InsAdrEventItm("^81^ceshi^ceshi^Y")
ClassMethod InsAdrEventItm(DataList As %String) As %String
{
	N (DataList)
	S parref=+$p(DataList,"^",2)
	S Code=$p(DataList,"^",3)
	S Desc=$p(DataList,"^",4)
	S level=$p(DataList,"^",5)     //级别    wangxuejian 2018-08-20
	S Plevel=$p(DataList,"^",6)   //上一级别
	S Active=$p(DataList,"^",7)
	S childSub=$o(^DHCMEDADREVTI(parref,"MADREVI",""),-1)+1
 	&SQL(INSERT INTO DHC_MedAdrRepEventItm(MADREVI_Parref, MADREVI_ChildSub,MADREVI_Code,MADREVI_Desc,MADREVI_ActiveFlag,MADREVI_Level,MADREVI_LevelRowID)
 		 VALUES(:parref,:childSub,:Code,:Desc,:Active,:level,:Plevel))
 	Q SQLCODE
}

/// Description: 删除 [不良反应/事件名称 子类]
/// Creator:     CongYue
/// CreateDate:  2018-05-22
/// Table:		 DHC_MedAdrRepEventItm
/// Input:  	 数据id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).DelAdrEventItm("")
ClassMethod DelAdrEventItm(AdrEventItmID As %String) As %String
{
	N (AdrEventItmID)
	Q:$d(^DHCADREVTWF(0,"Event",AdrEventItmID)) -1 ;判断此事件类型是否存在工作流 //qunianpeng 2017/12/25
	Q:$d(^DHCMEDREPADT(0,"Pointer",AdrEventItmID)) -1  ;判断此事件类型是否存在报告审批记录
	TS
	//删除相关表
	S Err=..DelAdrEventInfo(AdrEventItmID)
	I Err'=0 tro
	Q:Err'=0 "-31"
	//再删除表信息
	&SQL(Delete From DHC_MedAdrRepEventItm Where MADREVI_RowID=:AdrEventItmID)
	I SQLCODE'=0 tro
	Q:SQLCODE'=0 -3

	TC
	
	Q 0
}

/// Description: 不良事件分类主子表删除公用 --- 删除相关表信息 （不良事件分类子表与权限表信息）
/// Creator:     CongYue
/// CreateDate:  2019-06-28
/// Table:		 DHC_MedAdrRepEventItm,DHC_AdvQuerySec
/// Input:  	 数据id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).DelAdrEventItmInfo("20")
ClassMethod DelAdrEventInfo(AdrEventItmID As %String) As %String
{
	N (AdrEventItmID)
	S Err=0
	S DataList=AdrEventItmID_"^"_##class(web.DHCADVMEDEVENTADD).GetDelItmInfo(AdrEventItmID,"")
	S Len=$L(DataList,"^")
	F i=1:1:Len Q:Err'=0  D
	.S DelDr=$p(DataList,"^",i)
	.Q:DelDr=""
	.I (i'=1)&&($d(^DHCMEDADREVTI(+DelDr,"MADREVI",$p(DelDr,"||",2))))  D
	..&SQL(Delete From DHC_MedAdrRepEventItm Where MADREVI_RowID=:DelDr)
	..S:+$g(SQLCODE)'=0 Err="-11"
	.Q:Err'=0
	.I $d(^DHCADVQUS(0,"RepType",DelDr)) D
	..&SQL(Delete From DHC_AdvQuerySec Where ADVQS_RepTyep_Dr=:DelDr)
	..S:+$g(SQLCODE)'=0 Err="-12"
	.Q:Err'=0
		
	Q Err
}

/// Description: 不良事件分类主子表删除公用 ---删除关联表（获取删除id相关的不良事件子分类id，所有子数据id）
/// Creator:     CongYue
/// CreateDate:  2021-01-29
/// Table:		 DHC_MedAdrRepEventItm
/// Input:  	 ID:工作流id或者工作流项目id
/// w ##class(web.DHCADVMEDEVENTADD).GetDelItmInfo("108","")
ClassMethod GetDelItmInfo(ID As %String, List) As %String
{
	N (ID,List)
	S Parref="0"
	F  S Parref=$o(^DHCMEDADREVTI(0,"ItmLevelDr",ID,Parref)) Q:Parref=""  D
	.Q:+Parref=0
	.S SubID=""
	.F  S SubID=$o(^DHCMEDADREVTI(0,"ItmLevelDr",ID,Parref,SubID)) Q:SubID=""  D
	..Q:+SubID=0
	..S ItmID=Parref_"||"_SubID
	..S:(List'="")&&(List'[ItmID) List=List_"^"_ItmID
	..S:List="" List=ItmID
	..I ($D(^DHCMEDADREVTI(0,"ItmLevelDr",ItmID)))&&(ItmID["||") D
	...S List=##class(web.DHCADVMEDEVENTADD).GetDelItmInfo(ItmID,List)
	Q List
}

/// Description: 查询[不良反应/事件名称 子类]
/// CreateDate:  2018-05-22
/// Table:		 DHC_MedAdrRepEventItm
/// Input:  	 DataList: 以字符"^"分割,格式为:代码^描述
/// Return: 	 不良反应/事件名称信息
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).QueryAdrEventItm("12","1","27")
ClassMethod QueryAdrEventItm(rows As %String, page As %String, params As %String, HospDr = "") As %String
{
	N (rows,page,params,HospDr)
	S endpage = page*rows
	S stpage = (page-1)*rows+1
	S ParentID=params
	
    S pid=##class(web.DHCADVCOMMON).NewPid()
    k ^TMP("DHCADV","web.DHCADVMEDEVENTADD","QueryAdrEventItm",pid) //k掉临时global
	S h=0,count=0
	S Parref=""
	F  S Parref=$o(^DHCMEDADREVTI(0,"ItmLevelDr",ParentID,Parref)) Q:Parref=""  D
	.Q:+Parref=0
	.S SubID=""
	.F  S SubID=$o(^DHCMEDADREVTI(0,"ItmLevelDr",ParentID,Parref,SubID)) Q:SubID=""  D
	..Q:+SubID=0
	..S Code=$p(^DHCMEDADREVTI(Parref,"MADREVI",SubID),"^",1)  //代码
	..Q:##class(web.DHCADVFormName).CheckFormName(Code,HospDr)'=1
	..S Desc=$p(^DHCMEDADREVTI(Parref,"MADREVI",SubID),"^",2)  //描述
	..S Level=$p(^DHCMEDADREVTI(Parref,"MADREVI",SubID),"^",4) //级别
	..S Levelrowid=$p(^DHCMEDADREVTI(Parref,"MADREVI",SubID),"^",5) //上一级别的rowid
	..S Active=$p(^DHCMEDADREVTI(Parref,"MADREVI",SubID),"^",3) //是否可用
	..Q:ParentID'=Levelrowid  ; 入参与父元素指向id不相等则退出
	..S h=h+1
	..S TempStr=Parref_"||"_SubID_"^"_Code_"^"_Desc_"^"_Active_"^"_Level_"^"_Levelrowid
	..S ^TMP("DHCADV","web.DHCADVMEDEVENTADD","QueryAdrEventItm",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).GetNoJson()
	
	///转换数据为Json格式
	S Title="ID^Code^Desc^Active^Level^Levelrowid"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVMEDEVENTADD","QueryAdrEventItm",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVMEDEVENTADD","QueryAdrEventItm",pid,index))
	.S count = count+1
	.Q:(count<stpage)||(count>endpage)
	.I count=stpage D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	k ^TMP("DHCADV","web.DHCADVMEDEVENTADD","QueryAdrEventItm",pid) //k掉临时global
	Q ""
}

/// Description: 查询[维护的子类树]
/// Creator:     Wangxuejian
/// CreateDate:  2018-08-20
/// Table: 		 DHC_MedAdrRepEventItm
/// Input:  	 params：主表id
/// Output:  	 DHC_MedAdrRepEventItm表中的数据信息   
/// Others:		 w ##class(web.DHCADVMEDEVENTADD).QueryAdrItmTree("12","1","27")
ClassMethod QueryAdrItmTree(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S End = page*rows
	S Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    S ParrefID=params

    K ^TMP("DHCADV","web.DHCADVMEDEVENTADD","QueryAdrItmTree",pid) //k掉临时global
	S h=0,count=0
	S childId=""
	F  S childId=$o(^DHCMEDADREVTI(ParrefID,"MADREVI",childId)) Q:childId=""  D
	.Q:childId=0
	.S Code=$p(^DHCMEDADREVTI(ParrefID,"MADREVI",childId),"^",1)  //代码
	.S Desc=$p(^DHCMEDADREVTI(ParrefID,"MADREVI",childId),"^",2)  //描述
	.S Level=$p(^DHCMEDADREVTI(ParrefID,"MADREVI",childId),"^",4) //级别
	.S Levelrowid=$p(^DHCMEDADREVTI(ParrefID,"MADREVI",childId),"^",5) //上一级别的rowid
	.S Active=$p(^DHCMEDADREVTI(ParrefID,"MADREVI",childId),"^",3) //是否可用
	.s RowId=ParrefID_"||"_childId
	.S h=h+1
	.S TempStr=RowId_"^"_Desc_"^"_Level_"^"_Levelrowid
	.S ^TMP("DHCADV","web.DHCADVMEDEVENTADD","QueryAdrItmTree",pid,h)=TempStr
	S mdate=""
	Q:h=0 ..getJsonEmptySign() //输出json结尾符
	S Title="ID^text^Level^Levelrowid"
	///转换数据为Json格式
	//W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	W ..getJsonStartSign(h)
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVMEDEVENTADD","QueryAdrItmTree",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVMEDEVENTADD","QueryAdrItmTree",pid,index))
	.S count = count+1
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ..getJsonEndSign()  //输出json结尾符
	k ^TMP("DHCADV","web.DHCADVMEDEVENTADD","QueryAdrItmTree",pid) //k掉临时global
	Q ""
}

/// Descript:返回Json串起始符
ClassMethod getJsonStartSign(Count) As %String
{
	N (Count)
	S del=""""
	q "["
}

/// Descript:返回Json串结束符
ClassMethod getJsonEndSign() As %String
{
	q "]"
}

/// Descript:返回Json空串符
ClassMethod getJsonEmptySign(Count) As %String
{
	N (Count)
	S del=""""
	q "[]"
}

/// Creater:    congyue
/// CreateDate: 2019-06-05
/// Descript:   不良事件报告类型 加载树
/// w ##Class(web.DHCADVMEDEVENTADD).jsonCheckType("Root",2)
ClassMethod jsonCheckType(id, hospdr = "") As %String
{
	N (id,hospdr)
	W "["
	S count=0
	/// 入参为 "Root" ,显示默认根节点 + 父表元素树
	I id="Root" D
	.W ##class(web.DHCADVJSONCOMMON).getJsonTreeStartSign("Root","事件分类根目录","0")
	.W ","""_"state"_""""_":"_""""_"open"_""","""_"children"_""""_":"
	.D ..jsonCheckType(0,hospdr)
	.W "}"
	S ParID=0
	I id=0  D
	.F  S ParID=$o(^DHCMEDADREVT(ParID)) Q:ParID=""  D
	..Q:+ParID=0
	..S ParCode=$p(^DHCMEDADREVT(ParID),"^",1) //代码
	..S ParDesc=$p(^DHCMEDADREVT(ParID),"^",2) //描述
	..S ParActive=$p(^DHCMEDADREVT(ParID),"^",3) //是否可用
	..Q:##class(web.DHCADVFormName).CheckFormName(ParCode,hospdr)'=1
	..Q:ParActive="N"
	..S ParLevel=1  ; 父表数据默认第一层数据为1级 
	..S Levelrowid=""
	..S ParTempStr=ParID_"^"_ParDesc_"^"_ParLevel_"^"_Levelrowid
	..S count = count+1
	..I count=1 D
	...W ##class(web.DHCADVJSONCOMMON).getJsonTreeStartSign(ParID,ParDesc,ParLevel)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonTreeStartSign(ParID,ParDesc,ParLevel)
    ..///  是否存在孩子节点
	..S SubID=$o(^DHCMEDADREVTI(ParID,"MADREVI",""))
	..I SubID'="" D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonTreeClosedSign()
	..W "}"
	E  D
	.D ..jsonCheckTypeItm(id,hospdr)  //入参为父表id或子表id，加载子表元素树
	W "]"
  	Q ""
}

/// Creater:    congyue
/// CreateDate: 2019-06-05
/// Descript:   不良事件报告类型 加载子元素树
/// w ##Class(web.DHCADVMEDEVENTADD).jsonCheckType("")
ClassMethod jsonCheckTypeItm(ParentID, hospdr = "") As %String
{
	n (ParentID,hospdr)
	s h=0
	s SubID=""
	
	i ParentID'["||"  d
	.///入参为父表id，加载此父表id下的子元素树
	.F  S SubID=$o(^DHCMEDADREVTI(ParentID,"MADREVI",SubID)) Q:SubID=""  D
	..Q:+SubID=0
	..S Code=$p(^DHCMEDADREVTI(ParentID,"MADREVI",SubID),"^",1)  //代码
	..S Desc=$p(^DHCMEDADREVTI(ParentID,"MADREVI",SubID),"^",2)  //描述
	..Q:##class(web.DHCADVFormName).CheckFormName(Code,hospdr)'=1
	..S Level=$p(^DHCMEDADREVTI(ParentID,"MADREVI",SubID),"^",4) //级别
	..Q:Level'="2"  ; 子表数据默认第一层数据为2级 
	..S Levelrowid=$p(^DHCMEDADREVTI(ParentID,"MADREVI",SubID),"^",5) //上一级别的rowid
	..S Active=$p(^DHCMEDADREVTI(ParentID,"MADREVI",SubID),"^",3) //是否可用
	..Q:ParentID'=Levelrowid  ; 入参与父元素指向id不相等则退出
	..Q:Active="N"
	..S RowId=ParentID_"||"_SubID
	..S h=h+1
	..I h=1 D
	...W ##class(web.DHCADVJSONCOMMON).getJsonTreeStartSign(RowId,Desc,Level)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonTreeStartSign(RowId,Desc,Level)
    ..///  是否存在孩子节点
	..S ChildID=$o(^DHCMEDADREVTI(0,"ItmLevelDr",RowId,""))
	..I ChildID'="" D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonTreeClosedSign()
	..W "}"
	E  D
	.///入参为子表id，加载此子表id下的子元素树
	.S Parref=""
	.F  S Parref=$o(^DHCMEDADREVTI(0,"ItmLevelDr",ParentID,Parref)) Q:Parref=""  D
	..Q:+Parref=0
	..S SubID=""
	..F  S SubID=$o(^DHCMEDADREVTI(0,"ItmLevelDr",ParentID,Parref,SubID)) Q:SubID=""  D
	...Q:+SubID=0
	...S Code=$p(^DHCMEDADREVTI(Parref,"MADREVI",SubID),"^",1)  //代码
	...Q:##class(web.DHCADVFormName).CheckFormName(Code,hospdr)'=1
	...S Desc=$p(^DHCMEDADREVTI(Parref,"MADREVI",SubID),"^",2)  //描述
	...S Level=$p(^DHCMEDADREVTI(Parref,"MADREVI",SubID),"^",4) //级别
	...S Levelrowid=$p(^DHCMEDADREVTI(Parref,"MADREVI",SubID),"^",5) //上一级别的rowid
	...S Active=$p(^DHCMEDADREVTI(Parref,"MADREVI",SubID),"^",3) //是否可用
	...Q:ParentID'=Levelrowid  ; 入参与父元素指向id不相等则退出
	...Q:Active="N"
	...S RowId=Parref_"||"_SubID
	...S h = h+1
	...I h=1 D
	....W ##class(web.DHCADVJSONCOMMON).getJsonTreeStartSign(RowId,Desc,Level)
	...E  D
	....W ","_##class(web.DHCADVJSONCOMMON).getJsonTreeStartSign(RowId,Desc,Level)
    ...///  是否存在孩子节点
	...S ChildID=$o(^DHCMEDADREVTI(0,"ItmLevelDr",RowId,""))
	...I ChildID'="" D
	....W ","_##class(web.DHCADVJSONCOMMON).getJsonTreeClosedSign()
	...W "}"

  	Q ""
}

/// Description: 获取[该id树以上的所有父节点]
/// Creator:     CongYue
/// CreateDate:  2019-07-09
/// Table:		 DHC_MedAdrRepEventItm
/// Input:  	 ItmID:节点id
/// w ##class(web.DHCADVMEDEVENTADD).GetItmLevCon("20||3")
ClassMethod GetItmLevCon(ItmID As %String) As %String
{
	N (ItmID)
	Q:ItmID'["||" ItmID
	S LastItmID=$p(^DHCMEDADREVTI(+ItmID,"MADREVI",$p(ItmID,"||",2)),"^",6)  /// 上一级ID
	Q:LastItmID=0 ItmID
	
	S LastItmID=..GetItmLevCon(LastItmID)
	Q LastItmID_"^"_ItmID
}

/// Description: 事件分类复制--事件分类数据保存（复制事件分类及权限）
/// Creator:     CongYue
/// CreateDate:  2021-06-30
/// Table:		 DHC_MedAdrRepEvent,DHC_MedAdrRepEventItm,DHC_AdvQuerySec
/// Input:  	 Code:新增事件分类代码 , Desc:新增事件分类描述 , CopyID:复制事件分类ID, Parentid: 父元素id
/// w ##class(web.DHCADVMEDEVENTADD).CopyEventInfo("121","121","108||1","108")
ClassMethod CopyEventInfo(Code As %String, Desc As %String, CopyID As %String, ParentID As %String) As %String
{
	N (Code,Desc,CopyID,ParentID)
	
	S $zt="err"
	
	S ret=0
	TStart
	
	/// 保存事件分类
 	S:+ParentID=0 EventID=##class(web.DHCADVMEDEVENTADD).CopyEvent(Code,Desc,CopyID,ParentID)

	/// 保存事件子分类
 	S:+ParentID'=0 EventID=##class(web.DHCADVMEDEVENTADD).CopyEventItm(Code,Desc,CopyID,ParentID)

	I EventID<0 TRollback
	Q:EventID<0 EventID
	
	/// 保存权限
 	S ret=##class(web.DHCADVMEDEVENTADD).CopyEventGrant(EventID,CopyID)

	I ret'=0 TRollback
	Q:ret'=0 ret
	
	TCOMMIT
	Q ret
err
	TRollback
	Q -20
}

/// Description: 事件分类复制-事件分类保存（复制事件分类）
/// Creator:     CongYue
/// CreateDate:  2021-03-19
/// Table:		 DHC_MedAdrRepEvent
/// Input:  	 Code:新增事件分类代码 , Desc:新增事件分类描述 , CopyID:复制事件分类ID, Parentid: 父元素id
/// w ##class(web.DHCADVMEDEVENTADD).CopyEvent()
ClassMethod CopyEvent(Code As %String, Desc As %String, CopyID As %String, ParentID As %String) As %String
{
	N (Code,Desc,CopyID,ParentID)
	S Flag=0
	Q:$d(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(Code))) "-1" ; 判断代码是否存在
	Q:$d(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(Code))) "-1"  ; 判断代码是否存在
	S EvtObj=##class(User.DHCMedAdrRepEvent).%New()
	S EvtObj.MADREVCode=Code
	S EvtObj.MADREVDesc=Desc
	S EvtObj.MADREVActiveFlag="Y"
	S SC=EvtObj.%Save()
	S Flag=EvtObj.%Id()
 	S:$$$ISERR(SC) Flag="-10"
	Q Flag
}

/// Description: 事件分类复制-事件子分类保存（复制事件子分类）
/// Creator:     CongYue
/// CreateDate:  2021-03-19
/// Table:		 DHC_MedAdrRepEventItm
/// Input:  	 Code:新增事件分类代码 , Desc:新增事件分类描述 , CopyID:复制事件分类ID, Parentid: 父元素id
/// w ##class(web.DHCADVMEDEVENTADD).CopyEventItm()
ClassMethod CopyEventItm(Code As %String, Desc As %String, CopyID As %String, ParentID As %String) As %String
{
	N (Code,Desc,CopyID,ParentID)
	S Flag=0
	Q:$d(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(Code))) "-1" ; 判断代码是否存在
	Q:$d(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(Code))) "-1"  ; 判断代码是否存在
	S SubID=$p(CopyID,"||",2)
	S Level=$p(^DHCMEDADREVTI(+CopyID,"MADREVI",SubID),"^",4) //级别
	S Levelrowid=$p(^DHCMEDADREVTI(+CopyID,"MADREVI",SubID),"^",5) //上一级别的rowid
	
	S EvtItmObj=##class(User.DHCMedAdrRepEventItm).%New()
	D EvtItmObj.MADREVIParrefSetObjectId(ParentID) 
	S EvtItmObj.MADREVICode=Code
	S EvtItmObj.MADREVIDesc=Desc
	S EvtItmObj.MADREVIActiveFlag="Y"
	S EvtItmObj.MADREVILevel=Level
	S EvtItmObj.MADREVILevelRowID=Levelrowid
	S EvtItmObj.MADREVIChildSub=$o(^DHCMEDADREVTI(+CopyID,"MADREVI",""),-1)+1
	S SC=EvtItmObj.%Save()
	S Flag=EvtItmObj.%Id()
 	S:$$$ISERR(SC) Flag="-10"
	Q Flag
}

/// Description: 事件分类复制-权限保存（保存事件分类相关权限信息）
/// Creator:     CongYue
/// CreateDate:  2021-03-19
/// Table:		 DHC_AdvQuerySec
/// Input:  	 EventID:事件分类id, CopyID:复制事件分类ID
/// w ##class(web.DHCADVMEDEVENTADD).CopyEventGrant()
ClassMethod CopyEventGrant(EventID As %String, CopyID As %String) As %String
{
	N (EventID,CopyID)
	S Flag=0
	S AdvqsID="" 
	S TypeID=""
	S PointID=""
	F  S TypeID=$o(^DHCADVQUS(0,"RepType",CopyID,TypeID)) Q:(TypeID="")||(Flag="-11")  D
	.F  S PointID=$o(^DHCADVQUS(0,"RepType",CopyID,TypeID,PointID))  Q:(PointID="")||(Flag="-11")  D
	..F  S AdvqsID=$o(^DHCADVQUS(0,"RepType",CopyID,TypeID,PointID,AdvqsID))  Q:(AdvqsID="")||(Flag="-11")  D
	...Q:(+AdvqsID=0)||(+AdvqsID<0)
	...S SecFlag=$p(^DHCADVQUS(AdvqsID),"^",4) // 权限值 1仅自已,2仅本科室,3全院
	...S AssessFlag=$p(^DHCADVQUS(AdvqsID),"^",5)   //评估权限     wangxuejian 2016/10/18
	...S ShareFlag=$p(^DHCADVQUS(AdvqsID),"^",7)   //分享权限     ylp 2017/12/11
	...S FocusFlag=$p(^DHCADVQUS(AdvqsID),"^",8)   //重点关注权限     ylp 2017/12/11
	...S FileFlag=$p(^DHCADVQUS(AdvqsID),"^",9)			// 归档权限
	...S CaseShareFlag=$p(^DHCADVQUS(AdvqsID),"^",10)			// 案例共享权限
	...S DeleteFlag=$p(^DHCADVQUS(AdvqsID),"^",11)			// 删除权限
	...S CancelFlag=$p(^DHCADVQUS(AdvqsID),"^",12)			// 作废权限
	...S SecHospDr=$p(^DHCADVQUS(AdvqsID),"^",13)			// 医院
	...S AdvqsObj=##class(User.DHCAdvQuerySec).%New()
	...S AdvqsObj.ADVQSRepTyepDr=EventID 
	...S AdvqsObj.ADVQSType=TypeID
	...S AdvqsObj.ADVQSPointer=PointID
	...S AdvqsObj.ADVQSSecFlag=SecFlag
	...S AdvqsObj.ADVQSAssessFlag=AssessFlag 
	...S AdvqsObj.ADVQSShareFlag=ShareFlag
	...S AdvqsObj.ADVQSFocusFlag=FocusFlag
	...S AdvqsObj.ADVQSFileFlag=FileFlag
	...S AdvqsObj.ADVQSCaseShareFlag=CaseShareFlag 
	...S AdvqsObj.ADVQSDeleteFlag=DeleteFlag
	...S AdvqsObj.ADVQSCancelFlag=CancelFlag
	...D AdvqsObj.ADVQSHospDrSetObjectId(SecHospDr)
	...S SC=AdvqsObj.%Save()
 	...S:$$$ISERR(SC) Flag="-11"
 	...Q:Flag="-11"
	Q Flag
}

}
