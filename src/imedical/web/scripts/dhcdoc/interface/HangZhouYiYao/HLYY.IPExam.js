//
var PageLogicObj = {
    m_Time: 180,	//等候时间
	m_seachTime: 2,	//调用后台获取审方结算间隔时间
    m_Interval: ""
}

$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
});

function Init(){
	//初始化本次医嘱
	InPatOrdDataGrid=InitOrdList();
	LoadOrdListDataGrid();
	if (ServerObj.OrderItemStr!=""){
		PageLogicObj.m_Interval=window.setInterval(SetTime, 1000);
	}
}

function InitEvent(){
	$("#Find").click(LoadOrdListDataGrid);
	$("#BClose").bind("click",function(){
		var rtn=$.m({
		    ClassName:"web.DHCDocHLYYHZYY",
		    MethodName:"CheckBeforeUse",
		    EpisodeID:ServerObj.EpisodeID,
			OEORIRowIdStr:ServerObj.OrderItemStr
		},false);
		var rtnArr=rtn.split("^");
		if ((rtnArr[0]=="-2")||(rtnArr[0]=="-11")||(rtnArr[0]=="11")) {
			$.messager.alert("提示","存在未处理的医嘱,请先处理");
            return false;
		}
		websys_showModal("close");
	})
	if (ServerObj.OrderItemStr==""){
		$("#BClose").hide();
	}
}

function InitOrdList(){
	var toobar=[{
        text: '双签',
        iconCls: 'icon-ok',
        handler: function() { DoubleSignClick();}
    },{
        text: '作废',
        iconCls: 'icon-abort-order',
        handler: function() {
	        opl.view.abortOrderHandler();
		}
    }];
	/*var Columns = [[
		{field:'Check',checkbox:true},
		{field:'OrderRowid',title:'医嘱id',hidden:true},
		{field:'OeoriOeoriDR',title:'主医嘱id',hidden:true},
		{field:'Priority',title:'医嘱类型',width:80,align:'center'},
		{field:'OrdStartDate',title:'开始日期',width:90,align:'center'},
		{field:'OrdStartTime',title:'开始时间',width:70,align:'center'},
		{field:'ArcimDesc',title:'医嘱名称',width:200,align:'center'},
		{field:'DoseQty',title:'单次剂量',width:70,align:'center'},
		{field:'PHFreq',title:'频次',width: 50,align:'center'},
		{field:'Instr',title:'用法',width:70,align:'center'},
		{field:'GroupSign',title:'组符号',width:50,align:'center'},
		{field:'Doctor',title:'医生',width:70,align:'center'},
		{field:'ReLoc',title:'接收科室',width:90,align:'center'},
		{field:'OrdStatus',title:'状态',width:70,align:'center'},
		{field:'GroupNo',title:'组号',width:80,align:'center',hidden:true},
		{field:'IsSuccess',title:'审方结果',width:80,align:'center'},
		{field:'NowStatus',title:'状态',width:50,align:'center'},
		{field:'ErrorAndAdvice',title:'错误信息及药师建议',width:300,align:'center',
			formatter: function(value,row,index){
				return '<a class="editcls-TOrderDesc" id="'+row["OrderRowid"]+'" onmouseover="ShowDetails(this)">'+value+'</a>';
			}
		},
		{field:'DoubleSign',title:'双签内容',width:120,align:'center'},
		{field:'CheckPharmId',title:'药师工号',width:80,align:'center'},
		{field:'CheckPharmName',title:'药师姓名',width:80,align:'center'},
	]];*/
	var OrdListDataGrid = $("#tabOrdList").datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: false,
		multiselect: true,
		fitColumns: false, 			//为true时,不显示横向滚动条
		checkOnSelect: true,		//单击行时选择复选框
		selectOnCheck: true,		//如果为true,单击复选框将永远选择行;如果为false,选择行将不选中复选框。
		rownumbers: false,
		autoRowHeight: false,
		loadMsg: '加载中..',
		pagination : false, 
		idField:'OrderRowid',
		className:"web.DHCDocHLYYHZYY",
		queryName:"QryOrderInfo",
		toolbar:toobar,
		//columns:Columns,
		onColumnsLoad:function(cm){
			var colWidthObj={
				Priority:80,OrdStartDate:90,OrdStartTime:70,DoseQty:70,PHFreq:50,Instr:70,
				GroupSign:30,Doctor:70,ReLoc:90,OrdStatus:70,GroupNo:80,IsSuccess:80,NowStatus:50,
				ErrorAndAdvice:300,DoubleSign:120,CheckPharmId:80,CheckPharmName:80
			};
			for (var i=cm.length-1;i>=0;i--){
				var field=cm[i]['field'];
				if(["OrderRowid","OeoriOeoriDR","ArcimDesc","OrderId","TStDateHide"].indexOf(field)>-1){
					cm.splice(i,1);
					continue;
				}
				if(typeof colWidthObj[field]!='undefined'){
					cm[i].width=colWidthObj[field];
				}
				switch(field){
					case 'ErrorAndAdvice':
						cm[i].formatter = function(value,rec){
							return '<a class="editcls-TOrderDesc" id="'+rec["OrderRowid"]+'" onmouseover="ShowDetails(this)">'+value+'</a>';
						}
						break;
					default:break;
				}
			}
		},
		frozenColumns:[[
			{field:'Check',title:'选择',checkbox:'true',align:'center',width:70,auto:false},
			{field:'OrderRowid',title:'医嘱id',hidden:true},
			{field:'OeoriOeoriDR',title:'主医嘱id',hidden:true},
 			{field:'ArcimDesc',title:'医嘱名称',align:'left',width:200,auto:false}
		]],
		rowStyler:function(rowIndex, rowData){
 			if((rowData.OeoriOeoriDR=="")&&(rowData.GroupSign!="")){
		 		return 'background-color:#60F807;';
		 	}
		},
		onCheck:function(rowIndex, rowData){
			var GroupNo=rowData.GroupNo;
			var OrdList=$('#tabOrdList').datagrid('getData')
			for (var i=0;i<OrdList.rows.length;i++) {
				if (rowIndex==i) {continue}
				var myGroupNo=OrdList.rows[i].GroupNo;
				var myOrderRowid=OrdList.rows[i].OrderRowid;
				if (myGroupNo==GroupNo){
					//先判断是否已经选中
					var FindCheckAlready=0
					var Checked=$('#tabOrdList').datagrid('getChecked')
					for (var k=0;k<Checked.length;k++) {
						var TmpOrderRowid=Checked[k].OrderRowid;
						if (TmpOrderRowid==myOrderRowid){
							FindCheckAlready=1
						}
					}
					if (FindCheckAlready==1){continue}
					$('#tabOrdList').datagrid('checkRow',i)
				}
			}
		},
		onUncheck:function(rowIndex, rowData){
			var GroupNo=rowData.GroupNo;
			var OrdList=$('#tabOrdList').datagrid('getData')
			for (var i=0;i<OrdList.rows.length;i++) {
				if (rowIndex==i) {continue}
				var myGroupNo=OrdList.rows[i].GroupNo;
				var myOrderRowid=OrdList.rows[i].OrderRowid;
				if (myGroupNo==GroupNo){
					//先判断是否已经选中
					var FindCheckAlready=1
					var Checked=$('#tabOrdList').datagrid('getChecked');
					for (var k=0;k<Checked.length;k++) {
						var TmpOrderRowid=Checked[k].OrderRowid;
						if (TmpOrderRowid==myOrderRowid){
							FindCheckAlready=0;
						}
					}
					if (FindCheckAlready==1){continue}
					$('#tabOrdList').datagrid('uncheckRow',i)
				}
			}
		},
		/*
		onSelect:function(rowIndex, rowData){
			var GroupNo=rowData.GroupNo;
			var OrdList=$('#tabOrdList').datagrid('getData')
			for (var i=0;i<OrdList.rows.length;i++) {
				if (rowIndex==i) {continue}
				var myGroupNo=OrdList.rows[i].GroupNo;
				var myOrderRowid=OrdList.rows[i].OrderRowid;
				if (myGroupNo==GroupNo){
					//先判断是否已经选中
					var FindCheckAlready=0
					var Checked=$('#tabOrdList').datagrid('getChecked')
					for (var k=0;k<Checked.length;k++) {
						var TmpOrderRowid=Checked[k].OrderRowid;
						if (TmpOrderRowid==myOrderRowid){
							FindCheckAlready=1
						}
					}
					if (FindCheckAlready==1){continue}
					$('#tabOrdList').datagrid('checkRow',i)
				}
			}
		},
		onUnselect:function(rowIndex, rowData){
			var GroupNo=rowData.GroupNo;
			var OrdList=$('#tabOrdList').datagrid('getData')
			for (var i=0;i<OrdList.rows.length;i++) {
				if (rowIndex==i) {continue}
				var myGroupNo=OrdList.rows[i].GroupNo;
				var myOrderRowid=OrdList.rows[i].OrderRowid;
				if (myGroupNo==GroupNo){
					//先判断是否已经选中
					var FindCheckAlready=1
					var Checked=$('#tabOrdList').datagrid('getChecked');
					for (var k=0;k<Checked.length;k++) {
						var TmpOrderRowid=Checked[k].OrderRowid;
						if (TmpOrderRowid==myOrderRowid){
							FindCheckAlready=0;
						}
					}
					if (FindCheckAlready==1){continue}
					$('#tabOrdList').datagrid('uncheckRow',i)
				}
			}
		},
		onLoadSuccess:function(data){
			var Length=data.rows.length
			for (var i=0;i<Length;i++) {
				$('#tabOrdList').datagrid('checkRow',i)
			}
		}*/
	});
	return OrdListDataGrid;
}

function LoadOrdListDataGrid(){
	var StartDate=$HUI.datebox("#StartDate").getValue();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	var OrderDesc=$("#OrderDesc").val();
	var LongOrder=$("#LongOrder").checkbox("getValue")?"on":"";
	var ShortOrder=$("#ShortOrder").checkbox("getValue")?"on":"";
	var RefuseOrder=$("#RefuseOrder").checkbox("getValue")?"on":"";
	$.cm({
	    ClassName:"web.DHCDocHLYYHZYY",
	    QueryName:"QryOrderInfo",
	    EpisodeID:ServerObj.EpisodeID,UserID:session['LOGON.USERID'],
	    StartDate:StartDate,EndDate:EndDate,OrderDesc:OrderDesc,
	    LongOrder:LongOrder,ShortOrder:ShortOrder,RefuseOrder:RefuseOrder,
	    rows:99999
	},function(GridData){
		InPatOrdDataGrid.datagrid('uncheckAll').datagrid('loadData',GridData);
	})
}

function ShowDetails(that){
	var OrderRowId=that.id;
	var rows=InPatOrdDataGrid.datagrid('getRows');
	var index=InPatOrdDataGrid.datagrid('getRowIndex',OrderRowId);
	var content=rows[index]['ErrorAndAdvice'];
	$(that).webuiPopover({
		title:'',
		content:content,
		trigger:'hover',
		placement:'bottom',
		style:'inverse',
		height:'auto'
		
	});
	$(that).webuiPopover('show');
}

function SetTime(){
	$("#DivMsg").text("您的用药医嘱正在药师审核中，剩余"+PageLogicObj.m_Time+"秒，请等待...");
	PageLogicObj.m_Time--;
	if (PageLogicObj.m_Time>=0) {
		if (parseInt(PageLogicObj.m_Time)%parseInt(PageLogicObj.m_seachTime)==0) {
			var rtn=$.m({
				ClassName:"web.DHCDocHLYYHZYY",
				MethodName:"CheckBeforeUse",
				EpisodeID:ServerObj.EpisodeID,
				OEORIRowIdStr:ServerObj.OrderItemStr
			},false);
			var rtnArr=rtn.split("^");
			if (rtnArr[0]=="0") {
				window.parent.$.messager.popover({msg:"您的用药医嘱，药师人工审方通过，页面自动关闭",type:'success'});
				websys_showModal("close");
			}else if (rtnArr[0]!="-2") {
				$("#DivMsg").text("您的用药医嘱，药师人工审方已完毕，请在下方查看审方结果");
				window.clearInterval(PageLogicObj.m_Interval);
				LoadOrdListDataGrid();
			}
		}
	}else{
		window.clearInterval(PageLogicObj.m_Interval);
		//此处是否处理表数据？后面要是再返回了怎么办？
		/*var rtn=$.m({
		    ClassName:"web.DHCDocHLYYHZYY",
		    MethodName:"SignHLYYInfo",
		    EpisodeID:ServerObj.EpisodeID,
			DataStr:ServerObj.OrderItemStr,
			SignNotes:"",
			UserID:session['LOGON.USERID'],
			OperType:"F"
		},false);*/
		dhcsys_alert("药师审方结果：等待超时,自动通过...")
		websys_showModal("close");
	}
}

