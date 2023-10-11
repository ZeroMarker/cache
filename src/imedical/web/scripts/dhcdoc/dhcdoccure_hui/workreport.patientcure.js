var PageCurePatObj={
	m_PatientCureTabDataGrid:"",
	m_CureDetailDataGrid:"",
	m_SelectArcimID:"",
	PatCondition:[{id:"PatNo",desc:$g("登记号")},{id:"PatMedNo",desc:$g("住院号")},{id:"PatName",desc:$g("患者姓名")}]
}

$(document).ready(function(){
	var HospIdTdWidth=$("#HospIdTd").width()
	var opt={width:HospIdTdWidth}
	var hospComp = GenUserHospComp(opt);
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		InitArcimDesc();
		InitOrderLoc();
		PatientCureTabDataGridLoad();	
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//PatientCureTabDataGridLoad();
		Init();
	}	
	InitEvent();
});

function Init(){
	InitDate();
	InitOrderLoc();	
	InitOrderDoc();
	InitArcimDesc();
	InitPatCondition();
	InitOthChkCondition();
  	PageCurePatObj.m_PatientCureTabDataGrid=InitPatientCureTabDataGrid();	
}

function InitEvent(){
	$('#btnFind').click(PatientCureTabDataGridLoad);
    $('#btnClear').click(ClearHandle);
	$('#ApplyNo').bind('keydown', function(event){
		if(event.keyCode==13){
			PatientCureTabDataGridLoad();
		}
	});
	$('#PatConditionVal').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			var PatCondition=$("#PatCondition").combobox("getValue");
			if(PatCondition=="PatNo"){
				PatNoHandle(PatientCureTabDataGridLoad,this.id);	
				if ($(this).val()==""){
					$("#PatientID").val("");
				}
			}else{
				PatientCureTabDataGridLoad();
			}
		}
	});
	$('#PatConditionVal').bind('change', function(){
		var PatCondition=$("#PatCondition").combobox("getValue");
		if(PatCondition=="PatNo"){
			if ($(this).val()==""){
				$("#PatientID").val("");
			}
		}
    });
	$HUI.radio("[name='SortType']",{
        onChecked:function(e,value){
            setTimeout("PatientCureTabDataGridLoad();",10)
        }
    });
    $HUI.checkbox("#showByPat",{
		onCheckChange:function(e,value){
			setTimeout("PatientCureTabDataGridLoad();",10)
		}
	})
    //InitPatNoEvent(PatientCureTabDataGridLoad);
	InitCardNoEvent(PatientCureTabDataGridLoad);
}

