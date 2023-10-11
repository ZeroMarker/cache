/**
	zhouxin
	2019-06-21
	目录优先级
*/
var editRow="";
$(function(){ 
	initTree();
	initDataGrid();
})

function initTree(){
	$('#catalogTree').tree({
    	url:$URL+'?ClassName=web.DHCCKBRulePriority&MethodName=GetDrugLibraryTree&model=tmpquit'+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():""),
    	lines:true,
		animate:true,
		onClick:function(node, checked){
		    $('#datagrid').datagrid('load',{catId:node.id}); 
	    }
	});	
}
function initDataGrid(){
	
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	var levelEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "id",  //w ##class(web.DHCCKBDiction).QueryDicComboboxByID("","102","0")
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+levelDataId+"&parrefFlag=0",
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'RemindLevel'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'RemindLevelId'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	
	var priorityEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "id",
			textField: "text",
			data:[{"id":"Y","text":"是"},{"id":"N","text":"否"}],
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'priority'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	var statusEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "id",
			textField: "text",
			data:[{"id":"Y","text":"是"},{"id":"N","text":"否"}],
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'status'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	
	$('#datagrid').datagrid({
		toolbar:"#toolbar",
		url:LINK_CSP+"?ClassName=web.DHCCKBRulePriority&MethodName=ListRuleDic",
		columns:[[ 
			{field:'dic',hidden:true},
			{field:'dicName',title:'项目',width:150,align:'left'},
			{field:'priority',title:'前提条件',width:50,align:'left',editor:priorityEditor,formatter:FormatterCheck},
			{field:'status',title:'可用',width:50,align:'left',editor:priorityEditor,formatter:FormatterCheck},		
			{field:'RemindMsg',title:'提醒消息',width:50,align:'left',editor:{type:'text'}},
			{field:'RemindLevel',title:'消息级别',width:50,align:'left',editor:levelEditor},
			{field:'RemindLevelId',title:'消息级别id',width:50,align:'left',editor:texteditor,hidden:true}		

		 ]],
		title:'明细',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper', 
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],
		onDblClickRow: function (rowIndex, rowData) {		//双击选择行编辑
           CommonRowClick(rowIndex,rowData,"#datagrid");
           editRow = rowIndex; 
        }
	});
}

function Save(){
	
	var selectTree=$("#catalogTree").tree('getSelected')
	if(selectTree==null){
		$.messager.alert("提示","请选择规则列表!");
		return;
	}
	var catId=selectTree.id;
	
	if(!endEditing("#datagrid")){
		$.messager.alert("提示","请编辑必填数据!");
		return;
	}
	var rowsData = $("#datagrid").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	var del1=String.fromCharCode(1);
	var mindList = [];
	for(var i=0;i<rowsData.length;i++){
		
		var dic=rowsData[i].dic;
		var linkPriorityId=rowsData[i].linkPriorityId;
		var priorityDicId=rowsData[i].priorityDicId;
		//var priorityId=rowsData[i].priorityId;
		var priority=rowsData[i].priority;	// 前提条件
		if (priority == "是"){priority = "Y"}
		if (priority == "否"){priority = "N"}
		if (priority == undefined){priority = ""}
		if (priority != ""){
			var tmpPriorty=linkPriorityId+"^"+catId+"^"+dic+"^"+priorityDicId+"^"+priority;
			dataList.push(tmpPriorty)	
		}
		
		var linkStatusId=rowsData[i].linkStatusId;
		var statusDicId=rowsData[i].statusDicId;
		//var statusId=rowsData[i].statusId;		
		var status=rowsData[i].status;	
		var mindinfo=rowsData[i].RemindMsg;
		if (status == "是"){status = "Y"}
		if (status == "否"){status = "N"}
		if (status == undefined){status = ""}		
		if (status != ""){			
			var tmpstatus=linkStatusId+"^"+catId+"^"+dic+"^"+statusDicId+"^"+status;
			dataList.push(tmpstatus)
		}	
		
		var tmpPriorty=linkPriorityId+"^"+catId+"^"+dic+"^"+priorityDicId+"^"+priority;
		var tmpstatus=linkStatusId+"^"+catId+"^"+dic+"^"+statusDicId+"^"+status;
		
		var remindLevelId = (rowsData[i].RemindLevel=="")?"":rowsData[i].RemindLevelId;
		///组织提醒消息串
		var mindinfoList=catId +"^"+ dic +"^"+ mindinfo +"^"+ "RemindMsg" +"^"+ remindLevelId; // 2022-03-27 增加消息级别 qnp	
		mindList.push(mindinfoList)	
		
	}

	runClassMethod("web.DHCCKBRulePriority","SaveConfigPriority",{"str":dataList.join("$$"),"MindInfoList":mindList.join("$$")},function(data){
		if(data==0){
			$.messager.alert("提示","保存成功!","success");
			$('#datagrid').datagrid('reload'); 
		}else{
			$.messager.alert("提示","保存失败!"+data,"error");	
		}	
	},"text")
	/*
	runClassMethod("web.DHCADVModel","Save",{entity:"User.DHCCKBDicLinkAttr",'params':dataList.join("$$")},function(data){
		if(data==0){
			$.messager.alert("提示","保存成功!");
			$('#datagrid').datagrid('reload'); 
		}else{
			$.messager.alert("提示","保存失败!"+data);	
		}	
	},"text")
	*/
}
///授权  sufan 2020-03-27 新增
function GrantAuth()
{
	var selItem=$("#datagrid").datagrid("getSelected");
	if( selItem == null ){
		$.messager.alert('提示',"请选择要授权的项目！")
		return;
	}
	var hideFlag=1;								//按钮隐藏标识
	var setFlag = "grantAuth";					//授权标识
	var tableName = "DHC_CKBDicLinkAttr";		//授权表
	var dataId = selItem.link;					//数据Id
	
	if($('#win').is(":visible")){return;}  			//窗体处在打开状态,退出
	
	var linkurl = "dhcckb.diclog.csp"+"?HideFlag="+hideFlag+"&DicName="+tableName+"&dataid="+dataId+"&SetFlag="+setFlag+"&ClientIP="+ClientIPAdd+"&CloseFlag=1"+"&Operator="+LgUserID;
	if ("undefined"!==typeof websys_getMWToken){
		linkurl += "&MWToken="+websys_getMWToken();
	}	
	$('body').append('<div id="win"></div>');
	var myWin = $HUI.dialog("#win",{
        iconCls:'icon-write-order',
        title:'添加',
        modal:true,
        width:700,
        height:500,
        content:"<iframe id='diclog' scrolling='auto' frameborder='0' src='"+linkurl+"' "+"style='width:100%; height:100%; display:block;'></iframe>",
        buttonAlign : 'center',
        buttons:[{
            text:'保存',
            id:'save_btn',
            handler:function(){
                GrantAuthItem();                    
            }
        },{
            text:'关闭',
            handler:function(){                              
                myWin.close(); 
            }
        }]
    });
	$('#win').dialog('center');
}
///项目授权
function GrantAuthItem(){
	
	$("#diclog")[0].contentWindow.SaveManyDatas();	// 子页面日志
	$HUI.dialog('#win').close();
}

function FormatterCheck(value){
	
  if(value=="Y"){
	return "<font color='#21ba45'>是</font>"
  }else if(value=="N"){
	return "<font color='#f16e57'>否</font>"
  }else{
    return "";
  }
}
function reloadDatagrid(){}
