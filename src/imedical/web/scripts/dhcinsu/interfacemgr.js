/**
 * FileName: dhcinsu.interfacemgr.js
 * Author: lizhi
 * Date: 2022-06-6
 * Description: 接口管理
 */

 var GV = {
	CLASSNAME:"INSU.MI.ClassMethodCom"	 
}
 var HospDr=session['LOGON.HOSPID'];
 var SelRowid="";
 var PUBLISHSTATUS={"0":"草稿","1":"审核","2":"发布"}
//界面入口
$(function(){
	var Rq1 = INSUGetRequest();
	var classname = Rq1["classname"];
	var methodname = Rq1["methodname"];
	var InterfaceCode=Rq1["InterfaceCode"];
	InitDeleteDialog();
	//回车事件    
	key_enter();
	//默认时间
	setDateBox();
	//初始化产品组
	init_ProductLinkGroup();
	// 产品线下拉表格
	ini_ProductLine();
	//初始化产品线
    //InitProductLine();
    //界面加载先清屏
	// grid
	init_dg();
	//  操作员
	//InitUser();
	//初始化生效标志
	//init_EFFTFLAG();
 	Init_QBusinessType();//初始化业务类型下拉框
	Init_QFunPoint();//初始化功能点 
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
//初始化产品组
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
//数据面板
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
			{ field: 'id', title: '列操作',width: 180, align: "center",
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
			{field:'CLASSNAME',title:'类名称',width:200, hidden: true},
			{field:'METHODNAME',title:'方法名称',width:170, hidden: true},
			{field:'InterfaceCode',title:'接口代码',width:220,showTip:true,},
			{field:'METHODDESC',title:'接口名称',width:220,showTip:true,},
			{field:'InterfaceType',title:'接口类型',width:70},
			{field:'UseType',title:'调用类型',width:70,
				formatter: function (value, row, index) {
					return (value == "S") ?"服务":"调用";
			}},
			{field:'ProductLineName',title:'产品线',width:120},
			{field:'ProductTeamName',title:'相关产品组',width:140},
			{ field: 'EFFTFLAG', title: '状态', width: 50, 
				formatter: function(v, rec, index) {
                    var EFFTFLAG = (rec.EFFTFLAG == "Y") ? "运行" : "停用";
                    return EFFTFLAG;
                },
                styler: function(v, rec, index){
					if (rec.EFFTFLAG != "Y"){
						return 'background-color:#FFC1C1; color:red;';
					}
				}
			},
            { field: 'LogFlag', title: '记录日志', width: 70, align: "center",
                formatter: function(v, rec, index) {
                    var LogFlag = (rec.LogFlag == "Y") ? "是" : "否";
                    return LogFlag;
                }
            },
			{field:'Status',title:'发布状态',width:80,
                formatter: function(v, rec, index) {
                    var Status = (rec.Status == ""||rec.Status == undefined) ? "草稿" : PUBLISHSTATUS[rec.Status] || rec.Status;
                    return Status;
                }},
			{field:'METHODTYP',title:'方法类型',width:120,hidden:true}
			
		]],
		onLoadSuccess: function(data) {
			ChangeButtonText($(".editcls1"),"修改","icon-write-order");
			ChangeButtonText($(".deletecls"),"删除","icon-cancel");
			ChangeButtonText($(".logcls"),"记日志","icon-cal-pen");
			ChangeButtonText($(".slogcls"),"不记日志","icon-red-cancel-paper");
			ChangeButtonText($(".stopcls"),"停用","icon-lock");
			ChangeButtonText($(".startcls"),"运行","icon-unlock");
			ChangeButtonText($(".debugcls"),"调试","icon-ok");
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
    var message=(LogFlag == "Y") ? "不记日志":"记日志";
    $.messager.confirm("操作提示", "您确定要修改为"+message+"？", function(r) {
        if (r) {
            var Ret = tkMakeServerCall('INSU.MI.ClassMethodCom',"Save",JSON.stringify(Obj),session['LOGON.USERID']);
            var Code = Ret.split("^")[0];
            if (Code == "0") {
                $.messager.popover({ msg: '修改成功！', type: 'success', timeout: 1000 });
                $('#dg').datagrid('reload');
            } else {
                $.messager.alert('提示', Code,"error");
            }
        }
    })
}
function updateStatus(ID, index) {
    var EFFTFLAG = "";
    var Obj = $("#dg").datagrid("getData").rows[index];
    if($("#dg").datagrid("getData").rows[index].Status=="2"){$.messager.alert('提示','发布的接口不允许停用!','info');return;}
    if (Obj != null) {
        EFFTFLAG = Obj.EFFTFLAG;
    }
    Obj.EFFTFLAG = (EFFTFLAG == "Y") ? "N" : "Y";
     var message= (EFFTFLAG == "Y") ? "停用":"启用";
    $.messager.confirm("操作提示", "您确定要"+message+"服务？", function(r){
        if (r) {
	        var Ret = tkMakeServerCall('INSU.MI.ClassMethodCom',"Save",JSON.stringify(Obj),session['LOGON.USERID']);
            var Code = Ret.split("^")[0];
            if (Code == "0") {
                $.messager.popover({ msg: '修改成功！', type: 'success', timeout: 1000 });
                $('#dg').datagrid('reload');
            } else {
                $.messager.alert('提示', Code);
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
    //打开调试界面
    var url = "dhcinsu.interfacedebugdetail.csp?&debugcode=" + debugcode+"&debugdesc="+debugdesc+"&classname="+classname+"&methodname="+methodname+"&inputid="+inputid+"&methodtype="+methodtype+"&ProductLine="+ProductLine+"&InterfaceCode="+InterfaceCode;
	//var setwidth=920;
	//var setheigth = window.document.body.clientHeight*0.95;
	websys_showModal({
		url: url,
		title: "接口调试",
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
		title: "接口明细新增"+html,
		iconCls: "icon-w-edit",
		width: setwidth,
		height: setheigth,
		//tools:tools,
		onMinimize: function()
		{
			$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});
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
		title: "接口明细编辑"+html,
		iconCls: "icon-w-edit",
		width: setwidth,
		height: setheigth,
		onClose: function()
		{
			
		},
		onMinimize: function()
		{
			$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
			$('#dg').datagrid('reload');
		}
		
	});
}
function InitDeleteDialog() {
    $('#DeleteDialog').dialog({
        autoOpen: false,
        title: '请确认',
        closed: true,
        width: 350,
        cache: false,
        modal: true,
        resizable: true,
        buttons: [
        {
            text: '取消删除',
            iconCls: 'icon-w-close',
            handler: function() {
                $('#DeleteDialog').dialog('close');
            }
        },
		{
			text: '确认删除',
			iconCls: 'icon-w-save',
			handler: function() {
				var savecode=tkMakeServerCall(GV.CLASSNAME,"Delete",SelRowid)
				if(eval(savecode)==0){
					$('#dg').datagrid('reload');
					$.messager.alert('提示','删除成功!','info');   
				}else{
					$.messager.alert('提示','删除失败!','info');   
				}
				$('#DeleteDialog').dialog('close');
			}
		}
        ]
    });
}
//删除记录
function deleteRow(Rowid,indexid){
	if(Rowid=="" || Rowid<0 || !Rowid){$.messager.alert('提示','请选择要删除的记录!','info');return;}
	else if($("#dg").datagrid("getData").rows[indexid].Status=="2"){$.messager.alert('提示','发布的接口不允许删除!','info');return;}
	$.messager.confirm('请确认','你确认要删除这条记录吗?',function(fb){
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
	var _content = "<ul class='tip_class' style='padding:5px;'><li style='font-weight:bold'>计费医保接口管理使用说明</li>" +
		'<li>1、接口注册可把HIS内部接口、Webservice接口、Htpp接口进行配置化调用。</li>' +
		'<li>通过调用统一入口：##class(INSU.MI.ClassMethodCom).DoMethod(ClsRowId,InputJson)</li>' +
		'<li><span>即可调用到实际接口。</span></li>' + 
		'<li style="color:#ccc">-------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>2、计费医保注册表：CF_INSU_MI.ClassMethod、日志注册表: CF_INSU_MI.LogRegist 、日志记录表：CF_INSU_MI.Log。</li>" +
		'<li style="color:#ccc">-------------------------------------------------------------------------------------------------------------------------------------</li>'+
		'<li>3、具体配置操作：' +
/* 		"<li><span>接口代码规则：Soap类型以：W.开头、Http类型以：H.开头</span></li>" +  */
		"<li><span>HIS内部接口：配置必要的参数即可。</span></li>" + 
		'<li><span>Soap类型接口：配置必要的参数即可,提供给第三方的统一webservice: web.INSUInterfaceWebService.cls。</span></li>' + 
		"<li><span>Http类型接口：配置必要的参数即可,提供给第三方的统一Http:INSU.MI.InterfaceHttp.cls。</span></li>" + 
		'<li style="color:#ccc">-------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>4、如果勾上记录日志，则保存接口方法时，会同步保存计费医保接口日志注册信息。</li>" + 
		'<li style="color:#ccc">-------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>5、对Soap和Http调用类型的接口，如果设置了超时自动关闭，则当接口请求超时且超过设置次数(默认3次)时，会自动关闭接口。</li>"+
		'<li style="color:#ccc">-------------------------------------------------------------------------------------------------------------------------------------</li>'+
		"<li>6、相关产品组，表示这个接口是给谁用的。</li></ul>";//+
		//'<li>----------------------------------------------------------------------------------------------------------------------------------------------</li>';
	$("#tip").popover({
		trigger:'hover',
		content:_content
	});
	$("#tip").popover('show');
}
//草稿0、审核1、发布2
function Operation(type){
 	var checkedRows = $('#dg').datagrid('getChecked');
	var RowIdStr = '';
	if (checkedRows.length == '0'){
		$.messager.alert('提示','请选择需要操作的数据','info');
		return;
	}
	for (var i = 0; i <= checkedRows.length - 1; i++) {
		if(checkedRows[i].Status=="2")
		{
			continue;
		}
		if(checkedRows[i].EFFTFLAG!="Y"&&type=="2")
		{
			$.messager.alert('提示','数据中包含停用的接口,请先启用!','info');
			return;	
		}
		RowIdStr = RowIdStr + '^' + checkedRows[i].ROWID; 
	}
	var messager="";
	if(RowIdStr=="")
	{
		$.messager.alert('提示','发布的接口不允许修改发布状态!','info');
		return;	
	}
	var rtn = $.m({ClassName: "INSU.MI.ClassMethodCom", MethodName: "UpdatePublishStatusById", Status:type,RowIdStr:RowIdStr,User:session['LOGON.USERID']}, false);
	if (rtn == '0'){
		$.messager.alert('提示','操作成功' , 'success',function(){
			$('#dg').datagrid('reload');
		});
	}else{
		$.messager.alert('提示','操作失败' + rtn , 'error',function(){
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
//查询
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
	// 跳转页
	
}
function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
	$('#' + gridid).datagrid('unselectAll');
	$('#' + gridid).datagrid('clearChecked');
}
//默认时间
function setDateBox() {
	setValueById('StartDate',getDefStDate(0));
	setValueById('EndDate',getDefStDate(0));
}
///回车
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
//清屏
function clear_click() {
	$('#tQueryPanel').form('clear');
	setDateBox();
	RunQuery();	
}
// 产品线下拉表格
function ini_ProductLine() {
	$HUI.combogrid("#QProductLine", {
		url: $URL + "?ClassName=INSU.MI.ClassMethodCom&QueryName=QueryProductLine",
		idField: "PLCode",
		textField: "PLName",
		singleSelect: true,
		panelWidth: 430,
		columns: [[
			{ title: '代码', field: 'PLCode', width: 200 },
			{ title: '名称', field: 'PLName', width: 200 }
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
 * Description: 生成次级弹窗Modifydl
 * input:	msg : 提示内容
 * 			buttonType : 是否显示按钮 "disable" 不显示
 * 			title : 弹窗标题
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
//导入
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
         $.messager.alert('提示', '打开文件错误！'+rs.msg,'error');
      }				   
}
function importItm(filePath)
{
    if (filePath == "") {
        $.messager.alert('提示', '请选择文件！','info')
        return ;
    }
   $.messager.progress({
         title: "提示",
         msg: '服务注册管理导入',
         text: '数据读取中...'
        }); 
   $.ajax({
	async : true,
	complete : function () {
    ReadItmExcel(filePath);
	}
	});
  
}
//读取Excel数据
function ReadItmExcel(filePath)
{
	
   //读取excel
   var arr;
   try 
   {
	 arr= websys_ReadExcel(filePath);
	 $.messager.progress("close");
	}
   catch(ex)
   {
	  $.messager.progress("close");
	  $.messager.alert('提示', '调用websys_ReadExcel异常：'+ex.message,'error')
	  return ;
	}
	 var rowCnt=arr.length
	 $.messager.progress({
            title: "提示",
            msg: '服务注册管理导入',
            text: '导入中，共：'+(rowCnt-1)+'条'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
       ItmArrSave(arr);
	}
	});
}

//数据保存
function ItmArrSave(arr)
{
	
	//读取保存数据
	var ErrMsg = "";     //错误数据
    var errRowNums = 0;  //错误行数
    var sucRowNums = 0;  //导入成功的行数
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
	                    ErrMsg = ErrMsg + "<br>方法名称" + ExptObj["InterfaceCode"] +"保存失败:"+savecode+"<br>";
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
	    		var obj = jsonobj.rows[0];//通过rowid只能查回来一条数据
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
                    $.messager.alert('提示', '数据正确导入完成');
                } else {
                   $.messager.progress("close");
                     var tmpErrMsg = "导入成功："+sucRowNums +"条，失败："+errRowNums+"条。";
                     tmpErrMsg = tmpErrMsg + "<br>失败数据行号：<br>"+ ErrMsg;
                    $.messager.alert('提示', tmpErrMsg,'info');
                }
		      return ; 
		 }
		 catch(ex)
		 {
			  $.messager.progress("close");
			  $.messager.alert('提示', '保存数据核查字典数据异常：'+ex.message,'error')
	          return ;
	      }
	
}
//数据核查字典导出
function Export()
{
   try
   {
 		$.messager.progress({
	         title: "提示",
			 msg: '正在导出服务注册管理',
			 text: '导出中....'
			   });
		$cm({
			ResultSetType:"ExcelPlugin",  
			ExcelName:"服务注册管理",		  
			PageName:"ExportALLData",      
			ClassName:"INSU.MI.ClassMethodCom",
			QueryName:"ExportData",
		},function(){
			  setTimeout('$.messager.progress("close");', 3 * 1000);	
		}); 
		
   } catch(e) {
	   $.messager.alert("警告",e.message);
	   $.messager.progress('close');
   }; 
}
