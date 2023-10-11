/*
Creator:ShiXiaowei
CreatDate:2018-01-09
Description:知识库编辑器-禁忌症
*/
var GenDr=GlPGenDr
var PointerType=GlPPointerType
var PointerDr=GlPPointer

var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCECGDiseaseC&pClassMethod=SaveConData&pEntityName=web.Entity.KB.DHCECGDiseaseC";
var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCECGDiseaseC&pClassMethod=UpdateConData&pEntityName=web.Entity.KB.DHCECGDiseaseC";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCECGDiseaseC&pClassMethod=DeleteConData";

var DELETE_Disea_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDisease&pClassMethod=DeleteDiseaData";
var DELETE_Exam_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCLibExaItm&pClassMethod=DeleteExamData";
var mode=""
///初始化主索引列表
function InitMyList()
{

	//var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCECGDiseaseC&pClassQuery=GetListCon";
	var gencolumns =[[  
				  {field:'PHINSTText',title:'描述',width:260,sortable:true,sortable:true},
				  {field:'PHINSTRowId',title:'PHINSTRowId',width:30,hidden:true}
				  ]];

	$('#mygrid').datagrid({ 
		width:'100%',
		height:'100%', 
		scrollbarSize :0,
		showHeader:false, 
		fitColumns: true,  //fitColumns	boolean	设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCECGDiseaseC",
			QueryName:"GetListCon",
			TypeDr : "",
			GenDr: GenDr,
			PointerType:PointerType,
			PointerDr:PointerDr
		},
		singleSelect:true,
		idField:'PHINSTRowId', 
		rownumbers:true,
		fixRowNumber:true,
		fit:true,
		remoteSort:false,
		//sortName:"EpisodeID",
		columns:gencolumns,
		onDblClickRow: function() {

		},
		onLoadSuccess:function(data){
			//隐藏行选择数，只按默认显示15个
			//$(".pagination-page-list").hide();
		},
		onLoadError:function(){
		}
	});
}

///级别下拉框
function InitModeCmb()
{

	var modeCmb = $HUI.combobox("#PHINSTModeF",{
		valueField:'id',
		textField:'text',
		data:[
			{id:'W',text:'警示'},
			{id:'C',text:'管控'},
			{id:'S',text:'统计'}			
		],
		onLoadSuccess:function(){
				//获取级别默认值
				$.m({
					ClassName:"web.DHCBL.KB.DHCPHInstLabel",
					MethodName:"GetManageMode",
					code:"ELECTContr"
				},function(txtData){
					mode=txtData
					$('#PHINSTModeF').combobox('setValue', mode);	
				});
		}

	});
}

///生理参数
function InitPhyCmb()
{
	$('#PHYVFeildDrF').combobox({ 
		//url:BindingUom,
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPhysiologyFeild&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHYFRowId',
		textField:'PHYFDesc',
		onSelect:function(record){
			var selVal=record.id
			if(selVal!=""){
				$("#PHYVMinValF").attr("disabled",false); 
	 			$("#PHYVMaxValF").attr("disabled",false); 		
			}else{
				 $("#PHYVMinValF").attr("disabled",true); 
				 $("#PHYVMaxValF").attr("disabled",true);

			}	
		}
		
	});
}

///检验项目
function InitLabDrCmb()
{
	$('#LABILabDrF').combobox({ 
		//url:BindingGen+"&code=LAB",
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=LAB",
		valueField:'PHEGRowId',
		textField:'PHEGDesc',
		onSelect:function(record){
			var selVal=record.id
			if(selVal!=""){
				$("#LABIMinValF").attr("disabled",false); 
				$("#LABIMaxValF").attr("disabled",false); 
				$("#LABIUomDrF").combobox('enable'); 		
			}else{
				 $("#LABIMinValF").attr("disabled",true); 
				 $("#LABIMaxValF").attr("disabled",true); 
				 $("#LABIUomDrF").combobox('disable'); 

			}	
		}
	});
}

///检验项目单位
function InitLabDrUomCmb()
{
	$('#LABIUomDrF').combobox({ 
		//url:BindingUom,
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtUom&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEURowId',
		textField:'PHEUDesc'
	});
}

////**************************************************************病症多选列表初始化*****************************************************************/
///已选病症列表
function InitDiaList()
{
	//var ACTION_URL_Disea = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDisease&pClassQuery=GetDiseaList";

	var diacolumns=[[
					{field:'opt',title:'操作',width:50,align:'center',  
						formatter:function(value,row,index){  
							var btn = '<a class="editcls" onclick="RemoveDia('+index+')" href="#">删除</a>';  
							return btn;  
						}  
					} ,  
				  {field:'PHDISLDiseaDesc',title:'描述',width:220,sortable:true}, 
				  {field:'PHDISLDiseaCode',title:'代码',width:200,sortable:true}, 
				  {field:'PHDDRowId',title:'PHDDRowId',hidden:true},
				  {field:'PHDDDiseaDr',title:'PHDDDiseaDr',hidden:true}
				  ]];


	$('#diaGrid').datagrid({ 
		width:'100%',
		height:'100%', 
		pagination: false, 
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		//toolbar:'#probar',
		fitColumns: true,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		//url:ACTION_URL_Disea,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHDrugDisease",
			QueryName:"GetDiseaList",
			rows:1000
		},
		singleSelect:true,
		idField:'PHDDRowId', 
		rownumbers:true,
		fixRowNumber:true,
		fit:true,
		remoteSort:false,
		//sortName:"EpisodeID",
		columns:diacolumns,
		//onClickRow: ClickProGrid,
		onLoadSuccess:function(data){
			//隐藏行选择数，只按默认显示15个
			//$(".pagination-page-list").hide();
			 $('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'}); 
		},
		onLoadError:function(){
		}
	});
}




///未选病症列表
function InitUnDiaList()
{
	var diseaStr=getChoseDia();

	//var QUERY_UnSelDisea_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseList&pClassQuery=GetUnSelDiseaList";
	var unDiaColumns=[[ 
				  { field: 'ck', checkbox: true, width: '30' },  //复选框  	
				  {field:'PHDISLDiseaDesc',title:'病症描述',width:250,sortable:true}, 
				  {field:'PHDISLDiseaCode',title:'病症代码',width:200,hidden:true}, 
				  {field:'PHDISLRowId',title:'PHDISLRowId',hidden:true}
				  ]];


	$('#unDiaGrid').datagrid({ 
		headerCls:'panel-header-gray',
		width:320,
		height:235, 
		pagination: true, 
	    pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		displayMsg:"",
		bodyCls:'panel-header-gray',
		toolbar:'#myunDiatbar',
		fitColumns: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHDiseaseList",
			QueryName:"GetUnSelDiseaList",
			diseaStr : diseaStr
		},
		singleSelect:false,
		idField:'PHDISLRowId', 
		columns:unDiaColumns
	});
}

////**************************************************************病症多选列表初始化结束*****************************************************************/
////**************************************************************检查列表多选初始化*****************************************************************/
///已选检查列表
function InitExamList()
{
	//var ACTION_URL_Exam = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCLibExaItm&pClassQuery=GetExamList";
	var Examcolumns=[[
					{field:'opt',title:'操作',width:50,align:'center',  
						formatter:function(value,row,index){  
							var btn = '<a class="editcls" onclick="RemoveExam('+index+')" href="#">删除</a>';  
							return btn;  
						}  
					} ,   
				  {field:'ExaCode',title:'代码',width:200,sortable:true},
				  {field:'ExaResult',title:'检查结果',width:220,sortable:true}, 
				  {field:'EXAIRowId',title:'EXAIRowId',hidden:true},
				  {field:'EXAIExamDr',title:'EXAIExamDr',hidden:true}
				  ]];


	$('#ExamGrid').datagrid({ 
		width:'100%',
		height:'100%', 
		pagination: false, 
		pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		//toolbar:'#probar',
		fitColumns: true,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCLibExaItm",
			QueryName:"GetExamList",
			rows:1000
		},
		singleSelect:true,
		idField:'EXAIRowId', 
		rownumbers:true,
		fixRowNumber:true,
		fit:true,
		remoteSort:false,
		columns:Examcolumns,
		onLoadSuccess:function(data){
			//隐藏行选择数，只按默认显示15个
			//$(".pagination-page-list").hide();
			 $('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'}); 
		},
		onLoadError:function(){
		}
	});
}




