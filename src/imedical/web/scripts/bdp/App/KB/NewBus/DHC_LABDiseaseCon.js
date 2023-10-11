/*
Creator:Dingyanan
CreatDate:2018-01-10
Description:检验项目-禁忌症
*/
var GenDr=GlPGenDr
var PointerType=GlPPointerType
var PointerDr=GlPPointer

var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCLABDiseaseC&pClassMethod=SaveConData&pEntityName=web.Entity.KB.DHCLABDiseaseC";
var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCLABDiseaseC&pClassMethod=UpdateConData&pEntityName=web.Entity.KB.DHCLABDiseaseC";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCLABDiseaseC&pClassMethod=DeleteConData";
var DELETE_Disea_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCLABDiseaseI&pClassMethod=DeleteDiseaData";
var AGE_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassMethod=getMaxMin";
var DELETE_Popu_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCLibSpecPopuItm&pClassMethod=DeletePopuData";

	
	
var mode=""
///初始化主索引列表
function InitMyList()
{

	//var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCLABDiseaseC&pClassQuery=GetListCon";
	var gencolumns =[[  
				  {field:'PHINSTText',title:'描述',width:260},
				  {field:'PHINSTRowId',title:'PHINSTRowId',width:30,hidden:true}
				  ]];
	$('#mygrid').datagrid({ 
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCLABDiseaseC",
			QueryName:"GetListCon",
			TypeDr : "",
			GenDr: GenDr,
			PointerType:"Form",
			PointerDr:PointerDr
		},
		fitColumns: true,  //fitColumns	boolean	设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		singleSelect:true,
		idField:'PHINSTRowId', 
		rownumbers:true,
		fixRowNumber:true,
		showHeader:false,
		scrollbarSize :0,
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
					code:"LabContr"
				},function(txtData){
					mode=txtData
					$('#PHINSTModeF').combobox('setValue', mode);	
				});
		}

	});
}
///年龄
function InitAgeCmb()
{
	$('#PDAAgeDrF').combobox({ 
		//var Age_Dr_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassQuery=GetDataForCmb1";
		//url:Age_Dr_QUERY_ACTION_URL,
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHPatAgeList&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PDARowID',
		textField:'PDAAgeDesc',
		panelWidth:140,
		onSelect:function(record){
				var rowid=record.PDARowID
				$.ajax({
				url:AGE_ACTION_URL,  
				data:{"id":rowid},  
				type:"POST",   
				//dataType:"TEXT",  
				success: function(data){
						var data=eval('('+data+')'); 
						var PDAAgeMin=data.PDAAgeMin;
						$("#PDAMinValF").val(PDAAgeMin);
						var PDAAgeMax=data.PDAAgeMax;
						$("#PDAMaxValF").val(PDAAgeMax);
						var PDAUomDr=data.PDAUomDr;
						$('#PDAUomDrF').combobox('setValue', PDAUomDr);					
				}  
			})		
		}
	});
}

