//检查项目,部位与收费项对照维护js
//sufan  2016/07/21
var editRow = ""; editTRow = ""; var PartColumns=""; var ArcColumns="";
var PartUrl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonPart';
var ArcUrl = LINK_CSP+'?ClassName=web.DHCAPPTreeAdd&MethodName=QueryArcItmDetail';
var itmmastid =getParam("itmmastid");  ///医嘱项ID
var ServerObj={};
/// 页面初始化函数
function initPageDefault(){
	
	initArcItemList();       ///  初始页面DataGrid检查项目,部位列表
	initBlButton();          ///  页面Button绑定事件
	initColumns();
	commonQuery();
	
}

/// 初始化datagrid列
function initColumns(){
	
	PartColumns = [[
	    {field:'PartDesc',title:'部位',width:200},
	    {field:'LastPartDesc',title:'父部位',width:200},
		{field:'PartID',title:'PartID',width:100}
	]];
	
	ArcColumns = [[
	    {field:'itmDesc',title:'医嘱项名称',width:220},
	    {field:'itmCode',title:'医嘱项代码',width:100},
	    {field:'itmPrice',title:'单价',width:100},
		{field:'itmID',title:'itmID',width:80}
	]];
}

///检查项目,部位列表 
function initArcItemList(){
	
	 // 查找按钮绑定单击事件
	$('#find').bind('click',function(event){
         commonQuery(); //调用查询
    })
    
	//重置按钮绑定单击事件
	$('#reset').bind('click',function(event){
		$('#code').val("");
		$('#desc').val("");
		$('#partdesc').val("");
		commonQuery(); //调用查询
	})		
	
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	var textEditor2={
		type: 'combogrid',//设置编辑格式
		options: {
			required : true,
			id:'PartID',
			fitColumns:true,
			fit: true,//自动大小
			pagination : true,
			panelWidth:600,
			textField:'PartDesc', 
			mode:'remote',
			url:'dhcapp.broker.csp?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonPart',
			columns:[[
				    {field:'PartDesc',title:'部位',width:200},
				    {field:'LastPartDesc',title:'父部位',width:200},
					{field:'PartID',title:'PartID',width:100}
				]],
			onSelect:function(rowIndex, rowData) {
				
				var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ItemPart'});
				$(ed.target).combobox('setText',rowData.PartDesc)
				/// 部位ID
				var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ItemPartID'});		
				$(ed.target).val(rowData.PartID);	
				},
			onBeforeLoad:function(param){
				if (param['q']) {
					var desc=param['q'];
				}
				param = $.extend(param,{PartName:desc,itmmastid:itmmastid});
			}
		}
	}
	/// 部位树
	var textTreeEditor={
		type:'combotree',
		options:{
			url:'dhcapp.broker.csp?ClassName=web.DHCAPPPart&MethodName=getTreeCombo',    
	        onSelect:function(record){    
	            var ed=$("#arcItemList").datagrid('getEditor',{index:editRow,field:'ItemPartID'});
				$(ed.target).val(record.id);  // 检查部位ID   
	        }
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'ItemID',title:'检查项目ID',width:100,hidden:true,editor:textEditor,hidden:true},
		{field:'ItemDesc',title:'检查项目',width:200,editor:textEditor,hidden:true},
		{field:'ItemPartID',title:'部位ID',width:100,hidden:true,editor:textEditor},
		{field:'ItemPart',title:'部位',width:150,editor:textEditor2},
		{field:"AlRowID",title:'ID',hidden:true,editor:textEditor}
	]];
	
	///  定义datagrid  
	var option = {
		rownumbers : true,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
	        var HospID=window.parent.$HUI.combogrid('#_HospList').getValue()
	        if ((rowData.ItemPartID=="")||(typeof rowData.ItemPartID =="undefined")){
		       $('#arctardatagrid').datagrid('loadData',{"rows":[]});
				$('#FindTarItemList').datagrid('loadData',{"rows":[]});
				$('#PostionList').datagrid('loadData',{"rows":[]});
				$('#arctardatagrid2').datagrid('loadData',{"rows":[]});
		    }else{
				$('#arctardatagrid').datagrid('reload',{pointer: itmmastid,PartID:rowData.ItemPartID,hospid:HospID});
				$('#FindTarItemList').datagrid('reload',{arcimid: itmmastid,PartID:rowData.ItemPartID,hospid:HospID});
				$('#PostionList').datagrid('reload',{ArcRowId: itmmastid,PartID:rowData.ItemPartID});
				$('#arctardatagrid2').datagrid('reload',{pointer: rowData.ItemID,PartID:rowData.ItemPartID});
		    }
	    },
	    onDblClickRow: function (rowIndex, rowData) {// 双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#arcItemList").datagrid('endEdit', editRow); 
            } 
            $("#arcItemList").datagrid('beginEdit', rowIndex); 
           // dataArcGridBindEnterEvent(rowIndex);  //设置回车事件
            editRow = rowIndex;
        }
	};
	var param=""+"^"+""+"^"+""+"^"+itmmastid;
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPArclinkTar&MethodName=QueryArcLink"+"&params="+param;
	new ListComponent('arcItemList', columns, uniturl, option).Init(); 
	
}


