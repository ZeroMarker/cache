Include webimport

IncludeGenerator webimport

Class web.DHCSTPHCMPASS Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// ///////////////////////////////////////////////////调用知识库进行效验////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Description:	调用知识库进行效验
/// Creator:		(QuNianpeng 修改)
/// CreateDate:		(2017-08-04	修改)
/// Input:			返回信息,知识库类型,医嘱信息串,用户信息串
/// return:			效验结果
/// other:	
/// w ##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,"C","17!1532||1^12^4^20^19^^4^1^0"_$c(1)_"4^^^313!6||1","4634^110^29")
/// w ##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,"A","69!!","5083^137^134")
/// w ##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,"C","1042!337||1^12^5^0.3^66^1^66^5^^^^311^967||36","4638^311^37")
/// w ##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,"Q1","108!336||1^^^^^1^116^^0"_$c(1)_"1^SP004^^282!","10209^95^29")
/// 高危测试 w ##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,"C","6!1^^^^^^^^^^^^!!Oper","10362^97^29")	
/// 术前检查测试 w ##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,"C","32!1^^^^^^^^^^^^!!Oper","10362^97^29")
/// 术前检验测试 w ##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,"C","42!1^^^^^^^^^^^^!!Oper","10362^97^29")
/// w ##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,"C","5!403||1^12^27^20^269^^18^1^0"_$c(1)_"1^^^244!5||7"_$c(2)_"5||9"_$c(2)_"5||40"_$c(2)_"5||41"_$c(2)_"5||60"_$c(2)_"5||61"_$c(2)_"5||140"_$c(2)_"5||142"_$c(2)_"5||143"_$c(2)_"5||144"_$c(2)_"5||145"_$c(2)_"5||146"_$c(2)_"5||157"_$c(2)_"5||158","10209^95^30")
/// w ##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,"C","1092!283||1^12^21^0.45^66^1^18^1^0"_$c(1)_"1^^^243!","10209^6^28")
/// w ##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,"C","1002!76!!Oper","32^95^28")
ClassMethod CheckLibPha(ByRef retStr As %String, libLabel As %String, input As %String, userInfo As %String) As %String
{
	n (retStr,libLabel, input, userInfo)
	//s ^qunianpeng=$lb(libLabel,input,userInfo)
		
	q:(libLabel="")||(input="") ""

	/// 处理用户登录信息  
	s accInfo=##class(web.DHCSTPHCMPASS).DealUserInfo(userInfo)


	/// 拆分未提交的医嘱项串和已提交的医嘱串		k
    s adm=$p(input,"!",1)				 // 就诊id
    s ordStr=$p(input,"!",2)	 		 // 本次就诊医嘱信息
    s ordItem=$p(input,"!",3)	 		 // 历次就诊医嘱id串
    s admType=$case(adm'="",1:$p($g(^PAADM(adm)),"^",2),:"")	// O 门诊
    i (admType="O")||(admType="E") s ordStrItem=##class(web.DHCSTPHCMPASSFUN).GetOutValidOeori(adm)	// 门诊取一个月内的有效医嘱
	e  s ordStrItem=##class(web.DHCSTPHCMPASS).GetUseOrdStr(ordItem)    // 处理医嘱，只需有效医嘱和当日临嘱 
    //s ordStrItem=ordItem			     // 历次就诊医嘱id串 用于重复用药
    i ordStr'="" s ordItem=""            // 不同时监测界面未审核医嘱和已审核医嘱
	s checkType=$p(input,"!",4)			 // 调用类型(Oper-手术)

	s arci=$p(ordStr,"^",1)  
    s hisPart=$p(ordStr,"^",11)      	//     
    s hisSpec=$p(ordStr,"^",10)
    s tmpPointer=$case(hisPart,"":hisSpec,:hisPart)	// 部位/标本
    
    i libLabel="Q" d					//判断知识库类型    
    .s retStr="^^"_##class(web.DHCSTPHCMPASS).GetLibDataForWin(arci,tmpPointer,ordItem)	// 调用Q类型查询
    q:libLabel="Q" $g(retStr)
    
    i libLabel="Q1" d  
    .s retStr=##class(web.DHCSTPHCMPASSFUN).GetLabelTips(arci,tmpPointer,ordItem)		// 2019/11/21
   	q:libLabel="Q1" $g(retStr)     
    
    i libLabel="A" s retStr="^^"_##class(web.DHCSTPHCMPASS).GetArcIndDataForWin(adm)     			// 调用A类型建议医嘱
    q:libLabel="A" $g(retStr)

	/// 界面的本次医嘱项串和已审核的医嘱id串进行拼接处理
	s ordStr=##class(web.DHCSTPHCMPASS).DealOrdStr(ordStr,ordItem)
	s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid() 
	
	/// 获取过敏史
	d ##class(web.DHCSTPHCMPASS).GetAlgDesc(adm,pid)
 	    
	/// 遍历知识库规则，并用临时global暂存
	d ##class(web.DHCSTPHCMPASS).TraversalRules(accInfo,pid)   	
	
	/// 开始审查
	s retStr=""  
	s arrcnt=$l(ordStr,$c(2))
	
	f i=1:1:arrcnt d
	.s (libGenDr,hisGeneDesc,pointer,libProDr,libProCode,drugInfo,libDr,hisDosQtyInfo)=""	// 知识库通用名id,his通用名描述,pointer，商品名id,商品名code,药品信息,标识id
	.s itmStr=$p(ordStr,$c(2),i)	
	.s arci=$p(itmStr,"^",1)
	.q:arci=""
	.//i checkType'="Oper" s sub=$p(arci,"||",1),ver=$p(arci,"||",2)
	.s course=$p(itmStr,"^",8)	  								// 疗程
	.s seqNo=$p(itmStr,"^",9)    							 	// 关联序号
	.;s tmppart=$p(itmstr,"^",10) 								// 标本(检验)
	.s hisPart=$p(itmStr,"^",11)  								// 部位(检查)
    .s oeori=$p(itmStr,"^",13)   								// 医嘱id 	
	.s orderType=$p(..GetCommonTypeInfo(arci,hisPart,checkType),",",1)	// 获取医嘱类型
	.s commonInfo=$p(..GetCommonTypeInfo(arci,hisPart,checkType),",",2)   // 获取通用名,商品名
	.q:(orderType="")||(commonInfo="")
	.i orderType="R" d	 		    							// 药品医嘱
	..s libDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("DRUG","U"),""))
	..s instId=$p(itmStr,"^",2)									// 用法
    ..s instCode=$p($g(^PHCIN(+instId)),"^",1)
    ..s freqId=$p(itmStr,"^",3)									// 频次
    ..s (freqFac,freqCode,oneDayTime,dayMaxQty)=""
    ..s:freqId'="" freqFac=$p($g(^PHCFR(freqId)),"^",2)
    ..s:freqId'="" freqCode=$p($g(^PHCFR(freqId)),"^",1)
    ..s oneDayTime=$g(freqFac)									// 用药次数
	..s dosQty=$p(itmStr,"^",4)            						// 剂量（单次服药量/单次最大量）
	..s dosUomId=$p(itmStr,"^",5)           					// 剂量单位	
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arci,"||",1),""))  
	..s buomDr=$p(^INCI(inci,1),"^",10)
	..s dayMaxQty=$g(freqFac)*dosQty		   					// 每日最大量/每日总量
	..s hisDosQtyInfo=arci_","_dosUomId_","_dosQty_","_dayMaxQty_","_oneDayTime //用药量信息串,用于用法用量判断 （医嘱项id,单位,单次用药量/单次最大量,每日最大量/每日总量,用药次数,首次用药量,连用量,间隔数）
	..s drugInfo=instCode_"^"_$g(freqCode) 						// 用法 频次 用于用法和频率项目判断
	.
	.i orderType="L" d											// 检验医嘱
	..s libDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("LAB","U"),""))
	.i orderType = "N" d
	..s libDr = $o(^DHCPHLIBL(0,"Code",$ZCONVERT("TREAT","U"),""))	// 治疗项目  qunianpeng 2018/3/16
	.i orderType="OP" d
	..s libDr = $o(^DHCPHLIBL(0,"Code",$ZCONVERT("OPERATION","U"),""))	// 手术项目  qunianpeng 2019/12/24
	.
	.s hisGeneDesc=$p(commonInfo,"^",1) 						// his通用名描述
	.s libGenDr=$p(commonInfo,"^",2) 							// 知识库通用名id
	.s libProDr=$p(commonInfo,"^",3)    						// 知识库商品名id
	.s pointer=$p(commonInfo,"^",4)	   							// 剂型/标本/检查部位
	.
	.q:((libGenDr="")&(libProDr=""))||(pointer="")
	.s exitGenFlag=""
	.s:libGenDr="" exitGenFlag=1
	.s msgNode=hisGeneDesc_","_i_","_arci_","_oeori_","_$p($p(itmStr,"^",9),$c(1),2)   	// 设置节点信息
	.i (orderType="N")||(orderType="S")||(orderType="L") s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Part",msgNode)=$p(..GetCommonTypeInfo(arci,hisPart),",",3)
	.s hisOrdItm=itmStr   																// 一条医嘱串
	.s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"msgNode",msgNode)=itmStr			// 记录入参
	.// 取授权规则进行判断
	.s indexMain=""
	.f  s indexMain=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"rule",indexMain)) q:indexMain=""  d
	..s itmRelatFlag=""					     	    			// 用于目录最终值的关系判断
	..s labelDr=$p(indexMain,",",2)			        			// 知识库目录
	..s labelDesc=$p(^DHCPHPINL(labelDr),"^",2)      			// 目录描述	
	..q:((orderType="R")||(orderType="L"))&(libDr'=$p(indexMain,",",4))
	..s labelAllFlag=$p(^DHCPHPINL(labelDr),"^",7)   			// 是否启用标识(被修改成是否全部通过标识)
	..s labelAlert=$p(^DHCPHPINL(labelDr),"^",8)				// 目录提示信息
	..
	..//i (orderType="R")&&(libProDr'="")&&($d(^DHCPHINSTRUC(0,"TGP",labelDr,libProDr,"ProName",0))) d //药品医嘱先用商品名进行审查,如果返回值或者没有维护,则使用通用名审查
	..i (orderType="R")&&(libProDr'="") d 						// 药品医嘱先用商品名进行审查,如果没有维护,则使用通用名审查
	...d ..CheckLibPhaByProName(pid,adm,labelDr,libProDr,indexMain,msgNode,itmRelatFlag,drugInfo,ordStr,hisOrdItm,ordStrItem,hisDosQtyInfo)
	..e  d //检查检验使用通用名进行审查
	...q:$g(exitGenFlag)=1
	...d ..CheckLibPhaByGeneric(pid,adm,labelDr,libGenDr,indexMain,msgNode,itmRelatFlag,drugInfo,pointer,ordStr,hisOrdItm,ordStrItem,$g(hisDosQtyInfo))
	..//q:(orderType="R")&($g(exitGenFlag)=1)&((libProDr'=""))&&('$d(^DHCPHINSTRUC(0,"TGP",labelDr,libProDr,"ProName",0))) //药品医嘱 商品名不为空,但使用通用名审查时,通用名不能为能空
	..//q:(orderType="R")&($g(exitGenFlag)=1)&((libProDr'="")) 	// 药品医嘱 商品名不为空,但使用通用名审查时,通用名不能为能空
	..
	..q:((orderType="L")||(orderType="S")||(orderType="N")||(orderType="OP"))&($g(exitGenFlag)=1) 	// 检验/检查/治疗项目/手术 通用名不能为空			
	..//s itmRelatFlag=..GetLabelRelation(pid,indexMain)			// 确定一个目录下有多条记录，返回关系
	..s itmRelatFlag = $case($zcvt(labelAllFlag,"U"),"Y":0,"N":1,:1) // 0表示每一条都需要通过。1表示有一条通过即可。 使用目录的通过标志  qunianpeng 2018/3/16
	..s chkVal=..GetRecVal(pid,"Rec",$G(itmRelatFlag),msgNode)  // 一个目录审查结束，确定目录的最终值
	..i chkVal=1 k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsg",msgNode,indexMain)	// 若目录的最终返回值是1,则清空改目录下的每条记录值
	..s ruleRelat=^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"rule",indexMain)				// 确定一个药品中多个目录和目录之前的关系
	..s relatIndex=$case(ruleRelat,"&":1,"||":2,:1)
	..s itmRetVal=chkVal_$c(1)_ruleRelat  						// 目录关系
	..s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Label",relatIndex,indexMain)=itmRetVal	
	..
	.
	.s passVal=..GetRelatVal(pid,"Label")	// 一个药品多个目录审查结束,确定一个药品最终返回信息
	.i passVal=1 k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsg",msgNode)
    .s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Drug",1,i)=passVal
    .
	s passVal=..GetLastVal(pid,"Drug")	   						// 多个药品,确定最终返回值
	//i $d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"NoData")) s PassVal=2
	s manLevel="" 												// 生成日志(监测表数据)
    i passVal=0 d 
    .s retMsg=..SaveLibOrdLogNew(adm,userInfo,pid)
    .s manLevel=..GetCommonManLevel(pid)						// 所有药品统一返回一个最严格的级别	 	
	e  d
	.s retMsg=""
	.s manLevel="C"
	
	s listObj=##class(%ListOfObjects).%New()         			// 返回信息拼成json串
	i (retMsg="")||(retMsg="[]") s passVal=1
 	d listObj.Insert(##class(ext.util.JsonObject).%New().Put("passFlag",""_passVal).Put("manLevel",manLevel).Put("retMsg",retMsg))
  	s JsonObj=##class(ext.util.JsonObject).%New() 	 			// 返回信息Json对象
  	s retStr=JsonObj.ListToJson(listObj)

  	d ..killTmpGlobal(pid)
	q retStr
}

/// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// ///////////////////////////////////////////////////知识库审查所需公共辅助函数////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Description:	使用商品名进行知识库效验
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-16
/// Input:			进程号,就诊id,目录id,商品名id,知识库目录节点,药品节点,目录关系标志,用法/频次,本次医嘱项id串,历次医嘱串,用药量
/// return:			
/// other:	
ClassMethod CheckLibPhaByProName(pid, adm, labelDr, libProDr, indexMain, msgNode, itmRelatFlag, drugInfo, ordStr, hisOrdItm, ordStrItem, hisDosQtyInfo) As %String
{
	n (pid,adm,labelDr,libProDr,indexMain,msgNode,itmRelatFlag,drugInfo,ordStr,hisOrdItm,ordStrItem,hisDosQtyInfo)

	s pointer=0
	d ..CheckLibPhaCommon("ProName",pid,adm,labelDr,libProDr,indexMain,msgNode,itmRelatFlag,drugInfo,pointer,ordStr,hisOrdItm,ordStrItem,hisDosQtyInfo)
}

/// Description:	使用通用名进行知识库效验
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-16
/// Input:			进程号,就诊id,目录id,通用名id,知识库目录节点,药品节点,目录关系标志,用法/频次,本次医嘱项id串,历次医嘱串,用药量
/// return:			
/// other:	
ClassMethod CheckLibPhaByGeneric(pid, adm, labelDr, libGenDr, indexMain, msgNode, itmRelatFlag, drugInfo, pointer, ordStr, hisOrdItm, ordStrItem, hisDosQtyInfo = "") As %String
{
	n (pid, adm, labelDr, libGenDr, indexMain, msgNode, itmRelatFlag, drugInfo, pointer, ordStr, hisOrdItm,ordStrItem,hisDosQtyInfo)
	d ..CheckLibPhaCommon("Form",pid,adm,labelDr,libGenDr,indexMain,msgNode,itmRelatFlag,drugInfo,pointer,ordStr,hisOrdItm,ordStrItem,hisDosQtyInfo)
}

/// Description:	通用名/商品名 公共部分效验
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-16
/// Input:			医嘱项类型(通用名/商品名),进程号,就诊id,目录id,商品名id,知识库目录节点,药品节点,目录关系标志,用法/频次,本次医嘱项id串,历次医嘱串,用药量
/// return:			
/// other:	
ClassMethod CheckLibPhaCommon(instType, pid, adm, labelDr, libGenDr, indexMain, msgNode, itmRelatFlag, drugInfo, pointer, ordStr, hisOrdItm, ordStrItem, hisDosQtyInfo = "") As %String
{
	n (instType,pid,adm,labelDr,libGenDr,indexMain,msgNode,itmRelatFlag,drugInfo,pointer,ordStr,hisOrdItm,ordStrItem,hisDosQtyInfo)

	s instCode=$p(drugInfo,"^",1)					// his用法code
	s freqCode=$p(drugInfo,"^",2)					// his频次code
	s labelDesc=$p(^DHCPHPINL(labelDr),"^",2)     	// 目录描述
	// 病人基本信息 用于判断年龄 性别 体重 特殊人群 
	s patInfo=..GetPatInfo(adm)
	s patSex=$p(patInfo,"^",1)
	s patAge=$p(patInfo,"^",2)
	s patWeight=$p(patInfo,"^",3)
	s patPlan="",patclimac="",patmens="",patlac="",patpre="",patliver="",patren=""
	s patIcd=$p(patInfo,"^",4)  					// 取his诊断
	s admInfo=$p(patInfo,"^",5) 					// 特殊人群
	i patliver="" s patliver=..GetSpecPopuFlag("GGN",adm)
    i patren="" s patren=..GetSpecPopuFlag("SGN",adm)
	s instruId=""
	f  s instruId=$o(^DHCPHINSTRUC(0,"TGP",labelDr,libGenDr,instType,pointer,instruId)) q:instruId=""  d
	.s exitonFlag=1									// 前提条件是否通过标志 通过1 不通过0 qunianpeng 2017/9/15
	.s exitonerec=0									// 表示项目是否是前提条件
	.s itmDirecFlag=0								// 标记反向(禁忌症)
	.s useQtyFlag=0 								// 用法用量 是否维护剂量标志 
	.// 遍历规则项目,调用函数进行效验
	.s indexSub=""
	.f  s indexSub=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"rule",indexMain,indexSub)) q:(indexSub="")||(exitonerec=1)  d
	..s itmFun=^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"rule",indexMain,indexSub)
	..s ExeCls="chkVal="_itmFun
	..s @ExeCls	
	..i labelDesc["用法用量" s exitonerec=..CheckExtion(indexMain,itmFun,instruId,chkVal)  // 检查用法用量时,若前提条件不满足(检查用药量时,先看其他项目-前提条件是否通过，若不通过，则用药量不检查)，默认通过
	..i exitonerec=1 s exitonFlag=0					// qunianpeng 2017/9/15  用法用量 前提条件不通过时,该条记录为通过状态
	..q:exitonerec=1  								// 本条记录(InstruId)全部退出标记  
	..i (labelDesc["用药频率")&(chkVal=0)&(itmFun["CheckPatAge")  d
	...i $d(^DHCPHDISFR("0","Inst",instruId)) d
	...s pdfRowId=$o(^DHCPHDISFR("0","Inst",instruId,""))
	...i pdfRowId'="" s pdfRowFlag=$p($g(^DHCPHDISFR(pdfRowId)),"^",3)
	...i ($g(pdfRowFlag)'="")&&($g(pdfRowFlag)'="Y") s chkVal=1
	..
	..i (labelDesc["给药途径")&(chkVal=0)&(itmFun["CheckPatAge")  d
	...i $d(^DHCPHDISUSE("0","Inst",instruId)) d
	...s pdfRowId=$o(^DHCPHDISUSE("0","Inst",instruId,""))
	...i pdfRowId'="" s pdfRowFlag=$p($g(^DHCPHDISUSE(pdfRowId)),"^",3)
	...i ($g(pdfRowFlag)'="")&&($g(pdfRowFlag)'="Y") s chkVal=1
	..
	..s ruleItmRelat=$p(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"relat",indexMain,indexSub),"^",1) 	 // 规则明细项目关系 用于确定一条记录的最终值
	..s itmRetVal=chkVal_$c(1)_ruleItmRelat  		// 目录关系
	..s relatIndex=$case(ruleItmRelat,"&":1,"||":2,:1)
	..s itmDirec=$p(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"relat",indexMain,indexSub),"^",3)		// 函数返回值
	..i itmDirec=0 s itmDirecFlag=1					// 禁忌症反向
	..s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Itm",relatIndex,instruId_","_indexSub)=itmRetVal 	// 暂存一条记录中多个项目的值
	..
	.
	.q:'$d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Itm"))
	.s chkVal=..GetRelatVal(pid,"Itm",itmDirecFlag) // 一条记录中多个项目审查判断结束，得到一条记录中每个项目的最终值
	.i (chkVal'=-100)&("Y"=##class(web.DHCSTPHCMPASSFUN).CalcPath(labelDesc)) s chkVal='chkVal	// qunianpeng 2020/4/14 目录的判断方向
	.i (labelDesc["用药频率")&($d(^TMP("DHCST","web.DHCSTPHCMPASS","CheckFreqList",pid,"Taboo",instruId))) s chkVal='chkVal	
	.i itmDirecFlag=1 s chkVal='chkVal 				// 维护了反向
	.s:(labelDesc["用法用量")&(exitonFlag=0) chkVal=1	// 用法用量前提条件不通过,认为整条记录通过
	.i (chkVal=0) d 								// 暂存提示信息
	..i (labelDesc["给药途径")||(labelDesc["用药频率")||(labelDesc["用法用量") d	
	...i $g(^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId))'="" d
	....s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsg",msgNode,indexMain,instruId)="$"_$g(^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId))_"$"_..GetInstruIdMsg(instruId)
	...e  d 
	....s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsg",msgNode,indexMain,instruId)="$"_$g(^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId))_"$"_..GetInstruIdMsg(instruId)
	...
	..e  i (labelDesc["相互作用")||(labelDesc["配伍禁忌") d
	...s tmpOeorInfo=$g(^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId))
	...s linkOeoriInfo=$p(tmpOeorInfo,"$",1)
	...s linkOeoriMsg=..GetOeoriInfo($p(linkOeoriInfo,"-",3))
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsg",msgNode,indexMain,instruId)=$g(^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId))_"$"_..GetInstruIdMsg(instruId)_linkOeoriMsg //记录验证为0,则取记录描述 (2020/3/1 增加配伍的药品提醒)
	..e  d
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsg",msgNode,indexMain,instruId)="$$"_..GetInstruIdMsg(instruId) //记录验证为0,则取记录描述
	..
	.
	.i (labelDesc["溶媒量")&($d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"TmpMsg",instruId))) d		// 记录溶媒返回值
    ..q:$d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsgM",msgNode,indexMain))  
    ..s tmpMsgFlag=$p(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"TmpMsg",instruId),"^",1)  
    ..s oeoriMeg=$p(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"TmpMsg",instruId),"^",2)  
    ..i tmpMsgFlag=1 d  							// 有药品数据但是剂量不对
    ...k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsg",msgNode,indexMain) 
    ...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsgM",msgNode,indexMain)=""  //溶媒量返回信息  溶质医嘱项ID $c(2) 溶媒医嘱项ID $c(2) 溶质正确用法 $C(2) 溶媒溶质不匹配的用法提示
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsg",msgNode,indexMain,instruId)=oeoriMeg_"$"_..GetInstruIdMsg(instruId)
	..
	..i tmpMsgFlag=0 d 								// 无药品数据
	...i '$d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsgM",msgNode,indexMain)) d
	....k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsg",msgNode,indexMain)
	....s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsg",msgNode,indexMain,instruId)=oeoriMeg_"$"_..GetInstruIdMsg(instruId) 
	..k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"TmpMsg",instruId)
	.
	.s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Rec",indexMain,instruId)=chkVal 	// 记录每条记录的值
	.k ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)
	.k ^TMP("DHCST","web.DHCSTPHCMPASS","CheckUseList",pid,"HasXxist")
	.k ^TMP("DHCST","web.DHCSTPHCMPASS","CheckFreqList",pid,"Taboo",instruId)
}

/// Description:	获取his检查对应的知识库通用名
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-16
/// Input:			医嘱项id,his检查部位描述
/// return:			his通用名描述,知识库通用名id,知识库部位id
/// other:	
/// w ##class(web.DHCSTPHCMPASS).GetLibNameByLis("4815||1","")
ClassMethod GetLibNameByLis(arci, hisPart) As %String
{
	n (arci,hisPart)
	s sub=$p(arci,"||",1),ver=$p(arci,"||",2)
	s libGenDr=""
	s hisGeneCode=$P(^ARCIM(+sub,ver,1),"^",1)				// ARC_ItmMast
	s hisGeneDesc=$P(^ARCIM(+sub,ver,1),"^",2)	
	s conGenDr=$o(^DHCPHGENCON(0,"HisCode",hisGeneCode,""))	// 检查项目对照

    q:conGenDr="" 0
    s libGenCode=$p(^DHCPHGENCON(conGenDr),"^",1)
  	i libGenCode'="" s libGenDr=$o(^DHCPHEGENi(0,"Code",$ZCONVERT(libGenCode,"U"),""))	//知识库通用名
	q:libGenDr="" 0

	s pointer=""
	i hisPart'="" d  
	.s conPartDr=$o(^DHCPHPACON(0,"HisCode",hisPart,""))	//   部位对照
	.q:conPartDr=""
	.i conPartDr'="" s libPartCode=$p(^DHCPHPACON(conPartDr),"^",1)
	.q:libPartCode=""
	.i libPartCode'="" s libPartDr=$o(^DHCPHEPA(0,"Code",$ZCONVERT(libPartCode,"U"),""))
	e  i hisPart=""  d    									// 如果没有检查部位，则默认对照为NULL
	. s libPartDr=$o(^DHCPHEPA(0,"Code",$ZCONVERT("NULL","U"),""))

	s pointer=$g(libPartDr)
	q:pointer="" 0

	q hisGeneDesc_"^"_libGenDr_"^"_""_"^"_pointer
}

/// Description:	获取his检验对应的知识库通用名
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-16
/// Input:			医嘱项id
/// return:			his通用名描述,知识库通用名id,知识库标本id
/// other:	
ClassMethod GetLibNameByLab(arci As %String, sendHisSpec = "") As %String
{
	n (arci,sendHisSpec)

	s libGenDr=""
	s sub=$p(arci,"||",1),ver=$p(arci,"||",2)
	s hisGenCode=$P(^ARCIM(+sub,ver,1),"^",1)
	s hisGenDesc=$P(^ARCIM(+sub,ver,1),"^",2)
	s testCode=..GetTestCode(arci)			//外部代码
	q:testCode="" 0
	s libLabConDr=$o(^DHCPHGENCON(0,"HisCode",testCode,""))		//检验代码对照

	q:libLabConDr="" 0
	s libLabCode=$p(^DHCPHGENCON(libLabConDr),"^",1)			//知识库检验代码
	i libLabCode'="" s libGenDr=$o(^DHCPHEGENi(0,"Code",$ZCONVERT(libLabCode,"U"),""))
	q:$g(libGenDr)="" 0

	s pointer=""
	s hisSpec=sendHisSpec
	s:hisSpec="" hisSpec=..GetTestSetSpecimen(arci)					//his标本代码	
	q:hisSpec="" 0
	s conSpecDr=$o(^DHCPHGENCON(0,"HisCode",hisSpec,""))	//标本对照
	q:conSpecDr="" 0
	s libSpec=$p(^DHCPHGENCON(conSpecDr),"^",1)				//知识库标本
	i libSpec'="" s libSpecId=$o(^DHCPHEGENi(0,"Code",$ZCONVERT(libSpec,"U"),""))
	s pointer=$g(libSpecId)
	q:pointer="" 0	

	q hisGenDesc_"^"_libGenDr_"^"_""_"^"_pointer
}

/// Description:	获取his药品对应的知识库通用名和商品名
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-16
/// Input:			医嘱项id
/// return:			his通用名描述,知识库通用名id,知识库商品名id,知识库剂型
/// other:	
ClassMethod GetLibNameByDrug(arci As %String) As %String
{
	n (arci)

	s sub=$p(arci,"||",1),ver=$p(arci,"||",2)
	i +sub'=0 s itmMastCode=$P(^ARCIM(+sub,ver,1),"^",1) //ARC_ItmMast的code作为商品名的code	
	s phcdf=$p($g(^ARCIM(sub,ver,1)),"^",12)			 //PHC_DrgForm	
    s phcd=+phcdf										//药学项
    s phcdSub=$p(phcdf,"||",2)
    q:(phcd="")!(phcdSub="") 0    
    //获取对应的找商品名
    s libProDr=""
    s conProDr=$o(^DHCPHPCO(0,"HisCode",itmMastCode,"")) 		//知识库商品名对照表id
    i $g(conProDr)'="" s libProCode=$p(^DHCPHPCO(conProDr),"^",1) 	//知识库商品名code
    i $g(libProCode)'="" s libProDr=$o(^DHCPHPNA(0,"Code",$ZCONVERT(libProCode,"U"),"")) //知识库商品名id    

    //获取对应的通用名
    s libGenDr=""
    s hisGeneDesc=""
    s gene=$p($g(^PHCD(phcd,4)),"^",1) 
    i gene'="" d
    .s hisGeneDesc=$p($g(^PHCGE("GE",gene)),"^",2) 				//his通用名 PHC_Generic
    .s hisGeneCode=$p($g(^PHCGE("GE",gene)),"^",1) 
    .s conGenDr=$o(^DHCPHGENCON(0,"HisCode",hisGeneCode,""))	//通用名对照表id
    .i $g(conGenDr)'="" s libGeneCode=$p(^DHCPHGENCON(conGenDr),"^",1)
	.i $g(libGeneCode)'=""  s libGenDr=$o(^DHCPHEGENi(0,"Code",$ZCONVERT(libGeneCode,"U"),""))  //知识库通用名id    
 
    //获取对应的剂型作为pointer节点
    s pointer=""
	q:'$d(^PHCD(phcd,"DF",phcdSub,1)) 0
    s hisFormDr=$p(^PHCD(phcd,"DF",phcdSub,1),"^",1) 			//his剂型
	q:$g(hisFormDr)="" 0
	s hisFormCode=$p(^PHCF(hisFormDr),"^",1) 					 
	s conFormDr=$o(^DHCPHFOCON(0,"HisCode",hisFormCode,""))	 	//剂型对照表id
	i $g(conFormDr)'="" s conFormCode=$p(^DHCPHFOCON(conFormDr),"^",1)				//知识库剂型code
	i $g(conFormCode)'="" s libFormDr=$o(^DHCPHEFi(0,"Code",$ZCONVERT(conFormCode,"U"),""))			//知识库剂型id
	s pointer=$g(libFormDr)

	q hisGeneDesc_"^"_libGenDr_"^"_libProDr_"^"_pointer
}

/// Description:	用于确定一个目录下有多条记录，返回关系
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-16
/// Input:			进程号,节点信息
/// return:			返回值0表示每一条都需要通过。 返回值是1表示有一条通过即可。
/// other:	
ClassMethod GetLabelRelation(pid, indexMain) As %String
{
	n (pid,indexMain)	
	
	s relation=1
	s sub=""
	f  s sub=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"relat",indexMain,sub)) q:sub=""  d
	.s itmRelat=$p(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"relat",indexMain,sub),"^",2)      //知识库项目关系   用于确定一个目录的最终值
	.s flag=$case(itmRelat,"Or":1,"And":0,:1)	//用于目录最终值的关系判断
	.s relation=relation&flag
	
	q relation
}

/// Description:	获取医嘱类型
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-16
/// Input:			医嘱项id
/// return:			R(药品)/L(检验)/N(治疗项目)
/// other:	
ClassMethod GetOrdType(arci As %String) As %String
{
	n (arci)
	s sub=$p(arci,"||",1),ver=$p(arci,"||",2)	
	s itemCatDr="",itemCatCode=""
	i +sub'=0 s itemCatDr=$P(^ARCIM(+sub,ver,1),"^",10)  //ARC_ItemCat
	s orderType=""
	i itemCatDr'="" s orderType=$P(^ARC("IC",itemCatDr),"^",7) 
	q orderType
}

/// Description:	验证通用名目录有效性
/// Creator:		(QuNianpeng 修改加注释)
/// CreateDate:		(2017-08-04	修改加注释)
/// Input:			
/// return:			1授权 0未授权
/// other:	
ClassMethod CheckLabelVal(Libdr, Type, ActFlag, GenItmDr, FormDr, LabelDr) As %String
{
	q:$d(^DHCPHINSTRUC(0,"OrdNum",Libdr,Type,ActFlag,GenItmDr,FormDr,Labeldr)) 1
	q 0
}

/// Description:	验证目录授权
/// Creator:		(QuNianpeng 修改加注释)
/// CreateDate:		(2017-08-04	修改加注释)
/// Input:			
/// return:			目录授权类型
/// other:	
ClassMethod CheckLabelAcc(accinfo, Libdr, acctype, Labeldr) As %String
{
	n (accinfo,Libdr,acctype,Labeldr)
	s AccMain=""
	q:acctype="" ""
	
	s UserId=$p(accinfo,"^",1)
	s CptId=$p(accinfo,"^",2)
	s DocLocId=$p(accinfo,"^",3)
	s HospId=$p(accinfo,"^",4)
	
	i acctype="doc" d
	.s AccMain=$o(^DHCPHLIBACC(0,"Pointer",Libdr,"doc",UserId,Labeldr,""))
	
	i acctype="cpt" d
	.s AccMain=$o(^DHCPHLIBACC(0,"Pointer",Libdr,"cpt",UserId,Labeldr,""))

	i acctype="docloc" d
	.s AccMain=$o(^DHCPHLIBACC(0,"Pointer",Libdr,"docloc",DocLocId,Labeldr,""))

	i acctype="hosp" d
	.s AccMain=$o(^DHCPHLIBACC(0,"Pointer",Libdr,"hosp",HospId,Labeldr,""))

	
	q AccMain
}

/// Description:	获取权限优先级
/// Creator:		(QuNianpeng 修改加注释)
/// CreateDate:		(2017-08-04	修改加注释)
/// Input:			
/// return:			优先级
/// other:
ClassMethod GetAccPointer(Input, Libdr) As %String
{
	n (Input,Libdr)
	s AccType=""
	
	s UserId=+$p(Input,"^",1)
	s CptId=+$p(Input,"^",2)
	s DocLocId=+$p(Input,"^",3)
	s HospId=+$p(Input,"^",4)
	
	i $d(^DHCPHLIBACC(0,"Pointer",Libdr,"doc",UserId)) d
	.s AccType="doc"
	e  d
	.if $d(^DHCPHLIBACC(0,"Pointer",Libdr,"cpt",CptId)) d
	..s AccType="cpt"
	.e  d
	..if $d(^DHCPHLIBACC(0,"Pointer",Libdr,"docloc",DocLocId)) d
	...s AccType="docloc"
	..e  d
	...if $d(^DHCPHLIBACC(0,"Pointer",Libdr,"hosp",HospId)) d
	....s AccType="hosp"
	
	q AccType
}

