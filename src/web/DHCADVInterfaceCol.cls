Import SQLUSER

/// Descript:接口字段维护
/// CreateDate:2020-03-20
/// Creator:sufan
Class web.DHCADVInterfaceCol Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2018-01-04
/// Description：  接口字段维护
/// Table：        User.DHCAdvInterfaceCol
/// Input：		   ID^code^desc^Y/N
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCADVInterfaceCol).SaveIntCol("^22^22")
ClassMethod SaveIntCol(params As %String) As %String
{
	n (params)
	s Err=0
	TS
	s Len=$l(params,"$$")
	for i=1:1:Len  d
	.s ListData=$p(params,"$$",i)
	.s Err=..CheckRepeat(ListData)   	/// 重复性判断
	.q:Err'=0
	.i $p(ListData,"^",1)'=""  q:Err'=0  d
	..s Err=..UpdateIntCol(ListData)  /// 更新
	.e  d
	..s Err=..InsertIntCol(ListData)  /// 插入
	i Err'=0 tro
	q:Err'=0 Err
	TC
	q Err
}

/// Creator：      sufan
/// CreatDate：    2018-01-04
/// Description：  接口字段维护
/// Table：        User.DHCAdvInterfaceCol
/// Input：		   ID^code^desc^Y/N
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCADVInterfaceCol).InsertIntCol("^22^22")
ClassMethod InsertIntCol(ListData As %String) As %String
{
	n (ListData)
	s AFCCode=$p(ListData,"^",2)     		/// code
	s AFCDesc=$p(ListData,"^",3)	 		/// desc
	s AFCHospDr=$p(ListData,"^",4)
	&SQL(Insert into DHC_AdvInterfaceCol (AFC_Code,AFC_Desc,AFC_HospDr) values 
	(:AFCCode,:AFCDesc,:AFCHospDr))
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-01-04
/// Description：  接口字段维护
/// Table：        User.DHCAdvInterfaceCol
/// Input：		   ID^code^desc^Y/N
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCADVInterfaceCol).UpdateIntCol("^22^22^65^Y^dsds")
ClassMethod UpdateIntCol(ListData As %String) As %String
{
	n (ListData)
	s AFCRowId=$p(ListData,"^",1) 			/// id
	s AFCCode=$p(ListData,"^",2)     		/// code
	s AFCDesc=$p(ListData,"^",3)	 		/// desc
	s AFCHospDr=$p(ListData,"^",4)
	&SQL(Update DHC_AdvInterfaceCol Set AFC_Code=:AFCCode,AFC_Desc=:AFCDesc,AFC_HospDr=:AFCHospDr Where AFC_RowID =:AFCRowId)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-01-04
/// Description：  接口字段维护
/// Table：        User.DHCAdvInterfaceCol
/// Input：		   Id
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCADVInterfaceCol).DelIntCol()
ClassMethod DelIntCol(AFCRowID As %String) As %String
{
	n (AFCRowID)
	&sql(delete from DHC_AdvInterfaceCol where AFC_RowID=:AFCRowID)
	q SQLCODE
}

/// Creator：  sufan
/// CreatDate: 2017-07-06
/// Descript:  检查代码、描述是否重复
/// Table：    User.DHCAdvInterfaceCol
/// Others：   w ##class(web.DHCADVInterfaceCol).CheckRepeat("^11^11^65^Y")
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	N (ItmTempStr)
	S ret=0
	S ID=$p(ItmTempStr,"^",1)   	 ///ID
	S AFCCode=$p(ItmTempStr,"^",2)  	 ///代码
	S AFCDesc=$p(ItmTempStr,"^",3) 	 ///描述
	S AFCHospDr=$p(ItmTempStr,"^",4)
	S Flag=0
	S ID=""
	F  S ID=$o(^DHCADVAFC(0,"Code",$$ALPHAUP^SSUTIL4((AFCCode)),ID))  Q:(+ID=0)||(Flag'="0")  D
	.s Code=$p($g(^DHCADVAFC(ID)),"^",1)    //代码
	.s Desc=$p($g(^DHCADVAFC(ID)),"^",2)    //描述
	.s HospDr=$p($g(^DHCADVAFC(ID)),"^",4)
	.S:(AFCID="")&&(AFCHospDr=HospDr)&&(Code=AFCCode) Flag="-1"
	.S:(AFCID="")&&(AFCHospDr=HospDr)&&(Desc=AFCDesc) Flag="-2"
	.S:(AFCID'="")&&(AFCID'=ID)&&(Code=AFCCode) Flag="-3"
	.S:(AFCID'="")&&(AFCID'=ID)&&(Desc=AFCDesc) Flag="-4"
	.Q:Flag'="0"
	
	Q:Flag'="0" Flag
	
	S ID=""
	F  S ID=$o(^DHCADVAFC(0,"Desc",$$ALPHAUP^SSUTIL4((AFCDesc)),ID))  Q:(+ID=0)||(Flag'="0")  D
	.s Code=$p($g(^DHCADVAFC(ID)),"^",1)    //代码
	.s Desc=$p($g(^DHCADVAFC(ID)),"^",2)    //描述
	.s HospDr=$p($g(^DHCADVAFC(ID)),"^",4)
	.S:(AFCID="")&&(AFCHospDr=HospDr)&&(Code=AFCCode) Flag="-1"
	.S:(AFCID="")&&(AFCHospDr=HospDr)&&(Desc=AFCDesc) Flag="-2"
	.S:(AFCID'="")&&(AFCID'=ID)&&(Code=AFCCode) Flag="-3"
	.S:(AFCID'="")&&(AFCID'=ID)&&(Desc=AFCDesc) Flag="-4"
	.Q:Flag'="0"
	Q Flag
}

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  查询
/// Table：        User.DHCAdvInterfaceCol
/// Input：		   params:"代码^描述"
/// Output：       
/// Others：       w ##Class(web.DHCADVInterfaceCol).QueryIntCol(10,1,"")
ClassMethod QueryIntCol(rows As %String, page As %String, params As %String, HospDr = "") As %String
{
	n (rows,page,params,HospDr)
	S End = page*rows
	S Start=(page-1)*rows+1
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1     //开始行
	s Code=$p(params,"^",1)    // 在串params中取值
	s Desc=$p(params,"^",2)
	s h=0,count=0
	w "{""rows"":["
	s AFCRowID=""
	for  s AFCRowID=$o(^DHCADVAFC(AFCRowID)) q:AFCRowID=""  d  
	.q:AFCRowID=0
	.s AFCCode=$p(^DHCADVAFC(AFCRowID),"^",1)      				// code
	.s AFCDesc=$p(^DHCADVAFC(AFCRowID),"^",2)	  				// desc
	.s AFCHospDr=$p(^DHCADVAFC(AFCRowID),"^",4)
	.q:(HospDr'="")&&(AFCHospDr'="")&&(AFCHospDr'=HospDr)
	.q:(Code'="")&(AFCCode'[Code)							// 代码过滤
	.q:(Desc'="")&(AFCDesc'[Desc)							// 描述过滤
	.s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.s tmpObj={}
	.s tmpObj.ID=AFCRowID
	.s tmpObj.Code=AFCCode
	.s tmpObj.Desc=AFCDesc
	.s tmpObj.HospDr=AFCHospDr
	.w tmpObj.%ToJSON()
	w "],""total"":"_count_"}"
	q ""
}

}
