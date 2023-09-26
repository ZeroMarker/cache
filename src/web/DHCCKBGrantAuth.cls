Import SQLUser

/// Creator: 	sufan
/// CreateDate: 2020-01-21
/// Descript: 	知识库授权
Class web.DHCCKBGrantAuth Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 	sufan
/// CreateDate: 2020-01-21
/// Descript: 	查询医院列表
/// w ##class(web.DHCCKBGrantAuth).QueryHospList("180","1")
ClassMethod QueryHospList(rows = 10, page = 1) As %String
{
  	n (rows,page)
  	s End = page*rows
	s Start=(page-1)*rows+1
	s EndPage=page*rows  
	s StPage=((page-1)*rows)+1    
   	s count=0
   	s HospId=0
   	w "{""rows"":["
   	for  s HospId=$o(^CT("HOSP",HospId) ) q:(HospId="")||(+HospId=0)  d
   	.s Code=$p(^CT("HOSP",HospId),"^",1)
   	.s Desc=$p(^CT("HOSP",HospId),"^",2)
   	.s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.s tmpObj={}
	.s tmpObj.code=Code
	.s tmpObj.desc=Desc
	.s tmpObj.rowid=HospId	
	.s tmpObj.type="D"
	.s tmpObj.activeflag=..IsActiveFlag("D", HospId)
	.s tmpObj.permisflag = ..IsPermisFlag("D", HospId)
	.w tmpObj.%ToJSON()
	w "],""total"":"_count_"}"
	q ""
}

/// Creator: 	sufan
/// CreateDate: 2020-01-21
/// Descript: 	查询职称列表
/// w ##class(web.DHCCKBGrantAuth).QueryCtCptList("180","1")
ClassMethod QueryCtCptList(rows, page) As %String
{
    n (rows,page)
  	s End = page*rows
	s Start=(page-1)*rows+1
	s EndPage=page*rows  
	s StPage=((page-1)*rows)+1  
	s count=0
   	s CtcptId=0
   	w "{""rows"":["
   	for  s CtcptId=$o(^CT("CPT",CtcptId)) q:(CtcptId="")||(CtcptId=0)  d
   	.s Desc=$p(^CT("CPT",CtcptId),"^",2)
  	.s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.s tmpObj={}
	.s tmpObj.desc=Desc
	.s tmpObj.rowid=CtcptId
	.s tmpObj.type="C"
	.s tmpObj.activeflag=..IsActiveFlag("C", CtcptId)
	.s tmpObj.permisflag = ..IsPermisFlag("C", CtcptId)
	.w tmpObj.%ToJSON()
	w "],""total"":"_count_"}"
	q ""
}