/// Description:	验证目录子项目授权
/// Creator:		(QuNianpeng 修改加注释)
/// CreateDate:		(2017-08-04	修改加注释)
/// Input:			
/// return:			授权类型
/// other:
ClassMethod CheckRuleItmAcc(accinfo, Libdr, acctype, Labeldr, ItemDr) As %String
{
    n (accinfo,Libdr,acctype,Labeldr,ItemDr)
	s ret=0
	
	s UserId=$p(accinfo,"^",1)
	s CptId=$p(accinfo,"^",2)
	s DocLocId=$p(accinfo,"^",3)
	s HospId=$p(accinfo,"^",4)
	
	i acctype="doc" d
	.i $d(^DHCPHLIBACC(0,"Pointer",Libdr,"doc",UserId,Labeldr,ItemDr)) d
	..s ret=1
	
	i acctype="cpt" d
	.i $d(^DHCPHLIBACC(0,"Pointer",Libdr,"cpt",UserId,Labeldr,ItemDr)) d
	..s ret=1

	i acctype="docloc" d
	.i $d(^DHCPHLIBACC(0,"Pointer",Libdr,"docloc",DocLocId,Labeldr,ItemDr)) d
	..s ret=1

	i acctype="hosp" d
	.i $d(^DHCPHLIBACC(0,"Pointer",Libdr,"hosp",HospId,Labeldr,ItemDr)) d
	..s ret=1
	
	
	q ret
}

/// Description:	得到一条记录每个项目的最终值
/// Creator:		(QuNianpeng 修改加注释)
/// CreateDate:		(2017-08-04	修改加注释)
/// Input:			
/// return:			0,1
/// other:
ClassMethod GetRelatVal(pid As %String, node As %String, itmDirecFlag = "") As %String
{
	n (pid, node,itmDirecFlag)
	//按目录表达式排序并整合,And先执行,Or置后
	s tmpp=""
	s ret=""
	s oneStr=""
	s num=0
	s index=""
	f  s index=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,node,index)) q:index=""  d
	.s main=""
	.f  s main=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,node,index,main)) q:main=""  d
	..s str=^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,node,index,main)
	..s num=num+1
	..s val=$p(str,$c(1),1)
	..q:val=-100 //未维护的忽略项
	..q:val=-1   //频率和用法标识了禁忌返回-1
	..s tmpp=1
	..s ruleRelat=$p(str,$c(1),2)	
	..
	..q:($o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,node,""))=1)&(ruleRelat'="&")
	..i oneStr="" d
	...i ruleRelat="&" s oneStr=1&val
	...i ruleRelat="||" s oneStr=1||val
	..e  d
	...
	...i ruleRelat="&" s oneStr=oneStr&val
	...i ruleRelat="||" s oneStr=oneStr||val
	..	
	
	k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,node)
	
	i (itmDirecFlag=1)&(tmpp="") q 0  // 当全是-1，全部忽略时，禁忌结果为不通过 : 0
	i tmpp="" q -100   //当全是-1，全部忽略时，结果为通过 : 1

	s ret=oneStr	

	q ret
}

/// Description:	得到一条记录每个项目的最终值
/// Creator:		(QuNianpeng 修改加注释)
/// CreateDate:		(2017-08-04	修改加注释)
/// Input:			进程号，节点，关系，药品节点信息
/// return:			0,1
/// other:			indexMain=序号_","_目录id_","_规则表id_","_标识id  //序号 目录 规则表ID 标识
/// 				msgNode=通用名_","_i_","_医嘱项id_","_医嘱id_","_医嘱序号
ClassMethod GetRecVal(pid, node, flag, msgNode) As %String
{
	n (pid, node,flag,msgNode) 
	// flag=0 and 表示目录下面的每一条记录都需要符合,有一条不符合的就需要提示。  or时，有一条为1，则通过1  有一条通过就通过，不给提示
	//flag:0 目录下面的所有记录必须全部验证通过(禁忌证), 1:仅有一条验证通过即可(适应症,用法,频率)
	s ruleRelat="&"
	i flag="1" s ruleRelat="||"
	s labelCtrl=""
	s ret=""
	s oneStr=""
	s retMsgNode=$p(msgNode,",",1)_$c(14)_$p(msgNode,",",3)_"-"_$p(msgNode,",",5)_"-"_$p(msgNode,",",4)  
	s indexMain=""
	f  s indexMain=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,node,indexMain)) q:indexMain=""  d
	.s labelDr=$p(indexMain,",",2)				//目录id
	.s labelCtrl=$p(^DHCPHPINL(labelDr),"^",4)	//目录级别
	.i labelCtrl="" s labelCtrl="S"
	.s labelCtrlNum=$SELECT(labelCtrl="S":-1,labelCtrl="W":0,labelCtrl="C":1)  // 目录级别 -1 提示 0 警示 1 管控
	.s instruId=""
	.f  s instruId=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,node,indexMain,instruId)) q:instruId=""  d
	..s str=^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,node,indexMain,instruId)
	..s level=$p(^DHCPHINSTRUC(instruId),"^",14)  //明细的级别
	..i level="" s level=labelCtrl  //没有级别（默认目录级别）
	..s levelNum=$SELECT(level="S":-1,level="W":0,level="C":1)
	..s val=$p(str,$c(1),1)		//每条记录是否通过值
	..q:val=-100
	..i (flag'="1")&(val=0) d
	...s:labelCtrlNum<levelNum ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Ctrl")=levelNum   //取级别最严格的
	...s:labelCtrlNum>levelNum ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Ctrl")=labelCtrlNum
	...s:labelCtrlNum=levelNum ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Ctrl")=levelNum
	...s tmpLevel=^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Ctrl")		//qnp 多组药同时异常返回级别最严格的级别
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Ctrl","TmpCtrl",tmpLevel)=tmpLevel
	..
	..i oneStr="" d
	...i ruleRelat="&" s oneStr=1&val							
	...i ruleRelat="||" s oneStr=0||val   
	..e  d
	...i ruleRelat="&" s oneStr=oneStr&val
	...i ruleRelat="||" s oneStr=oneStr||val
	..i (flag="1")&(oneStr=0) d  
	...s:labelCtrlNum<levelNum ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Ctrl")=levelNum 
	...s:labelCtrlNum>levelNum ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Ctrl")=labelCtrlNum
	...s:labelCtrlNum=levelNum ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Ctrl")=levelNum
	...s tmpLevel=^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Ctrl")
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Ctrl","TmpCtrl",tmpLevel)=tmpLevel
	
	.i oneStr=0 s ^TMP("DHCST","web.DHCSTPHCMPASS","GetRecVal",pid,"LabelCtrl",msgNode,labelDr)=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Ctrl","TmpCtrl",""),-1)

    s ret=oneStr

    k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,node)
	k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Ctrl")
	k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Ctrl","TmpCtrl")

    i ret="" q 1
	q ret
}

/// Description:	将异常信息存到日志监测表中,并将返回信息拼成json返回
/// Creator:		QuNianpeng 
/// CreateDate:		2017-08-10
/// Input:			就诊号,登录信息,进程号
/// return:			返回信息json串
/// other:
ClassMethod SaveLibOrdLogNew(adm, userInfo, pid) As %String
{
	n (adm,userInfo,pid)

  	s drugJsonObj=##class(ext.util.JsonObject).%New() 	 //返回信息Json对象
  	s drugListObj=##class(%ListOfObjects).%New()

  	s msgNode="" 
  	f  s msgNode=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsg",msgNode)) q:msgNode=""  d  //一个药品的返回信息
   	.s passFlag=0					//是否通过审查标志
  	.s createDate=+$h				//创建日期
  	.s createTime=$p($h,",",2)		//创建时间
  	.s geneDesc=$p(msgNode,",",1)	//通过名
  	.s oeori=$p(msgNode,",",4)		//医嘱Id
  	.s arci=$p(msgNode,",",3)		//医嘱项id
  	.s seqNo=$p(msgNode,",",5)  	//医嘱序号
  	.s para=$g(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"msgNode",msgNode))
  	.s level=..GetLabelManLevel(pid,msgNode)	//一个药品 管理级别
  	.s level=$SELECT(level=-1:"S",level=0:"W",level=1:"C")  // 目录级别 -1 提示 0 警示 1 管控
	.s pointer=$g(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Part",msgNode))
  	.s phMRId=..SaveMonitorMsg(adm,userInfo,createDate,createTime,oeori,arci,seqNo,level,para)	//日志表id
	.i phMRId'="" d ..SaveMRitemDate(phMRId,createDate)	//存对应的日期
  	.s chlidJsonObj=##class(ext.util.JsonObject).%New() 	//目录返回值Json对象
 	.s chlidListObj=##class(%ListOfObjects).%New()  
 	.
  	.s indexMain="" 
  	.f  s indexMain=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsg",msgNode,indexMain)) q:indexMain=""  d  //一个目录的返回信息
  	..s labelDr=$p(indexMain,",",2)				 //目录id
	..s labelDesc=$p(^DHCPHPINL(labelDr),"^",2)  //目录描述
	..s linkOeori=""							 //关联医嘱id
	..s linkOeSeqNo=""							 //关联医嘱序号
	..s linkArci=""								 //关联医嘱项id
	..s labelLevel=$g(^TMP("DHCST","web.DHCSTPHCMPASS","GetRecVal",pid,"LabelCtrl",msgNode,labelDr))  //目录的 管理级别
	..s labelLevel=$SELECT(labelLevel=-1:"S",labelLevel=0:"W",labelLevel=1:"C") 
	..s trueMsg=""								 //知识库维护提示信息
	..s errMsg=""								 //自定义提示信息
	..s errFlag=""								 //针对溶媒（错误标志:不可选择/超剂量）
  	..s num=0
  	..s i=0
  	..s instruId=""
  	..f  s instruId=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsg",msgNode,indexMain,instruId)) q:instruId=""  d
    ...s i=i+1
    ...s promptInfo=^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"RecMsg",msgNode,indexMain,instruId) //提示信息
	...s linkArci=$p($p(promptInfo,"$",1),"-",1)
	...s linkOeori=$p($p(promptInfo,"$",1),"-",3)
	...s linkOeSeqNo=$p($p(promptInfo,"$",1),"-",2)
	...s tmpErrMsg=$p(promptInfo,"$",2)
	...s tmpTrueMsg=$p(promptInfo,"$",3)
	...i errMsg="" d
	....s:tmpErrMsg'="" errMsg=tmpErrMsg
	...e  d
	....s:(tmpErrMsg'="")&(errMsg'=tmpErrMsg) errMsg=errMsg_" "_tmpErrMsg
	...s:(tmpTrueMsg'="")&(errMsg'["无此") tmpTrueMsg=i_"、"_tmpTrueMsg
	...s:(tmpTrueMsg'="")&(errMsg["无此") tmpTrueMsg=""
	...i trueMsg="" d
	....s trueMsg=tmpTrueMsg
	...e  d
	....s trueMsg=trueMsg_" "_tmpTrueMsg
	..

	..i trueMsg="" s trueMsg=errMsg   
  	..i phMRId'="" d ..SaveMRLabel(phMRId,labelDr,errFlag,trueMsg,errMsg,linkOeori,linkOeSeqNo,linkArci,labelLevel)  //存对应的目录异常信息
    ..//目录返回信息json插入 
  	..d chlidListObj.Insert(##class(ext.util.JsonObject).%New().Put("labelLevel",labelLevel).Put("labelDesc",labelDesc).Put("linkArci",linkArci).Put("linkOeori",linkOeori).Put("linkOeSeqNo",linkOeSeqNo).Put("alertMsg",trueMsg))
  	..
  	.//目录返回信息转换成json串
  	.s children=chlidJsonObj.ListToJson(chlidListObj)
	.//药品返回信息json对象插入
  	.d drugListObj.Insert(##class(ext.util.JsonObject).%New().Put("passFlag",passFlag).Put("level",level).Put("geneDesc",geneDesc).Put("oeori",oeori).Put("arci",arci).Put("seqNo",seqNo).Put("PhMRId",phMRId).Put("pointer",pointer).Put("chlidren",children))
  	
  	//药品返回信息转换成json串
  	//k ^TMP("DHCST","web.DHCSTPHCMPASS","GetRecVal",pid,"LabelCtrl")
	q drugJsonObj.ListToJson(drugListObj)
}

/// Description:	将异常信息存到日志监测主表中
/// Creator:		QuNianpeng 
/// CreateDate:		2017-08-10
/// Input:			就诊id,登录信息,创建日期,创建时间,医嘱id,医嘱项id,医嘱序号,管理级别,,入参
/// return:			插入监测表的id
/// other:
ClassMethod SaveMonitorMsg(adm, userInfo, createDate, createTime, oeori, arci, seqNo, level, para) As %String
{
	n (adm,userInfo,createDate,createTime,oeori,arci,seqNo,level,para)

	s para=$tr(para,"^","@")
	s para=$tr(para,"!","@")
	k PLIST
    s PLIST(2)=adm
    s PLIST(3)=oeori
    s PLIST(4)=createDate
    s PLIST(5)=createTime
    s PLIST(6)=$p(userInfo,"^",1)
    s PLIST(7)=$p(userInfo,"^",2)
    s PLIST(8)=$p(userInfo,"^",3)
   	s PLIST(9)=arci
    s PLIST(10)=level
    s PLIST(16)=seqNo	//quniapeng 2017/9/1
    s PLIST(17)=para	//quniapeng 2017/9/2
    //s PLIST(15)=linkOeori
        
    TS
    &sql(INSERT INTO DHC_PHMonitorRecord VALUES :PLIST())
        
    i SQLCODE'=0  tro  Q:SQLCODE
    tc
    q %ROWID
}

/// Description:	存储医嘱的执行日期  
/// Creator:		QuNianpeng 
/// CreateDate:		2017-08-10
/// Input:			医嘱监控主表ID,创建日期
/// return:			插入监测表的id
/// other:          存在执行日期的作用：一条异常长嘱只在监控记录表存一次.查询时,若时间大于医嘱的开始日期,则这条医嘱被漏查。存储执行日期,则长嘱相当于每天被记录一次
ClassMethod SaveMRitemDate(phmrRowId, exDate) As %String
{
	n (phmrRowId, exDate)

	q:(phmrRowId="")||(phmrRowId=0) 0
	s PLIST(0)=phmrRowId
	s PLIST(2)=+$o(^DHCPHMREC(phmrRowId,"I",""),-1)+1
	s PLIST(3)=exDate
	ts
	&sql(INSERT INTO DHC_PHMonitorRecItm VALUES :PLIST())	
	i SQLCODE'=0  tro  Q SQLCODE
	tc
	Q +%ROWID
}

/// Description:	存储异常医嘱的对应到知识库中的目录及提示内容
/// Creator:		QuNianpeng 
/// CreateDate:		2017-08-10
/// Input:			医嘱监控主表ID,目录id,错误标志,正确信息,错误提示信息
/// return:			插入监测目录信息表的id
/// other：			
ClassMethod SaveMRLabel(phMRId, labelDr, errFlag, trueMsg, errMsg, linkOeori, linkOeSeqNo, linkArci, labelLevel) As %String
{
	n (phMRId,labelDr,errFlag,trueMsg,errMsg,linkOeori,linkOeSeqNo,linkArci,labelLevel)
	s rtn=0
	q:(phMRId="")||(phMRId=0) 0 

	s PLIST(0)=phMRId  								    //父表ID
	s PLIST(2)=+$o(^DHCPHMREC(phMRId,"Label",""),-1)+1   //childsub
	s PLIST(3)=labelDr	//目录ID
	s PLIST(4)=errFlag   //错误标志
	s PLIST(5)=errMsg	//错误原因
	s PLIST(6)=trueMsg	//正确提示
	s PLIST(7)=linkOeori	//关联医嘱id
	s PLIST(8)=linkOeSeqNo	//关联医嘱序号
	s PLIST(9)=linkArci		//关联医嘱的医嘱项id
	s PLIST(10)=labelLevel	//目录管理级别

	ts
	&sql(INSERT INTO DHC_PHMonitorRecLabel VALUES :PLIST())	

	i SQLCODE'=0  tro 
	Q:SQLCODE'=0
	tc
	
	q %ROWID
}

/// Description:	获取一个药品最终的管理级别
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-04
/// Input:			进程号,药品节点信息
/// return:			管理级别
/// other:			
ClassMethod GetLabelManLevel(pid, msgNode) As %String
{
	n (pid,msgNode)
	s level="",labelDr=""
	f  s labelDr=$o(^TMP("DHCST","web.DHCSTPHCMPASS","GetRecVal",pid,"LabelCtrl",msgNode,labelDr)) q:labelDr=""  d
	.s level=$g(^TMP("DHCST","web.DHCSTPHCMPASS","GetRecVal",pid,"LabelCtrl",msgNode,labelDr))
	.s ^TMP("DHCST","web.DHCSTPHCMPASS","GetLabelManLevel",pid,"TMP",level)=""
	
	s level=$o(^TMP("DHCST","web.DHCSTPHCMPASS","GetLabelManLevel",pid,"TMP",""),-1)
	k ^TMP("DHCST","web.DHCSTPHCMPASS","GetLabelManLevel",pid)
	
	q level
}

/// Description:	获取所有药品最终的管理级别
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-09
/// Input:			进程号
/// return:			管理级别
/// other:			
ClassMethod GetCommonManLevel(pid) As %String
{
	n (pid)
	s commonManLevel=""
	s msgNode=""

	f  s msgNode=$o(^TMP("DHCST","web.DHCSTPHCMPASS","GetRecVal",pid,"LabelCtrl",msgNode)) q:msgNode=""  d
	.s labelLevel=""
	.s labelDr=""
	.f  s labelDr=$o(^TMP("DHCST","web.DHCSTPHCMPASS","GetRecVal",pid,"LabelCtrl",msgNode,labelDr)) q:labelDr=""  d
	..s labelLevel=$g(^TMP("DHCST","web.DHCSTPHCMPASS","GetRecVal",pid,"LabelCtrl",msgNode,labelDr))
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","GetCommonManLevel",pid,"LabelLevel",labelLevel)=""
	.s drugLevel=$o(^TMP("DHCST","web.DHCSTPHCMPASS","GetCommonManLevel",pid,"LabelLevel",""),-1)
	.s ^TMP("DHCST","web.DHCSTPHCMPASS","GetCommonManLevel",pid,"DrugLevel",drugLevel)=""
	
	s commonManLevel=$o(^TMP("DHCST","web.DHCSTPHCMPASS","GetCommonManLevel",pid,"DrugLevel",""),-1)
	s commonManLevel=$SELECT(commonManLevel=-1:"S",commonManLevel=0:"W",commonManLevel=1:"C",1:"W") 
	
	k ^TMP("DHCST","web.DHCSTPHCMPASS","GetCommonManLevel",pid)
	
	q commonManLevel
}

/// Description:	判断知识库用法用量中的剂量是否维护
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-04
/// Input:			前提条件标志,节点,函数,目录索引
/// return:			0 未维护  1 维护
/// other:			
ClassMethod GetUseQtyFlag(condFlag As %String, indexMain As %String, itmFun As %String, instruId As %String) As %String
{
	n (condFlag,indexMain,itmFun,instruId)
	
	s useQtyFlag=0
	
	s libDr=$p(indexMain,",",4)  //标识id
	s labelDr=$p(indexMain,",",2) //目录id
	s labelDesc=$P(^DHCPHPINL(labelDr),"^",2)
	q:labelDesc'["用法用量" 0
		
	s usdoId=$o(^DHCPHUSDO(0,"Inst",instruId,""))  		//DHC_PHUsageDosage  用法用量表（业务表）
	q:usdoId="" 0	
	
	s oneDayTimeMin=$p(^DHCPHUSDO(usdoId),"^",2)	//每日服药次数
	s oneDayTimeMax=$p(^DHCPHUSDO(usdoId),"^",3)
	i (oneDayTimeMin'="")||(oneDayTimeMax'="") s useQtyFlag=1	
	
	s libUseQtyMin=$p(^DHCPHUSDO(usdoId),"^",4)    //单次用药量	
	s libUseQtyMax=$p(^DHCPHUSDO(usdoId),"^",5)
	s libUseQtyUomId=$p(^DHCPHUSDO(usdoId),"^",6)
	i (libUseQtyMin'="")||(libUseQtyMax'="")||(libUseQtyUomId="") s useQtyFlag=1

	s libUseQtyMin=$p(^DHCPHUSDO(usdoId),"^",7)   //每日用药总量      
	s libUseQtyMax=$p(^DHCPHUSDO(usdoId),"^",8)
	s libUseQtyUomId=$p(^DHCPHUSDO(usdoId),"^",9)	
	i (libUseQtyMin'="")||(libUseQtyMax'="")||(libUseQtyUomId="") s useQtyFlag=1	

	s libMaxUseQty=$p(^DHCPHUSDO(usdoId),"^",10)   //单次最大量
	s libUseQtyUomId=$p(^DHCPHUSDO(usdoId),"^",11)		
	i (libMaxUseQty'="")||(libUseQtyUomId="") s useQtyFlag=1

	s libMaxUseQty=$p(^DHCPHUSDO(usdoId),"^",12)  	//每日最大量
	s libUseQtyUomId=$p(^DHCPHUSDO(usdoId),"^",13)	  
	i (libMaxUseQty'="")||(libUseQtyUomId="") s useQtyFlag=1	

	s libUseQtyMin=$p(^DHCPHUSDO(usdoId),"^",14)    //首次用药量 (尚未启用)     
	s libUseQtyMax=$p(^DHCPHUSDO(usdoId),"^",15)
	s libUseQtyUomId=$p(^DHCPHUSDO(usdoId),"^",16)	  
	i (libUseQtyMin'="")||(libUseQtyMax'="")||(libUseQtyUomId="") s useQtyFlag=1
	
	s libUseQtyMin=$p(^DHCPHUSDO(usdoId),"^",17)   //连用量(尚未启用)       
	s libUseQtyMax=$p(^DHCPHUSDO(usdoId),"^",18)
	s libUseQtyUomId=$p(^DHCPHUSDO(usdoId),"^",19)	  
	i (libUseQtyMin'="")||(libUseQtyMax'="")||(libUseQtyUomId="") s useQtyFlag=1
		
	q useQtyFlag
}

/// Description:	验证检测项目在不通过的情况下是否是前提条件
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-04
/// Input:			节点,函数,目录索引id,项目审查结果
/// return:			0 前提条件  1 不是前提条件
/// other:			
ClassMethod CheckExtion(indexMain As %String, itmFun As %String, instruId As %String, chkVal As %String) As %String
{
	n (indexMain,itmFun,instruId,chkVal)
	
	s exitonerec=0
	s condFlag=..GetCondFlag(indexMain,itmFun)		//1是前提条件 0不是前提条件
	s useQtyFlag=..GetUseQtyFlag(condFlag,indexMain,itmFun,instruId)	//知识库是否维护剂量标志 1维护 0未维护

	//i (condFlag=1)&(useQtyFlag=1)&(chkVal=0) s exitonerec=1   //前提条件不通过
	i (condFlag=1)&(chkVal=0) s exitonerec=1   //前提条件不通过

	q exitonerec
}

/// Description:	获取病人基本信息
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-04
/// Input:			就诊id
/// return:			
/// other:			w ##class(web.DHCSTPHCMPASS).GetPatInfo(1)
ClassMethod GetPatInfo(adm As %String) As %String
{
	n (adm)
	s patInfo=""

 	s papmi=+$p(^PAADM(adm),"^",1) 			//PA_PatMas 
	s sexDr=$p(^PAPER(papmi,"ALL"),"^",7)
    s patSex=$p(^CT("SEX",sexDr),"^",2)		//检查性别项目 
    i patSex="男" s patSex="M"
    i patSex="女" s patSex="F"
    s getAge=##class(PHA.FACE.IN.Com).GetAge(papmi,adm)	//年龄
    s argBirthday=$p(^PAPER(papmi,"ALL"),"^",6)
	s argAdmDate=$p($h,",",1)
	s tmpAge=$$CalAge^at182(argBirthday,argAdmDate)
	i (tmpAge'="")&&($l(tmpAge,"|")'<14) d
	.s ageYears=$p(tmpAge,"|",12)
	.s ageMonths=$p(tmpAge,"|",13)
	.s ageDays=$p(tmpAge,"|",14)
	s patAge=+$p(tmpAge,"|",12)_"|"_$p(tmpAge,"|",13)_"|"_$p(tmpAge,"|",14)
	
	s mradm=$P(^PAADM(adm),"^",61)
	s patWeight=$P(^MR(mradm,"PRO",1),"^",27)
	
	s patPlan="",patclimac="",patmens="",patlac="",patpre="",patliver="",patren=""
    //s admInfo=$P($g(^MR(mradm,"DHC")),"^",8)  				  // 特殊人群
    s admInfo=##class(web.DHCSTPHCMPASSFUN).GetSpecialDesc(mradm) // qnp 2018/3/30 his特殊人群走了配置
 
    //w ##class(web.DHCSTPHCMPASS).GetMRDiagnosDesc(Adm)
    s patIcd=..GetMRDiagnosDesc(adm,",")  //取his诊断

    i admInfo=""  s admInfo=..GetAdmInfo(patIcd) ;2017-03-30 cy 添加,根据诊断关联病症,病症关联特殊人群,获取与特殊人群相关的病人诊断  
    i admInfo=""  s admInfo=..GetAdmInfoByDisHistory(adm,"B")  //qnp 通过既往史取特殊人群 17/4/10
    i admInfo=""  s admInfo=..GetAdmInfoByLabItm(adm,"F")      //qnp 通过检验指标取特殊人群 17/4/10
    i admInfo=""  s admInfo=..GetAdmInfoByLisRet(adm,"E")     //qnp 通过检查结果取特殊人群 17/4/10

	s patInfo=patSex_"^"_patAge_"^"_patWeight_"^"_patIcd_"^"_admInfo

	q patInfo
}

/// Description: 用户登录信息处理
/// Creator:     qunianpeng
/// CreateDate:  2017-07-24
/// Input:		 用户id^登录科室id^登录安全组id	 
/// Return:		用户id^^登录科室id^登录安全组id	 
/// Other:
ClassMethod DealUserInfo(userInfo As %String) As %String
{

	n (userInfo)
	s hospId=""
	s userId=$p(userInfo,"^",1)
	s ctLocId=$p(userInfo,"^",2)
	s groupId=$p(userInfo,"^",3)
	i ctLocId'="" S hospId=$P($g(^CTLOC(ctLocId)),"^",22)   
	s cptId="" //作用是？
	
	i hospId="" s hospId=$o(^CT("HOSP",0))
	
	s accinfo=userId_"^"_cptId_"^"_ctLocId_"^"_hospId  // 登录信息，用于验证权限
	
	q accinfo
}

/// Description: 获取有效医嘱
/// Creator:     QuNianpeng
/// CreateDate:  2017-07-24
/// Input:		 医嘱id串 
/// Return:		 有效的医嘱id串
/// Other:		 接受的医嘱id串已经是再用医嘱(即未停止、撤销、作废) 处理临嘱只保留当日临嘱
ClassMethod GetUseOrdStr(ordItem As %String) As %String
{
	n (ordItem)
	q:ordItem="" ""
	s ordItemStr=""
	s ordItmCnt=$l(ordItem,$c(2))    //已审核的医嘱
    f len=1:1:ordItmCnt d
    .s flag=0
    .s oeori=$p(ordItem,$c(2),len)	     
    .q:oeori=""
    .s oeord=$p(oeori,"||",1)
    .s oeordSub=$p(oeori,"||",2)   
    .q:'$d(^OEORD(oeord,"I",oeordSub))
    .s priority=$p(^OEORD(oeord,"I",oeordSub,1),"^",8)  //医嘱优先级  NORM-临时医嘱  S-长嘱
    .i priority'="" s priority=$p(^OECPR(priority),"^",1)
    .i priority="NORM"  d
    ..s oeoriStDate=$p(^OEORD(oeord,"I",oeordSub,1),"^",9) //临嘱只需要当日临嘱
    ..s:+oeoriStDate'=+$h flag=1
    .q:flag=1
    .
    .s statusDr=$p(^OEORD(oeord,"I",oeordSub,1),"^",13) //医嘱状态 U-作废 D-停止 C-撤销
    .i statusDr'="" s statusCode=$p(^OEC("OSTAT",statusDr),"^",1)
    .q:(statusCode="U")||(statusCode="D")||(statusCode="C")
    .i ordItemStr="" d
    ..s ordItemStr=oeori
    .e  d
    ..s ordItemStr=ordItemStr_$c(2)_oeori

	q ordItemStr
}

/// Description: 处理界面上的本次医嘱项串和已提交的医嘱id串，并进行拼接
/// Creator:     QuNianpeng
/// CreateDate:  2017-07-24
/// Input:		 本次医嘱项串，历次医嘱id串
/// Return:		 拼接后的医嘱项串
/// Other:
ClassMethod DealOrdStr(ordStr As %String, ordItem As %String) As %String
{
	    
    n (ordStr,ordItem)
      
    s ordItmCnt=$l(ordItem,$c(2))    //已审核的医嘱串
        
    f len=1:1:ordItmCnt d
    .s tmp=$p(ordItem,$c(2),len)	 //遍历已经提交的医嘱串，并和界面的医嘱项串键盘拼接
    .s oeori=$p(tmp,"^",1)          // 医嘱ID OE_OrdItem
    .q:oeori=""
    .//(传递的医嘱id串已经是有效医嘱--即没有停止、撤销等的医嘱)
    .s tmpPartStr=$p(tmp,"^",10)  //部位 
	.s oeord=$p(oeori,"||",1)		 
	.s oeordSub=$p(oeori,"||",2)	
	.s arci=$p(^OEORD(oeord,"I",oeordSub,1),"^",2)	// ARC_ItmMast  医嘱码表（药品）
	.s sub=$p(arci,"||",1),ver=$p(arci,"||",2)
	.s itemCatDr=""
	.i +sub'=0 s itemCatDr=$P(^ARCIM(+sub,ver,1),"^",10)	//ARC_ItemCat（医嘱子类）
	.s instId=""	//用法
	.s freqId=""    //频次
	.s dosQty=""    //剂量
	.s dosUomId=""  //剂量单位
	.s onceQty=""   //总量
	.s ordUomId=""  //总量单位
	.s course=""    //疗程
	.s seqNo=""     //关联医嘱
	.s hisSpec=""   //标本
	.s tmpPart=""  //部位
	.s recDepDr="" //接收科室$p(^OEORD(oeord,"I",oeordSub,3),"^",6) //接收科室
    .
	.s orderType=""
	.i itemCatDr'="" s orderType=$P(^ARC("IC",itemCatDr),"^",7) //医嘱类型
	.i orderType="R" d 	//药品 取医嘱的基本信息，如频次，用法等
    ..s phcdf=$p($g(^ARCIM(sub,ver,1)),"^",12)
    ..s instId=$p($g(^OEORD(oeord,"I",oeordSub,2)),"^",7)
	..s freqId=$p($g(^OEORD(oeord,"I",oeordSub,2)),"^",4)
	..s dosQty=$p($g(^OEORD(oeord,"I",oeordSub,2)),"^",1)   //剂量
	..s dosUomId=$p($g(^OEORD(oeord,"I",oeordSub,2)),"^",3)
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
    ..q:dsp=""
	..s onceQty=$p(^DHCOEDISQTY(dsp),"^",2)
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arci,"||",1),"") )  
	..s uomId=$p(^INCI(inci,1),"^",10)
	..s ordUomId=$p(^CT("UOM",uomId),"^",2) 
	..//s course=$p(^PHCDU($p(^OEORD(oeord,"I",oeordSub,2),"^",6)),"^",1)
	..s course=$p($g(^OEORD(oeord,"I",oeordSub,2)),"^",6)
	..s linkFlag=##class(web.DHCSTPHCMORDDATA).GetOISeqFlag(oeori)  //判断改医嘱是否成组关联
	..s seqNo=$p($g(^OEORD(oeord,"I",oeordSub,3)),"^",4)	//取序号  在序号中拼上医嘱是否关联标志
	..s seqNo=linkFlag_$c(1)_seqNo   //seqNo：以$c(1)分割 第一位是关联医嘱标志  1是 0否；第二位医嘱序号 如：主医嘱是1 则子医嘱分别是1.2 1.3
  	.
  	.i orderType="X" d //检查
  	..s tmpPart=""
  	..s recDepDr=$p(^OEORD(oeord,"I",oeordSub,3),"^",6) //接收科室
    .
   	.i orderType="L" d   //检验
  	..s hisSpec=..GetTestSetSpecimen(arci) //  获取标本编码
  	..s recDepDr=$p(^OEORD(oeord,"I",oeordSub,3),"^",6) //接收科室
   	.//医嘱详细信息
  	.s tmpInfo=arci_"^"_instId_"^"_freqId_"^"_dosQty_"^"_dosUomId_"^"_onceQty_"^"_ordUomId_"^"_course_"^"_seqNo_"^"_hisSpec_"^"_tmpPart_"^"_recDepDr_"^"_oeori
   
  	.i ordStr="" d
	..s ordStr=tmpInfo
	.e  d
	..s ordStr=ordStr_$c(2)_tmpInfo
    .

	q ordStr
}

/// Description: 获取过敏史
/// Creator:     QuNianpeng
/// CreateDate:  2017-07-24
/// Input:		 就诊id
/// Return:		  
/// Other:
/// w ##class(web.DHCSTPHCMPASS).GetAlgDesc(197,122)
ClassMethod GetAlgDesc(adm As %String, pid As %String) As %String
{
	n (adm,pid)
	s papmi=$p(^PAADM(adm),"^",1)
	s algSub=0
	f  s algSub=$o(^PAPER(papmi,"ALG",algSub)) q:(algSub="")||(algSub=0)  d
	.s algDesc=""
	.s algStatus=$p($g(^PAPER(papmi,"ALG",algSub)),"^",8)
	.q:algStatus="I" // I 是删除状态Inactive 2021/5/17 qnp
	.s algTypeDr=$p(^PAPER(papmi,"ALG",algSub),"^",9)
	.i algTypeDr'="" s algDesc=$p(^PAC("ALG",algTypeDr),"^",2)		//PAC_Allergy 
	.i algDesc'="" s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"allgy",algDesc)=""
	.i algDesc="" d
	..s algPhcdmDr=$p($g(^PAPER(papmi,"ALG",algSub)),"^",30) ; ARC_ItmMast
	..q:$g(algPhcdmDr)=""
	..q:$p(algPhcdmDr,"||",2)=""
	..s arcDesc=$p(^ARCIM(+algPhcdmDr,$p(algPhcdmDr,"||",2),1),"^",2)
	..s:arcDesc'="" ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"allgy",arcDesc)=""
	/*
	.s algPhcdmDr=$p(^PAPER(papmi,"ALG",algSub),"^",30) ; ARC_ItmMast
	.i algPhcdmDr'="" d
	..;s phcdfsub=$o(^PHCD(algphcdmdr,"DF",""),-1)
	..;s phcdf=algphcdmdr_"||"_phcdfsub
	..;s arcsub=$o(^ARCIM(0,"PHCDF",phcdf,""),-1)
	..;s arcver=$o(^ARCIM(0,"PHCDF",phcdf,arcsub,""),-1)
	..s arcSub=+algPhcdmDr
	..s arcVer=$p(algPhcdmDr,"||",2)
	..s algchl=0
	..f  s algchl=$o(^ARCIM(arcSub,arcVer,"ALG",algchl)) q:(algchl="")||(algchl=0)  d
	...s aller=$p(^ARCIM(arcSub,arcVer,"ALG",algchl),"^",3)
	...s algDesc=$p(^PAC("ALG",aller),"^",2)
	...q:algDesc=""
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"allgy",algDesc)=""  //过敏史
	*/
}

/// Description: 遍历知识库规则，并用临时global存储
/// Creator:     QuNianpeng
/// CreateDate:  2017-07-14
/// Input；		 登录信息,pid进程号   accinfo=userid_"^"_cptId_"^"_ctlocid_"^"_HospID
/// Other:   	思路：遍历规则配置表，取对应的标识字典，取优先级，取目录对应关系，判断标识授权。 -->遍历规则项目，取项目对应关系，判断授权，取项目对应函数
ClassMethod TraversalRules(accInfo As %String, pid) As %String
{
	n (accInfo,pid)
	s count=0
	s h=0
	s LibRelation=1
	//遍历规则
	//遍历规则并用临时global将规则存起来    遍历层次：目录->项目
	s libDr=""  //遍历规则主表
	f  s libDr=$o(^DHCPHLIBRULE(0,"OrdNum",libDr)) q:libDr=""  d	//DHC_PHLibRule
	.s accType=..GetAccPointer(accInfo,libDr)  						//知识库标识字典表(药品，公共) //获取权限优先级（主目录权限--是以用户，安全组，科室，医院授权）
	.s labelNum=""
	.f  s labelNum=$o(^DHCPHLIBRULE(0,"OrdNum",libDr,labelNum)) q:labelNum=""  d 
	..s ruleMain=""
	..f  s ruleMain=$o(^DHCPHLIBRULE(0,"OrdNum",libDr,labelNum,ruleMain)) q:ruleMain=""  d  //ruleMain->DHC_PHLibRule的ID  规则主表
	...s ruleRelat=$p(^DHCPHLIBRULE(ruleMain),"^",4)    // 目录之间的对应关系(如适应症和用法用量间的关系)
	...q:ruleRelat="Or"
	...//i ruleRelat="And" s ruleRelat="&"  			//And表标检查,Or表示忽略   2018/3/16 qunianpeng 注释 or关系则直接不计入审查global
	...//i ruleRelat="Or" s ruleRelat="||"
	...s labelDr=$p(^DHCPHLIBRULE(ruleMain),"^",2) 		//目录id
	...s accMain=..CheckLabelAcc(accInfo,libDr,accType,labelDr)    //判断目录是否授权
	...q:accMain="" 
	...s count=count+1
	...s index=count_","_labelDr_","_ruleMain_","_libDr           //序号 目录 规则表ID 标识
	...
	...//遍历规则项目  规则字表
	...s ordNum=""
	...f  s ordNum=$o(^DHCPHLIBRULE(0,"OrdNum",ruleMain,ordNum)) q:ordNum=""  d  
	....s ruleSub=""
	....f  s ruleSub=$o(^DHCPHLIBRULE(0,"OrdNum",ruleMain,ordNum,ruleSub)) q:ruleSub=""  d
	.....s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"rule",index)=ruleRelat  
	.....q:'$d(^DHCPHLIBRULE(ruleMain,"I",ruleSub))
	.....s ruleItmRelat=$p(^DHCPHLIBRULE(ruleMain,"I",ruleSub),"^",2)   //一个目录下多个子项目的对应关系
	.....q:ruleItmRelat="Or"
	.....s ruleItmRelat=$case(ruleItmRelat,"And":"&","Or":"||",:"&")
	.....//i ruleItmRelat="And" s ruleItmRelat="&"						2018/3/16 qunianpeng 注释 or关系则直接不计入审查global
	.....//i ruleItmRelat="Or" s ruleItmRelat="||"
	.....s ruleItmDr=$p(^DHCPHLIBRULE(ruleMain,"I",ruleSub),"^",3)       //规则项目id 
	.....q:..CheckRuleItmAcc(accInfo,libDr,accType,labelDr,ruleItmDr)=0  //验证规则项目权限 //目录子项目授权， 返回值为0,1 1有授权
	.....s itmRelat=$p(^DHCLIBITMF(ruleItmDr),"^",10) 					 //项目关系，标识是全部记录全通过，还是有一条通过(Or)  //and表示此项目下多条审查规则需要全部通过，or表示审查规则通过一条即可
	.....q:itmRelat="Or"												 //项目关系为全局关系,如年龄项目为or,则所有目录下的年龄项目都忽略
	.....s itmFunDr=$p(^DHCLIBITMF(ruleItmDr),"^",3)    //函数	
	.....s itmFun=$p(^DHCPHLFUNS(itmFunDr),"^",3)			
	.....//s itmarg=$p(^DHCLIBITMF(ruleitmdr),"^",8)   //入参
	.....//s ExtStr=$p(itmfundr,"(")_"("_itmarg_")"    //开始验证(0反向:禁忌)
	.....s itmDirec=$p(^DHCLIBITMF(ruleItmDr),"^",9)   //方向  //qnp 返回值	
	.....s extStr=itmFun
	.....s h=h+1
	.....q:$d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"rulechk",ruleMain,ruleSub))
	.....s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"rulechk",ruleMain,ruleSub)=""  //不让重复检查
	.....s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"rule",index,h)=extStr  
	.....s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"relat",index,h)=ruleItmRelat_"^"_itmRelat_"^"_itmDirec //规则项目关系 项目关系 返回值
	.....
}

