/**
 * FileName: interfacemgrdetail.js
 * Author: lizhi
 * Date: 2022-06-6
 * Description: �ӿڹ���
 */
var GV = {
	CLASSNAME:"INSU.MI.ClassMethodArgsCom"	 
}
var MethodNameCall=true;//�Ƿ���ú�̨��ȡ������
var id="";  //������rowid
var Status="0"; //���״̬
var demotxt="";
var outputListarr=[];//Ҫɾ���ĳ��μ�¼rowid
var inputListarr=[];//Ҫɾ����μ�¼rowid
$(function() {
	$("#methodDataSaveBtn").click(methodDataSave); //���水ť���¼�
	$("#HPath").val("/");
	var Rq = INSUGetRequest();
	var classname = Rq["classname"];
	var methodname = Rq["methodname"];
	var InterfaceCode=Rq["InterfaceCode"];
	Status=Rq["Status"];
	Init_MethodName();//��ʼ��������������
    InitmethodClassName();//��ʼ���෽������
    InitProductLine(); //��ʼ����Ʒ�����������
	init_ProductLinkGroup();//��ʼ����Ʒ��
	init_outputListTab(); //��ʼ������datagrid
	InitInputDescDialog();//��ʼ�������ϸ����
	InitDemoDialog();//��ʼ������˵��
	init_inputListTab(); //��ʼ�����datagrid
 	Init_BusinessType();//��ʼ��ҵ������������
	Init_FunPoint();//��ʼ�����ܵ� 
    InitParamsStyle("HHeadParmams");//��ʼ��head����
    ChagemethodInvokType();
    var PageNoteCont="";
	if(methodname!=''){
		//�ӿڱ༭ҳ�����ò��ɱ༭
		MethodNameCall=true
 		$("#methodClassName").combobox({disabled: true});
 		$("#methodName").combobox({disabled: true}); 
/* 			$("#ProductLine").combobox({disabled: true});
		$("#interfaceType").combobox({disabled: true});
		$("#methodInvokType").combobox({disabled: true});
		
		$("#interfaceName").attr("disabled",true);
		$("#interfaceCode").attr("disabled",true); */
		GetLoadDataDialog(classname,methodname,InterfaceCode);
		/* PageNoteCont="<ul class='tip_class'><li style='font-weight:bold'>�ӿ���ϸ�༭ʹ��˵��</li>" +
		'<li>1�����:���෽���޸���κ�,�ڱ༭�������ʾ�����仯��ȷ�������ֱ�ӱ��漴�ɣ�' +
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>2����������ϸ��ť:ά������ֶεĸ�ʽ��ģ��,��������Ϊ����,Ĭ��/xml/json��¼����ڵ��Խ��潫����ʾ�ֶεĿ��ӻ����ʽ��</li>" + 
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>3������˵��:�����HIS����HTTP/SOAP�ķ����Զ����뺯��ע�ͣ�HTTP/SOAP������Ҫ�ֶ�����,���ֶ��޸�</li>" + 
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>';	 */
		PageNoteCont="<ul class='tip_class'>" +
		'<li>1����Σ����෽���޸���κ��ڱ༭�������ʾ�����仯��ȷ�������ֱ�ӱ��漴�ɡ�</li>' +
		"<li>2���������갴ť��ά������ֶεĸ�ʽ��ģ�壬������Ϊ���֣�Ĭ��/xml/json��¼����ڵ��Խ��潫����ʾ�ֶο��ӻ����ʽ����</li>" + 
		"<li>3������˵���������HIS����HTTP/SOAP�ķ����Զ����뺯��ע�ͣ�HTTP/SOAP������Ҫ�ֶ����룬���ֶ��޸ġ�</li></ul>";	
	}
	else
	{
		MethodNameCall=true;
		PageNoteCont="<ul class='tip_class'><li style='font-weight:bold'>�ӿ���ϸ����ʹ��˵��</li>" +
		'<li>1����������:�����ʾ�������񹩸����������������ã����ñ�ʾ������������ߵ���������</li>' +
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>2���ӿڴ�����ɹ���:��Ʒ��.�ӿ�����.��������.�ӿ����ơ��ӿڴ������ɺ�������и���,Ҫ��Ψһ��</li>" +
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>3����ز�Ʒ�飬��ʾ����ӿ��Ǹ�˭�õġ�</li>"+
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>'+
		'<li>4�����:��������������ƺ��෽�����Զ�����,�����HTTP����,�����Ҫ�ֶ����롣' +
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>5����������ϸ��ť:ά������ֶεĸ�ʽ��ģ��,��������Ϊ����,Ĭ��/xml/json��¼����ڵ��Խ��潫����ʾ�ֶεĿ��ӻ����ʽ��</li>" + 
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>6������˵��:�����HIS����HTTP/SOAP�ķ����Զ����뺯��ע�ͣ�HTTP/SOAP������Ҫ�ֶ�����,���ֶ��޸�</li>" + 
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>';	
	}
		//�������س��¼�
	$('#interfaceName').keydown(function(e){
		var key = websys_getKey(e);
		if (key == 13) {
			ChangeinterfaceCode()}	
	});
	$("#interfaceName").bind("blur",function(){
	  ChangeinterfaceCode();
	});
	$("#interfaceCode").bind("blur",function(){
		if(CheckinterfaceCode($("#interfaceCode").val())){
			$.messager.alert('��ʾ', "�ӿڴ����Ѵ���,���޸�!", "info", function() {
	            $('#interfaceCode').focus();
	        });  
		}
	});
	$('#methodClassName').keydown(function(e){
		var key = websys_getKey(e);
		if (key == 13) {
			Init_MethodName();}	
	});
	top.$("#PageNote").popover({
		trigger:'hover',
		content:PageNoteCont,
		placement:"bottom"
	});
	$("#copy").popover({
		trigger:'hover',
		content:"���ƽӿڴ���",
		placement:"bottom"
	});
});
//����˵������
function InitmethodNote(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>˫������˵���ı���,������ʾ����˵������!</li>" ;
	$("#methodNote").popover({
		trigger:'hover',
		content:_content
	});
	$("#methodNote").popover('show');
}
function HPathChange(){
	var HPathStr=getValueById("HPath")
	if(HPathStr.charAt(0)!="/")
	{
	  $("#HPath").val("/"+getValueById("HPath")); //Ĭ��/��ͷ
	}	
}
function Init_BusinessType(){
	$HUI.combobox("#BusinessType", {
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
		},
		
	}); 
}

function Init_FunPoint(){
	$HUI.combobox("#FunPoint", {
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
	},
	
	}); 
}
 