///未选检查列表
function InitUnExamList()
{
	var examStr=getChoseExam();

	//var QUERY_UnSelExam_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCExamineFeild&pClassQuery=GetUnSelExamList";
	var unExamColumns=[[ 
				  { field: 'ck', checkbox: true, width: '30' },  //复选框  
				  {field:'ExaCode',title:'代码',width:200,hidden:true}, 	
				  {field:'ExaResult',title:'检查结果',width:250,sortable:true}, 
				  {field:'ExaRowId',title:'ExaRowId',hidden:true}
				  ]];


	$('#unExamGrid').datagrid({ 
		headerCls:'panel-header-gray',
		width:320,
		height:235, 
		pagination: true, 
	    pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		displayMsg:"",
		bodyCls:'panel-header-gray',
		toolbar:'#myunExamtbar',
		fitColumns: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCExamineFeild",
			QueryName:"GetUnSelExamList",
			examStr : examStr
		},
		singleSelect:false,
		idField:'ExaRowId', 
		columns:unExamColumns
	});
}

////**************************************************************检查列表多选初始化结束*****************************************************************/


///界面加载代码
function BodyLoadHandler()
{

	//主索引列表
    InitMyList();
    //级别下拉框
	InitModeCmb();
	//检验项目下拉框
	InitLabDrCmb();

	///生理参数
	InitPhyCmb();
	
	//检验项目单位下拉框
	InitLabDrUomCmb();
	
	//主索引列表单击事件
	var opt=$("#mygrid").datagrid('options');
	opt.onClickRow=ClickMyGrid
	//新增
	$("#btnAdd").click(function (e) { 

			AddFunLib(1);

	 })
 
	//更新
	$("#btnUpd").click(function (e) { 

			AddFunLib(2);

	 })

	//删除
	$("#btnDel").click(function (e) { 

			DeleteFunLib();

	 })  
	//重置
	$("#btnRel").click(function (e) { 

			ClearFunLib();

	 }) 
	 
	////*****************************病症多选初始化*****************************************************************/
	//加载病症已选列表
	InitDiaList();
	
	/*//添加病症按钮
	$("#btnAddDia").click(function (e) { 
		UnDiaWindow();
	})*/ 	
	//病症搜索按钮
	$('#btnDiaSearch').searchbox({ 
		searcher:function(value,name){ 
			DiaSearch(value)
			
		}
	}); 	
	//病症重置按钮
	$("#btnDiaReset").click(function (e) { 
		DiaReset();
	}) 	
	//病症保存按钮
	$("#btnDiaSave").click(function (e) { 
		DiaSave();
	}) 
	
	////*****************************病症多选初始化结束*****************************************************************/
	
	////*****************************检查多选初始化*****************************************************************/
    //加载治疗手术已选列表
	InitExamList();
	/*//添加检查按钮
	$("#btnAddExam").click(function (e) { 
		UnExamWindow();
	}) */	
	//检查搜索按钮
	$("#btnExamSearch").searchbox({  
		searcher:function(value,name){ 
			ExamSearch(value)
		}
	}) 		
	//检查重置按钮
	$("#btnExamReset").click(function (e) { 
		ExamReset();
	}) 	
	//检查保存按钮
	$("#btnExamSave").click(function (e) { 
		ExamSave();
	}) 
   ////*****************************检查多选初始化结束*****************************************************************/	

}


///新增、更新
function AddFunLib(opflag)
{            
	if (opflag==2)
	{
		//更新
		var row = $("#mygrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.PHINSTRowId;
		var saveURL=UPDATE_ACTION_URL
	}        		
	
	var code=$.trim($("#PHINSTTextF").val());


	if (code=="")
	{
		$.messager.alert('错误提示','描述不能为空!',"error");
		return;
	}

	if (opflag==1)
	{
		//增加
		var rowid="";
		var saveURL=SAVE_ACTION_URL

	}
	
	//获取已选病症
	var DiaIds=getChoseDiaIds();
	//获取已选检查项
	var ExamIds=getChoseExamIds();
	
	$('#form-save').form('submit', { 
		url: saveURL, 
		onSubmit: function(param){
			param.PHDDInstDr = rowid,
			param.PHINSTOrderNum = "1",
			param.PHINSTGenDr = GenDr,
			param.PHINSTPointerDr = PointerDr,
			param.PHINSTPointerType = PointerType,
			param.PHINSTActiveFlag = "Y",
			param.PHINSTSysFlag = "Y",
			param.PHDDDiseaDr = DiaIds,
			param.PHDDExamDr=ExamIds
		},
		success: function (data) { 
		  var data=eval('('+data+')'); 
		  if (data.success == 'true') {
			$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
			 $('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
			 ClearFunLib();
		  } 
		  else { 
			var errorMsg ="更新失败！"
			if (data.errorinfo) {
				errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
			}
			 $.messager.alert('操作提示',errorMsg,"error");

		}

		} 
	  }); 		




}


///删除
function DeleteFunLib()
{                  

	//更新
	var row = $("#mygrid").datagrid("getSelected"); 
	if (!(row))
	{	$.messager.alert('错误提示','请先选择一条记录!',"error");
		return;
	}
	var rowid=row.PHINSTRowId;
	$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
		if (r)
		{	
			$.ajax({
				url:DELETE_ACTION_URL,  
				data:{"id":rowid},  
				type:"POST",   
				//dataType:"TEXT",  
				success: function(data){
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
							 ClearFunLib()
							 $('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
						  } 
						  else { 
							var errorMsg ="删除失败！"
							if (data.info) {
								errorMsg =errorMsg+ '<br/>错误信息:' + data.info
							}
							 $.messager.alert('操作提示',errorMsg,"error");
		        
						}			
				}  
			})
		}
	})
	

}


