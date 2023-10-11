/**
  *sufan 
  *2019-06-18
  *附加属性维护
  *
 **/
 
var editRow = 0; editsubRow=0;
var CatId = getParam("parref");    //实体ID
var RangeId=CatId;
var extraAttr = "KnowType";			// 附加属性-知识类型
var extraAttrValue = "ModelFlag" 	// 实体标记(附加属性值)
/// 页面初始化函数
function initPageDefault(){

	initDataGrid();      /// 页面DataGrid初始定义
	initBlButton();      /// 页面 Button 绑定事件
	initCombobox();		 /// 初始化combobx
}

/// 页面DataGrid初始定义
function initDataGrid(){
	
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	var Attreditor={  
		type: 'combobox',	//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'AttrDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDr'});
				$(ed.target).val(option.value);
			},
			onShowPanel:function(){
				
				var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrCode'});
				var AddAttrID = $(ed.target).val();
				///设置级联指针
				var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'AttrDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAttrValue&AddAttrID="+ AddAttrID;
				$(ed.target).combobox('reload',unitUrl);
			}
		 }
	}

	///  定义columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult"
		{field:'ID',title:'ID',width:50,editor:textEditor,hidden:true},
		{field:'DLADicDr',title:'实体ID',width:100,hidden:true},
		{field:'DLAAttrCode',title:'属性id',width:150,hidden:true},
		{field:'DLAAttrCodeDesc',title:'附加属性',width:200},	
		{field:'DLAAttrDr',title:'属性值id',width:80,editor:textEditor,hidden:true},	
		/* {field:'DLAAttrDesc',title:'属性值描述',width:200,editor:Attreditor},	 */	
		{field:'DLAAttrDesc',title:'属性值描述',width:300,editor:textEditor,showTip:true},
		{field:'DLAResult',title:'备注',width:200,editor:textEditor,hidden:true},
		{field:'DLAAttr',title:'DLAAttr',width:200,hidden:true}
		
	]];
	
	///  定义datagrid
	var option = {
		singleSelect : true,
	    onClickRow: function (rowIndex, rowData) {		//单机击选择行编辑
           if (rowIndex != ""||rowIndex == 0) {    //wangxuejian 2021-05-21  关闭编辑行 
                $("#addattrlist").datagrid('endEdit', editsubRow); 
            } 
        },
        onDblClickRow: function (rowIndex, rowData) {		//双击选择行编辑
        
           //数据源
           var DataSource = serverCall("web.DHCCKBRangeCat","GetAddAttrSource",{"queryDicID":rowData.DLAAttrCode,"AttrLinkCode":"DataSource","AttrId":CatId});		//数据源
          
           //数据类型
           var DataType = serverCall("web.DHCCKBRangeCat","GetAddAttrCode",{"queryDicID":rowData.DLAAttrCode,"AttrLinkCode":rowData.DLAAttr,"AttrId":CatId});		//取数据类型
           var e = $("#addattrlist").datagrid('getColumnOption', 'DLAAttrDesc');
           var multiplevalue=false;
          
           if(rowData.DLAAttr =="DataSource"){multiplevalue=true;}
           if((DataType == "combobox")){
	            e.editor = {type:'combobox',
						  options:{
							valueField:'value',
							textField:'text',
							multiple:multiplevalue,
							onSelect:function(option) {
								// 若下拉框中已经从后台加载了值,选中时会被重复选中							
								var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDesc'});
								var selVal = $(ed.target).combobox('getValues');
								var setValArr = [];									
								if (selVal.indexOf(option.text) != -1){ //存在
									for (i=0;i<selVal.length-1;i++){
										if (selVal[i] != option.value){
											setValArr.push(selVal[i] );
										}										
									}							
									$(ed.target).combobox('setValues', setValArr); 
								}
								/* var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDesc'});
								$(ed.target).combobox('setValue', option.text); 
								
								var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDr'});
								$(ed.target).val(option.value);  */	
							}, 
						  	onShowPanel:function(){
								var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDesc'});
								
								var unitUrl = $URL+'?ClassName=web.DHCCKBRangeCat&MethodName=GetDataCombo&DataSource='+DataSource+'&dicCode='+rowData.DLAAttr
							
								$(ed.target).combobox('reload',unitUrl);
						    }	  
						}
				 }
				if (editRow != ""||editRow === 0) { 
            		$("#addattrlist").datagrid('endEdit', editRow); 
        		} 
           		$("#addattrlist").datagrid('beginEdit', rowIndex); 
	       }else if(rowData.DLAAttr=="OrderNum"){ 
	       		 e.editor = {type:'text'}
		         if (editRow != ""||editRow === 0) { 
                	 $("#addattrlist").datagrid('endEdit', editRow); 
            	 } 
            	 $("#addattrlist").datagrid('beginEdit', rowIndex); 
		        
		   }else if(DataType=="textarea"){ 
	       		 e.editor = {type:'text'}
		         if (editRow != ""||editRow === 0) { 
                	 $("#addattrlist").datagrid('endEdit', editRow); 
            	 } 
            	 $("#addattrlist").datagrid('beginEdit', rowIndex); 
		        
		   }else
		   {
			    ShowAllData();
		   }
		        var editors = $('#addattrlist').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 失去焦点关闭编辑行                
                for (var i = 0; i < editors.length; i++)   
                  {  
                    var e = editors[i]; 
                    $(e.target).bind("blur",function()
              	    { 
              	     $("#addattrlist").datagrid('endEdit', rowIndex); 
              	    })
                 }
             editsubRow = rowIndex 
             editRow=rowIndex;  
           }
            
	    };
	      
	var params=CatId +"^"+ extraAttr +"^"+"ExtraProp"+"^"+"";  //拼接 code为空
	var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAddLinkAttr&params="+params;
	new ListComponent('addattrlist', columns, uniturl, option).Init();
}