function DoubleSignClick() {
	var SelOrdRowStr=GetSelOrdRowStr("Sign");
	if (SelOrdRowStr=="-1") {
		return false;
	}
	if (SelOrdRowStr=="") {
		$.messager.alert("提示","请选择医嘱!");
		return false;
	}
	destroyDialog("DoubleSign");
	//
	var Content="<div id='DiagWin' style='margin-top: 5px;'>"+"<div style='margin:0 auto;border:none;'>" 
	Content=Content+"<textarea style='width:364px;height:128px;margin:5px;' class='' data-options='required:true' id='SignNotes'></textarea>"
	Content=Content+"</div>"+"</div>"
	//
    var iconCls="icon-w-msg";
    createModalDialog("DoubleSign","双签",380,240,iconCls,"确认",Content,"DoubleSignConfirm("+"'"+SelOrdRowStr+"'"+")");
    $("#SignNotes").focus();
}

function DoubleSignConfirm(SelOrdRowStr) {
	var SignNotes=$("#SignNotes").val();
	if (SignNotes==""){
		$.messager.alert("提示","请填写双签内容!","info",function(){
			$("#SignNotes").focus();
		});
		return false;
	}
	$.m({
		ClassName:"web.DHCDocHLYYHZYY",
		MethodName:"SignHLYYInfo",
		EpisodeID:ServerObj.EpisodeID,
		DataStr:SelOrdRowStr,
		SignNotes:SignNotes,
		UserID:session['LOGON.USERID'],
		OperType:"S"
	},function(val){
		if (val=="0"){
			LoadOrdListDataGrid();
			destroyDialog("DoubleSign");
		}
	});
}

function GetSelOrdRowStr(type){
   var SelOrdRowStr="";
   var SelOrdRowArr=InPatOrdDataGrid.datagrid('getChecked');
   for (var i=0;i<SelOrdRowArr.length;i++){
	   var OrderRowid=SelOrdRowArr[i].OrderRowid;
	   if (OrderRowid==""){ continue;}
	   if (type=="Sign") {
		   var rtn=$.m({
			    ClassName:"web.DHCDocHLYYHZYY",
			    MethodName:"CheckBeforeUse",
			    EpisodeID:ServerObj.EpisodeID,
				OEORIRowIdStr:OrderRowid
			},false);
			var rtnArr=rtn.split("^");
			if (rtnArr[0]!="11") {
				$.messager.alert("提示",SelOrdRowArr[i].ArcimDesc+"-"+rtnArr[1]+",不能进行双签");
				SelOrdRowStr="-1";
				break;
			}
		}
		if (SelOrdRowStr=="") SelOrdRowStr=OrderRowid;
		else SelOrdRowStr=SelOrdRowStr+"^"+OrderRowid;
   }
   return SelOrdRowStr;
}

function createModalDialog(id, _title, _width, _height, _icon, _btntext, _content, _event){
	if(_btntext==""){
		var buttons="";
	}else{
		var buttons=[{
			text:_btntext,
			iconCls:_icon,
			handler:function(){
				if(_event!="") eval(_event);
			}
		}]
	}
	//如果去掉关闭按钮，当用户点击窗体右上角X关闭时，窗体无法回调界面销毁事件，需要基础平台协助处理
	buttons.push({
		text:"关闭",
		iconCls:'icon-w-close',
		handler:function(){
			destroyDialog(id);
		}
	});
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: false,
        content:_content,
        buttons:buttons,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}

function destroyDialog(id){
   $("body").remove("#"+id); //移除存在的Dialog
   $("#"+id).dialog('destroy');
}

//此处是为了作废医嘱之后刷新界面,同时做标记
var oplhlyy=ipdoc.lib.ns("ipdoc.pattreatinfo");
oplhlyy.view=(function(){
	function ReLoadPatAdmInfoJson(){
		var SelOrdRowStr=GetSelOrdRowStr();
		$.m({
			ClassName:"web.DHCDocHLYYHZYY",
			MethodName:"SignHLYYInfo",
			EpisodeID:ServerObj.EpisodeID,DataStr:SelOrdRowStr,
			SignNotes:"",UserID:session['LOGON.USERID'],OperType:"U"
		},function(val){
			//
		});
		LoadOrdListDataGrid();
	}
   return {
	   "ReLoadPatAdmInfoJson":ReLoadPatAdmInfoJson,
   }
})()
