
var editRow = "";     /// 当前编辑行号
var funLibItmID = ""; /// 主题函数子项目ID
var funLibItmType=""; /// 主题函数子项目type   wangxuejian 2016-09-21
var arcColumns=""; 
var url = "dhcpha.clinical.action.csp"; 

/// 页面初始化函数
function initPageDefault(){
	
	funLibItmID=getParam("funLibItmID");
	funLibItmType=getParam("funLibItmType")
	initDataGrid();  ///  页面DataGrid初始定义
	initBlButton();  ///  页面Button 绑定事件
	initColumns();   ///  初始化datagrid列表
}
/// 初始化datagrid列表
function initColumns(){
	
	arcColumns = [[
	    {field:'itmDesc',title:'项目名称',width:220},
	    {field:'itmCode',title:'项目代码',width:100},
		{field:'itmID',title:'itmID',width:80}
	]];
}

/// 页面DataGrid初始定义
function initDataGrid(){
	
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'itmID',title:'ItmID',width:100,hidden:true},
		{field:'itmCode',title:'项目代码',width:100,editor:textEditor},
		{field:'itmDesc',title:'项目名称',width:160,editor:textEditor},
		{field:'itmMinVal',title:'最小值',width:100,editor:textEditor},
		{field:'itmMaxVal',title:'最大值',width:100,editor:textEditor}
	]];
	
	///  定义datagrid
	var option = {
		title:'检验指标列表',    //wangxuejian 2016-10-12
		singleSelect : true,
		showPageList : false,
        onClickRow:function(rowIndex, rowData){
	    },
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑 qunianpeng 2016-08-02
            if ((editRow != "")||(editRow == "0")) {
            	$("#dgItmList").datagrid('endEdit', editRow); 
			}
            $("#dgItmList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
            itmUpdate(editRow)   //wangxuejian 2016-10-12  更新带出回车事件
        },
		onLoadSuccess:function(data){
		}
	};

	var uniturl = url + "?action=QueryFunLibArt&params="+funLibItmID+"&sType=L";
	new ListComponent('dgItmList', columns, uniturl, option).Init();
	 
}

/// 页面 Button 绑定事件
function initBlButton(){
	
	///  查询
	$('a:contains("查询")').bind("click",itmFind);
	
	///  添加
	$('a:contains("添加")').bind("click",itmAdd);
	
	///  删除
	$('a:contains("删除")').bind("click",itmDel);
		
	///  保存
	$('a:contains("保存")').bind("click",itmSave);

       //同时给代码和描述绑定回车事件    wangxuejian 2016-10-12
        $('#itmcode,#itmdesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            itmFind(); //调用查询
        }
    });
}

/// 查询
function itmFind(){                            //wangxuejian 2016-10-12
	
	var itmCode = $("#itmcode").val();  /// 代码
	var itmDesc = $("#itmdesc").val();  /// 描述
        var sType="L";
	var params = funLibItmID +"^"+ itmCode +"^"+ itmDesc;
	$("#dgItmList").datagrid("reload",{"params":params,"sType":sType});
}

/// 添加
function itmAdd(){
	
	if(editRow>="0"){
		$("#dgItmList").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#dgItmList").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {itmID: '',ItmCode:'',ItmDesc: ''}//wangxuejian 2016-10-12
	});
	$("#dgItmList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	dataGridBindEnterEvent(0);  			 //设置回车事件
	editRow=0;
}

/// 更新
function itmUpdate(index){                                                           //wangxuejian 2016-10-12
	$("#dgItmList").datagrid('beginEdit', index);//开启编辑并传入要编辑的行
	dataGridBindEnterEvent(index);  			 //设置回车事件
}

/// 给datagrid绑定回车事件
function dataGridBindEnterEvent(index){
	
	var editors = $('#dgItmList').datagrid('getEditors', index);
	/// 名称
	var workRateEditor = editors[1];
	workRateEditor.target.focus();  ///设置焦点
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#dgItmList").datagrid('getEditor',{index:index, field:'itmDesc'});		
			if ($(ed.target).val() == ""){return;}
			var unitUrl = url+'?action=QueryLabItmDetail&Input='+$(ed.target).val();
			/// 调用医嘱项列表窗口
			new ListComponentWin($(ed.target), "", "600px", "" , unitUrl, arcColumns, setCurrEditRowCellVal).init();
		}
	});
}

/// 给当前编辑列赋值
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		var editors = $('#dgItmList').datagrid('getEditors', editRow);
		///药品名称
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();  ///设置焦点 并选中内容
		return;
	}
	///代码
	var ed=$("#dgItmList").datagrid('getEditor',{index:editRow, field:'itmCode'});
	$(ed.target).val(rowObj.itmCode);
	///名称
	var ed=$("#dgItmList").datagrid('getEditor',{index:editRow, field:'itmDesc'});		
	$(ed.target).val(rowObj.itmDesc);
	var rows = $('#dgItmList').datagrid('getRows');  //hezg 添加药品过滤一样的
	for(var j=0;j<rows.length;j++){
		if(rowObj.itmCode==rows[j].itmCode){
			alert("项目已存在'"+rows[j].itmDesc+"',请重新选择添加!");
			$.post(url+'?action=delFunLibArt',{"itmID":rowObj.itmID}, function(data){
					$('#dgItmList').datagrid('reload'); //重新加载
					$("#dgItmList").datagrid('loadData',{total:0,rows:[]}); 
				});
			
			}
		}
}

/// 删除
function itmDel(){
	
	var rows = $("#dgItmList").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=delFunLibArt',{"itmID":rows[0].itmID}, function(data){
					$('#dgItmList').datagrid('reload'); //重新加载
                                $("#dgItmList").datagrid('loadData',{total:0,rows:[]});  //wangxuejian 2016-10-11

				});
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 保存
function itmSave(){
	
	if(editRow>="0"){
		$("#dgItmList").datagrid('endEdit', editRow);
	}

	var rows = $("#dgItmList").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++){
		if((rows[i].itmCode=="")||(rows[i].itmDesc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;	
		}
		if(rows[i].itmMinVal==""||rows[i].itmMaxVal==""){  //qunianpeng 2016-10-10
			$.messager.alert("提示","最小值或最大值不能为空!");
			return false;
		}
		if(rows[i].itmMinVal*1>rows[i].itmMaxVal*1){  //qunianpeng 2016-08-02
			$.messager.alert("提示","最小值应小于最大值!");
			return false;
		}
		 if(!(/(^-?[0-9][0-9]*(.[0-9]+)?)$/.test(rows[i].itmMinVal))){ //lbb  2020.2.26
            alert("最小值应为数字");
            return
       }
        if(!(/(^-?[0-9][0-9]*(.[0-9]+)?)$/.test(rows[i].itmMaxVal))){ //lbb  2020.2.26
            alert("最大值应为数字");
            return
       }
	
		var tmp=rows[i].itmID +"^"+ funLibItmID +"^"+ rows[i].itmCode.replace(/^\s*/g,"") +"^"+ rows[i].itmMinVal +"^"+ rows[i].itmMaxVal

		dataList.push(tmp);
	} 
	var ListData=dataList.join("&");

	//保存数据
	$.post(url+'?action=saveFunLibArt',{"ListData":ListData},function(data){
		if(data==0){
			$.messager.alert("提示","保存成功!"); 
		}
		$('#dgItmList').datagrid('reload'); //重新加载
	});
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })