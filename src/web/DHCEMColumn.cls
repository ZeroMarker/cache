Import sqluser

Class web.DHCEMColumn Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

Property field As %String;

Property title As %String;

Property width As %String;

Property align As %String;

Property checkbox As %String;

Property styler As %String;

Property formatter As %String;

Property cellStyle As %String;

Property style As %String;

Property visible As %String;

/// d ##class(web.DHCEMColumn).getColumn(0,"DefaultSee")
ClassMethod getColumn(HospitalRowId = "", queryTypeCode = "") As %String
{
	q:HospitalRowId="" ""
	q:queryTypeCode="" ""
	
	s varStr=$G(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode,"VarId"))
    q:$g(varStr)="" ""
    s len=$l(varStr,"^")
    q:len=0 ""
    s jsonObj=##class(web.DHCAPPJsonObject).%New()
     w "["
    s obj=##class(web.DHCEMColumn).%New()
    s obj.title="选择"
    s obj.field="select"
    s obj.checkbox="true"
    w jsonObj.ObjToJson(obj)
    i "PSDO"=queryTypeCode d
    .w ","
    .s obj.field="op"
    .s obj.checkbox=""  
    .s obj.title="op"
    .s obj.formatter="opFormatter"
    .w jsonObj.ObjToJson(obj)  
    f i=1:1:len d
    .s obj=##class(web.DHCEMColumn).%New()
    .s obj.title=$p(^DHCCLNurseExec("Var",$p(varStr,"^",i)),"^",1)
    .s obj.field=$p(^DHCCLNurseExec("Var",$p(varStr,"^",i)),"^",2)
	.//w $case(i,1:"",:","
	.i $p(^DHCCLNurseExec("Var",$p(varStr,"^",i)),"^",2)="arcimDesc" d
	..s obj.formatter="arcimDescFormatter"
	..s obj.style="arcimDescCellStyle"
	.i $p(^DHCCLNurseExec("Var",$p(varStr,"^",i)),"^",2)="placerNo" d
	..s obj.formatter="placerNoFormatter"
	.i $p(^DHCCLNurseExec("Var",$p(varStr,"^",i)),"^",2)="prtFlag" d
	..s obj.style="prtFlagCellStyle"
	.i $p(^DHCCLNurseExec("Var",$p(varStr,"^",i)),"^",2)="disposeStatDesc" d  //hxy 2016-12-01 cellstyle
	..s obj.style="disposeStatDescCellStyle"  //hxy 2016-12-01 cellstyle
	.s obj.width=..getColumnWidth(obj.field)
	.w ","
	.w jsonObj.ObjToJson(obj) 
    w "]"
    q ""
}

