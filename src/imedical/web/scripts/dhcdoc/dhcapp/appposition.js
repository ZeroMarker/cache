/// Creator: sufan
/// CreateDate: 2016-4-13
//  Descript:后处理字典维护
var TYPE="";
var POINTER="";
var editRow="";editparamRow="";  //当前编辑行号
var dataArray = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];

$(function(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("DHC_AppPosition",hospStr);
	hospComp.jdata.options.onSelect= function(){
		 findAdrStatus(); 
		} 
	var Eventeditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#positionlist").datagrid('getEditor',{index:editRow,field:'hospdesc'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#positionlist").datagrid('getEditor',{index:editRow,field:'aphospdr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	var Flageditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:dataArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#positionlist").datagrid('getEditor',{index:editRow,field:'apactiveflag'});
				$(ed.target).combobox('setValue', option.value);  //设置是否可用
			} 
		}

	}

	// 定义columns
	var columns=[[
		{field:"apcode",title:'代码',width:100,editor:texteditor},
		{field:"apdesc",title:'描述',width:100,editor:texteditor},
	    {field:'apactiveflag',title:'是否可用',width:120,align:'center',editor:Flageditor},
	    {field:"aphospdr",title:'aphospdr',width:100,align:'center',hidden:true},//editor:texteditor,hidden:true},
		{field:'hospdesc',title:'医院',width:220},//editor:Eventeditor},
		{field:"aprowid",title:'ID',width:70,align:'center',hidden:true}
	]];
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
	/*
	// 定义datagrid
	$('#positionlist').datagrid({
		title:'体位字典维护',
		url:LINK_CSP+'?ClassName=web.DHCAPPPosition&MethodName=QueryPosition' ,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:5,  // 每页显示的记录条数
		pageList:[30,60],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != ""||editRow == 0) { 
                $("#positionlist").datagrid('endEdit', editRow); 
            } 
            $("#positionlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	});
	*/
	
	/// bianshuai 2017-01-01 修改，升级1.3.6后页面刷新异常
 	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow === 0)) { 
                $("#positionlist").datagrid('endEdit', editRow); 
            } 
            $("#positionlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
        onClickRow: function (rowIndex, rowData) {//双击选择行编辑
            onClickRowPos(rowIndex,rowData)
        }
	};
	var HospID=$HUI.combogrid('#_HospList').getValue();
 	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPPosition&MethodName=QueryPosition&HospID="+HospID;
	new ListComponent('positionlist', columns, uniturl, option).Init();
	
 	//按钮绑定事件
	$('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    $('#translateword').bind("click",function(){
		var SelectedRow = $("#positionlist").datagrid('getSelected');
		if (!SelectedRow){
		$.messager.alert("提示","请选择需要翻译的行!","info");
		return false;
		}
		CreatTranLate("User.DHCAppPosition","APDesc",SelectedRow["apdesc"])
		
		});
    //同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            //findAdrStatus(this.id+"^"+$('#'+this.id).val()); //调用查询
            findAdrStatus(); //调用查询
        }
    });
    
    // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         findAdrStatus(); //调用查询
    });
    

})

// 插入新行
function insertRow(){
	
	if(editRow>="0"){
		$("#positionlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#positionlist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {aprowid:'', apcode:'', apdesc:'', apactiveflag:'Y',aphospdr:'',hospdesc:''}
	});
	$("#positionlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}
// 删除选中行
function deleteRow(){
	
	var rowsData = $("#positionlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPPosition","DelPosition",{"params":rowsData.aprowid},function(jsonString){
					$('#positionlist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 保存编辑行
function saveRow(){
	if(editRow>="0"){
		$("#positionlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#positionlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].apcode=="")||(rowsData[i].apdesc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
		/*if (rowsData[i].aphospdr==""){
			$.messager.alert("提示","医院不能为空!"); 
			return false;
		}*/
		var tmp=rowsData[i].aprowid +"^"+ rowsData[i].apcode +"^"+ rowsData[i].apdesc +"^"+ rowsData[i].apactiveflag +"^"+ HospID;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCAPPPosition","SavePosition",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#positionlist').datagrid('reload'); //重新加载
	});
}

// 编辑格
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

// 查询
function findAdrStatus()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$('#positionlist').datagrid('load',{params:params,HospID:HospID}); 
}


function onClickRowTar(index,row){
	var e = $("#tardatagrid").datagrid('getColumnOption', 'TarDesc');
	e.editor = {};
	var e = $("#tardatagrid").datagrid('getColumnOption', 'PartNum');
	e.editor = {};
	var e = $("#tardatagrid").datagrid('getColumnOption', 'TarStart');
	e.editor = {};
	CommonRowClick(index,row,"#tardatagrid");
}

function addRow(){
	if((TYPE=="")||(POINTER=="")){
		$.messager.alert('提示','请先选择')
		return
	}
	var HospID=$HUI.combogrid('#_HospList').getValue();
	// sufan 由于双击时，关闭，再点增加，不可编辑
	var e = $("#tardatagrid").datagrid('getColumnOption', 'PartNum');
	e.editor = {type:'numberbox',options:{required:true}};
	var e = $("#tardatagrid").datagrid('getColumnOption', 'TarStart');
	e.editor = {type:'datebox',options:{required:true}};
	var e = $("#tardatagrid").datagrid('getColumnOption', 'TarDesc');
	e.editor = {type:'combogrid',options:{
										required : true,
										id:'AORowId',
										fitColumns:true,
										fit: true,//自动大小
										pagination : true,
										panelWidth:600,
										textField:'desc', 
										mode:'remote',
										url:'dhcapp.broker.csp?ClassName=web.DHCAPPPosLinkTar&MethodName=QueryTar&HospID='+HospID,
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
	commonAddRow({'datagrid':'#tardatagrid',value:{'Pointer':POINTER,'Type':TYPE,'PartNum':1,'TarStart':new Date().Format("yyyy-MM-dd")}})
}

function save(){
	saveByDataGrid("web.DHCAPPPosLinkTar","save","#tardatagrid",function(data){
		if(data==0){
			$.messager.alert('提示','保存成功')
			$('#tardatagrid').datagrid('reload')
		}else if(data==-10){//修改
			$.messager.alert('提示','该收费项已存在')
			$('#tardatagrid').datagrid('reload'); //重新加载
		}else if(data==-11){//修改
			$.messager.alert('提示','开始时间大于结束时间')
			$('#tardatagrid').datagrid('reload'); //重新加载
		}else if(data==-12){
			$.messager.alert('提示','结束日期早于今天')
			$('#tardatagrid').datagrid('reload'); //重新加载
		}else{
			$.messager.alert('提示','保存失败:'+data)
		}
	})
}
function fillValue(rowIndex, rowData){
	$('#tardatagrid').datagrid('getRows')[editIndex]['APLTarDr']=rowData.tarId
	$('#tardatagrid').datagrid('getRows')[editIndex]['TarCode']=rowData.code
	$('#tardatagrid').datagrid('getRows')[editIndex]['TarPrice']=rowData.price
}
function onClickRowPos(index,row){
	TYPE="POS";
	POINTER=row.aprowid
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$('#tardatagrid').datagrid('load',{type:TYPE,pointer:POINTER,hospid:HospID});
}

function onClickRowMed(index,row){
	TYPE="MED";
	POINTER=row.adrowid
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$('#tardatagrid').datagrid('load',{type:TYPE,pointer:POINTER,hospid:HospID});
}