/// Creator: 	sufan
/// CreateDate: 2020-01-21
/// Descript: 	查询科室列表 
/// w ##class(web.DHCCKBGrantAuth).QueryDocLocList("180","1","")
ClassMethod QueryDocLocList(rows, page, Input, HospId = "") As %String
{
   	n (rows,page,Input,HospId)
   	s Input=$zcvt(Input,"U") 
  	s End = page*rows
	s Start=(page-1)*rows+1
	s EndPage=page*rows  
	s StPage=((page-1)*rows)+1  
	s count=0
   	s LocId=""
   	w "{""rows"":["
   	for  s LocId=$o(^CTLOC(LocId)) q:LocId=""  d
   	.q:LocId=0
   	.s Code=$p(^CTLOC(LocId),"^",1)
   	.s Desc=$p(^CTLOC(LocId),"^",2)
   	.s Desc=$zcvt(Desc,"U") 
   	.s CtHospDr = $p($g(^CTLOC(+LocId)),"^",22)
   	.q:(HospId'="")&&(HospId'=CtHospDr)
   	.s ContactName=$p(^CTLOC(LocId),"^",43)
   	.s ContactName=$zcvt(ContactName,"U")  //qunianpeng 2017/10/9
    .s QuitStr=Desc_ContactName
    .Q:(Input'="")&&(QuitStr'[Input)
    .s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.s tmpObj={}
	.s tmpObj.code=Code
	.s tmpObj.desc=Desc
	.s tmpObj.rowid=LocId
	.s tmpObj.type="L"
	.s tmpObj.activeflag=..IsActiveFlag("L", LocId)
	.s tmpObj.permisflag = ..IsPermisFlag("L", LocId)
	.w tmpObj.%ToJSON()
	w "],""total"":"_count_"}"
	q ""
}

/// 查询医生列表
/// w ##class(web.DHCCKBGrantAuth).QueryAccDocList("180","1","")
ClassMethod QueryAccDocList(rows, page, input) As %String
{
	n (rows,page,input)  
	
   s endpage=page*rows  //结束行
   s stpage=((page-1)*rows)+1 //开始行
   
   k TmpArr
   s doccode=$p(input,"^",1)
   s h=0
   s cartpdr=""
   f  s cartpdr=$o(^CTPCP(0,"CareProvType",cartpdr)) q:cartpdr=""  d
   .s type=$p(^CT("CPT",cartpdr),"^",4)
   .q:type'="DOCTOR"
   .s ctpcpdr=""
   .f  s ctpcpdr=$o(^CTPCP(0,"CareProvType",cartpdr,ctpcpdr)) q:ctpcpdr=""  d
   ..s ssusr=$o(^SSU("SSUSR",0,"CTPCP",ctpcpdr,"")) 
   ..q:ssusr=""
   ..s code=$p(^SSU("SSUSR",ssusr),"^",1)
   ..q:(doccode'=code)&(doccode'="")
   ..s desc=$p(^SSU("SSUSR",ssusr),"^",2)
   ..s h=h+1 
   ..s rowid=ssusr
   ..s data=code_"^"_desc_"^"_rowid
   ..
   ..s index=h
   ..s TmpArr(index) = data
  
   q:h=0 "{""rows"":[],""total"":"_count_"}"   
   
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
	
	w "{""rows"":["
	
	s index=""
	f  s index=$o(TmpArr(index)) q:index=""  d
	.s data=$g(TmpArr(index))
	.s code=$p(data,"^",1)
	.s desc=$p(data,"^",2)
	.s rowid=$p(data,"^",3)
	.
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
	.w $case(count,stpage:"",:",")
	.s tmpObj={}
	.s tmpObj.code=code
	.s tmpObj.desc=desc
	.s tmpObj.rowid=rowid
	.s tmpObj.activeflag=..IsActiveFlag("U",rowid)
	.s tmpObj.permisflag = ..IsPermisFlag("U",rowid)
	.w tmpObj.%ToJSON()
	
	w "],""total"":"_count_"}"
 
	
	q ""
}

/// Creator: 	sufan
/// CreateDate: 2020-01-21
/// Descript: 	查询知识库函数字典 
/// w ##class(web.DHCCKBGrantAuth).QueryLibAccMenu("150","1","^2^D")
ClassMethod QueryLibAccMenu(rows = 150, page = 1, Input)
{
	n (rows, page, Input)

	Q:Input="" ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0) //输出json结尾符
	s End = page*rows
	s Start=(page-1)*rows+1	
	s CurLibDr=$p(Input,"^",1)			//知识库类型
	s Pointer=$p(Input,"^",2)			//授权对象值
	s PointType=$p(Input,"^",3)			//授权对象类型
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	d ..killTmpGlobal(pid) 
	
	s quitList = $lb("药物-食物相互作用","毒理研究","超说明书适应症","特殊人群用药","FDA妊娠药物分级","作用与用途","一般注意事项","药物过量","化学成分","临床试验","过敏试验","长期毒性试验","适应性","毒理作用")
	s quitListExt = $lb("使用方法","稳定性和相容性","不良事件","给药方法","配制说明","丢弃说明","病人须知","使用操作说明")
	s $list(quitListExt,*+1)="药物相互作用"
	s $list(quitListExt,*+1)="警告"
	s $list(quitListExt,*+1)="成分相互作用测试"
	s $list(quitListExt,*+1)="用药指导"
	s $list(quitListExt,*+1)="配药方法"
	s $list(quitListExt,*+1)="可以伍用"
	s $list(quitListExt,*+1)="交叉耐药"
	s $list(quitListExt,*+1)="药物治疗条件"
	s $list(quitListExt,*+1)="推荐方案"
	s $list(quitListExt,*+1)="用法用量(临床指南)"
	s $list(quitListExt,*+1)="液体配置(总)"
	s $list(quitListExt,*+1)="液体配置(唐镜波版)"	
	
	s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()
	s Id="" 
	for  s Id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugLibary,Id)) q:Id=""  d
	.q:+Id=0
	.s LibDr=""								//实体id
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),3)			//目录描述
	.q:($lf(quitList,Desc)>0)||($lf(quitListExt,Desc)>0)
	.//q:0=##class(web.DHCCKBRulePriority).TmpQuitDrugLibrary(Desc)
	.s ParentId=""
	.s Chk=""
	.s DlgRowId=$o(^CKB.PDSS.DicLogI("SCOPE",PointType,Pointer,"DHC_CKBDicLinkAttr",Id,"businessAuth",""))
	.s ActiveFlag=""
	.s:DlgRowId'="" ActiveFlag= $lg(^CKB.PDSS.DicLogD(DlgRowId),4)
	.s:ActiveFlag="businessAuth" ActiveFlag="Y"
	.s Chk=ActiveFlag
	.s Lib=""	//知识库描述	
	.s DataType="DHC_CKBCommonDiction"
	.s ListData=LibDr_"^"_Desc_"^"_ParentId_"^"_Id_"^"_Chk_"^"_Lib_"^"_DataType
	.s ^TMP("DHCCKB","web.DHCCKBGrantAuth","QueryLibAccMenu",pid,Id)=ListData
	.D ..QueryLinkItem(Id,Input,pid)				///取子项目
	
	// 增加全局规则授权 2020/11/30 qnp

	s GlobalData=##class(web.DHCCKBCommon).GetGlobalData()
	s Id="" 
	for  s Id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",GlobalData,Id)) q:Id=""  d
	.q:+Id=0
	.s LibDr=""								//实体id
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),3)			//目录描述
	.s ParentId=""
	.s Chk=""
	.s DlgRowId=$o(^CKB.PDSS.DicLogI("SCOPE",PointType,Pointer,"DHC_CKBDicLinkAttr",Id,"businessAuth",""))
	.s ActiveFlag=""
	.s:DlgRowId'="" ActiveFlag= $lg(^CKB.PDSS.DicLogD(DlgRowId),4)
	.s:ActiveFlag="businessAuth" ActiveFlag="Y"
	.s Chk=ActiveFlag
	.s Lib=""	//知识库描述	
	.s DataType="DHC_CKBCommonDiction"
	.s ListData=LibDr_"^"_Desc_"^"_ParentId_"^"_Id_"^"_Chk_"^"_Lib_"^"_DataType
	.s ^TMP("DHCCKB","web.DHCCKBGrantAuth","QueryLibAccMenu",pid,Id)=ListData
	.D ..QueryLinkItem(Id,Input,pid)				///取子项目

	
	s count=0
	w "{""rows"":["
	s ItmId=""
   	for  s ItmId=$o(^TMP("DHCCKB","web.DHCCKBGrantAuth","QueryLibAccMenu",pid,ItmId)) q:ItmId=""  d
   	.s Data=^TMP("DHCCKB","web.DHCCKBGrantAuth","QueryLibAccMenu",pid,ItmId)	
   	.s LibDr=$p(Data,"^",1)
   	.s Desc=$p(Data,"^",2)
   	.s ParentId=$p(Data,"^",3)
   	.s Id=$p(Data,"^",4)
   	.s Chk=$p(Data,"^",5)
   	.s Lib=$p(Data,"^",6)
   	.s DataType=$p(Data,"^",7)
    .s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.s tmpObj={}
	.s tmpObj.libdr=LibDr
	.s tmpObj.desc=Desc
	.s tmpObj.id=Id
	.s tmpObj."_parentId"=ParentId
	.s tmpObj.chk=Chk
	.s tmpObj.lib=Lib
	.s tmpObj.dataType=DataType
	.w tmpObj.%ToJSON()
	w "],""total"":"_count_"}"
	
	d ..killTmpGlobal(pid)
	q ""
}

/// w ##class(web.DHCCKBGrantAuth).QueryLinkItem(72,"5^2^D",1)
ClassMethod QueryLinkItem(CatId, Input, pid)
{
	n (CatId,Input,pid)
	s CurLibDr=$p(Input,"^",1)			//知识库类型
	s Pointer=$p(Input,"^",2)			//授权对象值
	s PointType=$p(Input,"^",3)			//授权对象类型
	s AvailableId=##class(web.DHCCKBCommon).GetAvailable()        //可用标志
	s Preconditions=##class(web.DHCCKBCommon).GetPreconditions()  //前提条件
	s Prop=##class(web.DHCCKBCommon).GetCheckItmListProp()		  // 项目列表属性

	s count = 0
	s Id="" 
	for  s Id=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",CatId,Prop,Id)) q:Id=""  d
	.q:Id=0
	.s LibDr=CurLibDr
	.s dicId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(Id)),4)	// 具体项目
	.q:+dicId=0
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)
	.s ParentId=CatId
	.s Chk=""
	.s DlgRowId=$o(^CKB.PDSS.DicLogI("SCOPE",PointType,Pointer,"DHC_CKBDicLinkAttr",Id,"businessAuth",""))
	.s ActiveFlag=""
	.s:DlgRowId'="" ActiveFlag= $lg(^CKB.PDSS.DicLogD(DlgRowId),4)
	.s:ActiveFlag="businessAuth" ActiveFlag="Y"
	.//b:CatId="111067"
	.s Chk=ActiveFlag
	.s Lib="" //$lg($g(^CT.CKB.PDSS.CommonDictionD(CurLibDr)),3)	//知识库描述
	.s DataType="DHC_CKBDicLinkAttr"
	.s ListData=LibDr_"^"_Desc_"^"_ParentId_"^"_Id_"^"_Chk_"^"_Lib_"^"_DataType
	.s ^TMP("DHCCKB","web.DHCCKBGrantAuth","QueryLibAccMenu",pid,Id)=ListData
	.s count = count +1
	
	i count = 0 d	// 没有子项目，则不显示主项目
	.k ^TMP("DHCCKB","web.DHCCKBGrantAuth","QueryLibAccMenu",pid,CatId)
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCCKB","web.DHCCKBGrantAuth","QueryLibAccMenu",pid)
}

/// Creator: 	sufan
/// CreateDate: 2020-01-21
/// Descript: 	知识库目录授权 
/// w ##class(web.DHCCKBGrantAuth).SaveAccItm("^D^3^11863^127.0.0.1@69:DHC_CKBCommonDiction^3965:DHC_CKBDicLinkAttr")
/// w ##class(web.DHCCKBGrantAuth).SaveAccItm("^D^3^17526^10.30.4.216@")
ClassMethod SaveAccItm(ListData)
{
	n (ListData)
	s Err=0
	TS
	s Err=..DeleSelItem(ListData)

	//	知识库类型  +"^"+ 作用域  "^"+  作用域值    +"^"+ 操作用户 +"^"+ 客户端ip    +"@"+ 项目id:字典类型^项目id:字典类型!项目id:字典类型
	s LibItmList=$p(ListData,"@",1)    ///知识库串
	s AuthobjId=$p(LibItmList,"^",2)	///作用域
	s Authobj=$p(LibItmList,"^",3)		///作用域值
	s AccItmList=$p(ListData,"@",2)	   ///项目串

	i (Err=0)&(AccItmList="") tc
	i (Err'=0)||(AccItmList="") tro
	q:(Err'=0)||(AccItmList="") 0
		
	s Len=$l(AccItmList,"!")
	for i=1:1:Len  Q:Err'=0  d
	.s TempList=$p(AccItmList,"!",i)
	.s ItmLen=$l(TempList,"^")
	.for j=1:1:ItmLen Q:Err'=0  d
	..s ItemAcList=$p(TempList,"^",j)
	..s ItmId=$p(ItemAcList,":",1)
	..s DataType=$p(ItemAcList,":",2)
	..//s DicLogId=$o(^CKB.PDSS.DicLogI("SCOPE",AuthobjId,Authobj,DataType,ItmId,"grantAuth",""))	// 是否可见
	..s DicLogId=$o(^CKB.PDSS.DicLogI("SCOPE",AuthobjId,Authobj,DataType,ItmId,"businessAuth",""))	// 授权
	..b //1
	..i DicLogId=""   d
	...s Err=..InsAccItm(LibItmList,ItemAcList)		///新增
	..e   d
	...s Err=..UpdAccItm(DicLogId,LibItmList,ItemAcList)		///更新
	
	i Err=0 tc
	i Err'=0 tro
	
	Q Err
}

ClassMethod InsAccItm(LibItmList, ListData)
{
	n (LibItmList,ListData)
	//	知识库类型  +"^"+ 作用域  "^"+  作用域值    +"^"+ 操作用户 +"^"+ 客户端ip    +"@"+ 项目id:字典类型^项目id:字典类型!项目id:字典类型
	s ItemId=$p(ListData,":",1)			/// 授权项目id
	s Dlgdic=$p(ListData,":",2)			/// 字典类型
	s AuthobjId=$p(LibItmList,"^",2)	/// 作用域
	s Authobj=$p(LibItmList,"^",3)		/// 作用域值
	s OperUser=$p(LibItmList,"^",4)		/// 操作人
	s ClientIP = $p(LibItmList,"^",5)	/// ip	
	s ActiveFlag="businessAuth"				///启用标识
	s OperDate=+$h
	s OperTime=$p($h,",",2)
	&sql(insert into CKB_PDSS.DicLog (DLG_Dic,DLG_Data_Dr,DLG_Function,DLG_Operator,DLG_Date,DLG_Time,DLG_Scope,DLG_ScopeValue,DLG_ClientIPAddress)
		values (:Dlgdic,:ItemId,:ActiveFlag,:OperUser,:OperDate,:OperTime,:AuthobjId,:Authobj,:ClientIP))
	Q SQLCODE
}

ClassMethod UpdAccItm(DicLogId, LibItmList, ListData)
{
	n (DicLogId,LibItmList,ListData)
	
	//	知识库类型  +"^"+ 作用域  "^"+  作用域值    +"^"+ 操作用户 +"^"+ 客户端ip    +"@"+ 项目id:字典类型^项目id:字典类型!项目id:字典类型
	s ItemId=$p(ListData,":",1)			/// 授权项目id
	s Dlgdic=$p(ListData,":",2)			/// 字典类型
	s AuthobjId=$p(LibItmList,"^",2)	/// 作用域
	s Authobj=$p(LibItmList,"^",3)		/// 作用域值
	s OperUser=$p(LibItmList,"^",4)		/// 操作人
	s ClientIP = $p(LibItmList,"^",5)	/// ip	
	s ActiveFlag="businessAuth"				///启用标识
	s OperDate=+$h
	s OperTime=$p($h,",",2)
	
	&sql(update CKB_PDSS.DicLog set DLG_Dic=:Dlgdic,DLG_Data_Dr=:ItemId,DLG_Function=:ActiveFlag,DLG_Operator=:OperUser,DLG_Date=:OperDate,DLG_Time=:OperTime,DLG_Scope=:AuthobjId,DLG_ScopeValue=:Authobj,DLG_ClientIPAddress=:ClientIP where DLG_RowID=:DicLogId)
	Q SQLCODE
}

/// w ##class(web.DHCCKBGrantAuth).DeleSelItem("5^2^D^1@72:Y^13354:Y^13355:Y^13356:Y^13357:Y")
ClassMethod DeleSelItem(ListData)
{
	n (ListData)
	//	知识库类型  +"^"+ 作用域  "^"+  作用域值    +"^"+ 操作用户 +"^"+ 客户端ip    +"@"+ 项目id:字典类型^项目id:字典类型!项目id:字典类型
	s LibItmList=$p(ListData,"@",1)    ///知识库串
	s PointType=$p(LibItmList,"^",2)
	s Pointer=$p(LibItmList,"^",3)
	
	s ret=0	
	s Fun = "businessAuth"
	&sql(delete from CKB_PDSS.DicLog where DLG_Scope=:PointType and DLG_Function=:Fun and DLG_ScopeValue=:Pointer)
	s ret=SQLCODE
	s:ret=100 ret=0
	q ret 
	/////// 使用上面方法
	s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()
	s Id="" 
	for  s Id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugLibary,Id)) q:Id=""  d
	.q:+Id=0
    .s DlgRowId=""
	.f  s DlgRowId=$o(^CKB.PDSS.DicLogI("SCOPE",PointType,Pointer,"DHC_CKBCommonDiction",Id,"businessAuth",DlgRowId)) q:(DlgRowId="")||(ret'=0)  d
	..&sql(delete from CKB_PDSS.DicLog where DLG_RowID=:DlgRowId)
	..s ret=SQLCODE
	..
	.s ret=..DeleselLinkItem(Id,LibItmList)	// 删除关联的授权
	
	
	Q ret
}

/// w ##class(web.DHCCKBGrantAuth).DeleselLinkItem(72,"5^2^D",1)
ClassMethod DeleselLinkItem(CatId, Input)
{
	n (CatId,Input)	
	s PointType=$p(Input,"^",2)			//授权对象类型
	s Pointer=$p(Input,"^",3)			//授权对象值
	s Prop=##class(web.DHCCKBCommon).GetCheckItmListProp()		  // 项目列表属性
	s ret=0
	s Id="" 
	
	for  s Id=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",CatId,Prop,Id)) q:Id=""  d
	.q:Id=0
	.s DlgRowId=""	
	.f  s DlgRowId=$o(^CKB.PDSS.DicLogI("SCOPE",PointType,Pointer,"DHC_CKBDicLinkAttr",Id,"businessAuth",DlgRowId)) q:(DlgRowId="")||(ret'=0)  d
	..&sql(delete from  CKB_PDSS.DicLog where DLG_RowID=:DlgRowId)
	..s ret=SQLCODE
	
	q ret
}

/// Creator: 		bianshuai
/// CreateDate: 	2022-06-23
/// Descript: 		判断用户是否具有审核权限
/// Input:          空(无权限) 权限类型^权限角色id^是否有可用权限
ClassMethod GetUserGrant(mParmas As %String) As %String
{
	n (mParmas)
	s HospID=$p(mParmas,"^",1)   /// 医院
	s PrvTpID=$p(mParmas,"^",2)  /// 职称
	s LocID=$p(mParmas,"^",3)    /// 科室
	s UserID=$p(mParmas,"^",4)   /// 人员
	s PermisStr=""
	
	/// 医院是否开启
	Q:..IsActiveFlag("D", HospID)'="Y" ""

	s ExitFlag = 0 
	s PointTypeList = $lb("U^"_UserID,"L^"_LocID,"C^"_PrvTpID,"D^"_HospID)	// 此list的顺序 就是授权角色的优先级
	f i=1:1:$ll(PointTypeList)  q:ExitFlag=1  d
	.s PointStr = $lg(PointTypeList,i)
	.s PointType = $P(PointStr,"^",1)
	.s PointDr = $P(PointStr,"^",2)
	.s PointActiveFlag = ..IsActiveFlag(PointType,PointDr)	 // 某角色下的用户 是否启用
	.s OtherPointFlag = ..CheckPointType(PointType,PointDr)	 // 该角色下的其他用户是否有可用权限
	.i (PointActiveFlag="N")&&(OtherPointFlag="Y") s ExitFlag=1 // 该角色未启用,该角色下的其他用户有可用权限
	.q:ExitFlag=1
	.q:(PointActiveFlag="N")&&(OtherPointFlag="N")			// 该角色均无可用权限,找下一个优先级权限
	.i (PointActiveFlag="Y") d	// 该角色启用
	..s AbleFlag = $d(^CKB.PDSS.DicLogI("FunSCOPE","businessAuth","DHC_CKBDicLinkAttr",PointType,PointDr))
	..i AbleFlag>1 d // 该角色有维护的权限
	...s PermisStr = PointType_"^"_PointDr_"^"_"Y" 
	..e  d			// 该角色没有维护权限,若该角色的其他用户有权限,则使用该角色的权限
	...i OtherPointFlag="Y"  s PermisStr = PointType_"^"_PointDr_"^"_"N" 
	.i PermisStr'="" s ExitFlag = 1	

	q PermisStr
}

/// Creator: 		bianshuai
/// CreateDate: 	2022-06-23
/// Descript: 		判断用户是否具有审核权限
/// Input:         
/// w ##Class(web.DHCCKBGrantAuth).GetUserGrantItem("3^1^1^10209", .TmpArr)
ClassMethod GetUserGrantItem(mParmas As %String, TmpArr) As %String
{
	n (mParmas, TmpArr)
	
	/// 权限类型
	s mAuthType=..GetUserGrant(mParmas)
	Q:mAuthType="" ""
	s pointType=$p(mAuthType,"^",1), pointDr=$p(mAuthType,"^",2), enableFlag = $p(mAuthType,"^",3)
	q:enableFlag="N" ""

	/// 授权项目
	s mDataID="" 
	F  s mDataID=$o(^CKB.PDSS.DicLogI("FunSCOPE","businessAuth","DHC_CKBDicLinkAttr",pointType,pointDr,mDataID)) Q:mDataID=""  D
	.s libDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(mDataID)),2)	// 目录
	.s itemDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(mDataID)),4)	// 计算项目
	.s TmpArr("GrantAuth", libDr, itemDr)=""
	
	q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2022-06-23
