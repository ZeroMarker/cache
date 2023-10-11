/**
* @author songchunli
* HISUI ������������js
* InterventionItemSetting.js
*/
var PageLogicObj={
	unitArr:[{"value":"��","text":"��"},
			{"value":"��/��","text":"��/��"},
			{"value":"ml","text":"ml"},
			{"value":"kg","text":"kg"},
			{"value":"cm","text":"cm"},
			{"value":"mmHg","text":"mmHg"},
			{"value":"mm","text":"mm"}],
	subWdgetTypesArr:[], //��ѡ��ؼ���������
	m_SelRowId:"",
	delInterventionSubItemArr:[], //�ѵ��"ɾ��"�ı�ѡ������
	iframeflag:"0", //2758853������ƻ����á�ҵ���������  �Ƿ���iframe ����  1���ǣ� 0����
	
}
$(function(){ 
	//2758853������ƻ����á�ҵ���������
	var iframeflag=""
	if (window.parent.window.PageLogicObj){
		iframeflag=window.parent.window.PageLogicObj.iframeflag
	}
	if(iframeflag=="1"){
		PageLogicObj.iframeflag=iframeflag
		Init();		   			// iframe ����
	}
	else if ((iframeflag== "")||(iframeflag=="0")){
		InitHospList();			// ��������
	}
	InitEvent();
});
$(window).load(function() {
	$("#loading").hide();
	InitEditWindow();
	InitInterventionItemEditWinWin();
})
function InitEvent(){
 	$("#BFind").click(function(){
	 	$("#tabInterventionItemList").datagrid("reload");
	});
	$("#SearchDesc").keydown(function(e){
		var key=websys_getKey(e);
		if (key==13){
			$("#tabInterventionItemList").datagrid("reload");
		}
	});
	$("#BSaveInterventionItem").click(SaveInterventionItemClick);
	$("#BCancel").click(function(){
		$("#InterventionItemEditWin").window('close');
	});
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_InterventionItem");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#SearchDesc").val("");
		$.extend(PageLogicObj,{m_SelRowId:"",delInterventionSubItemArr:[]});
		$("#tabInterventionItemList").datagrid("load");
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	// ��ʼ�� ״̬��ѯ����
	InitStatus();
	InitQuestionListDataGrid();
}
function InitStatus(){
	$("#status").combobox({
		valueField:'id',
		textField:'text',
		mode: "local",
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		data:[{"id":"1","text":"����"},{"id":"2","text":"ͣ��"}],
		onSelect:function(rec){
			if (rec) {
				$("#tabInterventionItemList").datagrid("load");
			}
		},
		onUnselect:function(rec){
			$("#tabInterventionItemList").datagrid("load");
		},
		onAllSelectClick:function(e){
			$("#tabInterventionItemList").datagrid("load");
		}
	});
}
function InitQuestionListDataGrid(){
	var ToolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() {
	            ResetInterventionItemEditWin();
				$("#InterventionItemEditWin").window('open');				
            }
        },{
            text: '�޸�',
            iconCls: 'icon-write-order',
            handler: function() {
	            ResetInterventionItemEditWin();
	            var row = $("#tabInterventionItemList").datagrid("getSelected");
				if (!row) {
					$.messager.popover({msg:'��ѡ����Ҫ�޸ĵļ�¼��',type:'error'});
					return false;
				}
				ShowInterventionItemWin(row);
            }
        },{
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
				DeleteInterventionItem();
            }
        }];
	var Columns=[[    
		{ field: 'code',title:'�����������',width:100},
		{ field: 'taskname',title:'������������',width:200,wordBreak:"break-all"},
		{ field: 'widget',title:'�ؼ�����',width:90},
		{ field: 'directuri',title:'��ת·��',width:250,wordBreak:"break-all"},
		{ field: 'unit',title:'��λ',width:90},
		{ field: 'backups',title:'��ѡ��',width:340,wordBreak:"break-all"},
		{ field: 'status',title:'״̬',width:60,
			styler: function(value,row,index){
				if (value =="����"){
					return "color:#3FBD79;"
				}else{
					return "color:#F16E57;"
				}
			}
		}
    ]];
	$('#tabInterventionItemList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : true, 
		rownumbers : true,
		idField:"rowid",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryTask",
		onBeforeLoad:function(param){
			var status=$("#status").combobox('getValues');
			if (status.length ==1){
				status=status.join("");
			}else{
				status="";
			}
			$.extend(PageLogicObj,{m_SelRowId:"",delInterventionSubItemArr:[]});
			$('#tabInterventionItemList').datagrid("unselectAll");
			//param = $.extend(param,{name:$("#SearchDesc").val(),statusFlag:status,hospitalID:$HUI.combogrid('#_HospList').getValue()});
			//2758853������ƻ����á�ҵ���������	
			param = $.extend(param,{name:$("#SearchDesc").val(),statusFlag:status,hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});	
		},
		onDblClickRow:function(rowIndex, rowData){
			ShowInterventionItemWin(rowData);
		}
	})
}
//2758853������ƻ����á�ҵ���������
function ReloadInterventionItemList(){
	$('#tabInterventionItemList').datagrid('load',{name:$("#SearchDesc").val(),statusFlag:status,hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())})
}
//2758853������ƻ����á�ҵ���������
function ResetInterventionItemEditWin(){
	var innerHeight = window.innerHeight;
	var innerWidth= window.innerWidth;
	if (PageLogicObj.iframeflag=="1"){
		$("#InterventionItemEditWin").parent().css({
			width:innerWidth,
		});
		$("#InterventionItemEditWin").parent().find(".panel-header").css({
			width:innerWidth,
		});
		$("#InterventionItemEditWin").window('resize',{
			width:innerWidth,
			height:innerHeight-28,
			top: 0,
			left:0
		});
		$("#IntItemCode,#IntItemDesc,#IntItemNotes,#DirectURL").css({
			width:innerWidth-200,
		});
		$("#tabInterventionSubItemEditList").css({
			width:innerWidth-110,
		});	
    }    
}
function InitEditWindow(){
    $("#InterventionItemEditWin" ).window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
			SetInterventionItemEditWinData();
	   }
	});
}
function InitInterventionItemEditWinWin(){
	$(".unit-tr,.directurl-tr").hide();
	// ����ؼ�����
	InitIntItemWidget();
	// ��λ������
	InitUnit();
	InittabInterventionSubItemEditList();
	$("#EnableDate").datebox("setValue",ServerObj.CurrentDate);
}
function InitIntItemWidget(){
	$('#IntItemWidget').combobox({
		url:$URL+"?ClassName=Nur.NIS.Common.QueryBrokerNew&MethodName=GetOptionOfProperty&className=CF.NUR.NIS.InterventionItem&propertyName=NIVITWidgetType",
		valueField:'value',
		textField:'text',
		editable:false,
		mode: "remote",
		loadFilter:function(data){
			var newData=new Array();
			for (var i=0;i<data.length;i++){
				var value=data[i].value;
				if (!value){
					continue;
				}
				var text=data[i].text;
				newData.push({
					"value":value.toString(),
					"text":text
				});
			}
			return newData;
		},
		onSelect:function(rec){
			if (rec) {
				PageLogicObj.subWdgetTypesArr=[];
				$(".unit-tr,.directurl-tr").hide();
				$("#intitem-layout").layout('panel', 'center').hide();
				var Widget=rec.value;
				if (Widget ==4) { //�ı���		
					$(".unit-tr").show();
					$('#InterventionItemEditWin').window('resize',{
						height: 335
					});
					$("#InterventionItemEditWin,#intitem-layout").css("height",335);
					$("#intitem-layout").layout('panel', 'south').panel("resize",{height:170,top:170});
				}else if(Widget ==5){ //button ��ť
					$(".directurl-tr").show();
					$('#InterventionItemEditWin').window('resize',{
						height: 335
					});
					$("#InterventionItemEditWin,#intitem-layout").css("height",335);
					$("#intitem-layout").layout('panel', 'south').panel("resize",{height:170,top:170});
				}else if((Widget ==6)||(Widget ==7)||(Widget ==8)||(Widget ==9)){ // ���ڡ�ʱ�䡢��ѡ������ա���ѡ�������
					$('#InterventionItemEditWin').window('resize',{
						height: 295
					});
					$("#InterventionItemEditWin,#intitem-layout").css("height",295);
					$("#intitem-layout").layout('panel', 'south').panel("resize",{height:130,top:170});
				}else{ //��ѡ����ѡ�������򡢸�������
					$("#intitem-layout").layout('panel', 'center').show();
					$('#InterventionItemEditWin').window('resize',{
						height: 575
					});
					$("#intitem-layout").layout('panel', 'south').panel("resize",{height:130,top:425});
				}
				$("#intitem-layout").layout("resize");
				if (Widget ==10){
					var ComboxData=$('#IntItemWidget').combobox("getData")
					var arr=["1", "2", "4", "6", "7", "8", "9"];
					for (var i=0;i<ComboxData.length;i++){
						var data=ComboxData[i];
						var value=data.value;
						if (arr.includes(value)){
							PageLogicObj.subWdgetTypesArr.push({"value":value,"text":data.text});
						}
					}
				}else{
					PageLogicObj.subWdgetTypesArr.push({"value":rec.value,"text":rec.text,selected:true});
				}
			}
		}
    });
}
function InitUnit(){
	$HUI.combobox("#Unit", {
		valueField:'value',
		textField:'text',
		data: PageLogicObj.unitArr
    });
}
function InittabInterventionSubItemEditList(){
	var ToolBar = [{
		text: '����',
		iconCls: 'icon-add',
		handler: function() {
			var IntItemWidget=$("#IntItemWidget").combobox("getValue");
			if (!IntItemWidget) {
				$.messager.popover({msg:'��ѡ������������ͣ�',type:'error'});
				$('#IntItemWidget').next('span').find('input').focus();
				return false;
			}
			var Len=$("#tabInterventionSubItemEditList").datagrid("getRows").length;
			$("#tabInterventionSubItemEditList").datagrid("insertRow",{
				index: Len,
				row: {
					rowid:""
				}
			});
			$("#tabInterventionSubItemEditList").datagrid("beginEdit", Len);
			var Editors=$('#tabInterventionSubItemEditList').datagrid("getEditors",Len);
			$(Editors[0].target).focus();
			$(Editors[1].target).combobox("loadData",PageLogicObj.subWdgetTypesArr);
		}
	}];
	var Columns=[[    
		//{ field: 'order',title:'���',width:95},
		{ field: 'name',title:'��ѡ��',width:150,wordBreak:"break-all",
			editor:{
				type:'text'
			}
		},
		{ field: 'subTypeId',title:'��ѡ��ؼ�����',width:130,wordBreak:"break-all", 
			editor:{
				type:'combobox',
				options:{
					valueField:'value',
					textField:'text',
					method:'local',
					editable:false
				}
			},
			formatter: function(value,row,index){
				return row.typeName;
			}
		},
		{ field: 'desc', title: '��ѡ������',width:220,
			editor:{
				type:'text'
			}
		},
		{ field: 'Action', title: '����',
			formatter:function(value,row,index){
				var d = "<a href='#' onclick='DeleteRow(this)'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/></a>";
				return d;
			}
		}
	]];
	$('#tabInterventionSubItemEditList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, 
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : false, 
		rownumbers : true, 
		idField:"rowid",
		columns :Columns, 
		toolbar:ToolBar,
		nowrap:false,  /*�˴�Ϊfalse*/
		onBeforeLoad:function(param){
			$('#tabInterventionSubItemEditList').datagrid("unselectAll");
		}
	})
}
function ShowInterventionItemWin(row){
	PageLogicObj.m_SelRowId=row.rowid;
	$.cm({
		ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
		MethodName:"GetTaskByID",
		rowID:row.rowid
	},function(JsonData){
		$("#IntItemCode").val(JsonData.itemcode);
		$("#IntItemDesc").val(JsonData.name);
		$("#IntItemNotes").val(JsonData.note);
		$("#IntItemWidget").combobox("select",JsonData.widget);
		$("#Unit").combobox("setText",JsonData.unit);
		$("#DirectURL").val(JsonData.uri);
		$("#EnableDate").datebox("setValue",JsonData.startdate);
		$("#StopDate").datebox("setValue",JsonData.stopdate);
		$('#tabInterventionSubItemEditList').datagrid("loadData",JsonData.backup);
		$("#InterventionItemEditWin").window('open');
	})
}
function SetInterventionItemEditWinData(){
	$("#IntItemCode,#IntItemDesc,#IntItemNotes,#DirectURL").val("");
	$("#IntItemWidget").combobox("setValue","");
	$("#Unit").combobox("setValue","");
	$("#EnableDate").datebox("setValue",ServerObj.CurrentDate);
	$("#StopDate").datebox("setValue","");
	$('#tabInterventionSubItemEditList').datagrid("loadData",[]);
	$(".unit-tr,.directurl-tr").hide();
	$('#InterventionItemEditWin').panel('resize',{
		height: 575
	});
	$("#intitem-layout").layout('panel', 'center').show().panel("resize",{height:270});
	$("#intitem-layout").layout('panel', 'south').panel("resize",{height:130,top:435});
}
function DeleteRow(target){
	var Msg="ȷ��Ҫɾ��������ѡ����";
		Msg += '</br><sapn style="opacity:0.65;">�˱�ѡ��ɾ���󣬵��ȷ������ɾ�����.</sapn>';
	$.messager.confirm('ȷ�϶Ի���', Msg, function(r){
		if (r) {
			var tr = $(target).closest('tr.datagrid-row');
			var index=parseInt(tr.attr('datagrid-row-index'));
			var rows=$("#tabInterventionSubItemEditList").datagrid("getRows");
			var rowid=rows[index].rowid;
			if (rowid) {
				var newObject = jQuery.extend(true, {}, rows[index]);
				$.extend(newObject,{del:1});
				PageLogicObj.delInterventionSubItemArr.push(newObject);
			}
			$('#tabInterventionSubItemEditList').datagrid('deleteRow', index);
		}
	});
}
function DeleteInterventionItem(){
	var selected = $("#tabInterventionItemList").datagrid("getSelected");
	if (!selected) {
		$.messager.popover({msg:'��ѡ����Ҫɾ���ļ�¼��',type:'error'});
		return false;
	}
	var Msg="ȷ��Ҫɾ����������������?";
		Msg += '</br><sapn style="opacity:0.65;">�˻�������ɾ���󣬻��������н���������˻�������.</sapn>';
	$.messager.confirm('��ʾ',Msg,function(r){   
		if (r){
			var rtn=$.m({
				ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
				MethodName:"DeleteTask",
				rowID:selected.rowid,
				optID:session['LOGON.USERID']
			},false)
			if (rtn !=0) {
				$.messager.popover({msg:'ɾ��ʧ�ܣ�',type:'error'});
				return false;
			}else{
				var Index=$('#tabInterventionItemList').datagrid('getRowIndex',selected.rowid);
				$('#tabInterventionItemList').datagrid('deleteRow', Index);
			}
		}
	}); 
}
// �����ʩС��
function SaveInterventionItemClick(){
	var IntItemDesc=$("#IntItemDesc").val();
	if (!IntItemDesc) {
		$.messager.popover({msg:'������������������',type:'error'});
		$('#IntItemDesc').focus();
		return false;
	}
	var IntItemWidget=$("#IntItemWidget").combobox("getValue")
	if (!IntItemWidget) {
		$.messager.popover({msg:'��ѡ������ؼ����ͣ�',type:'error'});
		$('#IntItemWidget').next('span').find('input').focus();
		return false;
	}
	var NIVITUrl="";
	if (IntItemWidget ==5) {
		NIVITUrl=$("#DirectURL").val();
		if (NIVITUrl.length < 1 || NIVITUrl.urlLen > 200) {
			$.messager.popover({msg:'��ת·������Ϊ1~200���ַ���',type:'error'});
			$('#DirectURL').focus();
			return false;
		}
	}
	var NIVITUnit="";
	if (IntItemWidget ==4) {
		NIVITUnit=$("#Unit").combobox("getText");
		if (NIVITUnit.length < 1 || NIVITUnit.urlLen > 20) {
			$.messager.popover({msg:'��λ����Ϊ1~20���ַ���',type:'error'});
			$('#Unit').focus();
			return false;
		}
	}
	var dataArray=new Array();
	var arr=["1", "2", "3", "10"];
	
	if ($.inArray(IntItemWidget, arr)>=0){ //(arr.includes(IntItemWidget))
		var rows=$("#tabInterventionSubItemEditList").datagrid("getRows");
		for (var i=0;i<rows.length;i++){
			var rowid=rows[i].rowid;
			if (!rowid) rowid="";
			var Editors=$('#tabInterventionSubItemEditList').datagrid("getEditors",i);
			if (Editors.length >0){
				var name=$(Editors[0].target).val();
				if (!name) {
					$.messager.popover({msg:'��'+(i+1)+'�У������뱸ѡ�',type:'error'});
					$(Editors[0].target).focus();
					return false;
				}else if(name.length < 1 || name.urlLen > 50){
					$.messager.popover({msg:'��'+(i+1)+'�У���ѡ������Ϊ1~50���ַ���',type:'error'});
					$(Editors[0].target).focus();
					return false;
				}
				var subTypeId=$(Editors[1].target).combobox("getValue");
				if (!subTypeId) {
					$.messager.popover({msg:'��'+(i+1)+'�У���ѡ��ѡ��ؼ����ͣ�',type:'error'});
					$(Editors[1].target).next('span').find('input').focus();
					return false;
				}
				var typeName=$(Editors[1].target).combobox("getText");
				var desc=$(Editors[2].target).val();
				if ((desc)&&(desc.length >100)) {
					$.messager.popover({msg:'��'+(i+1)+'�У���ѡ������������100���ַ���',type:'error'});
					$(Editors[1].target).focus();
					return false;
				}
			}else{
				var name=rows[i].name;
				var subTypeId=rows[i].subTypeId;
				var desc=rows[i].desc;
				if (!desc) desc="";
				var typeName=rows[i].typeName;
			}
			dataArray.push({
				"desc":desc,"name":name,"order":(i+1),"rowid":rowid,"subTypeId":subTypeId,"typeName":typeName,"rowKey":""
			});
		}
		if (dataArray.length < 1 || dataArray.length > 100){
			$.messager.popover({msg:'��ѡ��Ϊ1~100����',type:'error'});
			return false;
		}
		dataArray=dataArray.concat(PageLogicObj.delInterventionSubItemArr);
	}
	var NIVITNote=$("#IntItemNotes").val();
	var NIVITEnableDate=$("#EnableDate").datebox("getValue");
	if (!NIVITEnableDate) {
		$.messager.popover({msg:'����д�������ڣ�',type:'error'});
		$('#EnableDate').next('span').find('input').focus();
		return false;
	}
	var NIVITStopDate=$("#StopDate").datebox("getValue");
	if ((NIVITStopDate)&&(CompareDate(NIVITEnableDate,NIVITStopDate))) {
		$.messager.popover({msg:'ͣ�����ڲ��������������ڣ�',type:'error'});
		$('#StopDate').next('span').find('input').focus();
		return false;
	}
	var sc=$.m({
		ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
		MethodName:"SaveTask",
		taskID:PageLogicObj.m_SelRowId,
		NIVITName:IntItemDesc, 
		NIVITWidgetType:IntItemWidget, 
		NIVITUrl:NIVITUrl, 
		NIVITNote:NIVITNote, 
		NIVITUnit:NIVITUnit, 
		NIVITRequired:"", 
		NIVITValueType:"", 
		LocID:session['LOGON.CTLOCID'], 
		NIVITTemplateFunction:"", 
		NIVITEnableDate:NIVITEnableDate, 
		NIVITStopDate:NIVITStopDate, 
		OptID:session['LOGON.USERID'], 
		BackUpArray:JSON.stringify(dataArray),
		VitalSign:"", 
		//hospitalID:$HUI.combogrid('#_HospList').getValue()
		//2758853������ƻ����á�ҵ���������
		hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
	},false)
	if (sc>=0){
		$("#InterventionItemEditWin").window("close");
		$("#tabInterventionItemList").datagrid("reload");
	}else{
		$.messager.alert("��ʾ","����ʧ��!");
		return false;
	}
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (dtseparator=="-") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (dtseparator=="/") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(dtseparator=="/"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function CompareDate(date1,date2){
	var date1 = myparser(date1);
	var date2 = myparser(date2); 
	//if(date2<=date1){
	if(date2<date1){   
		return true;  
	} 
	return false;
}