/// 页面 Button 绑定事件
function initBlButton(){
	
	///  增加检查项目,部位
	$('#arctb a:contains("新增")').bind("click",insertArcRow);
	
	///  保存检查项目,部位
	$('#arctb a:contains("保存")').bind("click",saveArc);
	
	///  删除检查项目,部位
	$('#arctb a:contains("删除")').bind("click",deleteArcRow);
	
	///回车事件 sufan   2016/08/03
	$('#desc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var unitUrl = ArcUrl + "&Input="+$('#desc').val();
			/// 调用医嘱项列表窗口
			new ListComponentWin($('#desc'), "", "600px", "" , unitUrl, ArcColumns, setCurrEditRowCellVal).init();
		}
	});
}

///查询按钮医嘱项响应函数
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		$('#desc').focus().select();  ///设置焦点 并选中内容
		return;
	}
	$('#desc').val(rowObj.itmDesc);  /// 医嘱项
}

/// 插入检查项目部位行
function insertArcRow(){
	if(editRow>="0"){
		$("#arcItemList").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#arcItemList").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {}
	});
	$("#arcItemList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
	
	var rows = $("#arcItemList").datagrid('getRows');
	if (rows.length != "0"){
		dataArcGridBindEnterEvent(0);  //设置回车事件
	}
}
///保存检查项目部位
function saveArc(){
	
	if(editRow>="0"){
		$("#arcItemList").datagrid('endEdit', editRow);
	}
	var rowsData = $("#arcItemList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		/*if((rowsData[i].ItemID=="")||(rowsData[i].ItemDesc=="")){
			$.messager.alert("提示","检查项目不能为空！"); 
			return false;
		}*/
		if ((rowsData[i].ItemPartID=="")||(rowsData[i].ItemPart=="")){
			$.messager.alert("提示","部位不能为空！"); 
			return false;
			}  //sufan  2017-1-23
		var tmp=rowsData[i].AlRowID+"^"+itmmastid+"^"+""+"^"+rowsData[i].ItemPartID+"^"+ rowsData[i].ItemPart;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCAPPArclinkTar","SaveArcLink",{"params":params},function(jsonString){
		if(jsonString==0){
			$.messager.alert("提示","保存成功!");
			commonQuery(); 
			//$('#arcItemList').datagrid('reload'); //重新加载
		}
		if(jsonString==-10){
			$.messager.alert("提示","数据重复!"); 
			commonQuery();
			//$('#arcItemList').datagrid('reload'); //重新加载
		}
	});
}

/// 删除检查项目,部位选中行
function deleteArcRow(){
	
	var rowsData = $("#arcItemList").datagrid('getSelected'); //选中要删除的行
	var rowsTarData=$("#arctardatagrid").datagrid("getRows"); // 判断收费项datagrid是否有数据  sufan  2017-1-23
	if (rowsTarData.length>1){
		$.messager.alert('提示','请先删除关联的收费项','warning');
		return false;
		}
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPArclinkTar","DeleteArcLink",{"AlRowID":rowsData.AlRowID},function(jsonString){
					$('#arcItemList').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}	 
