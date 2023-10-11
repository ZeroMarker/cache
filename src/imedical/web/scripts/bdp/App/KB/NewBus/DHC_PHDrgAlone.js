/*
Creator:GuXueping
CreatDate:2017-12-26
Description:知识库编辑器-可配伍药品
*/


//alert(GlPGenDr+","+GlPPointer+","+GlPPointerType)
var GenDr=GlPGenDr
var PointerType=GlPPointerType
var PointerDr=GlPPointer

var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgAlone&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDrgAlone";
var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgAlone&pClassMethod=UpdateData&pEntityName=web.Entity.KB.DHCPHDrgAlone";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgAlone&pClassMethod=DeleteData";
var INGR_TREE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetIngrComboJson";
var DELETE_Disea_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgAlone&pClassMethod=DeleteDiseaData";

///界面加载代码
function BodyLoadHandler()
{
	var mode=""
	var myColumns =[[  
				  {field:'PHINSTText',title:'描述',width:600},
				  {field:'PHINSTRowId',title:'PHINSTRowId',width:30,hidden:true}
				  ]];
				  
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHDrgAlone",
			QueryName:"GetList",
			TypeDr : "",
			GenDr: GenDr,
			PointerType:PointerType,
			PointerDr:PointerDr
		},
		scrollbarSize :0,
		showHeader:false, 
		fitColumns: true,  //fitColumns	boolean	设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		singleSelect:true,
		idField:'PHINSTRowId', 
		rownumbers:true,
		fit:true,
		remoteSort:false,
		sortOrder : 'asc', 
		columns:myColumns,
		onClickRow:ClickMyGrid
	});
	
	///级别
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
					code:"DrgAlone"
				},function(txtData){
					mode=txtData
					$('#PHINSTModeF').combobox('setValue', mode);	
				});
		}

	});
	
	///溶媒分类
	var uomObj = $HUI.combobox("#PHDALCatDrF",{ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHMenstruumCat&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHMCRowId',
		textField:'PHMCDesc'
	});
	
	
	///规则
	var uomObj = $HUI.combobox("#PHRIRuleDrF",{ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHRepeatFeild&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHRFRowId',
		textField:'PHRFDesc'
	});
	
	

	////*****************************病症多选初始化*****************************************************************/
	InitDiaList();
	/*//添加病症按钮
	$("#btnAddDia").click(function (e) { 
		UnDiaWindow();
	}) */	
	///未选商品名弹窗
	$('#btnAddDia').popover({
			title:"商品名",
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
	 
	///新增、更新
	function AddFunLib(opflag)
	{            
		if (opflag==2)
		{
			//更新
			var row = mygrid.getSelected(); 
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

		$('#form-save').form('submit', { 
			url: saveURL, 
			onSubmit: function(param){
				param.PHDALInstDr = rowid,
				param.PHINSTOrderNum = "1",
				param.PHINSTGenDr = GenDr,
				param.PHINSTPointerDr = PointerDr,
				param.PHINSTPointerType = PointerType,
				param.PHINSTActiveFlag = "Y",
				param.PHINSTSysFlag = "Y",
				param.PHDALDrgDr = DiaIds
			},
			success: function (data) { 
			  var data=eval('('+data+')'); 
			  if (data.success == 'true') {
				$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
				 mygrid.reload();  // 重新载入当前页面数据  
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
		var row = mygrid.getSelected(); 
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
								 mygrid.reload();  // 重新载入当前页面数据  
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
		var record = mygrid.getSelected(); 
		if (record){
			var InstId = record.PHINSTRowId;
			$.cm({
				ClassName:"web.DHCBL.KB.DHCBusMainNew",
				MethodName:"OpenDrgAloneData",
				id:InstId
			},function(jsonData){

				$('#form-save').form("load",jsonData);		
			});
			
			//刷新已选病症列表
			$('#diaGrid').datagrid('load',  {
				ClassName:"web.DHCBL.KB.DHCPHDrgAlone",
				QueryName:"GetDiseaList",			
				InstId:InstId,
				rows:1000
			});
			
		}

	}

	///重置
	function ClearFunLib()
	{
		//清空表单
		$('#form-save').form('clear');
		//级别赋值
		$('#PHINSTModeF').combobox('setValue', mode);
		
		//清空病症数据
		$('#diaGrid').datagrid('loadData', { total: 0, rows: [] });
	}
	 	
}



////**************************************************************病症多选部分开始*****************************************************************/

///已选病症列表
function InitDiaList()
{
	///已选商品名列
	var diacolumns=[[
					{field:'opt',title:'操作',width:50,align:'center',  
						formatter:function(value,row,index){  
							var btn = '<a class="editcls" onclick="RemoveDia('+index+')" href="#">删除</a>';  
							return btn;  
						}  
					} ,  
				  {field:'PHNDesc',title:'描述',width:220}, 
				  {field:'PHNCode',title:'代码',width:200}, 
				  {field:'PHDALRowId',title:'PHDALRowId',hidden:true},
				  {field:'PHDALDrgDr',title:'PHDALDrgDr',hidden:true}
				  ]];

	var mulgrid = $HUI.datagrid("#diaGrid",{
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
			ClassName:"web.DHCBL.KB.DHCPHDrgAlone",
			QueryName:"GetDiseaList",
			rows:1000
		},
		singleSelect:true,
		idField:'PHDALRowId', 
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
function InitUnDiaList()
{
	var diseaStr=getChoseDia();

	var unDiaColumns=[[ 
				  { field: 'ck', checkbox: true, width: '30' },  //复选框  	
				  {field:'PHNDesc',title:'商品名',width:250}, 
				  {field:'PHNCode',title:'商品名代码',width:200,hidden:true}, 
				  {field:'PHNRowId',title:'PHNRowId',hidden:true}
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
			ClassName:"web.DHCBL.KB.DHCPHDrgAlone",
			QueryName:"GetUnSelDiseaList",
			diseaStr : diseaStr
		},
		singleSelect:false,
		idField:'PHNRowId',
		columns:unDiaColumns
	});
}


/*//点击添加商品名按钮
function UnDiaWindow()
{	
	$("#textDia").val("");
	$('#unDiaWindow').window({ 
		 title:"商品名",
		 minimizable:false,
		 maximizable:false,
		 collapsible:false,
		 width:300,   
		 height:500,   
		 modal:false //modal-boolean定义窗口是不是模态（modal）窗口-true
	});
	InitUnDiaList();

}*/

//商品名检索方法
function DiaSearch(desc)
{
	var diseaStr=getChoseDia();
	$('#unDiaGrid').datagrid('load',  { 	
		ClassName:"web.DHCBL.KB.DHCPHDrgAlone",
		QueryName:"GetUnSelDiseaList",
		diseaStr : diseaStr,
		desc: desc
	});

}

//商品名重置方法
function DiaReset()
{
	var diseaStr=getChoseDia();	
	$('#btnDiaSearch').searchbox('setValue', '');
	$('#unDiaGrid').datagrid('load',  { 	
		ClassName:"web.DHCBL.KB.DHCPHDrgAlone",
		QueryName:"GetUnSelDiseaList",
		diseaStr : diseaStr,
		desc: ""
	});
	$('#unDiaGrid').datagrid('unselectAll');
}

//商品名保存方法
function DiaSave()
{
	var deleteRows = []; 
	var rows = $('#unDiaGrid').datagrid('getSelections');
	
	//已选列表插入选中数据
	for(var i=0; i<rows.length; i++){
		deleteRows.push(rows[i]);
		$("#diaGrid").datagrid("appendRow", {
				opt:'',
				PHDALRowId:'',
				PHDALDrgDr:rows[i].PHNRowId,
				PHNCode:rows[i].PHNCode,
				PHNDesc:rows[i].PHNDesc
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

//获取所有已选商品名
function getChoseDia()
{
	var ids = [];
	var datas=$('#diaGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		var str="<"+datas[i].PHNCode+">"
		ids.push(str);
	}
	var diseaStr=ids.join('^')
	return diseaStr
}

//获取所有已选商品名的ID
function getChoseDiaIds()
{
	var ids = [];
	var datas=$('#diaGrid').datagrid('getRows');
	for(var i=0; i<datas.length; i++){
		//if (datas[i].PHDALRowId==""){	
			var str=datas[i].PHDALDrgDr
			ids.push(str);
		//}
	}
	var diseaStrIds=ids.join(',')
	return diseaStrIds
}

//移除已选商品名
function RemoveDia(index)
{
	$('#diaGrid').datagrid('selectRow',index);// 关键在这里 
	var record = $("#diaGrid").datagrid("getSelected"); 
	if (record){
		var PHDALRowId = record.PHDALRowId;
		if(PHDALRowId==""){  //如果是新加的数据，还没保存，则只是移除
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
			data:{"id":PHDALRowId},  
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

////**************************************************************商品名多选部分结束*****************************************************************/