function InitPatientCureTabDataGrid()
{
	var PatientCureToolBar = [{
		id:'BtnDetailView',
			text:'申请单浏览', 
			iconCls:'icon-eye',  
			handler:function(){
				OpenApplyDetailDiag();
			}
		},"-",{
			id:'BtnAssessment',
			text:'治疗评估', 
			iconCls:'icon-paper-table',  
			handler:function(){
				UpdateAssessment();
			}
		}
	];
	var PatientCureColumn=[[ 
		{field:'ApplyNo',title:'申请单号',width:120,align:'left'},  
		{field:'ArcimDesc',title:'治疗项目',width:180,align:'left',
			formatter: function (value, rowData, rowIndex) {
				var retStr=value;
				if(value!=""){
					retStr = "<a href='#' title='"+$g("医嘱及绑定信息")+"'  onclick='com_openwin.applyAppenditemShow(\""+rowData.OrderId+"\")'>"+value+"</a>"
				}
				return retStr;
			}
		},
		{field:'OrdOtherInfo',title:'医嘱其他信息',width:160,align:'left',
			formatter: function (value, rowData, rowIndex) {
				if(value==""){
					if(rowData.ArcimDesc==""){
						return "";	
					}else{
						value = $g("医嘱明细信息");
					}
				}
				return "<a href='javascript:void(0)' title='"+$g("医嘱明细信息")+"'  onclick='com_openwin.ordDetailInfoShow(\""+rowData.OrderId+"\")'>"+value+"</a>";
			}
		}, 
		{field:'OrdAddLoc',title:'开单科室',width:120,align:'left'},  
		{field:'OrdUnitPrice',title:'单价',width:80,align:'left'}, 
		{field:'OrdQty',title:'数量',width:50,align:'left'}, 
		{field:'OrdBillUOM',title:'单位',width:80,align:'left'}, 
		{field:'OrdPrice',title:'总金额',width:80,align:'left'}, 
		{field:'ApplyExec', title:'是否可预约', width: 120, align: 'left',
			formatter:function(value,row,index){
				if (row.ApplyExecFlag=="Y"){
					return "<span class='fillspan-exec'>"+value+"</span>";
				}else if (row.ApplyExecFlag==""){
					return value;
				}else {
					return "<span class='fillspan-app'>"+value+"</span>";
				}
			}
		},
		{field:'ApplyExecFlag', title:'是否可预约', width: 80, align: 'left',hidden: true},
		{field:'ApplyStatus',title:'申请状态',width:80,align:'left'},
		{field:'ApplyAppedTimes',title:'已预约数量',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'ApplyNoAppTimes',title:'未预约数量',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'ApplyFinishTimes',title:'已治疗数量',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false,
			formatter:function(value,row,index){
				if(value==""){
					return "";	
				}else{
					return '<a href="###" id= "'+row["TIndex"]+'"'+' onmouseover=ShowCureEexcDetail(this);'+' onclick=ShowCureDetail('+row.TIndex+','+row.DCARowId+');>'+"<span class='fillspan-nosave'>"+value+"</span>"+"</a>"
				}
			},
			styler:function(value,row){
				return "color:blue;text-decoration: underline;"
			}
		},
		{field:'ApplyNoFinishTimes',title:'未治疗数量',width:80,align:'left',hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'OrdBilled',title:'是否缴费',width:70,align:'left',
			formatter:function(value,row,index){
				if (value == $g("否")){
					return "<span class='fillspan-nobilled'>"+value+"</span>";
				}else{
					return "<span class='fillspan'>"+value+"</span>";
				}
			}
		},
		{field:'OrdReLoc',title:'接收科室',width:150,align:'left'},   
		{field:'ServiceGroup',title:'服务组',width:100,align:'left'}, 
		{field:'ApplyUser',title:'申请医生',width:80,align:'left'},
		{field:'ApplyDateTime',title:'申请时间',width:100,align:'left'},
		{field:'ApplyStatusCode',title:'ApplyStatusCode',width:80,hidden: true},
		{field:'CureCfgLimit',title:'CureCfgLimit',width:80,hidden: true}
	 ]]

	var PatientCureTabDataGrid=$('#PatientCureTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		url : $URL+'?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=FindAllCureApplyListHUI&rows=99999',
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"DCARowId",
		pageSize : 50,
		pageList : [20,50,100],
		frozenColumns : [
			[
				{field:'PatNo',title:'登记号',width:100,align:'left'},   
				{field:'PatName',title:'姓名',width:80,align:'left'},   
				{field:'PatOther',title:'患者其他信息',width:200,align:'left'},
				{field:'DCARowId',title:'DCARowId',width:30,hidden:true},	
				{field:'DCAAdmID',title:'DCAAdmID',width:50,hidden:true},
				{field:'PatientID',title:'PatientID',width:50,hidden:true}
			]
		],
		columns : PatientCureColumn,
		toolbar : PatientCureToolBar,
		onSelect:function(index, row){
			var frm=dhcsys_getmenuform();
			if (frm){
				var DCARowId=row.DCARowId;
				var EpisodeID=row.DCAAdmID;
				var PatientID=row.PatientID;
				if(EpisodeID!=""){
					frm.PatientID.value=PatientID;
					frm.EpisodeID.value=EpisodeID;
				}
			}
		},
		onBeforeSelect:function(index, row){
			var oldSelRow=$(this).datagrid('getSelected');
			var oldSelIndex=$(this).datagrid('getRowIndex',oldSelRow);
			if (oldSelIndex==index){
				$(this).datagrid('unselectRow',index);
				var frm=dhcsys_getmenuform();
				if (frm){
					frm.PPRowId.value="";
					frm.EpisodeID.value="";
				}
				return false;
			}
		},
		onBeforeLoad:function(param){
			var StartDate=$("#StartDate").datebox("getValue");
			var EndDate=$("#EndDate").datebox("getValue");
			var PatientID=$("#PatientID").val();
			var ApplyNo=$("#ApplyNo").val();
			var queryOrderLoc=$HUI.combobox("#ComboOrderLoc").getValue();
			queryOrderLoc=CheckComboxSelData("ComboOrderLoc",queryOrderLoc);
			var queryOrderDoc=$HUI.combobox("#ComboOrderDoc").getValue();
			queryOrderDoc=CheckComboxSelData("ComboOrderDoc",queryOrderDoc);
			var gtext=$HUI.lookup("#ComboArcim").getText();
			if (gtext=="")PageSizeItemObj.m_SelectArcimID="";
			var queryArcim=PageSizeItemObj.m_SelectArcimID;
			var PatName="",PatMedNo=""; 
			var PatCondition=$("#PatCondition").combobox("getValue");
			var PatConditionVal=$("#PatConditionVal").val();
			if(PatCondition=="PatName"){
				PatName=PatConditionVal;
			}else if(PatCondition=="PatMedNo"){
				PatMedNo=PatConditionVal;
			}
			var SortType="A"; //默认时间正序
			var chkRadioJObj = $("input[name='SortType']:checked");
			if(chkRadioJObj.length>0){SortType=chkRadioJObj.val();}
			var CheckAdmType="",ChkCurrLocFlag="";
			if($("#ComboOtherChk").length>0){
				var OtherChkAry=$("#ComboOtherChk").combobox("getValues");
				if($.hisui.indexOfArray(OtherChkAry,"OPCheck")>-1){CheckAdmType="O"}
				if($.hisui.indexOfArray(OtherChkAry,"IPCheck")>-1){CheckAdmType="I"}
				if($.hisui.indexOfArray(OtherChkAry,"ChkCurrLoc")>-1){ChkCurrLocFlag="Y"}
				if($.hisui.indexOfArray(OtherChkAry,"OPCheck")>-1 && $.hisui.indexOfArray(OtherChkAry,"IPCheck")>-1){CheckAdmType=""}
			}
			var showByPatFlag=$HUI.checkbox("#showByPat").getValue()?"Y":"N";
			var QueryExpStr=Util_GetSelUserHospID()+"^"+ChkCurrLocFlag+"^"+queryOrderDoc+"^"+PatMedNo+"^"+SortType+"^"+"doccure.workreport.patientcure.hui.csp";
				QueryExpStr=QueryExpStr+"^^^^"+showByPatFlag
			$.extend(param,{PatientID:PatientID,StartDate:StartDate,EndDate:EndDate,PatName:PatName,
			TriageFlag:"ALL",LogLocID:session['LOGON.CTLOCID'],LogUserID:session['LOGON.USERID'],
			ApplyNo:ApplyNo,CheckAdmType:CheckAdmType,queryArcim:queryArcim,queryOrderLoc:queryOrderLoc,queryExpStr:QueryExpStr});
		},
		onLoadSuccess:function(data){
			if($HUI.checkbox("#showByPat").getValue()){
				PageCurePatObj.m_PatientCureTabDataGrid.datagrid("autoMergeCells",['PatNo','PatName','PatOther']);    //合并相同列
				PageCurePatObj.m_PatientCureTabDataGrid.datagrid("getPanel").find(".datagrid-view1 tr.datagrid-row[datagrid-row-index]").css({"color": "inherit", "background-color": "inherit"}); //让冻结列前景色和背景色从父元素继承
			}
			$(this).datagrid("clearSelections");
		}
	});
	return PatientCureTabDataGrid
}
function PatientCureTabDataGridLoad()
{
	PageCurePatObj.m_PatientCureTabDataGrid.datagrid("reload");
}

