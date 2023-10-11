/**
 * FileName: dhcinsu.interfacemgr.js
 * Author: lizhi
 * Date: 2022-06-6
 * Description: �ӿڹ���
 */

 var GV = {
	CLASSNAME:"INSU.MI.ClassMethodCom"	 
}
 var HospDr=session['LOGON.HOSPID'];
 var SelRowid="";
 var PUBLISHSTATUS={"0":"�ݸ�","1":"���","2":"����"}
//�������
$(function(){
	var Rq1 = INSUGetRequest();
	var classname = Rq1["classname"];
	var methodname = Rq1["methodname"];
	var InterfaceCode=Rq1["InterfaceCode"];
	InitDeleteDialog();
	//�س��¼�    
	key_enter();
	//Ĭ��ʱ��
	setDateBox();
	//��ʼ����Ʒ��
	init_ProductLinkGroup();
	// ��Ʒ���������
	ini_ProductLine();
	//��ʼ����Ʒ��
    //InitProductLine();
    //�������������
	// grid
	init_dg();
	//  ����Ա
	//InitUser();
	//��ʼ����Ч��־
	//init_EFFTFLAG();
 	Init_QBusinessType();//��ʼ��ҵ������������
	Init_QFunPoint();//��ʼ�����ܵ� 
	clearform();
});
function Init_QBusinessType(){
	$HUI.combobox("#QBusinessType", {
	panelHeight: 200,
	url: $URL,
	editable: true,
	defaultFilter: 4,
	valueField: "DicCode",
	textField: 'DicDesc',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.CFG.COM.DictionaryCtl";
			param.QueryName = "QueryDicDataInfo";
			param.Type = "RSP_HisData_LogicType";
			param.ResultSetType = 'array';
		},
		onLoadSuccess: function (data) {
		},
		onChange:function(val){
			RunQuery();
		},
		
	}); 
}

