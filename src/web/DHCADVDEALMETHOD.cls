Import sqluser

Class web.DHCADVDEALMETHOD Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 保存[不良事件处理办法] 
/// Creator:     yangyongtao
/// CreateDate:  2016-03-25
/// Table:	     DHC_AdvDealMethod 
/// Input:  	
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVDEALMETHOD).SaveAdvDeal("9^药品^输血^错误^Y")
ClassMethod SaveAdvDeal(DataList As %String) As %String
{
	N (DataList)
	S len=$L(DataList,"||")
	F i=1:1:len D
	.S TmpStr=$p(DataList,"||",i)
	.s Err=..CheckRepeatDeal(TmpStr)   /// 重复性判断
	.q:Err'=0
	.I $p(TmpStr,"^",1)'="" D
	..S Err=..UpdAdvDeal(TmpStr)
	.E  D
	..S Err=..InsAdvDeal(TmpStr)
	Q Err
}

/// Description: 增加[不良事件处理办法]
/// Creator:     yangyongtao
/// CreateDate:  2016-03-25
/// Table:		 DHC_AdvDealMethod 
/// Input:  	 DataList:以字符"^"分割,格式为: id^代码^描述^标志
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVDEALMETHOD).InsAdvDeal("^输血^血型错误^Y")
ClassMethod InsAdvDeal(DataList As %String) As %String
{
	N (DataList)
	S ADMECode=$p(DataList,"^",2)
	S ADMEDesc=$p(DataList,"^",3)
	S ADMEActiveFlag=$p(DataList,"^",4)
	S ADMEHospDr=$p(DataList,"^",5) //hxy 2019-07-02
 	&SQL(INSERT INTO DHC_AdvDealMethod(ADME_Code,ADME_Desc,ADME_ActiveFlag,ADME_Hosp_Dr) VALUES(:ADMECode,:ADMEDesc,:ADMEActiveFlag,:ADMEHospDr))
 	Q SQLCODE
}

/// Description: 修改[不良事件处理办法]
/// Creator:     yangyongtao
/// CreateDate:  2016-03-25
/// Table:		 DHC_AdvDealMethod
/// Input:  	 DataList: 以字符"^"分割,格式为: id^代码^描述^标志
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVDEALMETHOD).UpdAdvDeal("1^输血^血型错误^Y")
ClassMethod UpdAdvDeal(DataList As %String) As %String
{
	N (DataList)
	S ADMEID=$p(DataList,"^",1)
	S ADMECode=$p(DataList,"^",2)
	S ADMEDesc=$p(DataList,"^",3)
	S ADMEActiveFlag=$p(DataList,"^",4)
	S Hosp=$p(DataList,"^",5) //hxy 2019-07-01 st
	S HospDr=$p(DataList,"^",6) 
	s ADMEHospDr=""
	S:+Hosp=0 ADMEHospDr=HospDr
	S:+Hosp'=0 ADMEHospDr=Hosp //ed
	&SQL(Update DHC_AdvDealMethod Set ADME_Code=:ADMECode,ADME_Desc=:ADMEDesc,ADME_ActiveFlag=:ADMEActiveFlag,ADME_Hosp_Dr=:ADMEHospDr WHERE ADME_RowID=:ADMEID)
 	Q SQLCODE
}

/// Description: 删除[不良事件处理办法]
/// Creator:     yangyongtao
/// CreateDate:  2016-03-25
/// Table:		 DHC_AdvDealMethod
/// Input:    	 数据id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVDEALMETHOD).DelAdvDeal("1")
ClassMethod DelAdvDeal(ADMEID As %String) As %String
{
	N (ADMEID)
	Q:$d(^DHCADVREPMAN(0,"DealMeth",ADMEID)) "-1" //判断此处理办法是否存在报告使用记录
	&SQL(Delete From DHC_AdvDealMethod Where ADME_RowID=:ADMEID)
	Q SQLCODE
}