function InitParamsStyle(id) {
    var target = $('#' + id)[0];
    initKeyValueBox(target, {
        panelWidth: 650,
        panelHeight: 250,
        parseValue: parseValue,
        formatValue: formatValue,
        descEditor: 'text'
    });

    function formatValue(o) {
        var arr = [];
        $.each(o, function() {
            if (this.key != "") {
                arr.push({ key: this.key, value: this.value, desc: this.desc });
            }
        })
        return JSON.stringify(arr);
    }

    function parseValue(str) {
        try {
            var arr = $.parseJSON(str);
        } catch (e) {
            var arr = [];
        }
        var all = [];
        $.each(arr, function() {
            all.push({ key: this.key, value: this.value, desc: this.desc, custom: true })
        })
        if (all.length == 0) all.push({ key: '', desc: '', value: '', custom: true });
        all.push({ key: '', desc: '', value: '', custom: true });
        return all;
    }
}
//���Ƽ��а�
function CopyInterfaceCode()
{        
     try 
     {
         $('#interfaceCode').select();
	     var state = document.execCommand('copy'); 
	 } 
	 catch (err) 
	 { 
	 	var state = false; 
	 }
     if (state) {//���Ƴɹ�
	     $.messager.popover({ msg: '���Ƴɹ�', type: 'success', timeout: 1000 });
    	
    } 
    else {//����ʧ��
	    $.messager.popover({ msg: '����ʧ��', type: 'faild', timeout: 1000 });	
    }
 }
//����ָ����ϸ����
function GetLoadDataDialog(classname,methodname,InterfaceCode){
	inputListarr=[];
	outputListarr=[];
	var input=classname+"|"+methodname+"|||"+InterfaceCode;
	$.cm({
		ClassName: "INSU.MI.ClassMethodCom",
		QueryName: "QueryClassMethod",
		ParamInput:input,
		rows:999999
	},function(jsonData){	
		var obj = jsonData.rows[0];//ͨ��rowidֻ�ܲ����һ������
			id=obj.ROWID;
            $('#interfaceCode').val(obj.InterfaceCode);
            var methodDesc = obj.METHODDESC;
            $('#interfaceName').val(methodDesc);
            setValueById("methodClassName",obj.CLASSNAME);
            $('#Active').combobox('select', obj.EFFTFLAG);
            $('#methodType').val(obj.METHODTYP);
            $('#interfaceType').combobox('select', obj.InterfaceType);
            $('#LogFlag').checkbox('setValue', obj.LogFlag == "Y" ? true : false);
            $('#MULTSPLIT').val(obj.MULTSPLIT);
            $('#DATASPLIT').val(obj.DATASPLIT);
            $('#methodName').combobox('select', obj.METHODNAME);
           	$('#ProductLine').combobox('select', obj.ProductLine);
           	setValueById('FunPoint',obj.FunPoint);
           	setValueById('BusinessType',obj.BusinessType);
/*            	$('#FunPoint').combobox('select', obj.FunPoint);
           	$('#BusinessType').combobox('select', obj.BusinessType); */
           	var ProductLinkGroupArr=obj.ProductTeam.split(",");
	        $('#ProductLinkGroup').combobox('setValues', ProductLinkGroupArr);
            demotxt=obj.DEMO;
            $('#methodNoteTxt').val(demotxt);
            $('#methodInvokType').combobox('select', obj.UseType);
            loadInputDetail(obj.ROWID);
            loadOutputDetail(obj.ROWID);
            if(obj.METHODTYP!="HIS"&&obj.PortConfig!="")
            {
	        	init_inputHttpLable(obj.PortConfig);    
	        }
	});
}
function httpMethodType() {
    var Type = $("#HMethodType").combobox("getValue");
    if (Type != "POST") {
        $('#HContentType').combobox('setValue', 'form-urlencoded').combobox('disable').combobox('isValid');
    } else {
        $('#HContentType').combobox('enable');
    }
}
function InterfaceType() {
    setValueById("methodName","");
    ChagemethodInvokType();
}

function Init_MethodName()
{
 	$("#methodName").combobox({
	panelHeight: 150,
	url:$URL,
    valueField:'METHODNAME',
    textField:'METHODNAME',
    mode:'local',
    defaultFilter:'4',
	onBeforeLoad:function(param){
		if(getValueById("methodClassName").replace(/\ /g, "")=="")
		{return}
		param.q="";
		param.ClassName = "INSU.MI.ClassMethodCom";
		param.QueryName= "QueryMethod";
		param.ResultSetType = 'array';
		param.clsName=getValueById("methodClassName").replace(/\ /g, "");
	},
	onLoadSuccess: function(data) {
		if(getValueById("methodClassName").replace(/\ /g, "")!=""&&data.length==0)
		{
			setValueById("methodName","�෽��������")
		}
	},
	onChange: function(newValue, oldValue) {
		AutoInputTxt(getValueById("methodClassName").replace(/\ /g, ""),newValue);
		AutoOutputTxt(getValueById("methodClassName").replace(/\ /g, ""),newValue);
	}
	}); 
}
//�ӿ�����ʧȥ������߻س��¼�
function ChangeinterfaceCode()
{
	var ProductLine=$("#ProductLine").combobox('getValue');
	var interfaceType=$("#interfaceType").combobox('getValue');
	var methodInvokType=$("#methodInvokType").combobox('getValue');
	var interfaceName=$('#interfaceName').val().replace(/\ /g, "");
	interfaceName = $.m({
                ClassName: "web.DHCINSUPort",
                MethodName: "GetCNCODE",
                HANZIS: interfaceName,
                FLAG:"4",
            }, false);
    interfaceName=DHCP_replaceAll(interfaceName,/[^0-9a-z]/gi,"");
	var interfaceCode=ProductLine+"."+interfaceType+"."+methodInvokType+"."+interfaceName;
	if(CheckinterfaceCode(interfaceCode)){
		$.messager.alert('��ʾ', "�ӿڴ����Ѵ���,���޸�!", "info", function() {
            $('#interfaceCode').focus();
        });
	}
	$('#interfaceCode').val(interfaceCode);
}
function CheckinterfaceCode(interfaceCode){ //����Ƿ��ظ�
	var interfaceRowid=$.m({
	    			ClassName:"INSU.MI.ClassMethodCom",
					MethodName:"GetInfoByInterfaceCode",
					interfaceCode:interfaceCode,
					index:"1"},false);
	if((id==''&&interfaceRowid!="")||(id!=''&&id!=interfaceRowid&&interfaceRowid!=""))//idΪ�մ�������,������������ͬ�Ľӿڴ���
    {
        return true;
	}
	return false;
}
function ChagemethodInvokType()
{
	ChangeinterfaceCode();
	var methodInvokType=$("#methodInvokType").combobox('getValue');
	var InterfaceType = $('#interfaceType').combobox('getValue');
	$('#inputListTab').datagrid('loadData',{total:0,rows:[]});
	$("#interfaceDetail").css("overflow","hidden"); //����Y�������
	if(InterfaceType=="HIS")
	{
		$(".HisServer").show();
		$(".SOAPService,.httpService").hide();
		$('#inputListTab').datagrid('hideColumn', "action");
		var ee = $('#inputListTab').datagrid('getColumnOption', 'ARGCODE');
		ee.editor={}	
	}
	else
	{
		if(methodInvokType=="S") //�������ص�ַ��
		{
			$(".HisServer").show();
			$(".SOAPService,.httpService").hide();
			$('#inputListTab').datagrid('hideColumn', "action");
			var ee = $('#inputListTab').datagrid('getColumnOption', 'ARGCODE');
			ee.editor={}
		}
		if(methodInvokType=="C") //���ã���ʾ��ַ��
		{
			$("#interfaceDetail").css("overflow-y","scroll");//��ʾY�������
			if(InterfaceType=="HTTP")
			{
				$(".httpService,.SOAPService").show();	
			}
			else
			{
				$(".httpService").hide();
				$(".SOAPService").show();	
			}
			$(".HisServer").hide();
			$('#inputListTab').datagrid('showColumn', "action");
			var ee = $('#inputListTab').datagrid('getColumnOption', 'ARGCODE');
			ee.editor="text";
		}
	}
}
function init_outputListTab(){
	var TitLnk = '<a href="#" onclick="insertoutputrow()"><img style="margin:6px 3px 0px 3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>';//������λ��
    $('#outputListTab').datagrid({
	    rownumbers:false,
		fit: true,
		striped:true,
		fitColumns:true,
		singleSelect: true,
		columns:[            
		[
			{ field: 'ROWID', title: '����id', width: 120,hidden:true,},
            { field: 'PARID', title: '����id', width: 120,hidden:true,
                	formatter: function(value, rowData) {
                         return id;
                    }, 
            },
            { field: 'SEQ', title: '���', width: 120,hidden:true,},//������Ϊ���޸�˳��
	    	{ field:'ARGTYPE',title:'��������',width:120,
                     formatter: function(value, rowData) {
                        return value;
                    },
                    editor: {
                        id: "lookTable",
                        type: 'combobox',
                        options: {
                            editable: false,
                            url: $URL,
							editable: false,
							valueField: "DicCode",
							textField: 'DicDesc',
							onBeforeLoad: function (param) {
								var jsonData=$.cm({
								ClassName:"BILL.CFG.COM.DictionaryCtl",
								QueryName:"QueryDicDataInfo",
								Type:"ARGTYPE",
								ResultSetType:'array'},false);
								jsonData.sort(objectSort("id")); 
								$(this).combobox('loadData', jsonData);
								return false;
							}
                        }
                    } 
                },
                { field: 'ARGCODE', title: '��������', width: 120, editor: 'text' },
                { field: 'ARGNAME', title: '��������', width: 120, editor: 'text' },
/*                 {field:'MustFlag',title:'�Ƿ����',width:70,align:'center',
					editor:{
						type:'icheckbox',
						options:{
							on: 'Y',
							off: 'N'
						}
					}
				}, */
                { field:'Memo',title:'��ע',width:180,editor: 'text' },
                { field:'action',title:TitLnk,width:40,align:'center',
                    formatter: function(value, row, index) {
                        var d = "<a href='#' onclick='deleteoutputrow(this)'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";//������λ��
                        return d;
                    }
                }
            ]],
		pageSize: 90,
		pagination:false,
        onBeforeEdit: function(index, row) {
//            row.editing = true;
        },
        onAfterEdit: function(index, row) {

        },
        onCancelEdit: function(index, row) {
        },
        onLoadSuccess: function(data) {
            //bindDescTip();
            var data = $('#outputListTab').datagrid('getData');
            var total = data.total;
            for (i = 0; i < total; i++) {
                $('#outputListTab').datagrid('beginEdit', i);
            }
        }
	});
}
function objectSort(property) {
  return function (Obj1,Obj2) {
        return Obj1[property]-Obj2[property]
  }
}
//http����������ֶ�����
function init_inputListTab(){//init_inputHttpListTab(){
	var TitLnk = '<a href="#" onclick="insertinputrow()"><img style="margin:6px 3px 0px 3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>';//������λ��
	$HUI.datagrid("#inputListTab",{
    rownumbers:false,
	fit: true,
	striped:true,
	fitColumns:true,
	singleSelect: true,
	columns:[            [
    	{ field:'ARGTYPE',title:'��������',width:120,
                     formatter: function(value, rowData) {
                        return value;
                    },
                    editor: {
                        id: "lookTable",
                        type: 'combobox',
                        options: {
                            editable: false,
                            url: $URL,
							editable: false,
							valueField: "DicCode",
							textField: 'DicDesc',
							onBeforeLoad: function (param) {
								var jsonData=$.cm({
								ClassName:"BILL.CFG.COM.DictionaryCtl",
								QueryName:"QueryDicDataInfo",
								Type:"ARGTYPE",
								ResultSetType:'array'},false);
								jsonData.sort(objectSort("id")); 
								$(this).combobox('loadData', jsonData);
								return false;
							}
                        }
                    } 
                },
            { field: 'ROWID', title: 'ROWid', width: 120,hidden:true,},
            { field: 'PARID', title: '����id', width: 120,hidden:true,},
            { field: 'ARGCODE', title: '��������', width: 120,editor: 'text'},
            { field: 'ARGNAME', title: '��������', width: 120,editor: 'text' },
			{field:'MustFlag',title:'�Ƿ����',width:70,align:'center',
				editor:{
					type:'icheckbox',
					options:{
						on: 'Y',
						off: 'N'
					}
				}
			},
            { field:'Memo',title:'����Ĭ��ֵ',width:240,editor: 'text' },
            { field:'ParamFormatter',title:'',width:40,align:'center',hidden:true},
            { field:'ParamFormatterbtn',title:'',width:40,align:'center',
            	formatter: function(value, row, index) {
                        return '<a class="editcls" onclick="showinputdetail(\'' + index + '\')">��</a>';
                    }
            },
            { field:'action',title:TitLnk,width:40,align:'center',
                formatter: function(value, row, index) {
                    var d = "<a href='#' onclick='deleteinputrow(this)'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";//������λ��
                    return d;
                }
            }
        ]],
	pageSize: 90,
	pagination:false,
    onBeforeEdit: function(index, row) {
//            row.editing = true;
    },
	    onAfterEdit: function(index, row) {
	    },
	    onCancelEdit: function(index, row) {
	        //$('#inputListTab').datagrid('deleteRow', index)

	    },
	    onLoadSuccess: function(data) {
	        var data = $('#inputListTab').datagrid('getData');
	        var total = data.total;
	        for (i = 0; i < total; i++) {
	            $('#inputListTab').datagrid('beginEdit', i);
	        }
	    }
	});	
}
function init_inputHttpLable(InputJson){
	var obj=JSON.parse(InputJson);
	$("#HReturnStr").val(obj.HReturnStr);
	$("#HTimeout").val(obj.HTimeout);
	$("#HTimeOutNum").val(obj.HTimeOutNum);
	$('#HAutoSwitch').checkbox('setValue', (obj.HAutoSwitch == "Y") ? true : false);
	$("#HServer").val(obj.HServer);
	$("#HPort").val(obj.HPort);
	$('#HDomainFlag').checkbox('setValue', obj.HDomainFlag == "Y" ? true : false);
	$("#HPath").val(obj.HPath);
	$("#HHeadParmams").val(obj.HHeaderJson);
	$('#HSSLCheckServerIdentity').checkbox('setValue', obj.HSSLCheckServerIdentity == "Y" ? true : false);
	$('#HHttps').checkbox('setValue', obj.HHttps == "Y" ? true : false);
    $('#HMethodType').combobox('setValue', obj.HMethodType);
    $('#HContentType').combobox('setValue', obj.HContentType);
	$("#HSSLConfiguration").val(obj.HSSLConfiguration);
}
function InitInputDescDialog() {
    $('#inputDescDialog').dialog({
        autoOpen: false,
        title: '������ʽ��',
        iconCls: 'icon-w-edit',
        width: 541.5,
        height: 348,
        closed: true,
        cache: false,
        href: '',
        modal: true,
        resizable: true,
        isTopZindex:true,
        buttons: [
         {
            text: 'ȷ��',
            iconCls: 'icon-w-save',
            handler: function() {
            var tVal = $('#inputDescDialog textarea').val();
            var rows = $('#inputListTab').datagrid('getSelected');
            var index = $('#inputListTab').datagrid('getRowIndex', rows);
            $('#inputListTab').datagrid('endEdit', index);
        	var datatype=getValueById("datatype");
        	rows = $('#inputListTab').datagrid('getSelected');
			if(datatype=="xml")
			{
				if(checkxml(tVal))
				{
					rows["ParamType"]=getValueById("datatype");
				}
				else
				{
					$.messager.alert('��ʾ', "xml��ʽ����!", "info", function() {
		        	});
		        	return
				}
			}
			if(datatype=="json")
			{
/* 				if(checkjson(tVal))
				{ */
					rows["ParamType"]=getValueById("datatype");
					//tVal=JSON.stringify(eval("("+tVal+")"))����ѹ�����ܣ�����֮���ڸ�ʽ����
					//tVal=formatJson(tVal);
/* 				}
				else
				{
					$.messager.alert('��ʾ', "json��ʽ����!", "info", function() {
		        	});
		        	return
				} */
			}
	        if(datatype=="separator")
	        {
		        rows["ParamType"]=getValueById("datatypeinput");
		    }
		    if(datatype=="")
	        {
		        rows["ParamType"]="";
		    }
            rows["ParamFormatter"]=replaceTextarea2(tVal);
			$('#inputListTab').datagrid('updateRow',{
			    index: index,
			    row:rows
			});
            $('#inputListTab').datagrid('beginEdit', index);
            $('#inputDescDialog').dialog('close');
            }
        },
        {
            text: 'ȡ��',
            iconCls: 'icon-w-close',
            handler: function() {
                $('#inputDescDialog').dialog('close');
            }
        }]
    });
}
function InitDemoDialog() {
    $('#DemoDialog').dialog({
        autoOpen: false,
        title: '����˵��',
        iconCls: 'icon-w-edit',
        width: 700,
        height: 496,
        closed: true,
        cache: false,
        href: '',
        modal: true,
        resizable: true,
        isTopZindex:true,
        buttons: [
         {
            text: 'ȷ��',
            iconCls: 'icon-w-save',
            handler: function() {
            var tVal = $('#DemoDialog textarea').val();
            $('#methodNoteTxt').val(tVal);
            $('#DemoDialog').dialog('close');
            }
        },
        {
            text: 'ȡ��',
            iconCls: 'icon-w-close',
            handler: function() {
                $('#DemoDialog').dialog('close');
            }
        }]
    });
}
function DemoDialogShow(){
	$('#DemoDialog').dialog("open");
	var text=$('#methodNoteTxt').val();
	$('#DemoDialog textarea').val(text);
	$('#DemoDialog textarea').focus();
}
//��ʾ����ֶ���ϸ����
function showinputdetail(index) {
	$('#inputListTab').datagrid('selectRow',index);
	var data = $('#inputListTab').datagrid('getData');
	var tVal=data.rows[index].ParamFormatter
	/* tVal=replaceTextarea2(tVal); */
	if(data.rows[index].ParamType=="json"||data.rows[index].ParamType=="xml")
	{
		$('#datatype').combobox('select', data.rows[index].ParamType);
	}
	else if(typeof(data.rows[index].ParamType)!="undefined"&&data.rows[index].ParamType!="")//�ָ���ֱ�Ӵ�ķָ���
	{
		$('#datatype').combobox('select', "separator");
		$('#datatypeinput').val(data.rows[index].ParamType);
	}
	else
	{
		$('#datatype').combobox('select', "");
		$('#datatypeinput').val(data.rows[index].ParamType);
	}
    $('#inputDescDialog textarea').val(tVal);
    $('#inputDescDialog').dialog("open");
    $('#inputDescDialog textarea').focus();
}
function replaceTextarea1(str) {
    var reg = new RegExp("\n", "g");
    var reg1 = new RegExp(" ", "g");
    str = str.replace(reg, "<br>");
    str = str.replace(reg1, "<p>");
    return str;
}
function replaceTextarea2(str) {
    var reg = new RegExp("<br>", "g");
    var reg1 = new RegExp("<p>", "g");
    str = str.replace(reg, "\n");
    str = str.replace(reg1, " ");
    return str;
}
//��������������ֿ�ֵ
function AutoInputTxt(classname,methodname)
{
	var ExtJsonStr = $.m({
		ClassName:"INSU.MI.ClassMethodArgsCom",
		MethodName: "GetClsMethodParam",
		clsName:classname,
		methodName:methodname
	}, false);
	//��֯����
	if(ExtJsonStr.split("^")[0]!="-1")
	{
		var methodType=ExtJsonStr.split("^")[1].split("|")[0];
		$("#methodType").val(methodType);
		var jsonstrarr=ExtJsonStr.split("|")[1].split(",");
		if(typeof(ExtJsonStr.split("|")[2])!="undefined")
		{
			demotxt=ExtJsonStr.split("|")[2];
			$('#methodNoteTxt').val(demotxt);
		}
		var jsonarr={total:0,rows:[],curPage: 1};
		for (i=0;i<jsonstrarr.length;i++)
		{
			var jsonobj={};
			if(jsonstrarr[0]==""&&jsonstrarr.length==1)
			{
			 break;	
			}
			jsonobj["ARGTYPE"]=jsonstrarr[i].split("=")[0].split("%")[1];
			if(jsonobj["ARGTYPE"] == ""||typeof(jsonobj["ARGTYPE"]) == "undefined"){
				 jsonobj["ARGTYPE"] = "STRING";
			 }
			 else{
					jsonobj["ARGTYPE"] = jsonobj["ARGTYPE"].toUpperCase();
			}
			jsonobj["MustFlag"]="Y";
			jsonobj["ARGCODE"]=jsonstrarr[i].split(":")[0].split("=")[0];//
			if(jsonobj["ARGCODE"].indexOf("&")>-1)
			{
				jsonobj["ARGCODE"]=jsonobj["ARGCODE"].split("&")[1];//
			}
			jsonarr.rows.push(jsonobj);
		} 
		jsonarr.total=jsonarr.rows.length;
		if(jsonstrarr[0]==""&&jsonstrarr.length==1)
	    {
	    	jsonarr.total="0";
	    }
		jsonarr.curPage=parseInt(jsonarr.total/90)+1;
		$('#inputListTab').datagrid('loadData',jsonarr);
	}
	else
	{
		$("#methodType").val("");
		$('#methodNoteTxt').val("");
		var jsonarr={total:0,rows:[],curPage: 1};
		$('#inputListTab').datagrid('loadData',jsonarr);
	}
}

