/// Creator: dws
/// CreateDate: 2017-06-01
//  Descript: 药品关联指标维护

var editRow=""; editmuliRow=""; //当前编辑行号
var hospID=session['LOGON.HOSPID']
//搜索指标列
var PartColumns = [[
	    {field:'IndexCode',title:'代码',width:100},
	    {field:'TestCodeName',title:'名称',width:150},
	]];
$(function(){
	DrugInfo(); //药品信息
	IndexInfo("");
	//查询药品
	$("#find").on('click',function(){
		DrugInfo();
		$('#meduselinkitmdg').datagrid('loadData',{total:0,rows:[]});
	});
	//插入新行
	$("#insmuli").on('click',function(){
		insmuliRow();
	});
	//删除数据
	$("#delmuli").on('click',function(){
		deleteRow();
	});
	//保存数据
	$("#savmuli").on('click',function(){
		savmuliRow();
	});
	
});

//药品信息
function DrugInfo(){
	var code=$("#code").val(); //代码
	var desc=$("#desc").val(); //描述
	$('#meduselinkdg').datagrid({
			url:"dhcapp.broker.csp?ClassName=web.DHCSTPHCMedIndexMonitoringInquiry&MethodName=DrugInfo",
			pageNumber:1, //从第一页显示
			fit:true,
			striped: true, //是否显示斑马线效果	
			frozenColumns:true,  //fitColumns自动初始化宽度，不要与frozenColumns（冻结列）一起使用
			loadMsg:'数据正在加载，请耐心等待', 
			rownumbers:true, //显示行号
			pagination:true, //显示分页工具栏
			singleSelect:true, //单选
			checkOnSelect:true, //点击行就被选中
			pageList : [40,80], // 可以设置每页记录条数的列表
			pageSize : 40 , // 每页显示的记录条数
			
			columns:[[		  //定义接收的数据格式，其中的field要和后台传递过来的相对应
				{field:'Code',title:'代码',width:104},
				{field:'Desc',title:'描述',width:400},
				{field:'Id',title:'ID',width:15,hidden:'true'}								
			]],
			queryParams:{
				code:code,
				desc:desc,
				hospID:hospID
			},
			onClickRow:function(rowIndex, rowData){ //点击药品显示相关的指标
				IndexInfo(rowData.Id)
			}			
	});	
	
}		

//指标信息
function IndexInfo(phdcDr){
	var editorText={
			type:'text',    
			options:{     
				required:true 
			}
	} 
	$('#meduselinkitmdg').datagrid({
			url:"dhcapp.broker.csp?ClassName=web.DHCSTPHCMedIndexMonitoringInquiry&MethodName=IndexInfo",
			pageNumber:1, //从第一页显示
			fit:true,
			striped: true, //是否显示斑马线效果	
			fitColumns:false,  //自动初始化宽度，不要与frozenColumns（冻结列）一起使用
			loadMsg:'数据正在加载，请耐心等待', 
			rownumbers:true, //显示行号
			pagination:true, //显示分页工具栏
			singleSelect:true, //单选
			checkOnSelect:true, //点击行就被选中
			pageList : [20,40], // 可以设置每页记录条数的列表
			pageSize : 20 , // 每页显示的记录条数
			
			columns:[[		  //定义接收的数据格式，其中的field要和后台传递过来的相对应
				{field:'IndexCode',title:'代码',width:120,editor:editorText},
				{field:'TestCodeName',title:'描述',width:300,editor:editorText},
				{field:'Id',title:'ID',hidden:true}							
			]],
			queryParams:{
				phdcDr:phdcDr
			},
			onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
			if ((editmuliRow != "")||(editmuliRow == "0")) {
            	 $("#meduselinkitmdg").datagrid('endEdit', editmuliRow); 
			}    
            $("#meduselinkitmdg").datagrid('beginEdit', rowIndex); 
            editmuliRow = rowIndex; 
            //设置回车事件
            dataIndexGridBindEnterEvent(editmuliRow);
        }			
	});
	$('#meduselinkitmdg').datagrid('loadData',{total:0,rows:[]});	
}		