function Init_QFunPoint(){
	$HUI.combobox("#QFunPoint", {
	panelHeight: 200,
	url: $URL,
	editable: true,
	defaultFilter: 4,
	valueField: "DicCode",
	textField: 'DicDesc',
	onBeforeLoad: function (param) {
		param.ClassName = "BILL.CFG.COM.DictionaryCtl";
		param.QueryName = "QueryDicDataInfo";
		param.Type = "function";
		param.ResultSetType = 'array';
	},
	onLoadSuccess: function (data) {
	},
	onChange:function(val){
		RunQuery();
	},
	
	}); 
}
//��ʼ����Ʒ��
function init_ProductLinkGroup(){
	$HUI.combobox("#QProductTeam", {
		panelHeight: 200,
		url: $URL,
		editable: true,
		valueField: "DicCode",
		textField: 'DicDesc',
		defaultFilter: 4,
		rowStyle:'checkbox',
		multiple:true,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.CFG.COM.DictionaryCtl";
			param.QueryName = "QueryDicDataInfo";
			param.Type = "ProductTeam";
			param.ResultSetType = 'array';
		},
		onLoadSuccess: function (data) {
		},
		onChange:function(val){
			RunQuery();
		},
		
	});
}
//�������
function init_dg(){

	$HUI.datagrid("#dg", {
		idField:'ROWID',
		toolbar:'#toolbar',
		fit: true,
		border: false,
		singleSelect: false,
		pagination: true,
		pageSize: 20,
		displayMsg: '',
		rownumbers:true,
		columns: [[
			{field:'ck',title:'ck',width:220, checkbox:true},
			{ field: 'id', title: '�в���',width: 180, align: "center",
                formatter: function(v, row, index) {
                    var editBtn = '<a href="#this" class="editcls1" onclick="editRow(' + index + ')"></a>';
                    var deleteBtn = '<a href="#this" class="deletecls" onclick="deleteRow(' + (row.ROWID+','+index) + ')"></a>';
                    var logBtn = '<a href="#this" class="logcls" onclick="updateLog(' + (row.ROWID + ',' + index) + ')"></a>';
                    if (row.LogFlag == "Y") {
                        logBtn = '<a href="#this" class="slogcls" onclick="updateLog(' + (row.ROWID + ',' + index) + ')"></a>';
                    }
                    if (row.EFFTFLAG == "Y") {
                        var statusBtn = '<a href="#this" class="stopcls" onclick="updateStatus(' +  (row.ROWID + ',' + index)  +')"></a>';
                        statusBtn += '<a href="#this" class="debugcls" onclick="debugRow(' + (row.ROWID) + ',' + index + ')"></a>'
                    } else {
                        var statusBtn = '<a href="#this" class="startcls" onclick="updateStatus(' +  (row.ROWID + ',' + index)  +')"></a>';
                    }
                    return editBtn + " " + deleteBtn + " " + logBtn + " " + statusBtn;
                }
            },
			{field:'ROWID',title:'ROWID',width:200, hidden: true},
			{field:'CLASSNAME',title:'������',width:200, hidden: true},
			{field:'METHODNAME',title:'��������',width:170, hidden: true},
			{field:'InterfaceCode',title:'�ӿڴ���',width:220,showTip:true,},
			{field:'METHODDESC',title:'�ӿ�����',width:220,showTip:true,},
			{field:'InterfaceType',title:'�ӿ�����',width:70},
			{field:'UseType',title:'��������',width:70,
				formatter: function (value, row, index) {
					return (value == "S") ?"����":"����";
			}},
			{field:'ProductLineName',title:'��Ʒ��',width:120},
			{field:'ProductTeamName',title:'��ز�Ʒ��',width:140},
			{ field: 'EFFTFLAG', title: '״̬', width: 50, 
				formatter: function(v, rec, index) {
                    var EFFTFLAG = (rec.EFFTFLAG == "Y") ? "����" : "ͣ��";
                    return EFFTFLAG;
                },
                styler: function(v, rec, index){
					if (rec.EFFTFLAG != "Y"){
						return 'background-color:#FFC1C1; color:red;';
					}
				}
			},
            { field: 'LogFlag', title: '��¼��־', width: 70, align: "center",
                formatter: function(v, rec, index) {
                    var LogFlag = (rec.LogFlag == "Y") ? "��" : "��";
                    return LogFlag;
                }
            },
			{field:'Status',title:'����״̬',width:80,
                formatter: function(v, rec, index) {
                    var Status = (rec.Status == ""||rec.Status == undefined) ? "�ݸ�" : PUBLISHSTATUS[rec.Status] || rec.Status;
                    return Status;
                }},
			{field:'METHODTYP',title:'��������',width:120,hidden:true}
			
		]],
		onLoadSuccess: function(data) {
			ChangeButtonText($(".editcls1"),"�޸�","icon-write-order");
			ChangeButtonText($(".deletecls"),"ɾ��","icon-cancel");
			ChangeButtonText($(".logcls"),"����־","icon-cal-pen");
			ChangeButtonText($(".slogcls"),"������־","icon-red-cancel-paper");
			ChangeButtonText($(".stopcls"),"ͣ��","icon-lock");
			ChangeButtonText($(".startcls"),"����","icon-unlock");
			ChangeButtonText($(".debugcls"),"����","icon-ok");
			$(this).datagrid('unselectAll');
		},
		onDblClickRow:function(index,row){
			editRow(index);
		}, 
		onLoadError:function(a){
			//alert(2)
		}
	});
	
}
function updateLog(ID, index) {
    var LogFlag = "";
    var Obj = $("#dg").datagrid("getData").rows[index];
    if (Obj != null) {
        LogFlag = Obj.LogFlag;
    }
    Obj.LogFlag = (LogFlag == "Y") ? "N" : "Y";
    var message=(LogFlag == "Y") ? "������־":"����־";
    $.messager.confirm("������ʾ", "��ȷ��Ҫ�޸�Ϊ"+message+"��", function(r) {
        if (r) {
            var Ret = tkMakeServerCall('INSU.MI.ClassMethodCom',"Save",JSON.stringify(Obj),session['LOGON.USERID']);
            var Code = Ret.split("^")[0];
            if (Code == "0") {
                $.messager.popover({ msg: '�޸ĳɹ���', type: 'success', timeout: 1000 });
                $('#dg').datagrid('reload');
            } else {
                $.messager.alert('��ʾ', Code,"error");
            }
        }
    })
}
function updateStatus(ID, index) {
    var EFFTFLAG = "";
    var Obj = $("#dg").datagrid("getData").rows[index];
    if($("#dg").datagrid("getData").rows[index].Status=="2"){$.messager.alert('��ʾ','�����Ľӿڲ�����ͣ��!','info');return;}
    if (Obj != null) {
        EFFTFLAG = Obj.EFFTFLAG;
    }
    Obj.EFFTFLAG = (EFFTFLAG == "Y") ? "N" : "Y";
     var message= (EFFTFLAG == "Y") ? "ͣ��":"����";
    $.messager.confirm("������ʾ", "��ȷ��Ҫ"+message+"����", function(r){
        if (r) {
	        var Ret = tkMakeServerCall('INSU.MI.ClassMethodCom',"Save",JSON.stringify(Obj),session['LOGON.USERID']);
            var Code = Ret.split("^")[0];
            if (Code == "0") {
                $.messager.popover({ msg: '�޸ĳɹ���', type: 'success', timeout: 1000 });
                $('#dg').datagrid('reload');
            } else {
                $.messager.alert('��ʾ', Code);
            }
        }
    })
}
function debugRow(id, index) {
    var Obj = $("#dg").datagrid("getData").rows[index];
    var debugcode=Obj.InterfaceCode;
    var debugdesc=escape(Obj.METHODDESC);
    var classname=Obj.CLASSNAME;
    var methodname=Obj.METHODNAME;
    var inputid=Obj.ROWID;
    var methodtype=Obj.METHODTYP;
    var ProductLine=Obj.ProductLine;
    var InterfaceCode=Obj.InterfaceCode;
    //�򿪵��Խ���
    var url = "dhcinsu.interfacedebugdetail.csp?&debugcode=" + debugcode+"&debugdesc="+debugdesc+"&classname="+classname+"&methodname="+methodname+"&inputid="+inputid+"&methodtype="+methodtype+"&ProductLine="+ProductLine+"&InterfaceCode="+InterfaceCode;
	//var setwidth=920;
	//var setheigth = window.document.body.clientHeight*0.95;
	websys_showModal({
		url: url,
		title: "�ӿڵ���",
		iconCls: "icon-w-edit",
		width: 773,//setwidth,
		height: 657,//setheigth,
		onClose: function()
		{
			
		},
		onMinimize: function()
		{
			$('#dg').datagrid('reload');
		}
	});
    
}
function AddClickHandle() {
	var html='<a href="javascript:void(0)" class="l-btn l-btn-small l-btn-plain" id="PageNote" style="margin-left: 10px;"><span class="l-btn-left l-btn-icon-left" style="bottom: 2px;"><span class="l-btn-text"></span><span class="l-btn-icon icon-help">&nbsp;</span></span></a>'
	var url = "dhcinsu.interfacemgrdetail.csp?&classname="+""+"&methodname="+""; 
	var setwidth=920;
	var setheigth = window.document.body.clientHeight*0.95;
 	var tools=[{
		iconCls:'icon-tip',
		handler:function(){
			$.messager.popover({msg: PageNoteCont,type:'success',timeout: 1000});
			}},]; 
	websys_showModal({
		url: url,
		title: "�ӿ���ϸ����"+html,
		iconCls: "icon-w-edit",
		width: setwidth,
		height: setheigth,
		//tools:tools,
		onMinimize: function()
		{
			$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});
			$('#dg').datagrid('reload');
		}
	});
}
function editRow(indexid) {
	var rowdata =$("#dg").datagrid("getData").rows[indexid];
	var html='<a href="javascript:void(0)" class="l-btn l-btn-small l-btn-plain" id="PageNote" style="margin-left: 10px;"><span class="l-btn-left l-btn-icon-left" style="bottom: 2px;"><span class="l-btn-text"></span><span class="l-btn-icon icon-help"></span></span></a>'
	var InterfaceCode=rowdata['InterfaceCode'];
	var classname=rowdata['CLASSNAME'];
    var methodname=rowdata['METHODNAME'];
    var Status=rowdata['Status'];
	var url = "dhcinsu.interfacemgrdetail.csp?&classname=" + classname+"&methodname="+methodname+"&InterfaceCode="+InterfaceCode+"&Status="+Status; 
	var setwidth=864;
	var setheigth = 680;//window.document.body.clientHeight*0.78;
	websys_showModal({
		url: url,
		title: "�ӿ���ϸ�༭"+html,
		iconCls: "icon-w-edit",
		width: setwidth,
		height: setheigth,
		onClose: function()
		{
			
		},
		onMinimize: function()
		{
			$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});
			$('#dg').datagrid('reload');
		}
		
	});
}
function InitDeleteDialog() {
    $('#DeleteDialog').dialog({
        autoOpen: false,
        title: '��ȷ��',
        closed: true,
        width: 350,
        cache: false,
        modal: true,
        resizable: true,
        buttons: [
        {
            text: 'ȡ��ɾ��',
            iconCls: 'icon-w-close',
            handler: function() {
                $('#DeleteDialog').dialog('close');
            }
        },
		{
			text: 'ȷ��ɾ��',
			iconCls: 'icon-w-save',
			handler: function() {
				var savecode=tkMakeServerCall(GV.CLASSNAME,"Delete",SelRowid)
				if(eval(savecode)==0){
					$('#dg').datagrid('reload');
					$.messager.alert('��ʾ','ɾ���ɹ�!','info');   
				}else{
					$.messager.alert('��ʾ','ɾ��ʧ��!','info');   
				}
				$('#DeleteDialog').dialog('close');
			}
		}
        ]
    });
}
//ɾ����¼
function deleteRow(Rowid,indexid){
	if(Rowid=="" || Rowid<0 || !Rowid){$.messager.alert('��ʾ','��ѡ��Ҫɾ���ļ�¼!','info');return;}
	else if($("#dg").datagrid("getData").rows[indexid].Status=="2"){$.messager.alert('��ʾ','�����Ľӿڲ�����ɾ��!','info');return;}
	$.messager.confirm('��ȷ��','��ȷ��Ҫɾ��������¼��?',function(fb){
		if(fb){
			SelRowid=Rowid;
			$('#DeleteDialog').dialog('open');
		}else{
			return;	
		}
	});
}

