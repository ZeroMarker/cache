var GV={}  ;//存放全局变量
var editRow = ""; var arcColumns=""; var PartColumns=""; var nodeArr=[]; var count = 0; var partEditRow="";
var ItemTypeArr = [{"value":"E","text":'检查'}, {"value":"L","text":'检验'}, {"value":"P","text":'病理'}];;

/// 页面初始化函数
function InitHosp(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_APP_Exacattreeadd",hospStr);
	hospComp.jdata.options.onSelect= function(){
		initPageDefault()
	} 
	initPageDefault();
	initBlButton();      /// 页面 Button 绑定事件
}
function initPageDefault(){
	GV.maxHeight=$(window).height()||550;
	GV.maxWidth=$(window).width()||1366;
	
	initColumns();       /// 初始化datagrid列表
	initSymLevTree();    /// 初始化检查分类树
	initDataGrid();      /// 页面DataGrid初始定义
	
    LoadPageBaseInfo();  /// 初始化加载基本数据  

    initPartDataGrid();  /// 页面DataGrid初始定义
    initCombobox();      /// 页面Combobox初始定义
    initMenuSecurityWin();
    <!-- 新旧版本兼容配置 -->
    if (version != 1){
	    /// 旧版时,隐藏部位列表窗口
		$('#mainpanel').layout('hidden','east');
		/// 显示增加部位选项菜单
		$("div[onclick='newCreatePart()']").attr("style","");
		///旧版时,改变右键面板的高度
		$("#right").attr("style","height:200px;");
	}
}
/// 初始化datagrid列表
function initColumns(){
	
	arcColumns = [[
	    {field:'itmDesc',title:'医嘱项名称',width:220},
	    {field:'itmCode',title:'医嘱项代码',width:100},
	    //{field:'itmPrice',title:'单价',width:100},
		{field:'itmID',title:'itmID',width:80,hidden:true}
	]];
	
	PartColumns = [[
	    {field:'PartDesc',title:'部位描述',width:100},
	    {field:'LastPartDesc',title:'上级部位',width:80},
		{field:'PartID',title:'PartID',width:100,hidden:true}
	]];
}

///  初始化加载基本数据
function LoadPageBaseInfo(){

	/// 检查分类列表
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryCheckItemList";
	$("#itemlist").datagrid({url:uniturl});
}

/// 检查分类树
function initSymLevTree(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	<!-- 新旧版本兼容配置 -->
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeID&id=0&HospID='+HospID;
	if (version == 1){
		uniturl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeIDNew&id=0&HospID='+HospID;
	}
	var option = {
		multiple:true,
		lines:true,
		animate:true,
		dnd:true,
        onClick:function(node, checked){
	        var isLeaf = $("#itemCat").tree('isLeaf',node.target);   /// 是否是叶子节点
	        if (isLeaf){
		        var itemCatID = node.id; 		/// 检查分类ID
				var params = itemCatID;
				$("#itemlist").datagrid("load",{"params":params});
				$("#partlist").datagrid("loadData",{"total":0,"rows":[]});
	        }else{
		    	//$("#itemCat").tree('toggle',node.target);   /// 点击项目时,直接展开/关闭
		    }
	    }, 
		onContextMenu: function(e, node){
			
			e.preventDefault();
			var node = $("#itemCat").tree('getSelected');
			if (node == null){
				$.messager.alert("提示","请选中节点后重试!"); 
				return;
			}
			// 显示快捷菜单
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
		onLoadSuccess: function(node, data){
			
			for (var i=0;i<nodeArr.length;i++){
				var node = $('#itemCat').tree('find', nodeArr[i]);
				if (node != null){
					$('#itemCat').tree('expand', node.target);
					count = count + 1;
				}
			}
			if (count == nodeArr.length+1){
				nodeArr=[];
			}
		},
		onBeforeDrop: function(target, source, point){
			
			if (point == "append") return false;
			var id = $('#itemCat').tree("getNode",target).id;
			if (!moveTree(id +"^"+ source.id+"^"+point)){
				return false;
			}
			//console.log("onDragEnter"+$('#itemCat').tree("getNode",target).id+"-"+source.id+"-"+point)
			
		},
		onStopDrag: function(node){
			
			//console.log("onStopDrag"+node.id)
			
		}
	};
	new CusTreeUX("itemCat", uniturl, option).Init();
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
	
	/// 医嘱项
	var boxArcEditor = {
		type:'combogrid',
		options:{
		    id:'itmID',
		    fitColumns:true,
		    fit: true,//自动大小  
			pagination : true,
			panelWidth:500,
			textField:'itmDesc',
			mode:'remote',
			url:LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=QueryArcItmDetail&HospID='+$HUI.combogrid('#_HospList').getValue(),
			columns:arcColumns,
				onSelect:function(rowIndex, rowData) {
   					setCurrArcEditRowCellVal(rowData);
				}		   
			}
		}
		
	///  定义columns
	var columns=[[
		{field:'ItemCode',title:'代码',width:100,editor:textEditor},
		{field:'ItemDesc',title:'医嘱项',width:260,editor:boxArcEditor},
		{field:'ItemID',title:'ItemID',width:100,hidden:true,editor:textEditor},
		{field:'ItemPartID',title:'ItemPartID',width:100,editor:textEditor,hidden:true},
		{field:'TraID',title:'TraID',width:100,hidden:true},
		{field:'TraItmID',title:'TraItmID',width:100,hidden:true},
		{field:'ItemPriority',title:'优先级',width:160,align:'center',formatter:SetCellUrl},
		{field:'ItemOrdNum',title:'顺序号',width:100,hidden:true}
	]];
	
	///  定义datagrid
	var option = {
		rownumbers : false,
		singleSelect : true,
		showPageList : false,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != "") {  //||editRow == 0
                $("#itemlist").datagrid('endEdit', editRow); 
            } 
            $("#itemlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex;
            dataArcGridBindEnterEvent(rowIndex);  //设置回车事件
            
        },
        onClickRow: function(rowIndex, rowData){
	        var TraID = rowData.TraID;
	        var ItemID = rowData.ItemID;
			/// 检查分类列表
			var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryCheckPartList&TraID="+TraID+"&ItemID="+ItemID;
			$("#partlist").datagrid({url:uniturl});
	    },
	    onBeginEdit: function(rowIndex, rowData){
		    var ItemCodeObj=$(this).datagrid('getEditor', {index:rowIndex,field:'ItemCode'});
			ItemCodeObj.target[0].disabled=true;
		}
	};
	
	var uniturl = "";
	new ListComponent('itemlist', columns, uniturl, option).Init();
}