///显示表单数据
function ClickMyGrid(rowIndex, rowData)
{
	//ClearFunLib();
	var record = $("#mygrid").datagrid("getSelected"); 
	if (record){
		var InstId = record.PHINSTRowId;
		
		//var check ="F"
		$.cm({
			ClassName:"web.DHCBL.KB.DHCBusMainNew",
			MethodName:"OpenECGConData",
			id:InstId
		},function(jsonData){
			//console.log(jsonData.list)
			//var check = jsonData.PHINSTSex; 
			//$HUI.radio("#sex"+check).setValue(true)
			$('#form-save').form("load",jsonData);			
			//$("input[name='PHINSTSex'][value='" + check + "']").attr("checked", true);
			//$HUI.radio("#sexF").setValue(true);
			var selVal=jsonData.LABILabDr
			if(selVal!=""){
				$("#LABIMinValF").attr("disabled",false); 
				$("#LABIMaxValF").attr("disabled",false); 
				$("#LABIUomDrF").combobox('enable'); 
						
			}else{
				 $("#LABIMinValF").attr("disabled",true); 
				 $("#LABIMaxValF").attr("disabled",true); 
				 $("#LABIUomDrF").combobox('disable'); 

			}
			var selPHYVVal=record.PHYVFeildDr
			if(selPHYVVal!=""){
				$("#PHYVMinValF").attr("disabled",false); 
	 			$("#PHYVMaxValF").attr("disabled",false); 		
			}else{
				 $("#PHYVMinValF").attr("disabled",true); 
				 $("#PHYVMaxValF").attr("disabled",true);

			}	
		});	
		//刷新已选病症列表
		$('#diaGrid').datagrid('load',  {
			ClassName:"web.DHCBL.KB.DHCPHDrugDisease",
			QueryName:"GetDiseaList",			
			InstId:InstId,
			rows:1000
		});
		
		//刷新已选检查列表
		$('#ExamGrid').datagrid('load',  {  
			ClassName:"web.DHCBL.KB.DHCLibExaItm",
			QueryName:"GetExamList",
			InstId:InstId,
			rows:1000
		});
		
		
	}

}


//重置
function ClearFunLib()
{
	//清空表单
	$('#form-save').form('clear');
	//级别赋值
	$('#PHINSTModeF').combobox('setValue', mode);
	//指标值范围不可用 
	 $("#LABIMinValF").attr("disabled",true); 
	 $("#LABIMaxValF").attr("disabled",true); 
	 $("#LABIUomDrF").combobox('disable');
	//生理参数范围不可用
	 $("#PHYVMinValF").attr("disabled",true); 
	 $("#PHYVMaxValF").attr("disabled",true);
	 
	//清空病症数据
	$('#diaGrid').datagrid('loadData', { total: 0, rows: [] });
	
	//清空检查数据
	$('#ExamGrid').datagrid('loadData', { total: 0, rows: [] });

}



////**************************************************************病症多选部分开始*****************************************************************/
/*//点击添加病症按钮
function UnDiaWindow()
{	
	$("#textDia").val("");
	$('#unDiaWindow').window({ 
		 title:"病症",
		 minimizable:false,
		 maximizable:false,
		 collapsible:false,
		 width:300,   
		 height:500,   
		 modal:false //modal-boolean定义窗口是不是模态（modal）窗口-true
	});
	InitUnDiaList();

}*/

///未选病症弹窗
$('#btnAddDia').popover({
		title:"病症",
		width:330,
		height:240,
		content:'<table id="unDiaGrid" ></table>',
		placement:'auto-right',
		closeable:true,
		trigger:'click',
		onShow:function(){
			InitUnDiaList()
			$('#btnDiaSearch').searchbox('setValue', '');
			
			}
	});
	
//病症检索方法
function DiaSearch(desc)
{
	var diseaStr=getChoseDia();
	$('#unDiaGrid').datagrid('load',  { 	
		ClassName:"web.DHCBL.KB.DHCPHDiseaseList",
		QueryName:"GetUnSelDiseaList",
		diseaStr : diseaStr,
		desc: desc
	});
	$('#unDiaGrid').datagrid('unselectAll');
}

//病症重置方法
function DiaReset()
{
	var diseaStr=getChoseDia();	
	$('#btnDiaSearch').searchbox('setValue', '');
	$('#unDiaGrid').datagrid('load',  { 	
		ClassName:"web.DHCBL.KB.DHCPHDiseaseList",
		QueryName:"GetUnSelDiseaList",
		diseaStr : diseaStr,
		desc: ""
	});
	$('#unDiaGrid').datagrid('unselectAll');
}

//病症保存方法
function DiaSave()
{
	var deleteRows = []; 
	var rows = $('#unDiaGrid').datagrid('getSelections');
	
	//已选列表插入选中数据
	for(var i=0; i<rows.length; i++){
		deleteRows.push(rows[i]);
		$("#diaGrid").datagrid("appendRow", {
			    opt:'',
				PHDDRowId:'',
				PHDDDiseaDr:rows[i].PHDISLRowId,
				PHDISLDiseaCode:rows[i].PHDISLDiseaCode,
				PHDISLDiseaDesc:rows[i].PHDISLDiseaDesc
			});
		$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  //操作列显示删除按钮
	}
	
	//未选列表移除选中数据
	for(var i =0;i<deleteRows.length;i++){    
		var index = $('#unDiaGrid').datagrid('getRowIndex',deleteRows[i]);
		$('#unDiaGrid').datagrid('deleteRow',index); 
	}
}

//获取所有已选病症
function getChoseDia()
{
	var ids = [];
	var datas=$('#diaGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		
		var str="<"+datas[i].PHDISLDiseaCode+">"
		ids.push(str);
		
	}
	var diseaStr=ids.join('^')
	return diseaStr
}

//获取所有已选病症的ID
function getChoseDiaIds()
{
	var ids = [];
	var datas=$('#diaGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		if (datas[i].PHDDRowId==""){
		var str=datas[i].PHDDDiseaDr
		ids.push(str);
		}
	}
	var diseaStrIds=ids.join(',')
	return diseaStrIds
}

//移除已选病症
function RemoveDia(index)
{
	$('#diaGrid').datagrid('selectRow',index);// 关键在这里 
	var record = $("#diaGrid").datagrid("getSelected"); 
	if (record){
		var PHDDRowId = record.PHDDRowId;
		if(PHDDRowId==""){  //如果是新加的数据，还没保存，则只是移除
			$('#diaGrid').datagrid('deleteRow',index); 
			var rows = $('#diaGrid').datagrid("getRows");
			$('#diaGrid').datagrid("loadData", rows);
			if($('#unDiaWindow').is(":visible"))  //如果新增病症窗口打开了，则点删除后刷新未选病症列表
			{
				DiaReset();
			}			
		}else{   //如果是已保存的数据直接执行删除操作
			$.ajax({
			url:DELETE_Disea_URL,  
			data:{"id":PHDDRowId},  
			type:"POST",   
			//dataType:"TEXT",  
			success: function(data){
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
						$('#diaGrid').datagrid('deleteRow',index);
						var rows = $('#diaGrid').datagrid("getRows");
						$('#diaGrid').datagrid("loadData", rows); // 重新载入当前页面数据  
						if($('#unDiaWindow').is(":visible"))  //如果新增病症窗口打开了，则点删除后刷新未选病症列表
						{
							DiaReset();
						}
					  } 
					  else { 
						var errorMsg ="删除失败！"
						if (data.info) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.info
						}
						$.messager.alert('操作提示',errorMsg,"error");
			
					}			
				}  
			})		
		}
		
	}

}


////**************************************************************病症多选部分结束*****************************************************************/