function ChangeButtonText(element,desc,icon){
	$(element).linkbutton({iconCls: icon, plain: true});
	$(element).popover({content: desc, placement: 'top-right', trigger: 'hover'});
}
function InitTip(){
	var _content = "<ul class='tip_class' style='padding:5px;'><li style='font-weight:bold'>�Ʒ�ҽ���ӿڹ���ʹ��˵��</li>" +
		'<li>1���ӿ�ע��ɰ�HIS�ڲ��ӿڡ�Webservice�ӿڡ�Htpp�ӿڽ������û����á�</li>' +
		'<li>ͨ������ͳһ��ڣ�##class(INSU.MI.ClassMethodCom).DoMethod(ClsRowId,InputJson)</li>' +
		'<li><span>���ɵ��õ�ʵ�ʽӿڡ�</span></li>' + 
		'<li style="color:#ccc">-------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>2���Ʒ�ҽ��ע���CF_INSU_MI.ClassMethod����־ע���: CF_INSU_MI.LogRegist ����־��¼��CF_INSU_MI.Log��</li>" +
		'<li style="color:#ccc">-------------------------------------------------------------------------------------------------------------------------------------</li>'+
		'<li>3���������ò�����' +
/* 		"<li><span>�ӿڴ������Soap�����ԣ�W.��ͷ��Http�����ԣ�H.��ͷ</span></li>" +  */
		"<li><span>HIS�ڲ��ӿڣ����ñ�Ҫ�Ĳ������ɡ�</span></li>" + 
		'<li><span>Soap���ͽӿڣ����ñ�Ҫ�Ĳ�������,�ṩ����������ͳһwebservice: web.INSUInterfaceWebService.cls��</span></li>' + 
		"<li><span>Http���ͽӿڣ����ñ�Ҫ�Ĳ�������,�ṩ����������ͳһHttp:INSU.MI.InterfaceHttp.cls��</span></li>" + 
		'<li style="color:#ccc">-------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>4��������ϼ�¼��־���򱣴�ӿڷ���ʱ����ͬ������Ʒ�ҽ���ӿ���־ע����Ϣ��</li>" + 
		'<li style="color:#ccc">-------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>5����Soap��Http�������͵Ľӿڣ���������˳�ʱ�Զ��رգ��򵱽ӿ�����ʱ�ҳ������ô���(Ĭ��3��)ʱ�����Զ��رսӿڡ�</li>"+
		'<li style="color:#ccc">-------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>6����ز�Ʒ�飬��ʾ����ӿ��Ǹ�˭�õġ�</li></ul>";//+
		//'<li>----------------------------------------------------------------------------------------------------------------------------------------------</li>';
	$("#tip").popover({
		trigger:'hover',
		content:_content
	});
	$("#tip").popover('show');
}
//�ݸ�0�����1������2
function Operation(type){
 	var checkedRows = $('#dg').datagrid('getChecked');
	var RowIdStr = '';
	if (checkedRows.length == '0'){
		$.messager.alert('��ʾ','��ѡ����Ҫ����������','info');
		return;
	}
	for (var i = 0; i <= checkedRows.length - 1; i++) {
		if(checkedRows[i].Status=="2")
		{
			continue;
		}
		if(checkedRows[i].EFFTFLAG!="Y"&&type=="2")
		{
			$.messager.alert('��ʾ','�����а���ͣ�õĽӿ�,��������!','info');
			return;	
		}
		RowIdStr = RowIdStr + '^' + checkedRows[i].ROWID; 
	}
	var messager="";
	if(RowIdStr=="")
	{
		$.messager.alert('��ʾ','�����Ľӿڲ������޸ķ���״̬!','info');
		return;	
	}
	var rtn = $.m({ClassName: "INSU.MI.ClassMethodCom", MethodName: "UpdatePublishStatusById", Status:type,RowIdStr:RowIdStr,User:session['LOGON.USERID']}, false);
	if (rtn == '0'){
		$.messager.alert('��ʾ','�����ɹ�' , 'success',function(){
			$('#dg').datagrid('reload');
		});
	}else{
		$.messager.alert('��ʾ','����ʧ��' + rtn , 'error',function(){
			//$('#dg').datagrid('reload');
		});
	}	 
}
function clearform(){
	$("#QInterfaceType").combobox('select',"");
	$("#QUseType").combobox('select',"");
	$("#QInterfaceCode").val("");
	$("#InterfaceName").val("");
	$("#QProductLine").combogrid('setValues',"");
	$('#QProductTeam').combobox('setValues', "");
	$('#QBusinessType').combobox('setValues', "");
	$('#QFunPoint').combobox('setValues', "");
	RunQuery();
}
//��ѯ
function RunQuery() {
	ClearGrid("dg");
	var InterfaceCode=getValueById("QInterfaceCode");
	var InterfaceName=getValueById("InterfaceName");
	var InterfaceType=getValueById("QInterfaceType");
	var UseType=getValueById("QUseType");
	var ProductLine=$("#QProductLine").combogrid('getValues');
	var ProductTeam="";
	var ProductTeam =$("#QProductTeam").combobox('getValues');
	var QBusinessType=$("#QBusinessType").combobox('getValues');
	var QFunPoint=$("#QFunPoint").combobox('getValues');
	var EFFTFLAG=getValueById("EFFTFLAG");
	var Status=$("#STATUS").combobox('getValues');
	var ExpStr = ""+ "|" + "" + "|"+"" + "|" +InterfaceName + "|"+InterfaceCode+ "|"+InterfaceType + "|"+UseType+ "|"+ ProductLine+"|"+ ProductTeam+"|"+EFFTFLAG+"|"+QBusinessType+"|"+QFunPoint+"|"+Status;
/* 	$.cm({
		ClassName: "INSU.MI.ClassMethodCom",
		QueryName: "QueryClassMethod",
		ParamInput:ExpStr,
		rows:999999
	},function(jsonData){	
		for (i=0;i<jsonData.rows.length;i++){
			if(jsonData.rows[i]._parentId == ""){
				jsonData.rows[i]['state']='closed';
			}
			if(jsonData.rows[i].ROWID.indexOf("O") >-1){
				jsonData.rows[i]['state']='closed';
			}
		};
		jsonData.total = jsonData.rows.length;
		$('#dg').datagrid('loadData',jsonData);
	}); */
	var QueryParam={
		ClassName: "INSU.MI.ClassMethodCom",
		QueryName: "QueryClassMethod",
		ParamInput:ExpStr,
	}
	loadDataGridStore('dg',QueryParam);
	// ��תҳ
	
}
function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
	$('#' + gridid).datagrid('unselectAll');
	$('#' + gridid).datagrid('clearChecked');
}
//Ĭ��ʱ��
function setDateBox() {
	setValueById('StartDate',getDefStDate(0));
	setValueById('EndDate',getDefStDate(0));
}
///�س�
function key_enter() {
	$('#PatName').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
	$('#PBDr').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
	$('#RegNo').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
	$('#AdmDr').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
	$('#QInterfaceCode').keyup(function(event){
		if (event.keyCode == 13) {
			RunQuery();
		}
		});
	$('#InterfaceName').keyup(function(event){
		if (event.keyCode == 13) {
			RunQuery();
		}
		})
	
}
//����
function clear_click() {
	$('#tQueryPanel').form('clear');
	setDateBox();
	RunQuery();	
}
// ��Ʒ���������
function ini_ProductLine() {
	$HUI.combogrid("#QProductLine", {
		url: $URL + "?ClassName=INSU.MI.ClassMethodCom&QueryName=QueryProductLine",
		idField: "PLCode",
		textField: "PLName",
		singleSelect: true,
		panelWidth: 430,
		columns: [[
			{ title: '����', field: 'PLCode', width: 200 },
			{ title: '����', field: 'PLName', width: 200 }
		]],
		onLoadSuccess:function(data){
					
		},
		onSelect:function(){
			RunQuery();	
		}
	})
}
/**
 * Creator: tangzf
 * CreatDate: 2019-7-10
 * Description: ���ɴμ�����Modifydl
 * input:	msg : ��ʾ����
 * 			buttonType : �Ƿ���ʾ��ť "disable" ����ʾ
 * 			title : ��������
 */