// 插入新行
function insmuliRow()
{
	var rows=$('#meduselinkdg').datagrid('getSelections')
	if(rows.length<=0){
		$.messager.alert("提示","请选择药品!");
		return;
	}
	if( editmuliRow>="0"){
		$("#meduselinkitmdg").datagrid('endEdit',  editmuliRow);//结束编辑，传入之前编辑的行
	}
	$("#meduselinkitmdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {IndexCode: '',TestCodeName:''}
	});
	$("#meduselinkitmdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editmuliRow=0;
	//设置回车事件
	dataIndexGridBindEnterEvent(editmuliRow);
}

// 删除选中行
function deleteRow()
{
	var rows = $("#meduselinkitmdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				var dgDr=$('#meduselinkdg').datagrid('getSelected').Id; //选中药品id
				var mdgDr=$('#meduselinkitmdg').datagrid('getSelected').Id; //选中药品id
				//alert(dgDr+"*"+mdgDr)
				runClassMethod("web.DHCSTPHCMedIndexMonitoringInquiry","DelIndex",{"phdcDr":dgDr,"testCodeDr":mdgDr},function(data){
					if(data==0){
						//$.messager.alert('提示','删除成功');	
						$('#meduselinkitmdg').datagrid('reload'); //重新加载
					}
					else{
						$.messager.alert('提示','删除失败');
					}
				},'text');
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function savmuliRow()
{
	var dgDr=$('#meduselinkdg').datagrid('getSelected').Id; //选中药品id 
	if( editmuliRow>="0"){
		$("#meduselinkitmdg").datagrid('endEdit',  editmuliRow);
	}
	var rows = $("#meduselinkitmdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].IndexCode=="")||(rows[i].TestCodeName=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}
		var tabId=rows[i].Id; //指标列表里指标id,如果id为空则新增数据，有值则更新数据
		//指标对应的id
		var id=tkMakeServerCall("web.DHCSTPHCMedIndexMonitoringInquiry","GetIndexId",rows[i].IndexCode,rows[i].TestCodeName)
			var tmp=dgDr+"^"+id+"^"+tabId;
			dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&")
	//保存数据
	runClassMethod("web.DHCSTPHCMedIndexMonitoringInquiry","SaveDrugIndex",{"rowstr":rowstr},function(data){
		switch(data){
			case 0:
				$.messager.alert('提示','操作成功');
				break;
			case 3:
				$.messager.alert('提示','代码重复,请核实后再试','warning');
				break;
			default:
				$.messager.alert('提示','操作失败','warning');
				break;
		}
	});
	$('#meduselinkitmdg').datagrid('reload'); //重新加载
}

//设置回车事件
function dataIndexGridBindEnterEvent(editmuliRow){
	var editors = $('#meduselinkitmdg').datagrid('getEditors', editmuliRow);
	var workRateEditor = editors[1];
	workRateEditor.target.focus();  ///设置焦点
	workRateEditor.target.bind('keydown', function(e){
	if (e.keyCode == 13) {
		var ed=$("#meduselinkitmdg").datagrid('getEditor',{index:editmuliRow, field:'TestCodeName'});		
		var input = $(ed.target).val();
		//if (input == ""){return;}
		var unitUrl = LINK_CSP+'?ClassName=web.DHCSTPHCMedIndexMonitoringInquiry&MethodName=GetAllIndexInfo&input='+$(ed.target).val();
		/// 调用指标列表窗口
		new ListComponentWin($(ed.target), input, "400px", "" , unitUrl, PartColumns, setCurrIndexEditRowCellVal).init();
		}
	});
	
}

//选中指标信息填入指标列表
function setCurrIndexEditRowCellVal(rowObj){
	var ed=$("#meduselinkitmdg").datagrid('getEditor',{index:editmuliRow, field:'IndexCode'});
	$(ed.target).val(rowObj.IndexCode);
	var ed=$("#meduselinkitmdg").datagrid('getEditor',{index:editmuliRow, field:'TestCodeName'});		
	$(ed.target).val(rowObj.TestCodeName);
}