function AutoOutputTxt(classname,methodname)
{
	var jsonData={total:0,rows:[],curPage: 1};
	$('#outputListTab').datagrid('loadData',jsonData);
	
}

//������ֿ�����
function loadInputDetail(rowId) {
	var classname =getValueById('methodClassName');
	var methodname =  getValueById('methodName');
	var jsonData=$.cm({
		ClassName:GV.CLASSNAME,
		QueryName: "QueryClassMethodArgs",
		ParamInput:rowId+"||||"+"input", //��ȡ��β���
		rows:999999
		},
		 false);	
	$('#inputListTab').datagrid('loadData',jsonData);
	var Result = $.m({
        ClassName: 'INSU.MI.ClassMethodArgsCom',
        MethodName: 'CheckParam',
        ParentId: rowId,
        clsName:classname,
        methodName:methodname
    }, false);
    if(Result.split("|")[0]=="Y") //��ά���Ĳ�����һ�£���ʾά�������뷽��ʵ�ʲ����ԱȺ���Ⱦ
    {
	    $.messager.alert('��ʾ', "���������ά��������һ�£������±���!", "info", function() {
        });
	    if(Result.split("|")[1].split("#")[0]!="")
	    {
			//��ȡ����ʵ�ʲ���
			var MethodJsonStr = $.m({
				ClassName:"INSU.MI.ClassMethodArgsCom",
				MethodName: "GetClsMethodParam",
				clsName:classname,
				methodName:methodname
			}, false);
			var methodType=MethodJsonStr.split("^")[1].split("|")[0];
			var jsonstrarr=MethodJsonStr.split("|")[1].split(",");
			for (i=0;i<jsonstrarr.length;i++)
			{
				var jsonobj={};
				if(jsonstrarr[0]==""&&jsonstrarr.length==1)
				{
				 break;	
				}
				jsonobj["ARGTYPE"]=jsonstrarr[i].split("=")[0].split("%")[1];
				if(jsonobj["ARGTYPE"] == ""||typeof(jsonobj["ARGTYPE"]) == "undefined"){
					 jsonobj["ARGTYPE"] = "STRING";
				 }
				else{
					jsonobj["ARGTYPE"] = jsonobj["ARGTYPE"].toUpperCase();
				}
				jsonobj["MustFlag"]="Y";
				jsonobj["ARGCODE"]=jsonstrarr[i].split(":")[0];//
				jsonobj["ARGCODE"]=jsonobj["ARGCODE"].split("=")[0]
				if(Result.split("|")[1].split("#")[0].split("^").indexOf(jsonobj["ARGCODE"])>-1)
				{
					if(jsonobj["ARGCODE"].indexOf("&")>-1)
					{
						jsonobj["ARGCODE"]=jsonobj["ARGCODE"].split("&")[1];//
					}
					var row={"ARGTYPE":jsonobj["ARGTYPE"],"ARGCODE":jsonobj["ARGCODE"],"MustFlag":jsonobj["MustFlag"]};
					$('#inputListTab').datagrid("insertRow",{"row":row,"index":i});
					$('#inputListTab').datagrid("beginEdit",i);
					$('#inputListTab').datagrid("highlightRow",i);
					$(GetDataGrid.GetGridInfo(0,"tr",i,"ARGCODE")).css("background-color","green");	
				}
			}
		}
		if(Result.split("|")[1].split("#")[1]!="")
		{
			var griddata=$('#inputListTab').datagrid('getRows');
			for(i=0;i<griddata.length;i++)
			{
				if(Result.split("|")[1].split("#")[1].split("^").indexOf(griddata[i]['ARGCODE'])>-1)
				{
					var indexrow=$('#inputListTab').datagrid("getRowIndex",griddata[i]);
					//�Զ���¼�޸ģ������ֶ�
					inputListarr.push($('#inputListTab').datagrid("getRows")[indexrow].ROWID);
					//$(GetDataGrid.GetGridInfo(0,"td",indexrow,"action")).append('<div style="text-align:center;" class="datagrid-cell datagrid-cell-c3-action"><a href="#" onclick="deleteinputrow(this)"><img src="../scripts/dhcpha/jQuery/themes/icons/edit_remove.png" border="0/"></a></div>');
					$(GetDataGrid.GetGridInfo(0,"tr",indexrow,"ARGCODE")).css("background-color","red");
				}
			}
		}
		
	}
}
function getRowIndex(target){
	var tr = $(target).closest('tr.datagrid-row');
	return parseInt(tr.attr('datagrid-row-index'));
}
function deleteinputrow(target){
	var index=getRowIndex(target);
	$("#inputListTab").datagrid('selectRow', index);
    var Obj = $("#inputListTab").datagrid('getSelected');
    if (Obj != null) {
       if(typeof(Obj.ROWID)!="undefined"&&Obj.ROWID!="")
       {
	   		inputListarr.push(Obj.ROWID);    
	   }
    }
	$('#inputListTab').datagrid('deleteRow', index);
}
function deleteoutputrow(target){
	var index=getRowIndex(target);
	$("#outputListTab").datagrid('selectRow', index);
    var Obj = $("#outputListTab").datagrid('getSelected');
    if (Obj != null) {
       if(typeof(Obj.ROWID)!="undefined"&&Obj.ROWID!="")
       {
	   		outputListarr.push(Obj.ROWID);    
	   }
    }
	$('#outputListTab').datagrid('deleteRow', index);
}
function insertinputrow(){
	var data=$('#inputListTab').datagrid('getData');
	var index=data.total;
	$('#inputListTab').datagrid('insertRow', {
		index: index,
		row:{
			requireFlag:'N'
		}
	});
	$('#inputListTab').datagrid('beginEdit',index);
}
///�������ֿ�����
function loadOutputDetail(rowId) {
	$.cm({
	ClassName:GV.CLASSNAME,
	QueryName: "QueryClassMethodArgs",
	ParamInput:rowId+"||||"+"output", //��ȡ���β���
	rows:999999

	},function(jsonData){	
		$('#outputListTab').datagrid('loadData',jsonData);
	})
}
function insertoutputrow() {
	var data=$('#outputListTab').datagrid('getData');
	var index=data.total;
	$('#outputListTab').datagrid('insertRow', {
		index: index,
		row:{}
	});
	$('#outputListTab').datagrid('selectRow',index).datagrid('beginEdit',index);
}

