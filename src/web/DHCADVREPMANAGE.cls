Import sqluser

Class web.DHCADVREPMANAGE Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 保存[不良事件后台管理信息]
/// Creator:     CongYue
/// CreateDate:  2016-03-29
/// Table: 	 	 DHC_AdvRepManage
/// Input:  	 DataList: 不良事件后台管理数据信息, 以字符"^"分割,格式为：ID, 报告类别ID^报告ID^级别^级别ID^处理办法ID^改进办法ID^职能部门意见陈述^改进措施&&ID^报告类别^报告ID^级别^级别ID^处理办法ID^改进办法ID^职能部门意见陈述^改进措施,
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVREPMANAGE).SaveRepManage("14^^^4^10^1^1^主管部门意见陈述^持续改进措施")
ClassMethod SaveRepManage(params As %String) As %String
{
	N (params)
	S ret=0
	I $p(params,"^",1)'="" D
	.S ret=..UpdRepManage(params)
	E  D
	.S ret=..InsRepManage(params)
	q 0_"^"_ret
}

/// Description: 更新[不良事件后台管理信息]
/// Creator:     CongYue
/// CreateDate:  2016-03-29
/// Table: 	 	 DHC_AdvRepManage
/// Input:  	 DataList: 不良事件后台管理数据信息, 以字符"^"分割,格式为：ID, 报告类别^报告ID^级别^级别ID^处理办法ID^改进办法ID^职能部门意见陈述^改进措施,
/// Return:	 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVREPMANAGE).UpdRepManage("55^1^25^0^1^1^1^主管部门意见陈述^持续改进措施")
ClassMethod UpdRepManage(DataList) As %String
{
	N (DataList)
	S armaID=$p(DataList,"^",1)
	S ArmaTypeDr=$p(DataList,"^",2)
	;S ArmaTypeDr=$o(^DHCMEDADREVT(0,"Code",ArmaType,""))
	S ArmaPointer=$p(DataList,"^",3)
	S ArmaLevelDr=$p(DataList,"^",4)
	S ArmaCatDr=$p(DataList,"^",5)
	S ArmaDealMethDr=$p(DataList,"^",6)
	S ArmaImpMethDr=$p(DataList,"^",7)
	S ArmaAdviceTxt=$p(DataList,"^",8)
	S ArmaImpTxt=$p(DataList,"^",9)
	
	&SQL(Update DHC_AdvRepManage Set ARMA_Type_Dr=:ArmaTypeDr,ARMA_Pointer=:ArmaPointer,ARMA_Level_Dr=:ArmaLevelDr,
	ARMA_Cat_Dr=:ArmaCatDr,ARMA_DealMeth_Dr=:ArmaDealMethDr, ARMA_ImpMeth_Dr=:ArmaImpMethDr,ARMA_AdviceTxt=:ArmaAdviceTxt,
	ARMA_ImpTxt=:ArmaImpTxt WHERE ARMA_RowID=:armaID)
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Description: 增加[不良事件后台管理信息]
/// Creator:     CongYue
/// CreateDate:  2016-03-29
/// Table: 	 	 DHC_AdvRepManage
/// Input:  	 DataList: 不良事件后台管理数据信息, 以字符"^"分割,格式为：报告类别^报告ID^级别^级别ID^处理办法ID^改进办法ID^职能部门意见陈述^改进措施,
/// Return:	 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVREPMANAGE).InsRepManage("^1^25^0^10^1^1^主管部门意见陈述^持续改进措施")
ClassMethod InsRepManage(DataList As %String) As %String
{

	N (DataList)
	S ArmaTypeDr=$p(DataList,"^",2)
	;S ArmaTypeDr=$o(^DHCMEDADREVT(0,"Code",ArmaType,""))
	S ArmaPointer=$p(DataList,"^",3)
	S ArmaLevelDr=$p(DataList,"^",4)
	S ArmaCatDr=$p(DataList,"^",5)
	S ArmaDealMethDr=$p(DataList,"^",6)
	S ArmaImpMethDr=$p(DataList,"^",7)
	S ArmaAdviceTxt=$p(DataList,"^",8)
	S ArmaImpTxt=$p(DataList,"^",9)
	
 	&SQL(INSERT INTO DHC_AdvRepManage(ARMA_Type_Dr,ARMA_Pointer,ARMA_Level_Dr,ARMA_Cat_Dr,ARMA_DealMeth_Dr, ARMA_ImpMeth_Dr,ARMA_AdviceTxt,ARMA_ImpTxt) VALUES
		(:ArmaTypeDr,:ArmaPointer,:ArmaLevelDr,:ArmaCatDr,:ArmaDealMethDr,:ArmaImpMethDr,:ArmaAdviceTxt,:ArmaImpTxt))
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

// 

/// Description: 删除 [不良事件后台管理信息]
/// Creator:     CongYue
/// CreateDate:  2016-03-29
/// Table: 	 	 DHC_AdvRepManage
/// Input:   	 表的id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVREPMANAGE).DelRepManage("1")
ClassMethod DelRepManage(ArmaID As %String) As %String
{
	N (ArmaID)
	&SQL(Delete From DHC_AdvRepManage Where ARMA_RowID=:ArmaID)
	Q SQLCODE
}

/// Description: 所发生不良事件类别
/// Creator:     CongYue
/// CreateDate:  2016-03-29
/// Table:		 DHC_AdvMedRepCat
/// Output:  	 一级类别描述（下拉框显示）  
/// Others:		 w ##class(web.DHCADVREPMANAGE).SelMainCat()
ClassMethod SelMainCat() As %String
{
	s count=0
	w "["
	S ID=""
	F  S ID=$o(	^DHCADVMEDRCA(ID)) Q:ID=""  D
	.Q:ID=0
	.S Desc=$p(^DHCADVMEDRCA(ID),"^",2) //描述
	.S Level=$p(^DHCADVMEDRCA(ID),"^",3) //级别
	.S Levelrowid=$p(^DHCADVMEDRCA(ID),"^",4) //上一级别的rowid
	.S Active=$p(^DHCADVMEDRCA(ID),"^",5) //是否可用
	.Q:Active="N"
	.Q:Level'="1"
	.S tmp=ID_"^"_Desc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Description: 所发生不良事件类别
/// Creator:     CongYue
/// CreateDate:  2016-03-29
/// Table:		 DHC_AdvMedRepCat
/// Output:  	 二级类别描述（下拉框显示）  
/// Others:		 w ##class(web.DHCADVREPMANAGE).SelSubCat("1")
ClassMethod SelSubCat(params As %String) As %String
{
	
	n (params)
	
	;q:Input="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出空的json串
	s count=0
	w "["
	S ID=""
	F  S ID=$o(	^DHCADVMEDRCA(0,"LevelRowID",params,ID)) Q:ID=""  D
	.Q:ID=0
	.S Desc=$p(^DHCADVMEDRCA(ID),"^",2) //描述
	.S Level=$p(^DHCADVMEDRCA(ID),"^",3) //级别
	.S Levelrowid=$p(^DHCADVMEDRCA(ID),"^",4) //上一级别的rowid
	.S Active=$p(^DHCADVMEDRCA(ID),"^",5) //是否可用
	.Q:Active="N"
	.S tmp=ID_"^"_Desc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Description: 处理办法
/// Creator:     CongYue
/// CreateDate:  2016-03-29
/// Table:		 DHC_AdvDealMethod
/// Output:  	 处理办法描述（下拉框显示）  
/// Others:		 w ##class(web.DHCADVREPMANAGE).SelDealMethod(2)
ClassMethod SelDealMethod(LgHospID As %String) As %String
{
	n (LgHospID)
	s count=0
	w "["
	S ID=""
	F  S ID=$o(^DHCADVDEMED(ID)) Q:ID=""  D
	.Q:ID=0
	.S Desc=$p(^DHCADVDEMED(ID),"^",2) //描述
	.S Active=$p(^DHCADVDEMED(ID),"^",3) //是否可用
	.Q:Active="N"
	.s HospDr=$p(^DHCADVDEMED(ID),"^",4) //医院 //hxy 2019-07-04 st
	.q:(HospDr'="")&&(HospDr'=LgHospID) //ed
	.S tmp=ID_"^"_Desc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Description: 改进办法
/// Creator:     CongYue
/// CreateDate:  2016-03-29
/// Table:		 DHC_AdvImpMethod
/// Output:  	 改进办法描述（下拉框显示）  
/// Others:		 w ##class(web.DHCADVREPMANAGE).SelImpMethod(2)
ClassMethod SelImpMethod(LgHospID As %String) As %String
{
	n (LgHospID)
	s count=0
	w "["
	S ID=""
	F  S ID=$o(^DHCADVIMPMED(ID)) Q:ID=""  D
	.Q:ID=0
	.S Desc=$p(^DHCADVIMPMED(ID),"^",2) //描述
	.S Active=$p(^DHCADVIMPMED(ID),"^",3) //是否可用
	.Q:Active="N"
	.s HospDr=$p(^DHCADVIMPMED(ID),"^",4) //医院 //hxy 2019-07-04 st
	.q:(HospDr'="")&&(HospDr'=LgHospID) //ed
	.S tmp=ID_"^"_Desc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Description: 获取  不良事件后台管理信息  
/// Creator:	 CongYue
/// CreateDate:  2016-03-31
/// Table: 		 DHC_AdvRepManage
/// Input:  	 评估报告id
/// Return： 	 不良事件后台管理信息
/// Others:		 w ##class(web.DHCADVREPMANAGE).GetRepManageInfo("1")
ClassMethod GetRepManageInfo(adrRepID As %String, RepType As %String) As %String
{
	n (adrRepID,RepType)
	s armaID=$o(^DHCADVREPMAN(0,"TyepPointer",RepType,adrRepID,""))
	
	if armaID=""  d
	.s ListData=""
	e  d  
	.s armaTypeDr=$p(^DHCADVREPMAN(armaID),"^",1) // 报告类型id
	.s armaLevelDr=$p(^DHCADVREPMAN(armaID),"^",3) //不良事件等级
	.s armaCatDr=$p(^DHCADVREPMAN(armaID),"^",4) //不良事件类别
	.s armaCatDesc="",armaCatpid="",CatpidDesc=""
	.S:+armaCatDr'="0" armaCatDesc=$p(^DHCADVMEDRCA(armaCatDr),"^",2) //一级描述
	.s:+armaCatDr'="0" armaCatpid=$o(^DHCADVMEDRCA(0,"LevelRowID",armaCatDr,""))
	.i +armaCatpid'="0" & armaCatpid'=0  d
	..s armaCatpid=armaCatDr
	..S CatpidDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //二级描述
	..s armaCatDr=""
	..s armaCatDesc=""
	.e  d
	..S:+armaCatDr'="0" armaCatpid=$p(^DHCADVMEDRCA(armaCatDr),"^",4)
	..S:+armaCatpid'="0" CatpidDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //二级描述
	.S DealMethDesc=""
	.s armaDealMethDr=$p(^DHCADVREPMAN(armaID),"^",5) //处理办法id
	.I armaDealMethDr'="" S DealMethDesc=$p(^DHCADVDEMED(armaDealMethDr),"^",2) //处理办法描述
	.S ImpMethDesc=""
	.s armaImpMethDr=$p(^DHCADVREPMAN(armaID),"^",6) //改进办法id
	.I armaImpMethDr'="" S ImpMethDesc=$p(^DHCADVIMPMED(armaImpMethDr),"^",2) //改进办法描述
	.s armaAdviceTxt=$p(^DHCADVREPMAN(armaID),"^",7) //部门陈述意见
	.s armaImpTxt=$p(^DHCADVREPMAN(armaID),"^",8) //改进措施
	.s ListData=armaTypeDr_"!"_armaID_"!"_armaLevelDr_"!"_armaCatpid_"!"_armaCatDr_"!"_armaDealMethDr_"!"_armaImpMethDr_"!"_armaAdviceTxt_"!"_armaImpTxt
	.s ListData=ListData_"!"_armaCatDesc_"!"_CatpidDesc_"!"_DealMethDesc_"!"_ImpMethDesc
	q ListData
}

/// Description: 判断报告是否被评估过
/// Creator:     QuNianpeng
/// CreateDate:  2018-1-9
/// Table: 	 	 
/// Input:  	 报告id
/// Return: 	 1评估过  0 未评估
/// Others:		w ##class(web.DHCADVREPMANAGE).CheckAssess(936)
ClassMethod CheckAssess(repID As %String) As %String
{
	n (repID)
	q:repID="" 0	
	q:$d(^DHCADVREPMAN(0,"Pointer",repID)) 1
	q:'$d(^DHCADVREPMAN(0,"Pointer",repID)) 0
}

}
