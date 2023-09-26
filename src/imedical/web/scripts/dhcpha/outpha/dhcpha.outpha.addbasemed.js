/*
ģ��:����ҩ��
��ģ��:����ҩ��-��ҳ-��˵�-�������ҩƷά��
createdate:2016-06-23
creator:yunhaibao
*/
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var url = "dhcpha.outpha.addbasemed.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID']; 
$(function(){
	/// ��ʼ��ҽ������	
	var options={
		url:commonOutPhaUrl+'?action=GetCtLocDs'
	}
	$('#docLoc').dhcphaEasyUICombo(options);
	/// ��ʼ��ʹ�ÿ���
	var options={
		url:commonOutPhaUrl+'?action=GetCtLocDs'
	}
	$('#useLoc').dhcphaEasyUICombo(options);
	/// ��ʼ��ʹ�ÿ���
	var options={
		url:commonOutPhaUrl+'?action=GetInstuDs'
	}
	$('#instu').dhcphaEasyUICombo(options);
	/// ��ʼ��ҩƷ
	InitCmgArcItm();
	
	InitBaseMedGrid();	
	$('#basemedgrid').datagrid('reload');
	$('#btnDelete').bind('click',btnDeleteHandler);//���ɾ��
	$('#btnClear').bind('click',btnClearHandler);//���ɾ��
	$('#btnAdd').bind('click', btnAddHandler);//�������
	$('#btnUpdate').bind('click',btnUpdateHandler);//����޸�
});
function InitCmgArcItm(){
    var tmpOptions={
	    url:"DHCST.QUERY.JSON.csp?Plugin=EasyUI.DataGrid&"+
				 "ClassName=web.DHCST.ARCITMMAST&QueryName=GetArcItmMast"+
				 "&StrParams="+"|@|",
	    columns: [[
			{field:'arcItmRowId',title:'arcItmRowId',width:100,sortable:true,hidden:true},
			{field:'arcItmCode',title:'ҩƷ����',width:100,sortable:true},
			{field:'arcItmDesc',title:'ҩƷ����',width:300,sortable:true}
	    ]],
		idField:'arcItmRowId',
		textField:'arcItmDesc',
		mode:"remote",
		pageSize:30, 
		pageList:[30,50,100],  
		pagination:true,
		panelWidth:500,
		onBeforeLoad: function(param) {
            param.StrParams = param.q;
        },
		onLoadSuccess:function(data) {
			/*
			LoadTimes=LoadTimes+1;
			if (LoadTimes==1){
				if (arcItmRowId!=""){
					$("#cmbLinkDict").combogrid("setValue",arcItmRowId);
				}else{
					$("#cmbLinkDict").combogrid("clear");
				}
			}
			*/
		}
    }
	$("#cmgArcItm").combogrid(tmpOptions);
}
//��ʼ������ҩƷgrid
function InitBaseMedGrid(){
	//����columns
	var columns=[[
        {field:'Tarcitm',title:'ҩƷ����',width:275},
        {field:'Tinst',title:'�÷�',width:190},
        {field:'Tdocloc',title:'ҽ������',width:220},
        {field:'Tuseloc',title:'ʹ�ÿ���',width:220},
		{field:'Tnote',title:'��ע',width:200},
        {field:'Tphbr',title:'Tphbr',width:150,hidden:true},
        {field:'Tinstrowid',title:'Tinstrowid',width:150,hidden:true},
        {field:'Tdoclocdr',title:'Tdoclocdr',width:150,hidden:true},
        {field:'Tuselocdr',title:'Tuselocdr',width:150,hidden:true},
        {field:'Tarcdr',title:'Tarcdr',width:150,hidden:true},
        {field:'Tinci',title:'Tinci',width:150,hidden:true}
	]];  
	
   //����datagrid	
   $('#basemedgrid').datagrid({    
        url:url+'?action=QueryLocBaseMed',
        fit:true,
        striped:true,
	    border:false,
	    toolbar:'#btnbar',
	    singleSelect:true,
	    rownumbers:false,
        columns:columns,
        pageSize:50,  // ÿҳ��ʾ�ļ�¼����
	    pageList:[50,100,300],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    fitColumns:false,
	    pagination:true,
	    onClickRow:function(rowIndex,rowData){
			if (rowData){
				var RowId=rowData['TRowId'];
				$("#remark").val(rowData["Tnote"]);
				$("#cmgArcItm").combogrid("setValue",rowData["Tarcdr"]);
				$("#cmgArcItm").combogrid("setText",rowData["Tarcitm"]);
				$("#instu").combobox('setValue',rowData["Tinstrowid"]);
				$("#docLoc").combobox('setValue',rowData["Tdoclocdr"]);
				$("#useLoc").combobox('setValue',rowData["Tuselocdr"]);
			}
		}   
   });
}