/// 页面 Button 绑定事件
function initBlButton(){
	
	
	///  保存
	//$('#save').bind("click",saveRow);
	
	//$('#link').bind("click",LinkPropWin);
	
	$("#reset").bind("click",InitPageInfo);	// 重置
	
	///属性检索
	$('#attrtreecode').searchbox({
		searcher : function (value, name) {
			var searcode=$.trim(value);
			findattrTree(searcode);
		}
	});

	///字典检索
	$('#dictreecode').searchbox({
		searcher : function (value, name) {
			var searcode=$.trim(value);
			finddicTree(searcode);
		}
	});
	
	///实体
	$('#entityCode').searchbox({
	    searcher:function(value,name){
	   		QueryWinDicList();
	    }	   
	});
	
	///附加属性  
	$('#addattrcode').searchbox({
	    searcher:function(value,name){
	   		serchAddattr()
	    }	   
	});
}

/// 悬浮diag（不用）
function dataGridBindEnterEvent(index){
	editRow=index;
	var editors = $('#addattrlist').datagrid('getEditors', index);

	for(var i=0;i<editors.length;i++){
		var workRateEditor = editors[i];
		
		//属性值 DLAAttrDesc
		if(workRateEditor.field=="DLAAttrDesc"){
			workRateEditor.target.mousedown(function(e){
				var ed=$("#addattrlist").datagrid('getEditor',{index:index, field:'DLAAttrDesc'});		
				var input = $(ed.target).val();
				divComponent({tarobj:$(ed.target),htmlType:"tree",width: 400,height: 260},function(obj){
					var ed=$("#addattrlist").datagrid('getEditor',{index:index, field:'DLAAttrDr'});		
					$(ed.target).val(obj.id);				
				})				
			});
		}else{
			workRateEditor.target.mousedown(function(e){
					$("#win").remove();;
			});
			workRateEditor.target.focus(function(e){
					$("#win").remove();;
			});
		}
	}
}