/// 上移和下移
function SetCellUrl(value,row,index){
	
	if(value==undefined){   //2016-07-18 qunianpeng
		value="" ;
	}	
	html="<a class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveUp("+index+")'>"
	html=html+"<span class='l-btn-left'><span class='l-btn-text icon-up l-btn-icon-left'>上移</span></span>"
	html=html+"</a><span style='margin:0px 10px;'> </span>"
	html=html+"<a class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveDown("+index+")'>"
	html=html+"<span class='l-btn-left'><span class='l-btn-text icon-down l-btn-icon-left'>下移</span></span>"
	html=html+"</a>"
	html=html+"<span style='display:none;'>"+value+"</span>"
	return html;
}

/// 上移
function moveUp(index){
	move(true,index)
}

/// 下移
function moveDown(index){
	move(false,index)
}

/// 移动
function move(isUp,index) {

	var newrow = "";
	if(isUp){
		var newrow=parseInt(index)-1;  /// 上移
	}else{
		var newrow=parseInt(index)+1;  /// 下移
	}
	var TrsRow = $("#itemlist").datagrid('getData').rows[index];
	var TrsID = TrsRow.TraItmID;
	var LastRow =$("#itemlist").datagrid('getData').rows[newrow];
	var LastID = LastRow.TraItmID;
	var mListData = TrsID +"^"+ LastID;
    runClassMethod("web.DHCAPPTreeAdd","moveTreeLink",{'mListData':mListData},function(jsonString){
		if (jsonString != 0){
			$.messager.alert("提示","移动出错!"); 
			return;
		}else{
			moveTreeLink(isUp, index, 'itemlist'); /// 移动界面行
		}
 	})
}

/// 移动界面行
function moveTreeLink(isUp, index, gridname){
	
    if (isUp) {

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
    }else{
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

/// 页面DataGrid初始定义
function initPartDataGrid(){
	
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	/// 部位
	var boxPartEditor = {
		type:'combogrid',
		options:{
		    id:'PartID',
		    fitColumns:true,
		    fit: true,//自动大小  
			pagination : true,
			panelWidth:460,
			textField:'PartDesc',
			mode:'remote',
			url:LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonPart&ShowAllPart=1',
			columns:PartColumns,
				onSelect:function(rowIndex, rowData) {
   					setCurrPartEditRowCellVal(rowData);
				}		   
			}
		}
		
	///  定义columns
	var columns=[[
		{field:'ItemPart',title:'部位',width:320,editor:boxPartEditor},
		{field:'ItemPartID',title:'ItemPartID',width:100,editor:textEditor,hidden:true},
		{field:'ItemID',title:'ItemID',width:100,hidden:true},
		{field:'TraID',title:'TraID',width:100,hidden:true},
		{field:'TraItmID',title:'TraItmID',width:100,hidden:true}
	]];
	
	///  定义datagrid
	var option = {
		rownumbers : false,
		singleSelect : true,
		showPageList : false,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (partEditRow != "") { //||partEditRow == 0
                $("#partlist").datagrid('endEdit', partEditRow); 
            } 
            $("#partlist").datagrid('beginEdit', rowIndex); 
            
            partEditRow = rowIndex;
            dataPartGridBindEnterEvent(rowIndex);  //设置回车事件
        }
	};
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryCheckPartList&TraID=&ItemID=";;
	new ListComponent('partlist', columns, uniturl, option).Init();
}

/// 页面 Button 绑定事件
function initBlButton(){
	
	///  增加检查项目,部位
	$('#arctb a:contains("新增")').bind("click",insertRow);
	
	///  保存检查项目,部位
	$('#arctb a:contains("保存")').bind("click",saveRow);
	
	///  删除检查项目,部位
	$('#arctb a:contains("删除")').bind("click",deleteRow);
	
	///  安全组授权
	$('#arctb a:contains("授权")').bind("click",openAuth);
	
	///  增加检查项目,部位
	$('#parttb a:contains("新增")').bind("click",insPartRow);
	
	///  保存检查项目,部位
	$('#parttb a:contains("保存")').bind("click",savePartRow);
	
	///  删除检查项目,部位
	$('#parttb a:contains("删除")').bind("click",delPartRow);
	
	///  拼音码
	//$("#ExaCatCode").bind("keyup",findExaItmTree);
	$('#ExaCatCode').searchbox({
		searcher : function (value, name) {
			var PyCode=$.trim(value);
			findExaItmTree(PyCode);
		}
	});
	
	///  保存
	$('#icw_bt a:contains("保存")').bind("click",saveCat);
	
	///  取消
	$('#icw_bt a:contains("取消")').bind("click",closeWin);
	
	///  保存
	$('#pw_bt a:contains("保存")').bind("click",savePart);
	
	///  取消
	$('#pw_bt a:contains("取消")').bind("click",closePartWin);
	
	///  更新
	$('#uicw_bt a:contains("更新")').bind("click",updTreeCat);
	
	///  取消
	$('#uicw_bt a:contains("取消")').bind("click",closeItmCatWin);
	
	///  部位描述
	$('#PartDesc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			if ($('#PartDesc').val() == "") return;
			var unitUrl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonPart&PartName='+$('#PartDesc').val()+"&ShowAllPart=1";
			/// 调用部位列表窗口
			new ListComponentWin($('#PartDesc'), "", "600px", "" , unitUrl, PartColumns, setCurrEditRowCellVal).init();
		}
	});
	
	///  分类名称
	$('#ItemDesc,#TraItmDesc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			//if ($('#ItemDesc').val() == "") return;
			//GetTreeCatAlias(this.id);
		}
	});
	
	///  分类名称
	$('#ItemDesc,#TraItmDesc').bind('blur',function(event){
		//GetTreeCatAlias(this.id);
	});
	
	///  医嘱项描述
	$('#ItmmastDesc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			if ($('#ItmmastDesc').val() == "") return;
			var HospID=$HUI.combogrid('#_HospList').getValue();
			var unitUrl = LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=QueryArcItmDetail&Input='+$('#ItmmastDesc').val()+"&HospID="+HospID;
			/// 调用部位列表窗口
			new ListComponentWin($('#ItmmastDesc'), "", "600px", "" , unitUrl, arcColumns, setArcCurrEditRowCellVal).init();
		}
	});
}

