/**
	xiaowenwu 
	2020-01-15
	药品输出的提示信息
*/
var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "ModelFlag" 	// 实体标记(附加属性值)
var parref = "";
var hospID = "";
var queryType = "drugType";		//sufan 2022-04-28 根据字典或者属性查询数据，默认属性
$(function(){ 

	initPage();			// 初始化界面
	initCombobox();		// 初始化combobox
	initdicTable();		// 初始化药品通用名列表
	initTree();			
	initButton();		//药品通用名查询
		
})

function initPage(){
			
	if (LgHospDesc.indexOf("东华标准") == 0){		// 非标准库不显示按钮
		$("#copy").show();
		$("#copyProp").show();
		$("#export").show();
	}
}

/// 初始化combobox
function initCombobox(){
		
		
	/**取药品属性**/
  	$HUI.combobox("#dicAttr",{
	    url:'',
	    valueField:'value',
		textField:'text',
		panelHeight:"150",
		mode:'remote',
		onSelect:function(option){
			
		}
	})
	
	/// 初始化分类检索框
	var option = {
		panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	        parref = option.value;
	        queryType  = "drugType";
	       	QueryDicList();
	       	var params = parref +"^"+ "LinkProp"; 		//sufan 增加属性2021-12-17
	        var uniturl = $URL+"?ClassName=web.DHCCKBDrugDetail&MethodName=GetDrugAttr&params="+params ;
			$("#dicAttr").combobox('reload',uniturl);  
	    },
		loadFilter:function(data){                
                for(var i = 0; i < data.length; i++){
                    if(data[i].text != "西药" && data[i].text != "中成药" && data[i].text != "中药饮片"){
                        data.splice(i,1);
                        //由于splice函数将data中的某个序号的值删掉了，因此整体数组的顺序会依次向前，如果不-1,会导致部分数据未经过筛选
                        i--;
                    }
                }
                return data;
        },
       onLoadSuccess: function (data) {
	        var data = $("#dicType").combobox("getData");	// 默认选择第一个
	        if (data && data.length > 0) {
	            $("#dicType").combobox("setValue", data[0].value);
	            parref = data[0].value;	
	            //QueryDicList(); 
	            var params = parref +"^"+ "LinkProp"; 		//sufan 增加属性2021-12-17
	            var uniturl = $URL+"?ClassName=web.DHCCKBDrugDetail&MethodName=GetDrugAttr&params="+params ;
				$("#dicAttr").combobox('reload',uniturl);          
	        }
        }
	}; 	
	var url = $URL +"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue+"&drugType="+InitDrugType();
	//var url = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("dicType",url,'',option).init(); 	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
  	$HUI.combobox("#hospId",{
	    url:uniturl,
	    valueField:'value',
		textField:'text',
		panelHeight:"150",
		mode:'remote',
		onSelect:function(option){
			hospID = option.value;
		}
	})	  
	$HUI.combobox("#exportHospId",{
	    url:uniturl,
	    valueField:'value',
		textField:'text',
		panelHeight:"150",
		mode:'remote',
		onSelect:function(option){
			$("#selectdrug").html("");
		}
	})	
	/// 初始化字典类型
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	       ("#selectdrug").html(""); 	           
	    },
	   	loadFilter:function(data){                
                for(var i = 0; i < data.length; i++){
                    if(data[i].text != "西药字典" && data[i].text != "中成药字典" && data[i].text != "中药饮片字典"&& data[i].text != "全局规则字典" && data[i].text != "通用名字典" ){
                        data.splice(i,1);
                        //由于splice函数将data中的某个序号的值删掉了，因此整体数组的顺序会依次向前，如果不-1,会导致部分数据未经过筛选
                        i--;
                    }
                }
                return data;
	   	}
	}; 
	var url = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue=DictionFlag";
	new ListCombobox("exDicType",url,'',option).init(); 
	
	
	/// 初始化字典类型
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	        queryType  = "dictionType";  
	        parref = option.value;	        
	    },
	   	loadFilter:function(data){                
                for(var i = 0; i < data.length; i++){
                    if(data[i].text != "西药字典" && data[i].text != "中成药字典" && data[i].text != "中药饮片字典"&& data[i].text != "处方应付字典"&&data[i].text != "通用名字典" &&data[i].text != "全局规则字典"){
                        data.splice(i,1);
                        //由于splice函数将data中的某个序号的值删掉了，因此整体数组的顺序会依次向前，如果不-1,会导致部分数据未经过筛选
                        i--;
                    }
                }
                return data;
	   	},
	   	onLoadSuccess: function (data) {
	       
        }
	}; 
	var url = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue=DictionFlag";
	new ListCombobox("dictiontype",url,'',option).init(); 
	
	
}


function initTree(){
	$('#ruleTree').tree({
    	url:LINK_CSP+'?ClassName=web.DHCCKBDrugDetail&MethodName=GetDrugLibraryTree',
    	lines:true,
		animate:true,
		checkbox:true,
		onClick:function(node, checked){

	    }, 
	    onContextMenu: function(e, node){
			
			e.preventDefault();
			/*var node = $("#ruleTree").tree('getSelected');
			if (node == null){
				$.messager.alert("提示","请选中节点后重试!"); 
				return;
			}*/
			$(this).tree('select', node.target);			
			console.log(node) 
			// 显示快捷菜单
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		}
	});
}

function initdicTable(){
	$('#dicTable').datagrid({
		toolbar:"#toolbar", //var uniturl = $URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetDicInstanceByParref&extraAttr="+"DataSource"+"&parref="+parref+"&params="+params;
		url:$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetDicInstanceByParref&extraAttr="+"DataSource"+"&parref="+parref+"&params="+""+"&drugType="+InitDrugType()+"&hospId=",
		//url:LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+DrugData,
		columns:[[ 
		/* 	{field:'ID',hidden:true},
			{field:'CDParrefDesc',title:'类型',width:100,align:'center'},		
			{field:'CDCode',title:'代码',align:'center',hidden:true},
			{field:'CDDesc',title:'药品名称',width:350,align:'left'} */
			{field:'dicID',title:'rowid',hidden:true},
			{field:'parref',title:'父节点id',width:100,align:'left',hidden:true},
			{field:'parrefDesc',title:'类型',width:100,align:'left'},
			{field:'dicCode',title:'代码',width:200,align:'left',hidden:true},
			{field:'dicDesc',title:'描述',width:350,align:'left'},
			{field:'idList',title:'idList',width:50,align:'left',hidden:true}
	
		 ]],
		title:"药品列表",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper', 
		border:false,
		fit:true,
		fitColumns:true,
		singleSelect:false,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],
		onClickRow: function (rowIndex, rowData) {
			//$('#indicTable').datagrid('load', {dic: rowData.ID});
			//$('#dirTable').datagrid('load', {dic: rowData.ID});
			dataGridDBClick(rowData);
        },
        onLoadSuccess:function(data){
	        if(data.rows.length>0){
				//dataGridDBClick(data.rows[0])
		    }
	    },
        displayMsg: '共{total}记录'
	});
		
}	

function dataGridDBClick(rowData){
		
	    $("#ruleTree").tree("options").url=LINK_CSP+'?ClassName=web.DHCCKBDrugDetail&MethodName=GetDrugLibraryTree&dic='+rowData.dicID;
		$('#ruleTree').tree('reload');
		
}

function initButton(){
	/// 代码.描述查询
	//$("#code,#desc").bind("keypress",QueryDicList);	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		QueryDicList();
	    }	   
	});

	$("#copy").bind("click",copyRule);	// 复制规则
	
	$("#copyProp").bind("click",CopyProp);	// 复制属性 qunianpeng 2020-04-16
	
	$("#find").bind("click",QueryDicList);	// 查询
	
	$("#export").bind("click",ExportWin);	// 导出  qnp 2021/07/13
	
	$("#exportReset").bind("click",ExportReset);	// 重置 qnp 2021/07/13
}


function QueryDicList(){
	
	var params = $HUI.searchbox("#queryCode").getValue() +"^" +$("#dicAttr").combobox("getValue") + $("#dictiontype").combobox("getValue");
	$('#dicTable').datagrid('load',{
		extraAttr:"DataSource",
		parref:parref,
		params:params,
		hospId:hospID,
		queryType:queryType
		//id:DrugData,
		//parDesc:params	
	}); 
}