/// 
function LinkPropWin(){
	var linkUrl = "dhcckb.property.csp"
	if ("undefined"!==typeof websys_getMWToken){
		linkUrl += '?MWToken='+websys_getMWToken(); 
	}
	///window.location.href="dhcckb.property.csp";
	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'"></iframe>';

	if($('#editProp').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="editProp"></div>');
	$('#editProp').window({
		title:"属性维护",
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		//maximized:true,
		//maximizable:true,
		width:800,
		height:500
	});	

	$('#editProp').html(openUrl);
	$('#editProp').window('open');
}



//核心,单选控制
function treeSingleCheckCtrl(node, checked) {
    var elementId = 'attrtree';		//元素ID
    if (checked) {
        var allCheckedNodes = $('#' + elementId).tree("getChecked");
        for (var i = 0; i < allCheckedNodes.length; i++) {
            var tempNode = allCheckedNodes[i];
            if (tempNode.id != node.id) {
                $('#' + elementId).tree('uncheck', tempNode.target);
            }
        }
        $('#attrtree').tree('select', node.target);
    }

}

//核心,选中同时勾选
function treeSelectCheckCtrl(node) {
    var elementId = 'attrtree';		//元素ID 
   	$('#' + elementId).tree('check', node.target);

}

/// 数据集合（全集）
function ShowAllData(){

	var attrrow = $('#addattrlist').datagrid('getSelected');	// 获取选中的行  
	if ($g(attrrow) == ""){
		$.messager.alert('提示','请选择一个附加属性进行维护！','info');
		return;
	}
	$("#myWin").show();
	
	SetTabsInit();
      
    var myWin = $HUI.dialog("#myWin",{
        iconCls:'icon-w-save',
        resizable:true,
        title:'添加属性值',
        modal:true,
        //left:400,
        //top:150,
        buttonAlign : 'center',
        buttons:[{
            text:'保存',
            id:'save_btn',
            handler:function(){
                SaveFunLib();                    
            }
        },{
            text:'关闭',
            handler:function(){                              
                myWin.close(); 
            }
        }],
        onClose:function(){

        }
    });
	$('#myWin').dialog('center');
	$('#tabOther').tabs('select',0);  
	
	var extraAttrValue = "AttrFlag" 	// 字典标记(附加属性值)
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	
	$("#attrtree").tree('options').url =(uniturl);
	$("#attrtree").tree('reload');
	
	
	$('#tabOther').tabs({
		onSelect:function(title){
			if (title == "属性"){
				var extraAttrValue = "AttrFlag" 	// 字典标记(附加属性值)
				var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
				
				$("#attrtree").tree('options').url =(uniturl);
				$("#attrtree").tree('reload');
				
			}else if(title == "字典"){
				var extraAttrValue = "DictionFlag" 	// 字典标记(附加属性值)
				var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+extraAttrValue;

				$("#dictree").tree('options').url =(uniturl);
				$("#dictree").tree('reload');
				$("#entitygrid").datagrid("unselectAll");
				
			}else if (title == "实体"){			  	
				var extraAttrValue = "ModelFlag" 	// 字典标记(附加属性值)
				var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params=";

				$("#entitygrid").datagrid('options').url =(uniturl);
				$("#entitygrid").datagrid('reload');	
			}
		}
	});
}


/// 初始化tabs中的数据表格
function SetTabsInit(){

	var extraAttrValue = "AttrFlag" 	// knowledge-属性
	// 属性
	var myAttrTree = $HUI.tree("#attrtree",{
		url:"", //$URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue,
   		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  //是否级联检查。默认true  菜单特殊，不级联操作
		animate:false     	//是否树展开折叠的动画效果
		//onCheck: treeSingleCheckCtrl,//核心,单选控制
		//onSelect:treeSelectCheckCtrl	//核心,单选控制		
	});
	//$("#attrtree").tree('options').url =(url);
	//$("#attrtree").tree('reload');
		
	// 字典
	var extraAttrValue = "DictionFlag" 	// knowledge-属性
	// 属性
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+extraAttrValue;
	var DicTree = $HUI.tree("#dictree",{
		url:uniturl, 
   		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  		//是否级联检查。默认true  菜单特殊，不级联操作
		animate:false,    			//是否树展开折叠的动画效果
		onClick:function(node, checked){
	    	
	    },
	    onLoadSuccess: function(node, data){
			if (node != null){
				$('#dictree').tree('expand', node.target);
			}
		}
			
	}); 
  
    // 实体
	var entitycolumns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'代码',width:200,align:'left'},
			{field:'CDDesc',title:'描述',width:300,align:'left'}			
		 ]]		 
	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90]	
		  
	}
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params=";
	new ListComponent('entitygrid', entitycolumns, uniturl, option).Init();

}

/// 保存
function SaveFunLib(){

	var currTab = $('#tabOther').tabs('getSelected');
	var currTabTitle = currTab.panel('options').title;
	var selectID=""
	var selectDesc=""
	var dataList=[];
	var Param="";
	if (currTabTitle.indexOf("属性")!=-1){					// 选择属性
		var attrrow = $('#attrtree').tree('getChecked');	// 获取选中的行  
		for (var i=0;i<attrrow.length;i++){
			selectID = $g(attrrow)==""?"":attrrow[i].id;
			selectDesc =  $g(attrrow)==""?"":attrrow[i].code;
			dataList.push(selectID);
		}
		Param=dataList.join("$");
	}else if(currTabTitle.indexOf("字典") != -1){				// 选择字典
	
		var dicrow =$('#dictree').tree('getChecked');	// 获取选中的行
		for (var i=0;i<dicrow.length;i++){
			selectID = $g(dicrow)==""?"":dicrow[i].id;
			selectDesc =  $g(dicrow)==""?"":dicrow[i].code;
			dataList.push(selectID);
		}
		Param=dataList.join("$");
	}else if(currTabTitle.indexOf("实体") != -1){				// 选择实体
	
		var entityrow =$('#entitygrid').datagrid('getSelected'); // 获取选中的行  
		selectID = $g(entityrow)==""?"":entityrow.ID;
		selectDesc =  $g(entityrow)==""?"":entityrow.CDDesc;
		dataList.push(selectID);
		Param=dataList.join("$");
	}

	if ($g(selectID) == ""){	
		 $.messager.alert('提示','请选择一个属性或字典或实体！','info');
		 return;	
	} 
	
	/// 附加属性界面赋值
	$('#addattrlist').datagrid('beginEdit', editRow);	
	//var attrDescObj=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDesc'});
	//$(attrDescObj.target).val(selectDesc);
	//var attrDrObj=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDr'});
	//$(attrDrObj.target).val(selectID);
	//$('#addattrlist').datagrid('endEdit', editRow);
	SaveLinkAttr(Param,2)
	//saveRow();

	//$HUI.dialog("#myWin").close();
}


