//
var PageLogicObj = {
    m_Time: 180,	//�Ⱥ�ʱ��
	m_seachTime: 2,	//���ú�̨��ȡ�󷽽�����ʱ��
    m_Interval: ""
}

$(function(){
	//��ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
});

function Init(){
	//��ʼ������ҽ��
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
			$.messager.alert("��ʾ","����δ�����ҽ��,���ȴ���");
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
        text: '˫ǩ',
        iconCls: 'icon-ok',
        handler: function() { DoubleSignClick();}
    },{
        text: '����',
        iconCls: 'icon-abort-order',
        handler: function() {
	        opl.view.abortOrderHandler();
		}
    }];
	/*var Columns = [[
		{field:'Check',checkbox:true},
		{field:'OrderRowid',title:'ҽ��id',hidden:true},
		{field:'OeoriOeoriDR',title:'��ҽ��id',hidden:true},
		{field:'Priority',title:'ҽ������',width:80,align:'center'},
		{field:'OrdStartDate',title:'��ʼ����',width:90,align:'center'},
		{field:'OrdStartTime',title:'��ʼʱ��',width:70,align:'center'},
		{field:'ArcimDesc',title:'ҽ������',width:200,align:'center'},
		{field:'DoseQty',title:'���μ���',width:70,align:'center'},
		{field:'PHFreq',title:'Ƶ��',width: 50,align:'center'},
		{field:'Instr',title:'�÷�',width:70,align:'center'},
		{field:'GroupSign',title:'�����',width:50,align:'center'},
		{field:'Doctor',title:'ҽ��',width:70,align:'center'},
		{field:'ReLoc',title:'���տ���',width:90,align:'center'},
		{field:'OrdStatus',title:'״̬',width:70,align:'center'},
		{field:'GroupNo',title:'���',width:80,align:'center',hidden:true},
		{field:'IsSuccess',title:'�󷽽��',width:80,align:'center'},
		{field:'NowStatus',title:'״̬',width:50,align:'center'},
		{field:'ErrorAndAdvice',title:'������Ϣ��ҩʦ����',width:300,align:'center',
			formatter: function(value,row,index){
				return '<a class="editcls-TOrderDesc" id="'+row["OrderRowid"]+'" onmouseover="ShowDetails(this)">'+value+'</a>';
			}
		},
		{field:'DoubleSign',title:'˫ǩ����',width:120,align:'center'},
		{field:'CheckPharmId',title:'ҩʦ����',width:80,align:'center'},
		{field:'CheckPharmName',title:'ҩʦ����',width:80,align:'center'},
	]];*/
	var OrdListDataGrid = $("#tabOrdList").datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: false,
		multiselect: true,
		fitColumns: false, 			//Ϊtrueʱ,����ʾ���������
		checkOnSelect: true,		//������ʱѡ��ѡ��
		selectOnCheck: true,		//���Ϊtrue,������ѡ����Զѡ����;���Ϊfalse,ѡ���н���ѡ�и�ѡ��
		rownumbers: false,
		autoRowHeight: false,
		loadMsg: '������..',
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
			{field:'Check',title:'ѡ��',checkbox:'true',align:'center',width:70,auto:false},
			{field:'OrderRowid',title:'ҽ��id',hidden:true},
			{field:'OeoriOeoriDR',title:'��ҽ��id',hidden:true},
 			{field:'ArcimDesc',title:'ҽ������',align:'left',width:200,auto:false}
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
					//���ж��Ƿ��Ѿ�ѡ��
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
					//���ж��Ƿ��Ѿ�ѡ��
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
					//���ж��Ƿ��Ѿ�ѡ��
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
					//���ж��Ƿ��Ѿ�ѡ��
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
	$("#DivMsg").text("������ҩҽ������ҩʦ����У�ʣ��"+PageLogicObj.m_Time+"�룬��ȴ�...");
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
				window.parent.$.messager.popover({msg:"������ҩҽ����ҩʦ�˹���ͨ����ҳ���Զ��ر�",type:'success'});
				websys_showModal("close");
			}else if (rtnArr[0]!="-2") {
				$("#DivMsg").text("������ҩҽ����ҩʦ�˹�������ϣ������·��鿴�󷽽��");
				window.clearInterval(PageLogicObj.m_Interval);
				LoadOrdListDataGrid();
			}
		}
	}else{
		window.clearInterval(PageLogicObj.m_Interval);
		//�˴��Ƿ�������ݣ�����Ҫ���ٷ�������ô�죿
		/*var rtn=$.m({
		    ClassName:"web.DHCDocHLYYHZYY",
		    MethodName:"SignHLYYInfo",
		    EpisodeID:ServerObj.EpisodeID,
			DataStr:ServerObj.OrderItemStr,
			SignNotes:"",
			UserID:session['LOGON.USERID'],
			OperType:"F"
		},false);*/
		dhcsys_alert("ҩʦ�󷽽�����ȴ���ʱ,�Զ�ͨ��...")
		websys_showModal("close");
	}
}

function DoubleSignClick() {
	var SelOrdRowStr=GetSelOrdRowStr("Sign");
	if (SelOrdRowStr=="-1") {
		return false;
	}
	if (SelOrdRowStr=="") {
		$.messager.alert("��ʾ","��ѡ��ҽ��!");
		return false;
	}
	destroyDialog("DoubleSign");
	//
	var Content="<div id='DiagWin' style='margin-top: 5px;'>"+"<div style='margin:0 auto;border:none;'>" 
	Content=Content+"<textarea style='width:364px;height:128px;margin:5px;' class='' data-options='required:true' id='SignNotes'></textarea>"
	Content=Content+"</div>"+"</div>"
	//
    var iconCls="icon-w-msg";
    createModalDialog("DoubleSign","˫ǩ",380,240,iconCls,"ȷ��",Content,"DoubleSignConfirm("+"'"+SelOrdRowStr+"'"+")");
    $("#SignNotes").focus();
}

function DoubleSignConfirm(SelOrdRowStr) {
	var SignNotes=$("#SignNotes").val();
	if (SignNotes==""){
		$.messager.alert("��ʾ","����д˫ǩ����!","info",function(){
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
				$.messager.alert("��ʾ",SelOrdRowArr[i].ArcimDesc+"-"+rtnArr[1]+",���ܽ���˫ǩ");
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
	//���ȥ���رհ�ť�����û�����������Ͻ�X�ر�ʱ�������޷��ص����������¼�����Ҫ����ƽ̨Э������
	buttons.push({
		text:"�ر�",
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
   $("body").remove("#"+id); //�Ƴ����ڵ�Dialog
   $("#"+id).dialog('destroy');
}

//�˴���Ϊ������ҽ��֮��ˢ�½���,ͬʱ�����
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
