var PageLogicObj={
	m_UnSaveOrderTabDataGrid:"",
	m_OrdListTabDataGrid:""
};
$(function(){
	///页面元素初始化
	//PageHandle();
	//页面数据初始化
	Init();
	//事件初始化
	InitEvent();
});
function Init(){
	PageLogicObj.m_UnSaveOrderTabDataGrid=UnSaveOrderTabDataGrid();
	UnSaveOrderTabDataGridLoad();
}
function InitEvent(){
	$HUI.tabs("#tt2",{
		onSelect:function(title,index){
			if (title=="需处理医嘱"){ //需处理医嘱
				LinkUrl = "doc.ordverify.hui.csp?EpisodeID="+ ServerObj.EpisodeID+"&FromTabFlag=Y" ;
				if(typeof websys_writeMWToken=='function') LinkUrl=websys_writeMWToken(LinkUrl);
				$("#TabMain").attr("src", LinkUrl);
			}else if (title=="待审核检验检查申请"){ //待确认检验检查申请
				LinkUrl="dhcapp.mainframe.csp?PatientID=" + ServerObj.PatientID + "&EpisodeID=" + ServerObj.EpisodeID + "&mradm=" + ServerObj.mradm +"&PracticeFlag=1"+"&PPRowId="+ServerObj.PPRowId;
				if(typeof websys_writeMWToken=='function') LinkUrl=websys_writeMWToken(LinkUrl);
				$("#TabMain1").attr("src", LinkUrl);
			}else if (title=="待审核治疗申请"){
				var LinkUrl = "doccure.applytree.hui.csp?EpisodeID=" + ServerObj.EpisodeID+"&PracticeCureCount="+ServerObj.PracticeCureNum+"&ParaType="+"&PPRowId="+ServerObj.PPRowId
				if(typeof websys_writeMWToken=='function') LinkUrl=websys_writeMWToken(LinkUrl);
				$("#TabMain2").attr("src", LinkUrl);
			}				
		}
	});
	if (ServerObj.GetPracticeOrdNum>0){
		if(ServerObj.PageType=="CureAdvise"){
			$("#tt2").find('.tabs-header:first').find('.tabs-title').eq(0).text($g("建议医嘱")+"("+ServerObj.GetPracticeOrdNum+")")
		}else{
			$("#tt2").find('.tabs-header:first').find('.tabs-title').eq(0).text($g("未审核医嘱")+"("+ServerObj.GetPracticeOrdNum+")")
		}
	}else{
		if(ServerObj.PAAdmType!="I")CloseTabByTitle("未审核医嘱");
	}
	if (ServerObj.VerifyStyleNum>0){
		$("#tt2").find('.tabs-header:first').find('.tabs-title').eq(1).text($g("需处理医嘱")+"("+ServerObj.VerifyStyleNum+")")
		//$(#NeedtoHandleOrder).attr(title, 需处理医嘱+(+ServerObj.VerifyStyleNum+));
	}else{
		if(ServerObj.PAAdmType!="I")CloseTabByTitle("需处理医嘱");
	}
	if (ServerObj.PracticeLabNum>0) {
		$("#tt2").find('.tabs-header:first').find('.tabs-title').eq(2).text($g("待审核检验检查申请")+"("+ServerObj.PracticeLabNum+")")
	}else{
		CloseTabByTitle("待审核检验检查申请");
	}
	if (ServerObj.PracticeCureNum>0) {
		var newTitle=$g("待审核治疗申请")+"("+ServerObj.PracticeCureNum+")";
		if (ServerObj.PracticeLabNum>0) {
			$("#tt2").find('.tabs-header:first').find('.tabs-title').eq(3).text(newTitle);
		}else{
			$("#tt2").find('.tabs-header:first').find('.tabs-title').eq(2).text(newTitle);
		}
	}else{
		CloseTabByTitle("待审核治疗申请");
	}
	$HUI.radio("[name='PracticeType']",{
        onChecked:function(e,value){
            UnSaveOrderTabDataGridLoad();
        }
    });
}
function UnSaveOrderTabDataGrid(){
	var toobar=new Array();
    if (ServerObj.PracticeFlag!=1 && ServerObj.PageType!="CureAdvise"){
		toobar.push({
			text:'确认',
			iconCls :'icon-save-sure',
			handler :function() {AddClickHandle();}
		});
	}
	toobar.push({
		text:'删除',
		iconCls :'icon-cancel',
		handler: function() {DelClickHandle();}
	});
	var Columns=[[ 
		{field:'CheckPre',title:'选择',checkbox:'true'},
		{field:'Rowid',hidden:true,title:'Rowid'},
		{field:'OrdSeqNo',title:'序号',width:50},
		{field:'OrderPrior',title:'医嘱类型',width:80},
		{field:'OrderInsertType',title:'类型',width:100,hidden:((ServerObj.PageType.indexOf("Cure")<0))?true:false},
		{field:'OrderName',title:'医嘱名称',width:280},
		{field:'OrderDoseQty',title:'单次剂量',width:80},
		{field:'OrderDoseUOM',title:'剂量单位',width:80},
		{field:'OrderInstr',title:'用法',width:100},
		{field:'OrderFreq',title:'频次',width:100},
		{field:'OrderDur',title:'疗程',width:100},
		{field:'OrderRecLoc',title:'接收科室',width:150},
		{field:'OrderPackQty',title:'数量',width:80},
		{field:'OrderPackUOM',title:'数量单位',width:80},
		{field:'OrderUserAdd',title:'开医嘱人',width:100},
		{field:'OrderStartDate',title:'开始日期时间',width:180},
		{field:'JsonStr',hidden:true,title:'JsonStr'}
    ]]
    var SingeFLag=false
    if (ServerObj.PageType=="C"){SingeFLag=true}
	var UnSaveOrderTabData=$("#UnSaveOrderTab").datagrid({
		fit :true,
		border :false,
		striped  :false,
		singleSelect :SingeFLag,
		fitColumns :false,
		autoRowHeight :false,
		rownumbers: false,
		pagination :true,  
		pageSize:20,
		pageList : [20,50,100],
		idField:'Rowid',
		columns:Columns,
		toolbar:toobar,
		selectOnCheck:true,
		checkOnSelect:true,
		onCheck:function(index, row){
			var SeqNo=row['OrdSeqNo'];
			if (SeqNo!=""){
		    	var arry1=SeqNo.split(".");
		    	if ((arry1.length>=1)&&(+arry1[0]!=0)) {
			    	var MasterSeqNo=arry1[0];
			    	ChangelLinkItemSelect(MasterSeqNo,true);
			    }
		    }
		},
		onUnselect:function(index, row){
			var SeqNo=row['OrdSeqNo'];
			if (SeqNo!=""){
		    	var arry1=SeqNo.split(".");
		    	if ((arry1.length>=1)&&(+arry1[0]!=0)) {
			    	var MasterSeqNo=arry1[0];
			    	ChangelLinkItemSelect(MasterSeqNo,false);
			    }
		    }
		},
		onLoadSuccess:function(data){
			PageLogicObj.m_UnSaveOrderTabDataGrid.datagrid("uncheckAll");
		}
	}); 
	return UnSaveOrderTabData;
}
function UnSaveOrderTabDataGridLoad(){
	var type=$("input[name='PracticeType']:checked").val();
	$.q({
	    ClassName :"web.DHCPracticeDocPreOrder",
	    QueryName:"FindPracticeOrder",
	    Adm:ServerObj.EpisodeID,
	    Type:type,
	    PageType:ServerObj.PageType,
	    AssScoreID:ServerObj.CureAssScoreID,
	    Pagerows:PageLogicObj.m_UnSaveOrderTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_UnSaveOrderTabDataGrid.datagrid("uncheckAll");
		PageLogicObj.m_UnSaveOrderTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function AddClickHandle(){
	var type=$("input[name='PracticeType']:checked").val();
	if (type=="A"){
		$.messager.alert("提示","已确认的医嘱不能进行操作");
		return false;
	}
	var SelOrdRowArr=PageLogicObj.m_UnSaveOrderTabDataGrid.datagrid('getChecked');
	var RowidStr=""
	 for (var i=0;i<SelOrdRowArr.length;i++){
		if (RowidStr==""){RowidStr=SelOrdRowArr[i].Rowid}else{RowidStr=RowidStr+"^"+SelOrdRowArr[i].Rowid}
	}
	if (RowidStr==""){
		$.messager.alert("提示","请至少选择一条医嘱进行审核");
		return false;
	}
	RowidStr=RowidStr.split("^").sort(function(num1,num2){
       return parseFloat(num1)-parseFloat(num2);
   }).join("^");
	//var rtn = $m({ClassName:"web.DHCPracticeDocPreOrder",MethodName:"ChangeMuiPreOrdType",RowidStr:RowidStr,Type:"I",UserID:session['LOGON.USERID']},false);
	if (ServerObj.PageType=="C"){
		var RowidStrAry=RowidStr.split("^")
		var JsonStr = $m({ClassName:"web.DHCPracticeDocPreOrder",MethodName:"GetOnePracticeOrder",Rowid:RowidStrAry[0]},false);
		var PracticePreary=JsonStr;
	}else if(ServerObj.PageType=="Cure"){
		var PracticePreary=new Array();
		var RowidStrAry=RowidStr.split("^")
		for (var i=0;i<RowidStrAry.length;i++){
			var Rowid=RowidStrAry[i]
			var JsonStr = $m({ClassName:"web.DHCPracticeDocPreOrder",MethodName:"GetOnePracticeOrder",Rowid:Rowid},false);
			var ArrStr = JSON.parse(JsonStr);
			PracticePreary[i]=ArrStr
		}
	}else{
		var CruRow = websys_showModal('options').GetPreRowId();
	    if (websys_showModal('options').CheckIsClear(CruRow) == true) {
	        CruRow=parseInt(CruRow)-1;
	    }
	    var LastMasterSeNo="",LastOrderMasterARCIMRowid="";
		/*
		ArrStr.id
		ArrStr.OrderMasterSeqNo
		*/
		var OrderDocStr = tkMakeServerCall("web.DHCOEOrdItemView", "GetOPSurgeonDocStr", "","",session['LOGON.USERID']);
		if (OrderDocStr!="") {
			var DefOrderDoc="",DefOrderDocRowid="";
			if (OrderDocStr!="") {
				for (var i=0;i<OrderDocStr.split("^").length;i++){
					var OneOrderDoc=OrderDocStr.split("^")[i];
					var Default=OneOrderDoc.split(String.fromCharCode(1))[2];
					if (Default="Y") {
						DefOrderDoc=OneOrderDoc.split(String.fromCharCode(1))[0];
						DefOrderDocRowid=OneOrderDoc.split(String.fromCharCode(1))[1];
						break;
					}
				}
				if (DefOrderDoc=="") {
					var OneOrderDoc=OrderDocStr.split("^")[0];
					DefOrderDoc=OneOrderDoc.split(String.fromCharCode(1))[0];
					DefOrderDocRowid=OneOrderDoc.split(String.fromCharCode(1))[1];
				}
			}
		}
		var PracticePreary=new Array();
		var RowidStrAry=RowidStr.split("^")
		for (var i=0;i<RowidStrAry.length;i++){
			var Rowid=RowidStrAry[i]
			var JsonStr = $m({ClassName:"web.DHCPracticeDocPreOrder",MethodName:"GetOnePracticeOrder",Rowid:Rowid},false);
			var ArrStr = JSON.parse(JsonStr);
			CruRow=parseInt(CruRow)+1;
			ArrStr.id=CruRow;
			if (ArrStr.OrderMasterSeqNo=="") {
				LastMasterSeNo=CruRow;
				LastOrderMasterARCIMRowid=ArrStr.OrderARCIMRowid;
				ArrStr.OrderMasterARCIMRowid="";
			}else{
				ArrStr.OrderMasterSeqNo=LastMasterSeNo;
				ArrStr.OrderMasterARCIMRowid=ArrStr.OrderARCIMRowid;
			}
			if (OrderDocStr!="") {
				ArrStr.OrderDocStr=OrderDocStr;
				ArrStr.OrderDoc=DefOrderDoc;
				ArrStr.OrderDocRowid=DefOrderDocRowid;
			}
			PracticePreary[i]=ArrStr
		}
	}
	websys_showModal("hide");
    websys_showModal('options').AddPracticeOrder(PracticePreary,RowidStr);
    websys_showModal("close");
}
function DelClickHandle(){
	var type=$("input[name='PracticeType']:checked").val();
	if (type=="A"){
		$.messager.alert("提示","已确认的医嘱不能进行操作");
		return false;
	}
	var SelOrdRowArr=PageLogicObj.m_UnSaveOrderTabDataGrid.datagrid('getChecked');
	var RowidStr=""
	for (var i=0;i<SelOrdRowArr.length;i++){
		if (RowidStr==""){RowidStr=SelOrdRowArr[i].Rowid}else{RowidStr=RowidStr+"^"+SelOrdRowArr[i].Rowid}
	}
	if (RowidStr==""){
		$.messager.alert("提示","请至少选择一条医嘱进行取消");
		return false;
	}
	var rtn = $m({ClassName:"web.DHCPracticeDocPreOrder",MethodName:"ChangeMuiPreOrdType",RowidStr:RowidStr,Type:"X",UserID:session['LOGON.USERID']},false);
	if (rtn==0){
		$.messager.alert("提示","取消成功!");
		UnSaveOrderTabDataGridLoad();
		UpdateTabsTilte();
		return true;
	}else{
		$.messager.alert("提示","取消失败!"+rtn);
		return false;
	}

}
function ChangelLinkItemSelect(MasterSeqNo,checkflag,OrderMustEnter){
    try{
		var data=PageLogicObj.m_UnSaveOrderTabDataGrid.datagrid('getData');
		for (var k=0; k<data.rows.length; k++) {
			var SeqNo=data['rows'][k]['OrdSeqNo'];
			if (+SeqNo==0) continue;
			var arry=SeqNo.split(".");
			if (arry[0]==MasterSeqNo) {
				if (checkflag){
					if (!$($("input[name='CheckPre']")[k]).is(":checked")){
						PageLogicObj.m_UnSaveOrderTabDataGrid.datagrid('selectRow',k);
					}
				}else{
					if ($($("input[name='CheckPre']")[k]).is(":checked")){
						PageLogicObj.m_UnSaveOrderTabDataGrid.datagrid('unselectRow',k);
					}
				}
			}
		}
    }catch(e){alert(e.message)}
}
function UpdateTabsTilte() {
	var tab = $('#tt2').tabs('getSelected');
	var index = $('#tt2').tabs('getTabIndex',tab);
	var title=tab.panel("options").title;
	if (index==0){
		ServerObj.GetPracticeOrdNum=$.m({
			ClassName:"web.DHCPracticeDocPreOrder",
			MethodName:"GetPracticeOrdNum",
			Adm:ServerObj.EpisodeID,
			Type:"N",
			PageType:ServerObj.PageType,
			AssScoreID:ServerObj.CureAssScoreID
		},false);
		var title=$g("未审核医嘱");
		if (ServerObj.GetPracticeOrdNum>0) {
			title=title+"("+ServerObj.GetPracticeOrdNum+")";
		}
		$("#tt2").find('.tabs-header:first').find('.tabs-title').eq(0).text(title);
	}else if (index==1){
		ServerObj.VerifyStyleNum=$.m({
			ClassName:"web.DHCPracticeDocPreOrder",
			MethodName:"GetVerifyStyleNum",
			EpisodeID:ServerObj.EpisodeID
		},false);
		var title=$g("需处理医嘱");
		if (ServerObj.VerifyStyleNum>0) {
			title=title+"("+ServerObj.VerifyStyleNum+")";
		}
		$("#tt2").find('.tabs-header:first').find('.tabs-title').eq(1).text(title);
	}else if (title=="待审核检验检查申请"){
		ServerObj.PracticeLabNum=$.m({
			ClassName:"web.DHCAPPExaReportQuery",
			MethodName:"QueryExaReqHisListCount",
			rows:30,
			page:1,
			params:ServerObj.EpisodeID+"^^I^"+session['LOGON.HOSPID']
		},false);
		//var title="待审核检验检查申请";
		if (ServerObj.PracticeLabNum>0) {
			title=$g(title)+"("+ServerObj.PracticeLabNum+")";
			$("#tt2").find('.tabs-header:first').find('.tabs-title').eq(index).text(title);
		}else{
			$('#tt2').tabs('close',index);
		}
	}else if (title=="待审核治疗申请"){
		ServerObj.PracticeCureNum=$.m({
			ClassName:"web.DHCPracticeDocPreOrder",
			MethodName:"GetPracticeOrdNum",
			Adm:ServerObj.EpisodeID,
			Type:"N",
			PageType:"Cure^CureAdvise",
			AssScoreID:ServerObj.CureAssScoreID
		},false);
		//var title="待审核治疗申请";
		if (ServerObj.PracticeCureNum>0) {
			title=$g(title)+"("+ServerObj.PracticeCureNum+")";
			$("#tt2").find('.tabs-header:first').find('.tabs-title').eq(index).text(title);
		}else{
			$('#tt2').tabs('close',index);
		}
	}
}
function CloseTabByTitle(title){
	var tab = $('#tt2').tabs('getTab',title.split("(")[0]);
	var index = $('#tt2').tabs('getTabIndex',tab);
	$('#tt2').tabs('close',index);
}