function openCellWindow(msg,buttonType,title){
	$('#editCode').val(msg);
	$('#Modifydl').panel({
    	title:title,
 	});
	$("#saveBtn").linkbutton(buttonType);
	if(buttonType=="disable"){
		$("#saveBtn").hide();	
	}else{
		$("#saveBtn").show();	
	}
	$('#Modifydl').window('open');	
}

function InitUser(){
	$('#UserCode').combobox({
		valueField: 'Desc',
		textField: 'Desc',
		url:$URL,
		defaultFilter:'4',
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUReport';
			param.QueryName= 'FindSSUser';
			param.ResultSetType = 'array';
			param.HospId = HospDr;
		},onLoadSuccess:function(data){
		},onLoadError:function(){
		}	
	});	
}
//����
function Import()
{
	/* var grid = $('#dg');  
    grid.datagrid('getPager').data("pagination").options.pageNumber=2;  

	return; */
	var filePath=""
	var exec= '(function tst(){ var xlApp  = new ActiveXObject("Excel.Application");'
	           +'var fName=xlApp.GetOpenFilename("Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls");'
	           +'if (!fName){fName="";}'
	           +'xlApp.Quit();'
               +'xlSheet=null;'
               +'xlApp=null;'
	           +'return fName;}());'
	  CmdShell.notReturn = 0;
      var rs=CmdShell.EvalJs(exec);
      if(rs.msg == 'success'){
        filePath = rs.rtn;
        importItm(filePath);
      }else{
         $.messager.alert('��ʾ', '���ļ�����'+rs.msg,'error');
      }				   
}
function importItm(filePath)
{
    if (filePath == "") {
        $.messager.alert('��ʾ', '��ѡ���ļ���','info')
        return ;
    }
   $.messager.progress({
         title: "��ʾ",
         msg: '����ע�������',
         text: '���ݶ�ȡ��...'
        }); 
   $.ajax({
	async : true,
	complete : function () {
    ReadItmExcel(filePath);
	}
	});
  
}
//��ȡExcel����
function ReadItmExcel(filePath)
{
	
   //��ȡexcel
   var arr;
   try 
   {
	 arr= websys_ReadExcel(filePath);
	 $.messager.progress("close");
	}
   catch(ex)
   {
	  $.messager.progress("close");
	  $.messager.alert('��ʾ', '����websys_ReadExcel�쳣��'+ex.message,'error')
	  return ;
	}
	 var rowCnt=arr.length
	 $.messager.progress({
            title: "��ʾ",
            msg: '����ע�������',
            text: '�����У�����'+(rowCnt-1)+'��'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
       ItmArrSave(arr);
	}
	});
}

