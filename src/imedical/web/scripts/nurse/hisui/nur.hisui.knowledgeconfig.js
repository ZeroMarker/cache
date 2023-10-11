/// 名称: 中医护理方案字典维护

$(function(){
	Init();
});
function Init(){
	InitTreeGrid();
	InitEvent();
	InitKICDescCombo();
}
// 关于处理hisui-treegrid如何在刷新后保持原折叠状态解决办法
var recordNodes = new Array();//定义一个数组容器记录已被展开的节点ID
function InitTreeGrid(){
	var columns =[[  
	   {field:'id',title:'id',width:80,sortable:true,hidden:true},
	   {field:'text',title:'描述',width:360,sortable:true}
	]];
	var mygrid = $HUI.treegrid("#mygrid",{
		//url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=Nur.TCM.Service.Config&pClassMethod=GetTreeJson&LastLevel=",
		columns: columns,  
		height:$(window).height()-105,  
		idField: 'id',
		ClassName: "Nur.TCM.Service.Config", //拖拽方法DragNode存在的类
		DragMethodName:"DragNode",
		treeField:'text',  	
		autoSizeColumn:false,
		animate:false,    
		lines:true,
		showHeader:false,
		fitColumns:false, 
		remoteSort:false, 
		striped:false,
		autoRowHeight:false,
		onContextMenu: function(e, row){ 
			var $clicked=$(e.target);
			e.preventDefault();
        	$(this).treegrid('select', row.id);
			var mygridmm = $('<div style="width:120px;"></div>').appendTo('body')
			
			$(
			'<div onclick="AddSameDataTree()" iconCls="icon-add" data-options="">添加本级</div>' +
       		'<div onclick="AddDataTree()" iconCls="icon-add" data-options="">添加下级</div>' +
       		'<div onclick="UpdateDataTree()" iconCls="icon-write-order" data-options="">修改</div>' +
       		'<div onclick="DelDataTree()" iconCls="icon-cancel" data-options="">删除</div>'+
       		'<div onclick="ClearFunLib()" iconCls="icon-reload" data-options="">重置</div>'
       		).appendTo(mygridmm)
		       		
			mygridmm.menu()
			mygridmm.menu('show',{
				left:e.pageX,  
				top:e.pageY
			});	
		},
        onDblClickRow: function (rowIndex,rowData) {
        	UpdateDataTree()
        },
		onLoadSuccess:function(data) {
			$(this).treegrid('enableDnd', data?data.id:null);
			/*$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
			$(this).treegrid('enableDnd', data?data.id:null);
			// 存储折叠数据 start
			//将记录已展开节点ID的数组容器转存到另一个数组容器中
            var list = [];
            for (var j = 0; j < recordNodes.length; j++) {
                list.push(recordNodes[j])
            }
            //这里必须将已记录的节点转存到另一个数组中,
            //因为执行collapseAll方法后,会触发onBeforeCollapse事件
            //会清空已记录的节点数据
            $("#mygrid").treegrid("collapseAll");
            for (var i = 0; i < list.length; i++) {
                $('#mygrid').treegrid('expand', list[i]);
            }
            // 存储折叠数据 end*/
        },
        // 存储折叠数据 start
        onBeforeExpand: function (node) {
	        if (!node._parentId){
		        if (!node.children) {
					UpdateNodeChildData(node.id);
				}
		    }
	        //每次执行展开一个节点的操作时
	        //记录被展开的节点ID
	        recordNodes.push(node.id.toString());
       },
       onBeforeCollapse: function (node) {
            //每次执行折叠一个节点的操作时
            //数组容器去除被折叠的节点ID
            var i = recordNodes.indexOf(node.id.toString());
            if (i >= 0) {
                recordNodes.splice(i, 1);
            }
        },
        onDrop: function(targetRow, sourceRow, point){
        	$(this).treegrid('enableDnd') //允许拖拽
        }
	});
	LoadTreeGridData();
}
function LoadTreeGridData(){
	var TCMDieaseData=$.cm({ 
	    ClassName:"Nur.TCM.Service.Config",
	    MethodName:"GetTCMDiease"
	},false)
	$('#mygrid').treegrid("loadData",{"rows":TCMDieaseData,"total":TCMDieaseData.length});
}
function InitEvent(){
	//检索框
	$('#FindTreeText').keyup(function(event){
		if(event.keyCode == 13) {
			SearchFunLib();
		}
		if(event.keyCode == 27) {
		    ClearFunLib();
		}
	});
	//检索框
	$("#myChecktreeDesc").keyup(function(){ 
		var str = $("#myChecktreeDesc").val(); 
		findByRadioCheck("myChecktree",str,$("input[name='FilterCK']:checked").val())
	})
	$('#btn_search').click(SearchFunLib);
}
//查询方法
function SearchFunLib(){
	var desc=$.trim($("#FindTreeText").val());
	$("#mygrid").treegrid('unselectAll').treegrid("search", desc)
}
//重置方法
function ClearFunLib(){
	$("#FindTreeText").val("");
	$('#mygrid').datagrid('unselectAll').treegrid('reload');
}
//点击添加同级节点按钮
function AddSameDataTree(){
	ClearWinData();
	$.cm({ 
	    ClassName:"Nur.TCM.Service.Config",
	    MethodName:"GetTreeJson",
	    LastLevel:""
	},function(GridData){
		$('#KICParentID').combotree('loadData',GridData);
	})	
	$("#myWin").show();
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-addlittle',
		resizable:true,
		title:'添加',
		modal:true,
		buttonAlign : 'center',
		buttons:[{
			text:'保存',
			id:'save_btn',
			handler:function(){
				SaveFunLibTree("")
			}
		},{
			text:'继续添加',
			id:'save_btn',
			handler:function(){
				TAddFunLibTree("")
			}
		},{
			text:'关闭',
			handler:function(){
				myWin.close();
			}
		}]
	});	
	var record = $("#mygrid").treegrid("getSelected"); 
	if (record){
		var ParentNode=$("#mygrid").treegrid("getParent",record.id)
		if (ParentNode){
			$('#KICParentID').combotree('setValue', ParentNode.id);
			var node = $('#KICParentID').combotree("tree").tree('find', ParentNode.id);
		    $('#KICParentID').combotree("tree").tree("expandTo",node.target);
		}
	}
}
//点击添加同级子节点按钮
function AddDataTree(){
	ClearWinData();
	var GridData=$.cm({ 
	    ClassName:"Nur.TCM.Service.Config",
	    MethodName:"GetTreeJson",
	    LastLevel:""
	},false)
	$('#KICParentID').combotree('loadData',GridData);
	$("#myWin").show();
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-w-add',
		resizable:true,
		title:'增加',
		modal:true,
		buttonAlign : 'center',
		buttons:[{
			text:'保存',
			id:'save_btn',
			handler:function(){
				SaveFunLibTree("")
			}
		},{
			text:'继续添加',
			id:'save_btn',
			handler:function(){
				TAddFunLibTree("")
			}
		},{
			text:'关闭',
			handler:function(){
				myWin.close();
			}
		}]
	});	
	ClearWinData();
	var record = $("#mygrid").treegrid("getSelected"); 
	if (record){
		$('#KICParentID').combotree('setValue', record.id);
		var node = $('#KICParentID').combotree("tree").tree('find', record.id);
		$('#KICParentID').combotree("tree").tree("expandTo",node.target);
	}
}
function UpdateDataTree(){
	ClearWinData();
	var GridData=$.cm({ 
	    ClassName:"Nur.TCM.Service.Config",
	    MethodName:"GetTreeJson",
	    LastLevel:""
	},false)
	$('#KICParentID').combotree('loadData',GridData);
	var record = $("#mygrid").treegrid("getSelected"); 
	if (!(record)){	
		$.messager.popover({msg: '请先选择一条记录!',type: 'error'});
		return false;
	}
	var id=record.id;
	$.cm({
		ClassName:"Nur.TCM.Service.Config",
		MethodName:"GetDataObjById",
		id:id
	},function(jsonData){
		for (item in jsonData){
			var _$id=$("#"+item);
			if (_$id.hasClass('combobox-f')){
				_$id.combobox("setValue",jsonData[item]);
				if (item =="KICDesc"){
					_$id.combobox("setText",jsonData[item]);
				}
			}else if(_$id.hasClass('combotree-f')){
				_$id.combotree("setValue",jsonData[item]);
			}else{
				_$id.val(jsonData[item]);
			}
		}
		$("#myWin").show(); 
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'修改',
			modal:true,
			buttons:[{
				text:'保存',
				id:'save_btn',
				handler:function(){
					SaveFunLibTree(id)
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});
	})
}
///新增、更新
function SaveFunLibTree(selNodeId){
	var SaveDataArr=[];
	SaveDataArr.push({"field":"KICRowId","fieldValue":selNodeId});
	var NullValColumnArr=[];
	var _$input=$("#config-table tr td:not(.r-label) > input");
	for (var i=0;i<_$input.length;i++){
		var id=_$input[i].id;
		if (!id) continue;
		var _$id=$("#"+id);
		if (_$id.hasClass('combobox-f')){
			var value=_$id.combobox("getValue");
			if (id =="KICDesc"){
				value=$.trim(_$id.combobox("getText"));
			}
		}else if(_$id.hasClass('combotree-f')){
			var value=_$id.combotree("getValue");
			if (!$.trim(_$id.combotree("getText"))) value="";
		}else{
			var value=$.trim(_$id.val());
			if ((id =="KICCode")&&(value=="")){
				value=$.trim($("#KICDesc").combobox("getText"));
			}
		}
		var _$label=$('label[for="' + id + '"]');
		if ((_$label.hasClass("clsRequired"))&&(!value)) {
			NullValColumnArr.push(_$label[0].innerHTML);
		}
		SaveDataArr.push({"field":id,"fieldValue":value});
	}
	if (NullValColumnArr.length>0){
		$.messager.popover({msg: NullValColumnArr.join("、")+"不能为空!",type: 'error'});
		return false;
	}
	$.cm({
		ClassName:"Nur.TCM.Service.Config",
		MethodName:"SaveData",
		SaveDataArr:JSON.stringify(SaveDataArr)
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg: '保存成功！',type: 'success'});
			LoadTreeGridData();
		    $('#myWin').dialog('close'); 
		}else{
			$.messager.popover({msg: '保存失败！',type: 'error'});
		}
	})
}
///继续添加
function TAddFunLibTree(id){
	var LastLevel="";
	var SaveDataArr=[];
	SaveDataArr.push({"field":"KICRowId","fieldValue":id});
	var NullValColumnArr=[];
	var _$input=$("#config-table tr td:not(.r-label) > input");
	for (var i=0;i<_$input.length;i++){
		var id=_$input[i].id;
		if (!id) continue;
		var _$id=$("#"+id);
		if (_$id.hasClass('combobox-f')){
			var value=$.trim(_$id.combobox("getValue"));
			if (id =="KICDesc"){
				value=$.trim(_$id.combobox("getText"));
			}
		}else if(_$id.hasClass('combotree-f')){
			var value=_$id.combotree("getValue");
			if (!$.trim(_$id.combotree("getText"))) value="";
		}else{
			var value=$.trim(_$id.val());
			if ((id =="KICCode")&&(value=="")){
				value=$.trim($("#KICDesc").combobox("getText"));
			}
		}
		var _$label=$('label[for="' + id + '"]');
		if ((_$label.hasClass("clsRequired"))&&(!value)) {
			NullValColumnArr.push(_$label[0].innerHTML);
		}
		if (id =="KICParentID"){
			var LastLevel=value;
		}
		SaveDataArr.push({"field":id,"fieldValue":value});
	}
	if (NullValColumnArr.length>0){
		$.messager.popover({msg: NullValColumnArr.join("、")+"不能为空!",type: 'error'});
		return false;
	}
	$.cm({
		ClassName:"Nur.TCM.Service.Config",
		MethodName:"SaveData",
		SaveDataArr:JSON.stringify(SaveDataArr)
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg: '保存成功！',type: 'success'});
			ClearWinData();
			$('#KICParentID').combotree('setValue', LastLevel);
			var node = $('#KICParentID').combotree("tree").tree('find', LastLevel);
		    $('#KICParentID').combotree("tree").tree("expandTo",node.target);
			LoadTreeGridData(); 
		}else{
			$.messager.popover({msg: '保存失败！',type: 'error'});
		}
	})
}
///删除
function DelDataTree(){
	var record = $("#mygrid").treegrid("getSelected"); 
	if (!(record)){	
		$.messager.alert('错误提示','请先选择一条记录!',"error");
		return;
	}
	$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
		if (r){
			$.cm({
				ClassName:"Nur.TCM.Service.Config",
				MethodName:"DeleteData",
				id:record.id
			},function(rtn){
				if (rtn ==0) {
					$.messager.popover({msg: '删除成功！',type: 'success'});
					$('#mygrid').treegrid('remove',record.id);
				}else{
					$.messager.popover({msg: '删除失败！'+rtn,type: 'error'});
				}
			})
		}
	});		
}
function ClearWinData(){
	var _$input=$("#config-table tr td:not(.r-label) > input");
	for (var i=0;i<_$input.length;i++){
		var id=_$input[i].id;
		if (!id) continue;
		var _$id=$("#"+id);
		if (_$id.hasClass('combobox-f')){
			_$id.combobox("setValue","").combobox("setText","");
		}else if(_$id.hasClass('combotree-f')){
			_$id.combotree("setValue","");
		}else{
			_$id.val("");
		}
	}
}
function InitKICDescCombo(){
	$("#KICDesc").combobox({
		required:true,
		textField:"text",
		valueField:"id",
		data:[{    
		    "id":"主要症状",    
		    "text":"主要症状"   
		},{    
		    "id":"证候诊断",    
		    "text":"证候诊断"   
		},{    
		    "id":"主要辩证施护方法",    
		    "text":"主要辩证施护方法"  
		},{    
		    "id":"中医护理技术",    
		    "text":"中医护理技术"   
		},{    
		    "id":"症状评价量表",    
		    "text":"症状评价量表"   
		}]
	})
}
function UpdateNodeChildData(parentID){
	var Childrens=$('#mygrid').treegrid("getChildren",parentID);
	for (var i=Childrens.length-1;i>=0;i--){
		$('#mygrid').treegrid('remove',Childrens[i].id);
	}
	var GridData=$.cm({ 
	    ClassName:"Nur.TCM.Service.Config",
	    MethodName:"GetTCMDieaseChild",
	    LastLevel:parentID
	},false)
	$('#mygrid').treegrid('append',{
		parent: parentID,
		data: GridData
	});
}