///年龄单位
function InitAgeUomCmb()
{
	$('#PDAUomDrF').combobox({ 
		//url:UOM_DR_QUERY_ACTION_URL,
		//var UOM_DR_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassQuery=GetDataForCmbYMD";
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHPatAgeList&QueryName=GetDataForCmbYMD&ResultSetType=array",
		valueField:'PHEURowId',
		textField:'PHEUDesc'
	});
}
////**************************************************************病症多选列表初始化*****************************************************************/
///已选病症列表
function InitDiaList()
{
	//var ACTION_URL_Disea = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCLABDiseaseI&pClassQuery=GetDiseaList";
	var diacolumns=[[
					{field:'opt',title:'操作',width:50,align:'center',  
						formatter:function(value,row,index){  
							var btn = '<a class="editcls" onclick="RemoveDia('+index+')" href="#">删除</a>';  
							return btn;  
						}  
					} ,  
				  {field:'PHDISLDiseaDesc',title:'描述',width:260}, 
				  {field:'PHDISLDiseaCode',title:'代码',width:200}, 
				  {field:'PHDDRowId',title:'PHDDRowId',hidden:true},
				  {field:'PHDDDiseaDr',title:'PHDDDiseaDr',hidden:true}
				  ]];


	$('#diaGrid').datagrid({ 
		width:'100%',
		height:'100%', 
		pagination: false, 
		pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		//toolbar:'#probar',
		fitColumns: true,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		//url:ACTION_URL_Disea,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCLABDiseaseI",
			QueryName:"GetDiseaList",
			rows:1000
		},
		singleSelect:true,
		idField:'PHDDRowId', 
		rownumbers:true,
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
var diseaStr="";//2016-08-09
function InitUnDiaList()
{
	var diseaStr=getChoseDia();

	var unDiaColumns=[[ 
				  { field: 'ck', checkbox: true, width: '30' },  //复选框  	
				  {field:'PHDISLDiseaDesc',title:'病症描述',width:250}, 
				  {field:'PHDISLDiseaCode',title:'病症代码',width:200,hidden:true}, 
				  {field:'PHDISLRowId',title:'PHDISLRowId',hidden:true}
				  ]];


	$('#unDiaGrid').datagrid({ 
		bodyCls:'panel-header-gray',
		width:320,
		height:235, 
		pagination: true, 
	    pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		displayMsg:"",
		toolbar:'#myunDiatbar',
		fitColumns: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCLABDiseaseI",
			QueryName:"GetUnSelDiseaList",
			diseaStr : diseaStr
		},
		idField:'PHDISLRowId', 
		columns:unDiaColumns
	});
}

////**************************************************************病症多选列表初始化结束*****************************************************************/
	
////**************************************************************特殊人群列表多选初始化*****************************************************************/
///已选特殊人群列表
function InitPopuList()
{
	//var ACTION_URL_Popu = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCLibSpecPopuItm&pClassQuery=GetPopuList";
	var Popucolumns=[[
					{field:'opt',title:'操作',width:50,align:'center',  
						formatter:function(value,row,index){  
							var btn = '<a class="editcls" onclick="RemovePopu('+index+')" href="#">删除</a>';  
							return btn;  
						}  
					} ,  
				  {field:'SPEDesc',title:'描述',width:260}, 
				  {field:'SPECode',title:'代码',width:200}, 
				  {field:'SPEPIRowId',title:'SPEPIRowId',hidden:true},
				  {field:'SPEPISpecDr',title:'SPEPISpecDr',hidden:true}
				  ]];


	$('#PopuGrid').datagrid({ 
		width:'100%',
		height:'100%', 
		pagination: false, 
		pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		//toolbar:'#probar',
		fitColumns: true,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		//url:ACTION_URL_Organism,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCLibSpecPopuItm",
			QueryName:"GetPopuList",
			rows:1000
		},
		singleSelect:true,
		idField:'SPEPIRowId', 
		rownumbers:true,
		fit:true,
		remoteSort:false,
		//sortName:"EpisodeID",
		columns:Popucolumns,
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

///未选特殊人群列表
var PopuStr="" //2017-04-01
function InitUnPopuList()
{
	var PopuStr=getChosePopu();
	//alert(PopuStr)
	//特殊人群
	//var QUERY_UnSelPopu_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCSpecialPopu&pClassQuery=GetUnSelPopuList";
	var unPopuColumns=[[ 
				  { field: 'ck', checkbox: true, width: '30' },  //复选框  	
				  {field:'SPEDesc',title:'描述',width:250}, 
				  {field:'SPECode',title:'代码',width:200,hidden:true}, 
				  {field:'SPERowId',title:'SPERowId',hidden:true}
				  ]];


	$('#unPopuGrid').datagrid({ 
		bodyCls:'panel-header-gray',
		width:320,
		height:235, 
		pagination: true, 
	    pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		displayMsg:"",
		toolbar:'#myunPoputbar',
		fitColumns: true,
		loadMsg:'数据装载中......',
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCSpecialPopu",
			QueryName:"GetUnSelPopuList",
			PopuStr : PopuStr
		},
		singleSelect:false,
		idField:'SPERowId', 
		rownumbers:false,
		columns:unPopuColumns
	});
}

////**************************************************************特殊人群列表多选初始化结束*****************************************************************/
	
///界面加载代码
function BodyLoadHandler()
{

	//主索引列表
    InitMyList();
    //级别下拉框
	InitModeCmb();

	//年龄下拉框
	InitAgeCmb();
	//年龄单位框
	InitAgeUomCmb();
	
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
	
	////*****************************特殊人群多选初始化*****************************************************************/
    //加载特殊人群已选列表
	InitPopuList();

	//特殊人群搜索按钮	
	$('#btnPopuSearch').searchbox({ 
		searcher:function(value,name){ 
			PopuSearch(value)
			
		}
	});
	//特殊人群重置按钮
	$("#btnPopuReset").click(function (e) { 
		PopuReset();
	}) 	
	//特殊人群保存按钮
	$("#btnPopuSave").click(function (e) { 
		PopuSave();
	}) 
   ////*****************************特殊人群多选初始化结束*****************************************************************/	
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
	
	//获取已选特殊人群
	var PopuIds=getChosePopuIds();
	
	$('#form-save').form('submit', { 
		url: saveURL, 
		onSubmit: function(param){
			param.PHDDInstDr = rowid,
			param.PHINSTOrderNum = "1",
			param.PHINSTGenDr = GenDr,
			param.PHINSTPointerDr = PointerDr,
			param.PHINSTPointerType = "Form",
			param.PHINSTActiveFlag = "Y",
			param.PHINSTSysFlag = "Y",
			param.PHDDDiseaDr = DiaIds,
			param.SpecialPopu=PopuIds
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
	});
	

}

///显示表单数据
function ClickMyGrid(rowIndex, rowData)
{
	//ClearFunLib();
	//var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCLABDiseaseC&pClassMethod=OpenConData";
	var record = $("#mygrid").datagrid("getSelected"); 
	if (record){
		var InstId = record.PHINSTRowId;
		
		//var check ="F"
		$.cm({
			ClassName:"web.DHCBL.KB.DHCBusMainNew",
			MethodName:"OpenDHCLABDiseaseConData",
			id:InstId
		},function(jsonData){
			//console.log(jsonData.list)
			var check = jsonData.PHINSTSex; 
			$HUI.radio("#sex"+check).setValue(true);
			var type = jsonData.PHDDType; 
			$HUI.radio("#type"+type).setValue(true)	
			$('#form-save').form("load",jsonData);			
				
		});	
		
		
		//刷新已选病症列表
		$('#diaGrid').datagrid('load',  {
			ClassName:"web.DHCBL.KB.DHCLABDiseaseI",
			QueryName:"GetDiseaList",			
			InstId:InstId,
			rows:1000
		});
		
		//刷新已选特殊人群列表
		$('#PopuGrid').datagrid('load',  {
			ClassName:"web.DHCBL.KB.DHCLibSpecPopuItm",
			QueryName:"GetPopuList",		
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
	//性别赋值
	$HUI.radio("#sexA").setValue(true);
	//类型赋值
	$HUI.radio("#typeF").setValue(true);
	//级别赋值
	$('#PHINSTModeF').combobox('setValue', mode);
	//清空病症数据
	$('#diaGrid').datagrid('loadData', { total: 0, rows: [] });
	//清空特殊人群数据
	$('#PopuGrid').datagrid('loadData', { total: 0, rows: [] });
	
	
}

////**************************************************************病症多选部分开始*****************************************************************/
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
		ClassName:"web.DHCBL.KB.DHCLABDiseaseI",
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
		ClassName:"web.DHCBL.KB.DHCLABDiseaseI",
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
		//datatgrid删除行deleteRow的方法中，会去调opts.view.deleteRow.call(opts.view,_4d2,_4d3);刷新页面上的行的index，index会发生改变，原来rows的数据也会发生改变，所以下列方法只能删除一行。
	    //var index = $('#unDiaGrid').datagrid('getRowIndex',rows[i]);  
		//$("#unDiaGrid").datagrid("deleteRow", index);
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
		var str=datas[i].PHDDDiseaDr
		ids.push(str);
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
						$('#diaGrid').datagrid("loadData", rows);// 重新载入当前页面数据  
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


////**************************************************************特殊人群多选方法****************************************************************/
//点击新增特殊人群按钮
$('#btnAddPopu').popover({
		title:"特殊人群",
		width:330,
		height:240,
		content:'<table id="unPopuGrid" ></table>',
		placement:'auto-right',
		closeable:true,
		trigger:'click',
		onShow:function(){
			InitUnPopuList()
			$('#btnPopuSearch').searchbox('setValue', '');
			
			}
	});

//特殊人群检索方法
function PopuSearch(desc)
{
	var PopuStr=getChosePopu();
	$('#unPopuGrid').datagrid('load',  { 
		ClassName:"web.DHCBL.KB.DHCSpecialPopu",
		QueryName:"GetUnSelPopuList",
		desc: desc,
		PopuStr:PopuStr
	});
	$('#unPopuGrid').datagrid('unselectAll');
}

//特殊人群重置方法
function PopuReset()
{
	var PopuStr=getChosePopu();	
	$('#btnPopuSearch').searchbox('setValue', '');
	$('#unPopuGrid').datagrid('load',  { 
		ClassName:"web.DHCBL.KB.DHCSpecialPopu",
		QueryName:"GetUnSelPopuList",
		desc: "",
		PopuStr:PopuStr
	});
	$('#unPopuGrid').datagrid('unselectAll');
}

//特殊人群保存方法
function PopuSave()
{
	var deleteRows = []; 
	var rows = $('#unPopuGrid').datagrid('getSelections');
	
	//已选列表插入选中数据
	for(var i=0; i<rows.length; i++){
		deleteRows.push(rows[i]);
		$("#PopuGrid").datagrid("appendRow", {
			    opt:'',
				SPEPIRowId:'',
				SPEPISpecDr:rows[i].SPERowId,
				SPECode:rows[i].SPECode,
				SPEDesc:rows[i].SPEDesc
			});
		$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  //操作列显示删除按钮
		//datatgrid删除行deleteRow的方法中，会去调opts.view.deleteRow.call(opts.view,_4d2,_4d3);刷新页面上的行的index，index会发生改变，原来rows的数据也会发生改变，所以下列方法只能删除一行。
	    //var index = $('#unPopuGrid').datagrid('getRowIndex',rows[i]);  
		//$("#unPopuGrid").datagrid("deleteRow", index);
	}
	
	//未选列表移除选中数据
	for(var i =0;i<deleteRows.length;i++){    
		var index = $('#unPopuGrid').datagrid('getRowIndex',deleteRows[i]);
		$('#unPopuGrid').datagrid('deleteRow',index); 
	}
}

//获取所有已选特殊人群
function getChosePopu()
{
	var ids = [];
	var datas=$('#PopuGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		var str="<"+datas[i].SPECode+">"
		ids.push(str);
	}
	var PopuStr=ids.join('^')
	return PopuStr
}

//获取所有已选特殊人群的ID
function getChosePopuIds()
{
	var ids = [];
	var datas=$('#PopuGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		var str=datas[i].SPEPISpecDr
		ids.push(str);
	}
	var PopuStrIds=ids.join(',')
	return PopuStrIds
}

//移除已选特殊人群
function RemovePopu(index)
{
	$('#PopuGrid').datagrid('selectRow',index);// 关键在这里 
	var record = $("#PopuGrid").datagrid("getSelected"); 
	if (record){
		var SPEPIRowId = record.SPEPIRowId;
		if(SPEPIRowId==""){  //如果是新加的数据，还没保存，则只是移除
			$('#PopuGrid').datagrid('deleteRow',index); 
			var rows = $('#PopuGrid').datagrid("getRows");
			$('#PopuGrid').datagrid("loadData", rows);				
			if($('#unPopuWindow').is(":visible"))  //如果新增特殊人群窗口打开了，则点删除后刷新未选特殊人群列表
			{
				PopuReset();
			}			
		}else{   //如果是已保存的数据直接执行删除操作
			$.ajax({
			url:DELETE_Popu_URL,  
			data:{
				"id":SPEPIRowId
			},  
			type:"POST",   
			//dataType:"TEXT",  
			success: function(data){
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
						$('#PopuGrid').datagrid('deleteRow',index); 
						var rows = $('#PopuGrid').datagrid("getRows");
						$('#PopuGrid').datagrid("loadData", rows);	 // 重新载入当前页面数据  
						if($('#unPopuWindow').is(":visible"))  //如果新增特殊人群窗口打开了，则点删除后刷新未选特殊人群列表
						{
							PopuReset();
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

////*************************************************************特殊人群多选方法结束****************************************************************/
	
	