//���ݱ���
function ItmArrSave(arr)
{
	
	//��ȡ��������
	var ErrMsg = "";     //��������
    var errRowNums = 0;  //��������
    var sucRowNums = 0;  //����ɹ�������
	var rowCnt=arr.length
	var CLASSNAME="";
	var METHODNAME="";
	var InterfaceCode="";
	var Addchild=false;
	 try{
 		 for (i = 1; i < rowCnt; i++) 
		 {
			var rowArr=arr[i]
			var j=0; 
			var ExptObj = {};
			ExptObj["CLASSNAME"] =rowArr[j++];
			ExptObj["METHODNAME"] =rowArr[j++];
			ExptObj["METHODTYP"] =rowArr[j++];
			ExptObj["METHODDESC"] =rowArr[j++];
			ExptObj["DEMO"] =rowArr[j++];
			ExptObj["EFFTFLAG"] =rowArr[j++];
			ExptObj["MULTSPLIT"] =rowArr[j++];
			ExptObj["DATASPLIT"] =rowArr[j++];
			ExptObj["OUTPUTTYPE"] =rowArr[j++];
			ExptObj["CRTER"] =rowArr[j++];
			ExptObj["CRTEDATE"] =rowArr[j++];
			ExptObj["CRTETIME"] =rowArr[j++];
			ExptObj["UPDTID"] =rowArr[j++];
			ExptObj["UPDTDATE"] =rowArr[j++];
			ExptObj["UPDTTIME"] =rowArr[j++];
			ExptObj["InterfaceCode"] =rowArr[j++];
			ExptObj["InterfaceType"] =rowArr[j++];
			ExptObj["UseType"] =rowArr[j++];
			ExptObj["ProductLine"] =rowArr[j++];
			ExptObj["ProductTeam"] =rowArr[j++];
			ExptObj["LogFlag"] =rowArr[j++];
			ExptObj["PortConfig"] =rowArr[j++];
			ExptObj["BusinessType"] =rowArr[j++];
			ExptObj["FunPoint"]= rowArr[j++];
			ExptObj["Status"]= rowArr[j++];
			var saveinfo = JSON.stringify(ExptObj);
			if(ExptObj["InterfaceCode"]!="")
			{
				saveinfo=tkMakeServerCall('INSU.MI.ClassMethodCom',"Save",saveinfo,session['LOGON.USERID'])
	            if (saveinfo == null || saveinfo == undefined) saveinfo = -1
	            if (saveinfo >= 0) {
	                sucRowNums = sucRowNums + 1;
	                Addchild=true;
					CLASSNAME=ExptObj["CLASSNAME"];
					METHODNAME=ExptObj["METHODNAME"];
					InterfaceCode=ExptObj["InterfaceCode"];
	            } else {
	                errRowNums = errRowNums + 1;
	                if (ErrMsg == "") {
	                    ErrMsg = i+":"+savecode;
	                } else {
	                    ErrMsg = ErrMsg + "<br>��������" + ExptObj["InterfaceCode"] +"����ʧ��:"+savecode+"<br>";
	                }
	                Addchild=false;
	            }
			}
			else if(Addchild)
			{
				var input=CLASSNAME+"|"+METHODNAME+"|||"+InterfaceCode;
				var jsondata = $.m({
	        		ClassName: "INSU.MI.ClassMethodCom",
					QueryName: "QueryClassMethod",
					ParamInput:input,
					rows:999999
	    		}, false);
	    		var jsonobj =eval("("+jsondata+")");
	    		var obj = jsonobj.rows[0];//ͨ��rowidֻ�ܲ����һ������
	    		j++;
				ExptObj["PARID"] =obj.ROWID;
				ExptObj["SEQ"] =rowArr[j++];
				ExptObj["ARGCODE"] =rowArr[j++];
				ExptObj["ARGNAME"] =rowArr[j++];
				ExptObj["ARGTYPE"] =rowArr[j++];
				ExptObj["PARNODETYPE"] =rowArr[j++];
				ExptObj["MAXLENG"] =rowArr[j++];
				ExptObj["CRTER"] =rowArr[j++];
				ExptObj["CRTEDATE"] =rowArr[j++];
				ExptObj["CRTETIME"] =rowArr[j++];
				ExptObj["UPDTID"] =rowArr[j++];
				ExptObj["UPDTDATE"] =rowArr[j++];
				ExptObj["UPDTTIME"] =rowArr[j++];
				ExptObj["MustFlag"] =rowArr[j++];
				ExptObj["Memo"] =rowArr[j++];
				ExptObj["ParamType"] =rowArr[j++];
				ExptObj["ParamFormatter"] =rowArr[j++];
				saveinfo = JSON.stringify(ExptObj);
				var savecode=tkMakeServerCall('INSU.MI.ClassMethodArgsCom',"Save",saveinfo,session['LOGON.USERID'])
			}
		 }
		  if (ErrMsg == "") {
                    $.messager.progress("close");
                    $.messager.alert('��ʾ', '������ȷ�������');
                } else {
                   $.messager.progress("close");
                     var tmpErrMsg = "����ɹ���"+sucRowNums +"����ʧ�ܣ�"+errRowNums+"����";
                     tmpErrMsg = tmpErrMsg + "<br>ʧ�������кţ�<br>"+ ErrMsg;
                    $.messager.alert('��ʾ', tmpErrMsg,'info');
                }
		      return ; 
		 }
		 catch(ex)
		 {
			  $.messager.progress("close");
			  $.messager.alert('��ʾ', '�������ݺ˲��ֵ������쳣��'+ex.message,'error')
	          return ;
	      }
	
}
//���ݺ˲��ֵ䵼��
function Export()
{
   try
   {
 		$.messager.progress({
	         title: "��ʾ",
			 msg: '���ڵ�������ע�����',
			 text: '������....'
			   });
		$cm({
			ResultSetType:"ExcelPlugin",  
			ExcelName:"����ע�����",		  
			PageName:"ExportALLData",      
			ClassName:"INSU.MI.ClassMethodCom",
			QueryName:"ExportData",
		},function(){
			  setTimeout('$.messager.progress("close");', 3 * 1000);	
		}); 
		
   } catch(e) {
	   $.messager.alert("����",e.message);
	   $.messager.progress('close');
   }; 
}
