// Creator: congyue
/// CreateDate: 2017-12-27
//  Descript: 不良事件升级 导出字典维护
var HospDr="";
var editRow = "",LinkID="";
$(function(){
    InitHosp(); 	//初始化医院 多院区改造 cy 2021-04-09
	initParams();
	
	//initCombobx();
	
	initBindMethod();

	initDatagrid();
	
})	
// 初始化医院 多院区改造 cy 2021-04-09
function InitHosp(){
	hospComp = GenHospComp("DHC_AdvExpFieldLink"); 
	HospDr=hospComp.getValue(); 
	//$HUI.combogrid('#_HospList',{value:"11"})
	hospComp.options().onSelect = function(){///选中事件
		HospDr=hospComp.getValue();
		$('#linkdg').datagrid('reload'); //重新加载
		reloadTopTable(); 
		$('#linkdg').datagrid({
			url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetLinkList&HospDr="+HospDr,
		});	
	}
	$("#_HospBtn").bind('click',function(){
		var rowData = $("#linkdg").datagrid('getSelected');
		if (!rowData){
			$.messager.alert("提示","请选择一条导出模板定义数据！")
			return false;
		}
		GenHospWin("DHC_AdvExpFieldLink",rowData.ID);
	})
}
function initParams(){
	editRow="";	
	inputEditor={type:'validatebox',options:{required:true}};
}

function initBindMethod(){
    $("a:contains('添加元素')").bind('click',addItm);
    $("a:contains('删除元素')").bind('click',delItm);
    $("a:contains('全部选中')").bind('click',selAllItm);
    $("a:contains('取消选中')").bind('click',unSelAllItm);
    $("a:contains('全部删除')").bind('click',delAllItm);
	$("#inslink").bind("click",inslinkRow);
	$("#dellink").bind("click",dellinkRow);
	$("#savelink").bind("click",savelinkRow);
    
}
/* function initCombobx(){
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=";
	var option = {
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			reloadTopTable();
	    }
	};
	
	var url = uniturl+"JsonGetRepotType&HospDr="+HospDr;
	new ListCombobox("reportType",url,'',option).init();
	
} */

function initDatagrid(){
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	/// 表单Combobox
	var FormEditor={  //设置其为可编辑
		//类别 		
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCADVDicContrast&MethodName=jsonForm&HospID="+HospDr,
			required:true,
			//panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#linkdg").datagrid('getEditor',{index:editRow,field:'FormNameDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#linkdg").datagrid('getEditor',{index:editRow,field:'FormNameCode'});
				$(ed.target).val(option.code);
				
				/* ///设置级联指针
				var FormID=option.value;  //元素
				var FormDicDesced=$("#linkdg").datagrid('getEditor',{index:editRow,field:'FormDicDesc'});
				$(FormDicDesced.target).combobox('setValue', "");
				var unitUrl=LINK_CSP+"?ClassName=web.DHCADVFormDicContrast&MethodName=jsonFormDic&FormID="+FormID;
				$(FormDicDesced.target).combobox('reload',unitUrl);
				var FormDicCodeed=$("#linkdg").datagrid('getEditor',{index:editRow,field:'FormDicCode'});
				$(FormDicCodeed.target).val(""); */
				
			}
		}
	}
	var linkcolumns=[[
		{field:'ID',title:'ID',width:80,hidden:true},
		{field:'Code',title:'代码',width:120,editor:inputEditor,hidden:false},
		{field:'Desc',title:'描述',width:120,editor:inputEditor},
		{field:'FormNameCode',title:'表单代码',width:220,editor:textEditor,hidden:true},
		{field:'FormNameDesc',title:'表单名称',width:220,editor:FormEditor}
	]];
	
	$("#linkdg").datagrid({
		title:'导出模板定义',
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetLinkList&HospDr="+HospDr,
		fit:true,
		columns:linkcolumns,
		loadMsg: '正在加载信息...',
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
		pagination:true,
		singleSelect:true,
		onClickRow: function (rowIndex, rowData) {//双击选择行编辑
			LinkID=rowData.ID;
			reloadTopTable();
		},
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) {
            	if(CheckEdit("linkdg",editRow)){
		        	$.messager.alert("提示","请填写必填项信息!"); 
					return false;	    
	            }
            	$("#linkdg").datagrid('endEdit', editRow);
			}
            $("#linkdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
		}
	});	
	
	var columns=[[
		{field:'FormDicID',title:'FormDicID',width:80,hidden:true},
		{field:'DicField',title:'DicField',width:120,hidden:true},
		{field:'DicDesc',title:'全部列',width:200}
	]];
	
	$("#allItmTable").datagrid({
		title:'报告全部列',
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetAllItmByFormID",
		queryParams:{
			LinkID:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		loadMsg: '正在加载信息...',
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});	
	
	var setcolumns=[[
		{field:'RowID',title:'RowID',width:80,hidden:true},
		{field:'FormDicDr',title:'FormDicDr',width:120,hidden:true},
		{field:'DicField',title:'DicField',width:120,hidden:true},
		{field:'DicDesc',title:'导出列',width:200},
		{field:'num',title:'顺序号',width:80},
		{field:'pri',title:'优先级',width:120,
			formatter:function(value,rec,index){
			var a = '<a href="#" mce_href="#" onclick="upclick(\''+ index + '\')">上移</a> ';
			var b = '<a href="#" mce_href="#" onclick="downclick(\''+ index + '\')">下移</a> ';
			return a+b;  
        }  
		,hidden:false}
	]];

	$("#setItmTable").datagrid({
		title:'报告导出列',
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetSetFiel&LinkID="+"",
		fit:true,
		rownumbers:true,
		columns:setcolumns,
		loadMsg: '正在加载信息...',
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});
	$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 
		
}
///添加元素
function addItm(){
	var linkdata = $("#linkdg").datagrid("getSelections");
	if(linkdata.length<1){
		$.messager.alert("提示","未选中导出模板定义数据！");
		return;	    
	}
	LinkID=linkdata[0].ID;
	
	var datas = $("#allItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("提示","未选中报告全部列数据！");
		return;	    
	}
	var dataArray=[],param="";
	for(x in datas){ 
		param = datas[x].DicField;
		dataArray.push(param);
	}
	
	var params = dataArray.join("&&");
	runClassMethod("web.DHCADVEXPFIELD","SaveExpField",{"Params":params,"LinkID":LinkID},
	function(ret){
		if(ret=="0"){
			$.messager.alert("提示","新增成功！");
			reloadTopTable();
		}
	},'text');
	

}
function delItm(){
	var datas = $("#setItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("提示","未选中右侧数据！");
		return;	    
	}
	var dataArray=[],param="";
	for(x in datas){ 
		param = datas[x].RowID;
		dataArray.push(param);
	}
	
	var params = dataArray.join("&&");
	runClassMethod("web.DHCADVEXPFIELD","DelExpField",{"Params":params},
	function(ret){
		if(ret=="0"){
			$.messager.alert("提示","删除成功！");
			reloadTopTable();
		}
	},'text');
}

function delAllItm(){
	$("#setItmTable").datagrid("checkAll");
	delItm();
}
function selAllItm(){
	$("#allItmTable").datagrid("checkAll");
}
function unSelAllItm(){
	$("#allItmTable").datagrid("uncheckAll");
}
//reload 左上表
function reloadAllItmTable(){
	$("#allItmTable").datagrid('load',{
		LinkID:LinkID
	})
}

function reloadSetFielTable(){
	$("#setItmTable").datagrid('load',{
		LinkID:LinkID
	})
}
///刷新 field和fieldVal
function reloadTopTable(){
	reloadSetFielTable();
	reloadAllItmTable();
}

//上移
function upclick(index)
{
	/* var datas = $("#setItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("提示","未选中左侧数据！");
		return;	    
	}
	if(datas.length>1){
		$.messager.alert("提示","只能选择一条左侧数据！");
		return;	    
	}
	var index=$('#setItmTable').datagrid('getRowIndex',datas[0]); */
	
	var newrow=parseInt(index)-1     
	var curr=$("#setItmTable").datagrid('getData').rows[index];
	var currowid=curr.RowID;
	var currordnum=curr.num;
	var up =$("#setItmTable").datagrid('getData').rows[newrow];
	var uprowid=up.RowID;
	var upordnum=up.num;

	var input=currowid+"^"+upordnum+"^"+uprowid+"^"+currordnum ;
	SaveUp(input);
	mysort(index, 'up', 'setItmTable');
	
}
//下移
function downclick(index)
{
	/* var datas = $("#setItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("提示","未选中左侧数据！");
		return;	    
	}
	if(datas.length>1){
		$.messager.alert("提示","只能选择一条左侧数据！");
		return;	    
	}
	var index=$('#setItmTable').datagrid('getRowIndex',datas[0]); */
	
	var newrow=parseInt(index)+1 ;
	var curr=$("#setItmTable").datagrid('getData').rows[index];
	var currowid=curr.RowID;
	var currordnum=curr.num;
	var down =$("#setItmTable").datagrid('getData').rows[newrow];
	var downrowid=down.RowID;
	var downordnum=down.num;

	var input=currowid+"^"+downordnum+"^"+downrowid+"^"+currordnum ;
	SaveUp(input);
	mysort(index, 'down', 'setItmTable');
}
function SaveUp(input,datas)
{
	 /* $.post(url+'?action=UpdEventWorkFlowItmNum',{"input":input},function(data){
	}); */
	runClassMethod("web.DHCADVEXPFIELD","UpdExpFieldNum",{"input":input},
	function(ret){
		reloadTopTable();
	},'text');
	 
}
function mysort(index, type, gridname) {

    if ("up" == type) {

        if (index != 0) {
			var nextrow=parseInt(index)-1 ;
			var lastrow=parseInt(index);
            var toup = $('#' + gridname).datagrid('getData').rows[lastrow];
            var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
            $('#' + gridname).datagrid('getData').rows[lastrow] = todown;
            $('#' + gridname).datagrid('getData').rows[nextrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    } else if ("down" == type) {
        var rows = $('#' + gridname).datagrid('getRows').length;
        if (index != rows - 1) {
		    var nextrow=parseInt(index)+1 ;
			var lastrow=parseInt(index);
            var todown = $('#' + gridname).datagrid('getData').rows[lastrow];
            var toup = $('#' + gridname).datagrid('getData').rows[nextrow];
            $('#' + gridname).datagrid('getData').rows[nextrow] = todown;              
            $('#' + gridname).datagrid('getData').rows[lastrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    }
}


/// 保存编辑行
function savelinkRow(){
	
	if(editRow>="0"){
		$("#linkdg").datagrid('endEdit', editRow);
	}

	var rowsData = $("#linkdg").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	if(editRow>="0"){
		if(CheckEdit("linkdg",editRow)){
        	$.messager.alert("提示","请填写必填项信息!"); 
			return false;	    
        }
		$("#linkdg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if((rowsData[i].FormNameCode=="")){
			$.messager.alert("提示","请填写必填项信息!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].FormNameCode;
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");
	//保存数据
	runClassMethod("web.DHCADVEXPFIELD","SaveExpFieldLink",{"Params":params,"HospDr":HospDr},function(jsonString){

		if ((jsonString == "11")||((jsonString == "12"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			//return;	
		}else if (jsonString !="0"){
			$.messager.alert('提示','保存失败！','warning');
			//return;
		}
		$('#linkdg').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function inslinkRow(){
	
	if(editRow>="0"){
		$("#linkdg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#linkdg").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].aitCode == ""){
			$('#linkdg').datagrid('selectRow',0);
			$("#linkdg").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	if(editRow>="0"){
		if(CheckEdit("linkdg",editRow)){
        	$.messager.alert("提示","请填写必填项信息!"); 
			return false;	    
        }
		$("#linkdg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	var rows = $("#linkdg").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].FormNameCode=="")){
			$.messager.alert("提示","请填写必填项信息!"); 
			return false;
		}
	} 
	$("#linkdg").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', Code:'', Desc:'', FormNameCode:'',FormNameDesc:''}
	});
	$("#linkdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}
//检查编辑行是否编辑完全 2018-07-18 cy
function CheckEdit(id,index){
	var flag=0;
	var editors = $('#'+id).datagrid('getEditors', index); 
	for (i=0;i<editors.length;i++){
		if(((editors[i].type=="validatebox")&&(editors[i].target.val()==""))){  ///|| ((editors[i].type=="text")&&(editors[i].target.val()==""))||((editors[i].type=="combobox")&&(editors[i].target.combobox('getText')==""))
			flag=-1;
			return flag;	
		}
	}
	return flag; 
} 
/// 删除选中行
function dellinkRow(){
	
	var rowsData = $("#linkdg").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCADVEXPFIELD","DelExpFieldLink",{"ID":rowsData.ID},function(jsonString){
					if (jsonString !=0){
						$.messager.alert('提示','删除失败！','warning');
						return;
					}
					$('#linkdg').datagrid('reload'); //重新加载
					LinkID="";
					reloadTopTable();
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