/// 返回知识库->HIS的等效数量,默认知识库是his的基本单位
ClassMethod GetUomFacNum(arci, buomdr, libuomdr) As %String
{
	n (arci,buomdr,libuomdr)
	
	q:libuomdr="" 1
	q:'$d(^DHCPHEUO(libuomdr)) 1
	s libnumcode=$p(^DHCPHEUO(libuomdr),"^",1)
	s tmpcode=$o(^DHCPHUOCON(0,"Code",libnumcode,""))
	q:tmpcode="" 1
	s tmpdr=$o(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(tmpcode),""))
	
	q:buomdr=tmpdr 1
	
	S phcdf=$P(^ARCIM(+arci,$p(arci,"||",2),1),"^",12)
	S phc=$P(phcdf,"||",1)
	Q:phc="" 1
	S formsub=$P(phcdf,"||",2)
	Q:formsub="" 1
	s eqsub="0",eqqty=0
	f  s eqsub=$O(^PHCD(phc,"DF",formsub,"EQ",eqsub)) q:eqsub=""  d
	.S equomdr=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",1)
	.
	.Q:equomdr'=tmpdr
	.s eqqty=+$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",2) //等效数量
	

	Q:eqqty=0 1
	
	
	q eqqty
}

// 此方法中的原本有buomdr参数貌似没使用，去掉  qunianpeng 2016/8/4

ClassMethod GetBUomFac(arci, dosuomid) As %String
{
	n (arci, dosuomid)
	S phcdf=$P(^ARCIM(+arci,$p(arci,"||",2),1),"^",12)
	S phc=$P(phcdf,"||",1)
	Q:phc="" 1
	S formsub=$P(phcdf,"||",2)
	Q:formsub="" 1
	s eqsub="0",eqqty=0
	f  s eqsub=$O(^PHCD(phc,"DF",formsub,"EQ",eqsub)) q:eqsub=""  d
	.S equomdr=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",1)
	.Q:equomdr'=dosuomid
	.s eqqty=+$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",2) //等效数量
	Q:eqqty=0 1
	
	
	q eqqty
}

/// 返回记录的描述
ClassMethod GetInstruIdMsg(instruId) As %String
{
	n (instruId)
	s msg=$p(^DHCPHINSTRUC(instruId),"^",15)
	q msg
}

/// 返回相互作用消息
ClassMethod GetEctInstruIdMsg(pid, GenItmDr) As %String
{
	n (pid,GenItmDr)
	s msg="",ret=""
	s tmpInstId=""
	f  s tmpInstId=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EffectInstId",GenItmDr,tmpInstId)) q:tmpInstId=""  d
	.s msg=..GetInstruIdMsg(tmpInstId)
	.i ret="" d
	..s ret=msg
	.e  d
	..s ret=ret_","_msg
	
	q ret
}

/// Description:	按照体重计算剂量
/// Creator:		QuNianpeng
/// CreateDate:		2017-03-27
/// Input:			知识库剂量,知识库剂量单位id,his单位id,体重
/// return:			计算后的剂量
/// other:
/// w ##class(web.DHCSTPHCMPASS).changeUnit(200,3,149,"")
ClassMethod ChangeUnit(qty, qtyUom, dosUomId, patWeight) As %String
{
	n (qty,qtyUom,dosUomId,patWeight)
	i patWeight="" q qty
	
	s qtyUomDesc=""
	i qtyUom'="" s qtyUomDesc=$p(^DHCPHEUO(qtyUom),"^",2) //单位字典表
	i qtyUomDesc["/kg" d
	.s qty=qty*patWeight
	.s tempLibUom=$p(qtyUomDesc,"/",1)
	.s dosUom=$p(^CT("UOM",dosUomId),"^",2)  //his中剂量单位
	.i (tempLibUom="mg")&(dosUom="g") S qty=qty/1000
	.i (tempLibUom="g")&(dosUom="mg") S qty=qty*1000
	.i (tempLibUom="ml")&(dosUom="l") S qty=qty/1000
	.i (tempLibUom="ml")&(dosUom="l") S qty=qty/1000	
	.i (tempLibUom="l")&(dosUom="ml") S qty=qty*1000
	.s qtyUom=dosUomId
			
	q qty
}

/// Description:	根据转换系数进行剂量转换
/// Creator:		QuNianpeng
/// CreateDate:		2017-03-27
/// Input:			剂量, 医嘱项ID,his单位ID, 知识库剂量单位ID
/// return:			计算后的剂量
/// other:			//暂时弃用(2017/8/4 qunianpeng)
/// w ##class(web.DHCSTPHCMPASS).changeUnit() 
ClassMethod changeQtyByModulus(qty, arci, buomDr, dosuomId, dosUom) As %String
{
	n (qty,arci,buomDr,dosuomId,dosUom) 
	s dosUomDesc=""
	i dosUom'="" s dosUomDesc=$p(^DHCPHEUO(dosUom),"^",2)
	i dosUomDesc["/kg" d  s factor=..GetBUomFac(arci,buomDr,dosuomId) //获取转换系数
	i dosUomDesc'["/kg" d  s factor=..GetUomFacNum(arci,buomDr,dosUom)
		
	i qty'="" d
    .s qty=qty/factor
    .i $f(qty,".") s qty=$fn(qty,"",6)
    
	Q qty
}

/// Description: 获取某目录下项目的前提条件标志(在用法用量目录下检测具体的用药量时，先判断其他项目是否是前提判断项)
/// Creator:     QuNianpeng
/// CreateDate:  2017-04-10
/// Input:  	 
/// Return: 	1是前提条件 0不是前提条件
/// Others:		 w ##class(web.DHCSTPHCMPASS).GetAdmInfoByLabItm()
ClassMethod GetCondFlag(indexMain, itmFun) As %String
{
	n (indexMain,itmFun)
	s condFlag=0
	
	s libDr=$p(indexMain,",",4)  //标识id
	s labelDr=$p(indexMain,",",2) //目录id
	s ruleId=$o(^DHCPHLIBRULE(0,"Label",libDr,labelDr,""))
	
	s ruleSub=""
	f  s ruleSub=$o(^DHCPHLIBRULE(ruleId,"I",ruleSub)) q:ruleSub=""  d
	.s ruleItmDr=$p(^DHCPHLIBRULE(ruleId,"I",ruleSub),"^",3)  //项目ID
	.s itmFunDr=$p(^DHCLIBITMF(ruleItmDr),"^",3)  //函数
	.s tmpItmFun=$p(^DHCPHLFUNS(itmFunDr),"^",3)
	.q:tmpItmFun'=itmFun
	.s condition=$p(^DHCPHLIBRULE(ruleId,"I",ruleSub),"^",4) //前提条件
	.s:condition="Y" condFlag=1
	
	q condFlag
}

/// Description:	更新日志信息
/// Creator:		QuNianpeng
/// CreateDate:		2017-09-26
/// Input:			日志表id^医嘱id   //多组用!分割
/// return:			
/// other:			w ##class(web.DHCSTPHCMPASS).UpdateLibOrdLog("7^1931016||75")
ClassMethod UpdateLibOrdLog(params As %String) As %String
{
	n (params)
	//s ^TMPQNP($h)=params
	s date=$p($h,",",1)
    //s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid() 
	s count=$l(params,"!")
	f len=1:1:count d
	.s tmpParams=$p(params,"!",len)
	.s mrRowId=$p(tmpParams,"^",1)					//日志表id
	.s oeori=$p(tmpParams,"^",2)					//医嘱id
	.s mainOeori=$p(tmpParams,"^",3)				//关联医嘱id
	.q:(mrRowId="")||(oeori="")
	.s mrOeori=$p($g(^DHCPHMREC(mrRowId)),"^",2)
	.q:mrOeori'=""
	.TS
	.&sql(UPDATE DHC_PHMonitorRecord SET PHMR_Oeori_Dr=:oeori,PHMR_LinkOeor_Dr=:mainOeori WHERE PHMR_Rowid=:mrRowId)
	.i ('$d(^DHCPHMREC(0,"ExDate",date,mrRowId)))&(oeori'="") d
    ..d ##class(web.DHCSTPHCMORDDATA).SaveMRitemDate(mrRowId,date)              //将执行日期插入到子表中(日志信息不需要在日期子表存日期)
    .
	.i SQLCODE'=0  tro  Q:SQLCODE
	.tc
	
	q +$g(%ROWID)
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	
	k ^TMP("DHCST","DHCSTPHCMPASS","GetLibDataForWin",pid)	// 悬浮框用临时global
	k ^TMP("DHCST","web.DHCSTPHCMPASS","CheckFreqList",pid) // 记录用药频率是否审查过，且不满足
	k ^TMP("DHCST","web.DHCSTPHCMPASS","CheckUseList",pid)  // 记录给药途径是否审查过，且不满足
	k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid)
	k ^TMP("DHCST","web.DHCSTPHCMPASS","GetRecVal",pid) 		// 记录每个目录的返回级别
}

/// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// ///////////////////////////////////////////////////药品子库审查函数和其他辅助函数////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Description:	获取医嘱类型和知识库通用名/检验名串
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-26
/// Input:			医嘱项id
/// return:			医嘱类型,知识库通用名/检验名串
/// other:			知识库通用名/商品名串组成：	his通用名描述,知识库通用名id,知识库商品名id,知识库剂型/标本/部位
ClassMethod GetCommonTypeInfo(arci As %String, hisPart As %String, checkType = "") As %String
{
	n (arci,hisPart,checkType)

	s sub=$p(arci,"||",1),ver=$p(arci,"||",2)
	i checkType'="Oper" s orderType=..GetOrdType(arci) 			/// 医嘱类型 
	e  s orderType="OP" 										/// 手术申请 ORC_Operation
   	i orderType="R" s commonLibInfo=..GetLibNameByDrug(arci),commonType="R"		 /// 药品医嘱
	i orderType="L" s commonLibInfo=..GetLibNameByLab(arci),commonType="L"		 /// 检验医嘱 
	i orderType="N" s commonLibInfo=##class(web.DHCSTPHCMPASSFUN).GetLibNameByTreat(arci),commonType="N"	 /// 治疗项目医嘱 	/// 添加治疗项目	
	i orderType="OP" s commonLibInfo=##class(web.DHCSTPHCMPASSFUN).GetLibNameByOper(arci),commonType="OP"	 /// 添加手术项目 ORC_Operation
	
	i checkType'="Oper" d
	.s serverMaterial=$p($g(^ARCIM(sub,ver,7)),"^",6)	
	.i serverMaterial="S" d
	..s commonLibInfo=..GetLibNameByLis(arci,hisPart)
	..s commonType="S"						/// 检查医嘱
	..s hisPartDesc=""
	..i hisPart'="" s partId=$o(^DHCAPPART(0,"Code",hisPart,""))	
	..i $g(partId)'="" s hisPartDesc=$p(^DHCAPPART(partId),"^",2)
	
	q $g(commonType)_","_$g(commonLibInfo)_","_$g(hisPartDesc)
}

/// Description:	审查每日用药次数
/// Creator:		QuNianpeng(重写)
/// CreateDate:		2017-08-04
/// Input:			目录索引id,药品剂量串
/// return:			0 不通过  1 通过
/// other:			药品剂量串（医嘱项id,单位,单次用药量/单次最大量,每日最大量/每日总量,用药次数,首次用药量,连用量,间隔数）
/// w ##class(web.DHCSTPHCMPASS).CheckOneDayTime(10287,"1043||1,10,149",50,.RetMsg)
ClassMethod CheckOneDayTime(instruId As %String, hisDosQtyInfo As %String, ByRef RetMsg As %String) As %String
{
 
	n (instruId,hisDosQtyInfo,RetMsg)
	
	q:instruId="" -100	//没有维护
	s usdoId=$o(^DHCPHUSDO(0,"Inst",instruId,""))  //DHC_PHUsageDosage  用法用量表（业务表）
	q:usdoId="" -100
	s useQtyFlag=0,ret=1,RetMsg=""

	i usdoId'="" d
	.s oneDayTimeMin=$p(^DHCPHUSDO(usdoId),"^",2)	//每日服药次数
	.s oneDayTimeMax=$p(^DHCPHUSDO(usdoId),"^",3)
	.i (oneDayTimeMin'="")||(oneDayTimeMax'="") s useQtyFlag=1
	q:useQtyFlag=0 -100
	
	s hisUseTime=$p(hisDosQtyInfo,",",5)
	
	//进行判断
	i ((hisUseTime<oneDayTimeMin)&(oneDayTimeMin'=""))||((hisUseTime>oneDayTimeMax)&(oneDayTimeMax'="")) d
	.s ret=0
	
	i ret=0 d
	.s RetMsg="每日服药次数,超出限制范围"_oneDayTimeMin_"~"_oneDayTimeMax_"次;"
	.i $d(^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)) d
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)_RetMsg
	.e  d	
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=RetMsg
	
	q ret
}

/// Description:	验证单次用药量
/// Creator:		QuNianpeng(重写)
/// CreateDate:		2017-08-04
/// Input:			目录索引id,药品剂量串,体重,返回值
/// return:			0 不通过  1 通过
/// other:			药品剂量串（医嘱项id,单位,单次用药量/单次最大量,每日最大量/每日总量,用药次数,首次用药量,连用量,间隔数）
ClassMethod CheckOnceQty(instruId As %String, hisDosQtyInfo As %String, patWeight As %String, ByRef RetMsg As %String) As %String
{
	n (instruId,hisDosQtyInfo,patWeight,RetMsg)

	q:instruId="" -100	//没有维护
	s usdoId=$o(^DHCPHUSDO(0,"Inst",instruId,""))  		//DHC_PHUsageDosage  用法用量表（业务表）
	q:usdoId="" -100

	s RetMsg=""	
	s useQtyInfo=""
	s useQtyFlag=0
	
	s libUseQtyMin=$p(^DHCPHUSDO(usdoId),"^",4)    //知识库维护的用药剂量和单位
	s libUseQtyMax=$p(^DHCPHUSDO(usdoId),"^",5)
	s libUseQtyUomId=$p(^DHCPHUSDO(usdoId),"^",6)
	s titleMsg="单次服药量"
	i (libUseQtyMin'="")||(libUseQtyMax'="") s useQtyFlag=1
	s hisUseQty=$p(hisDosQtyInfo,",",3)				//his传递的用药剂量和单位
	s hisUseQtyUomId=$p(hisDosQtyInfo,",",2)
	s arci=$p(hisDosQtyInfo,",",1)
	
	s useQtyInfo=libUseQtyMin_","_libUseQtyMax_","_libUseQtyUomId_","_useQtyFlag_","_hisUseQty_","_hisUseQtyUomId_","_titleMsg_","_arci

	s retMsg=..CheckUseQty(useQtyInfo,patWeight)
	s ret=$p(retMsg,"^",1)	

	i ret=0 d
	.s RetMsg=$p(retMsg,"^",2)
	.i $d(^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)) d
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)_RetMsg
	.e  d	
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=RetMsg

	q ret
}

