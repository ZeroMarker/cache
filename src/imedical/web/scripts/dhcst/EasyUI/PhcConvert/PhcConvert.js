/**
 * 模块:药库
 * 子模块:草药颗粒剂与饮片转换维护
 * 编写日期:2017-08-04
 * 编写人:yunhaibao
 */
var HospId = session['LOGON.HOSPID'];
$(function(){
    InitHospCombo(); //加载医院
	InitDict();
	InitGridConvert();
	$("#btnClose").on("click",function(){
		$('#maintainWin').window("close");
	});
	$("#btnSave").on("click",SaveContent);
	$("#btn-Search").on("click",Query);
});

/// 初始化字典
function InitDict(){
	/// 处方类型
	var options={
		ClassName:"web.DHCST.PhcConvert",
		QueryName:"GetCMPrescType",
		StrParams:HospId,
		mode:"remote",
		onBeforeLoad:function(params){
			params.StrParams=HospId
		}
    }
    $("#cmbPrescType").dhcstcomboeu(options);

	options.editable=false;
	options.onSelect=function(selData){
		$("#cmbFPhcDrg").combogrid("clear");
		$("#cmbFPhcDrg").combogrid("grid").datagrid("options").queryParams.q="";
		$("#cmbFPhcDrg").combogrid("grid").datagrid("reload");
		$("#txtFQty").numberbox("setValue","");
	}
    $("#cmbFPrescType").dhcstcomboeu(options);
	options.onSelect=function(selData){
		$("#cmbTPhcDrg").combogrid("clear");
		$("#cmbTPhcDrg").combogrid("grid").datagrid("options").queryParams.q="";
		$("#cmbTPhcDrg").combogrid("grid").datagrid("reload");
		$("#txtTQty").numberbox("setValue","");
	}
    $("#cmbTPrescType").dhcstcomboeu(options);
    /// 药学项下拉
    options={
	    ClassName:"web.DHCST.PhcConvert",
		QueryName:"QueryPHCDrgMast",
	    columns: [[
			{field:'phcId',title:'phcId',width:100,sortable:true,hidden:true},
			{field:'phcCode',title:'药品代码',width:100,sortable:true},
			{field:'phcDesc',title:'药品名称',width:200,sortable:true}
	    ]],
		idField:'phcId',
		textField:'phcDesc',
		strParams:'needNull',
		width:300,
		mode:"remote",
		pageSize:30, 
		pageList:[30,50,100],  
		pagination:true,
		onBeforeLoad: function(param) {
			var newQ=param.q||"";
			if (newQ==""){
				newQ="needNull";
			}else{
				var curPrescId=$("#cmbPrescType").combobox("getValue")||"";
				newQ=newQ+"|@|"+curPrescId+"|@|"+HospId;
			}
			param.q =newQ;
            param.StrParams =newQ;
        }
    }
    $("#cmbPhcDrg").dhcstcombogrideu(options);
    options.width='null';
	options.onBeforeLoad=function(param){
		var curFPrescId=$("#cmbFPrescType").combobox("getValue")||"";
		var newQ=param.q||"";
		if ((curFPrescId=="")){
			newQ="needNull";
		}else{
			newQ=newQ+"|@|"+curFPrescId+"|@|"+HospId;
		}
		param.q=newQ;
        param.StrParams =newQ;
	}
    $("#cmbFPhcDrg").dhcstcombogrideu(options);
	options.onBeforeLoad=function(param){
		var curTPrescId=$("#cmbTPrescType").combobox("getValue")||"";
		var newQ=param.q||"";
		if ((curTPrescId=="")){
			newQ="needNull";
		}else{
			newQ=newQ+"|@|"+curTPrescId+"|@|"+HospId;
		}
		param.q=newQ;
        param.StrParams =newQ;
	}
    $("#cmbTPhcDrg").dhcstcombogrideu(options);
}

function InitGridConvert(){
	var gridColumns=[[  
		{field:'pcId',title:'pcId',width:100,hidden:true},
        {field:'fromTypeDesc',title:'类型',width:100},
        {field:'fromPhcDesc',title:'药品',width:300},
	    {field:'fromNum',title:'数量',width:100,align:'right'},
	    {field:'toTypeDesc',title:'转换类型',width:100},
        {field:'toPhcDesc',title:'转换药品',width:300},
        {field:'toNum',title:'转换数量',align:'right',width:100}
	]];
	var options={
		ClassName:'web.DHCST.PhcConvert',
		QueryName:'Query',
		queryParams:{
			StrParams:''
		},
	    toolbar:'#gridConvertBar',
        columns:gridColumns,
        rownumbers:false,
        singleSelect:true
        
	}
	$('#gridConvert').dhcstgrideu(options);
}

///查询
function Query(){
	var prescType=$("#cmbPrescType").combobox('getValue')||"";
	if ($.trim($("#cmbPrescType").combobox('getText'))==""){
		prescType="";	
	}
	var phcId=$("#cmbPhcDrg").combobox('getValue')||"";
	if ($.trim($("#cmbPhcDrg").combobox('getText'))==""){
		phcId="";	
	}
	var params=prescType+"^"+phcId+"^"+HospId;
	$('#gridConvert').datagrid({
     	queryParams:{
			StrParams:params 
		}
	});
}

	
/// 维护弹出框
function ButtonEdit(btnId){
	var title="草药处方类型转换系数";
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var seletcted = $("#gridConvert").datagrid("getSelected");
	var rowId="";
	if (modifyType=="A"){
		title=title+"增加";
		var editOptions={
			title:title,
		}
		EditShow(editOptions);
		return;
	}
	if (modifyType=="U"){
		title=title+"修改";
		if(seletcted==null){
	        $.messager.alert('提示',"请选中需要修改的行!","warning");
	        return;
	    }
		var editOptions={
			title:title,
		}
		EditShow(editOptions);
	}
	if (modifyType=="D"){
		if(seletcted==null){
	        $.messager.alert('提示',"请选中需要删除的行!","warning");
	        return;
	    }
	    $.messager.confirm('删除提示', '您确认删除吗?', function(r){
			if (r){	
			    var pcId=seletcted.pcId
				var delRet=tkMakeServerCall("web.DHCST.PhcConvert","DeleteDHCPhcConvert",pcId,HospId)
				if(delRet==0){
					//$.messager.alert("成功提示","删除成功!","info");
					Query();
				}else{
					$.messager.alert("错误提示","删除失败","error");
				}
				return;
			}
	    });
	}
	
}

/// 编辑弹窗
function EditShow(_options){
	var options={
		title: '维护',
	    width: 640,
	    height: 180,
	    shadow: true,
	    modal: true,
	    iconCls: 'icon-edit',
	    closed: true,
	    minimizable: false,
	    maximizable: true,
	    collapsible: true,
	    top:null,
	    left:null,
		onBeforeClose:function(){ 
			ClearContent();
		}
	}
	var optionsNew = $.extend({},options, _options);
	var $modifyWin = $('#maintainWin').window(optionsNew);
	$modifyWin.window('open');
	if ((_options.title).indexOf("修改")>=0){
		var gridSelected=$("#gridConvert").datagrid("getSelected")
		var pcId=gridSelected.pcId;
		$.ajax({
			type:"POST",
			data:"json",
			url:"DHCST.QUERY.JSON.csp?&Plugin=EasyUI.ComboBox"+
			"&ClassName=web.DHCST.PhcConvert"+
			"&QueryName=QueryByRowId"+
			"&StrParams="+pcId,
			error:function(){        
				alert("获取数据失败!");
			},
			success:function(retData){
				SetPhcConValues(retData)
			}
		})	
	}else{
		ClearContent();
	}
}

function SetPhcConValues(retData){
	var jsonData=JSON.parse(retData)[0];
	$("#cmbFPrescType").combobox("setValue",jsonData.cmbFPrescType);
	$("#cmbTPrescType").combobox("setValue",jsonData.cmbTPrescType);
	$("#txtFQty").numberbox("setValue",jsonData.txtFQty);
	$("#txtTQty").numberbox("setValue",jsonData.txtTQty);
	$("#cmbFPhcDrg").combogrid("setValue",jsonData.cmbFPhcDrg);
	$("#cmbTPhcDrg").combogrid("setValue",jsonData.cmbTPhcDrg);
	$("#cmbFPhcDrg").combogrid("setText",jsonData.cmbFPhcDrg_text);
	$("#cmbTPhcDrg").combogrid("setText",jsonData.cmbTPhcDrg_text);
}
function ClearContent(){
	$("#cmbPrescType").combobox("clear").combobox("reload");
	$("#cmbFPrescType").combobox("clear").combobox("reload");
	$("#cmbTPrescType").combobox("clear").combobox("reload");
	$("#txtFQty").numberbox("setValue","");
	$("#txtTQty").numberbox("setValue","");
	$("#cmbFPhcDrg").combogrid("clear");
	$("#cmbTPhcDrg").combogrid("clear");
	$("#cmbFPhcDrg").combogrid("grid").datagrid("options").queryParams.q="";
	$("#cmbTPhcDrg").combogrid("grid").datagrid("options").queryParams.q="";
	$("#cmbFPhcDrg").combogrid("grid").datagrid("reload")
	$("#cmbTPhcDrg").combogrid("grid").datagrid("reload")
	$("#cmbPhcDrg").combogrid("clear");
	$("#cmbPhcDrg").combogrid("grid").datagrid("options").queryParams.q="";

	
}

/// 保存内容
function SaveContent(){
	var selected = $("#gridConvert").datagrid("getSelected");
	var pcId="";
	if (($('#maintainWin').window('options').title).indexOf("增加")>=0){
		pcId="";
	}else{
		pcId=selected.pcId;
	}
	var inputStr=GetSaveConvertList();
	if (inputStr==""){
		return;
	}
	var saveRet= tkMakeServerCall("web.DHCST.PhcConvert","SavePhcConvert",pcId,inputStr);
	var saveArr=saveRet.split("^");
	if (saveArr[0]>0){
		//$.messager.alert("成功提示","保存成功","info");
		$('#maintainWin').window('close');
		Query();		
	}else{
		$.messager.alert("错误提示",saveArr[1],"error");
	}

}

function GetSaveConvertList(){
	var fPrescTypeId=$("#cmbFPrescType").combobox("getValue")||"";
	if (fPrescTypeId==""){
		$.messager.alert("提示","请先选择类型","warning");
		return "";
	}
	var fPhcDrgId=$("#cmbFPhcDrg").combogrid("getValue")||"";
	if (fPhcDrgId==""){
		$.messager.alert("提示","请选择药品","warning");
		return "";
	}
	var fQty=$("#txtFQty").numberbox("getValue")||"";
	if (fQty==""){
		$.messager.alert("提示","请先输入数量","warning");
		return "";	
	}
	if(parseFloat(fQty)<=0){
		$.messager.alert("提示","请先核对数量,不能小于或等于0","warning");
		return "";		
	}
	var tPrescTypeId=$("#cmbTPrescType").combobox("getValue")||"";
	if (tPrescTypeId==""){
		$.messager.alert("提示","请先选择转换类型","warning");
		return "";
	}
	var tPhcDrgId=$("#cmbTPhcDrg").combogrid("getValue")||"";
	if (tPhcDrgId==""){
		$.messager.alert("提示","请选择转换药品","warning");
		return "";
	}
	var tQty=$("#txtTQty").numberbox("getValue")||"";
	if (tQty==""){
		$.messager.alert("提示","请先输入数量","warning");
		return "";	
	}
	if(parseFloat(fQty)<=0){
		$.messager.alert("提示","请先核对数量,不能小于或等于0","warning");
		return "";		
	}
	return fPrescTypeId+"^"+fPhcDrgId+"^"+fQty+"^"+tPrescTypeId+"^"+tPhcDrgId+"^"+tQty+"^"+HospId;

}
function InitHospCombo() {
    var genHospObj = DHCSTEASYUI.GenHospComp({tableName:'DHC_PhcConvert'});
    if (typeof genHospObj === 'object') {
        //增加选择事件
        $('#_HospList').combogrid('options').onSelect = function(index, record) {
            NewHospId = record.HOSPRowId;
            if (NewHospId != HospId) {
                HospId = NewHospId;
				ClearContent();
				//InitDict();
				Query();
            }
        };
    }
}