/// d ##class(web.DHCEMColumn).getColumnNew(4)
ClassMethod getColumnNew(execFormID = "") As %String
{
	q:execFormID="" "[]"
	s formItmRowID = $o(^DHCEMEFSI(0,"ExecForm",+execFormID,"Column",""))
	q:+formItmRowID=0 ""
	s queryTypeCode = $p(^DHCEMEFS(execFormID),"^",1)
	
	s varStr=$p(^DHCEMEFSI(formItmRowID),"^",3)
    q:$g(varStr)="" ""
    s len=$l(varStr,"#")
    q:len=0 ""
    s jsonObj=##class(web.DHCAPPJsonObject).%New()
     w "["
    s obj=##class(web.DHCEMColumn).%New()
    s obj.title=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","选择")
    s obj.field="select"
    s obj.checkbox="true"
    w jsonObj.ObjToJson(obj)
    ;i "PSDO"=queryTypeCode d //hxy 2020-06-22 st
    i queryTypeCode["PSD" d //ed
    .w ","
    .s obj.field="op"
    .s obj.checkbox=""  
    .s obj.title=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","皮试") //"op"
    .s obj.formatter="opFormatter"
    .w jsonObj.ObjToJson(obj)  
    f i=1:1:len d
    .s obj=##class(web.DHCEMColumn).%New()
    .q:+$p(varStr,"#",i)=0
    .q:'$d(^DHCCLNurseExec("Var",+$p(varStr,"#",i)))
    .s obj.title=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp",$p(^DHCCLNurseExec("Var",$p(varStr,"#",i)),"^",1))
    .s obj.field=$p(^DHCCLNurseExec("Var",$p(varStr,"#",i)),"^",2)
	.//w $case(i,1:"",:","
	.i $p(^DHCCLNurseExec("Var",$p(varStr,"#",i)),"^",2)="arcimDesc" d
	..s obj.formatter="arcimDescFormatter"
	..s obj.style="arcimDescCellStyle"
	.i $p(^DHCCLNurseExec("Var",$p(varStr,"#",i)),"^",2)="placerNo" d
	..s obj.formatter="placerNoFormatter"
	.i $p(^DHCCLNurseExec("Var",$p(varStr,"#",i)),"^",2)="prtFlag" d
	..s obj.style="prtFlagCellStyle"
	.i $p(^DHCCLNurseExec("Var",$p(varStr,"#",i)),"^",2)="disposeStatDesc" d  //hxy 2016-12-01 cellstyle
	..s obj.style="disposeStatDescCellStyle"  //hxy 2016-12-01 cellstyle
	.s obj.width=..getColumnWidth(obj.field)
	.w ","
	.w jsonObj.ObjToJson(obj) 
    w "]"
    q ""
}

ClassMethod queryColumn(cspName, tableId, column, menuId) As %String
{
	
	n (cspName, tableId ,column,menuId,%session)
	s:+menuId'=0 cspName=..getLinkUrl(menuId)
	s cspName=$$ALPHAUP^SSUTIL4(cspName)
	d ..autoSave(cspName, tableId ,column)
	
	s User=%session.Get("LOGON.USERID")
	s Group=%session.Get("LOGON.GROUPID")
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	
	w "{""rows"":["
	s pri="U^G^D",count=0,flag=0
	f i=1:1:$l(pri,"^") d
	.s type=$p(pri,"^",i)
	.SET pointer=$SELECT(type="G":Group,type="U":User,type="D":"DHC")
	.q:flag=1
	.s sgs=""
	.f  s sgs=$o(^DHCEMSGS(0,"Grid",$$ALPHAUP^SSUTIL4(cspName),tableId,type,pointer,sgs)) q:sgs=""  d
	..s flag=1
	..s count=count+1
	..w $case(count,1:"",:",")
	..s obj=##class(User.DHCEmSysGridSet).%OpenId(sgs,0)
	..w jsonObj.ObjToJson(obj) 
	w "],""total"":"_count_"}"
	
	q ""
}

ClassMethod getColumnByTable(cspName, tableId, column, menuId) As %String
{
	
	n (cspName, tableId ,column,menuId,%session)
	q:tableId="" ""
	s:+menuId'=0 cspName=..getLinkUrl(menuId)
	s cspName=$$ALPHAUP^SSUTIL4(cspName)
	d ..autoSave(cspName, tableId ,column)
	s User=%session.Get("LOGON.USERID")
	s Group=%session.Get("LOGON.GROUPID")
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
	
	s pri="U^G^D",flag=0
	f i=1:1:$l(pri,"^") d
	.s type=$p(pri,"^",i)
	.SET pointer=$SELECT(type="G":Group,type="U":User,type="D":"DHC")
	.q:flag=1
	.s sgs=""
	.f  s sgs=$o(^DHCEMSGS(0,"Grid",$$ALPHAUP^SSUTIL4(cspName),tableId,type,pointer,sgs)) q:sgs=""  d
	..s flag=1
	..s sort=+$p(^DHCEMSGS(sgs),"^",11)
	..s hidden=$p(^DHCEMSGS(sgs),"^",10)
	..//q:hidden="Y"
	..s ^TMP("DHCEM","web.DHCEMColumn","getColumnByTable",pid,sort)=sgs
	
 
	
	
	w "["
	s sort=0,count=0
	f  s sort=$o(^TMP("DHCEM","web.DHCEMColumn","getColumnByTable",pid,sort)) q:sort=""  d
	.s sgs=^TMP("DHCEM","web.DHCEMColumn","getColumnByTable",pid,sort)
	.s count=count+1
	.w $case(count,1:"",:",")
	.s tmpobj=##class(User.DHCEmSysGridSet).%OpenId(sgs,0)
	.s obj=##class(web.DHCEMColumn).%New()
	.s obj.field=tmpobj.SGSKey
	.s obj.title=tmpobj.SGSName
	.s obj.formatter=""
	.s obj.width=+tmpobj.SGSWidth
	.s obj.align=tmpobj.SGSAlignment
	.s obj.visible=$CASE(tmpobj.SGSHidden,"N":"true",:"false")
	.w jsonObj.ObjToJson(obj)
	w "]"
	k ^TMP("DHCEM","web.DHCEMColumn","getColumnByTable",pid)
	q ""
}

ClassMethod autoSave(cspName, tableId, column) As %String
{
	
	n (cspName, tableId ,column)
	q:tableId="" ""
	s ret=0
	i $d(^DHCEMSGS(0,"Grid",$$ALPHAUP^SSUTIL4(cspName),tableId))<1 d
	.s orderNum=1
	.f i=1:1:$l(column,"$$") d
	..q:ret'=0
	..s ss=$p(column,"$$",i)
	..s obj=##class(User.DHCEmSysGridSet).%New()
	..s obj.SGSCspName=cspName
	..s obj.SGSGridID=tableId
	..s obj.SGSKey=$p(ss,"^",1)
	..s obj.SGSName=$p(ss,"^",2)
	..s obj.SGSSaveFor="D"
	..s obj.SGSReference="DHC"
	..s obj.SGSOrderNum=orderNum
	..s obj.SGSHidden="N"
	..s obj.SGSAlignment="center"
	..s obj.SGSWidth=+$p(ss,"^",3)
	..s sc=obj.%Save()
	..If $System.Status.IsError(sc) s ret=-1
	..s orderNum=orderNum+1
	q ret
}

ClassMethod saveTable(jsonStr, cspName, tableId, menuId, type, pointer) As %String
{
	
	n (jsonStr,cspName,tableId,menuId,type,pointer)
	s:+menuId'=0 cspName=..getLinkUrl(menuId)
	s cspName=$$ALPHAUP^SSUTIL4(cspName)
	//s ^ZXZX=cspName_"^"_tableId_"^"_type_"^"_pointer
	&sql(delete from DHC_EmSysGridSet where SGS_CspName=:cspName and SGS_GridID=:tableId and SGS_SaveFor=:type and SGS_Reference=:pointer)
	s ret=0
	f i=1:1:$l(jsonStr,"$$") d
	.q:ret'=0
	.s json=$p(jsonStr,"$$",i)
	.s obj=##class(web.DHCAPPJsonObject).FromJSON(json).Bean("User.DHCEmSysGridSet")
	.s obj.SGSCspName=$$ALPHAUP^SSUTIL4(cspName)
	.s obj.SGSGridID=tableId
	.s obj.SGSSaveFor=type
	.s obj.SGSReference=pointer
	.s sc=obj.%Save()
	.If $System.Status.IsError(sc) s ret=-1
	i ret'=0 Do $System.Status.DisplayError(sc)	
	w ret
	q ""
}

/// @param : %String menuId websys.Menu 的 id
/// 菜单对应的csp
/// w ##class(web.DHCEMColumn).getLinkUrl(55330)
ClassMethod getLinkUrl(menuId) As %String
{
	
	n (menuId)
	Set Obj=##Class(websys.Menu).%OpenId(menuId,0)
	q Obj.LinkUrl
}

// w ##class(web.DHCEMColumn).getAlignment()

ClassMethod getAlignment() As %String
{
	
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","left").Put("text","left"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","center").Put("text","center"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","right").Put("text","right"))
  w jsonObj.ListToJson(listObj)
  q ""
}

// w ##class(web.DHCEMColumn).getHidden()

ClassMethod getHidden() As %String
{
	
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","Y"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","N"))
  w jsonObj.ListToJson(listObj)
  q ""
}