//��ʼ����Ʒ��
function InitProductLine() {
	$HUI.combobox("#ProductLine", {
	panelHeight: 200,
	url: $URL,
	editable: true,
	defaultFilter: 4,
	valueField: "DicCode",
	textField: 'DicDesc',
	onBeforeLoad: function (param) {
		param.ClassName = "BILL.CFG.COM.DictionaryCtl";
		param.QueryName = "QueryDicDataInfo";
		param.Type = "ProductLine";
		param.ResultSetType = 'array';
	},
	onLoadSuccess: function (data) {
	},
	onSelect:function(data){
		ChangeinterfaceCode();
	}
});
}
//��ʼ����Ʒ��
function init_ProductLinkGroup(){
	$HUI.combobox("#ProductLinkGroup", {
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
			}
	});
}
//��ʼ��������
function InitmethodClassName() {
	$HUI.combobox("#methodClassName", {
	panelHeight: 200,
	editable: true,
	defaultFilter: 4,
	valueField: "ClassName",
	textField: 'ClassName',
	onBeforeLoad: function (param) {
	},
	onLoadSuccess: function (data) {
		},
	onChange: function(newValue,oldValue) {
		if(MethodNameCall)
		{
			if(typeof(newValue)!="undefined"&&newValue.length>4)
			{
				var QueryParam=$.cm({
					ClassName:"INSU.MI.ClassMethodCom",
					QueryName:"QueryAllClass",
					clsName:newValue,
					ResultSetType:'array'
				},function(data)
				{
					MethodNameCall=false;
					$('#methodClassName').combobox('loadData',data);
					setValueById("methodClassName",newValue);
				});
			}
		}
		else
		{
			if(typeof(newValue)!="undefined"&&newValue.length<=4)
			{
				MethodNameCall=true;
			}
		}
		Init_MethodName();//��ʼ��������
	},
	onSelect:function(record)
	{
		Init_MethodName();//��ʼ��������
	}
});
}