///保存
function saveRow()
{
	// 使用此方法保存时，需要datagrid的列名和表字段名称相同，修改时ID默认固定
	comSaveByDataGrid("User.DHCCKBDicLinkAttr","#addattrlist",function(ret){
			if(ret=="0")
			{
				$('#myWin').dialog('close');
				$("#addattrlist").datagrid('reload');
			}
					
		}
	)	
}

/// 删除
function DelLinkAttr(){

	//removeCom("User.DHCCKBDicLinkAttr","#addattrlist")
	var rowsData = $("#addattrlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		if((rowsData.DLAAttrDr=="")||(rowsData.DLAAttrDr === undefined)){
			//$.messager.alert('提示','没有数据，不需要删除','warning');
			return;
		}
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBRangeCat","CancelAddAttr",{"EntyId":CatId,"AddAttrList":rowsData.DLAAttrCode},function(jsonString){
					if(jsonString!=0){
						$.messager.alert('提示',"ErrMsg:"+jsonString,"warning")
					}else{
						window.parent.reloadPagedg();
					}
					$('#addattrlist').datagrid('reload'); 
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
///检索属性树
function findattrTree(searcode)
{
	var extraAttrValue = "AttrFlag" 	// 字典标记(附加属性值)
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	$("#attrtree").tree('options').url =encodeURI(uniturl);
	$("#attrtree").tree('reload');
}
///属性清屏
function RefreshData()
{
	$HUI.searchbox("#attrtreecode").setValue("");
	var searcode=$HUI.searchbox("#attrtreecode").getValue();
	var extraAttrValue = "AttrFlag"
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	$("#attrtree").tree('options').url =encodeURI(uniturl);
	$("#attrtree").tree('reload');
}
///检索字典树
function finddicTree(searcode)
{
	var extraAttrValue = "DictionFlag" 	// 字典标记(附加属性值)
	var dictype = $("#dictype").combobox("getValue");
	/* if(searcode==""){
		var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+extraAttrValue;
	}else{
		var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	} */
	dictype = dictype==""?0:dictype;
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id='+dictype+'&extraAttr='+extraAttr+'&extraAttrValue='+extraAttrValue+"&queryCode="+searcode;
	$("#dictree").tree('options').url =encodeURI(uniturl);
	$("#dictree").tree('reload');
}
///属性清屏
function Refreshdic()
{
	$HUI.searchbox("#dictreecode").setValue("");
	$HUI.combobox("#dictype").setValue("");
	
	var extraAttrValue = "DictionFlag"
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+extraAttrValue;
	$("#dictree").tree('options').url =encodeURI(uniturl);
	$("#dictree").tree('reload');
}
// 实体查询
function QueryWinDicList()
{
	var params = $HUI.searchbox("#entityCode").getValue();
	
	$('#entitygrid').datagrid('load',{
		extraAttr:extraAttr,
		extraAttrValue:extraAttrValue,
		params:params
	}); 
}
// 重置
function InitPageInfo(){
	$HUI.searchbox('#entityCode').setValue("");
	QueryWinDicList();	
	$("#div-img").show();

}
///保存附加属性可编辑的行 2019-11-27
function SaveLinkAttr(Param,flag)
{
	if(editRow>="0"){
		$("#addattrlist").datagrid('endEdit', editRow);
	}
	var dataList = [];
	if(Param=="0"){
		
		var rowsData = $("#addattrlist").datagrid('getChanges');
		if(rowsData.length<=0){
			$.messager.alert("提示","没有待保存数据!",'info');
			return;
		}
		if (rowsData.length == 1){
			if(rowsData[0].DLAAttrDesc==""){
				$.messager.alert("提示","保存数据不能为空！如需删除，请点击删除按钮",'info',function(){
					$('#addattrlist').datagrid('reload'); 
				}); 				
				return;
			}
		}		
		for(var i=0;i<rowsData.length;i++){
		
			/*if(rowsData[i].DLAAttrDesc==""){
				$.messager.alert("提示","可编辑数据不能为空！"); 
				return false;
			}*/
			var IdList=serverCall("web.DHCCKBRangeCat","GetAttrIdList",{"ItmList":rowsData[i].DLAAttrDesc,'AddAttr':$g(rowsData[i].DLAAttrCode)});
			var dataId=IdList.split("^")[0];
			var datatext=IdList.split("^")[1];
			var IdArray=dataId.split(",")
			
			if(dataId==""){
				var tmp=RangeId +"^"+ $g(rowsData[i].DLAAttrCode) +"^"+ dataId +"^"+ datatext+"^"+ $g(rowsData[i].DLAAttr);
				dataList.push(tmp);
			}else{
				if(IdArray.length>1){
					for(var j=0;j<IdArray.length;j++){
						var tmp=RangeId +"^"+ $g(rowsData[i].DLAAttrCode) +"^"+ $g(IdArray[j]) +"^"+ $g(IdArray[j]) +"^"+ $g(rowsData[i].DLAAttr);
						dataList.push(tmp);
					}
				}else{
					var tmp=RangeId +"^"+ $g(rowsData[i].DLAAttrCode) +"^"+ $g(dataId) +"^"+ $g(rowsData[i].DLAAttrDesc) +"^"+ $g(rowsData[i].DLAAttr);
					dataList.push(tmp);
				}
			}	
		} 
	}else{
		var rowsData=$("#addattrlist").datagrid('getRows')[editRow];
		var ParamArray = Param.split("$");
		for(var i=0;i<ParamArray.length;i++)
		{
			var tmp=RangeId +"^"+ $g(rowsData.DLAAttrCode) +"^"+ $g(ParamArray[i]) +"^"+ "" +"^"+ $g(rowsData.DLAAttr);
			dataList.push(tmp);
		}
	}
	
	var params=dataList.join("&&");
	
	//保存数据
	runClassMethod("web.DHCCKBRangeCat","SaveUpdate",{"params":params,"flag":flag},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('提示','保存失败！ErrCode:'+jsonString,'warning');
			$('#addattrlist').datagrid('reload'); 
			return;	
		}else{
			$.messager.alert('提示','保存成功！','info');
			if(flag==2){
				$HUI.dialog("#myWin").close();
				
				
			}
			$('#addattrlist').datagrid('reload'); 
			//window.parent.reloadPagedg();
			return;
		}
	});
}
function DownData()
{

	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:"药学分类", //默认DHCCExcel
		ClassName:"web.DHCCKBPrescTest",
		QueryName:"ExportDrugCat"
	},false);
	//web.Util.Menu SelectGroupMenu
	location.href = rtn;

}
function saveCommon()
{
	
}
//查询属性  wxj 2021-05-20
function serchData(){
   	var searcode = $HUI.searchbox("#attrtreecode").getValue();
	findattrTree(searcode);
	}
	
function serchdic(){
   	var searcode = $HUI.searchbox("#dictreecode").getValue();
	finddicTree(searcode);
	}
	
// 查询附加属性
function serchAddattr()
{
	var addattrcode = $HUI.searchbox("#addattrcode").getValue();
	var params=CatId +"^"+ extraAttr +"^"+"ExtraProp"+"^"+addattrcode; 
	//alert(params)
	$('#addattrlist').datagrid('load',{
		params:params
	}); 
}
///附加属性清屏
function RefreshAddattr()
{
    $HUI.searchbox("#addattrcode").setValue("");
	serchAddattr()
}

/// 初始化页面combobx 
function initCombobox(){
	
	    /// 初始化分类检索框
    var option = {
        //panelHeight:"auto",
        mode: "remote",
        valueField: 'value',
        textField: 'text',
        onSelect: function (option) {
            serchdic();
      
        },
        onLoadSuccess:function(data){
	        console.log(data)
	        newdata = [
	        {value: '20', text: '附加属性字典'}
	        ]
	        return newdata;
	    }
    };
    var url = LINK_CSP + "?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr=" + extraAttr +
        "&extraAttrValue=" + "DictionFlag";
    new ListCombobox("dictype", url, '', option).init();
}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })
