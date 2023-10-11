/**
 * FileName: interfacemgrdetail.js
 * Author: lizhi
 * Date: 2022-06-6
 * Description: 接口管理
 */
var GV = {
	CLASSNAME:"INSU.MI.ClassMethodArgsCom"	 
}
var MethodNameCall=true;//是否调用后台获取类名称
var id="";  //主索引rowid
var Status="0"; //审核状态
var demotxt="";
var outputListarr=[];//要删除的出参记录rowid
var inputListarr=[];//要删除入参记录rowid
$(function() {
	$("#methodDataSaveBtn").click(methodDataSave); //保存按钮绑定事件
	$("#HPath").val("/");
	var Rq = INSUGetRequest();
	var classname = Rq["classname"];
	var methodname = Rq["methodname"];
	var InterfaceCode=Rq["InterfaceCode"];
	Status=Rq["Status"];
	Init_MethodName();//初始化方法名下拉框
    InitmethodClassName();//初始化类方法名称
    InitProductLine(); //初始化产品线下拉框填充
	init_ProductLinkGroup();//初始化产品组
	init_outputListTab(); //初始化出参datagrid
	InitInputDescDialog();//初始化入参详细弹框
	InitDemoDialog();//初始化函数说明
	init_inputListTab(); //初始化入参datagrid
 	Init_BusinessType();//初始化业务类型下拉框
	Init_FunPoint();//初始化功能点 
    InitParamsStyle("HHeadParmams");//初始化head参数
    ChagemethodInvokType();
    var PageNoteCont="";
	if(methodname!=''){
		//接口编辑页面设置不可编辑
		MethodNameCall=true
 		$("#methodClassName").combobox({disabled: true});
 		$("#methodName").combobox({disabled: true}); 
/* 			$("#ProductLine").combobox({disabled: true});
		$("#interfaceType").combobox({disabled: true});
		$("#methodInvokType").combobox({disabled: true});
		
		$("#interfaceName").attr("disabled",true);
		$("#interfaceCode").attr("disabled",true); */
		GetLoadDataDialog(classname,methodname,InterfaceCode);
		/* PageNoteCont="<ul class='tip_class'><li style='font-weight:bold'>接口明细编辑使用说明</li>" +
		'<li>1、入参:当类方法修改入参后,在编辑界面会显示参数变化，确认无误后直接保存即可！' +
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>2、参数中详细按钮:维护入参字段的格式和模板,包含类型为三种,默认/xml/json。录入后，在调试界面将会显示字段的可视化与格式化</li>" + 
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>3、函数说明:如果是HIS或者HTTP/SOAP的服务自动填入函数注释，HTTP/SOAP调用需要手动填入,可手动修改</li>" + 
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>';	 */
		PageNoteCont="<ul class='tip_class'>" +
		'<li>1、入参：当类方法修改入参后，在编辑界面会显示参数变化，确认无误后直接保存即可。</li>' +
		"<li>2、参数中详按钮：维护入参字段的格式和模板，含类型为三种：默认/xml/json。录入后，在调试界面将会显示字段可视化与格式化。</li>" + 
		"<li>3、函数说明：如果是HIS或者HTTP/SOAP的服务自动填入函数注释，HTTP/SOAP调用需要手动填入，可手动修改。</li></ul>";	
	}
	else
	{
		MethodNameCall=true;
		PageNoteCont="<ul class='tip_class'><li style='font-weight:bold'>接口明细新增使用说明</li>" +
		'<li>1、调用类型:服务表示发布服务供给其他组或第三方调用，调用表示调用其他组或者第三方服务</li>' +
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>2、接口代码组成规则:产品线.接口类型.调用类型.接口名称。接口代码生成后可以自行更改,要求唯一。</li>" +
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>3、相关产品组，表示这个接口是给谁用的。</li>"+
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>'+
		'<li>4、入参:入参在输入类名称和类方法后自动生成,如果是HTTP服务,入参需要手动填入。' +
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>5、参数中详细按钮:维护入参字段的格式和模板,包含类型为三种,默认/xml/json。录入后，在调试界面将会显示字段的可视化与格式化</li>" + 
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>6、函数说明:如果是HIS或者HTTP/SOAP的服务自动填入函数注释，HTTP/SOAP调用需要手动填入,可手动修改</li>" + 
		'<li>--------------------------------------------------------------------------------------------------------------------------------------------------------------</li>';	
	}
		//方法名回车事件
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
			$.messager.alert('提示', "接口代码已存在,请修改!", "info", function() {
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
		content:"复制接口代码",
		placement:"bottom"
	});
});
//函数说明弹窗
function InitmethodNote(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>双击函数说明文本框,即可显示函数说明弹窗!</li>" ;
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
	  $("#HPath").val("/"+getValueById("HPath")); //默认/开头
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
//复制剪切板
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
     if (state) {//复制成功
	     $.messager.popover({ msg: '复制成功', type: 'success', timeout: 1000 });
    	
    } 
    else {//复制失败
	    $.messager.popover({ msg: '复制失败', type: 'faild', timeout: 1000 });	
    }
 }