/// 查找检查项目树
function findExaItmTree(PyCode){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if (PyCode == ""){
		<!-- 新旧版本兼容配置 -->
	    if (version != 1){
			/// 旧版
			var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeID&id=0&HospID='+HospID;
	    }else{
			/// 新版
			var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeIDNew&id=0&HospID='+HospID;
		}
	}else{
		<!-- 新旧版本兼容配置 -->
	    if (version != 1){
		    /// 旧版
			var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByPyCode&PyCode='+PyCode+'&HospID='+HospID;
		}else{
			/// 新版
			var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByPyCodeNew&PyCode='+PyCode+'&HospID='+HospID;
		}
	}
	
	$("#itemCat").tree('options').url =encodeURI(url);
	$("#itemCat").tree('reload');
}

/// 插入检查项目部位行
function insertRow(){
	
	var node = $("#itemCat").tree('getSelected');
	if (!node){
		$.messager.alert("提示","请选定具体项目后进行增加操作!"); 
        return;
    }
	var isLeaf = $("#itemCat").tree('isLeaf',node.target);   /// 是否是叶子节点
    if (!isLeaf){
		$.messager.alert("提示","请选定具体项目后进行增加操作!"); 
        return;
    }
    if (node.id.indexOf("^") != "-1"){
    	var TraID = node.id.split("^")[0];
    	var PartID = node.id.split("^")[1];
    }else{
		var TraID = node.id;
		var PartID = "";
	}
	
	if(editRow>="0"){
		$("#itemlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#itemlist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ItemPartID:PartID, TraID:TraID, TraItmID:""}
	});
	$("#itemlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
	
	var rows = $("#itemlist").datagrid('getRows');
	if (rows.length != "0"){
		dataArcGridBindEnterEvent(0);  //设置回车事件
	}
}

/// 给检查项目,部位datagrid绑定回车事件
function dataArcGridBindEnterEvent(index){
	
	var editors = $('#itemlist').datagrid('getEditors', index);
	/// 检查项目名称
	var workRateEditor = editors[1];
	workRateEditor.target.focus();  ///设置焦点
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var HospID=$HUI.combogrid('#_HospList').getValue();
			var ed=$("#itemlist").datagrid('getEditor',{index:index, field:'ItemDesc'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var unitUrl = LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=QueryArcItmDetail&Input='+$(ed.target).val()+"&HospID="+HospID;
			/// 调用医嘱项列表窗口
			new ListComponentWin($(ed.target), input, "600px", "" , unitUrl, arcColumns, setCurrArcEditRowCellVal).init();
		}
	});
	/*
	/// 检查部位名称
	var workRateEditor = editors[2];
	//workRateEditor.target.focus();  ///设置焦点
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#itemlist").datagrid('getEditor',{index:index, field:'ItemPart'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var unitUrl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonPart&PartName='+$(ed.target).val();
			/// 调用部位列表窗口
			new ListComponentWin($(ed.target), input, "600px", "" , unitUrl, PartColumns, setCurrArcEditRowCellVal).init();
		}
	});
	*/
}


/// 给检查项目,部位datagrid绑定回车事件
function dataPartGridBindEnterEvent(index){
	
	var editors = $('#partlist').datagrid('getEditors', index);
	/// 检查部位名称
	var workRateEditor = editors[0];
	workRateEditor.target.focus();  ///设置焦点
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#partlist").datagrid('getEditor',{index:index, field:'ItemPart'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var unitUrl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonPart&PartName='+$(ed.target).val()+"&ShowAllPart=1";
			/// 调用部位列表窗口
			new ListComponentWin($(ed.target), input, "450px", "" , unitUrl, PartColumns, setCurrPartEditRowCellVal).init();
		}
	});
}

/// 给当前编辑列赋值(检查项目)
function setCurrArcEditRowCellVal(rowObj){
	if (rowObj == null){
		var editors = $('#itemlist').datagrid('getEditors', editRow);
		///检查项目
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();  ///设置焦点 并选中内容
		return;
	}

	if (typeof rowObj.itmDesc != "undefined"){
		/// 项目名称
		//var ed=$("#itemlist").datagrid('getEditor',{index:editRow, field:'ItemDesc'});
		//$(ed.target).val(rowObj.itmDesc);
		/// 项目代码
		var ed=$("#itemlist").datagrid('getEditor',{index:editRow, field:'ItemCode'});		
		$(ed.target).val(rowObj.itmCode);
		/// 项目名称ID
		var ed=$("#itemlist").datagrid('getEditor',{index:editRow, field:'ItemID'});		
		$(ed.target).val(rowObj.itmID);

		/// 设置下一焦点
		//var ed=$("#itemlist").datagrid('getEditor',{index:editRow, field:'ItemPart'});
		//ed.target.focus();  ///设置焦点;
	}else{
		/// 部位名称
		var ed=$("#itemlist").datagrid('getEditor',{index:editRow, field:'ItemPart'});
		$(ed.target).val(rowObj.PartDesc);
		/// 部位ID
		var ed=$("#itemlist").datagrid('getEditor',{index:editRow, field:'ItemPartID'});		
		$(ed.target).val(rowObj.PartID);
	}
}

/// 给当前编辑列赋值(检查部位)
function setCurrPartEditRowCellVal(rowObj){
	if (rowObj == null){
		var editors = $('#partlist').datagrid('getEditors', partEditRow);
		///检查项目
		var workRateEditor = editors[0];
		workRateEditor.target.focus().select();  ///设置焦点 并选中内容
		return;
	}

	/// 部位名称
	var ed=$("#partlist").datagrid('getEditor',{index:partEditRow, field:'ItemPart'});
	$(ed.target).val(rowObj.PartDesc);
	/// 部位ID
	var ed=$("#partlist").datagrid('getEditor',{index:partEditRow, field:'ItemPartID'});		
	$(ed.target).val(rowObj.PartID);
}