/// Description:	验证单次最大量
/// Creator:		QuNianpeng(重写)
/// CreateDate:		2017-08-04
/// Input:			目录索引id,药品剂量串,体重,返回值
/// return:			0 不通过  1 通过
/// other:			药品剂量串（医嘱项id,单位,单次用药量/单次最大量,每日最大量/每日总量,用药次数,首次用药量,连用量,间隔数）
ClassMethod CheckOnceMaxQty(instruId As %String, hisDosQtyInfo As %String, patWeight As %String, ByRef RetMsg As %String) As %String
{
	n (instruId,hisDosQtyInfo,patWeight,RetMsg)
	q:instruId="" -100	//没有维护	
	s usdoId=$o(^DHCPHUSDO(0,"Inst",instruId,""))  		//DHC_PHUsageDosage  用法用量表（业务表）
	q:usdoId="" -100

	s ret=1
	s useQtyFlag=0
	s libMaxUseQty=$p(^DHCPHUSDO(usdoId),"^",10)    //知识库维护的用药剂量和单位
	s libMaxUseQtyId=$p(^DHCPHUSDO(usdoId),"^",11)
	q:(libMaxUseQty="")||(libMaxUseQtyId="") -100
	
	s changeFlag=0
	s titleMsg="单次最大量"
	i (libMaxUseQty'="") s useQtyFlag=1
	s hisMaxUseQty=$p(hisDosQtyInfo,",",3)				//his传递的用药剂量和单位
	s hisMaxUseQtyId=$p(hisDosQtyInfo,",",2)
	s arci=$p(hisDosQtyInfo,",",1)						
	s hisMaxUseQtyDesc=$p(^CT("UOM",hisMaxUseQtyId),"^",2)

	//知识库中单位包含体重，则按照体重进行剂量计算
	s libMaxUseQtyCode=""
	s libMaxUseQtyDesc=""
	i libMaxUseQtyId'="" s libMaxUseQtyDesc=$p(^DHCPHEUO(libMaxUseQtyId),"^",2),libMaxUseQtyCode=$p(^DHCPHEUO(libMaxUseQtyId),"^",1)
	i (libMaxUseQtyDesc["/kg")&(patWeight="")  q 1	
	i (libMaxUseQtyDesc["/kg")&(useQtyFlag) d  
	.s libMaxUseQty=..ChangeUnit(libMaxUseQty,libMaxUseQtyId,hisMaxUseQtyId,patWeight)  
	.s changeFlag=1 
	
	//用知识库中单位反向找到对照的his单位描述
	s libMaxUseQtyCode=$p(libMaxUseQtyCode,"/",1)
	s conHisMaxUseQtyCode=$o(^DHCPHUOCON(0,"Code",libMaxUseQtyCode,""))					//对照his单位code
	q:conHisMaxUseQtyCode="" -100
	s conHisMaxUseQtyId=$o(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(conHisMaxUseQtyCode),""))  //对照his单位id
	s conHisMaxUseQtyDesc=$p(^CT("UOM",conHisMaxUseQtyId),"^",2)							//对照his单位描述

	//his中剂量单位和知识库中单位不相同时,将知识库的剂量转换为his剂量
	i (hisMaxUseQtyDesc'=conHisMaxUseQtyDesc)&(changeFlag=0) d
	.s hisFac=..GetBUomFac(arci,hisMaxUseQtyId)  	 //获取his的等效数量
	.s libFac=..GetBUomFac(arci,libMaxUseQtyId) 	//获取知识库对照his单位的等效数量	 	
	.s libMaxUseQty=libMaxUseQty/libFac*hisFac		//将知识库的剂量转换为his剂量

	//进行判断
	i ((hisMaxUseQty>libMaxUseQty)&(libMaxUseQty'="")) d
	.s ret=0
	
	i ret=0  d
	.s RetMsg=titleMsg_hisMaxUseQty_hisMaxUseQtyDesc_",超出限制范围"_libMaxUseQty_hisMaxUseQtyDesc_";"
	.i $d(^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)) d
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)_RetMsg
	.e  d	
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=RetMsg
	

	q ret
}

/// Description:	验证每日总量
/// Creator:		QuNianpeng(重写)
/// CreateDate:		2017-08-04
/// Input:			目录索引id,药品剂量串,体重,返回值
/// return:			0 不通过  1 通过
/// other:			药品剂量串（医嘱项id,单位,单次用药量/单次最大量,每日最大量/每日总量,用药次数,首次用药量,连用量,间隔数）
/// w ##class(web.DHCSTPHCMPASS).CheckUseQty(10287,"1043||1,10,149",50,.RetMsg)
ClassMethod CheckOneDayQty(instruId As %String, hisDosQtyInfo As %String, patWeight As %String, ByRef RetMsg As %String) As %String
{
	n (instruId,hisDosQtyInfo,patWeight,RetMsg)
		
	q:instruId="" -100	//没有维护
	s usdoId=$o(^DHCPHUSDO(0,"Inst",instruId,""))  		//DHC_PHUsageDosage  用法用量表（业务表）
	q:usdoId="" -100
	
	s RetMsg=""	
	s useQtyInfo=""
	s useQtyFlag=0
	
	s libUseQtyMin=$p(^DHCPHUSDO(usdoId),"^",7)          
	s libUseQtyMax=$p(^DHCPHUSDO(usdoId),"^",8)
	s libUseQtyUomId=$p(^DHCPHUSDO(usdoId),"^",9)

	s titleMsg="每日用药总量"
	i (libUseQtyMin'="")||(libUseQtyMax'="") s useQtyFlag=1
	s hisUseQty=$p(hisDosQtyInfo,",",4)
	s hisUseQtyUomId=$p(hisDosQtyInfo,",",2)
	s arci=$p(hisDosQtyInfo,",",1)

	s useQtyInfo=libUseQtyMin_","_libUseQtyMax_","_libUseQtyUomId_","_useQtyFlag_","_hisUseQty_","_hisUseQtyUomId_","_titleMsg_","_arci

	s retMsg=..CheckUseQty(useQtyInfo,patWeight)
	
	s ret=$p(retMsg,"^",1)
	
	i ret=0 d
	.s RetMsg=$p(retMsg,"^",2)
	.i $d(^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)) d
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)_RetMsg
	.e  d	
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=RetMsg

	q ret
}

/// Description:	每日最大量
/// Creator:		QuNianpeng(重写)
/// CreateDate:		2017-08-04
/// Input:			目录索引id,药品剂量串,体重,返回值
/// return:			0 不通过  1 通过
/// other:			药品剂量串（医嘱项id,单位,单次用药量/单次最大量,每日最大量/每日总量,用药次数,首次用药量,连用量,间隔数）
ClassMethod CheckOneDayMaxQty(instruId As %String, hisDosQtyInfo As %String, patWeight As %String, ByRef RetMsg As %String) As %String
{
	n (instruId,hisDosQtyInfo,patWeight,RetMsg)
	
	q:instruId="" -100 	//没有维护	
	s usdoId=$o(^DHCPHUSDO(0,"Inst",instruId,""))  		//DHC_PHUsageDosage  用法用量表（业务表）
	q:usdoId="" -100

	s ret=1
	s useQtyFlag=0
	s libMaxUseQty=$p(^DHCPHUSDO(usdoId),"^",12)    
	s libMaxUseQtyId=$p(^DHCPHUSDO(usdoId),"^",13)
	q:(libMaxUseQty="")||(libMaxUseQtyId="") -100
	
	s changeFlag=0
	s titleMsg="每日最大量"
	i (libMaxUseQty'="") s useQtyFlag=1
	s hisMaxUseQty=$p(hisDosQtyInfo,",",4)				
	s hisMaxUseQtyId=$p(hisDosQtyInfo,",",2)
	s arci=$p(hisDosQtyInfo,",",1)						
	s hisMaxUseQtyDesc=$p(^CT("UOM",hisMaxUseQtyId),"^",2)

	//知识库中单位包含体重，则按照体重进行剂量计算
	s libMaxUseQtyCode=""
	s libMaxUseQtyDesc=""
	i libMaxUseQtyId'="" s libMaxUseQtyDesc=$p(^DHCPHEUO(libMaxUseQtyId),"^",2),libMaxUseQtyCode=$p(^DHCPHEUO(libMaxUseQtyId),"^",1)
	i (libMaxUseQtyDesc["/kg")&(patWeight="")  q 1	
	i (libMaxUseQtyDesc["/kg")&(useQtyFlag) d  
	.s libMaxUseQty=..ChangeUnit(libMaxUseQty,libMaxUseQtyId,hisMaxUseQtyId,patWeight)  
	.s changeFlag=1
	
	//用知识库中单位反向找到对照的his单位描述
	s libMaxUseQtyCode=$p(libMaxUseQtyCode,"/",1)
	s conHisMaxUseQtyCode=$o(^DHCPHUOCON(0,"Code",libMaxUseQtyCode,""))	//对照his单位code
	q:conHisMaxUseQtyCode="" -100	
	s conHisMaxUseQtyId=$o(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(conHisMaxUseQtyCode),""))  //对照his单位id
	s conHisMaxUseQtyDesc=$p(^CT("UOM",conHisMaxUseQtyId),"^",2)							//对照his单位描述

	//his中剂量单位和知识库中单位不相同时,将知识库的剂量转换为his剂量
	i (hisMaxUseQtyDesc'=conHisMaxUseQtyDesc)&(changeFlag=0) d
	.s hisFac=..GetBUomFac(arci,hisMaxUseQtyId)  	 //获取his的等效数量
	.s libFac=..GetBUomFac(arci,libMaxUseQtyId) 	//获取知识库对照his单位的等效数量	 	
	.s libMaxUseQty=libMaxUseQty/libFac*hisFac		//将知识库的剂量转换为his剂量

	//进行判断
	i ((hisMaxUseQty>libMaxUseQty)&(libMaxUseQty'="")) d
	.s ret=0
	
	i ret=0 d
	.s RetMsg=titleMsg_hisMaxUseQty_hisMaxUseQtyDesc_",超出限制范围"_libMaxUseQty_hisMaxUseQtyDesc_";"
	.i $d(^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)) d
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)_RetMsg
	.e  d	
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=RetMsg
	
	q ret
}

/// Description:	验证单次用药量/每日总量/首次用药量/连用量
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-04
/// Input:			类型,目录索引id,药品剂量串,体重,返回值
/// return:			0 不通过  1 通过
/// other:			药品剂量串（医嘱项id,单位,单次用药量/单次最大量,每日最大量/每日总量,用药次数,首次用药量,连用量,间隔数）
/// w ##class(web.DHCSTPHCMPASS).CheckUseQty(10287,"1043||1,10,149",50,.RetMsg)
ClassMethod CheckUseQty(useQtyInfo, patWeight) As %String
{
	n (useQtyInfo,patWeight)
	
	q:useQtyInfo="" -100

	s ret=1
	s retMsg=""
	s useQtyFlag=0
		
	s changeFlag=0							//剂量根据体重转换标志
	s libUseQtyMin=$p(useQtyInfo,",",1)		//知识库剂量
	s libUseQtyMax=$p(useQtyInfo,",",2)	
	s libUseQtyUomId=$p(useQtyInfo,",",3)	//知识库剂量单位
	s useQtyFlag=$p(useQtyInfo,",",4)		//知识库是否维护剂量标志 维护1 未维护0 
	s hisUseQty=$p(useQtyInfo,",",5)		//his剂量
	s hisUseQtyUomId=$p(useQtyInfo,",",6)	//his剂量单位
	s hisUseQtyUomDesc=$p(^CT("UOM",hisUseQtyUomId),"^",2)
	s titleMsg=$p(useQtyInfo,",",7)			//提示标题
	s arci=$p(useQtyInfo,",",8)		
	q:((libUseQtyMin="")&(libUseQtyMax=""))||(hisUseQty="") -100

	//知识库中单位包含体重，则按照体重进行剂量计算
	s libUseQtyUomCode=""
	s libUseQtyUomDesc=""
	i libUseQtyUomId'="" s libUseQtyUomDesc=$p(^DHCPHEUO(libUseQtyUomId),"^",2),libUseQtyUomCode=$p(^DHCPHEUO(libUseQtyUomId),"^",1)
	i (libUseQtyUomDesc["/kg")&(patWeight="")  q 1	
	i (libUseQtyUomDesc["/kg")&(useQtyFlag) d  
	.s libUseQtyMin=..ChangeUnit(libUseQtyMin,libUseQtyUomId,hisUseQtyUomId,patWeight)  
	.s libUseQtyMax=..ChangeUnit(libUseQtyMax,libUseQtyUomId,hisUseQtyUomId,patWeight)
	.s changeFlag=1

	//用知识库中单位反向找到对照的his单位描述
	s libUseQtyUomCode=$p(libUseQtyUomCode,"/",1)
	s conHisUseQtyUomCode=$o(^DHCPHUOCON(0,"Code",libUseQtyUomCode,""))					//对照his单位code
	q:conHisUseQtyUomCode="" -100
	s conHisUseQtyId=$o(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(conHisUseQtyUomCode),""))  //对照his单位id
	s conHisUseQtyUomDesc=$p(^CT("UOM",conHisUseQtyId),"^",2)							//对照his单位描述

	//his中剂量单位和知识库中单位不相同时,将知识库的剂量转换为his剂量
	i (hisUseQtyUomDesc'=conHisUseQtyUomDesc)&(changeFlag=0) d	//剂量根据体重转换后,不在进行等效数量转换(g,mg,l,ml)
	.s hisFac=..GetBUomFac(arci,hisUseQtyUomId)  	 			//获取his的等效数量
	.s libFac=..GetBUomFac(arci,libUseQtyUomId) 				//获取知识库对照his单位的等效数量
	.s libUseQtyMin=+(libUseQtyMin/libFac*hisFac) 				//将知识库的剂量转换为his剂量
	.s libUseQtyMax=+(libUseQtyMax/libFac*hisFac)

	q:(+libUseQtyMin=0)&(+libUseQtyMax=0) -100	

	//进行判断
	i (+libUseQtyMin'=0)&(+libUseQtyMax'=0) d
	.i (hisUseQty<libUseQtyMin)||(hisUseQty>libUseQtyMax) d
	..s ret=0
	i (+libUseQtyMin'=0)&(+libUseQtyMax=0) d						// 增加范围值只维护了某一个单边的判断 2018/7/23 qunianpeng
	.i (hisUseQty<libUseQtyMin)  d
	..s ret=0
	i (+libUseQtyMin=0)&(+libUseQtyMax'=0) d
	.i (hisUseQty>libUseQtyMax)  d
	..s ret=0

	i ret=0 s retMsg=titleMsg_hisUseQty_hisUseQtyUomDesc_",超出限制范围"_libUseQtyMin_"~"_libUseQtyMax_hisUseQtyUomDesc_";"

	q ret_"^"_retMsg
}

/// 验证间隔数（尚未启用）
ClassMethod CheckSpaceQty(LibSpaceQty, SpaceQty, ByRef RetMsg As %String) As %String
{
 
	n (LibSpaceQty, SpaceQty,RetMsg )
	s ret=0
	s min=$p(LibDurationQty,",",1)
	s max=$p(LibDurationQty,",",2)
	i (SpaceQty'>max)&(SpaceQty'<min) d
	.s ret=1
	q ret
}

/// Description:	审查给药途径列表
/// Creator:		QuNianpeng(修改、注释)
/// CreateDate:		2017-08-04
/// Input:			目录主索引id,用法code,返回信息
/// return:			0 不通过  1 通过
/// other:			
ClassMethod CheckUseList(instruId, instCode, instType, libGenDr, pointer, pid, ByRef RetMsg As %String) As %String
{
	n (instruId, instCode, instType, libGenDr, pointer, pid, RetMsg)

	s RetMsg="",ret=1
	q:instCode="" -100 												// 没有维护
	s instDr=$o(^PHCIN(0,"Code",$$ALPHAUP^SSUTIL4(instCode),""))	// his用法id
	q:$g(instDr)="" -100
	s instDesc=$p(^PHCIN(instDr),"^",2)								// his用法描述	
	s conInstId=$o(^DHCPHINSTCON(0,"HisCode",instCode,"")) 			// 用法对照表id DHC_PHInstContrast
	q:conInstId="" -100
	i conInstId'="" s libInstCode=$p(^DHCPHINSTCON(conInstId),"^",1)	// 知识库用法代码

	// 用法业务表
	s tmpInstDisId=$o(^DHCPHDISUSE(0,"Inst",instruId,""))
	s tmpInstDr=$p(^DHCPHDISUSE(tmpInstDisId),"^",2)	
	s tmpInstCode=$p(^DHCPHEINSTR(tmpInstDr),"^",1)		

	// his给药途径不在知识库给药途径列表 忽略	
	q:$d(^TMP("DHCST","web.DHCSTPHCMPASS","CheckUseList",pid,"HasXxist")) -100
	s retflag=0
	i $d(^TMP("DHCST","web.DHCSTPHCMPASS","CheckUseList",pid,instType,libGenDr,"PreMet",libInstCode,instruId)) d
	.s retflag=1
	e  d
	.s retflag=0
	q:retflag=1 0

	i libInstCode=tmpInstCode d
	.s excflag=$p(^DHCPHDISUSE(tmpInstDisId),"^",3)   
	.s:excflag="Y" ret=-1											// 是否禁用
	.s:excflag="Y" ^TMP("DHCST","web.DHCSTPHCMPASS","CheckUseList",pid,instType,libGenDr,"PreMet",libInstCode)=""
	e  d
	.s:instType="ProName" pointer=0
	.s ifFlag=0,tmpInstruId=""										// 0不在给药途径列表中  1在给药途径列表中
	.s instLabel=$o(^DHCPHPINL("0","Code",$ZCVT("PreMet","U"),""))
	.f  s tmpInstruId=$o(^DHCPHINSTRUC("0","TGP",instLabel,libGenDr,instType,pointer,tmpInstruId)) q:(tmpInstruId="")  d
	..s instDisId=$o(^DHCPHDISUSE(0,"Inst",tmpInstruId,""))
	..s instDisDr=$p(^DHCPHDISUSE(instDisId),"^",2)	
	..q:instDisDr="" 
	..s instCode=$p(^DHCPHEINSTR(instDisDr),"^",1)		
	..i libInstCode=instCode d
	...s ifFlag=1 	
	...s tmpExcflag=$p(^DHCPHDISUSE(instDisId),"^",3)   
	...s:tmpExcflag="Y" ret=-1	
	...s:tmpExcflag="Y" ^TMP("DHCST","web.DHCSTPHCMPASS","CheckUseList",pid,instType,libGenDr,"PreMet",libInstCode,tmpInstruId)=""												
	..q:ifFlag=1
	.i ifFlag=0 d
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CheckUseList",pid,"HasXxist")=""	//记录his用法不在列表中
	..//s ^TMP("DHCST","web.DHCSTPHCMPASS","CheckUseList",pid,instType,libGenDr,"PreMet",libInstCode)=""  
	..s ret=-2

	s RetMsg=$Case(ret,0:instDesc_",此用法禁用;","-1":instDesc_",此用法禁用;",-2:instDesc_",无此用法;",:"")
	//s ret=$Case(ret,-1:0,-2:0,0:0,:1)	
	i $d(^TMP("DHCST","web.DHCSTPHCMPASS","CheckUseList",pid,instType,libGenDr,"PreMet",libInstCode)) d
	.s tmpInstruId=$o(^TMP("DHCST","web.DHCSTPHCMPASS","CheckUseList",pid,instType,libGenDr,"PreMet",libInstCode,""))
	.s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=RetMsg
	.s ret=0
	i $d(^TMP("DHCST","web.DHCSTPHCMPASS","CheckUseList",pid,"HasXxist")) d
	.s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=RetMsg
	.s ret=0

	q ret
}

/// Description:	审查用药频率列表
/// Creator:		QuNianpeng(修改、注释)
/// CreateDate:		2017-08-04
/// Input:			目录主索引id,用法code,商品/通用名类型,商品名/通用名,剂型，返回信息
/// return:			0 不通过  1 通过
/// other:
ClassMethod CheckFreqList(instruId, freqCode, instType, libGenDr, pointer, pid, ByRef RetMsg As %String) As %String
{
	n (instruId,freqCode,instType, libGenDr, pointer,pid,RetMsg)

	s RetMsg="",ret=1 
	q:freqCode="" -100
	s freqDr=$o(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4(freqCode),""))  	// his频率
	q:$g(freqDr)="" -100
	s freqDesc=$p(^PHCFR(freqDr),"^",3)	
	s confreqId=$o(^DHCPHFRCON(0,"HisCode",freqCode,""))		    // 频率对照表id DHC_PHFreqContrast
	q:confreqId="" -100 											// 没对照(则默认通过)
	i confreqId'="" s libFreqCode=$p(^DHCPHFRCON(confreqId),"^",1)	// 知识库频率代码
	// his用药频率不在知识库频率列表  或者在列表且有禁忌标识,则不继续审查其他记录  忽略
	//q:$d(^TMP("DHCST","web.DHCSTPHCMPASS","CheckFreqList",pid,instType,libGenDr,"Freq",freqCode)) 0
	
	// 频率业务表
	s tmpFreqDisId=$o(^DHCPHDISFR(0,"Inst",instruId,""))
	s tmpFreqDr=$p(^DHCPHDISFR(tmpFreqDisId),"^",2)
	s tmpFreqCode=$p(^DHCPHEFR(tmpFreqDr),"^",1)
	
	i libFreqCode=tmpFreqCode d
	.s excflag=$p(^DHCPHDISFR(tmpFreqDisId),"^",3)   
	.s:excflag="Y" ret=-1											// 是否禁用
	.s:excflag="Y" ^TMP("DHCST","web.DHCSTPHCMPASS","CheckFreqList",pid,"Taboo",instruId)=""
	.s ^TMP("DHCST","web.DHCSTPHCMPASS","CheckFreqList",pid,instType,libGenDr,"Freq",libFreqCode)=""
	e  d
	.s:instType="ProName" pointer=0
	.s ifFlag=0,tmpInstruId=""										// 0不在频率列表中  1在频率列表中
	.s instLabel=$o(^DHCPHPINL("0","Code",$ZCVT("Freq","U"),""))
	.f  s tmpInstruId=$o(^DHCPHINSTRUC("0","TGP",instLabel,libGenDr,instType,pointer,tmpInstruId)) q:(tmpInstruId="")||(ifFlag=1)  d
	..s freqDisId=$o(^DHCPHDISFR(0,"Inst",tmpInstruId,""))
	..s freqDisDr=$p(^DHCPHDISFR(freqDisId),"^",2)
	..q:freqDisDr=""
	..s freqDisCode=$p(^DHCPHEFR(freqDisDr),"^",1)
	..i libFreqCode=freqDisCode d
	...s ifFlag=1 	
	...s tmpExcflag=$p(^DHCPHDISFR(freqDisId),"^",3)   
	...s:tmpExcflag="Y" ret=-1	
	...s:tmpExcflag="Y" ^TMP("DHCST","web.DHCSTPHCMPASS","CheckFreqList",pid,"Taboo",tmpInstruId)=""
	...s ^TMP("DHCST","web.DHCSTPHCMPASS","CheckFreqList",pid,instType,libGenDr,"Freq",libFreqCode)=""
	..q:ifFlag=1
	.i ifFlag=0 d
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CheckFreqList",pid,instType,libGenDr,"Freq",libFreqCode)=""  //记录不his频率不在列表中
	..s ret=-2

	s RetMsg=$Case(ret,0:freqDesc_",此频率禁用;","-1":freqDesc_",此频率禁用;",-2:freqDesc_",无此频率;",:"")
	s ret=$Case(ret,-1:-1,-2:0,0:0,:1)

	i (ret=0)||(ret=-1) d
	.i $d(^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)) d
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)_RetMsg
	.e  d
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=RetMsg
	
	i ret=-1 s ret=1
	q ret
}

/// Description:	审查适应症是否存在
/// Creator:		QuNianpeng(重写)
/// CreateDate:		2017-08-04
/// Input:			目录主索引id,诊断信息串
/// return:			0 不通过  1 通过 -100没有维护数据
/// other:
ClassMethod CheckIndication(instruId, patIcd, ByRef RetMsg As %String) As %String
{
	n (instruId,patIcd,RetMsg)

	q:(instruId="")||(patIcd="") -100 	//没有维护
	s RetMsg=""
	s ret=..CheckDiseaCommon(instruId,patIcd)
	
	i ret=0 s RetMsg="超适应症"

	q ret
}

/// Description:	检查禁忌症是否存在
/// Creator:		QuNianpeng(重写)
/// CreateDate:		2017-08-04
/// Input:			目录主索引id,诊断信息串
/// return:			0 不通过  1 通过 -100没有维护数据
/// other：
ClassMethod CheckContra(instruId, patIcd, ByRef RetMsg As %String) As %String
{
	n (instruId,patIcd,RetMsg)
	q:(instruId="")||(patIcd="") -100 	//没有维护
	s RetMsg=""

	s ret=..CheckDiseaCommon(instruId,patIcd)

	i ret=0 s RetMsg="病症禁忌"

	q ret
}

/// Description:	检查病症是否存在
/// Creator:		QuNianpeng(重写)
/// CreateDate:		2017-08-04
/// Input:			目录主索引id,诊断信息串
/// return:			0 不通过  1 通过 -100没有维护数据
/// other:
ClassMethod CheckDisea(instruId, patIcd, ByRef RetMsg As %String) As %String
{
	n (instruId,patIcd,RetMsg)
	q:(instruId="")||(patIcd="") -100 	//没有维护
	s RetMsg=""
	s ret=..CheckDiseaCommon(instruId,patIcd)
	
	i ret=0 s RetMsg=""
	
	q ret
}

/// Description:	审查禁忌症、适应症、病症是否存在公共部分
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-04
/// Input:			目录主索引id,诊断信息串
/// return:			0 不通过  1 通过 -100没有维护数据
/// other:			(禁忌症、适应症、病症 均是对关联的诊断进行匹配,因此提取公共方法）
ClassMethod CheckDiseaCommon(instruId As %String, patIcd As %String) As %String
{
	n (instruId,patIcd)

	s conFlag=0
	s chkIndPid=##class(web.DHCSTPHCMADDEXTLIB).NewPid() 
	q:(instruId="")||(patIcd="") -100  //没有维护

	s cnt=$l(patIcd,",")
	
	f len=1:1:cnt d
	.s hisIcdCode=$p(patIcd,",",len)
	.q:hisIcdCode=""
	.i '$d(^DHCEXTICON(0,"HisCode",hisIcdCode)) d	// his中维护非icd诊断,通过诊断关键字找到知识库的诊断代码 2018/8/9
	..s tmpICDKey=""  f  s tmpICDKey=$o(^DHCEXTICDK(tmpICDKey))  q:tmpICDKey=""  d
	...s ICDText=$p(^DHCEXTICDK(tmpICDKey),"^",2)
	...i (ICDText=hisIcdCode) d
	....s tmpIcdDr=$p(^DHCEXTICDK(tmpICDKey),"^",1)
	....s tmpIcdCode=$p($g(^DHCEXTICD(tmpIcdDr)),"^",1)
	....s ^TMP("DHCST","DHCSTPHCMPASS","CheckIndication",chkIndPid,"Icd",tmpIcdCode)=""
	....s conFlag=1
	.e  d	
	..s conIcdDr=""
	..f  s conIcdDr=$o(^DHCEXTICON(0,"HisCode",hisIcdCode,conIcdDr)) q:conIcdDr=""  d		//诊断对照 DHC_ExtIcdContrast
	...s libIcdCode=$p(^DHCEXTICON(conIcdDr),"^",1)		//知识库诊断代码 libcode	
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckIndication",chkIndPid,"Icd",libIcdCode)=""
	...s conFlag=1

	q:conFlag=0 -100 //没对照
	
	s ret=0
	s conFlag=0
	s disId=""
	f  s disId=$o(^DHCPHDDIS(0,"Inst",instruId,disId)) q:(disId="")||(ret=1)  d  //病症业务表 DHC_PHDrugDisease
	.//s conFlag=1
	.s sub=""
	.s diseaDr=$p(^DHCPHDDIS(disId),"^",3)						//知识库病症表id  DHC_PHDiseaseList
	.q:diseaDr=""
	.s conFlag=1
	.f  s sub=$o(^DHCPHDISL(diseaDr,"ICD",sub)) q:sub=""  d		//知识库病症诊断关联 DHC_PHDiseaseItmList
	..s tmpIcd=$p(^DHCPHDISL(diseaDr,"ICD",sub),"^",1)			//知识库诊断id
	..q:tmpIcd=""
	..s tmpIcdCode=$p(^DHCEXTICD(tmpIcd),"^",1)				
	..i $d(^TMP("DHCST","DHCSTPHCMPASS","CheckIndication",chkIndPid,"Icd",tmpIcdCode)) d
	...s ret=1
	
	k ^TMP("DHCST","DHCSTPHCMPASS","CheckIndication",chkIndPid,"Icd")

	q:conFlag=0 -100 //没有维护
	
	q ret
}

/// Description:	审查年龄
/// Creator:		QuNianpeng(修改、注释)
/// CreateDate:		2017-08-04
/// Input:			目录主索引id,his年龄,返回信息
/// return:			0 不通过  1 通过 -100没有维护数据
/// other:			
ClassMethod CheckPatAge(instruId, patAge, ByRef RetMsg As %String) As %String
{
	n (instruId,patAge,RetMsg)

	q:(instruId="")||(patAge="") -100	//没有维护
	q:'$d(^DHCPHDISAGE(0,"Inst",instruId)) -100
	s ageYears=+$p(patAge,"|",1)	//patAge x岁y月z天
	s ageMonths=+$p(patAge,"|",2)
	s ageDays=+$p(patAge,"|",3)	
	s RetMsg=""
	s exit=0
	s ret=1

	s libDisAgeDr=$o(^DHCPHDISAGE(0,"Inst",instruId,""))	//年龄业务表 DHC_PHDiseaseAge
	s libAgeMin=$p(^DHCPHDISAGE(libDisAgeDr),"^",3)
	s libAgeMax=$p(^DHCPHDISAGE(libDisAgeDr),"^",4)
	s libAgeUomDr=$p(^DHCPHDISAGE(libDisAgeDr),"^",5)		
	//s libAgeListDr=$p(^DHCPHDISAGE(libDisAgeDr),"^",3)	    //从年龄字典表中取单位
	//s libAgeUomDr=$p(^DHCPHPAGEL(libAgeListDr),"^",7)

	q:(+libAgeUomDr=0)||((libAgeMin="")&(libAgeMax="")) -100   //-100没有维护

	s libAgeUomDesc=$p(^DHCPHEUO(libAgeUomDr),"^",2)
	i (libAgeUomDesc="日")||(libAgeUomDesc="月") d
	.i (ageYears>0)&(libAgeMin'="") s exit=1
	.i (ageYears>0)&(libAgeMax'="") s exit=1
	.q:exit=1
	.i (ageYears=0)&(libAgeUomDesc="月") d
	..i (libAgeMin'="")&(libAgeMin>ageMonths) s ret=0,exit=1  
	..i (libAgeMax'="")&(libAgeMax<ageMonths) s ret=0,exit=1
	..q:exit=1
	..;	 
	..i (ageYears=0)&(ageMonths=0)&(libAgeUomDesc="日") d
	...i (libAgeMin'="")&(libAgeMin>ageDays) s ret=0,exit=1 
	...i (libAgeMax'="")&(libAgeMax<ageDays) s ret=0,exit=1 
	..
	.

	i exit=0 d
	.i ((ageYears>libAgeMax)&(libAgeMax'=""))||((ageYears<libAgeMin)&(libAgeMin'="")) s ret=0
	e  d
	.s ret=0
	
    i ret=0 d 
    .s RetMsg="年龄不在限制范围;"
    .i $d(^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)) d
    ..i $g(^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId))["频率禁用" k ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)
	..i '$g(^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId))["无此频率"  d
	...s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=$g(^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId))_RetMsg
	.e  d
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=RetMsg
	
	q ret
}

/// Description:	审查性别
/// Creator:		QuNianpeng(修改、注释)
/// CreateDate:		2017-08-04
/// Input:			目录主索引id,his性别,返回信息
/// return:			0 不通过  1 通过 -100没有维护数据
/// other:
ClassMethod CheckPatSex(patSex, instruId, ByRef RetMsg As %String) As %String
{
	n (patSex,instruId,RetMsg)
	q:(patSex="")||(instruId="") -100				// 没有维护
	
	s RetMsg=""
	s ret=1
	s libSex=$p(^DHCPHINSTRUC(instruId),"^",9) 	   // 性别
	
	q:(libSex="A")||(libSex="") -100		       // F女 M男 A全部
	
	i libSex'=patSex s ret=0,RetMsg="性别不符"

	i ret=0 d
	.i $d(^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)) d
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)_RetMsg
	.e  d
	..s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=RetMsg

	q ret
}

/// Description:	审查体重
/// Creator:		QuNianpeng(修改、注释)
/// CreateDate:		2017-08-04
/// Input:			目录主索引id,his体重,返回信息
/// return:			0 不通过  1 通过 -100没有维护数据
/// other:
ClassMethod CheckPatWeight(instruId, patWeight, ByRef RetMsg As %String) As %String
{
	n (instruId,patWeight)
	s RetMsg=""

	q:(instruId="")&(patWeight="") -100
	s usdoId=$o(^DHCPHUSDO(0,"Inst",instruId,""))  //DHC_PHUsageDosage  用法用量表（业务表）
	q:usdoId="" -100

	//s libWeightMin=$p(^DHCPHINSTRUC(instruId),"^",23)
	//s libWeightMax=$p(^DHCPHINSTRUC(instruId),"^",24)
	s libWeightMin=$p(^DHCPHUSDO(usdoId),"^",23)	//体重
	s libWeightMax=$p(^DHCPHUSDO(usdoId),"^",24)		
	
	q:(libWeightMin="")&(libWeightMax="") -100
	
	s ret=1
	i ((patWeight<libWeightMin)&(libWeightMin'=""))|| ((patWeight>libWeightMax)&(libWeightMax'="")) d
	.s RetMsg="体重不符"
	.s ret=0

	q ret
}

/// Description:	审查用法
/// Creator:		(QuNianpeng 修改)
/// CreateDate:		2017-08-09
/// Input:			主索引表id,his用法code,返回信息
/// return:			1通过 0不通过
/// other:			
ClassMethod CheckDisUse(instruId, instCode, ByRef RetMsg As %String) As %String
{
	n (instruId,instCode,RetMsg)
	q:(instCode="")||(instruId="") -100

	s RetMsg=""
	s ret=-100
	s useDisDr=$o(^DHCPHDISUSE(0,"Inst",instruId,""))	//DHC_PHDiseaseUse 用法业务表
	q:useDisDr="" -100
	
	s useId=$p(^DHCPHDISUSE(useDisDr),"^",2)			//知识库用法字典表id
	q:useId="" -100
	s libInstCode=$p(^DHCPHEINSTR(useId),"^",1)			//知识库用法描述

	s conUseId=""
	f conUseId=$o(^DHCPHINSTCON(0,"HisCode",instCode,conUseId)) q:(conUseId="")||(ret=1)  d
	.s tmpInstCode=$p(^DHCPHINSTCON(conUseId),"^",1)  	//his用法对照的知识库用法
	.i tmpInstCode=libInstCode d
	..s ret=1
	.i tmpInstCode'=libInstCode d
	..s ret=0

	q ret
}

/// Description:	审查溶媒量
/// Creator:		(QuNianpeng 修改)
/// CreateDate:		2017-08-05
/// Input:			进程号,医嘱项信息串,当前检查医嘱项信息,主索引表id,返回信息
/// return:			1通过 0不通过
/// other:			hisOrditm组成:医嘱项ID^用法ID^频次ID^剂量^剂量单位^总量^总量单位^疗程ID^关联号^标本^部位^接受科室ID^医嘱ID
/// 				关联号组成 seqno：以$c(1)分割 第一位是关联医嘱标志  1是 0否；第二位医嘱序号 如：主医嘱是1 则子医嘱分别是1.2 1.3
/// w ##class(web.DHCSTPHCMPASS).CheckMentsQtyNew()
ClassMethod CheckMentsQtyNew(pid, ordStr, hisOrdItm, instruId, ByRef RetMsg As %String) As %String
{
	
	n (pid,ordStr,hisOrdItm,instruId,RetMsg)

	s instid=$p(hisOrdItm,"^",2)
	s instDesc=""
	i instid'="" s instCode=$p(^PHCIN(instid),"^",1),instDesc=$p(^PHCIN(instid),"^",2)  //暂时不判断输液用法为空
	;q:'(instDesc["静滴")||(instid="") 1
	q:(instid="") -100
	
	//判断医嘱是否关联医嘱
	s seqno=$p(hisOrdItm,"^",9)  
	s groupOrdFlag=$p(seqno,$c(1),1) //医嘱是否是关联医嘱
	s oeoriNo=$p(seqno,$c(1),2)      //开立医嘱序号 如：主医嘱是1 则子医嘱分别是1.2 1.3
	q:groupOrdFlag=0 -100		    //溶媒量检查只针对成组关联医嘱

	//判断溶质是否有关联溶媒		
	s phmqDr=$o(^DHCPHMQ(0,"Inst",instruId,""))	 //溶媒业务表 DHC_PHMenstruumQty
	q:phmqDr="" -100

	//取溶质的通用名/商品名
	s tmpArci=$p(hisOrdItm,"^",1)
	s tmpSub=$p(tmpArci,"||",1)
	s tmpVer=$p(tmpArci,"||",2)	 
	s phcdf=$p(^ARCIM(tmpSub,tmpVer,1),"^",12) 
    s genenDr=+$p($g(^PHCD(+phcdf,4)),"^",1)		//his通用名id
    s geneCode=$p($g(^PHCGE("GE",genenDr)),"^",1) 	//his通用名code
    s genenDesc=$p($g(^PHCGE("GE",genenDr)),"^",2)  
    //q:geneCode="" -100
    //q:$o(^DHCPHGENCON(0,"HisCode",geneCode,""))="" -100 //无对照

    s hisProCode=$P(^ARCIM(+tmpSub,tmpVer,1),"^",1)  		//his商品名code
    s conProDr=$o(^DHCPHPCO(0,"HisCode",hisProCode,"")) 	//商品名对照表id
    q:conProDr="" -100										//商品名对照
    s libProCode=$p(^DHCPHPCO(conProDr),"^",1)				
    s libProId=+$o(^DHCPHPNA(0,"Code",$ZCONVERT(libProCode,"U"),"")) //商品名id(知识库)
    q:libProId=0 -100

	// 获取药品在编辑器中关联的溶媒分类和上下值
    s instCatDr=$p(^DHCPHMQ(phmqDr),"^",2)   	//溶媒分类
    s qtyMin=$p($g(^DHCPHMQ(phmqDr)),"^",3)      //最小值
    s qtyMax=$p($g(^DHCPHMQ(phmqDr)),"^",4)		 //最大值
    s qtyUomDr=$p($g(^DHCPHMQ(phmqDr)),"^",5)    //单位
    s qtyUomDesc=""
    s:qtyUomDr'="" qtyUomDesc=$P($g(^DHCPHEUO(qtyUomDr)),"^",2)  //知识库单位描述
   	q:(instCatDr="")||((qtyMin="")&(qtyMax=""))||(qtyUomDr="") -100

    //将his医嘱项ID串根据关联成组情况，用临时global暂存起来
    i '$d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"MentsQty")) d
	.s arrcnt=$l(ordStr,$c(2))
	.f i=1:1:arrcnt d
	..s itmStr=$p(ordStr,$c(2),i)
	..s seqNo=$p($p(itmStr,"^",9),$c(1),2)			//医嘱序号
	..s oeori=$p(itmStr,"^",1)_","_seqNo_","_$p(itmStr,"^",13)
	..s moeori=..GetOrdStrMainOeori(ordStr,itmStr)  //主医嘱医嘱项id,主序号,主医嘱id
	..q:moeori=""
	..s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"MentsQty",moeori,oeori)=itmStr 
	..
	.
	q:'$d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"MentsQty")) -100

	// 遍历溶质对应的所有的溶媒分类，并暂时存起来。用于判断溶媒是否在溶质对应的分类中
	s instType="ProName"
	s labelDr=""
	f  s labelDr=$o(^DHCPHINSTRUC(0,"TGP",labelDr)) q:labelDr=""  d
	.s tmpInstruId=""
	.f  s tmpInstruId=$o(^DHCPHINSTRUC(0,"TGP",labelDr,libProId,instType,0,tmpInstruId)) q:tmpInstruId=""  d	
	..s tmpPhmqDr=$o(^DHCPHMQ(0,"Inst",tmpInstruId,""))
	..q:tmpPhmqDr=""
	..s:tmpPhmqDr'="" tmpPhCaDdr=$p(^DHCPHMQ(tmpPhmqDr),"^",2)  //溶媒分类字典表
	..s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"checkphmqdr",tmpPhCaDdr)=""	
	..

	//遍历存储医嘱项ID串的临时global,找到溶质对应的溶媒,并和知识库中的溶媒进行比较
	s existflag=0
	s ret=-100
	s hisLinkArci=""      //记录his溶媒的医嘱项
	s hisLinkSeqNo=""     //his溶媒医嘱序号
	s hisLinkOeori=""  	  //记录his溶媒的医嘱ID
	s hisLinkArciQty=""   //记录his溶媒的剂量
	;s linkArciDesc=""    //记录his溶媒医嘱项描述
	s libLinkProDesc=""
	s isInclueLinkOeir=1

	s hisMoeori=..GetOrdStrMainOeori(ordStr,hisOrdItm)  // 获取医嘱项串的关联医嘱，主医嘱项ID
	s tmpoe=""
	f  s tmpoe=$O(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"MentsQty",hisMoeori,tmpoe)) Q:(tmpoe="")||(ret=0)  d	
	.s arci=$p(hisOrdItm,"^",1)
	.s seqNo=$p($p(hisOrdItm,"^",9),$c(1),2)
	.s oeori=$p(hisOrdItm,"^",13)
	.s tmpOeori=arci_","_seqNo_","_oeori
	.q:tmpOeori=tmpoe				//只对成组中的溶媒进行判断	
	.
	.s linkArci=$p(tmpoe,",",1)		//溶媒医嘱项(医嘱码表)ID
	.s doseQty=""   //剂量
    .s doseUomDr="" //剂量单位
	.s sub=$p(linkArci,"||",1),ver=$p(linkArci,"||",2)	
	.;s ItemCatDr=""
	.s hisLinkProCode=""
	.;i +sub'=0 s ItemCatDr=$P(^ARCIM(+sub,ver,1),"^",10)
	.i +sub'=0 s hisLinkProCode=$P(^ARCIM(+sub,ver,1),"^",1)			
	.s conLinkProDr=$o(^DHCPHPCO(0,"HisCode",hisLinkProCode,""))
    .q:conLinkProDr="" 	//溶媒商品名是否对照    .
    .i conLinkProDr'="" s libLinkProCode=$p(^DHCPHPCO(conLinkProDr),"^",1)
    .s libLinkProId=+$o(^DHCPHPNA(0,"Code",$$UPPER^SSUTIL4(libLinkProCode),""))		//溶媒 商品名id
    .q:libLinkProId=0
    .
    .s libLinkProDesc=$p(^DHCPHPNA(libLinkProId),"^",2)				//溶媒描述
    .s libLinkProCatDr=..GetPhMentDr(libLinkProId)					//获取溶媒的商品名是归属于哪个溶媒分类 返回值是空 或者是溶媒分类ID
    .q:libLinkProCatDr="" 								 
	.
	.//(入参his)取溶媒医嘱id,医嘱序号,剂量,计量单位,描述
	.s hisLinkOeori=$p(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"MentsQty",hisMoeori,tmpoe),"^",13) 				// 溶媒医嘱ID
	.s hisLinkSeqNo=$p($p(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"MentsQty",hisMoeori,tmpoe),"^",9),$c(1),2) 	//溶媒的医嘱序号
	.s hisLinkArciQty=$p(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"MentsQty",hisMoeori,tmpoe),"^",4) 				//溶媒剂量
	.s hisLinkDoseUomDr=$p(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"MentsQty",hisMoeori,tmpoe),"^",5)  			//溶媒剂量单位
	.s hisLinkDoseUomDesc=$p(^CT("UOM",hisLinkDoseUomDr),"^",2)  //取单位描述
	.
	.//溶媒对应分类Id 不在溶质对应溶媒分类Id组中
	.s isInclueLinkOeir=$d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"checkphmqdr",libLinkProCatDr)) 
    .s:(libLinkProCatDr'=instCatDr)&(isInclueLinkOeir=0) ret=0  
  	.q:libLinkProCatDr'=instCatDr    
    .s existflag=1
 	.
    .//若知识库中溶媒剂量单位和his中溶媒剂量单位不同，则进行转换    
    .s hisQtyAndUomDr=hisLinkArciQty_"^"_hisLinkDoseUomDr
    .s:hisLinkDoseUomDesc'=qtyUomDesc hisLinkArciQty=..GetDosageFactorNew(linkArci,hisQtyAndUomDr,qtyUomDesc) 
    .s:hisLinkArciQty="" ret=1 
    .q:hisLinkArciQty=""
    .
    .//跟知识库溶媒进行比较
    .i ((qtyMin'="")&(hisLinkArciQty<qtyMin))||((qtyMax'="")&(hisLinkArciQty>qtyMax))  d
    ..s ret=0      
	.
	//溶媒的返回信息 医嘱项ID-序号-医嘱ID
	s oeoriMeg=""
	i ret=0 d
	.s linkOeoriMsg=linkArci_"-"_hisLinkSeqNo_"-"_hisLinkOeori
	.i existflag=0 d
	..s:isInclueLinkOeir=0 oeoriMeg=linkOeoriMsg_"$"_genenDesc_"溶媒不可选择"_libLinkProDesc   //溶媒溶质不匹配
	.
	.s:existflag=1 oeoriMeg=linkOeoriMsg_"$"_hisLinkArciQty_qtyUomDesc_libLinkProDesc_"溶媒剂量与说明书剂量不符"  // 溶媒溶质匹配,但是剂量不对

    i (ret=0)&(existflag=1) d   // 有药品，但剂量不对
    .s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"TmpMsg",instruId)=1_"^"_oeoriMeg
       
    i (ret=0)&(existflag=0) d  //  无药品数据
    .s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"TmpMsg",instruId)=0_"^"_oeoriMeg    

	q ret
}

/// 验证过敏史
/// return：1有过敏史 0 无过敏史
/// ##class(web.DHCSTPHCMPASS).CheckPatAllergy(InstruId,pid,.RetMsg)
ClassMethod CheckPatAllergy(instruId, pid, ByRef RetMsg As %String) As %String
{
	n (instruId,pid,RetMsg)
	k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"allgykey")  //记录是否存在过敏史 初始化 qnp
	s RetMsg=""

	s ret=0
	s alli=""
	f  s alli=$o(^DHCLIBALLI(0,"Inst",instruId,alli)) q:(alli="")||(ret=1)  d	//DHC_LibAllergyItm 过敏史业务表
	.s allgydr=$p(^DHCLIBALLI(alli),"^",2)
	.q:allgydr=""
	.q:'$d(^DHCALLERGY(allgydr))
	.s allgy=$p(^DHCALLERGY(allgydr),"^",2)         
	.q:allgy=""
	.s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"allgykey",allgy)=""
	.s tmpkey=""
	.f  s tmpkey=$o(^DHCALLGYKEYi(0,"Key",allgydr,tmpkey)) q:tmpkey=""  d		//DHC_AllergyKey 过敏史关键字
	..s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"allgykey",tmpkey)=""
	
	q:'$D(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"allgykey")) -100
    
	s exist=0
	s algdesc=""
	f  s algdesc=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"allgy",algdesc)) q:(algdesc="")||(exist=1)  d
	.s tmpkey=""
	.f  s tmpkey=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"allgykey",tmpkey)) q:tmpkey=""  d
	..i algdesc[tmpkey d
	...s exist=1
	...s ret=1
	...i ret=1 s RetMsg="存在过敏史:"_allgy
	
	q:exist=0 -100
	
	q ret
}

/// 验证成分
ClassMethod CheckIngr(InstruId, IngrId, ByRef RetMsg As %String) As %String
{
	s ret=0
	s ingrdr=""
	f  s ingrdr=$o(^DHCPHINI(0,"Inst",InstruId,ingrdr)) q:(ingrdr="")||(ret=1)  d
	.i ingrdr=IngrId d
	..s ret=1
	q 0
}

/// 验证分类
ClassMethod CheckImtCat(InstruId, catId, ByRef RetMsg As %String) As %String
{
	n (instruId,catId,RetMsg)
	s ret=0
	s catdr=""
	f  s catdr=$o(^DHCLIBCATI(0,"Inst",instruId,ingrdr)) q:(catdr="")||(ret=1)  d
	.i catdr=catId d
	..s ret=1
	q 0
}

/// 检查是否更年期妇女
ClassMethod CheckPatclimac(LibPatclimac, Patclimac, ByRef RetMsg As %String) As %String
{
	n (LibPatclimac, Patclimac,RetMsg)
	s RetMsg=""
	q:LibPatclimac="" -100
	q:(LibPatclimac'="")&(Patclimac="Y") 1
	q 0
}

/// 检查是否更经期
ClassMethod CheckPatmens(LibPatmens, Patmens, ByRef RetMsg As %String) As %String
{
	n (LibPatmens, Patmens,RetMsg)
	s RetMsg=""
	q:LibPatmens="" -100
	q:(LibPatmens'="")&(Patmens="Y") 1
	q 0
}

/// 检查是否哺乳期
ClassMethod CheckPatlac(LibPatlac, Patlac, ByRef RetMsg As %String) As %String
{
	n (LibPatlac, Patlac,RetMsg)
    s RetMsg=""
	q:LibPatlac="" -100
	q:(LibPatlac'="")&(Patlac="Y") 1
	q 0
}

/// 检查是否孕妇
ClassMethod CheckPatpre(LibPatpre, Patpre, ByRef RetMsg As %String) As %String
{
	n (LibPatpre, Patpre,RetMsg)
    s RetMsg=""
	//i (LibPatpre="")||(Patpre'="Y") q 1
	//q:(LibPatpre=Patpre)&(Patpre="Y") 1
    
	//w !,LibPatpre_","_Patpre
	q:LibPatpre="" -100  //表示没有维护忽略
	q:(LibPatpre'="")&(Patpre="Y") 1
	
	q 0
}

ClassMethod CheckPatpre1(mradm, InstruId, ByRef RetMsg As %String) As %String
{
	n (mradm, InstruId,RetMsg)
   
    s adminfo=$P($g(^MR(mradm,"DHC")),"^",8)
    q:adminfo="" 0
    s flag=0
    s speppi=""
    f  s specinfo=$o(^DHCLIBSPEPI(0,"Inst",InstruId,speppi)) q:speppi=""  d
	.s tmpsepc=$p(^DHCSPEP(speppi),"^",2)
	.s tmpsepc=$e(tmpsepc,1)
	.i adminfo[tmpsepc  s flag=1

	q:flag=1 1

	q 0
}

/// 检查是否肝功能不全
ClassMethod CheckPatliver(LibPatliver, Patliver, ByRef RetMsg As %String) As %String
{
	n (LibPatliver, Patliver,RetMsg)
	s RetMsg=""
	q:LibPatliver="" -100
	q:(LibPatliver'="")&(Patliver="Y") 1
	q 0
}

/// 检查是否肾功能不全
ClassMethod CheckPatren(LibPatren, Patren, ByRef RetMsg As %String) As %String
{
	n (LibPatren, Patren,RetMsg)
	s RetMsg=""
	q:LibPatren="" -100
	q:(LibPatren'="")&(Patren="Y") 1
	q 0
}

/// 检查是否计划妊娠
ClassMethod CheckPatPlan(LibPatPlan, PatPlan, ByRef RetMsg As %String) As %String
{
	n (LibPatPlan, PatPlan,RetMsg)
	s RetMsg=""
	Q:LibPatPlan="" -100
	q:(LibPatPlan'="")&(PatPlan="Y") 1
	q 0
}

/// Description:	获取界面传递过来未提交医嘱串中的主医嘱的医嘱项(医嘱码表)ID
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-05
/// Input:			医嘱项串,要确定主医嘱的医嘱项id串
/// return:			医嘱项id(医嘱码表),主医嘱序号,医嘱id  （对于本次医嘱,医嘱ID为空） 不是成组医嘱则返回空
/// other:			hisOrditm组成:医嘱项ID^用法ID^频次ID^剂量^剂量单位^总量^总量单位^疗程ID^关联号^标本^部位^接受科室ID^医嘱ID
/// 					seqno关联号组成   seqno：以$c(1)分割 第一位是关联医嘱标志  1是 0否；第二位医嘱序号 如：主医嘱是1 则子医嘱分别是1.2 1.3
ClassMethod GetOrdStrMainOeori(ordStr As %String, hisOrdItm As %String) As %String
{
 
	n (ordStr,hisOrdItm)
	
	s hisMoeori="" 				  //获取主医嘱ID（医嘱项ID,主医嘱序号,医嘱ID）
	s mainOeoriNo=""

	s oeori=$p(hisOrdItm,"^",13)  //医嘱ID
	i oeori'="" d			      //存在医嘱Id的情况下,通过医嘱ID找到主医嘱id,再取主医嘱ID的医嘱项ID(医嘱item表)
	.q:..GetOISeqFlag(oeori)=0 
	.s moeori=..GetMainOeori(oeori) //因为已经判断是关联医嘱,返回值是主医嘱id
	.q:moeori=""
	.s oeord=$p(moeori,"||",1) 
	.q:oeord="" 		
	.s oeordSub=$p(moeori,"||",2)	
	.q:oeordSub=""
	.s arci=$p(^OEORD(oeord,"I",oeordSub,1),"^",2) //医嘱项ID
	.s mSeqNo=$p(^OEORD(oeord,"I",oeordSub,3),"^",4) //主医嘱序号
	.s hisMoeori=arci_","_mSeqNo_","_moeori
	e  d						           //不存在医嘱id(界面传递的医嘱项ID串),在医嘱项id串中找到主医嘱的医嘱项ID
	.s seqno=$p(hisOrdItm,"^",9)			//关联号
	.s arci=$p(hisOrdItm,"^",1)            //医嘱项ID	
	.s oeoriNo=$p(seqno,$c(1),2)	       //医嘱序号
	.q:oeoriNo=""			
	.s childOeoriNo=$p(oeoriNo,".",2)
	.s:childOeoriNo="" hisMoeori=arci_","_oeoriNo_","_""
	.q:hisMoeori'=""
	 
	.s:childOeoriNo'="" mainOeoriNo=$p(oeoriNo,".",1)  //主医嘱序号		
	.s arrcnt=$l(ordStr,$c(2))		                   //遍历医嘱项ID串，找到主医嘱,并取医嘱项ID
	.f i=1:1:arrcnt d
	..s itmstr=$p(ordStr,$c(2),i)
	..q:$p(itmstr,"^",13)'=""
	..s tmpSeqno=$p(itmstr,"^",9)
	..s tmpOeoriNo=$p(tmpSeqno,$c(1),2)
	..s tmpMainOeoriNo=$p(tmpOeoriNo,".",1)
	..s tmpChildOeoriNo=$p(tmpOeoriNo,".",2)
    ..s:(mainOeoriNo=tmpMainOeoriNo)&(tmpChildOeoriNo="") hisMoeori=$p(itmstr,"^",1)_","_mainOeoriNo_","_""
	.
	q hisMoeori
}

/// 获取商品名是归属于哪个分类
ClassMethod GetPhMentDr(proid As %String) As %String
{
	
	;s phmi=$o(^DHCPHMIi(0,"Drug",proid,"")) //qnp 溶媒分类明细的global写错了
	s phmi=$o(^DHCPHMITi(0,"Drug",proid,""))
	q:phmi="" ""
	;s phmentdr=$p(^DHCPHMI(phmi),"^",2)  //qnp 溶媒分类明细的global写错了
	s phmentdr=$p(^DHCPHMIT(phmi),"^",2)
	q phmentdr
}

/// 本医嘱是否关联医嘱 1-是；0-否
ClassMethod GetOISeqFlag(oeori As %String) As %String
{
	Q:oeori="" 0
 	N (oeori)
 	S ord=$p(oeori,"||",1) Q:ord="" 0
 	S chl=$p(oeori,"||",2) Q:chl="" 0
 	Q:'$D(^OEORD(ord,"I",chl,1)) 0
 	S glflag=0
 	S reploc=$P(^OEORD(ord,"I",chl,3),"^",6)
 	S linkorder=$P(^OEORD(ord,"I",chl,11),"^",39)
 	Q:linkorder'="" 1
 	I linkorder="" D
 	.S tmpchl=""
 	.F  S tmpchl=$O(^OEORDi(0,"OEORI",ord,oeori,tmpchl)) Q:(tmpchl="")!(glflag=1)  d
 	..Q:'$D(^OEORD(ord,"I",tmpchl,3))
 	..Q:'$D(^OEORD(ord,"I",tmpchl,1))
 	..Q:$P(^OEORD(ord,"I",tmpchl,3),"^",6)'=reploc
 	..s linksubord=ord_"||"_tmpchl
 	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",linksubord,""))
    ..q:dsp=""
 	..s glflag=1
 	q glflag
}

/// 取主医嘱Rowid
ClassMethod GetMainOeori(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" ""
 	S ord=$p(oeori,"||",1) Q:ord="" ""
 	S chl=$p(oeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	Q:'$D(^OEORD(ord,"I",chl,11)) ""
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
  	Q:loeori'="" loeori
 	Q oeori
}

/// 医嘱剂量按知识库中的维护的单位转换后的医嘱剂量
/// w ##class(web.DHCSTPHCMPASS).GetDosageFactor()
ClassMethod GetDosageFactorNew(arci As %String, doseQtyAndUomDr As %String, qtyUomDesc As %String) As %String
{
	N (arci,doseQtyAndUomDr,qtyUomDesc) 

	s dosqty=$p(doseQtyAndUomDr,"^",1)      //his剂量
	s dosUomDr=$p(doseQtyAndUomDr,"^",2)
	s dosUomDesc=$P(^CT("UOM",dosUomDr),"^",2)  //his单位描述

	S arcim=arci
	S sub=$P(arcim,"||",1)
	Q:sub="" ""
	S ver=$P(arcim,"||",2)
	Q:ver="" ""
	S incidr=$O(^INCI(0,"ARCIM_DR",sub,""))
	Q:incidr="" ""
	Q:'$D(^INCI(incidr,1)) ""
	Q:'$D(^INCI(incidr,3)) ""
	S buom=$P(^INCI(incidr,1),"^",10)  //基本单位
	S puom=$P(^INCI(incidr,3),"^",6)   //入库单位
	Q:'$D(^ARCIM(sub,ver,1)) ""
	S phcdf=$P(^ARCIM(sub,ver,1),"^",12) //药学项
	S phc=$P(phcdf,"||",1)
	Q:phc="" ""
	S formsub=$P(phcdf,"||",2)
	Q:formsub="" ""
	
	s eqsub=""
	f  s eqsub=$O(^PHCD(phc,"DF",formsub,"EQ",eqsub)) q:eqsub=""  d  //qnp PHC_FormDoseEquiv ?
	.S equomdr=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",1)  
	.s equom=$P($G(^CT("UOM",equomdr)),"^",2)				  //等效单位描述
	.q:equom=""
	.s eqqty=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",2) //等效数量
	.
	.i equom=qtyUomDesc  d
	..s mlqty=eqqty
	.i equom=dosUomDesc d
	..s otherqty=eqqty
	
	Q:$g(mlqty)="" ""
	;
	i $g(otherqty)="" s qty=dosqty*mlqty
	i $g(otherqty)'="" s qty=(dosqty/otherqty)*mlqty
	
	
	Q qty
}

/// Description:	审查重复用药
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-04
/// Input:			进程号,本次医嘱串,历次医嘱项串,目录主索引id,节点,返回信息
/// return:			0不通过(重复) 1通过(重复)
/// other:			效验规则-病人此次开了A,B药.以前开过C,D药. 知识库规则下有E,F药.判断统一规则下,此次和以前是否开过E,F药
ClassMethod CheckRepeatUseDurg(pid, ordStr, ordStrItem, instruId, msgNode, ByRef RetMsg As %String) As %String
{
	n (pid,ordStr,ordStrItem,instruId,msgNode,RetMsg)
	
	q:instruId="" -100
	s RetMsg="" 
	s instType=$p(^DHCPHINSTRUC(instruId),"^",5)
	s ordStrItem=..GetUseOrdStr(ordStrItem)		//获取有效医嘱(再用长嘱和当日临嘱)	
	
	i instType="Form" d
	.s ret=..CheckRepeatUseDurgByGeneric(pid,ordStr,ordStrItem,instruId,msgNode,RetMsg) //通用名效验
	e  i instType="ProName" d
	.s ret=..CheckRepeatUseDurgByProName(pid,ordStr,ordStrItem,instruId,msgNode,RetMsg)  //商品名效验

	q ret
}

/// Description:	审查重复用药(商品名)
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-04
/// Input:			进程号,本次医嘱串,历次医嘱项串,目录主索引id,节点,返回信息
/// return:			0不通过(重复) 1通过(重复)
/// other:			效验规则-病人此次开了A,B药.以前开过C,D药. 知识库规则下有E,F药.判断统一规则下,此次和以前是否开过E,F药
/// w ##class(web.DHCSTPHCMPASS).CheckRepeatUseDurg(pid,ordStr,ordStrItem,instruId,,.RetMsg)
ClassMethod CheckRepeatUseDurgByProName(pid As %String, ordStr As %String, ordStrItem As %String, instruId As %String, msgNode As %String, ByRef RetMsg As %String) As %String
{
	n (pid,ordStr,ordStrItem,instruId,msgNode,RetMsg)

	s ret=1
	s checkFlag=1
	s ordStrItemInfo=..DealOrdStr(ordStr,ordStrItem) //##class(web.DHCSTPHCMORDDATA).GetOrdItmStr(ordStrItem)

	s repItmId=""
	f  s repItmId=$o(^DHCPHRITM(0,"Inst",instruId,repItmId)) q:repItmId=""  d  //重复用药业务表 DHC_PHRepeatItm
	.s repId=$p(^DHCPHRITM(repItmId),"^",3)		//规则id DHC_PHRepeatItm
	.q:repId=""
	.q:$d(^TMP("DHCST","web.DHCSTPHCMPASS","CheckRepeatUseDurg",pid,repId,repItmId))
	.s ^TMP("DHCST","web.DHCSTPHCMPASS","CheckRepeatUseDurg",pid,repId,repItmId)=$p(^DHCPHRITM(repItmId),"^",2) //一个规则下的所有药品
	.
	q:'$d(^TMP("DHCST","web.DHCSTPHCMPASS","CheckRepeatUseDurg",pid)) -100	

	s tmpRepId=$o(^TMP("DHCST","web.DHCSTPHCMPASS","CheckRepeatUseDurg",pid,""))  //一条记录，只有一个规则
	s activeFlag=$p(^DHCPHRFE(tmpRepId),"^",3)
	q:activeFlag'="Y" 1  //规则未启用,则默认通过

	s tmpItmId=""
	f  s tmpItmId=$o(^TMP("DHCST","web.DHCSTPHCMPASS","CheckRepeatUseDurg",pid,tmpRepId,tmpItmId)) q:tmpItmId=""  d
	.s proDr=^TMP("DHCST","web.DHCSTPHCMPASS","CheckRepeatUseDurg",pid,tmpRepId,tmpItmId)
	.s arrcnt=$l(ordStrItemInfo,$c(2))
	.f i=1:1:arrcnt d 	//从入参中取出每一个药,找到对应的商品名id,并和规则下的药品进行对比
	..s itmstr=$p(ordStrItemInfo,$c(2),i)
	..q:itmstr=""
	..s arci=$p(itmstr,"^",1)
	..s seqNo=$p($p(itmstr,"^",9),$c(1),2) //医嘱序号
	..s oeori=$p(itmstr,"^",13)				//医嘱ID
	..s libProCode=""
	..s libProId=""
	..
	..s sub=$p(arci,"||",1),ver=$p(arci,"||",2)	
	..i +sub'=0 s itemCatDr=$P(^ARCIM(+sub,ver,1),"^",10)
	..i +sub'=0 s itemCode=$P(^ARCIM(+sub,ver,1),"^",1)
	..;s phcdf=$p($g(^ARCIM(sub,ver,1)),"^",12)	
	..s conProDr=$o(^DHCPHPCO(0,"HisCode",itemCode,""))
	..i conProDr'="" s libProCode=$p(^DHCPHPCO(conProDr),"^",1)	
	..i libProCode'="" s libProId=+$o(^DHCPHPNA(0,"Code",$ZCONVERT(libProCode,"U"),""))
	..q:libProId=""
	..q:libProId'=proDr	
	..
	..s ret=0
	..i ret=0 s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=arci_"-"_seqNo_"-"_oeori_"$"
	.
	
	q ret
}

/// Description:	审查重复用药(通用名)
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-04
/// Input:			进程号,本次医嘱串,历次医嘱项串,目录主索引id,节点,返回信息
/// return:			0不通过(重复) 1通过(重复)
/// other:			效验规则-病人此次开了A,B药.以前开过C,D药. 知识库规则下有E,F药.判断统一规则下,此次和以前是否开过E,F药
/// w ##class(web.DHCSTPHCMPASS).CheckRepeatUseDurg(pid,ordStr,ordStrItem,instruId,,.RetMsg)
ClassMethod CheckRepeatUseDurgByGeneric(pid As %String, ordStr As %String, ordStrItem As %String, instruId As %String, msgNode As %String, ByRef RetMsg As %String) As %String
{
	n (pid,ordStr,ordStrItem,instruId,msgNode,RetMsg)

	s ret=1
	s checkFlag=1	
	s ordStrItemInfo=..DealOrdStr(ordStr,ordStrItem) //##class(web.DHCSTPHCMORDDATA).GetOrdItmStr(ordStrItem)

	s repItmId=""
	f  s repItmId=$o(^DHCPHRITM(0,"Inst",instruId,repItmId)) q:repItmId=""  d  //重复用药业务表 DHC_PHRepeatItm
	.s repId=$p(^DHCPHRITM(repItmId),"^",3)		//规则id DHC_PHRepeatItm
	.q:repId=""
	.q:$d(^TMP("DHCST","web.DHCSTPHCMPASS","CheckRepeatUseDurg",pid,repId,repItmId))
	.s ^TMP("DHCST","web.DHCSTPHCMPASS","CheckRepeatUseDurg",pid,repId,repItmId)=$p(^DHCPHRITM(repItmId),"^",2) //一个规则下的所有药品
	.
	q:'$d(^TMP("DHCST","web.DHCSTPHCMPASS","CheckRepeatUseDurg",pid)) -100	

	s tmpRepId=$o(^TMP("DHCST","web.DHCSTPHCMPASS","CheckRepeatUseDurg",pid,""))  //一条记录，只有一个规则
	s activeFlag=$p(^DHCPHRFE(tmpRepId),"^",3)
	q:activeFlag'="Y" 1  //规则未启用,则默认通过

	s tmpItmId=""
	f  s tmpItmId=$o(^TMP("DHCST","web.DHCSTPHCMPASS","CheckRepeatUseDurg",pid,tmpRepId,tmpItmId)) q:tmpItmId=""  d
	.s geneDr=^TMP("DHCST","web.DHCSTPHCMPASS","CheckRepeatUseDurg",pid,tmpRepId,tmpItmId)
	.s arrcnt=$l(ordStrItemInfo,$c(2))
	.f i=1:1:arrcnt d 	//从入参中取出每一个药,找到对应的商品名id,并和规则下的药品进行对比
	..s itmstr=$p(ordStrItemInfo,$c(2),i)
	..q:itmstr=""
	..s arci=$p(itmstr,"^",1)
	..s seqNo=$p($p(itmstr,"^",9),$c(1),2) //医嘱序号
	..s oeori=$p(itmstr,"^",13)				//医嘱ID
	..s conGeneDr=""  //通用名对照id
	..s libGeneDr=""  //通用名id
	
	..
	..s sub=$p(arci,"||",1),ver=$p(arci,"||",2)	
	..s phcdf=$p($g(^ARCIM(sub,ver,1)),"^",12)
	..s genItmDr=""  //通用名对照id
	..s genLibDr=""  //通用名id
	..s gene=$p($g(^PHCD(+phcdf,4)),"^",1)
    ..i gene'="" d 
    ...s geneDesc=$p($g(^PHCGE("GE",gene)),"^",2) //his通用名
    ...s geneCode=$p($g(^PHCGE("GE",gene)),"^",1) 
    ...s conGeneDr=$o(^DHCPHGENCON(0,"HisCode",geneCode,"")) //通用名和his对照表ID
    ..
    ..i conGeneDr'="" d  
	...s libGeneCode=$p(^DHCPHGENCON(conGeneDr),"^",1)
	...s libGeneDr=$o(^DHCPHEGENi(0,"Code",$ZCONVERT(libGeneCode,"U"),"")) //通用名表
	..q:libGeneDr=""
	..
	..q:libGeneDr'=geneDr 	
	
	..s ret=0
	..i ret=0 s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",instruId)=arci_"-"_seqNo_"-"_oeori_"$"
	.
	k ^TMP("DHCST","web.DHCSTPHCMPASS","CheckRepeatUseDurg",pid)
	q ret
}

/// Description:	审查相互作用
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-04
/// Input:			进程号,医嘱项id串,医嘱id串,目录主索引id,目录节点信息,返回信息
/// return:			0不通过 1通过
/// other:			组内：一组医嘱内是否相互作用   组间:所有的医嘱中，是否相互作用  //index=xx_","_Labeldr_","_rulemain_","_Libdr //qnp 序号 目录 规则表ID 标识
ClassMethod CheckEffect(pid, ordStr, ordStrItem, instruId, labelDr, ByRef RetMsg As %String) As %String
{
	n (pid, ordStr, ordStrItem, instruId,labelDr,RetMsg)

	q:instruId="" -100
	s RetMsg=""
	s labelDesc=$p(^DHCPHPINL(labelDr),"^",1)
	q:(labelDesc'="InterEach")&(labelDesc'="LabInterEach")&(labelDesc'="ELECTInterEach") -100  //药品、检验、心电相互作用
	s instType=$p(^DHCPHINSTRUC(instruId),"^",5)	
	i instType="Form" d
	.s ret=..CheckEffectByGeneric(pid,ordStr, ordStrItem, instruId,labelDr) //通用名效验
    i instType="ProName" d
	.s ret=..CheckEffectByProName(pid,ordStr, ordStrItem, instruId,labelDr)  //商品名效验

	q:$g(ret)="" -100
	
	q ret
}

/// Description:	审查商品名配伍禁忌
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-04
/// Input:			进程号,医嘱项id串,医嘱id串,目录主索引id,目录节点信息,返回信息
/// return:			0不通过 1通过
/// other:			组内：一组医嘱内是否相互作用   组间:所有的医嘱中，是否相互作用  //index=xx_","_Labeldr_","_rulemain_","_Libdr //qnp 序号 目录 规则表ID 标识
ClassMethod CheckTaboo(pid, ordStr, ordStrItem, instruId, labelDr, ByRef RetMsg As %String) As %String
{
	n (pid, ordStr, ordStrItem, instruId,labelDr,RetMsg)
	
	q:instruId="" -100
	s RetMsg=""
	s labelDesc=$p(^DHCPHPINL(labelDr),"^",1)
	q:(labelDesc'="Taboo") -100
	s instType=$p(^DHCPHINSTRUC(instruId),"^",5)	
	i instType="Form" d
	.s ret=..CheckTabooByGeneric(pid,ordStr,ordStrItem,instruId,labelDr) //通用名效验
    i instType="ProName" d
	.s ret=..CheckTabooByProName(pid,ordStr,ordStrItem,instruId,labelDr)  //商品名效验
	
	q:$g(ret)="" -100
	
	q ret
}

/// Description:	审查商品名配伍禁忌
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-04
/// Input:			进程号,医嘱项id串,医嘱id串,目录主索引id,目录节点信息,返回信息
/// return:			0不通过 1通过
/// other:			组内：一组医嘱内是否相互作用   组间:所有的医嘱中，是否相互作用  //index=xx_","_Labeldr_","_rulemain_","_Libdr //qnp 序号 目录 规则表ID 标识
ClassMethod CheckTabooByProName(pid, ordStr, ordStrItem, instruId, labelDr) As %String
{
	n (pid,ordStr,ordStrItem,instruId,labelDr)  
	
	s ordStrItem=..DealOrdStr(ordStr,ordStrItem)
	s RetMsg=""
	s ret=1
	q:instruId="" -100
	s libProId=$p(^DHCPHINSTRUC(instruId),"^",3)		//商品名id

	//配伍禁忌，一个药品只查一次
    s exit=0
	s exit=( $d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Taboo",libProId)) )&($d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"TabooInstId",libProId,instruId)))
	q:exit=1 0 	
	
	//开始检查
	s arrCnt=$l(ordStr,$c(2))
	f i=1:1:arrCnt d
	.s itmStr=$p(ordStr,$c(2),i)
	.s arci=$p(itmStr,"^",1)
	.s tmpOeori=$p(itmStr,"^",13)		//本次医嘱，医嘱id为空
	.//对于历次医嘱，非当日临嘱和已停长嘱不进行 相互作用/配伍禁忌 检测
	.s tmpMainOeori=..GetOrdStrMainOeori(ordStr,itmStr)
	.s commonInfo=$p(..GetCommonTypeInfo(arci,""),",",2)   //获取通用名,商品名
	.s proId=$p(commonInfo,"^",3)	
    .q:($g(proId)="")
    .	
  	.s instType="ProName"
    .//遍历出一个医嘱对应的相互作用/配伍禁忌信息，并用global暂存
    .s tmpInstruId=""  
    .f  s tmpInstruId=$o(^DHCPHINSTRUC(0,"TGP",labelDr,proId,instType,0,tmpInstruId)) q:tmpInstruId=""  d
    ..s interId=""	
	..f  s interId=$o(^DHCPHDINTER(0,"Inst",tmpInstruId,interId)) q:interId=""  d // 相互作用业务表数据 DHC_PHDiseaseInteract
	...q:interId=""
	...s tmpProDr=$p(^DHCPHDINTER(interId),"^",6)	//配伍禁忌 商品名id
	...q:tmpProDr=""
	...s type=$p(^DHCPHDINTER(interId),"^",4)		// I 相互作用 INC配伍禁忌
	...s inisFlag=$p(^DHCPHDINTER(interId),"^",5)	//配伍禁忌 医嘱标识(组内1  组间2  全部3)
	...q:type'="INC"
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckTaboo",proId,tmpProDr,tmpInstruId)=inisFlag   
	...
	..
    .//遍历所有待检测医嘱,与临时global中的相互作用信息进行判断
	.f h=1:1:arrCnt d
	..s newItmStr=$p(ordStr,$c(2),h)
	..s newArci=$p(newItmStr,"^",1)
	..q:arci=newArci
	..s NewCommonInfo=$p(..GetCommonTypeInfo(newArci,""),",",2)   //获取通用名,商品名
	..//s newConProDr=$p(NewCommonInfo,"^",3)	
    ..//q:($g(newConProDr)="")
    ..s newProId=$p(NewCommonInfo,"^",3)	
    ..q:($g(newProId)="")    
    ..;q:$d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Taboo",proId,newProConDr))  //AB 和BA 不重复判断
    ..//判断医嘱标识(组内 组间)
    ..s newOeori=$p(newItmStr,"^",13)
    ..s newMainOeori=..GetOrdStrMainOeori(ordStr,newItmStr)
 	..i newOeori'="" d
 	...s newSeqno=$P(^OEORD(+newOeori,"I",$p(newOeori,"||",2),3),"^",4)		/// 关联医嘱号
	..e  d
	...s newSeqno=$p(newItmStr,"^",9)
	...s newSeqno=$p(newSeqno,$c(1),2)
	..
	..s grpFlag=3
	..//考虑本次医嘱(未提交审核)
	..i (tmpOeori="")&(newOeori="") d
	...s:(tmpMainOeori=newMainOeori)&(tmpMainOeori'="")&(newMainOeori'="") grpFlag=1 //组内
	...s:(tmpMainOeori'=newMainOeori)||((tmpMainOeori=newMainOeori)&(tmpMainOeori="")&(newMainOeori="")) grpFlag=2 //组间
	..//考虑历次医嘱(已提交审核)
	..i (tmpOeori'="")&(newOeori'="") d
	...s:tmpMainOeori=newMainOeori grpFlag=1 //组内
	...s:tmpMainOeori'=newMainOeori grpFlag=2 //组间
	..//考虑本次和历次交叉
	..i ( ((tmpOeori="")&(newOeori'=""))  ||  ((tmpOeori'="")&(newOeori="")) ) d
	...s grpFlag=2 //组间
	..
	..//判断配伍禁忌
	..i $D(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckTaboo",proId,newProId)) d
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Taboo",proId,newProId)=""
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Taboo",newProId,proId)=""
	...
	...s tmpInstId=""
	...s insgFlag=""
	...s tmpInstId=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckTaboo",proId,newProId,""))
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"TabooInstId",proId,tmpInstId)=""	
	...s insgFlag=^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckTaboo",proId,newProId,tmpInstId)
	...s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",tmpInstId)=newArci_"-"_newSeqno_"-"_newOeori_"$"
	...
	...i (grpFlag'=insgFlag)&(insgFlag'=3) d //组内
	....k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Taboo",proId,newProId)
	....k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Taboo",newProId,proId)
	....k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckTaboo",proId)
	....k ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",tmpInstId)
	...
	..
	.

	i $d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Taboo",libProId))&($d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"TabooInstId",libProId,instruId))) d
	.s ret=0

	q ret
}

/// Description:	审查通用名配伍禁忌
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-04
/// Input:			进程号,医嘱项id串,医嘱id串,目录主索引id,目录节点信息,返回信息
/// return:			0不通过 1通过
/// other:			组内：一组医嘱内是否相互作用   组间:所有的医嘱中，是否相互作用  //index=xx_","_Labeldr_","_rulemain_","_Libdr //qnp 序号 目录 规则表ID 标识
ClassMethod CheckTabooByGeneric(pid, ordStr, ordStrItem, instruId, labelDr) As %String
{
	//q:-100 -100
	n (pid,ordStr,ordStrItem,instruId,labelDr)  

	s ordStrItem=..DealOrdStr(ordStr,ordStrItem)
	s RetMsg=""
	s ret=-100
	q:instruId="" -100
	s libGeneDr=$p(^DHCPHINSTRUC(instruId),"^",3)		//通用名id
	q:libGeneDr="" -100
	//相互作用和配伍禁忌，一个药品只查一次
    s exit=0
 	s exit=( $d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Taboo",libGeneDr)) )&($d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"TabooInstId",libGeneDr,instruId)))
	q:exit=1 0 	
	
	s arrCnt=$l(ordStrItem,$c(2))  //开始检查
	f i=1:1:arrCnt d
	.s itmStr=$p(ordStrItem,$c(2),i)
	.s arci=$p(itmStr,"^",1)
	.s tmpOeori=$p(itmStr,"^",13)		//本次医嘱，医嘱id为空
	.s tmpMainOeori=..GetOrdStrMainOeori(ordStrItem,itmStr) //对于历次医嘱，非当日临嘱和已停长嘱不进行 相互作用/配伍禁忌 检测
	.s orderType=$p(..GetCommonTypeInfo(arci,""),",",1)	//获取医嘱类型
	.q:orderType'="R"
	.s commonInfo=$p(..GetCommonTypeInfo(arci,""),",",2)   //获取通用名,商品名
	.s geneDr=$p(commonInfo,"^",2) 						//知识库通用名id
	.s pointer=$p(commonInfo,"^",4)	
    .q:($g(pointer)="")||($g(geneDr)="")
	.
  	.s instType="Form" 
    .//遍历出一个医嘱对应的相互作用/配伍禁忌信息，并用global暂存
    .s tmpInstruId=""  
    .f  s tmpInstruId=$o(^DHCPHINSTRUC(0,"TGP",labelDr,geneDr,instType,pointer,tmpInstruId)) q:tmpInstruId=""  d
    ..s interId=""	
	..f  s interId=$o(^DHCPHDINTER(0,"Inst",tmpInstruId,interId)) q:interId=""  d // 相互作用业务表数据 DHC_PHDiseaseInteract
	...q:interId=""
	...s tmpGeneDr=$p($g(^DHCPHDINTER(interId)),"^",2)	//相互作用/配伍禁忌 通用名id
	...q:tmpGeneDr=""
	...s type=$p(^DHCPHDINTER(interId),"^",4)		// I 相互作用 INC配伍禁忌
	...s inisFlag=$p(^DHCPHDINTER(interId),"^",5)	//相互作用/配伍禁忌 医嘱标识(组内1  组间2  全部3)
	...q:type'="INC"
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckTaboo",geneDr,tmpGeneDr,tmpInstruId)=inisFlag   
	...
	..
	.
    .//遍历所有待检测医嘱,与临时global中的相互作用信息进行判断
	.f h=1:1:arrCnt d
	..s newItmStr=$p(ordStrItem,$c(2),h)
	..s newArci=$p(newItmStr,"^",1)
	..q:arci=newArci
	..s newOrderType=$p(..GetCommonTypeInfo(newArci,""),",",1)	//获取医嘱类型
	..q:newOrderType'="R"
	..s commonInfo=$p(..GetCommonTypeInfo(newArci,""),",",2)   //获取通用名,商品名
	..s newGeneDr=$p(commonInfo,"^",2) 						//知识库通用名id
	..s newPointer=$p(commonInfo,"^",4)	
    ..q:($g(newGeneDr)="")||($g(newPointer)="")
	..
	..;q:$d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Taboo",proId,newProConDr))  //AB 和BA 不重复判断
    ..//判断医嘱标识(组内 组间)
    ..s newOeori=$p(newItmStr,"^",13)
    ..s newMainOeori=..GetOrdStrMainOeori(ordStrItem,newItmStr)
 	..i newOeori'="" d
 	...s newSeqno=$P(^OEORD(+newOeori,"I",$p(newOeori,"||",2),3),"^",4)		/// 关联医嘱号
	..e  d
	...s newSeqno=$p(newItmStr,"^",9)
	...s newSeqno=$p(newSeqno,$c(1),2)
	..
	..s grpFlag=3
	..//考虑本次医嘱(未提交审核)
	..i (tmpOeori="")&(newOeori="") d
	...s:(tmpMainOeori=newMainOeori)&(tmpMainOeori'="")&(newMainOeori'="") grpFlag=1 //组内
	...s:(tmpMainOeori'=newMainOeori)||((tmpMainOeori=newMainOeori)&(tmpMainOeori="")&(newMainOeori="")) grpFlag=2 //组间
	..//考虑历次医嘱(已提交审核)
	..i (tmpOeori'="")&(newOeori'="") d
	...s:tmpMainOeori=newMainOeori grpFlag=1 //组内
	...s:tmpMainOeori'=newMainOeori grpFlag=2 //组间
	..//考虑本次和历次交叉
	..i ( ((tmpOeori="")&(newOeori'=""))  ||  ((tmpOeori'="")&(newOeori="")) ) d
	...s grpFlag=2 //组间
	..
	..//判断配伍禁忌
	..i $D(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckTaboo",geneDr,newGeneDr)) d
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Taboo",geneDr,newGeneDr)=""
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Taboo",newGeneDr,geneDr)=""
	...
	...s tmpInstId=""
	...s insgFlag=""
	...s tmpInstId=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckTaboo",geneDr,newGeneDr,""))
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"TabooInstId",geneDr,tmpInstId)=""	
	...s insgFlag=^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckTaboo",geneDr,newGeneDr,tmpInstId)
	...s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",tmpInstId)=newArci_"-"_newSeqno_"-"_newOeori_"$"
	...
	...i (grpFlag'=insgFlag)&(insgFlag'=3) d //组内
	....k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Taboo",geneDr,newGeneDr)
	....k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Taboo",newGeneDr,geneDr)
	....k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckTaboo",geneDr)
	....k ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",tmpInstId)
	...
	..
	.

	i $d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Taboo",libGeneDr))&($d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"TabooInstId",libGeneDr,instruId))) d
	.s ret=0
	
	q ret
}

/// Description:	审查通用名相互作用
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-04
/// Input:			进程号,医嘱项id串,医嘱id串,目录主索引id,目录节点信息,返回信息
/// return:			0不通过 1通过
/// other:			组内：一组医嘱内是否相互作用   组间:所有的医嘱中，是否相互作用  //index=xx_","_Labeldr_","_rulemain_","_Libdr //qnp 序号 目录 规则表ID 标识
ClassMethod CheckEffectByGeneric(pid, ordStr, ordStrItem, instruId, labelDr) As %String
{
	n (pid,ordStr,ordStrItem,instruId,labelDr) 
	s ordStrItem=..DealOrdStr(ordStr,ordStrItem)	
	s RetMsg=""
	s ret=1
	q:instruId="" -100
	s libGeneDr=$p(^DHCPHINSTRUC(instruId),"^",3)		//通用名id	
	q:libGeneDr="" -100

	//相互作用和配伍禁忌，一个药品只查一次
    s exit=0
   	s exit=( $d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Effect",libGeneDr)) )&($d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EffectInstId",libGeneDr,instruId)))
	q:exit=1 0 	

	s arrCnt=$l(ordStrItem,$c(2))  //开始检查
	f i=1:1:arrCnt d
	.s itmStr=$p(ordStrItem,$c(2),i)
	.s arci=$p(itmStr,"^",1)
	.q:arci=""
	.s hisPart=$p(itmStr,"^",11)
	.s tmpOeori=$p(itmStr,"^",13)		                //本次医嘱，医嘱id为空
	.s tmpMainOeori=..GetOrdStrMainOeori(ordStrItem,itmStr) //对于历次医嘱，非当日临嘱和已停长嘱不进行 相互作用审查
	.s orderType=$p(..GetCommonTypeInfo(arci,hisPart),",",1)	//获取医嘱类型
	.s commonInfo=$p(..GetCommonTypeInfo(arci,hisPart),",",2)   //获取通用名,商品名
	.s hisGeneDesc=$p(commonInfo,"^",1)      
	.s geneDr=$p(commonInfo,"^",2) 						//知识库通用名id
	.s proDr=$p(commonInfo,"^",3)	
	.s pointer=$p(commonInfo,"^",4)	
    .q:($g(pointer)="")||($g(geneDr)="")
    .//遍历出一个医嘱对应的相互作用信息，并用global暂存
    .s instType="Form"
    .s tmpInstruId=""  
    .f  s tmpInstruId=$o(^DHCPHINSTRUC(0,"TGP",labelDr,geneDr,instType,pointer,tmpInstruId)) q:tmpInstruId=""  d
    ..s interId=""	
	..f  s interId=$o(^DHCPHDINTER(0,"Inst",tmpInstruId,interId)) q:interId=""  d // 相互作用业务表数据 DHC_PHDiseaseInteract
	...q:interId=""
	...s tmpGeneDr=$p(^DHCPHDINTER(interId),"^",2)	//相互作用 通用名id
	...q:tmpGeneDr=""
	...s type=$p(^DHCPHDINTER(interId),"^",4)		// I 相互作用 INC配伍禁忌	
	...s inisFlag=$p(^DHCPHDINTER(interId),"^",5)	//相互作用/配伍禁忌 医嘱标识(组内1  组间2  全部3)
	...q:type'="I"
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckEffect",geneDr,tmpGeneDr,tmpInstruId)=inisFlag  
	..
	.
    .//遍历所有待检测医嘱,与临时global中的相互作用信息进行判断
	.f h=1:1:arrCnt d
	..s newItmStr=$p(ordStrItem,$c(2),h)
	..s newArci=$p(newItmStr,"^",1)
	..q:newArci=""
	..q:arci=newArci
	..s newHisPart=$p(newItmStr,"^",11)
	..s tmpMainOeori=..GetOrdStrMainOeori(ordStrItem,itmStr) //对于历次医嘱，非当日临嘱和已停长嘱不进行 相互作用审查
	..s newOrderType=$p(..GetCommonTypeInfo(newArci,newHisPart),",",1)	//获取医嘱类型
	..s newCommonInfo=$p(..GetCommonTypeInfo(newArci,newHisPart),",",2)   //获取通用名,商品名
	..s newGeneDr=$p(newCommonInfo,"^",2) 						//知识库通用名id
	..s newProDr=$p(newCommonInfo,"^",3)
	..s newPointer=$p(newCommonInfo,"^",4)	
	..q:($g(newGeneDr)="")||($g(newPointer)="")	
    ..//q:(($g(newGeneDr)="")&($g(newProDr)=""))||($g(newPointer)="")	
    ..//判断医嘱标识(组内 组间)
    ..s newOeori=$p(newItmStr,"^",13)
    ..s newMainOeori=..GetOrdStrMainOeori(ordStrItem,newItmStr)
 	..i newOeori'="" d
 	...s newSeqno=$P(^OEORD(+newOeori,"I",$p(newOeori,"||",2),3),"^",4)		/// 关联医嘱号
	..e  d
	...s newSeqno=$p(newItmStr,"^",9)
	...s newSeqno=$p(newSeqno,$c(1),2)
	..
	..s grpFlag=3
	..//考虑本次医嘱(未提交审核)
	..i (tmpOeori="")&(newOeori="") d
	...s:(tmpMainOeori=newMainOeori)&(tmpMainOeori'="")&(newMainOeori'="") grpFlag=1 //组内
	...s:(tmpMainOeori'=newMainOeori)||((tmpMainOeori=newMainOeori)&(tmpMainOeori="")&(newMainOeori="")) grpFlag=2 //组间
	..//考虑历次医嘱(已提交审核)
	..i (tmpOeori'="")&(newOeori'="") d
	...s:tmpMainOeori=newMainOeori grpFlag=1 //组内
	...s:tmpMainOeori'=newMainOeori grpFlag=2 //组间
	..//考虑本次和历次交叉
	..i ( ((tmpOeori="")&(newOeori'="")) || ((tmpOeori'="")&(newOeori="")) ) d
	...s grpFlag=2 //组间
	..
	..i newOrderType'="R"  s grpFlag=2  //检验检查默认组间
	..//判断相互作用
	..i $D(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckEffect",geneDr,newGeneDr)) d
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Effect",geneDr,newGeneDr)=""
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Effect",newGeneDr,geneDr)=""
	...
	...s tmpInstId=""
	...s tmpInstId=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckEffect",geneDr,newGeneDr,""))
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EffectInstId",geneDr,tmpInstId)=""
	...s insgFlag=^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckEffect",geneDr,newGeneDr,tmpInstId)
	...i orderType'="R" s insgFlag=2 //检验检查默认组间
	...s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",tmpInstId)=newArci_"-"_newSeqno_"-"_newOeori_"$"
	...i (grpFlag'=insgFlag)&(insgFlag'=3) d //组内
	....k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Effect",geneDr,newGeneDr)
	....k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Effect",newGeneDr,geneDr)
	....k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EffectInstId",geneDr)
	....k ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",tmpInstId)
	..	

	i $d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Effect",libGeneDr))&($d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EffectInstId",libGeneDr,instruId)))  d
	.s ret=0

	q ret
}

/// Description:	审查商品名相互作用
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-04
/// Input:			进程号,医嘱项id串,医嘱id串,目录主索引id,目录节点信息,返回信息
/// return:			0不通过 1通过
/// other:			组内：一组医嘱内是否相互作用   组间:所有的医嘱中，是否相互作用  //index=xx_","_Labeldr_","_rulemain_","_Libdr //qnp 序号 目录 规则表ID 标识
ClassMethod CheckEffectByProName(pid, ordStr, ordStrItem, instruId, labelDr) As %String
{
	n (pid,ordStr,ordStrItem,instruId,labelCode,labelDr)  
	
	s ordStrItem=..DealOrdStr(ordStr,ordStrItem)
	s RetMsg=""
	s ret=1
	q:instruId="" -100
	s libProId=$p(^DHCPHINSTRUC(instruId),"^",3)		//商品名id
	q:libProId="" -100
	//相互作用和配伍禁忌，一个药品只查一次
    s exit=0
   	s exit=( $d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Effect",libProId)) )&($d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EffectInstId",libProId,instruId)))
	q:exit=1 0 	
	
	//开始检查
	s arrCnt=$l(ordStrItem,$c(2))
	f i=1:1:arrCnt d
	.s itmStr=$p(ordStrItem,$c(2),i)
	.s arci=$p(itmStr,"^",1)
	.q:arci=""
	.s tmpOeori=$p(itmStr,"^",13)		//本次医嘱，医嘱id为空
	.//对于历次医嘱，非当日临嘱和已停长嘱不进行 相互作用/配伍禁忌 检测
	.s tmpMainOeori=..GetOrdStrMainOeori(ordStrItem,itmStr)
	.s commonInfo=$p(..GetCommonTypeInfo(arci,""),",",2)   //获取通用名,商品名
	.s proId=$p(commonInfo,"^",3)	
	.q:($g(proId)="")
	.
	.s instType="ProName"
    .//遍历出一个医嘱对应的相互作用/配伍禁忌信息，并用global暂存
    .s tmpInstruId=""  
    .f  s tmpInstruId=$o(^DHCPHINSTRUC(0,"TGP",labelDr,proId,instType,0,tmpInstruId)) q:tmpInstruId=""  d
    ..s interId=""	
	..f  s interId=$o(^DHCPHDINTER(0,"Inst",tmpInstruId,interId)) q:interId=""  d // 相互作用业务表数据 DHC_PHDiseaseInteract
	...q:interId=""
	...s tmpProDr=$p(^DHCPHDINTER(interId),"^",6)	//相互作用/配伍禁忌 商品名id
	...q:tmpProDr=""
	...s type=$p(^DHCPHDINTER(interId),"^",4)		// I 相互作用 INC配伍禁忌
	...s inisFlag=$p(^DHCPHDINTER(interId),"^",5)	//相互作用/配伍禁忌 医嘱标识(组内1  组间2  全部3)
	...q:type'="I"
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckEffect",proId,tmpProDr,tmpInstruId)=inisFlag  
	...
	..
	.
    .//遍历所有待检测医嘱,与临时global中的相互作用信息进行判断
	.f h=1:1:arrCnt d
	..s newItmStr=$p(ordStrItem,$c(2),h)
	..s newArci=$p(newItmStr,"^",1)
	..q:newArci=""
	..q:arci=newArci
	..s NewCommonInfo=$p(..GetCommonTypeInfo(newArci,""),",",2)   //获取通用名,商品名
	..s newProId=$p(NewCommonInfo,"^",3)	
	..q:($g(newProId)="")
	..;q:$d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Taboo",proId,newProConDr))  //AB 和BA 不重复判断
    ..//判断医嘱标识(组内 组间)
    ..s newOeori=$p(newItmStr,"^",13)
    ..s newMainOeori=..GetOrdStrMainOeori(ordStrItem,newItmStr)
 	..i newOeori'="" d
 	...s newSeqno=$P(^OEORD(+newOeori,"I",$p(newOeori,"||",2),3),"^",4)		/// 关联医嘱号
	..e  d
	...s newSeqno=$p(newItmStr,"^",9)
	...s newSeqno=$p(newSeqno,$c(1),2)
	..
	..s grpFlag=3
	..//考虑本次医嘱(未提交审核)
	..i (tmpOeori="")&(newOeori="") d
	...s:(tmpMainOeori=newMainOeori)&(tmpMainOeori'="")&(newMainOeori'="") grpFlag=1 //组内
	...s:(tmpMainOeori'=newMainOeori)||((tmpMainOeori=newMainOeori)&(tmpMainOeori="")&(newMainOeori="")) grpFlag=2 //组间
	..//考虑历次医嘱(已提交审核)
	..i (tmpOeori'="")&(newOeori'="") d
	...s:tmpMainOeori=newMainOeori grpFlag=1 //组内
	...s:tmpMainOeori'=newMainOeori grpFlag=2 //组间
	..//考虑本次和历次交叉
	..i ( ((tmpOeori="")&(newOeori'=""))  ||  ((tmpOeori'="")&(newOeori="")) ) d
	...s grpFlag=2 //组间
	..
	..//判断相互作用
	..i $D(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckEffect",proId,newProId)) d
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Effect",proId,newProId)=""
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Effect",newProId,proId)=""
	...
	...s tmpInstId=""
	...s tmpInstId=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckEffect",proId,newProId,""))
	...s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EffectInstId",proId,tmpInstId)=""
	...s insgFlag=^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"CheckEffect",proId,newProId,tmpInstId)
	...s ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",tmpInstId)=newArci_"-"_newSeqno_"-"_newOeori_"$"
	...;s ^TMP("DHCST","web.DHCSTPHCMPASS","CheckProEffect",pid,"TmpMsg",tmpInstId)=newArci_"-"_newSeqno_"-"_newOeori
	...
	...i (grpFlag'=insgFlag)&(insgFlag'=3) d //组内
	....k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Effect",proId,newProId)
	....k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Effect",newProId,proId)
	....k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EffectInstId",proId)
	....k ^TMP("DHCST","web.DHCSTPHCMPASS","CommonRetMsg",tmpInstId)
	....k ^TMP("DHCST","web.DHCSTPHCMPASS","CheckProEffect",pid,"TmpMsg",instruId)
	..
	.
	
	i $d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Effect",libProId))&($d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EffectInstId",libProId,instruId)))  d
	.s ret=0
	
	q ret
}

/// Description:	审查商品名可配伍药品
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-15
/// Input:			进程号,医嘱项串,带审查医嘱项串,目录主索引id,返回信息
/// return:			0不通过 1通过 -100没有维护数据
/// other:			
ClassMethod CheckDrugAlone(pid, ordStr, hisOrdItm, instruId, ByRef RetMsg As %String) As %String
{
	
	n (pid,ordStr,hisOrdItm,instruId,RetMsg)
	q:instruId="" -100 //没有维护
	q:'$D(^DHCPHDAL(0,"Inst",instruId)) -100	
	s drugAloneId=$o(^DHCPHDAL(0,"Inst",instruId,""))	//DHC_PHDrgAlone 可配伍药品业务表
	q:drugAloneId="" -100

	//判断医嘱是否关联医嘱
	s seqNo=$p(hisOrdItm,"^",9)  
	s groupOrdFlag=$p(seqNo,$c(1),1) //医嘱是否是关联医嘱
	//s oeoriNo=$p(seqNo,$c(1),2)      //开立医嘱序号 如：主医嘱是1 则子医嘱分别是1.2 1.3
	q:groupOrdFlag=0 1		    //可配伍药品审查查只针对成组关联医嘱
	
   
    i '$d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"DrugAlone")) d
	.s arrcnt=$l(ordStr,$c(2))
	.f len=1:1:arrcnt d
	..s itmStr=$p(ordStr,$c(2),len)
	..s seqNo=$p($p(itmStr,"^",9),$c(1),2)			//医嘱序号
	..s oeori=$p(itmStr,"^",1)_","_seqNo_","_$p(itmStr,"^",13)
	..s moeori=..GetOrdStrMainOeori(ordStr,itmStr)  //主医嘱医嘱项id,主序号,主医嘱id
	..s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"DrugAlone",moeori,oeori)=itmStr
	q:'$d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"DrugAlone")) -100

	s ret=1
	s hisMainOeori=..GetOrdStrMainOeori(ordStr,hisOrdItm)

	s tmpoe=""
	f  s tmpoe=$O(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"DrugAlone",hisMainOeori,tmpoe)) Q:tmpoe=""  d	
	.s arci=$p(hisOrdItm,"^",1)
	.s seqNo=$p($p(hisOrdItm,"^",9),$c(1),2)
	.s oeori=$p(hisOrdItm,"^",13)
	.s tmpOeori=arci_","_seqNo_","_oeori
	.//q:tmpOeori=tmpoe		
	.q:hisMainOeori=tmpoe			
	.s linkArci=$p(tmpoe,",",1)
	.s hisProCode=$P(^ARCIM(+linkArci,$p(linkArci,"||",2),1),"^",1)
    .s conProDr=$o(^DHCPHPCO(0,"HisCode",hisProCode,""))
    .q:conProDr=""
    .i conProDr'="" s libProCode=$p(^DHCPHPCO(conProDr),"^",1)
    .s libProId=+$o(^DHCPHPNA(0,"Code",$ZCONVERT(libProCode,"U"),""))
    .s libProCatDr=..GetPhMentDr(libProId)
    .s instLibProID=$p(^DHCPHINSTRUC(instruId),"^",3)
    .s proFlag=1,catFlag=1
    .
    .s drugAloneId=""
    .f  s drugAloneId=$o(^DHCPHDAL(0,"Inst",instruId,drugAloneId)) q:drugAloneId=""  d
    ..s instProDr=$p(^DHCPHDAL(drugAloneId),"^",1)
    ..s instCatDr=$p(^DHCPHDAL(drugAloneId),"^",5)
    ..s instGroup=$p($g(^DHCPHDAL(drugAloneId)),"^",4)
    ..//q:instProDr=""
    ..//i (instProDr'="")&(instProDr=libProId) s proFlag=1 	
    ..i (instLibProID'=libProId)&(instProDr'="")&(instProDr'=libProId) s proFlag=0	// qunianpeng 2018/8/27
    ..
    ..//i (instCatDr'="")&(instCatDr=libProCatDr) s catFlag=1
    ..i (instCatDr'="")&(instCatDr'=libProCatDr) s catFlag=0	// qunianpeng 2018/8/27
    ..i instCatDr="" s catFlag=1
    .
    .i proFlag=0  d
    ..s ret=0
    .i proFlag=1  d
    ..i catFlag=0  s ret=0
    .

    q ret
}

/// Description:	审查辅助用药个数
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-16
/// Input:			进程号,医嘱项串,带审查医嘱项串,目录主索引id,返回信息
/// return:			0不通过 1通过 -100没有维护数据
/// other:		     ##class(web.DHCSTPHCMPASS).CheckAccDrugNum(pid,ordStr,hisOrdItm,instruId,.RetMsg)
ClassMethod CheckAccDrugNum(pid, ordStr, hisOrdItm, instruId, ByRef RetMsg As %String) As %String
{
	n (pid,ordStr,hisOrdItm,instruId,RetMsg)
	q:instruId="" -100
    q:'$d(^DHCPHADN(0,"Inst",instruId)) -100	//DHC_PHAssDrugNum 辅助用药个数业务表
    s drugNumId=$o(^DHCPHADN(0,"Inst",instruId,""))
	q:drugNumId="" -100	
	s drugNum=+$p(^DHCPHADN(drugNumId),"^",2)	//知识库维护辅药个数
	s arrcnt=$l(ordStr,$c(2))
	f len=1:1:arrcnt d
	.s itmStr=$p(ordStr,$c(2),len)
	.s seqNo=$p($p(itmStr,"^",9),$c(1),2)			//医嘱序号
	.s oeori=$p(itmStr,"^",1)_","_seqNo_","_$p(itmStr,"^",13)
	.s moeori=..GetOrdStrMainOeori(ordStr,itmStr)  //主医嘱医嘱项id,主序号,主医嘱id
	.q:moeori=""
	.s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"AccDrug",moeori,oeori)=len
	q:'$d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"AccDrug")) -100
		
	s ret=1
	s hisMeori=..GetOrdStrMainOeori(ordStr,hisOrdItm)
	s count=0
	s tmpOeori="" 
	f  s tmpOeori=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"AccDrug",hisMeori,tmpOeori)) q:tmpOeori=""  d
	.s arci=$p(hisOrdItm,"^",1)
	.s seqNo=$p($p(hisOrdItm,"^",9),$c(1),2)
	.s oeori=$p(hisOrdItm,"^",13)
	.s tmpoe=arci_","_seqNo_","_oeori
	.q:tmpOeori=tmpoe				
	.
	.;s tmpArci=$p(tmpOeori,",",1)
	.;s tmpHisProCode=$P(^ARCIM(+tmpArci,$p(tmpArci,"||",2),1),"^",1)
	.;s conProDr=$o(^DHCPHPCO(0,"HisCode",tmpHisProCode,""))
    .;q:conProDr=""
    .;s tmpLibProCode=$p(^DHCPHPCO(conProDr),"^",1)
    .;s tmpLibProId=+$o(^DHCPHPNA(0,"Code",$ZCONVERT(tmpLibProCode,"U"),""))
	.;q:tmpLibProId=0
	.s count=count+1	//计算一组医嘱中有几个医嘱(辅药个数)
	i drugNum<count d
	.s ret=0	

	k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"AccDrug")
 	q ret
}

/// Description:	审查单个药溶媒浓度
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-16
/// Input:			进程号,医嘱项串,带审查医嘱项串,目录主索引id,返回信息
/// return:			0不通过 1通过 -100没有维护数据
/// other:		     ##class(web.DHCSTPHCMPASS).CheckSolvent(pid,ordStr,hisOrdItm,instruId,.RetMsg)
ClassMethod CheckSolvent(pid, ordStr, hisOrdItm, instruId, ByRef RetMsg As %String) As %String
{
	n (pid,ordStr,hisOrdItm,instruId,RetMsg)
	q:instruId="" -100	

	s seqNo=$p(hisOrdItm,"^",9)  
	s groupOrdFlag=$p(seqNo,$c(1),1) //医嘱是否是关联医嘱
	s oeoriNo=$p(seqNo,$c(1),2)      //开立医嘱序号 如：主医嘱是1 则子医嘱分别是1.2 1.3
	q:groupOrdFlag=0 -100		    //溶媒量检查只针对成组关联医嘱 	判断医嘱是否关联医嘱
	
	s instid=$p(hisOrdItm,"^",2)
	s instDesc=""
	i instid'="" s instCode=$p(^PHCIN(instid),"^",1),instDesc=$p(^PHCIN(instid),"^",2)  //暂时不判断输液用法为空
	;q:'(instDesc["静滴")||(instid="") 1
	q:(instid="") -100
		
	s hisMoeori=..GetOrdStrMainOeori(ordStr,hisOrdItm)	
	s dstDr=$o(^DHCPHDST(0,"Inst",instruId,""))		//DHC_PHDrgSolvent 浓度业务表
	q:dstDr="" -100		
	s libLinkProDr=$p(^DHCPHDST(dstDr),"^",2) 		//知识库溶媒药品
	s libLinkQty=$p(^DHCPHDST(dstDr),"^",4) 		//知识库溶媒剂量	
	s location=$p(^DHCPHDST(dstDr),"^",5)			//逻辑关系
	i location = "><" d
	.s libLinkQty=$p(^DHCPHDST(dstDr),"^",8)_"-"_$p(^DHCPHDST(dstDr),"^",7)
	s libLinkQtyUomDr=$p(^DHCPHDST(dstDr),"^",6)   //知识库容量单位	
	q:libLinkQtyUomDr="" -100
	s libLinkQtyUomDesc=$P(^DHCPHEUO(libLinkQtyUomDr),"^",2)	
	
	i '$d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Solvent")) d
	.s arrcnt=$l(ordStr,$c(2))
	.f len=1:1:arrcnt d
	..s itmStr=$p(ordStr,$c(2),len)
	..s seqNo=$p($p(itmStr,"^",9),$c(1),2)			//医嘱序号
	..s oeori=$p(itmStr,"^",1)_","_seqNo_","_$p(itmStr,"^",13)
	..s moeori=..GetOrdStrMainOeori(ordStr,itmStr)  //主医嘱医嘱项id,主序号,主医嘱id
	..s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Solvent",moeori,oeori)=itmStr

	s ret=1
	//s existflag=0
    s tmpoe=""
	f  s tmpoe=$O(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Solvent",hisMoeori,tmpoe)) Q:tmpoe=""  d
	.s tmpArci=$p(hisOrdItm,"^",1)
	.s tmpSeqNo=$p($p(hisOrdItm,"^",9),$c(1),2)
	.s tmpOeori=$p(hisOrdItm,"^",13)
	.s tmpOeori=tmpArci_","_tmpSeqNo_","_tmpOeori
	.q:tmpOeori=tmpoe	
	.s arci=$p(tmpoe,",",1)
	.s hisProCode=$P(^ARCIM(+arci,$p(arci,"||",2),1),"^",1)
	.s conProDr=$o(^DHCPHPCO(0,"HisCode",hisProCode,""))
    .q:conProDr=""
    .s libProCode=$p(^DHCPHPCO(conProDr),"^",1)
    .s libProId=+$o(^DHCPHPNA(0,"Code",$ZCONVERT(libProCode,"U"),""))
	.q:libProId=0
	.q:libProId'=libLinkProDr
	.s hisLinkQty=$p($g(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Solvent",hisMoeori,tmpoe)),"^",4)			//溶媒剂量
	.s hisLinkUomDr=$p($g(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"Solvent",hisMoeori,tmpoe)),"^",5)			//溶媒剂量
	.s hisLinkUomDesc=$p(^CT("UOM",hisLinkUomDr),"^",2)  //取单位描述
	.s:hisLinkUomDesc'=libLinkQtyUomDesc hisLinkQty=..GetDosageFactorNew(arci,hisLinkQty_"^"_hisLinkUomDr,libLinkQtyUomDesc) 
    .s:hisLinkQty="" ret=1 
    .q:hisLinkQty=""
    .i location="!>" d
	..i hisLinkQty>libLinkQty s ret=0
	.
	.i location="!<" d
	..i hisLinkQty<libLinkQty s ret=0
	.
	.i location=">" d
	..i hisLinkQty<=libLinkQty s ret=0
	.
	.i location="<" d
	..i hisLinkQty>=libLinkQty s ret=0
	.
	.i location="=" d
	..i hisLinkQty'=libLinkQty s ret=0
	.
	.i location="<>" d	// 不等于
	..i hisLinkQty=libLinkQty s ret=0
	.
	.i location="><" d	// 区间
	..i (hisLinkQty>$p(libLinkQty,"-",2))||(hisLinkQty<$p(libLinkQty,"-",1)) s ret=0
	
 	q ret
}

/// Description:	审查成分含量
/// Creator:		QuNianpeng(未完成)
/// CreateDate:		2017-08-16
/// Input:			进程号,医嘱项串,带审查医嘱项串,目录主索引id,返回信息
/// return:			0不通过 1通过 -100没有维护数据
/// other:		     ##class(web.DHCSTPHCMPASS).CheckSolvent(pid,ordStr,hisOrdItm,instruId,.RetMsg)
ClassMethod CheckEleCon(pid, ordStr, hisOrdItm, instruId, ByRef RetMsg As %String) As %String
{
	n (pid,ordStr,hisOrdItm,instruId,RetMsg)

    q:..GetOISeqFlag(HisOrditm)=0 1

	s HisMoeori=##class(web.DHCSTPHCMPASS).GetMainOeori(HisOrditm)
	
	
	s phecdr=$o(^DHCPHEC(0,"Inst",InstruId,""))	//DHC_PHEleCon 成分含量业务表
	q:phecdr="" 1
	q:'$D(^DHCPHEC(0,"Inst",InstruId)) 1


	q:$d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EleConRet",HisMoeori)) $g(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EleConRet",HisMoeori))

    
	s arrcnt=$l(OrdStr,$c(2))
	f i=1:1:arrcnt d
	.s itmstr=$p(OrdStr,$c(2),i)
	.s oeori=$p(itmstr,"^",12)
	.s moeori=##class(web.DHCSTPHCMPASS).GetMainOeori(oeori)
	.q:HisMoeori'=moeori
	.s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,"")) 
	.s dspqty=$p(^DHCOEDISQTY(dsp),"^",2)
	.s dspqty=1
	.s dspqty="" //dspqty*(..GetCompFlag(oeori))
	.s arcitm=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)
	.s ItemCode=$P(^ARCIM(+arcitm,$p(arcitm,"||",2),1),"^",1)
    .s phpcr=$o(^DHCPHPCO(0,"HisCode",ItemCode,""))
    .q:phpcr=""
    .i phpcr'="" s libitmcode=$p(^DHCPHPCO(phpcr),"^",1)
    .s libitmID=+$o(^DHCPHPNA(0,"Code",libitmcode,""))
	.s tInstruId=""
    .f  s tInstruId=$o(^DHCPHINSTRUC(0,"GEN",libitmID,tInstruId)) q:tInstruId=""  d
    ..s insttype=$p(^DHCPHINSTRUC(tInstruId),"^",5)
    ..q:insttype'="ProName"
    ..s phecdr=$o(^DHCPHEC(0,"Inst",tInstruId,""))
    ..
    ..q:phecdr=""
    ..
    ..S ingr=$P(^DHCPHEC(phecdr),"^",2)
    ..s ingrqty=$P(^DHCPHEC(phecdr),"^",3) //成分量
    ..
    ..s ingrqty=ingrqty*dspqty
    ..
    ..s ingrqtyuomdr=$P(^DHCPHEC(phecdr),"^",4) //成分量单位
    ..s loction=$P(^DHCPHEC(phecdr),"^",5)
    ..s ingrtotalqty=$P(^DHCPHEC(phecdr),"^",6) //总成分量
    ..
    ..
    ..s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EleConTotal",ingr)=ingrtotalqty
    ..s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EleConLoction",ingr)=loction
	..s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EleCon",moeori,ingr,oeori)=""
	..s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EleCon",moeori,ingr)=+$g(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EleCon",moeori,ingr))+ingrqty
	
	
	
	s ret=1
	s mo=""
	f  s mo=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EleCon",mo)) q:mo=""  d
	.q:mo'=HisMoeori
    .s moqty=##Class(web.DHCSTPIVA).GetTotalLiquidOe(mo) //总容量ml
    .s moqty=+moqty
	.s ingr=""
	.f  s ingr=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EleCon",mo,ingr)) q:ingr=""  d
	..s itmqty=^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EleCon",mo,ingr)
	..s itmqty=$fn(itmqty,"",4)
	..s ingrtotalqty=^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EleConTotal",ingr) 
	..
	..s flag=itmqty/moqty
	..
	..s loction=^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EleConLoction",ingr)
	..
	..i loction="!>" d
	...i flag'>ingrtotalqty d
	....s ret=1
	...e  d
	....s ret=0
	..;
	..i loction="!<" d
	...i flag'<ingrtotalqty d
	....s ret=1
	...e  d
	....s ret=0
	..;
	..i loction=">" d
	...i flag>ingrtotalqty d
	....s ret=1
	...e  d
	....s ret=0
	..;
	..
	..i loction="<" d
	...i flag<ingrtotalqty d
	....s ret=1
	...e  d
	....s ret=0
	..;
	..i loction="=" d
	...i flag=ingrtotalqty d
	....s ret=1
	...e  d
	....s ret=0
	..
	..s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"EleConRet",mo)=ret
	..
	
    
 	q ret
}