//加载指标明细数据
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
		var obj = jsonData.rows[0];//通过rowid只能查回来一条数据
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
			setValueById("methodName","类方法不存在")
		}
	},
	onChange: function(newValue, oldValue) {
		AutoInputTxt(getValueById("methodClassName").replace(/\ /g, ""),newValue);
		AutoOutputTxt(getValueById("methodClassName").replace(/\ /g, ""),newValue);
	}
	}); 
}
//接口名称失去焦点或者回车事件
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
		$.messager.alert('提示', "接口代码已存在,请修改!", "info", function() {
            $('#interfaceCode').focus();
        });
	}
	$('#interfaceCode').val(interfaceCode);
}
function CheckinterfaceCode(interfaceCode){ //检测是否重复
	var interfaceRowid=$.m({
	    			ClassName:"INSU.MI.ClassMethodCom",
					MethodName:"GetInfoByInterfaceCode",
					interfaceCode:interfaceCode,
					index:"1"},false);
	if((id==''&&interfaceRowid!="")||(id!=''&&id!=interfaceRowid&&interfaceRowid!=""))//id为空代表新增,不允许新增相同的接口代码
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
	$("#interfaceDetail").css("overflow","hidden"); //隐藏Y轴滚动条
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
		if(methodInvokType=="S") //服务，隐藏地址框
		{
			$(".HisServer").show();
			$(".SOAPService,.httpService").hide();
			$('#inputListTab').datagrid('hideColumn', "action");
			var ee = $('#inputListTab').datagrid('getColumnOption', 'ARGCODE');
			ee.editor={}
		}
		if(methodInvokType=="C") //调用，显示地址框
		{
			$("#interfaceDetail").css("overflow-y","scroll");//显示Y轴滚动条
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
	var TitLnk = '<a href="#" onclick="insertoutputrow()"><img style="margin:6px 3px 0px 3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>';//待更改位置
    $('#outputListTab').datagrid({
	    rownumbers:false,
		fit: true,
		striped:true,
		fitColumns:true,
		singleSelect: true,
		columns:[            
		[
			{ field: 'ROWID', title: '主表id', width: 120,hidden:true,},
            { field: 'PARID', title: '关联id', width: 120,hidden:true,
                	formatter: function(value, rowData) {
                         return id;
                    }, 
            },
            { field: 'SEQ', title: '序号', width: 120,hidden:true,},//后续作为可修改顺序？
	    	{ field:'ARGTYPE',title:'数据类型',width:120,
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
                { field: 'ARGCODE', title: '参数代码', width: 120, editor: 'text' },
                { field: 'ARGNAME', title: '参数名称', width: 120, editor: 'text' },
/*                 {field:'MustFlag',title:'是否必填',width:70,align:'center',
					editor:{
						type:'icheckbox',
						options:{
							on: 'Y',
							off: 'N'
						}
					}
				}, */
                { field:'Memo',title:'备注',width:180,editor: 'text' },
                { field:'action',title:TitLnk,width:40,align:'center',
                    formatter: function(value, row, index) {
                        var d = "<a href='#' onclick='deleteoutputrow(this)'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";//待更改位置
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
//http的输入可以手动增加
function init_inputListTab(){//init_inputHttpListTab(){
	var TitLnk = '<a href="#" onclick="insertinputrow()"><img style="margin:6px 3px 0px 3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>';//待更改位置
	$HUI.datagrid("#inputListTab",{
    rownumbers:false,
	fit: true,
	striped:true,
	fitColumns:true,
	singleSelect: true,
	columns:[            [
    	{ field:'ARGTYPE',title:'数据类型',width:120,
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
            { field: 'PARID', title: '主表id', width: 120,hidden:true,},
            { field: 'ARGCODE', title: '参数代码', width: 120,editor: 'text'},
            { field: 'ARGNAME', title: '参数名称', width: 120,editor: 'text' },
			{field:'MustFlag',title:'是否必填',width:70,align:'center',
				editor:{
					type:'icheckbox',
					options:{
						on: 'Y',
						off: 'N'
					}
				}
			},
            { field:'Memo',title:'测试默认值',width:240,editor: 'text' },
            { field:'ParamFormatter',title:'',width:40,align:'center',hidden:true},
            { field:'ParamFormatterbtn',title:'',width:40,align:'center',
            	formatter: function(value, row, index) {
                        return '<a class="editcls" onclick="showinputdetail(\'' + index + '\')">详</a>';
                    }
            },
            { field:'action',title:TitLnk,width:40,align:'center',
                formatter: function(value, row, index) {
                    var d = "<a href='#' onclick='deleteinputrow(this)'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";//待更改位置
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
        title: '参数格式化',
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
            text: '确定',
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
					$.messager.alert('提示', "xml格式错误!", "info", function() {
		        	});
		        	return
				}
			}
			if(datatype=="json")
			{
/* 				if(checkjson(tVal))
				{ */
					rows["ParamType"]=getValueById("datatype");
					//tVal=JSON.stringify(eval("("+tVal+")"))加入压缩功能，存入之后不在格式化了
					//tVal=formatJson(tVal);
/* 				}
				else
				{
					$.messager.alert('提示', "json格式错误!", "info", function() {
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
            text: '取消',
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
        title: '函数说明',
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
            text: '确定',
            iconCls: 'icon-w-save',
            handler: function() {
            var tVal = $('#DemoDialog textarea').val();
            $('#methodNoteTxt').val(tVal);
            $('#DemoDialog').dialog('close');
            }
        },
        {
            text: '取消',
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
//显示入参字段详细参数
function showinputdetail(index) {
	$('#inputListTab').datagrid('selectRow',index);
	var data = $('#inputListTab').datagrid('getData');
	var tVal=data.rows[index].ParamFormatter
	/* tVal=replaceTextarea2(tVal); */
	if(data.rows[index].ParamType=="json"||data.rows[index].ParamType=="xml")
	{
		$('#datatype').combobox('select', data.rows[index].ParamType);
	}
	else if(typeof(data.rows[index].ParamType)!="undefined"&&data.rows[index].ParamType!="")//分隔符直接存的分隔符
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
//新增服务入参文字框赋值
function AutoInputTxt(classname,methodname)
{
	var ExtJsonStr = $.m({
		ClassName:"INSU.MI.ClassMethodArgsCom",
		MethodName: "GetClsMethodParam",
		clsName:classname,
		methodName:methodname
	}, false);
	//组织参数
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

//入参文字框内容
function loadInputDetail(rowId) {
	var classname =getValueById('methodClassName');
	var methodname =  getValueById('methodName');
	var jsonData=$.cm({
		ClassName:GV.CLASSNAME,
		QueryName: "QueryClassMethodArgs",
		ParamInput:rowId+"||||"+"input", //获取入参参数
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
    if(Result.split("|")[0]=="Y") //和维护的参数不一致，显示维护参数与方法实际参数对比和渲染
    {
	    $.messager.alert('提示', "方法入参与维护参数不一致，请重新保存!", "info", function() {
        });
	    if(Result.split("|")[1].split("#")[0]!="")
	    {
			//获取方法实际参数
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
					//自动记录修改，无需手动
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
///出参文字框内容
function loadOutputDetail(rowId) {
	$.cm({
	ClassName:GV.CLASSNAME,
	QueryName: "QueryClassMethodArgs",
	ParamInput:rowId+"||||"+"output", //获取出参参数
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

//初始化产品线
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
//初始化产品组
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
//初始化类名称
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
		Init_MethodName();//初始化方法名
	},
	onSelect:function(record)
	{
		Init_MethodName();//初始化方法名
	}
});
}

//数据类型下拉框改变
function datatypechange()
{
	//$("#inputDescDialog textarea").val('');
	var datatype=getValueById("datatype");
	if(datatype=="separator")	
	{
		$("#dataformat").empty();//移除元素
		$("#datacompress").empty();//移除元素
		$("#datatypeinput").css("display",'block');//分割字符输入框显示
		$("#dataformat").append('<lable>分割字符</lable>');
	}
	if(datatype=="xml"||datatype=="json")	
	{
		$("#dataformat").empty();//移除元素
		$("#datacompress").empty();//移除元素
		$("#datatypeinput").val();//分割字符输入框清空
		$("#datatypeinput").css("display",'none');//分割字符输入框隐藏
		$("#dataformat").append('<a class="hisui-linkbutton l-btn l-btn-small" data-options="" onclick="dataformat(0)" group="" id=""><span class="l-btn-left"><span class="l-btn-text">格式化</span></span></a>');
		$("#datacompress").append('<a class="hisui-linkbutton l-btn l-btn-small" data-options="" onclick="dataformat(1)" group="" id=""><span class="l-btn-left"><span class="l-btn-text">压缩</span></span></a>');
	}
	if(datatype=="")	
	{
		$("#dataformat").empty();//移除元素
		$("#datacompress").empty();//移除元素
		$("#datatypeinput").css("display",'none');//分割字符输入框隐藏
		$("#datatypeinput").val();//分割字符输入框清空
	}
}

//格式化输入数据,inputId=0是格式化，inputId=1是压缩
function dataformat(inputId)
{
	var datatype=getValueById("datatype");
	if(inputId==0)//格式化
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
				$.messager.alert('提示', "xml格式错误!", "info", function() {
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
				$.messager.alert('提示', "json格式错误!", "info", function() {
	        	});
			}
		}
	}
	if(inputId==1)//压缩
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
//http服务校验
function GetHttpExtObj() {
	var InterfaceType = $('#interfaceType').combobox('getValue');
    var HTimeout = $("#HTimeout").val();
    if(HTimeout=="")
    {
	    $.messager.alert('提示', "请设置超时时间!", "info", function() {
	            $('#HServer').focus();
	        });
	      return false;
	}
    var HTimeOutNum = $("#HTimeOutNum").val();
    var HReturnStr = $("#HReturnStr").val().replace(/\ /g, "");
    	HReturnStr=HReturnStr.replace(/？/g, "?");
    var HAutoSwitch = $("#HAutoSwitch").checkbox('getValue') ? "Y" : "N";
   	var HttpObj = { "HTimeout": HTimeout, "HTimeOutNum": HTimeOutNum,"HReturnStr":HReturnStr, "HAutoSwitch":HAutoSwitch};
	if (($("#methodInvokType").combobox('getValue')=="C")){
	    var HServer = $("#HServer").val();
	    if (HServer == "") {
	        $.messager.alert('提示', "请输入服务IP/域名!", "info", function() {
	            $('#HServer').focus();
	        });
	        return false;
	    }
	    var HPath = $("#HPath").val();
	    if (HPath == "") {
	        $.messager.alert('提示', "请输入请求路径", "info", function() {
	            $('#HPath').focus();
	        });
	        return false;
	    }
	    var HHttps = $("#HHttps").checkbox('getValue') ? "Y" : "N";
	    var HSSLConfiguration = $("#HSSLConfiguration").val()
/* 	    if (HHttps == "Y" && HSSLConfiguration == "") {
	        $.messager.alert('提示', "HTTPS请输入SSL名字", "info", function() {
	            $('#HSSLConfiguration').focus();
	        });
	        return false;
	    } */
	    if(InterfaceType=="HTTP")
	    {
		    var Type = $("#HMethodType").combobox("getValue");
		    if (Type == "") {
			    $.messager.alert('提示', "请选择HTTP方法", "info", function() {
		            $('#HMethodType').next('span').find('input').focus();
		        });
		        return false;
			}
			var Type = $("#HContentType").combobox("getValue");
		    if (Type == "") {
			    $.messager.alert('提示', "请选择数据类型", "info", function() {
		            $('#HContentType').next('span').find('input').focus();
		        });
		        return false;
			}
			var HContentCharset = $("#HContentCharset").combobox("getValue");
		    if (HContentCharset == "") {
			    $.messager.alert('提示', "请选择编码格式", "info", function() {
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
//保存接口明细信息
function methodDataSave() {
 	if(Status=="2") //发布状态为2是发布状态,不允许修改。
	{
		$.messager.alert('提示','发布的接口只允许浏览,不允许修改!','info');return;	
	}
    var interfaceType = $('#interfaceType').combobox('getValue');
    var interfaceCode = $('#interfaceCode').val().replace(/\ /g, "");
    if (interfaceCode == "") {
        $.messager.alert('提示', "请输入接口代码!", "info", function() {
            $('#interfaceCode').focus();
        });
        return false;
    }
	if(CheckinterfaceCode(interfaceCode))
	{
		$.messager.alert('提示', "接口代码已存在,请修改后重新保存!", "info", function() {
            $('#interfaceCode').focus();
        });
        return false;
	}
    var interfaceName = $('#interfaceName').val().replace(/\ /g, "");
    if (interfaceName == "") {
        $.messager.alert('提示', "请输入接口名称!", "info", function() {
            $('#interfaceName').focus();
        });
        return false;
    }
    var ProductLine = $("#ProductLine").combobox('getValue');
    if (!ProductLine) {
        $.messager.alert('提示', "请输入产品线!", "info", function() {
            $('#ProductLine').next('span').find('input').focus();
        });
        return false;
    }
    var BusinessType = getValueById("BusinessType"); //$("#BusinessType").combobox('getValue');
    if (!BusinessType) {
        $.messager.alert('提示', "请输入业务类型!", "info", function() {
            $('#BusinessType').next('span').find('input').focus();
        });
        return false;
    }
    var FunPoint =  getValueById("FunPoint")//$("#FunPoint").combobox('getValue');
    if (!FunPoint) {
        $.messager.alert('提示', "请输入功能点!", "info", function() {
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
        $.messager.alert('提示', "请输入关联产品组!", "info", function() {
            $('#ProductLinkGroup').focus();
        });
        return false;
    }
    var methodType = $("#methodType").val().replace(/\ /g, "");
    var methodClassName = getValueById("methodClassName").replace(/\ /g, "");
    if (methodClassName == "" && interfaceType != "HTTP"&&!(interfaceType == "SOAP")&&(methodInvokType=="C")) {
        $.messager.alert('提示', "请输入类名!", "info", function() {
            $('#methodClassName').focus();
        });
        return false;
    }
    var methodInvokType=$('#methodInvokType').combobox('getValue');
    var methodName =getValueById('methodName');
    if ((methodName == ""||methodName=="类方法不存在") && interfaceType != "HTTP"&&!(interfaceType == "SOAP")&&(methodInvokType=="C")) {
        $.messager.alert('提示', "请输入方法名!", "info", function() {
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
     	ExptObj["Status"]="0"; //新增接口，状态为草稿
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
		if(id=="")//代表新增，新增得情况下，id只有保存之后才可以取到
		{
			//取新增之后得CF.INSU.MI.ClassMethod表id
			var input=classname+"|"+methodname+"|||"+InterfaceCode;
			var jsondata = $.m({
        		ClassName: "INSU.MI.ClassMethodCom",
				QueryName: "QueryClassMethod",
				ParamInput:input,
				rows:999999
    		}, false);
	    	var jsonobj =eval("("+jsondata+")");
			var obj = jsonobj.rows[0];//通过rowid只能查回来一条数据
			id=obj.ROWID;
			var inputdata = $('#inputListTab').datagrid('getData');
			var outputdata = $('#outputListTab').datagrid('getData');
			for(i=0;i<inputdata.rows.length;i++) //组织入参参数
			{
				inputdata.rows[i]['SEQ']=i+1;
				inputdata.rows[i]['PARID']=id;
				inputdata.rows[i]['PARNODETYPE']="input";
				saveinfo = JSON.stringify(inputdata.rows[i]);
				savecode=tkMakeServerCall('INSU.MI.ClassMethodArgsCom',"Save",saveinfo,session['LOGON.USERID'])
				if(savecode!="0")
				{
					$.messager.alert('提示','保存失败!rtn=' + savecode,'info');
					GetLoadDataDialog(classname,methodname,InterfaceCode);
					return;
				}
			}
			//出参先组织删除参数
			for(i=0;i<outputListarr.length;i++)
			{
				saveinfo = outputListarr[i];
				savecode=tkMakeServerCall("INSU.MI.ClassMethodArgsCom","Delete",saveinfo);
				if(savecode!="0")
				{
					$.messager.alert('提示','保存失败!rtn=' + savecode,'info');
					GetLoadDataDialog(classname,methodname,InterfaceCode);
					return;
				}
			}
			for(i=0;i<outputdata.rows.length;i++) //组织出参参数
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
					$.messager.alert('提示','保存失败!rtn=' + savecode,'info');
					GetLoadDataDialog(classname,methodname,InterfaceCode);
					return;
				}
			}
		}
		else //编辑有id，直接取数据存即可
		{
			var inputdata = $('#inputListTab').datagrid('getData');
			var outputdata = $('#outputListTab').datagrid('getData');
			//入参先组织删除参数
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
					$.messager.alert('提示','保存失败!rtn=' + savecode,'info');
					GetLoadDataDialog(classname,methodname,InterfaceCode);
					return;
				}
			}
			for(i=0;i<inputdata.rows.length;i++) //组织入参参数
			{
				inputdata.rows[i]['SEQ']=i+1;
				inputdata.rows[i]['PARID']=id;
				inputdata.rows[i]['PARNODETYPE']="input";
				saveinfo = JSON.stringify(inputdata.rows[i]);
				savecode=tkMakeServerCall('INSU.MI.ClassMethodArgsCom',"Save",saveinfo,session['LOGON.USERID']);
				if(savecode!="0")
				{
					$.messager.alert('提示','保存失败!rtn=' + savecode,'info');
					GetLoadDataDialog(classname,methodname,InterfaceCode);
					return;
				}
			}
			//出参先组织删除参数
			for(i=0;i<outputListarr.length;i++)
			{
				saveinfo = outputListarr[i];
				savecode=tkMakeServerCall("INSU.MI.ClassMethodArgsCom","Delete",saveinfo);
				if(savecode!="0")
				{
					$.messager.alert('提示','保存失败!rtn=' + savecode,'info');
					GetLoadDataDialog(classname,methodname,InterfaceCode);
					return;
				}
			}
			inputListarr=[];
			outputListarr=[];
			for(i=0;i<outputdata.rows.length;i++) //组织出参参数
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
					$.messager.alert('提示','保存失败!rtn=' + savecode,'info');
					GetLoadDataDialog(classname,methodname,InterfaceCode);
					return;
				}
			}
		}
		websys_showModal("minimize");
	}
	else{
		$.messager.alert('提示','保存失败!rtn=' + savecode,'info');  
		setValueById("methodName",""); 
	}
}