/// Descript: 		审查项目列表
/// Input:          
ClassMethod InsUse(PointType As %String, PointDr As %String, IsUseFlag As %String) As %String
{
	n (PointType, PointDr, IsUseFlag)
	s Err=0
	i '$D(^CF.CKB.PDSS.GrantAuthI("PointType",PointType, PointDr)) D
	.s Err=..InsUseFlag(PointType, PointDr, IsUseFlag)
	E  D
	.s Err=..UpdUseFlag(PointType, PointDr, IsUseFlag)
	Q Err
}

/// Creator: 		bianshuai
/// CreateDate: 	2022-06-23
/// Descript: 		审查项目列表
/// Input:          
ClassMethod InsUseFlag(PointType As %String, PointDr As %String, IsUseFlag As %String) As %String
{
	n (PointType, PointDr, IsUseFlag)
	&SQL(Insert Into CF_CKB_PDSS.GrantAuth(PointType, PointDr, UseFlag) Values(:PointType, :PointDr, :IsUseFlag))
	Q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2022-06-23
/// Descript: 		删除审查项目列表
/// Input:          
ClassMethod UpdUseFlag(PointType As %String, PointDr As %String, IsUseFlag As %String) As %String
{
	n (PointType, PointDr, IsUseFlag)
	&SQL(Update CF_CKB_PDSS.GrantAuth Set UseFlag=:IsUseFlag Where PointType=:PointType And PointDr=:PointDr)
	Q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2022-06-23
/// Descript: 		审查项目列表
/// Input:          Type(授权类型:D/L/U/C:医院/科室/人员/职称),对应授权类型的id
/// OutPut:			Y 可用 N 不可用 默认可用
/// w ##class(web.DHCCKBGrantAuth).IsActiveFlag("D","2")
ClassMethod IsActiveFlag(PointType As %String, PointDr As %String) As %String
{
	n (PointType, PointDr)
	s Ret = "Y"
	q:(PointType="")||(PointDr="") "N"
	s ID=$o(^CF.CKB.PDSS.GrantAuthI("PointType",PointType,PointDr,""))
	Q:ID="" Ret
	
	Q $LG(^CF.CKB.PDSS.GrantAuthD(ID),4)
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-07-06
/// Descript: 		是否有某个角色类型的授权
/// Input:          (授权类型:D/L/U/C:医院/科室/人员/职称)
/// OutPut:			Y 是, N 否 (是否有该类型的授权)
/// w ##class(web.DHCCKBGrantAuth).CheckPointType("U","11")
ClassMethod CheckPointType(pointType As %String, pointDr As %String) As %String
{
	n (pointType,pointDr)
	
	/// 授权项目
	s exitFlag = "N"
	s otherPointDr = ""
	F  s otherPointDr=$o(^CKB.PDSS.DicLogI("FunSCOPE","businessAuth","DHC_CKBDicLinkAttr",pointType,otherPointDr)) Q:(otherPointDr="")||(exitFlag="Y")  D
	.q:otherPointDr=pointDr
	.s isActive = ..IsActiveFlag(pointType,otherPointDr)
	.q:isActive="N"
	.s exitFlag="Y"
	
	q exitFlag
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-07-06
/// Descript: 		角色是否有维护了授权列表
/// Input:          (授权类型:D/L/U/C:医院/科室/人员/职称)
/// OutPut:			Y 是, N 否
/// w ##class(web.DHCCKBGrantAuth).IsPermisFlag("U","11")
ClassMethod IsPermisFlag(pointType As %String, pointDr As %String) As %String
{
	n (pointType,pointDr)
	
	s ret = "N"
	s enableFlag = $d(^CKB.PDSS.DicLogI("FunSCOPE","businessAuth","DHC_CKBDicLinkAttr",pointType,pointDr))
	
	i +enableFlag>0 s ret="Y"	
	
	q ret
}

/// w ##Class(web.DHCCKBGrantAuth).GetTest("2^8^1^11871") //11871^8^1^289^2
ClassMethod GetTest(str) As %String
{
	n (str)
	 k TmpArr
	 /// 医院^职称^科室^人员

	 d ..GetUserGrantItem(str,.TmpArr)
	 b //111
	 q ""
}

}
