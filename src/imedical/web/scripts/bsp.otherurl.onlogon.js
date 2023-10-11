// otherSysUrlOnlogon.js
function init() {
    $("#Loading").fadeOut("fast");
    createDataGrid();
	//configDialog
	$HUI.dialog('#configDialog').close();
}
/*
* Ĭ����ɾ�Ļص�
* ��ʾmsg�����ɹ���ʧ�ܡ���̨dto����json����gridId����,ˢ��gridId���
*/ 
var defaultCallBack = function(rtn){
	if (rtn.success==1){
		if (rtn.gridId!=""){
			$('#'+rtn.gridId).datagrid('load');
		}
		$.messager.popover({msg:rtn.msg,type:'success'});
	}else{
		$.messager.popover({msg:rtn.msg,type:'error'});
	}
}
$('#configBtn').click(function(){
	//##class(websys.StandardTypeItem).GetIdFromCodeOrDescription("websys","IsShowCareInfoInLogonPage")
	var jsonStr = tkMakeServerCall("websys.StandardTypeItem", "GetIdFromCodeOrDescription", "websys", "sysUrlOnLogon");
	if(!jsonStr) {		
		$("#isShow").checkbox("check");
		$("#textDecoration").checkbox("uncheck");
		$("#topDiv").val("14%");
		$("#fontFamily").val("Microsoft Yahei");
		$("#leftDiv").val("10%");
		$("#fontSize").val("12px");
		$("#widthDiv").val("250px");
		$("#fontColor").val("#666");
		$("#bgcDiv").val("#fff");
		$("#fontBgc").val("#eee");
		$HUI.dialog('#configDialog').open();
		return;
	};
	var json = JSON.parse(jsonStr);
	$("#isShow").checkbox("setValue", json.isShow);
	$("#textDecoration").checkbox("setValue", json.textDecoration);
	$("#topDiv").val(json.topDiv);
	$("#fontFamily").val(json.fontFamily);
	$("#leftDiv").val(json.leftDiv);
	$("#fontSize").val(json.fontSize);
	$("#widthDiv").val(json.widthDiv);
	$("#fontColor").val(json.fontColor);
	$("#bgcDiv").val(json.bgcDiv);
	$("#fontBgc").val(json.fontBgc);
	$HUI.dialog('#configDialog').open();
});
$('#FindBtn').click(function(){
	$.messager.progress({title: "��ʾ",text: '��ѯ��....'});
	$(dataGradId).datagrid('load');
});
$('#SysCode1').keypress(function(event){
	// ��ѯ input �� Enter�� ֮��
	if (event.keyCode == "13"){
		$(dataGradId).datagrid('load');
	}
});
$('#SysDesc1').keypress(function(event){
	// ��ѯ input �� Enter�� ֮��
	if (event.keyCode == "13"){
		$(dataGradId).datagrid('load');
	}
});
var dataGradId = "#sysListGrid";
var ActiveTypeData = [{"id":"Y","text":"Yes"},{"id":"N","text":"No"}];
var formatterActiveType = function (value, rowData, rowIndex) {
	for(var i = 0; i < ActiveTypeData.length; i++) {
		if (ActiveTypeData[i].id == value) {
			return ActiveTypeData[i].text;
		}
	}
	return value;
}
$('#configDialog').dialog({
	isTopZindex:true,
	buttons:[{
		text:'����',
		handler:function(){
			var json = {};
			json.isShow = $("#isShow").checkbox("getValue");
			json.textDecoration = $("#textDecoration").checkbox("getValue");
			json.topDiv = $("#topDiv").val();
			json.fontFamily = $("#fontFamily").val();
			json.leftDiv = $("#leftDiv").val();
			json.fontSize = $("#fontSize").val();
			json.widthDiv = $("#widthDiv").val();
			json.fontColor = $("#fontColor").val();
			json.bgcDiv = $("#bgcDiv").val();
			json.fontBgc = $("#fontBgc").val();
			// console.log(JSON.stringify(json));
			$cm({
				ClassName:"websys.dto.OtherSysUrlOnLogon",
				MethodName:"saveConfig",
				str:JSON.stringify(json)
			},defaultCallBack);
		}
	},{
		text:'�ر�',
		handler:function(){$HUI.dialog('#configDialog').close();}
	},{
		text:'�ָ�Ĭ������',
		handler:function(){
			$("#isShow").checkbox("check");
			$("#textDecoration").checkbox("uncheck");
			$("#topDiv").val("14%");
			$("#fontFamily").val("Microsoft Yahei");
			$("#leftDiv").val("10%");
			$("#fontSize").val("12px");
			$("#widthDiv").val("250px");
			$("#fontColor").val("#666");
			$("#bgcDiv").val("#fff");
			$("#fontBgc").val("#eee");
		}
	}]
});
var createDataGrid = function(){
	$(dataGradId).mgrid({
		className:"websys.dto.OtherSysUrlOnLogon",
		editGrid:true,
		key:dataGradId.substr(1, dataGradId.length - 5), // div id + "Grid"
		// title:"��׼�����б�",
		fit:true,
		pageSize:15,
        onBeforeLoad:function(p){
			p.SysCode1 = getValueById("SysCode1");
            p.SysDesc1 = getValueById("SysDesc1");
		},
		columns:[[
			{field:'ID', title:'ID', hidden:true}
			,{field:'SysCode', title:'ϵͳ����', width:50, editor:{type:'text'}}
            ,{field:'SysName', title:'ϵͳ����', width:100, editor:{type:'text'}}
            ,{field:'SysUrl', title:'ϵͳ����', width:150, editor:{type:'text'}}
            ,{field:'SysDesc', title:'ϵͳ����', width:150, editor:{type:'text'}}
            ,{field:'Active', title:'�Ƿ񼤻�', width:50
				,formatter:formatterActiveType
				,editor:{
					type:'combobox',
					readonly : true,					
					options:{
						data:ActiveTypeData,
						valueField:"id",
						textField:"text"
					}
				}
			}
            ,{field:'SysOrder', title:'��ʾ˳��', width:50, editor:{type:'text'}}
		]],
		insOrUpdHandler:function(row){
			var param ={
				"dto.entity.SysCode":row.SysCode,"dto.entity.SysName":row.SysName,"dto.entity.SysUrl":row.SysUrl,"dto.entity.SysDesc":row.SysDesc,"dto.entity.Active":row.Active,"dto.entity.SysOrder":row.SysOrder
			};
			if(!validateData(row)) return false;			
            if (row.ID==""){
				$.extend(param,this.insReq,{
					"dto.entity.id":""
				});
			}else{
				$.extend(param,this.updReq,{
					"dto.entity.id":row.ID
				});
			}
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){			
			return {"ID":"","SysCode":"","SysName":"","SysUrl":"","SysDesc":"","Active":"Y","SysOrder":""};
		},
        delReq:{hidden:true},
		onLoadSuccess:function(data){
			$.messager.progress("close");
		},
		a:1
	});
}
function validateData(row){
	if (!row.SysCode){
		$.messager.popover({msg:"���벻��Ϊ�գ�",type:'info'});
		return false;
	}
	if (!row.SysUrl){
		$.messager.popover({msg:"ϵͳ���� ����Ϊ�գ�",type:'info'});
		return false;
	}
	var order = row.SysOrder;
	if (!!order && !(/(^[1-9]\d*$)/.test(order))){
		$.messager.popover({msg:"˳�����Ч��������",type:'info'});
		return false;
	}
	return true;
}
$('#FindBtn').click(function(){
	$('#ProcessLog').datagrid('load');
});
$(init);
