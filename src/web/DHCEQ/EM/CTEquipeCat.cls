Class web.DHCEQ.EM.CTEquipeCat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*// add by lmm 2018-08-16
/// 描述：hisui改造 根据类组查询类型
/// 入参：Desc 设备类组
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.CTEquipeCat","GetEquipeCat","其他兽医设备")
Query GetEquipeCat(Desc) As %SQLQuery(ROWSPEC = "TDescription:%String,TRowID:%String,TCode:%String,TParCatDR:%String,TParCatCode:%String,TParCat:%String")
{
	SELECT EC_Desc,
		   EC_RowID,
		   EC_Code,
		   EC_ParCatDR,
		   EC_ParCatDR->EC_Code,
		   EC_ParCatDR->EC_Desc
	FROM sqluser.DHC_EQCEquipeCat
	where EC_InvalidFlag = 'N' and EC_Desc like nvl(:Desc,'')||'%'
}*/
/// MZY0030		2020-06-09	取消IncludeFlag参数控制,增加StatCatDR和EditFlag
/// MZY0030	1340074		2020-06-01
/// 设备分类查询放大镜由SQL改为query
/// 入参：	Desc			描述或代码  
/// 			EquipTypeDR		管理类组
/// 			StatCatDR		设备类型
/// 				EditFlag		编辑标识:非空为编辑状态,启用系统参数分类控制"992004"
/// 	输出：结果明细
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.CTEquipeCat","GetEquipeCat","",2,8,1)
Query GetEquipeCat(Desc As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EditFlag As %String = "") As %Query(ROWSPEC = "TDescription:%String,TRowID:%String,TCode:%String,TParCatDR:%String,TParCatCode:%String,TParCat:%String")
{
}

ClassMethod GetEquipeCatExecute(ByRef qHandle As %Binary, Desc As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EditFlag As %String = "") As %Status
{
	new repid, index,RowID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;s ^DHCEQMozy("web.DHCEQCEquipeCat")=Desc_","_EquipTypeDR_","_StatCatDR_","_EditFlag
	s index=1
	s Flag=##class(web.DHCEQCommon).GetSysInfo("990014") ;分类最末级限制参数 0:不限制  1:限制  2:提示
	s FinanceType=$p($g(^DHCEQCCode("DHCEQCEquipType", +EquipTypeDR)),"^",9)
	s CatSysInfo=##class(web.DHCEQCommon).GetSysInfo("992004")
	
	s RowID=0
	for  s RowID=$o(^DHCEQCCode("DHCEQCEquipeCat",RowID)) quit:RowID=""  d
	.d ResetVariablesGetEquipeCat
	.s TRowID=RowID
	.;MZY0030		2020-06-09	系统参数进行分类控制
	.s FTParentDR=$p($g(^DHCEQCCode("DHCEQCEquipeCat",RowID)),"^",10)		//czf 1904153 2021-05-07 begin
	.s SCParentDR=$p($g(^DHCEQCCode("DHCEQCEquipeCat",RowID)),"^",11)
	.q:(EditFlag'="")&&(CatSysInfo=1)&&(FTParentDR'=FinanceType)
	.q:(EditFlag'="")&&(CatSysInfo=2)&&(SCParentDR'="")&&(StatCatDR'="")&&(SCParentDR'=StatCatDR)	//设备分类所属类型不为空时按类型过滤	
	.q:(EditFlag'="")&&(CatSysInfo=2)&&((SCParentDR="")||(StatCatDR=""))&&(EquipTypeDR'="")&&(FTParentDR'=FinanceType)	//设备分类所属类型为空或设备类型为空时按财务大类过滤 //czf 1904153 2021-05-07 end
	.s Find='$d(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",RowID))	//是最末级:1 否:0
	.q:(+Flag=1)&&(Find=0)	//限制则只输出最末级
	.s TCode=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",1)
	.s TDesc=$P(^DHCEQCCode("DHCEQCEquipeCat",RowID),"^",2)
	.s AText=""			//modified by czf 20210430 begin
	.s ARowID=##Class(web.DHCEQ.Plat.CTAlias).GetAlias("DHCEQCEquipeCat",RowID,"text","PYCode")
	.i ARowID'="" s AText=$p($g(^DHCEQCCode("DHCEQCAlias",ARowID)),"^",1)
	.i AText="" s AText=##class(web.DHCEQCHanZiEncoding).GetEncoding(TDesc,4,"","U")
	.q:(Desc'="")&&(TDesc'[Desc)&&($ZConvert(TCode,"U")'[$ZConvert(Desc,"U"))&&(AText'[$ZConvert(Desc,"U"))		//modified by czf 20210430 end
	.q:$p($g(^DHCEQCCode("DHCEQCEquipeCat",RowID)),"^",7)="Y"
	.s TParCatDR=$p($g(^DHCEQCCode("DHCEQCEquipeCat",RowID)),"^",4)
	.s TParCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TParCatDR)),"^",1)
	.s TParCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TParCatDR)),"^",2)
	.d OutputRowGetEquipeCat
	Quit $$$OK
OutputRowGetEquipeCat
	Set Data=$lb(TDesc,TRowID,TCode,TParCatDR,TParCatCode,TParCat)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipeCat
	s (TDesc,TRowID,TCode,TParCatDR,TParCatCode,TParCat)=""
	quit
}

ClassMethod GetEquipeCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipeCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEquipeCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipeCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// add by zc2018-10-19  zc0039
/// 描述：hisui改造 根据分类ID生成html页面信息
/// 入参：id:分类ID text:分类描述
/// 返回值描述：生成html页面信息
ClassMethod CreateRoot(id, text)
{
	
	new html
	s html="<div id='tDHCEQCEquipCatTree' style='background-color: '>"
	s html=html_"<SPAN id=Tree_"_id_">"
	s html=html_"<DIV noWrap><NOBR>"
	s html=html_"<IMG id=Icon"_id_" style=""CURSOR:hand"" src=""../images/tree/root.gif"" align=absMiddle onclick=""ExpandTree("_id_")"">"
	s html=html_"<A id=Link"_id_" hideFocus title="""_text_""" onclick="_"""NodeClick("_id_")"""_" href=""#"">"_text_"</A>"
	s html=html_"</NOBR></DIV>"
	
	s html=html_"<SPAN id=Set_"_id_" style=""DISPLAY:none"">"
	s html=html_"<input id=""HasChild"_id_""" name=""HasChild"_id_""" type=""hidden"" value=""1"">"
	s html=html_"<input id=""Loaded"_id_""" name=""Loaded"_id_""" type=""hidden"" value=""0"">"
	s html=html_"<input id=""Parent"_id_""" name=""Parent"_id_""" type=""hidden"" value="""">"
	s html=html_"<input id=""Layer"_id_""" name=""Layer"_id_""" type=""hidden"" value=""0"">"
	s html=html_"<input id=""IsLast"_id_""" name=""IsLast"_id_""" type=""hidden"" value="""">"
	s html=html_"<input id=""ID"_id_""" name=""ID"_id_""" type=""hidden"" value="""_id_""">"
	s html=html_"</SPAN>"
	
	s html=html_"<SPAN id=Child"_id_" style=""DISPLAY:none""></SPAN>"
	s html=html_"</SPAN>"
	q html
}

}