function ClearHandle(){
	//InitCardType();
	$('.search-table input[class*="cure-box"]').val("");
	$('input[type=checkbox]').checkbox('uncheck');
	$("#ComboOrderLoc,#ComboOrderDoc,#PatCondition").combobox("setValue","");
	PageSizeItemObj.m_SelectArcimID=""; 
	$("#ComboArcim").lookup('setText','');
	$("#ComboOtherChk").combobox('setValues','');
	$HUI.radio('.search-table input[value="A"]').setValue(true);
	InitDate();	
}

function ShowCureDetail(inde,id){
	var dhwid=window.screen.availWidth-60;
	var dhhei=window.screen.availHeight-100;
	$('#add-dialog').window('open').window('resize',{
		width:dhwid,
		height:dhhei,
		top: ($(window).height() - dhhei) * 0.5,
		left:($(window).width() - dhwid) * 0.5
	});
	var CureDetailDataGrid=$('#tabCureDetail').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		checkOnSelect:false,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:false,    
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.ExecApply&QueryName=FindCureExecList&DCARowId="+id+"&OnlyExcute=Y&rows=9999",
		loadMsg : '加载中..',  
		pagination : true, 
		rownumbers : true,
		idField:"OEORERowID",
		pageSize : 20,
		pageList : [20,50,100],
		columns :[[ 
			{field:'DCARowId',title:'',width:1,hidden:true}, 
			{field:'PapmiNo',title:'登记号',width:100},   
			{field:'PatientName',title:'姓名',width:100},
			{field:'ArcimDesc',title:'治疗项目',width:220,align:'left'},  
			//{field:'OEOREExStDate',title:'要求执行时间',width:130,align:'left'},
			{field:'DCRContent',title:'治疗记录',width:220,align:'left'} ,
			{field:'OEOREQty',title:'执行数量',width:80,align:'left'} ,
			{field:'OEOREStatus',title:'执行状态',width:80,align:'left'},
			{field:'OEOREUpUser',title:'执行人',width:60,align:'left'},
			{field:'DCRIsPicture',title:'是否有图片',width:80,
    			formatter:function(value,row,index){
	    			if(value=="Y"){
						return '<a href="###" id= "'+row["OEORERowID"]+'"'+' onmouseover=workList_RecordListObj.ShowCurePopover(this);'+' onclick=ShowCureRecordPic(\''+row.DCRRowId+'\');>'+$g("查看图片")+"</a>"
	    			}else{
		    			return "";	
		    		}
				},
				styler:function(value,row){
					return "color:blue;text-decoration: underline;"
			}},
			{field:'DCRCureDate',title:'治疗时间',width:160,align:'left'} ,
			{field:'DCRResponse',title:'治疗反应',width:220,align:'left'} ,
			{field:'DCREffect',title:'治疗效果',width:220,align:'left'} ,
			{field:'OEOREExDate',title:'操作时间',width:160,align:'left'} ,
			{field:'OEORETransType',title:'医嘱类型',width:100,align:'left'} ,
			{field:'DCRRowId',title:'DCRRowId',width:100,align:'left',hidden:true} ,
			{field:'OEORERowID',ExecID:'ID',width:50,align:'left',hidden:true}  
	 	]],
	 	onLoadSuccess: function(){
		    PageCurePatObj.m_CureDetailDataGrid.datagrid("clearSelections");
        }
	});
	PageCurePatObj.m_CureDetailDataGrid=CureDetailDataGrid;
	return CureDetailDataGrid;
}