/// Descript:检查代码是否重复
ClassMethod CheckRepeatDeal(TmpStr As %String) As %String
{
	N (TmpStr)
	s ADMEID=$p(TmpStr,"^",1)   		///ID
	s ADMECode=$p(TmpStr,"^",2)   	///代码
	/// 新记录
	q:(ADMEID="")&($d(^DHCADVDEMED(0,"Code",$$ALPHAUP^SSUTIL4(ADMECode)))) "-1"
	q:ADMEID="" 0
	
	/// 修改记录
	s Code=$p($g(^DHCADVDEMED(ADMEID)),"^",1)    //代码
	q:(ADMECode'=Code)&($d(^DHCADVDEMED(0,"Code",$$ALPHAUP^SSUTIL4(ADMECode)))) "-2"
	q 0
}

/// Description: 查询[不良事件处理办法]
/// Creator:     yangyongtao
/// CreateDate:  2016-03-25
/// Table:		 DHC_AdvDealMethod
/// Input:  	 params:类型描述
/// Others:		 w ##class(web.DHCADVDEALMETHOD).QueryAdvDeal("12","1","")
ClassMethod QueryAdvDeal(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S End = page*rows
	S Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    S admeCode=$P(params,"^",1)
    S admeDesc=$P(params,"^",2)
    s hospDrID=$P(params,"^",3)
	S h=0,count=0
	S ID="0"
	F  S ID=$o(^DHCADVDEMED(ID)) Q:ID=""  D
	.S Code=$p(^DHCADVDEMED(ID),"^",1) //代码
	.S Desc=$p(^DHCADVDEMED(ID),"^",2) //描述
	.S Active=$p(^DHCADVDEMED(ID),"^",3) //是否可用
	.q:(admeCode'="")&(Code'[admeCode) //判断admeCode是否为空，'[ 为包含的意思
	.q:(admeDesc'="")&(Desc'[admeDesc)  //判断admeDesc是否为空，'[ 为包含的意思
	.s HospID=$p(^DHCADVDEMED(ID),"^",4) //hxy 2019-07-02 st
	.q:(hospDrID'="")&(hospDrID'=HospID) //hxy 2019-07-20
	.s Hosp=""
	.i HospID'="" s Hosp=$P(^CT("HOSP",HospID),"^",2) //ed
	.S h=h+1
	.S TempStr=ID_"^"_Code_"^"_Desc_"^"_Active_"^"_Hosp_"^"_HospID
	.S ^TMP("DHCST","web.DHCADVDEALMETHOD","QueryAdvDeal",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc^Active^Hosp^HospID"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCADVDEALMETHOD","QueryAdvDeal",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCST","web.DHCADVDEALMETHOD","QueryAdvDeal",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// ================不良事件改进办法==============================================
/// Description: 保存[不良事件改进办法] 
/// Creator:     yangyongtao
/// CreateDate:  2016-03-25
/// Table:	     DHC_AdvImpMethod 
/// Input:  	
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVDEALMETHOD).SaveAdvImp("^器械^器械错误^N")
ClassMethod SaveAdvImp(DataList As %String) As %String
{
	N (DataList)
	S len=$L(DataList,"||")
	F i=1:1:len D
	.S TmpStr=$p(DataList,"||",i)
	.s Err=..CheckRepeatImp(TmpStr)   /// 重复性判断
	.q:Err'=0
	.I $p(TmpStr,"^",1)'="" D
	..S Err=..UpdAdvImp(TmpStr)
	.E  D
	..S Err=..InsAdvImp(TmpStr)
	Q Err
}

/// Description: 增加[不良事件改进办法]
/// Creator:     yangyongtao
/// CreateDate:  2016-03-25
/// Table:		 DHC_AdvImpMethod 
/// Input:  	 DataList:以字符"^"分割,格式为: id^代码^描述^标志
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVDEALMETHOD).InsAdvImp("^输血^血型错误^Y")
ClassMethod InsAdvImp(DataList As %String) As %String
{
	N (DataList)
	S AIMECode=$p(DataList,"^",2)
	S AIMEDesc=$p(DataList,"^",3)
	S AIMEActiveFlag=$p(DataList,"^",4)
	S AIMEHospDr=$p(DataList,"^",5) //hxy 2019-07-01
 	&SQL(INSERT INTO DHC_AdvImpMethod(AIME_Code,AIME_Desc,AIME_ActiveFlag,AIME_Hosp_Dr) VALUES(:AIMECode,:AIMEDesc,:AIMEActiveFlag,:AIMEHospDr))
 	Q SQLCODE
}

/// Description: 修改[不良事件改进办法]
/// Creator:     yangyongtao
/// CreateDate:  2016-03-25
/// Table:		 DHC_AdvImpMethod
/// Input:  	 DataList: 以字符"^"分割,格式为: id^代码^描述^标志
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVDEALMETHOD).UpdAdvImp("1^输血^血型错误^Y")
ClassMethod UpdAdvImp(DataList As %String) As %String
{
	N (DataList)
	S AIMEID=$p(DataList,"^",1)
	S AIMECode=$p(DataList,"^",2)
	S AIMEDesc=$p(DataList,"^",3)
	S AIMEActiveFlag=$p(DataList,"^",4)
	S Hosp=$p(DataList,"^",5) //hxy 2019-07-01 st
	S HospDr=$p(DataList,"^",6) 
	s AIMEHospDr=""
	S:+Hosp=0 AIMEHospDr=HospDr
	S:+Hosp'=0 AIMEHospDr=Hosp //ed
	&SQL(Update DHC_AdvImpMethod Set AIME_Code=:AIMECode,AIME_Desc=:AIMEDesc,AIME_ActiveFlag=:AIMEActiveFlag,AIME_Hosp_Dr=:AIMEHospDr WHERE AIME_RowID=:AIMEID)
 	Q SQLCODE
}

/// Description: 删除[不良事件改进办法]
/// Creator:     yangyongtao
/// CreateDate:  2016-03-25
/// Table:		 DHC_AdvImpMethod
/// Input:    	 数据id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVDEALMETHOD).DelAdvImp("2")
ClassMethod DelAdvImp(AIMEID As %String) As %String
{
	N (AIMEID)
	Q:$d(^DHCADVREPMAN(0,"ImpMeth",AIMEID)) "-1" //判断此改进办法是否存在报告使用记录
	&SQL(Delete From DHC_AdvImpMethod Where AIME_RowID=:AIMEID)
	Q SQLCODE
}

/// Descript:检查代码是否重复
ClassMethod CheckRepeatImp(TmpStr As %String) As %String
{
	N (TmpStr)
	s AIMEID=$p(TmpStr,"^",1)   		///ID
	s AIMECode=$p(TmpStr,"^",2)   	///代码
	/// 新记录
	q:(AIMEID="")&($d(^DHCADVIMPMED(0,"Code",$$ALPHAUP^SSUTIL4(AIMECode)))) "-1"
	q:AIMEID="" 0
	
	/// 修改记录
	s Code=$p($g(^DHCADVIMPMED(AIMEID)),"^",1)    //代码
	q:(AIMECode'=Code)&($d(^DHCADVIMPMED(0,"Code",$$ALPHAUP^SSUTIL4(AIMECode)))) "-2"
	q 0
}

/// Description: 查询[不良事件改进办法]
/// Creator:     yangyongtao
/// CreateDate:  2016-03-25
/// Table:		 DHC_AdvImpMethod
/// Input:  	 params:类型描述
/// Others:		 w ##class(web.DHCADVDEALMETHOD).QueryAdvImp("12","1","")
ClassMethod QueryAdvImp(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S End = page*rows
	S Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    S aimeCode=$P(params,"^",1)
    S aimeDesc=$P(params,"^",2)
    S hospDrID=$P(params,"^",3) //hxy 2019-07-20
	S h=0,count=0
	S ID="0"
	F  S ID=$o(^DHCADVIMPMED(ID)) Q:ID=""  D
	.S Code=$p(^DHCADVIMPMED(ID),"^",1) //代码
	.S Desc=$p(^DHCADVIMPMED(ID),"^",2) //描述
	.S Active=$p(^DHCADVIMPMED(ID),"^",3) //是否可用
	.q:(aimeCode'="")&(Code'[aimeCode) //判断admeCode是否为空，'[ 为包含的意思
	.q:(aimeDesc'="")&(Desc'[aimeDesc)  //判断admeDesc是否为空，'[ 为包含的意思
	.s HospID=$p(^DHCADVIMPMED(ID),"^",4) //hxy 2019-07-01 st
	.q:(hospDrID'="")&(hospDrID'=HospID) //hxy 2019-07-20
	.s Hosp=""
	.i HospID'="" s Hosp=$P(^CT("HOSP",HospID),"^",2) //ed
	.S h=h+1
	.S TempStr=ID_"^"_Code_"^"_Desc_"^"_Active_"^"_Hosp_"^"_HospID
	.S ^TMP("DHCST","web.DHCADVDEALMETHOD","QueryAdvImp",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc^Active^Hosp^HospID"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCADVDEALMETHOD","QueryAdvImp",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCST","web.DHCADVDEALMETHOD","QueryAdvImp",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// ================不良反应报告事件名称==============================================
/// Description: 保存[不良反应报告事件名称] 
/// Creator:     yangyongtao
/// CreateDate:  2016-03-25
/// Table:	     DHC_AdvDrugEvent
/// Input:  	
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVDEALMETHOD).SaveAdvEvent("^器械^器械错误^N")
ClassMethod SaveAdvEvent(DataList As %String) As %String
{
	N (DataList)
	S len=$L(DataList,"||")
	F i=1:1:len D
	.S TmpStr=$p(DataList,"||",i)
	.s Err=..CheckRepeatEvent(TmpStr)   /// 重复性判断
	.q:Err'=0
	.I $p(TmpStr,"^",1)'="" D
	..S Err=..UpdAdvEvent(TmpStr)
	.E  D
	..S Err=..InsAdvEvent(TmpStr)
	Q Err
}

/// Description: 增加[不良反应报告事件名称]
/// Creator:     yangyongtao
/// CreateDate:  2016-03-25
/// Table:		 DHC_AdvDrugEvent
/// Input:  	 DataList:以字符"^"分割,格式为: id^代码^描述^标志
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVDEALMETHOD).InsAdvEvent("^输血^血型错误^Y")
ClassMethod InsAdvEvent(DataList As %String) As %String
{
	N (DataList)
	S ADVDECode=$p(DataList,"^",2)
	S ADVDEDesc=$p(DataList,"^",3)
 	&SQL(INSERT INTO DHC_AdvDrugEvent(ADVDE_Code,ADVDE_Desc) VALUES(:ADVDECode,:ADVDEDesc))
 	Q SQLCODE
}

/// Description: 修改[不良反应报告事件名称]
/// Creator:     yangyongtao
/// CreateDate:  2016-03-25
/// Table:		 DHC_AdvDrugEvent
/// Input:  	 DataList: 以字符"^"分割,格式为: id^代码^描述^标志
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVDEALMETHOD).UpdAdvEvent("1^输血^血型错误^Y")
ClassMethod UpdAdvEvent(DataList As %String) As %String
{
	N (DataList)
	S ADVDEID=$p(DataList,"^",1)
	S ADVDECode=$p(DataList,"^",2)
	S ADVDEDesc=$p(DataList,"^",3)
	&SQL(Update DHC_AdvDrugEvent Set ADVDE_Code=:ADVDECode,ADVDE_Desc=:ADVDEDesc WHERE ADVDE_RowID=:ADVDEID)
 	Q SQLCODE
}

/// Description: 删除[不良反应报告事件名称]
/// Creator:     yangyongtao
/// CreateDate:  2016-03-25
/// Table:		 DHC_AdvDrugEvent
/// Input:    	 数据id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVDEALMETHOD).DelAdvEvent("4")
ClassMethod DelAdvEvent(ADVDEID As %String) As %String
{
	N (ADVDEID)
	Q:$d(^DHCADVDRUGREP(0,"DrugEvent",ADVDEID)) "-1" //判断此事件名称是否存在报告使用记录
	&SQL(Delete From DHC_AdvDrugEvent Where ADVDE_RowID=:ADVDEID)
	Q SQLCODE
}

/// Descript:检查代码是否重复
ClassMethod CheckRepeatEvent(TmpStr As %String) As %String
{
	N (TmpStr)
	s ADVDEID=$p(TmpStr,"^",1)   		///ID
	s ADVDECode=$p(TmpStr,"^",2)   	///代码
	/// 新记录
	q:(ADVDEID="")&($d(^DHCADVDRUGEV(0,"Code",$$ALPHAUP^SSUTIL4(ADVDECode)))) "-1"
	q:ADVDEID="" 0
	
	/// 修改记录
	s Code=$p($g(^DHCADVDRUGEV(ADVDEID)),"^",1)    //代码
	q:(ADVDECode'=Code)&($d(^DHCADVDRUGEV(0,"Code",$$ALPHAUP^SSUTIL4(ADVDECode)))) "-2"
	q 0
}

/// Description: 查询[不良反应报告事件名称]
/// Creator:     yangyongtao
/// CreateDate:  2016-03-25
/// Table:		 DHC_AdvDrugEvent
/// Input:  	 params:类型描述
/// Others:		 w ##class(web.DHCADVDEALMETHOD).QueryAdvEvent("12","1","")
ClassMethod QueryAdvEvent(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S End = page*rows
	S Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    S advdeCode=$P(params,"^",1)
    S advdeDesc=$P(params,"^",2)
	S h=0,count=0
	S ID="0"
	F  S ID=$o(^DHCADVDRUGEV(ID)) Q:ID=""  D
	.S Code=$p(^DHCADVDRUGEV(ID),"^",1) //代码
	.S Desc=$p(^DHCADVDRUGEV(ID),"^",2) //描述
	.q:(advdeCode'="")&(Code'[advdeCode) //判断admeCode是否为空，'[ 为包含的意思
	.q:(advdeDesc'="")&(Desc'[advdeDesc)  //判断admeDesc是否为空，'[ 为包含的意思
	.S h=h+1
	.S TempStr=ID_"^"_Code_"^"_Desc
	.S ^TMP("DHCST","web.DHCADVDEALMETHOD","QueryAdvEvent",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCADVDEALMETHOD","QueryAdvEvent",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCST","web.DHCADVDEALMETHOD","QueryAdvEvent",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	K ^TMP("DHCST","web.DHCADVDEALMETHOD","QueryAdvDeal",pid)
	K ^TMP("DHCST","web.DHCADVDEALMETHOD","QueryAdvImp",pid)
	K ^TMP("DHCST","web.DHCADVDEALMETHOD","QueryAdvEvent",pid)
}

}
