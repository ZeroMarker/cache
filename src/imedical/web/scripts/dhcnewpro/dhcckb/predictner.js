//predictner.js
$(function(){
	initPageDefault();
})

var editIndex = undefined,editIndexT =undefined; 

function initPageDefault(){
	
	InitButton();		// 按钮响应事件初始化
	initList();
	initTabooList();
	initCombobox();
	
}
/// 按钮响应事件初始化
function InitButton(){

	$("#submit").bind("click",submit); 
	$("#save").bind("click",saveUsage); 
	$("#submitTaboo").bind("click",submitTaboo); 
	$("#saveTaboo").bind("click",saveTaboo); 

}
function submit(){
	if(editIndex>=0){
		$("#predictList").datagrid('endEdit', editIndex);
		editIndex = undefined;
	}
	text=$("#input").val()
	$('#predictList').datagrid('load',{'text':text,textType:1});
}
function submitTaboo(){
	if(editIndexT>=0){
		$("#tabooList").datagrid('endEdit', editIndexT);
		editIndexT = undefined;
	}
	text=$("#inputTaboo").val()
	$('#tabooList').datagrid('load',{'text':text,textType:2});
}
function saveUsage(){
	if(editIndex>=0){
		$("#predictList").datagrid('endEdit', editIndex);
		editIndex = undefined;
	}

	SaveRuleRow("RuleUsage");
}
function saveTaboo(){
	if(editIndexT>=0){
		$("#tabooList").datagrid('endEdit', editIndexT);
		editIndexT = undefined;
	}
	SaveRuleRow("OtherLib");
}
///实体属性列表
function initList()
{
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: false //设置编辑规则属性
		}
	}
	
	///  定义columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult
		{propId:'',field:'ROW_NUM',title:'关联行',width:50,hidden:true},
		/*
		{propId:72,field:'Library',title:'目录',width:70,
			 formatter:function(value,row){
                            row.Library="用法用量";
                            return row.Library;
                        }
		},*/
		{propId:91,field:'SPECIAL',title:'人群',width:100,editor:textEditor},
		{propId:85,field:'AGE',title:'年龄',width:70,editor:textEditor},
		{propId:74533,field:'DISEASE',title:'疾病',width:100,editor:textEditor},
		{propId:82168,field:'ZHDISEASE',title:'疾病(中)',width:100,editor:textEditor},
		{propId:46,field:'METHOD',title:'用药途径',width:70,editor:textEditor},
		{propId:45,field:'FREQ',title:'频率',width:70,editor:textEditor},
		{propId:49,field:'ONCE_FORM_UNIT',title:'每次用量',width:70,editor:textEditor},
		{propId:48,field:'TREATMENT',title:'疗程',width:70,editor:textEditor},
		{propId:86,field:'WEIGHT',title:'体重',width:70,editor:textEditor},
		{propId:52,field:'DAYS_FORM_UNIT',title:'每日用量',width:70,editor:textEditor},
		{propId:51,field:'MONCE_FORM_UNIT',title:'每次极量',width:70,editor:textEditor},
		{propId:54,field:'MDAYS_FORM_UNIT',title:'每日极量',width:70,editor:textEditor},
		{propId:50,field:'HONCE_FORM_UNIT',title:'每次最大量',width:70,editor:textEditor},
		{propId:53,field:'HDAYS_FORM_UNIT',title:'每日最大量',width:70,editor:textEditor},
		{propId:74698,field:'FLAG',title:'提示标记',width:50,editor:textEditor,
			 formatter:function(value,row){
                            row.FLAG="Y";
                            return row.FLAG;
                        }
		},
		{propId:82,field:'TEXT',title:'提示',width:200,editor:textEditor}
		//{propId:49,field:'ONCE_FORM',title:'每次用量',width:70},
		//{propId:'',field:'ONCE_UNIT',title:'单位',width:50},
		//{propId:52,field:'DAYS_FORM',title:'每日用量',width:70},
		//{propId:'',field:'DAYS_UNIT',title:'单位',width:50},	
		//{propId:51,field:'MONCE_FORM',title:'每次极量',width:70},
		//{propId:'',field:'MONCE_UNIT',title:'单位',width:50},
		//{propId:54,field:'MDAYS_FORM',title:'每日极量',width:70},
		//{propId:'',field:'MDAYS_UNIT',title:'单位',width:50},	
		//{propId:50,field:'HONCE_FORM',title:'每次最大量',width:70},
		//{propId:'',field:'HONCE_UNIT',title:'单位',width:50},
		//{propId:53,field:'HDAYS_FORM',title:'每日最大量',width:70},
		//{propId:'',field:'HDAYS_UNIT',title:'单位',width:50},	
	]];
	
	///  定义datagrid
	var option = {
		nowrap:false,
		//fitColumns:true,
		singleSelect : true,
	    //onDblClickRow: function (rowIndex, rowData) {},	//双击选择行编辑
	    onClickRow: function(rowIndex,rowData){
	 	}, 
	 	onClickCell:onClickCell
	};
	
	var uniturl = "dhcapp.broker.csp?ClassName=web.PredictModel&MethodName=WebServicePredict";
	//var uniturl ="http://127.0.0.1:5000/predict?text="
	new ListComponent('predictList', columns, uniturl, option).Init();
}

function endEditing(){
    if (editIndex == undefined){return true}
    if ($('#predictList').datagrid('validateRow', editIndex)){
        $('#predictList').datagrid('endEdit', editIndex);
        editIndex = undefined;
        return true;
    } else {
        return false;
    }
}
function onClickCell(index, field){
    if (editIndex != index){
        if (endEditing()){
            $('#predictList').datagrid('selectRow', index)
                    .datagrid('beginEdit', index);
            var ed = $('#predictList').datagrid('getEditor', {index:index,field:field});
            if (ed){
                ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
            }
            editIndex = index;
        } else {
            setTimeout(function(){
                $('#predictList').datagrid('selectRow', editIndex);
            },0);
        }
    }
}

function initTabooList()
{
	/// 文本编辑格
	var textEditor={
		type: 'textarea',//设置编辑格式	
		options: {
			required: false //设置编辑规则属性	
		}
	}
	
	///  定义columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult
		{propId:'',field:'ROW_NUM',title:'关联行',width:50,rowspan:2,hidden:true},
		/*
		{propId:72,field:'Library',title:'目录',width:70,rowspan:2,
			 formatter:function(value,row){
                            row.Library="禁忌症";
                            return row.Library;
                        }
		},*/
		{propId:91,field:'SPECIAL',title:'人群',width:100,editor:textEditor}, 
		{propId:93,field:'PROF',title:'职业',width:100,editor:textEditor},
		{propId:85,field:'AGE',title:'年龄',width:70,editor:textEditor},
		{propId:89,field:'SEX',title:'性别',width:50,editor:textEditor},
		{propId:74533,field:'DISEASE',title:'疾病',width:100,editor:textEditor},
		{propId:82168,field:'ZHDISEASE',title:'疾病(中)',width:100,editor:textEditor},
		
		//{title:'过敏',width:50,colspan:4},		
	//],[
		{propId:'74532',field:'DRUG',title:'药品',width:100,editor:textEditor},
		{propId:'42',field:'GENER',title:'通用名',width:100,editor:textEditor},
		{propId:'39',field:'INGR',title:'成分',width:100,editor:textEditor},
		{propId:'259671',field:'CAT',title:'分类',width:100,editor:textEditor},
		{propId:'',field:'ENV',title:'环境',width:100,editor:textEditor},
		{propId:'74959',field:'LABITEM',title:'检验指标',width:100,editor:textEditor},
		{propId:'',field:'FREQ',title:'检验范围值',width:70,editor:textEditor},
		{propId:'',field:'ONCE_FORM',title:'检验套',width:70,editor:textEditor},
		{propId:'74698',field:'FLAG',title:'提示标记',width:50,editor:textEditor,
			 formatter:function(value,row){
                            row.FLAG="Y";
                            return row.FLAG;
                        }
		},
		{propId:82,field:'TEXT',title:'提示',width:200,editor:textEditor},
		{propId:83,field:'CONLEVEL',title:'管理力度',width:70,editor:textEditor},
		{propId:81,field:'LEVELFLAG',title:'管理级别',width:70,editor:textEditor},
		]
		];
	
	///  定义datagrid
	var option = {
		nowrap:false,
		//fitColumns:true,
		singleSelect : true,
	    //onDblClickRow: function (rowIndex, rowData) {},	//双击选择行编辑
	    onClickRow: function(rowIndex,rowData){
	 	}, 
	 	onClickCell:onClickCellT
	};
	
	//var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryDicAttr&params="+params;
	//var uniturl ="http://127.0.0.1:5000/predict?text="
	var uniturl = "dhcapp.broker.csp?ClassName=web.PredictModel&MethodName=WebServicePredict";
	new ListComponent('tabooList', columns, uniturl, option).Init();
}

function endEditingT(){
    if (editIndexT == undefined){return true}
    if ($('#tabooList').datagrid('validateRow', editIndexT)){
        $('#tabooList').datagrid('endEdit', editIndexT);
        editIndexT = undefined;
        return true;
    } else {
        return false;
    }
}
function onClickCellT(index, field){
    if (editIndexT != index){
        if (endEditingT()){
            $('#tabooList').datagrid('selectRow', index)
                    .datagrid('beginEdit', index);
            var ed = $('#tabooList').datagrid('getEditor', {index:index,field:field});
            
            if (ed){
                ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
            }
            editIndexT = index;
        } else {
            setTimeout(function(){
                $('#tabooList').datagrid('selectRow', editIndexT);
            },0);
        }
    }
}


function initCombobox(){
	///模板类型
	$('#drug').combobox({
    	url:LINK_CSP+'?ClassName=web.DHCCKBDicLinkAttr&MethodName=GetDataCombo&DataSource=105&filed:DrugData',
    	lines:true,
		animate:true,
	});	
}
///保存规则
function SaveRuleRowOld()
{
	var TempId=75369;
	var rowsData = $("#predictList").datagrid('getSelected');
	if(rowsData.length<=0||rowsData==null){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataListAll = [];
	var dataList = [];
	var desc="",value="",tmp="";
	value=81224 //药品名称
	desc=$('#drug').combobox("getText");
	if(value==""){
		$.messager.alert("提示","请选择药品!");
		return;
	}
	tmp="" +"^"+desc +"^"+ value +"^"+ TempId +"^"+ 0 ;
	dataList.push(tmp);
	var opts = $('#predictList').datagrid('getColumnFields');
	for(var i=0;i<opts.length;i++){
		var colOpt=$('#predictList').datagrid('getColumnOption',opts[i]);
		if(colOpt.propId==''){continue;};
		value=colOpt.propId;
		desc=rowsData[colOpt.field];
		tmp="" +"^"+desc +"^"+ value +"^"+ TempId +"^"+ 0 ;
		dataList.push(tmp);
		/*
		if(colOpt.field.search("FORM")>0){
			var unit=colOpt.field.replace('FORM','UNIT');
			value=colOpt.propId;
			desc=rowsData[colOpt.field]+rowsData[unit];
			tmp="" +"^"+desc +"^"+ value +"^"+ TempId +"^"+ 0 ;
			dataList.push(tmp);
		}else{
			value=colOpt.propId;
			desc=rowsData[colOpt.field];
			tmp="" +"^"+desc +"^"+ value +"^"+ TempId +"^"+ 0 ;
			dataList.push(tmp);
		}
		*/
	}
	var mListData=dataList.join("$$");
	dataListAll.push(mListData);
	var mListDataAll=dataListAll.join("@@");
	//alert(mListDataAll);
	//保存数据
	//return;
	runClassMethod("web.DHCCKBRuleMaintain","saveAll",{"params":mListDataAll},function(jsonString){
		if (jsonString == 0){
			$.messager.alert('提示','保存成功！','info');
		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
		$('#ruleList').datagrid('reload'); //重新加载			
	});	
}

///保存规则
function SaveRuleRow(libName)
{
	//debugger
	//var TempId=75369; 目录id
	var rowData={}
	var obj="predictList"
	if(libName=="RuleUsage"){
		obj="predictList"
	}
	if(libName=="OtherLib"){
		obj="tabooList"
	}
	rowsData = $("#"+obj).datagrid('getSelected');
	if(rowsData==null){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataListAll = [];
	var dataList = [];
	var desc="",value="",tmp="";
	value=81224 //药品名称
	desc=DrugDesc
	tmp="" +"^"+desc +"^"+ value +"^"+ TempId +"^"+ 0 ; //药品字段
	dataList.push(tmp);
	
	var DrugLibaryID=serverCall("web.DHCCKBRuleText","DrugLibaryDataID",{"dicId":TempId});  		//获取模板绑定的目录的ID和描述
	var array=DrugLibaryID.split("^")
	value=array[0];		//目录ID（73）
	desc=array[1];	//目录描述（适应症）
	tmp="" +"^"+desc +"^"+ value +"^"+ TempId +"^"+ 0 ; //目录模板名字 用法用量、适应症。。
	dataList.push(tmp);
	
	var opts = $("#"+obj).datagrid('getColumnFields');
	for(var i=0;i<opts.length;i++){
		var colOpt=$("#"+obj).datagrid('getColumnOption',opts[i]);
		if(colOpt.propId==''){continue;};
		value=colOpt.propId;
		desc=rowsData[colOpt.field];
		if(desc==""){continue;};
		tmp="" +"^"+desc +"^"+ value +"^"+ TempId +"^"+ 0 ;
		dataList.push(tmp);
	}
	var mListData=dataList.join("$$");
	dataListAll.push(mListData);
	var mListDataAll=dataListAll.join("@@");
	//alert(mListDataAll);
	//保存数据
	runClassMethod("web.DHCCKBRuleText","saveAll",{"params":mListDataAll},function(jsonString){
		if (jsonString == 0){
			if(libName=="RuleUsage"){
				subRuleRow();
			}
			if(libName=="OtherLib"){
				subTabooRow(array[1]);
			}
			//$.messager.alert('提示','保存成功！','info');
		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
		//$('#ruleList').datagrid('reload'); //重新加载			
	});	
}
///保存规则
function subTabooRow(libName)
{
	//debugger
	//alert(TempId+" "+DrugDesc);
	var rowsData = $("#tabooList").datagrid('getSelected');
	if(rowsData==null){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var retData={};
	
	var opts = $('#tabooList').datagrid('getColumnFields');
	for(var i=0;i<opts.length;i++){
		var colOpt=$('#tabooList').datagrid('getColumnOption',opts[i]);
		if(colOpt.propId==''){continue;};
		var value=colOpt.propId;
		var desc=rowsData[colOpt.field];
		retData[value]=desc
	}
	if(libName=="药物过敏" || libName=="配伍禁忌"){
		if(retData['83']==""){
			retData['83']="禁用";
			retData['81']="禁止";
		}
	}else{
		if(retData['83']==""){
			retData['83']="慎用";
			retData['81']="提醒";  //原警示 xww 2021-08-17 改完提醒
		}
	}
	window.parent.addPredictRow(retData);
}
///保存规则
function subRuleRow()
{
	//debugger
	var rowsData = $("#predictList").datagrid('getSelected');
	if(rowsData==null){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var retData={};
	
	var opts = $('#predictList').datagrid('getColumnFields');
	for(var i=0;i<opts.length;i++){
		var colOpt=$('#predictList').datagrid('getColumnOption',opts[i]);
		if(colOpt.propId==''){continue;};
		var value=colOpt.propId;
		var desc=rowsData[colOpt.field];
		retData[value]=desc

	}
	window.parent.addPredictRow(retData);
}