/// 关闭规则
function CloseRule(){
	
	var ruleArr=[];
	var node = $("#ruleTree").tree('getSelected');
	if (node.ruleId === undefined){		// 叶子节点
		for (i=0;i<node.children.length;i++){
			var leaf=node.children[i];
			if (leaf.ruleId != undefined){
				ruleArr.push(leaf.ruleId);
			}
		}
		
	}
	else{	// 规则节点	
		ruleArr.push(node.ruleId)
	}
	
	var ruleStr=ruleArr.join("^");
	var tableName = "DHC_CKBRuleData";
	var setFlag = "stop";
	var hideFlag = 1;	
	
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="win"></div>');
	var myWin = $HUI.dialog("#win",{
        iconCls:'icon-write-order',
        //resizable:true,
        title:'添加',
        modal:true,
        width:500,
        height:600,
        content:"<iframe id='diclog' scrolling='auto' frameborder='0' src='dhcckb.diclog.csp"+"?HideFlag="+hideFlag+"&DicName="+tableName+"&dataid="+ruleStr+"&SetFlag="+setFlag+"&Operator="+LgUserID+"&type=acc"+"&ClientIP="+ClientIPAdd+ "' "+"style='width:100%; height:100%; display:block;'></iframe>",
        buttonAlign : 'center',
        buttons:[{
            text:'保存',
            id:'save_btn',
            handler:function(){
                Save(ruleStr);                    
            }
        },{
            text:'关闭',
            handler:function(){                              
                myWin.close(); 
            }
        }],
        onClose:function(){

        },
        onLoad:function(){
	    
	    },
	    onOpen:function(){
	    }
    });
	$('#win').dialog('center');
	
}

/// 存储授权
function Save(ruleStr){
	
	//var scope=$("#diclog").contents().find("#scope").combobox("getValue");	// 作用域
	//$("#diclog").contents().find("#dicname").val(); //	 获取元素
	//$("#diclog")[0].contentWindow.test;		// 获取变量
	//$("#diclog")[0].contentWindow.test();	// 获取方法
	var scope=$("#diclog")[0].contentWindow.SAtypeID;	// 作用域	
	if (scope == "D"){	// 全院
		// 更改状态	
		runClassMethod("web.DHCCKBDrugDetail","CloseRule",{"ruleStr":ruleStr,"userId":LgUserID,"status":"CancelRelease"},function(jsonString){
			if (jsonString!=0 ){
				$.messager.alert('提示','关闭失败','info');			
			}
		});
	}
	
	$("#diclog")[0].contentWindow.SaveManyDatas();	// 子页面日志
}


///	Desc:	复制规则 
/// Author:	qunianpeng 
/// Date:	2020-03-13
function copyRule(){

	var rowsData = $("#dicTable").datagrid('getSelections');
	if(rowsData.length<=0){
		$.messager.alert("提示","请选择一行数据!","info");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		dataList.push(rowsData[i].dicID);
	} 
	var dicStr=dataList.join("&&");
	//var userInfo=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
	
	$.messager.confirm("提示", "您确定要复制这些数据吗？", function (res) {	// 提示是否删除
		if (res) {
			//保存数据
			runClassMethod("web.DHCCKBDrugDetail","CopyDrugRule",{"dicStr":dicStr,"userInfo":LoginInfo,"clientIP":ClientIPAdd},function(jsonString){
				
				if (jsonString == 0){
					$.messager.alert('提示','复制成功','info');
				}else{
					$.messager.alert('提示','复制失败,失败代码:'+jsonString,'warning');
				}
				QueryDicList();
			});
		}
	});	
}


/// Author: qunianpeng 
/// Time:	2020-04-16
/// Desc:	复制属性 
function CopyProp(){
	
	var rowsData = $("#dicTable").datagrid('getSelections');
	if(rowsData.length<=0){
		$.messager.alert("提示","请选择一行数据!","info");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		dataList.push(rowsData[i].dicID);
	} 
	var dicStr=dataList.join("&&");
	
	if($('#propWin').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="propWin"></div>');
	var myWin = $HUI.dialog("#propWin",{
        iconCls:'icon-write-order',
        //resizable:true,
        title:'添加',
        modal:true,
        width:600,
        height:500,
        content:"<iframe id='copypropFrame' scrolling='auto' frameborder='0' src='dhcckb.copyprop.csp"+"?dicStr="+dicStr+"&parref="+parref+  "' "+"style='width:100%; height:100%; display:block;'></iframe>",
        buttonAlign : 'center',
        buttons:[{
            text:'保存',
            id:'save_btn',
            handler:function(){
                SaveCopyProp();  
                myWin.close();                   
            }
        },{
            text:'关闭',
            handler:function(){                              
                myWin.close(); 
            }
        }],
        onClose:function(){

        },
        onLoad:function(){
	    
	    },
	    onOpen:function(){
	    }
    });
	$('#propWin').dialog('center');
	
}

/// Author: qunianpeng 
/// Time:	2020-04-16
/// Desc:	存储复制的规则 
/// 
function SaveCopyProp(){
	
	$.messager.confirm("提示", "您确定要复制这些数据吗？", function (res) {	// 提示是否删除
		if (res) {
			var ret=$("#copypropFrame")[0].contentWindow.CopyPropValue();	// 子页面保存方法	
			if (ret == 0){
				$.messager.alert('提示','复制成功','info');
			}else{
				$.messager.alert('提示','复制失败,失败代码:'+ret,'warning');
			}
		}
	});	
	
}

function reloadDatagrid(){

}

/// 药品类型
function InitDrugType(){	

	var drugType = getParam("DrugType");	
	return drugType;
}

/// Author: qunianpeng 
/// Time:	2021-07-13
/// Desc:	规则导出
function ExportWin(){
	
	CleanExportMsg();
	/* 选择的药品 */	
	var rowsData = $("#dicTable").datagrid('getSelections');
	/* if(rowsData.length<=0){
		$.messager.alert("提示","请选择一行数据!","info");
		return;
	} */	
	var dataList = [],dataNameList =[];
	for(var i=0;i<rowsData.length;i++){
		dataList.push(rowsData[i].dicID);
		dataNameList.push(rowsData[i].dicDesc);
	} 
	var dicStr=dataList.join("^");
	$HUI.dialog("#exportWin").open();
	
	var subhtmls =""
	var $tdstyle  = 'padding:10px;';	
	
	if (dataNameList.length>0){	
		var tipHtml = "<p style='font-weight:bold'>您已经选择以下药品,点击导出按钮,导出数据,也可以重新选择条件,导出数据。</p>"	
		var tablehtml = "<table>"
		var trhtml = ""
		for (var i=0; i<dataNameList.length; i++){	
			trhtml = trhtml +"<tr>" +'<td style='+$tdstyle+'><span>'+dataNameList[i]+'</span> </td>' + "</tr>";	
			/*if((i+1)%2 == 1){  
				subhtmls = subhtmls + '<tr>';
			}
			subhtmls = subhtmls + '<td><span style="'+spanleft+'">'+dataNameList[i]+'</span> </td>';						    
			if((i+1)%2 == 0){
			   	subhtmls = subhtmls + '</tr>';
			}*/				
		}
		tablehtml = tablehtml +trhtml + "</table>";
		$("#selectdrug").html(tipHtml+tablehtml)
	}
	
}

/// 重置查询条件
function ExportReset(){

	$HUI.combobox("#exDicType").setValue("");
	$HUI.combobox("#exportHospId").setValue("");
	$HUI.datebox("#exStDate").setValue("");
	$HUI.datebox("#exendDate").setValue("");
	
}

/// 导出数据
function Export(extype){
	CleanExportMsg();
	var stDate = $HUI.datebox("#exStDate").getValue();
	var endDate = $HUI.datebox("#exEndDate").getValue();
	var hospDesc = $HUI.combobox("#exportHospId").getText();
	var dicType = $HUI.combobox("#exDicType").getValue();

	/* 选择的药品 */	
	var rowsData = $("#dicTable").datagrid('getSelections');
	var dataList = []
	for(var i=0;i<rowsData.length;i++){
		dataList.push(rowsData[i].dicID);	
	} 
	var dicStr=dataList.join("^");
	if ((dicStr=="")&&(hospDesc=="")&&(dicType=="")&&(stDate=="")){
		$.messager.alert('提示','请至少选择一个药品,或者选择一个导出条件！','info');
		retrun;	
	}
		
	if ((extype == "all")||(extype == "know")){
		if ((dicStr=="")&&(hospDesc=="")&&(dicType=="")&&(stDate!="")){
			$.messager.alert('提示','知识数据导出不支持单一时间条件,请选择更多条件！','info');
			retrun;
		}
	}
	
	//选择的规则序号
	var idList = []
	var selItems = $("#ruleTree").tree('getChecked');
	for(var i=0;i<selItems.length;i++){
		var id = selItems[i].ruleId;
		idList.push(id);
	}
	var nodeList = idList.join("^");
	runClassMethod("web.DHCCKBUpdateManage","Export",{"stDate":stDate, "endDate":endDate, "userId":LgUserID, "hosp":hospDesc, "extype":extype, "drugStr":dicStr, "dataId":dicType,"nodeList":nodeList},function(data){
		$("#exportPath").html("<p style='font-weight:bold'>"+data+"</p>");		
	},"text",false);
	

}

function onChangeDate(){
	$("#selectdrug").html("");
}

function CleanExportMsg(){
	$("#exportPath").html("");
	$("#selectdrug").html("");

}