function CureDetailDataGridLoad(){
	PageCurePatObj.m_CureDetailDataGrid.datagrid("reload");
}

function ShowCureRecordPic(DCRRowId){
	workList_RecordListObj.ShowCureRecordPic(DCRRowId,CureDetailDataGridLoad);	
}
	
function ShowCureEexcDetail(that){
	var title=""
	var content="点击浏览明细信息"
	$(that).webuiPopover({
		title:title,
		content:content,
		trigger:'hover',
		placement:'top',
		style:'inverse'
	});
	$(that).webuiPopover('show');
}
function OpenApplyDetailDiag()
{
	var row = PageCurePatObj.m_PatientCureTabDataGrid.datagrid("getSelected");
	if (row) {
		var DCARowId=row.DCARowId;
		if(DCARowId==""){
			$.messager.alert('提示','获取申请单信息错误!',"warning");
			return false;
		}
		com_openwin.ShowApplyDetail(DCARowId,ServerObj.DHCDocCureLinkPage,PatientCureTabDataGridLoad);
	}else{
		$.messager.alert('提示','请选择一条申请单!',"warning");
		return false;
	}
	
}
function UpdateAssessment(){
	var row = PageCurePatObj.m_PatientCureTabDataGrid.datagrid("getSelected");
	if (row) {
		var DCARowId=row.DCARowId;
		var OrdBilled=row.OrdBilled;
		var ApplyStatusCode=row.ApplyStatusCode;
		var CureCfgLimit=row.CureCfgLimit;
		if(DCARowId==""){
			$.messager.alert('提示','获取申请单信息错误!',"warning");
			return false;
		}
		if((OrdBilled==$g("否"))||(ApplyStatusCode=="C")){
			$.messager.alert('提示','未有可进行评估的治疗申请,请确认申请是否已缴费或是否已撤消!',"warning");
			return false;	
		}
		var myTitle=$g('治疗评估');
		if(CureCfgLimit=="0"){
			var PageShowFromWay="ShowFromEmrList";
			var myTitle=$g('治疗评估')+'<span style="color:red">('+$g('仅有浏览权限')+')</span>';
		}else{
			var PageShowFromWay="";	
		}
		var href="doccure.cureassessmentlist.csp?OperateType=&DCARowIdStr="+DCARowId+"&PageShowFromWay="+PageShowFromWay;
	    websys_showModal({
			url:href,
			iconCls:"icon-w-paper",
			title:myTitle,
			width:"80%",height:"80%"
		});
	} else {
		$.messager.alert("提示","请选择一个申请单!","warning");
		return false;
	}
}

function InitOrderLoc(){
	var obj=com_withLocDocFun.InitComboDoc("ComboOrderDoc");
	com_withLocDocFun.InitComboLoc("ComboOrderLoc",obj);
}
function InitOrderDoc(LocID){
}

function InitPatCondition(){
	$HUI.combobox("#PatCondition", {
		valueField: 'id',
		textField: 'desc', 
		editable:false,
		data: PageCurePatObj.PatCondition,
		onSelect:function(){
	    	$("#PatConditionVal").val("");
	    	$("#PatientID").val("");
	    }
	});
}
function InitOthChkCondition(){
	var OthChkConditionAry=[{id:"OPCheck",desc:$g("患者类型-门急诊")},{id:"IPCheck",desc:$g("患者类型-住院")},{id:"ChkCurrLoc",desc:$g("本科就诊患者")}]
	$HUI.combobox("#ComboOtherChk", {
		valueField: 'id',
		textField: 'desc', 
		editable:false,
		multiple:true,
		rowStyle:'checkbox',
		selectOnNavigation:false,
		panelHeight:"auto",
		data: OthChkConditionAry
	});
}