/// w ##class(web.DHCEMColumn).writeTopBtn()
ClassMethod writeTopBtn() As %String
{
	
	s grp=%session.Data("LOGON.GROUPID")
	s userid=%session.Data("LOGON.USERID")
	s btnNum=0
	s flag = ##class(web.DHCEMOrdInfoVO).checkStayFlag(grp,userid)  //1:留观  0:急诊
	s EpisodeID=%request.Get("EpisodeID")
	i +EpisodeID'=0 d
	.s patVisit=$p($g(^PAADM(EpisodeID)),"^",20)
	.q:patVisit="A"
	.q:flag'=1
	.s btnNum=1
	.w "<a href='#' class='hisui-linkbutton' onclick='opPatStatus(""cancel"");'>撤销结算</a>"
	
	q:(+EpisodeID'=0)&&(($p($g(^PAADM(+EpisodeID)),"^",20))'="A") ""   //qqa 离院的Adm只显示撤销结算
	
	s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
	s showOpBtnNum=4 //显示按钮数
	//先按用户取
	i $d(^DHCEMPSA(0,"TYPE","U",userid))=10 d
	.q:flag'=1	
	.s psa=""  f  s psa=$o(^DHCEMPSA(0,"TYPE","U",userid,psa)) q:psa=""  d
	..q:'$D(^DHCEMPSA(psa))
	..s parf=$p(^DHCEMPSA(psa),"^",1)
	..q:+parf=0
	..s code=$p(^DHCPACVisitStatus(parf),"^",1)
	..s desc=$p(^DHCPACVisitStatus(parf),"^",2)
	..s ^TMP("web.DHCEMColumn",pid,code)=desc
	e  d
	.q:flag'=1
	.i $d(^DHCEMPSA(0,"TYPE","G",grp))=10 d
	..s psa=""  f  s psa=$o(^DHCEMPSA(0,"TYPE","G",grp,psa)) q:psa=""  d
	...s parf=$p(^DHCEMPSA(psa),"^",1)
	...q:+parf=0
	...s code=$p(^DHCPACVisitStatus(parf),"^",1)
	...s desc=$p(^DHCPACVisitStatus(parf),"^",2)
	...s ^TMP("web.DHCEMColumn",pid,code)=desc
	
	s tmp=""
	f  s tmp=$o(^TMP("web.DHCEMColumn",pid,tmp)) q:tmp=""  d
	.s desc=^TMP("web.DHCEMColumn",pid,tmp)
	.s btnNum=btnNum+1
	.w:btnNum<showOpBtnNum "<a href='#' class='hisui-linkbutton' onclick='opPatStatus("""_tmp_""");'>"_desc_"</a>"
	.w:btnNum=showOpBtnNum "<a href='javascript:void(0)'  class='hisui-menubutton menubutton-blue' style='width:100px;' data-options=""menu:'#mm-other'"">其他</a>"
	.w:btnNum=showOpBtnNum "<div id='mm-other' style='width:100px;'>"	
	.w:btnNum>=showOpBtnNum "<div onclick='opPatStatus("""_tmp_""");'>"_desc_"</div>" 
	w:btnNum>=showOpBtnNum "</div>"    //qqa 为四个时有问题
	i flag=1 d
	.w "<a href='javascript:void(0)'  class='hisui-menubutton menubutton-blue' style='width:150px;' data-options=""menu:'#mm-referral'"">转诊</a>"
	.w "<div id='mm-referral' style='width:150px;'>"
	.s loc=%session.Data("LOGON.CTLOCID")	//67	
	.s link=0
	.f  s link=$o(^CTLOC(loc,"LINK",0,"Loc",link)) q:link=""  d
	..s WardRowID=""
	..f  s WardRowID=$O(^PAWARD(0,"WARD_LocationDR",link,WardRowID)) q:WardRowID=""  d
	...s WardName= $p(^PAWARD(WardRowID),"^",2)
	...s EmSeatNum = ##class(web.DHCEMPat).GetEmPatSeat(WardRowID)
	...s HaspatEmSeatNum = ##class(web.DHCEMPat).GetHasEmPatSeat(WardRowID)
	...s WardName = WardName_"("_(EmSeatNum-HaspatEmSeatNum)_")"
	...w "<div onclick='changeWard(this)' data-id="_WardRowID_" >"_WardName_"</div>" 
	.w "</div>"
   	
   	k ^TMP("web.DHCEMColumn",pid)
}

/// w ##class(web.DHCEMColumn).writeTopBtnNew("22^4636^124^286")
ClassMethod writeTopBtnNew(Params) As %String
{
	n (Params)	
	s grp = $p(Params,"^",1)
	s userid = $p(Params,"^",2)
	s EpisodeID=$p(Params,"^",3)
	s LocID = $p(Params,"^",4)
	s btnNum=0
	s flag = ##class(web.DHCEMOrdInfoVO).checkStayFlag(grp,userid)  //1:留观  0:急诊
	
	i +EpisodeID'=0 d
	.s patVisit=$p($g(^PAADM(EpisodeID)),"^",20)
	.q:patVisit="A"
	.q:flag'=1
	.s btnNum=1
	.w "<a href='#' class='hisui-linkbutton' onclick='opPatStatus(""cancel"");'>撤销结算</a>"
	
	q:(+EpisodeID'=0)&&(($p($g(^PAADM(+EpisodeID)),"^",20))'="A") ""   //qqa 离院的Adm只显示撤销结算
	
	s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
	s showOpBtnNum=4 //显示按钮数

	i flag=1 d
	.w "<a href='#' class='hisui-linkbutton' onclick='emPatChange();'>状态改变</a>"
	.w "<a href='#' class='hisui-linkbutton' onclick='emPatChangeLoc();'>转移</a>"
   	
   	k ^TMP("web.DHCEMColumn",pid)
   	q ""
}

/// Creator:    bianshuai
/// CreateDate: 2019-03-21
/// Descript:   指定护士执行列宽
/// InPut:      列名
/// OutPut:     列宽
/// w ##Class(web.DHCEMColumn).getColumnWidth("298")
ClassMethod getColumnWidth(Field As %String) As %String
{
	n (Field)
	s TMPColWidthArr("regNo")=120        /// 登记号
	s TMPColWidthArr("execDateTime")=130 /// 执行时间
	s TMPColWidthArr("sttDateTime")=130  /// 医嘱生效时间
	s TMPColWidthArr("reclocDesc")=130   /// 接收科室
	s TMPColWidthArr("seqNo")=140        /// 序号
	s TMPColWidthArr("prescNo")=120      /// 处方号
	s TMPColWidthArr("groupNo")=45       /// 组号
	s TMPColWidthArr("GroupImg")=45      /// 组符
	
	s Width=$g(TMPColWidthArr(Field))
	i Width="" s Width=90
	Q Width
}

}