///插入收费项列表
function addRow(){
	var rowsMData = $("#arcItemList").datagrid('getSelected'); //选中左边的检查项目、部位行
	if (rowsMData == null){
		$.messager.alert("提示", "请选择检查项目&部位！");
		return;
	}
	// sufan 由于双击时，关闭，再点增加，不可编辑
	var e = $("#arctardatagrid").datagrid('getColumnOption', 'PartNum');
	e.editor = {type:'numberbox',options:{required:true}};
	var e = $("#arctardatagrid").datagrid('getColumnOption', 'TarStart');
	e.editor = {type:'datebox',options:{required:true}};
	var HospID=window.parent.$HUI.combogrid('#_HospList').getValue()
	var e = $("#arctardatagrid").datagrid('getColumnOption', 'TarDesc');
	e.editor = {type:'combogrid',options:{
										required : true,
										id:'AORowId',
										fitColumns:true,
										fit: true,//自动大小
										pagination : true,
										panelWidth:600,
										textField:'desc', 
										mode:'remote',
										url:'dhcapp.broker.csp?ClassName=web.DHCAPPPosLinkTar&MethodName=QueryTar&HospID='+window.parent.$HUI.combogrid('#_HospList').getValue(),
										columns:[[
												{field:'tarId',hidden:true},
												{field:'code',title:'代码',width:60},
												{field:'desc',title:'名称',width:100},
												{field:'price',title:'收费项价格',width:40}
												]],
												onSelect:function(rowIndex, rowData) {
			                   					fillValue(rowIndex, rowData);
			                				}	
										}
									};

	commonAddRow({'datagrid':'#arctardatagrid',value:{'ArcId':rowsMData.ItemID,'BaseFlag':'Y','PartNum':1,'TarStart':new Date().Format("yyyy-MM-dd"),'PartID':rowsMData.ItemPartID}})
}

///如果是合计行,则不能编辑
function onClickRowDisc(index,row){
	if(row.TarCode=="合计:") return;
	var e = $("#arctardatagrid").datagrid('getColumnOption', 'TarDesc');
	if (e) e.editor = {};
	var e = $("#arctardatagrid").datagrid('getColumnOption', 'PartNum');
	if (e) e.editor = {};
	var e = $("#arctardatagrid").datagrid('getColumnOption', 'TarStart');
	if (e) e.editor = {};
	CommonRowClick(index,row,"#arctardatagrid");
}

///行编辑
function onClickRow(index,row){
	
	 CommonRowClick(index,row,"#PostionList");
}

///插入空行
function addRowPos(){
	
	var rowsMData = $("#arcItemList").datagrid('getSelected'); //选中左边的检查项目、部位行
	if (rowsMData == null){
		$.messager.alert("提示", "请选择检查项目&部位！","warning");
		return;
	}
	commonAddRow({'datagrid':'#PostionList',value:{'ArcDr':rowsMData.ItemID,'PartID':rowsMData.ItemPartID}})  
}

///删除 
function cancelPos(){
	
	if ($("#PostionList").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
	    if (r){
		    var row =$("#PostionList").datagrid('getSelected');     
			 runClassMethod("web.DHCAppArcLinkPos","remove",{'Id':row.ID},function(data){ $('#PostionList').datagrid('load'); })
	    }    
	}); 
}

/// 保存
function savePos(){
	
	saveByDataGrid("web.DHCAppArcLinkPos","save","#PostionList",function(data){
			if(data==0){
				$("#PostionList").datagrid('reload')
			}else if(data == -1){
				$.messager.alert('提示','不可重复保存:'+data)
				$("#PostionList").datagrid('reload')
			}else{
				$.messager.alert('提示','保存失败！'+data)
			}
		});	
}

///保存收费项列表
function save(){
	saveByDataGrid("web.DHCAPPArclinkTar","save","#arctardatagrid",function(data){
		if(data==0){
			$.messager.alert('提示','保存成功')
			$('#arctardatagrid').datagrid('reload')
			$('#FindTarItemList').datagrid('reload')
		}else if(data == -1){
			$.messager.alert('提示','不可重复保存:'+data)
			$('#arctardatagrid').datagrid('reload');
			$('#FindTarItemList').datagrid('reload');
		}else if(data == -2){
			$.messager.alert('提示','收费项不能为空:'+data)
			$('#arctardatagrid').datagrid('reload');
			$('#FindTarItemList').datagrid('reload');
		}else if(data==-11){
			$.messager.alert('提示','开始时间大于结束时间')
			$('#arctardatagrid').datagrid('reload')
		}else if(data==-12){
			$.messager.alert('提示','结束日期早于今天')
			$('#arctardatagrid').datagrid('reload')
		}else{
			$.messager.alert('提示','保存失败:'+data)
			$('#arctardatagrid').datagrid('reload')
		}
	})
}
/// 删除收费项选中行
function deleteTarRow(){
	
	var rowsData = $("#arctardatagrid").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPArclinkTar","DeleteArclinkTar",{"AltRowID":rowsData.ID},function(jsonString){
					$('#arctardatagrid').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
///调用取值函数
function fillValue(rowIndex, rowData){
	$('#arctardatagrid').datagrid('getRows')[editIndex]['TarDr']=rowData.tarId
	$('#arctardatagrid').datagrid('getRows')[editIndex]['TarCode']=rowData.code
	$('#arctardatagrid').datagrid('getRows')[editIndex]['TarPrice']=rowData.price
}
 
/// 给检查项目,部位datagrid绑定回车事件
function dataArcGridBindEnterEvent(index){
	
	var editors = $('#arcItemList').datagrid('getEditors', index);
	/// 检查项目名称
	var workRateEditor = editors[1];
	workRateEditor.target.focus();  ///设置焦点
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#arcItemList").datagrid('getEditor',{index:index, field:'ItemDesc'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var unitUrl = ArcUrl + "&Input="+$(ed.target).val();
			/// 调用医嘱项列表窗口
			new ListComponentWin($(ed.target), input, "600px", "" , unitUrl, ArcColumns, setCurrArcEditRowCellVal).init();
		}
	});
	
	/// 检查部位名称
	var workRateEditor = editors[3];
	//workRateEditor.target.focus();  ///设置焦点
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#arcItemList").datagrid('getEditor',{index:index, field:'ItemPart'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var unitUrl = PartUrl + "&PartName="+$(ed.target).val()//+"&itmmastid="+itmmastid;
			/// 调用部位列表窗口
			new ListComponentWin($(ed.target), input, "600px", "" , unitUrl, PartColumns, setCurrArcEditRowCellVal).init();
		}
	});
}

/// 给当前编辑列赋值(检查项目)
function setCurrArcEditRowCellVal(rowObj){
	if (rowObj == null){
		var editors = $('#arcItemList').datagrid('getEditors', editRow);
		///检查项目
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();  ///设置焦点 并选中内容
		return;
	}
	if (typeof rowObj.itmDesc != "undefined"){
		/// 项目名称
		var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ItemDesc'});
		$(ed.target).val(rowObj.itmDesc);
		/// 项目名称ID
		var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ItemID'});		
		$(ed.target).val(rowObj.itmID);
	}else{
		/// 部位名称
		var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ItemPart'});
		$(ed.target).val(rowObj.PartDesc);
		/// 部位ID
		var ed=$("#arcItemList").datagrid('getEditor',{index:editRow, field:'ItemPartID'});		
		$(ed.target).val(rowObj.PartID);
	}
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
/// 按医嘱项或代码查询函数
function commonQuery() 
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var part=$('#partdesc').val();
	var param=""+"^"+""+"^"+""+"^"+itmmastid;
	$('#arcItemList').datagrid('load',{params:param}); 
}
function addARCItemRow(){
    var rowsMData = $("#arcItemList").datagrid('getSelected'); //选中左边的检查项目、部位行
	if (rowsMData == null){
		$.messager.alert("提示", "请选择检查项目&部位！");
		return;
	}
	// tanjishan 由于双击时，关闭，再点增加，不可编辑
	var e = $("#arctardatagrid2").datagrid('getColumnOption', 'TarDesc');
	if (e) {
		if (typeof ServerObj.TarDescEditor!="undefined"){
			$.extend(e.editor,ServerObj.TarDescEditor);
		}
	}
	var e = $("#arctardatagrid2").datagrid('getColumnOption', 'PartNum');
	if (e) {
		if (typeof ServerObj.PartNumEditor!="undefined"){
			$.extend(e.editor,ServerObj.PartNumEditor);
		}
	}
	var e = $("#arctardatagrid2").datagrid('getColumnOption', 'TarStart');
	if (e) {
		if (typeof ServerObj.TarStartEditor!="undefined"){
			$.extend(e.editor,ServerObj.TarStartEditor);
		}
	}
	commonAddRow({'datagrid':'#arctardatagrid2',value:{'ArcId':rowsMData.ItemID,'BaseFlag':'Y','PartNum':1,'PartID':rowsMData.ItemPartID}})
}
function saveARCItem(){
	saveByDataGrid("web.DHCAPPArclinkTar","saveArc","#arctardatagrid2",function(data){
			if(data==0){
				$.messager.alert('提示','保存成功')
				$('#arctardatagrid2').datagrid('reload')
				$('#FindTarItemList').datagrid('reload')
			}else if(data==-11){
				$.messager.alert('提示','开始时间大于结束时间')
				//$('#arctardatagrid2').datagrid('reload')
			}else if(data==-12){
				$.messager.alert('提示','结束日期早于今天')
				//$('#arcitemdatagrid2').datagrid('reload')
			}else if(data==-3){
				$.messager.alert('提示','代码重复')
				//$('#arcitemdatagrid2').datagrid('reload')
			}else if(data==-4){
				$.messager.alert('提示','年龄范围格式错误')
				//$('#arcitemdatagrid2').datagrid('reload')
			}else if(data==-5){
				$.messager.alert('提示','日期范围格式错误')
				//$('#arcitemdatagrid2').datagrid('reload')
			}else{
				$.messager.alert('提示','保存失败:'+data)
				$('#arctardatagrid2').datagrid('reload')
			}
		})
}
function deleteARCItemRow(){
	var rowsData = $("#arctardatagrid2").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPArclinkTar","DeleteArclinkArc",{"AltRowID":rowsData.ID},function(jsonString){
					$('#arctardatagrid2').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
function onClickRowDisc2(index,row){
	if(row.TarCode=="合计:") return;
	var e = $("#arctardatagrid2").datagrid('getColumnOption', 'TarDesc');
	if (e) {
		if (typeof ServerObj.TarDescEditor=="undefined"){
			ServerObj.TarDescEditor={};
			$.extend(true,ServerObj.TarDescEditor,e.editor);
		}
		e.editor = {};
	}
	var e = $("#arctardatagrid2").datagrid('getColumnOption', 'PartNum');
	if (e) {
		if (typeof ServerObj.PartNumEditor=="undefined"){
			ServerObj.PartNumEditor={};
			$.extend(true,ServerObj.PartNumEditor,e.editor);
		}
		e.editor = {};
	}
	var e = $("#arctardatagrid2").datagrid('getColumnOption', 'TarStart');
	if (e) {
		if (typeof ServerObj.TarStartEditor=="undefined"){
			ServerObj.TarStartEditor={};
			$.extend(true,ServerObj.TarStartEditor,e.editor);
		}
		e.editor = {};
	}
	CommonRowClick(index,row,"#arctardatagrid2");
}
 function fillValue2(rowIndex, rowData){
	$('#arctardatagrid2').datagrid('getRows')[editIndex]['TarDr']=rowData.tarId
	//$('#arctardatagrid2').datagrid('getRows')[editIndex]['TarCode']=rowData.code
	//$('#arctardatagrid2').datagrid('getRows')[editIndex]['TarPrice']=rowData.price
}
 function fillValue3(rowIndex, rowData){
	$('#arctardatagrid2').datagrid('getRows')[editIndex]['ByHandleValue']=rowIndex.id;
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