////**************************************************************检查多选方法****************************************************************/
/*//点击添加检查按钮
function UnExamWindow()
{	
	$("#textExam").val("");
	$('#unExamWindow').window({ 
		 title:"检查结果",
		 minimizable:false,
		 maximizable:false,
		 collapsible:false,
		 width:300,   
		 height:500,   
		 modal:false //modal-boolean定义窗口是不是模态（modal）窗口-true
	});
	InitUnExamList();

}*/

///未选检查弹窗
$('#btnAddExam').popover({
		title:"检查结果",
		width:330,
		height:240,
		content:'<table id="unExamGrid" ></table>',
		placement:'auto-right',
		closeable:true,
		trigger:'click',
		onShow:function(){
			InitUnExamList()
			$('#btnExamSearch').searchbox('setValue', '');
			
			}
	});
//检查检索方法
function ExamSearch(desc)
{
	var examStr=getChoseExam();
	$('#unExamGrid').datagrid('load',  { 
		ClassName:"web.DHCBL.KB.DHCExamineFeild",
		QueryName:"GetUnSelExamList",
		desc: desc,
		examStr:examStr
	});
	$('#unExamGrid').datagrid('unselectAll');
}

//检查重置方法
function ExamReset()
{
	var examStr=getChoseExam();	
	$('#btnExamSearch').searchbox('setValue', '');
	$('#unExamGrid').datagrid('load',  { 
		ClassName:"web.DHCBL.KB.DHCExamineFeild",
		QueryName:"GetUnSelExamList",
		desc: "",
		examStr:examStr
	});
	$('#unExamGrid').datagrid('unselectAll');
}

//检查保存方法
function ExamSave()
{
	var deleteRows = []; 
	var rows = $('#unExamGrid').datagrid('getSelections');
	
	//已选列表插入选中数据
	for(var i=0; i<rows.length; i++){
		deleteRows.push(rows[i]);
		$("#ExamGrid").datagrid("appendRow", {
			    opt:'',
				EXAIRowId:'',
				EXAIExamDr:rows[i].ExaRowId,
				ExaCode:rows[i].ExaCode,
				ExaResult:rows[i].ExaResult
			});
		$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  //操作列显示删除按钮
	}
	
	//未选列表移除选中数据
	for(var i =0;i<deleteRows.length;i++){    
		var index = $('#unExamGrid').datagrid('getRowIndex',deleteRows[i]);
		$('#unExamGrid').datagrid('deleteRow',index); 
	}
}

//获取所有已选检查
function getChoseExam()
{
	var ids = [];
	var datas=$('#ExamGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		var str="<"+datas[i].ExaCode+">"
		ids.push(str);
	}
	var examStr=ids.join('^')
	return examStr
}

//获取所有已选检查的ID
function getChoseExamIds()
{
	var ids = [];
	var datas=$('#ExamGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		if (datas[i].EXAIRowId==""){
		var str=datas[i].EXAIExamDr
		ids.push(str);
		}
	}
	var examStrIds=ids.join(',')
	return examStrIds
}

//移除已选检查
function RemoveExam(index)
{
	$('#ExamGrid').datagrid('selectRow',index);// 关键在这里 
	var record = $("#ExamGrid").datagrid("getSelected"); 
	if (record){
		var EXAIRowId = record.EXAIRowId;
		if(EXAIRowId==""){  //如果是新加的数据，还没保存，则只是移除
			$('#ExamGrid').datagrid('deleteRow',index); 
			var rows = $('#ExamGrid').datagrid("getRows");
			$('#ExamGrid').datagrid("loadData", rows);			
			if($('#unExamWindow').is(":visible"))  //如果新增检查窗口打开了，则点删除后刷新未选检查列表
			{
				ExamReset();
			}			
		}else{   //如果是已保存的数据直接执行删除操作
			$.ajax({
			url:DELETE_Exam_URL,  
			data:{
				"id":EXAIRowId
			},  
			type:"POST",   
			//dataType:"TEXT",  
			success: function(data){
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
						$('#ExamGrid').datagrid('deleteRow',index); 
						var rows = $('#ExamGrid').datagrid("getRows");
						$('#ExamGrid').datagrid("loadData", rows);	 // 重新载入当前页面数据  
						if($('#unExamWindow').is(":visible"))  //如果新增检查窗口打开了，则点删除后刷新未选检查列表
						{
							ExamReset();
						}
					  } 
					  else { 
						var errorMsg ="删除失败！"
						if (data.info) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.info
						}
						$.messager.alert('操作提示',errorMsg,"error");
			
					}			
				}  
			})		
		}
		
	}

}

////**************************************************************检查多选方法结束****************************************************************/