///保存检查项目部位
function saveRow(){
	
	if(editRow>="0"){
		$("#itemlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#itemlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].ItemID=="")||(rowsData[i].ItemDesc=="")){
			$.messager.alert("提示","检查项目不能为空！"); 
			return false;
		}
		var tmp=rowsData[i].TraID+"^"+rowsData[i].ItemID+"^"+rowsData[i].ItemPartID+"^"+rowsData[i].TraItmID;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");

	//保存数据
	runClassMethod("web.DHCAPPTreeAdd","SaveTraTreeLink",{"version":version, "params":params},function(jsonString){
		if(jsonString==0){
			$.messager.alert("提示","保存成功!"); 
			$('#itemlist').datagrid('reload'); //重新加载
		}
		if(jsonString==-1){
			$.messager.alert("提示","数据重复!"); 
			$('#itemlist').datagrid('reload'); //重新加载
		}
		if(jsonString==-2){
			$.messager.alert("提示","医嘱项已经对应部位，请先删除部位!"); 
			$('#itemlist').datagrid('reload'); //重新加载
		}
	});
}

///授权
function openAuth () {
	var selected = $("#itemlist").datagrid('getSelected');
	if (!selected) {
		$.messager.alert('提示','请选择一行记录！','warning');
		 return;
	}
	var caption = selected.ItemDesc;
	var name = selected.ItemCode;
	var id = selected.TraItmID;
	$('#menu-security-win-search').searchbox('setValue','');
    //$('#menu-security-win').find('.i-searchbox tr').eq(0).find('input').val(caption);
    $('#menu-security-win-caption').text(caption);
    //$('#menu-security-win').find('.i-searchbox tr').eq(1).find('input').val(name);
    $('#menu-security-win-name').text(name);
    $('#menu-security-win-id').val(id);
    $('#menu-security-win-list').datagrid('options').url='websys.Broker.cls';
    //alert(id)
    $('#menu-security-win-list').datagrid('unselectAll').datagrid('load',{ClassName:'web.DHCAppTreeGroup',QueryName:'QryArcimAuth',MenuID:id,GroupDesc:''});
    $('#menu-security-win').dialog('open');
	
	
}

/// 删除检查项目,部位选中行
function deleteRow(){

	var rowsData = $("#itemlist").datagrid('getSelected'); /// 选中要删除的行
	if (rowsData != null) {
		var TarID = rowsData.TraID;
		$.messager.confirm("提示", "您确定要删除吗？", function (res) {
			/// 提示是否删除
			if (res) {
				if (rowsData.TraItmID != ""){
					runClassMethod("web.DHCAPPTreeAdd","DelTreeLink",{"version":version, "TraItmID":rowsData.TraItmID},function(jsonString){
						if (jsonString == "-1"){
							$.messager.alert("提示","请先删除部位,再删除项目!"); 
						}else if(jsonString = "0"){
							var rows = $("#itemlist").datagrid('getRows');   ///只有一条项目，同时刷新左边的树  sufan  2017-05-26
							if((rows.length == "1")&&(version != "1")){
									refreshItmCat(TarID);
									$('#itemlist').datagrid('reload');    /// 重新加载
								}else{
										$('#itemlist').datagrid('reload');    /// 重新加载
										}
							}else{
							$('#itemlist').datagrid('reload');    /// 重新加载
						}
					})
				}else{
					var index = $("#itemlist").datagrid('getRowIndex',rowsData); /// 行索引
					$("#itemlist").datagrid('deleteRow',index);
				}
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 新建分类窗口
function newCreateItmCat(type){
	
	var node = $("#itemCat").tree('getSelected');
	if (node.id.indexOf("^") != "-1"){
		$.messager.alert("提示","当前节点为部位节点,不能添加分类!"); 
        return;
	}
	
	if ((type == "C")&(!isAllowItmCat(node.id))){
		$.messager.alert("提示","下级分类类型不一致,'非部位分类'!"); 
        return;
	}
	
	newCreateItmCatWin(type);      // 新建咨询窗口
	InitItmCatDefault(type);   // 初始化界面默认信息
}

/// Window 定义
function newCreateItmCatWin(type){
	
	/// 分类窗口
	var option = {
		modal:false,
		collapsible:false,
		border:true,
		closed:false,
		minimizable:false,
		maximizable:false
	};
	
	var title = "增加子分类";
	if (type == "S"){
		title = "增加同级分类";
	}
	
	new WindowUX(title, 'itmCatWin', '400', '280', option).Init();
}

/// 初始化界面默认信息
function InitItmCatDefault(type){
	
	$("#ItemDesc").val("");    /// 分类名称
	$("#ItemAlias").val("");   /// 别名
	$("#ItemType").combobox({disabled: false});
	$("#ItemType").combobox('setValue',"");   /// 分类类型
	var node = $("#itemCat").tree('getSelected');
	
	if (type == "C"){
	    if (node.id.indexOf("^") != "-1"){
			$.messager.alert("提示","当前节点已经是末级节点,不能进行添加!"); 
	        return;
		}
		$("#LastItmID").val(node.id);
		$("#LastItmDesc").val(node.text);
	}else{
		var node = $("#itemCat").tree('getParent',node.target);
		if (node != null){
			$("#LastItmID").val(node.id);
			$("#LastItmDesc").val(node.text);
		}else{
			$("#LastItmID").val(0);
			$("#LastItmDesc").val(0);
		}
	}
	if(node==null) return false;
	var ItemType = GetNodeType(node.id);
	if (ItemType != ""){
		$HUI.combobox("#ItemType").setValue(ItemType);   /// 分类类型
		$HUI.combobox("#ItemType").disable(true);
	}
}

/// 新建子部位
function newCreatePart(){
	
	var node = $("#itemCat").tree('getSelected');
	if (node.id.indexOf("^") != "-1"){
		$.messager.alert("提示","当前节点为部位节点,不能添加下级部位!"); 
        return;
	}
	
	/*if (!isAllowPart(node.id)){
		$.messager.alert("提示","下级分类类型不一致,'非部位分类'!"); 
        return;
	}*/
	
	newCreatePartWin(); 	// 新建咨询窗口
	InitItmPartDefault();   // 初始化界面默认信息
}

/// Window 定义
function newCreatePartWin(){
	
	/// 部位别名窗口
	var option = {
		modal:false,
		collapsible:true,
		border:true,
		closed:"true"
	};
	
	new WindowUX('增加部位', 'PartWin', '400', '240', option).Init();
}

/// 初始化界面默认信息
function InitItmPartDefault(){
	
	$("#PartID").val("");     /// 部位ID
	$("#PartDesc").val("");   /// 部位
	$("#ItmmastID").val("");    /// 医嘱项ID
	$("#ItmmastDesc").val("");  /// 医嘱项
	var node = $("#itemCat").tree('getSelected');
	$("#LastNodeID").val(node.id);
	$("#LastNodeDesc").val(node.text);
}

/// 新建分类窗口
function newCreateUpdItmCat(){
	
	var node = $("#itemCat").tree('getSelected');
	if (node.id.indexOf("^") != "-1"){
		$.messager.alert("提示","当前节点为部位节点,不能使用更新!"); 
        return;
	}
	newCreateUpdItmCatWin();      // 新建咨询窗口
	InitUpdItmCatDefault();   // 初始化界面默认信息
}

/// Window 定义
function newCreateUpdItmCatWin(){
	
	/// 分类窗口
	var option = {
		modal:false,
		collapsible:false,
		border:true,
		closed:false,
		minimizable:false,
		maximizable:false
	};
	
	new WindowUX('更新分类', 'uItmCatWin', '400', '240', option).Init();
}

/// 初始化界面默认信息
function InitUpdItmCatDefault(){
	
	var node = $("#itemCat").tree('getSelected');

	$("#TraItmID").val(node.id);
	$("#TraItmDesc").val(node.text);
	$("#TraItmAlias").val(GetTreeAlise(node.id));
	var ItemType = GetNodeType(node.id);
	if (ItemType != ""){
		$("#TraItmType").combobox('setValue',ItemType);   /// 分类类型
	}
}

/// 关闭窗口
function closeWin(){
	$('#itmCatWin').window('close');
}

/// 关闭窗口
function closePartWin(){
	$('#PartWin').window('close');
}

/// 关闭窗口
function closeItmCatWin(){
	$('#uItmCatWin').window('close');
}

/// 保存分类
function saveCat(){
	
	var ItemDesc = $("#ItemDesc").val();    /// 分类名称
	if (ItemDesc == ""){
		$.messager.alert("提示","分类名称不能为空,请选择!"); 
        return;
	}
	var LastItmID = $("#LastItmID").val();  /// 上级分类
	if (LastItmID == ""){
		$.messager.alert("提示","上级分类不能为空,请选择!"); 
        return;
	}
	var ItemAlias = $("#ItemAlias").val();  /// 别名
	var ItemType = $("#ItemType").combobox('getValue');  /// 分类类型
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var mListData =ItemDesc +"^"+ ItemDesc +"^"+ LastItmID +"^"+ ItemAlias +"^"+ HospID +"^"+ ItemType;

	/// 保存数据
	runClassMethod("web.DHCAPPTreeAdd","InsTraTreeAdd",{"mListData":mListData},function(jsonString){
		if (jsonString == 0){
			//$.messager.alert("提示","保存成功!");
			refreshItmCat(LastItmID); /// 刷新检查分类树
			closeWin();  /// 关闭窗口
		} 
		if(jsonString == "-1"){
		     $.messager.alert("提示","已存在相同项目,请核实!");
		}

     },'',false)
}

/// 保存子部位
function savePart(){
	
	var PartID = $("#PartID").val();
	if (PartID == ""){
		$.messager.alert("提示","部位不能为空,请选择!"); 
        return;
	}
	var ItmmastID = $("#ItmmastID").val();
	if (ItmmastID == ""){
		$.messager.alert("提示","医嘱项不能为空,请选择!"); 
        return;
	}
	var LastNodeID = $("#LastNodeID").val();
	if (LastNodeID == ""){
		$.messager.alert("提示","上级分类不能为空,请选择!"); 
        return;
	}
	
	var mListData =LastNodeID +"^"+ ItmmastID +"^"+ PartID;

	/// 保存数据
	runClassMethod("web.DHCAPPTreeAdd","InsTraTreeLink",{"mListData":mListData},function(jsonString){
		if (jsonString == 0){
			//$.messager.alert("提示","保存成功!");
			refreshItmCat(LastNodeID); /// 刷新检查分类树
			closePartWin();  /// 关闭窗口
		} 
		if(jsonString == "-2"){
		     $.messager.alert("提示","已存在相同项目,请核实!");
		}

     },'',false)
}

///查询按钮部位项响应函数
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		$("#PartDesc").focus().select();  /// 设置焦点 并选中内容
		return;
	}
	$("#PartID").val(rowObj.PartID);      /// 医嘱项
	$("#PartDesc").val(rowObj.PartDesc);  /// 医嘱项
	$("#ItmmastDesc").val("");
	$("#ItmmastDesc").focus();   		  /// 设置焦点
}

///查询按钮医嘱项响应函数
function setArcCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		$("#ItmmastDesc").focus().select();  /// 设置焦点 并选中内容
		return;
	}
	$("#ItmmastID").val(rowObj.itmID);      /// 医嘱项ID
	$("#ItmmastDesc").val(rowObj.itmDesc);  /// 医嘱项
}

/// 删除分类
function delTreeCat(){

	var node = $("#itemCat").tree('getSelected');
	if (node.id.indexOf("^") != "-1"){
		$.messager.alert("提示","当前节点为部位节点,不能删除!"); 
        return;
	}
	
	$.messager.confirm('确认对话框','确定要删除该分类项目吗？', function(r){
		if (r){
			/// 删除数据
			runClassMethod("web.DHCAPPTreeAdd","DelTreeAdd",{"TraID":node.id},function(jsonString){
				if (jsonString == 0){
					$('#itemCat').tree('reload');
				}else{
					
				}

		     },'',false)
		}
	});
}

/// 删除部位
function delPart(){
	
	var node = $("#itemCat").tree('getSelected');
	var lastnode = $("#itemCat").tree('getParent',node.target);
	$.messager.confirm('确认对话框','确定要删除该分类项目吗？', function(r){
		if (r){
			/// 删除数据
			runClassMethod("web.DHCAPPTreeAdd","DelTreeAdd",{"TraID":node.id},function(jsonString){
				if (jsonString == 0){
					refreshItmCat(lastnode.id);  /// 刷新检查分类树
				}else{
					
				}

		     },'',false)
		}
	});
}

/// 更新节点名称
function updTreeCat(){
	
	var TraID = $("#TraItmID").val();    /// 分类ID
	if (TraID == ""){
		$.messager.alert("提示","分类名称不能为空,请选择!"); 
        return;
	}
	
	var TraItmDesc = $("#TraItmDesc").val();    /// 分类名称
	if (TraItmDesc == ""){
		$.messager.alert("提示","分类名称不能为空,请选择!"); 
        return;
	}
	var TraItmAlias = $("#TraItmAlias").val();  /// 别名
	
	var TraItmType = $("#TraItmType").combobox("getValue");  /// 分类类型  sufan 2018-03-05  
	
	var mListData =TraItmDesc +"^"+ TraItmDesc +"^"+ TraItmAlias +"^"+ TraItmType;

	/// 保存数据
	runClassMethod("web.DHCAPPTreeAdd","UpdTraTreeAdd",{"TraID":TraID, "mListData":mListData},function(jsonString){
		if (jsonString == 0){
			//$.messager.alert("提示","更新成功!");
			closeItmCatWin();      /// 关闭更新窗体
			refreshItmCat(TraID);  /// 刷新检查分类树
		} 
		if(jsonString == "-2"){
		     $.messager.alert("提示","已存在相同项目,请核实!");
		}

     },'',false)
}

/// 获取别名
function GetTreeCatAlias(id){
	
	var ItemDesc = "";
	if (id == "ItemDesc"){
		ItemDesc = $("#ItemDesc").val();    /// 分类名称
	}
	if (id == "TraItmDesc"){
		ItemDesc = $("#TraItmDesc").val();    /// 分类名称
	}
	/// 保存数据
	runClassMethod("web.DHCAPPTreeAdd","GetTreeCatAlias",{"ItemDesc":ItemDesc},function(jsonString){
		if (jsonString != ""){
			if (id == "ItemDesc"){
				$("#ItemAlias").val(jsonString); 
			}
			if (id == "TraItmDesc"){
				$("#TraItmAlias").val(jsonString); 
			}
		}

    },'',false)
	
}

/// 刷新检查分类树
function refreshItmCat(TraID){

	runClassMethod("web.DHCAPPTreeAdd","GetTarILevCon",{"TraID":TraID},function(jsonString){
		if(jsonString){
			nodeArr = jsonString.split("^");
			count = 0;
		}
	},'',false);
	$('#itemCat').tree('reload');
	return;
}

/// 是否允许添加部位项目
/// 当前项目如果已经存在下级分类,不允许添加部位
function isAllowPart(TraID){
	
	var retflag = true;
	runClassMethod("web.DHCAPPTreeAdd","isAllowAddPartItem",{"TraID":TraID},function(jsonString){
		if(jsonString == 0){
			retflag = false;
		}
	},'',false);
	return retflag;
}

/// 是否允许添加分类
/// 当前项目如果已经存在下级分类,且下次分类是部位，此时不允许添加分类类型
function isAllowItmCat(TraID){
	
	var retflag = true;
	runClassMethod("web.DHCAPPTreeAdd","isAllowAddCatItem",{"TraID":TraID},function(jsonString){
		if(jsonString == 1){
			retflag = false;
		}
	},'',false);
	return retflag;
}

/// 删除分类
function delItmCat(){
	
	/// 获取当前节点
	var node = $("#itemCat").tree('getSelected');
	if (node.id.indexOf("^") != "-1"){
		$.messager.alert("提示","当前节点为部位节点,不能使用删除!"); 
        return;
	}
	
	/// 获取当前节点的父节点
	var parNode = $("#itemCat").tree('getParent',node.target);

	$.messager.confirm('确认对话框','确定要删除该项吗？', function(r){
		if (r){
			/// 保存数据
			runClassMethod("web.DHCAPPTreeAdd","delTraTreeAdd",{"TraID":node.id},function(jsonString){
				if (jsonString == 0){
					if (!parNode){
						$('#itemCat').tree('reload');
					}else{
						refreshItmCat(parNode.id);  /// 刷新检查分类树
					}
				} 
				if(jsonString != "0"){
				     $.messager.alert("提示","删除失败!");
				}

		     },'',false)
		}
	});
}


/// 插入检查部位行
function insPartRow(){

	var rowData = $("#itemlist").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("提示","请先选择检查方法!");
		return;
	}
	var TraID = rowData.TraID;   /// 分类表ID
	var ItemID = rowData.ItemID; /// 医嘱项ID

	if(partEditRow>="0"){
		$("#partlist").datagrid('endEdit', partEditRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#partlist").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].ItemPartID == ""){
			$('#partlist').datagrid('selectRow',0);
			$("#partlist").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			dataPartGridBindEnterEvent(0);  //设置回车事件
			return;
		}
	}
	
	$("#partlist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ItemPartID:'', ItemPart:'', ItemID:ItemID, TraID:TraID, TraItmID:''}
	});
	$("#partlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	partEditRow=0;
	
	var rows = $("#partlist").datagrid('getRows');
	if (rows.length != "0"){
		dataPartGridBindEnterEvent(0);  //设置回车事件
	}
}

/// 删除检查项目,部位选中行
function delPartRow(){
	
	var rowsData = $("#partlist").datagrid('getSelected'); /// 选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除吗？", function (res) {
			/// 提示是否删除
			if (res) {
				if (rowsData.TraItmID != ""){
					runClassMethod("web.DHCAPPTreeAdd","DelTreeLink",{"TraItmID":rowsData.TraItmID},function(jsonString){
						$('#partlist').datagrid('reload');    /// 重新加载
					})
				}else{
					var index = $("#partlist").datagrid('getRowIndex',rowsData); /// 行索引
					$("#partlist").datagrid('deleteRow',index);
				}
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

///保存检查项目部位
function savePartRow(){
	
	if(partEditRow>="0"){
		$("#partlist").datagrid('endEdit', partEditRow);
	}

	var rowsData = $("#partlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].ItemPartID==""){
			$.messager.alert("提示","部位不能为空！"); 
			return false;
		}
		var tmp=rowsData[i].TraID+"^"+rowsData[i].ItemID+"^"+rowsData[i].ItemPartID+"^"+rowsData[i].TraItmID;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");

	//保存数据
	runClassMethod("web.DHCAPPTreeAdd","insPartTreeLink",{"params":params},function(jsonString){
		if(jsonString==0){
			$.messager.alert("提示","保存成功!"); 
			$('#partlist').datagrid('reload'); //重新加载
		}
		if(jsonString==-1){
			$.messager.alert("提示","数据重复!"); 
			$('#partlist').datagrid('reload'); //重新加载
		}
	});
}

/// 页面Combobox初始定义
function initCombobox(){

	/// 分类类型
	var option = {
		panelHeight:"auto",
        onSelect:function(option){
	    }
	};
	new ListCombobox("ItemType",'',ItemTypeArr,option).init();
	
	/// 分类类型  sufan 更新时使用
	var option = {
		panelHeight:"auto",
        onSelect:function(option){
	    }
	};
	new ListCombobox("TraItmType",'',ItemTypeArr,option).init();
}

/// 获取节点类型
function GetNodeType(ID){
	
	var nodeType = "";
	runClassMethod("web.DHCAPPExaReportQuery","GetNodeType",{"ID":ID},function(jsonString){
		nodeType = jsonString;
	},'',false)
	return nodeType;
}

//扩展 datagrid combogrid 属性的editor 2016-07-24
$(function(){
	 $.extend($.fn.datagrid.defaults.editors, {
			combogrid: {
				init: function(container, options){
					var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
					input.combogrid(options);
					return input;
				},
				destroy: function(target){
					$(target).combogrid('destroy');
				},
				getValue: function(target){
					return $(target).combogrid('getText');
				},
				setValue: function(target, value){
					$(target).combogrid('setValue', value);
					
				},
				resize: function(target, width){
					$(target).combogrid('resize',width);
				}
			}
	});
})

/// 获取检查分类树别名
function GetTreeAlise(TraID){

	var Tra = "";
	runClassMethod("web.DHCAPPTreeAdd","GetTreeAlise",{"TraID":TraID},function(val){
		if (val != ""){
			TreeAlise = val;
		}
	},'',false)
	return TreeAlise;
}


///授权弹出
var initMenuSecurityWin=function(){
	var winH=GV.maxHeight-100;
	var winW=430;
	$('#menu-security-win').dialog({
		height:winH,
		width:winW,
		title:'项目授权',
		buttons:[
			{
				text:'保存',
				handler:saveMenuSecurity
			},
			{
				text:'关闭',
				handler:function(){
					$('#menu-security-win').dialog('close');
				}	
			}
		]
	});
	$('#menu-security-win-search').searchbox({
		width:winW-20-10,
		searcher:function(value){
			var MenuID=$('#menu-security-win-id').val();
			$('#menu-security-win-list').datagrid('load',{ClassName:'web.DHCAppTreeGroup',QueryName:'QryArcimAuth',MenuID:MenuID,GroupDesc:value});
		}
	})
	$('#menu-security-win-list').datagrid({
		width:winW-20,
		height:winH-207+50,
		bodyCls:'panel-header-gray',
		singleSelect:true,
		pagination:true,
		pageSize:30,
		columns:[[
			{field:'SSGroupDesc',title:'安全组',width:300},
			
			{field:'HasMenuAccess',title:'菜单授权',width:80,align:'center',formatter:function(value,row,index){
				return "<label class='checkbox-label'><input type='checkbox' data-id='"+row.SSGroupID+"'  "+(value=="1"?"checked":"")+"/> </label>";
			}},
			{field:'SSGroupID',title:'ID',hidden:true}
		]],
		idField:'SSGroupID',
		url:"",
		lazy:true,
		toolbar:'#menu-security-win-list-tb'
	})
	function saveMenuSecurity(){
		var MenuID=$('#menu-security-win-id').val();
		if (MenuID == "") {
			return false;
		}
		var data={ClassName:'web.DHCAppTreeGroup',MethodName:'SaveTreeGroup',MenuID:MenuID,Length:0,IdStr:""};
		
		$('#menu-security-win .checkbox-label>input').each(function(i){
			var cid = $(this).data('id');
			data["Length"] = data["Length"] + 1;
			if($(this).is(':checked')){      //不能用attr('checked')=='checked' 判断
				cid = cid + "-1";
				if (data["IdStr"] == "") data["IdStr"] = cid
				else  data["IdStr"] = data["IdStr"] + "," + cid;
			} else {
				cid = cid + "-0";
				if (data["IdStr"] == "") data["IdStr"] = cid
				else  data["IdStr"] = data["IdStr"] + "," + cid;
			}
		})
		$.m(data,function(rtn){
			if(rtn == 0){
				$.messager.popover({msg:'授权保存成功',type:'success',timeout:1000});
				//$.messager.alert("成功","更新授权成功");
				//$('#menu-security-win').dialog('close');
			} else {
				$.messager.popover({msg:'授权保存失败',type:'error',timeout:1000});
			}
		})
	}
	GV.showMenuSecurityWin=function(id,name,caption){
		
		$('#menu-security-win-search').searchbox('setValue','');
		//$('#menu-security-win').find('.i-searchbox tr').eq(0).find('input').val(caption);
		$('#menu-security-win-caption').text(caption);
		//$('#menu-security-win').find('.i-searchbox tr').eq(1).find('input').val(name);
		$('#menu-security-win-name').text(name);
		$('#menu-security-win-id').val(id);
		$('#menu-security-win-list').datagrid('options').url='websys.Broker.cls';
		//alert(id)
		$('#menu-security-win-list').datagrid('unselectAll').datagrid('load',{ClassName:'web.DHCAppTreeGroup',QueryName:'QryArcimAuth',MenuID:id,GroupDesc:''});
		$('#menu-security-win').dialog('open');
	}
	
};
/// 移动检查分类数
function moveTree(mListData){
	
	var InsFlag = false;
	runClassMethod("web.DHCAPPTreeAdd","moveTreeNew",{'mListData':mListData},function(jsonString){
		if (jsonString != 0){
			$.messager.alert("提示","移动出错!","warning"); 
		}else{
			InsFlag = true;
		}
 	},'json',false)
 	return InsFlag;
}
/// JQuery 初始化页面
$(function(){ InitHosp(); })