/// Description:	审查联合用药
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-16
/// Input:			进程号,医嘱项串,带审查医嘱项串,目录主索引id,返回信息
/// return:			0不通过 1通过 -100没有维护数据
/// other:		     ##class(web.DHCSTPHCMPASS).CheckMustDrug(pid,ordStr,hisOrdItm,instruId,.RetMsg)
ClassMethod CheckMustDrug(pid, ordStr, hisOrdItm, instruId, ByRef RetMsg As %String) As %String
{
	n (pid,ordStr,hisOrdItm,instruId,RetMsg)	
	q:instruId="" -100	
	
	s seqNo=$p(hisOrdItm,"^",9)  
	s groupOrdFlag=$p(seqNo,$c(1),1) //医嘱是否是关联医嘱
	s oeoriNo=$p(seqNo,$c(1),2)      //开立医嘱序号 如：主医嘱是1 则子医嘱分别是1.2 1.3
	q:+groupOrdFlag=0 -100		    //溶媒量检查只针对成组关联医嘱 	判断医嘱是否关联医嘱

	s instid=$p(hisOrdItm,"^",2)
	s instDesc=""
	i instid'="" s instCode=$p(^PHCIN(instid),"^",1),instDesc=$p(^PHCIN(instid),"^",2)  //暂时不判断输液用法为空
	;q:'(instDesc["静滴")||(instid="") 1
	q:(instid="") -100

	s hisMoeori=..GetOrdStrMainOeori(ordStr,hisOrdItm)	
	s mustDrugDr=$o(^DHCPHMD(0,"Inst",instruId,""))		//DHC_PHMustDrug 联合用药业务表
	q:mustDrugDr="" -100	
	s accDrugId=$p(^DHCPHMD(mustDrugDr),"^",2)			//关联液体
    s mustDrugId=$p(^DHCPHMD(mustDrugDr),"^",3)			//必用药品
    s location=$p(^DHCPHMD(mustDrugDr),"^",4)			//逻辑关系
    s mustQty=$p(^DHCPHMD(mustDrugDr),"^",5)			//必用药品数量
    s mustQtyUomDr=$p(^DHCPHMD(mustDrugDr),"^",6)		//必用药品剂量
    s mustQtyUomDesc=$P(^DHCPHEUO(mustQtyUomDr),"^",2)	//必用药品剂量单位
	
	i '$d(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"MustDrug")) d
	.s arrcnt=$l(ordStr,$c(2))
	.s arrcnt=$l(ordStr,$c(2))
	.f len=1:1:arrcnt d
	..s itmStr=$p(ordStr,$c(2),len)
	..s seqNo=$p($p(itmStr,"^",9),$c(1),2)			//医嘱序号
	..s oeori=$p(itmStr,"^",1)_","_seqNo_","_$p(itmStr,"^",13)
	..s moeori=..GetOrdStrMainOeori(ordStr,itmStr)  //主医嘱医嘱项id,主序号,主医嘱id
	..s ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"MustDrug",moeori,oeori)=itmStr 

	s ret=1,accFlag=0,mustFlag=0,mdoseQty=0
	s tmpoe=""
	f  s tmpoe=$O(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"MustDrug",hisMoeori,tmpoe)) Q:(tmpoe="")  d
	.s tmpArci=$p(hisOrdItm,"^",1)
	.s tmpSeqNo=$p($p(hisOrdItm,"^",9),$c(1),2)
	.s tmpOeori=$p(hisOrdItm,"^",13)
	.s tmpOeori=tmpArci_","_tmpSeqNo_","_tmpOeori
	.q:tmpOeori=tmpoe	
	.s arci=$p(tmpoe,",",1)
	.s hisProCode=$P(^ARCIM(+tmpoe,$p(arci,"||",2),1),"^",1)
	.s conProDr=$o(^DHCPHPCO(0,"HisCode",hisProCode,""))
    .q:conProDr=""
    .s libProCode=$p(^DHCPHPCO(conProDr),"^",1)
    .s libProId=+$o(^DHCPHPNA(0,"Code",$ZCONVERT(libProCode,"U"),""))
	.q:libProId=0
	.i libProId=accDrugId s accFlag=1
    .i libProId=mustDrugId d
    ..s mustFlag=1    
    ..s hisLinkQty=$p($g(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"MustDrug",hisMoeori,tmpoe)),"^",4)			//溶媒剂量
	..s hisLinkUomDr=$p($g(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,"MustDrug",hisMoeori,tmpoe)),"^",5)		//溶媒剂量
	..s hisLinkUomDesc=$p(^CT("UOM",hisLinkUomDr),"^",2)  //取单位描述
	..s:mustQtyUomDesc'=hisLinkUomDesc hisLinkQty=..GetDosageFactorNew(arci,hisLinkQty_"^"_hisLinkUomDr,mustQtyUomDesc) 
    ..s:hisLinkQty="" ret=1 
    ..q:hisLinkQty=""
	
    i accDrugId'="" q:accFlag=0 1
    i mustDrugId'="" q:mustFlag=0 0  //医嘱里没有必用药,不通过

    i (hisLinkQty="")||(mustQty="") q 1

    i location=">" d
	.i hisLinkQty<=mustQty s ret=0

    i location="<" d
	.i hisLinkQty>=mustQty s ret=0

    i location="!>" d
    .i hisLinkQty>mustQty s ret=0
	
    i location="!<" d
    .i hisLinkQty<mustQty s ret=0

    i location="=" d
    .i hisLinkQty'=mustQty s ret=0
    
    i location="<>" d
    .i hisLinkQty=mustQty s ret=0

    q ret
}

/// KM 27-Jun-2001: Called from component  MRDiagnos.ListEMR
Query Find(mradm As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,mradm,MRDIAICDCodeDR,MRDIAICDCodeDRDesc,MRDIAICDCodeDRCode,MRDIADate:%Date,MRDIATime:%Time,MRDIADesc:%List,MRDIAUpdateUserDRSSUSRName")
{
SELECT MRDIA_RowID, MRDIA_MRADM_ParRef, MRDIA_ICDCode_DR, MRDIA_ICDCode_DR->MRCID_Desc, MRDIA_ICDCode_DR->MRCID_ICD9CM_Code, MRDIA_Date, MRDIA_Time, MRDIA_Desc, MRDIA_UpdateUser_DR->SSUSR_Name
FROM SQLUser.MR_Diagnos
WHERE MRDIA_MRADM_ParRef = :mradm
}

/// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// ///////////////////////////////////////////////////检验子库审查函数和其他辅助函数////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ClassMethod GetMRDiagnosDesc(MRAdmRowid As %String, DelimStr As %String) As %String
{
 n (MRAdmRowid,DelimStr)
 q:MRAdmRowid="" ""
 s MRAdmRowid=$p(^PAADM(MRAdmRowid),"^",61)
 q:MRAdmRowid="" ""
 s retval=""
 s i=0
 //Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find") 	// 复制出接口，修改中的诊断代码取值字段，MRCID->Code,改为 MRCID_ICD9CM_Code 2020/2/21
 Set obj=##class(%ResultSet).%New("web.DHCSTPHCMPASS:Find")
 d obj.Execute(MRAdmRowid)
 For  Quit:'obj.Next()  Do
 .s Desc=obj.Data("MRDIAICDCodeDRDesc")		// icd诊断描述
 .s Rowid=obj.Data("ID")
 .s CodeRowid=obj.Data("MRDIAICDCodeDR")	// icd诊断id
 .s MRCode=obj.Data("MRDIAICDCodeDRCode")	// icd诊断代码
 .i CodeRowid=""  d
 ..s MRDesc=$List(obj.Data("MRDIADesc"),1)	// 非icd诊断
 ..s MRCode=MRDesc
 .//q:CodeRowid=""
 .//s MRDesc=$p(^MRC("ID",CodeRowid),"^",1) 
 .
 .//if MRDesc'="" s MRDesc=$LIST(MRDesc,1)
 .//i Desc="" s Desc=MRDesc
 .//e  d
 .//.i MRDesc'="" s Desc=Desc_"("_MRDesc_")"
 .//s i=i+1
 .//s Desc=i_"."_Desc
 .s Desc=MRCode
 .if retval="" s retval=Desc
 .e  s retval=retval_DelimStr_Desc
 d obj.Close()
 q $ZCVT($g(retval),"O","JS")
}

ClassMethod GetLastVal(pid, node) As %String
{
	n (pid, node)

	s rulerelat="&"
	s ret=""
	s onestr=""
	s index=""
	f  s index=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,node,index)) q:index=""  d
	.s main=""
	.f  s main=$o(^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,node,index,main)) q:main=""  d
	..s str=^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,node,index,main)
	..
	..s val=$p(str,$c(1),1)
	..//q:val=""
	..i onestr="" d
	...i rulerelat="&" s onestr=1&val
	...i rulerelat="||" s onestr=0||val
	..e  d
	...i rulerelat="&" s onestr=onestr&val
	...i rulerelat="||" s onestr=onestr||val
	
	 
	
    s ret=onestr
    
    k ^TMP("DHCST","DHCSTPHCMPASS","CheckLibPha",pid,node)
    
    i ret="" q 1
	q ret
}

/// 验证特殊人群
/// return:1是特殊人群 0不是特殊人群 -100 没有维护特殊人群
/// ##class(web.DHCSTPHCMPASS).CheckSepPeople(InstruId,AdmInfo,.RetMsg)
ClassMethod CheckSepPeople(instruId, admInfo, ByRef RetMsg As %String) As %String
{
	n (instruId,admInfo,RetMsg)
	//q:'$d(^DHCLIBSPEPI(0,"Inst",instruId))||(instruId="")||(admInfo="") -100
	q:'$d(^DHCLIBSPEPI(0,"Inst",instruId))||(instruId="") -100
	s RetMsg=""

	i admInfo["妊娠" s patPlan="Y"
    i admInfo["更年期" s patClimac="Y"
    i admInfo["经期" s patMens="Y"
    i admInfo["哺乳" s patLac="Y"
    i admInfo["孕妇" s patPre="Y"
    i admInfo["肝功" s patLiver="Y"
    i admInfo["肾功" s patRen="Y"
    
    s ret=0
    s exist=0
    s speppi="" 
	f  s speppi=$o(^DHCLIBSPEPI(0,"Inst",instruId,speppi)) q:speppi=""  d	//DHC_LibSpecPopuItm 特殊人群业务表
	.s tmpSepcDr=$p(^DHCLIBSPEPI(speppi),"^",2)
	.q:tmpSepcDr=""
	.s tmpSepc=$p($g(^DHCSPEP(tmpSepcDr)),"^",2)	//DHC_SpecialPopu 特殊人群字典表
	.s exist=1
	.i tmpSepc["哺乳"  d
	..i admInfo["哺乳" s ret=1
	.i tmpSepc["孕妇"  d
	..i admInfo["孕妇" s ret=1
	.i tmpSepc["经期"  d
	..i admInfo["经期" s ret=1
	.i tmpSepc["妊娠"  d
	..i admInfo["妊娠" s ret=1
	.i tmpSepc["肝功"  d
	..i admInfo["肝功" s ret=1
	.i tmpSepc["肾功"  d
	..i admInfo["肾功" s ret=1
	.i tmpSepc["更年期妇女"  d
	..i admInfo["更年期妇女" s ret=1
	.i tmpSepc'="" d	// 知识库维护了特殊人群,但his没有特殊人群，此时认为前提条件不满足 2018/7/23 qunianpeng
	..s:admInfo="" ret=0
    
	q:exist=0 -100  //表示没有维护忽略

	q ret
}

/// 获取特殊人群
ClassMethod GetSpecPopuFlag(Code, Adm) As %String
{
	n (Code,Adm)
	s patnameid=$p(^PAADM(Adm),"^",1)   
    s patid=$p(^PAPER(patnameid,"ALL"),"^",1)      
	s ret=""
	s spepdr=$o(^DHCSPEP(0,"Code",Code,""))
	q:spepdr="" ""
	s sub=""
	f  s sub=$o(^DHCSPEP(spepdr,"LAB",sub)) q:sub=""  d
	.s labitmdr=$p(^DHCSPEP(spepdr,"LAB",sub),"^",1)
	.s instgendr=$p(^DHCLABIF($p(labitmdr,"||",1),"VAL",$p(labitmdr,"||",2)),"^",1)
	.s instgencode=$p(^DHCPHEGEN(instgendr),"^",1)
	.s val=$p(^DHCLABIF($p(labitmdr,"||",1),"VAL",$p(labitmdr,"||",2)),"^",2)
	.s exist=0
	.s hisgencode=""
	.f  s hisgencode=$o(^DHCPHGENCON(0,"Code",instgencode,hisgencode)) q:hisgencode=""  d
	..f datadate=DateFrom:1:DateTo  d
	...q:'$d(^DHCPHLIBDP(0,"PatDate",patid,datadate,"Lab",hisgencode))
	...s exist=1
	.q:exist=0
	.i val="H" s ret="Y"
	.
	q ret
}

/// 获取医嘱项的外部代码
ClassMethod GetTestCode(arcim) As %String
{
	n (arcim)
	Quit:$g(arcim)="" ""
	Quit:'$d(^ARCIM(+arcim,1,"EXT")) ""
	Set Ext=$o(^ARCIM(+arcim,1,"EXT",0))
	Quit:$g(Ext)="" ""
	Set ExtCode=$p(^ARCIM(+arcim,1,"EXT",Ext),"^",4)
	Quit ExtCode
}

/// Lis旧版获取标本编码
/// w ##class(web.DHCSTPHCMPASS).GetTestSetSpecimen("")
ClassMethod GetTestSetSpecimen(arcim) As %String
{
	n (arcim)
	s TestCode=..GetTestCode(arcim)
	q:TestCode="" ""
	s FirstSpecimen=""
    i $d(^DHCLISBSVersion(1))  s FirstSpecimen=##Class(DHCLIS.DHCCommon).GetTestSetSpecimen(TestCode,"") //标本代码
    q:$d(^DHCLISBSVersion(1)) FirstSpecimen
	
	Set FirstSpecimen=$o(^TTAB("TS",TestCode,1,""))
	Set Specimendr=""
	set Convolumn=""
	Set Defaultflag="N"
	For  Set Specimendr=$o(^TTAB("TS",TestCode,1,Specimendr)) Q:(Specimendr="")!(Defaultflag="Y")  Do
	.Set Container=$o(^TTAB("TS",TestCode,1,Specimendr,""))
	.i Container'="" d
	..Set Specimenflag=$g(^TTAB("TS",TestCode,1,Specimendr,Container))
	..If Specimenflag="1" Set FirstSpecimen=Specimendr,Defaultflag="Y"
	..set Convolumn=$p($g(^TTAB("TS",TestCode,"SC",Container,Specimendr)),"\",1)

	Quit FirstSpecimen
}

/// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// ///////////////////////////////////////////////////检查子库审查函数和其他辅助函数////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// 检查病人血压
ClassMethod CheckPatPres(LibPatPresc, PatPresStr, ByRef RetMsg As %String) As %String
{
	s RetMsg=""
	q:LibPatW="" 1

	s PatPMin=$p(PatPresStr,"^",1)
	s PatPMax=$p(PatPresStr,"^",2)
	
	s ret=1
	i (LibPatPresc<PatWMin)&(PatPMin'="") d
	.s RetMsg="血压不符"
	.s ret=0
	i (LibPatPresc>PatPMax)&(PatWMax'="") d
	.s RetMsg="血压不符"
	.s ret=0

	q ret
}

/// Description: 	检验结果辅助诊断
/// Creator:		QuNianpeng
/// CreateDate:		2017-03-31
/// Input:			adm,检验项目通用名code,检验项目标准码,标本
/// return:			Lib检验结果
/// other:
/// w ##class(web.DHCSTPHCMPASS).GetLibHelpDisInfo(41,"A0001","WBC","SP02")
/// w ##class(web.DHCSTPHCMPASS).GetLibHelpDisInfo(41,"S0004","ALT","SP004")
/// w ##class(web.DHCSTPHCMPASS).GetLibHelpDisInfo("69","L0025","CSYJJ","SP001","11"_$c(2)_"A")
ClassMethod GetLibHelpDisInfo(adm, libHisCode, genextHisCode, pointerHisCode, lisResult) As %String
{
	//思路：
	//	1.在通用名和知识库通用名中，判断通用名是否对照，若没有，则返回  检验项目未跟知识库对照
	//	1.1 根据通用名，从检验通用名检验属性表和检验通用名与标本关联表 取出标准码和标本；判断标准码是否一致，标本是否对照；没有，返回未对照
	//	1.2 对照后，用adm和标准码从his中取检验项目结果值，与知识库中检验项目值进行比较，取对应描述
	//  1.3 若his中检验结果值，为空(没做检验) 返回知识库中对应标准码的其他结果值字段
	
	n (adm, libHisCode, genextHisCode, pointerHisCode,lisResult)
	s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()
	s rtnMsg=""
	s genid=""
	s libPointer=""
	
	i '$d(^DHCPHGENCON(0,"HisCode",libHisCode)) s rtnMsg="检验项目未对照"    //检验项目是否和知识库对照
	i rtnMsg'="" q rtnMsg

	i $d(^DHCPHGENCON(0,"HisCode",libHisCode)) d		
	.s gictRowId=$o(^DHCPHGENCON(0,"HisCode",libHisCode,"")) 
	.s gictTCode=$p(^DHCPHGENCON(gictRowId),"^",1)
	.;s genId(^DHCPHGENCON(gictRowId),"^",7)
	.s genId=$o(^DHCPHEGENi(0,"Code",$ZCONVERT(gictTCode,"U"),""))	
	.//取知识库标准码
	.s lgpRowId=$o(^DHCLISGPi(0,"Gen",$ZCONVERT(genId,"U"),""))
	.s genexLibCode=$p(^DHCLISGP(lgpRowId),"^",2)	
	.//取知识库标本代码
	.s glpRowId=$o(^DHCGENLINPi(0,"Gen",$ZCONVERT(genId,"U"),""))
	.q:glpRowId=""  
	.s libPointer=$p(^DHCGENLINP(glpRowId),"^",2)	//知识库检验项目关联的检验标本
	.s pointerLibCode=$p(^DHCPHEGEN(libPointer),"^",1)	
	.// 标准码或标本是否对照
	.i (genexLibCode'=genextHisCode)||('$d(^DHCPHGENCON(0,"Code",pointerLibCode,pointerHisCode))) s rtnMsg="标准码或标本未对照"
	i rtnMsg'="" q rtnMsg	
	
	//取his检验项目的结果
	//s hisStr=##class(LabService.TCResult).GetTCReesultByAdmNo(adm,genextHisCode)
	//qunianpeng  2017/9/27 检验结果不取，检验组调用接口时,直接传检查结果
	s hisNormal=$p($p(lisResult,$c(2),1),"(",1)
	s hisAbFlag=$p(lisResult,$c(2),2)
	s hisNegative=$p(lisResult,$c(2),1)

	s h=0
	s instruId=""	
	f  s instruId=$o(^DHCPHINSTRUC(0,"GP",genId,"Form",libPointer,instruId)) q:instruId=""  d
	.;s plrdRowId=""	
	.s plrdRowId=$o(^DHCPHLRD("0","Inst",instruId,""))
	.q:plrdRowId=""
	.s libNormal=$p(^DHCPHLRD(plrdRowId),"^",2)
	.s libNormalMin=+$p(libNormal,"-",1) ; 0
	.s libNormalMax=$p(libNormal,"-",2) ;0.1 
	.i (hisNormal<libNormalMin)||((libNormalMax'="")&&(hisNormal>libNormalMax)) s ^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid,h)="正常范围值:"_libNormal							
	.i hisAbFlag["H" s ^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid,h)=$g(^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid,h))_"^"_"结果值升高:"_$p(^DHCPHLRD(plrdRowId),"^",3)		      //升高
	.i hisAbFlag["L" s ^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid,h)=$g(^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid,h))_"^"_"结果值降低:"_$p(^DHCPHLRD(plrdRowId),"^",4)		      //降低
	.i hisNegative["阴" s ^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid,h)=$g(^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid,h))_"^"_"结果值阴性:"_$p(^DHCPHLRD(plrdRowId),"^",5)	      //阴性
	.i hisNegative["阳" s ^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid,h)=$g(^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid,h))_"^"_"结果值阳性:"_$p(^DHCPHLRD(plrdRowId),"^",6)        //阳性	
	.i ($g(^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid,h))="")&&($p(^DHCPHLRD(plrdRowId),"^",7)'="") s ^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid,h)="结果值其他:"_$p(^DHCPHLRD(plrdRowId),"^",7)			    		  //其他
	.i ($g(^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid,h))="")&&($p(^DHCPHINSTRUC(instruId),"^",15)'="") s ^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid,h)="异常描述:"_$p(^DHCPHINSTRUC(instruId),"^",15)						  //描述
	.s h=h+1

	s index=""
	f  s index=$o(^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid,index)) q:index=""  d
	.i index=0 d
	..s rtnMsg=$g(^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid,index))
	.i index>0 d
	..s rtnMsg=rtnMsg_"!"_$g(^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid,index))
	
	s rtnMsg="检验结果辅助诊断@"_rtnMsg
	k ^TMP("DHCPH","web.DHCSTPHCMPASS","GetLibHelpDisInfo",pid)
	q rtnMsg
}

/// Description:	验证检查结果
/// Creator:		QuNianpeng
/// CreateDate:		2017-03-24
/// Input:			Adm=就诊id,Hispart=部位id,主索引表ID,返回值
/// return:			0,1 0不通过 1 通过
/// other:
/// w ##class(web.DHCSTPHCMPASS).CheckLibExaRet()
ClassMethod CheckLibExaRet(adm, hispart, instruId, ByRef RetMsg As %String) As %String
{
	
	n (adm,hispart,instruId,RetMsg)
	
	s ret=""
	//没有维护检查结果，则默认通过
	q:'$d(^DHCLIBEXAI("0","Inst",instruId)) -100 //没有维护检查结果
	q:hispart="" -100  //检查部位为空(传参时空被转化为NULL)
	
	s flag=0
	i hispart'="NULL" d
	.s hispartCode=$p(^DHCAPPART(hispart),"^",1)  //检查部位描述
	.//判断检查部位是否和知识库检查部位对照
	.i '$d(^DHCPHPACON(0,"HisCode",hispartCode)) d
	.s flag=1
	//检查部位没有和知识库对照
	q:flag=1 -100  
	
	s type="E"  //检查结果关键字
 	//通过adm取到his中检查结果(中间表)  (中间表增加索引,^DHCPHLIBDP(0,"Adm",Adm,Type))
	q '$d(^DHCPHLIBDP(0,"Adm",adm,type))	//检查结果不存在
	s phRowId=$o(^DHCPHLIBDP(0,"Adm",adm,type,""),-1)   //最近一次检查结果
	s hisLibExaRetKey=$p(^DHCPHLIBDP(phRowId),"^",11)	//检查结果关键字
	s hisLibExaRet=""
	i hisLibExaRetKey'="" s hisLibExaRet=$p(^DHCEXAMINE(hisLibExaRetKey),"^",2)
	q:hisLibExaRet="" -100
	//取知识库检查结果
	s exaiRowId=""
	f  s exaiRowId=$o(^DHCLIBEXAI("0","Inst",instruId,exaiRowId))  q:exaiRowId=""  d //检查业务表
	.s exaiIExamDr=$p(^DHCLIBEXAI(exaiRowId),"^",2)		//检查结果id
	.q:exaiIExamDr="" 
	.s exaResult=$p(^DHCEXAMINE(exaiIExamDr),"^",2)  //知识库检查结果
	.i '(exaResult[hisLibExaRet) d	
	..s ret=0
	.
	i ret=0 s retMsg="检查结果"_hisLibExaRet_",不在限定范围;"
	
	q:$g(ret)="" -100
	q ret
}

/// Description:	验证检验指标
/// Creator:		QuNianpeng
/// CreateDate:		2017-03-24
/// Input:			Adm,主索引表ID,返回值
/// return:			0,1 0不通过 1 通过 -100 没有维护
/// other:
/// w ##class(web.DHCSTPHCMPASS).CheckLibLab(Adm,InstruId,.RetMsg )
ClassMethod CheckLibLab(adm, instruId, ByRef RetMsg As %String) As %String
{
	n (adm,instruId,RetMsg)

	s flag=0
	s RetMsg=""
	s ret=""
	s libLabi=$o(^DHCLIBLABI(0,"Inst",instruId,""))		//DHC_LibLabItm 检验指标业务表
	q:libLabi="" -100  //没有维护检验指标
	
	s labGenextCode=""
	s labGencDr=$p(^DHCLIBLABI(libLabi),"^",2)			//DHCPHExtGeneric 检验指标通用名
	q:labGencDr="" -100
	s lisGpi=$o(^DHCLISGPi(0,"Gen",$ZCONVERT(labGencDr,"U"),""))  	// DHC_LisGenPro 通用名检验属性表
    q:lisGpi="" -100
    s labGenextCode=$p(^DHCLISGP(lisGpi),"^",2) 		//检验项目标准码
    q:labGenextCode="" -100	// 标准码为空
    s hisLabVal=""
	i ##class(websys.Conversions).IsValidClassName("web.DHCENS.STBLL.Method.PostReportInfo")=1 d	// 使用新接口获取检验值 2020/2/26 qunianpeng
	.s result = ##Class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QryTCResultBySync")
	.d result.Execute(adm,"",labGenextCode)	// 就诊号,登记号,标准码,审核日期,审核时间
	.For  Quit:'result.Next()  Do
 	..s hisLabVal=result.Data("TCRes")		// icd诊断描述
 	e  d	 	
	.s labRetStr=##class(LabService.TCResult).GetTCReesultByAdmNo(adm,labGenextCode)
	.q:$g(labRetStr)="" 
	.s patLabRetVal=$p(labRetStr,$Char(2),3) //检验结果值his	
	.q:patLabRetVal=""
	.i patLabRetVal["(" s hisLabVal=$p(patLabRetVal,"(",1)
	.i patLabRetVal'["(" s hisLabVal=patLabRetVal

	q:hisLabVal="" -100
	
	s libLabMin=$p(^DHCLIBLABI(libLabi),"^",4)  //知识库检验最大值 DHC_LibLabItm 检验指标业务表
	s libLabMax=$p(^DHCLIBLABI(libLabi),"^",3)  //知识库检验最小值
	s reation=$p(^DHCLIBLABI(libLabi),"^",6)	//逻辑关系
	q:(libLabMin="")&(libLabMax="") -100		// 极限值同时为空时，忽略
	s flag=1
	// > 逻辑处理		
	i reation=">" d								// 最大值为空时，与最小值比较
	.i ((libLabMax'="")&(hisLabVal>libLabMax)) ||((libLabMax="")&(hisLabVal>libLabMin)) d
	..s ret=1
	.e  d
	..s ret=0
	
	// < 逻辑处理			
	i reation="<" d								// 	最小值为空时，与最大值比较		
	.i ((libLabMin'="")&(hisLabVal<libLabMin)) ||((libLabMin="")&(hisLabVal<libLabMax)) d
	..s ret=1	
	.e  d
	..s ret=0
	
	// !> 逻辑处理								// 小于等于 优先以最小值为参考依据
	i reation="!>" d
	.i ((libLabMin'="")&(hisLabVal<=libLabMin))||((libLabMin="")&(hisLabVal<=libLabMax)) d
	..s ret=1 
	.e  d
	..s ret=0
			
	// !< 逻辑处理								// 大于等于 优先以最小值为参考依据
	i reation="!<" d
	.i ((libLabMax'="")&(hisLabVal>=libLabMax))||((libLabMax="")&(hisLabVal>=libLabMin)) d
	..s ret=1 
	.e  d
	..s ret=0

	// <> 逻辑处理(不等于)
	i reation="<>" d
	.i ((libLabMin'="")&(+hisLabVal'=+libLabMin))||((libLabMax'="")&(+hisLabVal'=+libLabMax)) d
	..s ret=1
	.e  d
	..s ret=0

	// = 逻辑处理	
	i reation="=" d
	.i (+hisLabVal=+libLabMax)||(+hisLabVal=+libLabMin) d
	..s ret=1
	.e  i (hisLabVal<=libLabMax)&(hisLabVal>=libLabMin) d	// 标准版逻辑中没有区间了 2020/2/26
	..s ret=1
	.e  d
	..s ret=0

	// >< 区间
	i reation="><" d
	.i (hisLabVal<=libLabMax)&(hisLabVal>=libLabMin) d
	..s ret=1
	.e  d 
	..s ret=0
	
	q:flag=0 -100 //中途退出，未进行检测
	q:$g(ret)="" -100

	q ret
}

/// Description:	验证治疗手术结果
/// Creator:		QuNianpeng
/// CreateDate:		2017-03-27
/// Input:			adm,主索引表ID,返回值
/// return:			0不通过 1 通过
/// other:
/// w ##class(web.DHCSTPHCMPASS).CheckCure()
ClassMethod CheckCure(adm, instruId, ByRef RetMsg As %String) As %String
{
	
	n (adm,instruId,RetMsg)

	s ret=0
	q:'$d(^DHCPHCU("0","Inst",instruId)) -100 //没有维护手术

	s type="C"  //治疗手术类型

	//通过adm取到病人his中手术(数据池)
	q:'$d(^DHCPHLIBDP(0,"Adm",adm,type)) -100
	s phRowId=$o(^DHCPHLIBDP(0,"Adm",adm,type,""),-1)  //取最近一次手术业务
	s hisCureKey=$p(^DHCPHLIBDP(phRowId),"^",11)  		//手术关键字
	s admHisCureType=""
	i hisCureKey'="" s admHisCureType=$p(^DHCPHKW(hisCureKey),"^",5)
	q:admHisCureType'=1 -100  //退出不是手术的类型
	s admHisCure=$p(^DHCPHKW(hisCureKey),"^",2)   //his手术描述
	q:admHisCure="" -100

	//取知识库中手术
	s cureID=""
	f  s cureID=$o(^DHCPHCU(0,"Inst",instruId,cureID)) q:(cureID="")||(ret=1)  d
	.s cuKeyWordDr=$p(^DHCPHCU(cureID),"^",2)
	.q:cuKeyWordDr="" 
	.s activeFlag=$p(^DHCPHKW(cuKeyWordDr),"^",3)  //是否启用标志Y/N
	.q:activeFlag="N" 	
	.s typeFlag=$p(^DHCPHKW(cuKeyWordDr),"^",5)  //类型标志0 症状 1治疗手术	
	.i (typeFlag'="")&&(typeFlag=1) d
	..s cureCode=$p(^DHCPHKW(cuKeyWordDr),"^",2) //治疗手术描述
	..i (cureCode[admHisCure) d
	...s ret=1
	..
	.
	;i Ret=0 s RetMsg="手术结果"_AdmHisCure_",不在限定范围: "_CureCode
	i ret=0 s retMsg="手术结果"_admHisCure_",不在限定范围;"

	q ret
}

/// Description:	验证症状业务结果
/// Creator:		QuNianpeng
/// CreateDate:		2017-03-27
/// Input:			adm,主索引表ID,返回值
/// return:			0,1 0不通过 1 通过
/// other:
/// w ##class(web.DHCSTPHCMPASS).CheckSymptom()
ClassMethod CheckSymptom(adm, instruId, ByRef RetMsg As %String) As %String
{
	
	n (adm,instruId,RetMsg)

	s ret=0	
	q:'$d(^DHCPHSYM("0","Inst",instruId)) -100 //没有维护症状
	
	s type="D"  //症状类型

	//通过adm取到病人his中症状(数据池)
	q:'$d(^DHCPHLIBDP(0,"Adm",adm,type)) -100
	s phRowId=$o(^DHCPHLIBDP(0,"Adm",adm,type,""),-1)  //取最近一次症状业务
	s hisSymKey=$p(^DHCPHLIBDP(phRowId),"^",11)  		//手术关键字
	s admHisSymType=""
	i hisSymKey'="" s admHisSymType=$p(^DHCPHKW(hisSymKey),"^",5)
	q:admHisSymType'=0 -100  //退出不是症状的类型
	s admHisSym=$p(^DHCPHKW(hisSymKey),"^",2)   //his症状描述	
	q:admHisSym="" -100

	//取知识库中症状
	s symID=""
	f  s symID=$o(^DHCPHSYM(0,"Inst",instruId,symID))  q:(symID="")||(ret=1)  d //DHC_PHSymptom
	.s symKeyWordDr=$p(^DHCPHSYM(symID),"^",2)
	.q:symKeyWordDr=""
	.s activeFlag=$p(^DHCPHKW(symKeyWordDr),"^",3)  //是否启用标志Y/N
	.q:activeFlag="N"	
	.s typeFlag=$p(^DHCPHKW(symKeyWordDr),"^",5)  //类型标志0 症状 1治疗手术	
	.i (typeFlag'="")&&(typeFlag=0) d
	..s symCode=$p(^DHCPHKW(symKeyWordDr),"^",2) //症状描述
	..i (symCode[admHisSym) d
	...s ret=1
	..
	.
	i ret=0 s RetMsg="症状结果"_admHisSym_",不在限定范围;"
	
	q ret
}

/// Description: 根据诊断关联病症,病症关联特殊人群,获取与特殊人群相关的病人诊断 
/// Creator:     CongYue
/// CreateDate:  2017-03-30
/// Input:  	 PatIcd:病人诊断代码 以逗号进行分割
/// Return: 	 AdmInfo:病人诊断信息
/// Others:		 w ##class(web.DHCSTPHCMPASS).GetAdmInfo("ZYZD002571,cs,ZYZD002572")
ClassMethod GetAdmInfo(PatIcd) As %String
{
	n (PatIcd)

	s lkm=0
	s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid() 
	s cnt=$l(PatIcd,",")
	S AdmInfo=""
	
	f lk=1:1:cnt d
	.s code=$p(PatIcd,",",lk)
	.q:code=""
	.s icdid=$o(^DHCEXTICD(0,"Code",$ZCONVERT(code,"U"),"")) ;诊断id
	.q:icdid=""
	.s icddesc=$p(^DHCEXTICD(icdid),"^",2) ;诊断描述
	.s disrowid="" ;病症字典表 id
	.f  s disrowid=$o(^DHCPHDISL(0,"ICD",icdid,disrowid)) q:disrowid=""  d
	..q:disrowid=0
	..s sub=$o(^DHCPHDISL(0,"ICD",icdid,disrowid,"")) ;病症与诊断关联表 id
	..q:sub=""
	..s poid="" ;特殊人群表 id
	..f  s poid=$o(^DHCSPEP(0,"DIS",disrowid,poid)) q:poid=""  d
	...s posub=$o(^DHCSPEP(0,"DIS",disrowid,poid,"")) ;病症与特殊人群关联表 id
 	...q:posub=""
	...s podesc=$p(^DHCSPEP(poid),"^",2) ;特殊人群描述
	...s:podesc'="" AdmInfo=podesc_","_AdmInfo ;如果该诊断与病症关联并且此病症关联特殊人群，那诊断描述赋值为特殊人群描述
	..
	.
	
	q AdmInfo
}

/// Description: 根据既往史获取特殊人群
/// Creator:     QuNianpeng
/// CreateDate:  2017-04-10
/// Input:  	 adm:病人就诊号 Type:类型(B既往史)
/// Return: 	 admInfo:病人诊断信息
/// Others:		 w ##class(web.DHCSTPHCMPASS).GetAdmInfoByDisHistory()
ClassMethod GetAdmInfoByDisHistory(adm, type) As %String
{
	n (adm,type)
	s admInfo=""
	//通过adm取到病人既往史(数据池)
	q:'$d(^DHCPHLIBDP(0,"Adm",adm,type)) ""
	s phRowId=$o(^DHCPHLIBDP(0,"Adm",adm,type),-1)  //取最近一次既往史
	s hisDisHistorKey=$p(^DHCPHLIBDP(phRowId),"^",11)
	q:hisDisHistorKey="" ""	
	q:'$d(^DHCSPEP(0,"DH",hisDisHistorKey)) ""   //特殊人群没有和既往史关联
	
	s spePoId=""  //特殊人群字典表id
	f  s spePoId=$o(^DHCSPEP(0,"DH",hisDisHistorKey,spePoId)) q:spePoId=""  d //通过既往史获取特殊人群(特殊人群和既往史关联表)
	;q:spePoId="" ""
	.s spePoDesc=$p(^DHCSPEP(spePoId),"^",2)
	.i spePoDesc'="" s admInfo=spePoDesc_","_admInfo
	
	q admInfo
}

/// Description: 根据检查结果获取特殊人群
/// Creator:     QuNianpeng
/// CreateDate:  2017-04-10
/// Input:  	 adm:病人就诊号 Type:类型(E检查结果)
/// Return: 	 admInfo:病人诊断信息
/// Others:		 w ##class(web.DHCSTPHCMPASS).GetAdmInfoByLisRet()
ClassMethod GetAdmInfoByLisRet(adm, type) As %String
{
	n (adm,type)
	s admInfo=""
	//通过adm取到病人检查结果(数据池)
	q:'$d(^DHCPHLIBDP(0,"Adm",adm,type)) ""
	s phRowId=$o(^DHCPHLIBDP(0,"Adm",adm,type),-1)  //取最近一次检查结果
	s hisLabItmKey=$p(^DHCPHLIBDP(phRowId),"^",11)  
	q:hisLabItmKey="" ""
	q:'$d(^DHCSPEP(0,"EXA",hisLabItmKey)) "" //特殊人群没有和检查结果关联
	
	s spePoId=""
	f  s spePoId=$o(^DHCSPEP(0,"EXA",hisLabItmKey,spePoId))  q:spePoId=""  d //通过检查结果获取特殊人群(特殊人群和检查结果关联表)
	.s spePoDesc=$p(^DHCSPEP(spePoId),"^",2)
	.i spePoDesc'="" s admInfo=spePoDesc_","_admInfo
	
	q admInfo
}

/// Description: 根据检验条目关联检验指标,特殊人群关联检验条目  获取特殊人群
/// Creator:     QuNianpeng
/// CreateDate:  2017-04-10
/// Input:  	 adm:病人就诊号 Type:类型(F检验指标)
/// Return: 	 admInfo:病人诊断信息
/// Others:		 w ##class(web.DHCSTPHCMPASS).GetAdmInfoByLabItm()
ClassMethod GetAdmInfoByLabItm(adm, type) As %String
{
	n (adm,type)
	s admInfo=""
	//通过adm取到病人检验指标(数据池)
	i '$d(^DHCPHLIBDP(0,"Adm",adm,type)) q ""
	s phRowId=$o(^DHCPHLIBDP(0,"Adm",adm,type),-1)  //取检验指标
	s hisLabItmKey=$p(^DHCPHLIBDP(phRowId),"^",11)   
	s labItmFeId=$o(^DHCLABIF(0,"VAL",hisLabItmKey,""))		//通过检验指标取检验条目
	q:'$d(^DHCSPEP(0,"LAB",labItmFeId)) ""      //特殊人群没有和检验条目关联
	s spePoId=""
	f  s spePoId=$o(^DHCSPEP(0,"LAB",labItmFeId,spePoId)) q:spePoId=""  d		//根据检验条目取特殊人群
	.s spePoDesc=$p(^DHCSPEP(spePoId),"^",2)
	.i spePoDesc'="" s admInfo=spePoDesc_","_admInfo
	.
	q admInfo
}

/// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// ///////////////////////////////////////////////////Q类型辅助诊断查询相关/////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Description:	适应,禁忌,不良反应,注意事项,采集,临床意义,
/// Creator:		(QuNianpeng 修改)
/// CreateDate:		(2017-08-21修改)
/// Input:			医嘱项id,医嘱id串
/// return:			效验结果
/// other:	
ClassMethod GetLibDataForWin(arci, hisPart, ordItem) As %String
{
	n (arci,hisPart,ordItem)    
    
    s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()
  
    s insnum=0
    s oeori=$p(ordItem,$c(2),1)
    s ord=$p(oeori,"||",1)
    s ordSub=$p(oeori,"||",2)
    i ord'="" d
    .i arci="" s arci=$p(^OEORD(ord,"I",ordSub,1),"^",2)
    
    s sub=$p(arci,"||",1),ver=$p(arci,"||",2)
    
    s pointer="",instType="Form"   
    s commonType=""
    s orderType=..GetOrdType(arci)		// 医嘱类型
	i orderType="R" s commonLibInfo=..GetLibNameByDrug(arci),commonType="R"		// 药品医嘱
	i orderType="L" s commonLibInfo=..GetLibNameByLab(arci,hisPart),commonType="L"		// 检验医嘱 
	i orderType="N" s commonLibInfo=##class(web.DHCSTPHCMPASSFUN).GetLibNameByTreat(arci),commonType="N"	//治疗项目医嘱
	q:((sub="")||(ver="")) ""
	s serverMaterial=$p($g(^ARCIM(sub,ver,7)),"^",6)	
	i serverMaterial="S" s commonLibInfo=..GetLibNameByLis(arci,hisPart),commonType="S" //检查医嘱
	q:$g(commonLibInfo)="" ""
	s hisGeneDesc=$p(commonLibInfo,"^",1) // 通用名描述
	s libGenDr=$p(commonLibInfo,"^",2) 	  // 知识库通用名id
	s libProDr=$p(commonLibInfo,"^",3)    // 知识库商品名id
	s pointer=$p(commonLibInfo,"^",4)     // 剂型/部位/标本	
	q:(libGenDr="")&(libProDr="")||($g(pointer)="") ""
						
	i libProDr'=""  d					  // 通用名和商品名同时存在的情况下，优先通用名
	.s ^TMP("DHCST","DHCSTPHCMPASS","GetLibDataForWin",pid,"Gen",libProDr,pointer)=""
	.s instType="ProName"		 		 
   	e  d
	.s ^TMP("DHCST","DHCSTPHCMPASS","GetLibDataForWin",pid,"Gen",libGenDr,pointer)=""

	///格式如下：　适应症@项目$c(2)部位/$222/n333/*部位2/$444/n555$c(13)项目$c(2)部位/$222/n333/*部位2/$444/n555
    
    // 获取适应症
    s incDiseaInfo=..GetIncDiseaInfo(pid,commonType,instType,libGenDr,pointer)
    i $p(incDiseaInfo,"@",2)="" s incDiseaInfo=""
    
	//获取禁忌症
	s diseaInfo=..GetDiseaInfo(pid,commonType,instType,libGenDr,pointer)
	i $p(diseaInfo,"@",2)="" s diseaInfo=""
    	
	//获取不良反应   
	s phAddTextInfo=..GetAddTextInfo(pid,commonType,instType,libGenDr,pointer)
	i $p(phAddTextInfo,"@",2)="" s phAddTextInfo=""
    	
	//注意事项
    s advInfo=..GetAdvInfo(pid,commonType,instType,libGenDr,pointer)
	i $p(advInfo,"@",2)="" s advInfo=""
    
	
    //采集注意事项
	s careInfo=..GetCareInfo(pid)
	
	//临床意义
	s labCliInfo=..GetLabCliInfo(pid,instType)   
   
    d ..killTmpGlobal(pid)
			
	q $g(incDiseaInfo)_"!"_$g(diseaInfo)_"!"_$g(phAddTextInfo)_"!"_$g(advInfo)_"!"_$g(careInfo)_"!"_$g(labCliInfo)
}

/// Description:	获取Q类型的适应证信息
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-21
/// Input:			进程号,医嘱类型,医嘱名称类型(商品名/通用名),知识库(通用名id/商品名id),剂型id
/// return:			适应证信息
/// other:
ClassMethod GetIncDiseaInfo(pid, commonType, instType, tmpLibGenDr, pointer) As %String
{
	n (pid,commonType,instType,tmpLibGenDr,pointer)
	
	s:instType="ProName" pointer=0	// 说明：商品名关联剂型是写在了商品名字典表中,但是在目录索引表的索引中，商品名的pointer是0
	s labelCode=$Case(commonType,"R":"INDIC","L":"LABINDIC","N":"TREATINDIC",:"") // qunianpeng 2018/4/9 增加N治疗项目
	i commonType="S" d
    .s tmpInstruId=""
    .//f  s tmpInstruId=$o(^DHCPHINSTRUC("0","GEN",tmpLibGenDr,tmpInstruId)) q:tmpInstruId=""  d
    .f  s tmpInstruId=$o(^DHCPHINSTRUC("0","GP",tmpLibGenDr,instType,pointer,tmpInstruId)) q:tmpInstruId=""  d
    ..s libDr=$p(^DHCPHINSTRUC(tmpInstruId),"^",6)
    ..s libCode=$p(^DHCPHLIBL(libDr),"^",1)
    ..//q:(libCode'="ULTR")||(libCode'="RADI")||(libCode'="ELECT")||(libCode'="ENDO")
    ..q:(libCode'="ULTR")&(libCode'="RADI")&(libCode'="ELECT")&(libCode'="ENDO")
    .q:$g(libCode)=""
    .s labelCode=$Case(libCode,"ULTR":"ULTRINDIC","RADI":"RADIINDIC","ELECT":"ELECTINDIC","ENDO":"ENDOINDIC") // 超声,放射,心电,内镜

	s incDiseaInfo=..GetQueryInfoByCommon(pid,commonType,instType,labelCode)
	
	q $g(incDiseaInfo)
}

/// Description:	获取Q类型的禁忌证信息
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-21
/// Input:			进程号,医嘱类型(R药品 L检验 S检查),医嘱名称类型(商品名/通用名) ,知识库通用名id
/// return:			禁忌证信息
/// other:
ClassMethod GetDiseaInfo(pid, commonType, instType, tmpLibGenDr, pointer) As %String
{
	n (pid,commonType,instType,tmpLibGenDr,pointer)
		 
	s:instType="ProName" pointer=0	// 说明：商品名关联剂型是写在了商品名字典表中,但是在目录索引表的索引中，商品名的pointer是0
	s labelCode=$Case(commonType,"R":"CONTR","L":"LABCONTR","N":"TREATCONTR",:"") 	// qunianpeng 2018/4/9 增加N治疗项目	  
    i commonType="S" d
    .s tmpInstruId=""
    .//f  s tmpInstruId=$o(^DHCPHINSTRUC("0","GEN",tmpLibGenDr,tmpInstruId)) q:tmpInstruId=""  d
    .f  s tmpInstruId=$o(^DHCPHINSTRUC("0","GP",tmpLibGenDr,instType,pointer,tmpInstruId)) q:tmpInstruId=""  d
    ..s libDr=$p(^DHCPHINSTRUC(tmpInstruId),"^",6)
    ..s libCode=$p(^DHCPHLIBL(libDr),"^",1)
    ..//q:(libCode'="ULTR")||(libCode'="RADI")||(libCode'="ELECT")||(libCode'="ENDO")
    ..q:(libCode'="ULTR")&(libCode'="RADI")&(libCode'="ELECT")&(libCode'="ENDO")
    .q:$g(libCode)=""
    .s labelCode=$Case(libCode,"ULTR":"ULTRCONTR","RADI":"RADICONTR","ELECT":"ELECTCONTR","ENDO":"ENDOCONTR") // 超声,放射,心电,内镜
 
	s diseaInfo=..GetQueryInfoByCommon(pid,commonType,instType,labelCode)
	
	q $g(diseaInfo)
}

/// Description:	获取Q类型的不良反应信息
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-21
/// Input:			进程号,医嘱类型(R药品 L检验 S检查),医嘱名称类型(商品名/通用名) ,知识库通用名id
/// return:			不良反应信息
/// other:
ClassMethod GetAddTextInfo(pid, commonType, instType, tmpLibGenDr, pointer) As %String
{
	n (pid,commonType, instType,tmpLibGenDr,pointer)	
	s:instType="ProName" pointer=0	// 说明：商品名关联剂型是写在了商品名字典表中,但是在目录索引表的索引中，商品名的pointer是0
	s labelCode=$Case(commonType,"R":"ADVREA","L":"LABADVREA",:"")	 	
    i commonType="S" d
   .s tmpInstruId=""
    .//f  s tmpInstruId=$o(^DHCPHINSTRUC("0","GEN",tmpLibGenDr,tmpInstruId)) q:tmpInstruId=""  d
    .f  s tmpInstruId=$o(^DHCPHINSTRUC("0","GP",tmpLibGenDr,instType,pointer,tmpInstruId)) q:tmpInstruId=""  d
    ..s libDr=$p(^DHCPHINSTRUC(tmpInstruId),"^",6)
    ..s libCode=$p(^DHCPHLIBL(libDr),"^",1)
    ..//q:(libCode'="ULTR")||(libCode'="RADI")||(libCode'="ELECT")||(libCode'="ENDO")
    ..q:(libCode'="ULTR")&(libCode'="RADI")&(libCode'="ELECT")&(libCode'="ENDO")
    .q:$g(libCode)=""
    .s labelCode=$Case(libCode,"ULTR":"ULTRADVREA","RADI":"RADIADVREA","ELECT":"ELECTADVREA","ENDO":"ENDOADVREA") // 超声,放射,心电,内镜
  
	s phAddTextInfo=..GetQueryInfoByCommon(pid,commonType,instType,labelCode)
	
	q $g(phAddTextInfo)
}

/// Description:	获取Q类型的注意事项
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-21
/// Input:			进程号,医嘱类型,医嘱名称类型(商品名/通用名),知识库通用名id
/// return:			注意事项
/// other:
ClassMethod GetAdvInfo(pid, commonType, instType, tmpLibGenDr, pointer) As %String
{
	n (pid,commonType, instType,tmpLibGenDr,pointer)  

	s labelCode=$Case(commonType,"R":"MATNEAT","L":"LABMATNEAT",:"")	
    i commonType="S" d
    .s tmpInstruId=""
    .//f  s tmpInstruId=$o(^DHCPHINSTRUC("0","GEN",tmpLibGenDr,tmpInstruId)) q:tmpInstruId=""  d
    .f  s tmpInstruId=$o(^DHCPHINSTRUC("0","GP",tmpLibGenDr,instType,pointer,tmpInstruId)) q:tmpInstruId=""  d
    ..s libDr=$p(^DHCPHINSTRUC(tmpInstruId),"^",6)
    ..s libCode=$p(^DHCPHLIBL(libDr),"^",1)
    ..//q:(libCode'="ULTR")||(libCode'="RADI")||(libCode'="ELECT")||(libCode'="ENDO")
    ..q:(libCode'="ULTR")&(libCode'="RADI")&(libCode'="ELECT")&(libCode'="ENDO")
    .q:$g(libCode)=""
    .s labelCode=$Case(libCode,"ULTR":"ULTRMATNEAT","RADI":"RADIMATNEAT","ELECT":"ELECTMATNEAT","ENDO":"ENDOMATNEAT") // 超声,放射,心电,内镜
   
	s advInfo=..GetQueryInfoByCommon(pid,commonType,instType,labelCode)
	
	q $g(advInfo)
}

/// Description:	获取Q类型的采集注意事项
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-21
/// Input:			进程号
/// return:			采集注意事项
/// other:
ClassMethod GetCareInfo(pid) As %String
{
	n (pid)	
	
	s careInfo=""
	s libGenDr=""
	f  s libGenDr=$o(^TMP("DHCST","DHCSTPHCMPASS","GetLibDataForWin",pid,"Gen",libGenDr)) q:libGenDr=""  d
	.s pointer=$o(^TMP("DHCST","DHCSTPHCMPASS","GetLibDataForWin",pid,"Gen",libGenDr,"")) 
	.q:+pointer=0	
	.s careDr=""
	.f  s careDr=$o(^DHCLSCCARE(0,"Gen",pointer,careDr)) q:careDr=""  d	// 采集注意事项针对标本 应该使用pointer
	..q:'$d(^DHCLSCCARE(careDr))
	..s careDesc=$p(^DHCLSCCARE(careDr),"^",3)
	..i careInfo="" d
	...s careInfo="采集注意事项@/$"_careDesc
	..e  d 
	...s careInfo=careInfo_"/n"_careInfo

	q careInfo
}

/// Description:	获取Q类型的临床意义
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-21
/// Input:			进程号,医嘱名称类型(商品名/通用名)
/// return:			临床意义
/// other:
ClassMethod GetLabCliInfo(pid, instType) As %String
{
	n (pid,instType)
	q:instType="" ""
	
    s labCliInfo=""
	s labelCode="LABCLINICAL"
	s labelDr=$o(^DHCPHPINL(0,"Code",labelCode,""))
	q:labelDr="" ""
    s labelDesc=$p(^DHCPHPINL(labelDr),"^",2)

    s libGenDr=""
	f  s libGenDr=$o(^TMP("DHCST","DHCSTPHCMPASS","GetLibDataForWin",pid,"Gen",libGenDr)) q:libGenDr=""  d
	.s pointer=""
	.f  s pointer=$o(^TMP("DHCST","DHCSTPHCMPASS","GetLibDataForWin",pid,"Gen",libGenDr,pointer)) q:pointer=""  d
	..  
	..s instruId=""
	..f  s instruId=$o(^DHCPHINSTRUC(0,"TGP",labelDr,libGenDr,instType,pointer,instruId)) q:instruId=""  d
	...s phAddi=""
	...f  s phAddi=$o(^DHCLABCLI(0,"Inst",instruId,phAddi)) q:phAddi=""  d
	....s phAddText=$p(^DHCLABCLI(phAddi),"^",2)
	....i labCliInfo="" d
	.....s labCliInfo=labelDesc_"@/$"_phAddText
	....e  d
	.....s labCliInfo=labCliInfo_"/n"_phAddText
	...//兼容历史数据，保存在主索引表中 text 2020/08/20
	...i '$d(^DHCLABCLI(0,"Inst",instruId)) d
	....s phAddText=$p($g(^DHCPHINSTRUC(+instruId)),"^",15)
	....q:phAddText=""
	....s labCliInfo=$case(labCliInfo="",1:labelDesc_"@/$"_phAddText,:labCliInfo_"/n"_phAddText)
	
	q labCliInfo
}

/// Description:	获取Q类型的适应证、禁忌证、不良反应、注意事项公共部分
/// Creator:		QuNianpeng
/// CreateDate:		2017-08-21
/// Input:			进程号,医嘱类型,医嘱名称类型(商品名/通用名),目录代码
/// return:			适应证/禁忌证/不良反应/注意事项描述
/// other:
ClassMethod GetQueryInfoByCommon(pid, commonType, instType, labelCode) As %String
{
	n (pid,commonType,instType,labelCode)
	q:(commonType="")||(instType="")||(labelCode="") ""

	s labelDesc=""
    s labelDr=$o(^DHCPHPINL(0,"Code",labelCode,""))
    i labelDr'="" s labelDesc=$p(^DHCPHPINL(labelDr),"^",2)	// 目录描述
    q:labelDr="" ""
    
	s commonInfo=labelDesc_"@"
	s itmNum=0
	s libGenDr=""
	f  s libGenDr=$o(^TMP("DHCST","DHCSTPHCMPASS","GetLibDataForWin",pid,"Gen",libGenDr)) q:libGenDr=""  d
	.q:libGenDr=""
	.s libGenDesc=$p(^DHCPHEGEN(libGenDr),"^",2)
    .//i itmNum=0 s commonInfo=commonInfo_"@"_libGenDesc
    .//i itmNum>0 s commonInfo=commonInfo_$c(13)_libGenDesc
    .//s itmNum=itmNum+1
    .
    .s pointNum=0
	.s pointer="" 	//剂型(药品) 部位(检查) 标本(检验)
	.f  s pointer=$o(^TMP("DHCST","DHCSTPHCMPASS","GetLibDataForWin",pid,"Gen",libGenDr,pointer)) q:pointer=""  d
	..i commonType="S" s pointDesc=$p(^DHCPHEPA(pointer),"^",2)
	..i commonType="R" s pointDesc=$p(^DHCPHEF(pointer),"^",2)
	..i commonType="L" s pointDesc=$p(^DHCPHEGEN(pointer),"^",2)
	..//i pointNum=0 s commonInfo=commonInfo_$c(2)_pointDesc
	..//i pointNum>0 s commonInfo=commonInfo_"/*"_pointDesc
	..s pointNum=pointNum+1
	..s insNum=0
	..s tmpPointer=$Select(instType="ProName":0,1:pointer)
	..s instruId=""
	..f  s instruId=$o(^DHCPHINSTRUC(0,"TGP",labelDr,libGenDr,instType,tmpPointer,instruId)) q:instruId=""  d
	...i (labelDesc["适应证")||(labelDesc["禁忌证") d	//适应证、禁忌证从目录索引表的text字段取值
	....s disea=$p(^DHCPHINSTRUC(instruId),"^",15)
	...e  d												//不良反应、注意事项从业务表中取值
	....s disea=""
	....s tmpComDr=$o(^DHCPHADDI("0","Inst",instruId,""))
	....i tmpComDr'="" s disea=$p(^DHCPHADDI(tmpComDr),"^",2)
	....//q:tmpComDr=""
	....//s disea=$p(^DHCPHADDI(tmpComDr),"^",2)
	....i $g(disea)="" s disea=$p(^DHCPHINSTRUC(instruId),"^",15) //qunianpeng 2-17/9/28 如果业务表中为空，则从目录主索引表中取
	...
	...i insNum=0 s commonInfo=commonInfo_"/$"_$g(disea)
	...i insNum>0 s commonInfo=commonInfo_"/n"_$g(disea)
	...s insNum=insNum+1
	...
	..

	q commonInfo
}

/// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////A类型建议医嘱///////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// 取诊断对应的
/// w ##class(web.DHCSTPHCMPASS).GetArcIndDataForWin(69)
ClassMethod GetArcIndDataForWin(adm) As %String
{
	
	n (adm)
	s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()
    s ret=""
    S mradm=$P(^PAADM(adm),"^",61)
    s patIcd=..GetMRDiagnosDesc(adm,",")	// his诊断
    s cnt=$l(patIcd,",")
	f lk=1:1:cnt d
	.s code=$p(patIcd,",",lk)
	.q:code=""
	.s id=""
	.f  s id=$o(^DHCEXTICON(0,"HisCode",code,id)) q:id=""  d			
    ..s libmrccode=$p(^DHCEXTICON(id),"^",1)
    ..q:libmrccode=""  
    ..s libmrcid=$o(^DHCEXTICD(0,"Code",$ZCONVERT(libmrccode,"U"),""))
    ..//s libmrcid=$o(^DHCEXTICD(0,"Code",libmrccode,""))
    ..q:libmrcid=""
	..s maindis=""
	..f  s maindis=$o(^DHCPHDISL(0,"ICD",libmrcid,maindis)) q:maindis=""  d	// DHC_PHDiseaseItmList 病症与诊断关联表
	...s instruId=""
	...f  s instruId=$o(^DHCPHDDIS(0,"Mode",maindis,"I",instruId)) q:instruId=""  d //DHC_PHDrugDisease 病症业务表 I为适应症
	....s genitmdr=$p($g(^DHCPHINSTRUC(instruId)),"^",3)
	....s pointerType=$p($g(^DHCPHINSTRUC(instruId)),"^",5)	      // 增加通用名/商品名区分 qnp 2018/3/30
	....q:pointerType=""
	....q:(pointerType="Form")&('$d(^DHCPHEGEN(genitmdr)))    // 基础数据有问题 过滤问题数据 qunianpeng 2017/8/28
	....q:(pointerType="ProName")&('$d(^DHCPHPNA(genitmdr)))
	....//s gendesc=$p(^DHCPHEGEN(genitmdr),"^",2)			  // quninpeng 2017/9/28 在返回值中取	
	....s libdr=$p(^DHCPHINSTRUC(instruId),"^",6)             // 知识库标识
	....//s libdesc=$p(^DHCPHLIBL(libdr),"^",2)	              // quninpeng 2017/9/28 在返回值中取
	....q:$d(^TMP("DHCST","DHCSTPHCMPASS","GetArcIndDataForWin",pid,pointerType,libdr,genitmdr)) 
	....s ^TMP("DHCST","DHCSTPHCMPASS","GetArcIndDataForWin",pid,pointerType,libdr,genitmdr)=""
    ....
    ...
    ..
    .    
    
    //s pointerType=""  //药品：商品名不存在适应证时，取通用名  qnp 2018/3/30
    //i $d(^TMP("DHCST","DHCSTPHCMPASS","GetArcIndDataForWin",pid,"ProName"))  d 
    //.s pointerType="ProName"   
    //e  d
    //.s pointerType="Form"
    
    s retDrug=..GetAdvByDrug(pid,"ProName")	// 药品：商品名不存在适应证时，取通用名 (药品@药1$c(2）药2)   
    s retDrugForm=..GetAdvByDrug(pid,"Form")	// 药品：t通用名和商品名各一次(2018/12/11 )
    s retOther=..GetAdvByOther(pid,"Form")		// 除药品以外的,取通用名对应的医嘱
    i (retDrugForm'="")&(retDrug'="") s retDrug=retDrug_$c(2)_$p(retDrugForm,"@",2)
    i (retDrugForm'="")&(retDrug="") s retDrug=retDrugForm
    
    i retDrug'="" s ret=retDrug_"!"_retOther
	e  s ret=retOther
	
	k ^TMP("DHCST","DHCSTPHCMPASS","GetArcIndDataForWin",pid)
	
    q ret
}

/// Description:	获取药品的建议医嘱(区分通用名和商品名)
/// Creator:		QuNianpeng
/// CreateDate:		2018-03-30
/// Input:			pid,商品名/通用名类型
/// return:			
/// other:
ClassMethod GetAdvByDrug(pid, pointerType) As %String
{
	n (pid,pointerType)    
	s ret="",libdr=""
	s libdr=$o(^DHCPHLIBL(0,"Code",$$ALPHAUP^SSUTIL4("DRUG"),""))
	q:libdr="" ""
	s libdesc=$p(^DHCPHLIBL(libdr),"^",2)		//目录描述
	s num=0,tmpStr=""
	s genitmdr=""
	f  s genitmdr=$o(^TMP("DHCST","DHCSTPHCMPASS","GetArcIndDataForWin",pid,pointerType,libdr,genitmdr)) q:genitmdr=""  d
	.i pointerType="Form" s gendesc=$p(^DHCPHEGEN(genitmdr),"^",2)		// 通用名
	.i pointerType="ProName" s gendesc=$p(^DHCPHPNA(genitmdr),"^",2)    // 商品名
	.i num=0 s tmpStr=gendesc
	.i num'=0 s tmpStr=tmpStr_$c(2)_gendesc
	.s num=num+1
	
	i tmpStr'="" s ret=libdesc_"@"_tmpStr

	q ret
}

/// Description:	获取检验、检查、治疗项目建议医嘱(通用名)
/// Creator:		QuNianpeng
/// CreateDate:		2018-03-30
/// Input:			商品名/通用名类型,知识库标识id
/// return:			
/// other:
ClassMethod GetAdvByOther(pid, pointerType) As %String
{
	n (pid,pointerType)    
	s ret="",libdr=""
	s tmpLibStr=""
	f  s libdr=$o(^TMP("DHCST","DHCSTPHCMPASS","GetArcIndDataForWin",pid,pointerType,libdr)) q:libdr=""  d
	.s libcode=$p(^DHCPHLIBL(libdr),"^",1)
	.s libdesc=$p(^DHCPHLIBL(libdr),"^",2)		//目录描述
	.q:libcode="DRUG"
	.s tmpStr=""
	.s genitmdr=""
	.f  s genitmdr=$o(^TMP("DHCST","DHCSTPHCMPASS","GetArcIndDataForWin",pid,pointerType,libdr,genitmdr)) q:genitmdr=""  d
	..s gendesc=$p(^DHCPHEGEN(genitmdr),"^",2)		// 通用名
	..i tmpStr="" s tmpStr=gendesc
	..e  s tmpStr=tmpStr_$c(2)_gendesc
	..
	.
	.i tmpStr'="" s tmpLibStr=libdesc_"@"_tmpStr
	.i ret="" s ret=tmpLibStr
	.e  s ret=ret_"!"_tmpLibStr
	
	q ret
}

/// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////测试用例////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ClassMethod Test(a) As %String
{
	    
	    s ClassName="web.DHCSTPHCMADDEXTLIB"
		s aCmdCreateCls="ret=##class("_ClassName_").Test1()"
		s @aCmdCreateCls
		
		q $g(ret)
}

/// 构造数据池
ClassMethod CreateLibData(Input) As %String
{
	n (Input)
	s ^tlq("input",Input)=""
	//日期^时间^病人id^就诊id^报告号^项目^结果值^单位^类型(检验L,检查C)
	s date=$p(Input,"^",1)
	s time=$p(Input,"^",2)
	s patid=$p(Input,"^",3)
	s admid=$p(Input,"^",4)
	s reportno=$p(Input,"^",5)
	s itemcode=$p(Input,"^",6)
	s itemval=$p(Input,"^",7)
	k PLIST
	s PLIST(2)=date
	s PLIST(3)=time
	s PLIST(4)=patid
	s PLIST(5)=admid
	s PLIST(6)=reportno
	s PLIST(7)=itemcode
	s PLIST(8)=itemval
	&sql(INSERT INTO DHC_PHLibDataPooL VALUES :PLIST())
	q 0
}

ClassMethod GetSpecDataPool(Adm) As %String
{
}

/// Description:	中药药品毒性判断 单次剂量超过限制，判断毒性药品（毒性）
/// Creator:		(QuNianpeng ) 江苏中医
/// CreateDate:		(2017-08-08
/// Input:			商品名id,his用药信息串,目录索引id,返回信息
/// return:			效验结果
/// other:
ClassMethod CheckDrugPoison(libProId, hisDosQtyInfo, instruId, ByRef RetMsg As %String) As %String
{
	n (libProId,hisDosQtyInfo,instruId,RetMsg)
	//s hisDosQtyInfo=arci_","_dosUomId_","_dosQty_","_dayMaxQty_","_oneDayTime //用药量信息串 （医嘱项id,单位,单次用药量/单次最大量,每日最大量/每日总量,用药次数,首次用药量,连用量,间隔数）
	
	s RetMsg=""
	q:instruId="" -100 	//没有维护
	   
	s usdoId=$o(^DHCPHUSDO(0,"Inst",instruId,""))  		//DHC_PHUsageDosage  用法用量表（业务表）
	q:usdoId="" -100

	s poison=$p(^DHCPHPNA(libProId),"^",2)		//毒性 
	q:poison=""	
	
	s ret=1
	s libMaxUseQty=$p(^DHCPHUSDO(usdoId),"^",10)    //知识库维护的用药剂量和单位
	s libMaxUseQtyId=$p(^DHCPHUSDO(usdoId),"^",11)
	i (libMaxUseQty'="") s useQtyFlag=1
	s hisMaxUseQty=$p(hisDosQtyInfo,",",3)				//his传递的用药剂量和单位
	s hisMaxUseQtyId=$p(hisDosQtyInfo,",",2)
	s arci=$p(hisDosQtyInfo,",",1)						
	s hisMaxUseQtyDesc=$p(^CT("UOM",hisMaxUseQtyId),"^",2)

	s libMaxUseQtyCode=""
	s libMaxUseQtyDesc=""
	i libMaxUseQtyId'="" s libMaxUseQtyDesc=$p(^DHCPHEUO(libMaxUseQtyId),"^",2),libMaxUseQtyCode=$p(^DHCPHEUO(libMaxUseQtyId),"^",1)
	
	//用知识库中单位反向找到对照的his单位描述
	s libMaxUseQtyCode=$p(libMaxUseQtyCode,"/",1)
	s conHisMaxUseQtyCode=$o(^DHCPHUOCON(0,"Code",libMaxUseQtyCode,""))					//对照his单位code
	q:conHisMaxUseQtyCode="" -100
	s conHisMaxUseQtyId=$o(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(conHisMaxUseQtyCode),""))  //对照his单位id
	s conHisMaxUseQtyDesc=$p(^CT("UOM",conHisMaxUseQtyId),"^",2)							//对照his单位描述

	//his中剂量单位和知识库中单位不相同时,将知识库的剂量转换为his剂量
	i hisMaxUseQtyDesc'=conHisMaxUseQtyDesc d
	.s hisFac=..GetBUomFac(arci,hisMaxUseQtyId)  	 //获取his的等效数量
	.s libFac=..GetBUomFac(arci,libMaxUseQtyId) 	//获取知识库对照his单位的等效数量	 	
	.s libMaxUseQty=libMaxUseQty/libFac*hisFac		//将知识库的剂量转换为his剂量

	//进行判断
	i ((hisMaxUseQty>libMaxUseQty)&(libMaxUseQty'="")) d
	.i poison'="" s ret=0
	
	i ret=0 s RetMsg=..GetInstruIdMsg(instruId)

	q ret
}

/// Description:	获取医嘱的开始时间，医生，科室，医嘱
/// Creator:		(QuNianpeng 修改)
/// CreateDate:		(2017-08-04	修改)
/// Input:			返回信息,知识库类型,医嘱信息串,用户信息串
/// return:			效验结果
/// other:	 		w ##class(web.DHCSTPHCMPASS).GetOeoriInfo("1||1")
ClassMethod GetOeoriInfo(oeori)
{
	n (oeori)
	
	q:oeori="" ""
	s oeord=+oeori
	s sub=$p(oeori,"||",2)
	s stDate=$p(^OEORD(oeord,"I",sub,1),"^",9)
	s:stDate'="" stDate=$zd(stDate,3)
	
	s locDr=$p(^OEORD(oeord,"I",sub,1),"^",3)	// 科室
	s:locDr'="" locDr=$p($g(^CTLOC(locDr)),"^",2)
	
	s doctorDr=$p(^OEORD(oeord,"I",sub,1),"^",11)
	s:doctorDr'="" doctorDr=$p(^CTPCP(doctorDr,1),"^",2) 
	
	s arci=$p(^OEORD(oeord,"I",sub,1),"^",2)
	s arciSub=$p(arci,"||",2)
	s arciDesc=$p(^ARCIM(+arci,arciSub,1),"^",2)
	
	q "("_stDate_locDr_" "_doctorDr_" "_arciDesc_")"
}

}