//��������������ı�
function datatypechange()
{
	//$("#inputDescDialog textarea").val('');
	var datatype=getValueById("datatype");
	if(datatype=="separator")	
	{
		$("#dataformat").empty();//�Ƴ�Ԫ��
		$("#datacompress").empty();//�Ƴ�Ԫ��
		$("#datatypeinput").css("display",'block');//�ָ��ַ��������ʾ
		$("#dataformat").append('<lable>�ָ��ַ�</lable>');
	}
	if(datatype=="xml"||datatype=="json")	
	{
		$("#dataformat").empty();//�Ƴ�Ԫ��
		$("#datacompress").empty();//�Ƴ�Ԫ��
		$("#datatypeinput").val();//�ָ��ַ���������
		$("#datatypeinput").css("display",'none');//�ָ��ַ����������
		$("#dataformat").append('<a class="hisui-linkbutton l-btn l-btn-small" data-options="" onclick="dataformat(0)" group="" id=""><span class="l-btn-left"><span class="l-btn-text">��ʽ��</span></span></a>');
		$("#datacompress").append('<a class="hisui-linkbutton l-btn l-btn-small" data-options="" onclick="dataformat(1)" group="" id=""><span class="l-btn-left"><span class="l-btn-text">ѹ��</span></span></a>');
	}
	if(datatype=="")	
	{
		$("#dataformat").empty();//�Ƴ�Ԫ��
		$("#datacompress").empty();//�Ƴ�Ԫ��
		$("#datatypeinput").css("display",'none');//�ָ��ַ����������
		$("#datatypeinput").val();//�ָ��ַ���������
	}
}

//��ʽ����������,inputId=0�Ǹ�ʽ����inputId=1��ѹ��
function dataformat(inputId)
{
	var datatype=getValueById("datatype");
	if(inputId==0)//��ʽ��
	{
		if(datatype=="xml")
		{
			var xmldata=$("#inputDescDialog textarea").val();
			if(checkxml(xmldata))
			{
				xmldata=formatXml(xmldata);
				$("#inputDescDialog textarea").val(xmldata);
			}
			else if(checkjson(xmldata))
			{
				var xmldata=JSON.parse(xmldata);
				xmldata=$.json2xml(xmldata);
				xmldata=formatXml(xmldata);
				$("#inputDescDialog textarea").val(xmldata);
			}
			else
			{
				$.messager.alert('��ʾ', "xml��ʽ����!", "info", function() {
	        	});
			}
		}
		if(datatype=="json")
		{
			var jsondata=$("#inputDescDialog textarea").val();
			if(checkjson(jsondata))
			{
				jsondata=JSON.stringify(eval("("+jsondata+")"));
				jsondata=formatJson(jsondata);
				$("#inputDescDialog textarea").val(jsondata);
			}
			else if(checkxml(jsondata))
			{
				jsondata=$.xml2json(jsondata);
				jsondata=formatJson(jsondata);
				$("#inputDescDialog textarea").val(jsondata);
			}
			else
			{
				$.messager.alert('��ʾ', "json��ʽ����!", "info", function() {
	        	});
			}
		}
	}
	if(inputId==1)//ѹ��
	{
		var data=$("#inputDescDialog textarea").val();
		data=DHCP_replaceAll(data," ","");
		data=DHCP_replaceAll(data,"\r\n$1\r\n","");
		data=DHCP_replaceAll(data,"\r\n","");
		data=DHCP_replaceAll(data,"\r","");
		data=DHCP_replaceAll(data,"\n","");
		$("#inputDescDialog textarea").val(data);
	}
}
//http����У��
function GetHttpExtObj() {
	var InterfaceType = $('#interfaceType').combobox('getValue');
    var HTimeout = $("#HTimeout").val();
    if(HTimeout=="")
    {
	    $.messager.alert('��ʾ', "�����ó�ʱʱ��!", "info", function() {
	            $('#HServer').focus();
	        });
	      return false;
	}
    var HTimeOutNum = $("#HTimeOutNum").val();
    var HReturnStr = $("#HReturnStr").val().replace(/\ /g, "");
    	HReturnStr=HReturnStr.replace(/��/g, "?");
    var HAutoSwitch = $("#HAutoSwitch").checkbox('getValue') ? "Y" : "N";
   	var HttpObj = { "HTimeout": HTimeout, "HTimeOutNum": HTimeOutNum,"HReturnStr":HReturnStr, "HAutoSwitch":HAutoSwitch};
	if (($("#methodInvokType").combobox('getValue')=="C")){
	    var HServer = $("#HServer").val();
	    if (HServer == "") {
	        $.messager.alert('��ʾ', "���������IP/����!", "info", function() {
	            $('#HServer').focus();
	        });
	        return false;
	    }
	    var HPath = $("#HPath").val();
	    if (HPath == "") {
	        $.messager.alert('��ʾ', "����������·��", "info", function() {
	            $('#HPath').focus();
	        });
	        return false;
	    }
	    var HHttps = $("#HHttps").checkbox('getValue') ? "Y" : "N";
	    var HSSLConfiguration = $("#HSSLConfiguration").val()
/* 	    if (HHttps == "Y" && HSSLConfiguration == "") {
	        $.messager.alert('��ʾ', "HTTPS������SSL����", "info", function() {
	            $('#HSSLConfiguration').focus();
	        });
	        return false;
	    } */
	    if(InterfaceType=="HTTP")
	    {
		    var Type = $("#HMethodType").combobox("getValue");
		    if (Type == "") {
			    $.messager.alert('��ʾ', "��ѡ��HTTP����", "info", function() {
		            $('#HMethodType').next('span').find('input').focus();
		        });
		        return false;
			}
			var Type = $("#HContentType").combobox("getValue");
		    if (Type == "") {
			    $.messager.alert('��ʾ', "��ѡ����������", "info", function() {
		            $('#HContentType').next('span').find('input').focus();
		        });
		        return false;
			}
			var HContentCharset = $("#HContentCharset").combobox("getValue");
		    if (HContentCharset == "") {
			    $.messager.alert('��ʾ', "��ѡ������ʽ", "info", function() {
		            $('#HContentCharset').next('span').find('input').focus();
		        });
		        return false;
			}
	    }
	    var HHeadParmams = $("#HHeadParmams").val().replace(/\ /g, "");
	    $.extend(HttpObj, {
	        HServer: HServer,
	        HDomainFlag: $("#HDomainFlag").checkbox('getValue') ? "Y" : "N",
	        HPort: $("#HPort").val(),
	        HPath: HPath,
	        HMethodType: $("#HMethodType").combobox("getValue"),
	        HContentType: $("#HContentType").combobox("getValue"),
	        HTimeout: $("#HTimeout").val(),
	        HHttps: HHttps,
	        HContentCharset: $("#HContentCharset").combobox("getValue"),
	        HSSLConfiguration: HSSLConfiguration,
	        HSSLCheckServerIdentity: $("#HSSLCheckServerIdentity").checkbox('getValue') ? "Y" : "N",
	        HHeaderJson: HHeadParmams
	    });
	}
	return HttpObj;
}
//����ӿ���ϸ��Ϣ
function methodDataSave() {
 	if(Status=="2") //����״̬Ϊ2�Ƿ���״̬,�������޸ġ�
	{
		$.messager.alert('��ʾ','�����Ľӿ�ֻ�������,�������޸�!','info');return;	
	}
    var interfaceType = $('#interfaceType').combobox('getValue');
    var interfaceCode = $('#interfaceCode').val().replace(/\ /g, "");
    if (interfaceCode == "") {
        $.messager.alert('��ʾ', "������ӿڴ���!", "info", function() {
            $('#interfaceCode').focus();
        });
        return false;
    }
	if(CheckinterfaceCode(interfaceCode))
	{
		$.messager.alert('��ʾ', "�ӿڴ����Ѵ���,���޸ĺ����±���!", "info", function() {
            $('#interfaceCode').focus();
        });
        return false;
	}
    var interfaceName = $('#interfaceName').val().replace(/\ /g, "");
    if (interfaceName == "") {
        $.messager.alert('��ʾ', "������ӿ�����!", "info", function() {
            $('#interfaceName').focus();
        });
        return false;
    }
    var ProductLine = $("#ProductLine").combobox('getValue');
    if (!ProductLine) {
        $.messager.alert('��ʾ', "�������Ʒ��!", "info", function() {
            $('#ProductLine').next('span').find('input').focus();
        });
        return false;
    }
    var BusinessType = getValueById("BusinessType"); //$("#BusinessType").combobox('getValue');
    if (!BusinessType) {
        $.messager.alert('��ʾ', "������ҵ������!", "info", function() {
            $('#BusinessType').next('span').find('input').focus();
        });
        return false;
    }
    var FunPoint =  getValueById("FunPoint")//$("#FunPoint").combobox('getValue');
    if (!FunPoint) {
        $.messager.alert('��ʾ', "�����빦�ܵ�!", "info", function() {
            $('#FunPoint').next('span').find('input').focus();
        });
        return false;
    }
    var MULTSPLIT= $('#MULTSPLIT').val().replace(/\ /g, "");
    var DATASPLIT= $('#DATASPLIT').val().replace(/\ /g, "");
    var Active = $("#Active").combobox('getValue');
    var Local = $("#Local").checkbox('getValue') ? "Y" : "N";
    var methodInvokType = $("#methodInvokType").combobox('getValue');
    var ProductLinkGroupArr =$("#ProductLinkGroup").combobox('getValues');
    var ProductLinkGroup=""
    for(i=0;i<ProductLinkGroupArr.length;i++)
    {
	    ProductLinkGroup=ProductLinkGroup+ProductLinkGroupArr[i];
	    if(i!=ProductLinkGroupArr.length-1)
	    {
	    	ProductLinkGroup=ProductLinkGroup+",";
	    }
	}
    if (ProductLinkGroup == "") {
        $.messager.alert('��ʾ', "�����������Ʒ��!", "info", function() {
            $('#ProductLinkGroup').focus();
        });
        return false;
    }
    var methodType = $("#methodType").val().replace(/\ /g, "");
    var methodClassName = getValueById("methodClassName").replace(/\ /g, "");
    if (methodClassName == "" && interfaceType != "HTTP"&&!(interfaceType == "SOAP")&&(methodInvokType=="C")) {
        $.messager.alert('��ʾ', "����������!", "info", function() {
            $('#methodClassName').focus();
        });
        return false;
    }
    var methodInvokType=$('#methodInvokType').combobox('getValue');
    var methodName =getValueById('methodName');
    if ((methodName == ""||methodName=="�෽��������") && interfaceType != "HTTP"&&!(interfaceType == "SOAP")&&(methodInvokType=="C")) {
        $.messager.alert('��ʾ', "�����뷽����!", "info", function() {
            $('#methodName').focus();
        });
        return false;
    }
    var methodNote = demotxt;
    var LogFlag = $("#LogFlag").checkbox('getValue') ? "Y" : "N";
    var ExptObj = { "interfaceType": interfaceType, "LogFlag": LogFlag };
    var PortConfig="";
    if ((interfaceType != "HIS")&&(methodInvokType=="C")) {
	    var HttpObj = GetHttpExtObj();
        if (!HttpObj) return false;
        PortConfig=JSON.stringify(HttpObj);
        methodName=" ";
        methodClassName=" ";
        methodType=" ";
    }
    var DEMO=getValueById('methodNoteTxt');
    var  inputGdRows = $('#inputListTab').datagrid('getRows');
    for (var i = 0; i <  inputGdRows.length; i++) {
        $('#inputListTab').datagrid('endEdit', i);
    }
    var outputGdRows = $('#outputListTab').datagrid('getRows');
    for (var i = 0; i < outputGdRows.length; i++) {
        $('#outputListTab').datagrid('endEdit', i);
    }
     ExptObj["ROWID"]=id;
     ExptObj["CLASSNAME"]=methodClassName;
     ExptObj["METHODNAME"]=methodName;
     ExptObj["METHODTYP"]=methodType;
     ExptObj["METHODDESC"]=interfaceName;
     ExptObj["DEMO"]=DEMO;
     ExptObj["EFFTFLAG"]=Active;
     ExptObj["MULTSPLIT"]=MULTSPLIT;
     ExptObj["DATASPLIT"]=DATASPLIT;
     ExptObj["InterfaceCode"]=interfaceCode;
     ExptObj["InterfaceType"]=interfaceType;
     ExptObj["UseType"]=methodInvokType;
     ExptObj["ProductLine"]=ProductLine;
     ExptObj["ProductTeam"]=ProductLinkGroup;
     ExptObj["LogFlag"]=LogFlag;
     ExptObj["PortConfig"]=PortConfig; 
     ExptObj["BusinessType"]=BusinessType; 
     ExptObj["FunPoint"]=FunPoint;
     if(id=="")
     { 
     	ExptObj["Status"]="0"; //�����ӿڣ�״̬Ϊ�ݸ�
     }
     else
     {
	     ExptObj["Status"]=Status; 
	 }
	var saveinfo = JSON.stringify(ExptObj);
	var savecode=tkMakeServerCall('INSU.MI.ClassMethodCom',"Save",saveinfo,session['LOGON.USERID'])
	var classname =getValueById('methodClassName');
	var methodname =  getValueById('methodName');
	var InterfaceCode=interfaceCode;
	if(savecode=="0"){
		if(id=="")//��������������������£�idֻ�б���֮��ſ���ȡ��
		{
			//ȡ����֮���CF.INSU.MI.ClassMethod��id
			var input=classname+"|"+methodname+"|||"+InterfaceCode;
			var jsondata = $.m({
        		ClassName: "INSU.MI.ClassMethodCom",
				QueryName: "QueryClassMethod",
				ParamInput:input,
				rows:999999
    		}, false);
	    	var jsonobj =eval("("+jsondata+")");
			var obj = jsonobj.rows[0];//ͨ��rowidֻ�ܲ����һ������
			id=obj.ROWID;
			var inputdata = $('#inputListTab').datagrid('getData');
			var outputdata = $('#outputListTab').datagrid('getData');
			for(i=0;i<inputdata.rows.length;i++) //��֯��β���
			{
				inputdata.rows[i]['SEQ']=i+1;
				inputdata.rows[i]['PARID']=id;
				inputdata.rows[i]['PARNODETYPE']="input";
				saveinfo = JSON.stringify(inputdata.rows[i]);
				savecode=tkMakeServerCall('INSU.MI.ClassMethodArgsCom',"Save",saveinfo,session['LOGON.USERID'])
				if(savecode!="0")
				{
					$.messager.alert('��ʾ','����ʧ��!rtn=' + savecode,'info');
					GetLoadDataDialog(classname,methodname,InterfaceCode);
					return;
				}
			}
			//��������֯ɾ������
			for(i=0;i<outputListarr.length;i++)
			{
				saveinfo = outputListarr[i];
				savecode=tkMakeServerCall("INSU.MI.ClassMethodArgsCom","Delete",saveinfo);
				if(savecode!="0")
				{
					$.messager.alert('��ʾ','����ʧ��!rtn=' + savecode,'info');
					GetLoadDataDialog(classname,methodname,InterfaceCode);
					return;
				}
			}
			for(i=0;i<outputdata.rows.length;i++) //��֯���β���
			{
				if(outputdata.rows[i]['ARGCODE']=="")
				{continue;}
				outputdata.rows[i]['SEQ']=i+1;
				outputdata.rows[i]['PARID']=id;
				outputdata.rows[i]['PARNODETYPE']="output";
				saveinfo = JSON.stringify(outputdata.rows[i]);
				savecode=tkMakeServerCall('INSU.MI.ClassMethodArgsCom',"Save",saveinfo,session['LOGON.USERID']);
				if(savecode!="0")
				{
					$.messager.alert('��ʾ','����ʧ��!rtn=' + savecode,'info');
					GetLoadDataDialog(classname,methodname,InterfaceCode);
					return;
				}
			}
		}
		else //�༭��id��ֱ��ȡ���ݴ漴��
		{
			var inputdata = $('#inputListTab').datagrid('getData');
			var outputdata = $('#outputListTab').datagrid('getData');
			//�������֯ɾ������
			for(i=0;i<inputListarr.length;i++)
			{
				saveinfo = inputListarr[i];
				var obj=inputdata.rows.find(function (obj) {
				    return obj.ROWID === saveinfo;
				})
				var index=$('#inputListTab').datagrid('getRowIndex',obj);
				inputdata.rows.splice(index,1)
				savecode=tkMakeServerCall("INSU.MI.ClassMethodArgsCom","Delete",saveinfo);
				if(savecode!="0")
				{
					$.messager.alert('��ʾ','����ʧ��!rtn=' + savecode,'info');
					GetLoadDataDialog(classname,methodname,InterfaceCode);
					return;
				}
			}
			for(i=0;i<inputdata.rows.length;i++) //��֯��β���
			{
				inputdata.rows[i]['SEQ']=i+1;
				inputdata.rows[i]['PARID']=id;
				inputdata.rows[i]['PARNODETYPE']="input";
				saveinfo = JSON.stringify(inputdata.rows[i]);
				savecode=tkMakeServerCall('INSU.MI.ClassMethodArgsCom',"Save",saveinfo,session['LOGON.USERID']);
				if(savecode!="0")
				{
					$.messager.alert('��ʾ','����ʧ��!rtn=' + savecode,'info');
					GetLoadDataDialog(classname,methodname,InterfaceCode);
					return;
				}
			}
			//��������֯ɾ������
			for(i=0;i<outputListarr.length;i++)
			{
				saveinfo = outputListarr[i];
				savecode=tkMakeServerCall("INSU.MI.ClassMethodArgsCom","Delete",saveinfo);
				if(savecode!="0")
				{
					$.messager.alert('��ʾ','����ʧ��!rtn=' + savecode,'info');
					GetLoadDataDialog(classname,methodname,InterfaceCode);
					return;
				}
			}
			inputListarr=[];
			outputListarr=[];
			for(i=0;i<outputdata.rows.length;i++) //��֯���β���
			{
				if(outputdata.rows[i]['ARGCODE']=="")
				{continue;}
				outputdata.rows[i]['SEQ']=i+1;
				outputdata.rows[i]['PARID']=id;
				outputdata.rows[i]['PARNODETYPE']="output";
				saveinfo = JSON.stringify(outputdata.rows[i]);
				savecode=tkMakeServerCall('INSU.MI.ClassMethodArgsCom',"Save",saveinfo,session['LOGON.USERID']);
				if(savecode!="0")
				{
					$.messager.alert('��ʾ','����ʧ��!rtn=' + savecode,'info');
					GetLoadDataDialog(classname,methodname,InterfaceCode);
					return;
				}
			}
		}
		websys_showModal("minimize");
	}
	else{
		$.messager.alert('��ʾ','����ʧ��!rtn=' + savecode,'info');  
		setValueById("methodName",""); 
	}
}