///����
function btnAddHandler(){
	var remark=$("#remark").val();
	var arcim=$("#cmgArcItm").combogrid("getValue")||"";
	if (arcim==""){
		$.messager.alert('��ʾ',"��¼��ҩƷ����!","info");
		return;
	}
	var instu=$("#instu").combobox('getValue');
	if  ($.trim($("#instu").combobox('getText'))==""){
		instu="";
	}
	var docloc=$("#docLoc").combobox('getValue');
	if  ($.trim($("#docLoc").combobox('getText'))==""){
		docloc="";
	}
	if (docloc==""){
		$.messager.alert('��ʾ',"��ѡ��ҽ������!","info");
		return;
	}
	var useloc=$("#useLoc").combobox('getValue');
	if  ($.trim($("#useLoc").combobox('getText'))==""){
		useloc="";
	}
	if (useloc==""){
		$.messager.alert('��ʾ',"��ѡ��ʹ�ÿ���!","info");
		return;
	}
    var returnValue= tkMakeServerCall("web.DHCOutPhAddBaseMed","AddBaseMed",arcim,instu,docloc,useloc,remark);
    if(returnValue==0){
	    $.messager.alert('��ʾ',"����������ظ�����!","info");
	    return;
    }else if (returnValue>0){
	    $('#basemedgrid').datagrid('reload');
	    btnClearHandler();
    }
}


///ɾ��
function btnDeleteHandler(){
	var seletcted = $("#basemedgrid").datagrid("getSelected");
	if (seletcted==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫɾ���ļ�¼!","info");
		return;
	}
	var phbr=seletcted["Tphbr"];
	$.messager.confirm('��ʾ',"ȷ��ɾ����",function(r){
		if(r){
			var retValue=tkMakeServerCall("web.DHCOutPhAddBaseMed","DelBaseMed",phbr);
			if(retValue==0){
				$('#basemedgrid').datagrid('reload');
				btnClearHandler();
			}
			else{
				$.messager.alert('��ʾ',"ɾ��ʧ��,�������:"+retValue,"error");
			}
		}
	});
}
///�޸�
function btnUpdateHandler(){
	var seletcted = $("#basemedgrid").datagrid("getSelected");
	if (seletcted==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�޸ĵļ�¼!","info");
		return;
	}
	var remark=$("#remark").val();
	var arcim=$("#cmgArcItm").combogrid("getValue")||"";
	if (arcim==""){
		$.messager.alert('��ʾ',"��¼��ҩƷ����!","info");
		return;
	}
	var instu=$("#instu").combobox('getValue');
	if  ($.trim($("#instu").combobox('getText'))==""){
		instu="";
	}
	var docloc=$("#docLoc").combobox('getValue');
	if  ($.trim($("#docLoc").combobox('getText'))==""){
		docloc="";
	}
	if (docloc==""){
		$.messager.alert('��ʾ',"��ѡ��ҽ������!","info");
		return;
	}
	var useloc=$("#useLoc").combobox('getValue');
	if  ($.trim($("#useLoc").combobox('getText'))==""){
		useloc="";
	}
	if (useloc==""){
		$.messager.alert('��ʾ',"��ѡ��ʹ�ÿ���!","info");
		return;
	}
	var phbr=seletcted["Tphbr"];
    var returnValue= tkMakeServerCall("web.DHCOutPhAddBaseMed","UpdBaseMed",phbr,arcim,instu,docloc,useloc,remark);
    if (returnValue==0){
	    $('#basemedgrid').datagrid('reload');
	    btnClearHandler();
    }else if(returnValue==-2){
	    $.messager.alert('��ʾ',"�޸ĺ�ļ�¼�Ѵ���!","info");
    }else {
	    $.messager.alert('��ʾ',"�޸�ʧ��,�������:"+returnValue,"error");
	}
}
///���
function btnClearHandler(){
	$("input[name=txtCondition]").val("");
	$("#docLoc").combobox('setValue',"");
	$("#useLoc").combobox('setValue',"");
	$("#instu").combobox('setValue',"");
	$("#cmgArcItm").combogrid("clear");
	$("#cmgArcItm").combogrid("grid").datagrid("options").queryParams.q="";
	$("#cmgArcItm").combogrid("grid").datagrid("reload");
	$('#basemedgrid').datagrid('loadData',{total:0,rows:[]});
	$('#basemedgrid').datagrid({
     	url:url+'?action=QueryLocBaseMed',
     	queryParams:{
			params:""
		}
	});
}