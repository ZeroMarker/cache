/*
Creator:GuXueping
CreatDate:2017-12-10
Description:知识库编辑器-用法用量
*/


//alert(GlPGenDr+","+GlPPointer+","+GlPPointerType)
var GenDr=GlPGenDr
var PointerType=GlPPointerType
var PointerDr=GlPPointer

var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHUsageDosage&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHUsageDosage";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHUsageDosage&pClassMethod=DeleteData";

var AGE_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassMethod=getMaxMin";

var DELETE_Disea_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDisease&pClassMethod=DeleteDiseaData";
var DELETE_Popu_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCLibSpecPopuItm&pClassMethod=DeletePopuData";

var mode=""
///初始化主索引列表
function InitMyList()
{

	var gencolumns =[[  
				  {field:'PHINSTText',title:'描述',width:260},
				  {field:'PHUSDOInstDr',title:'PHUSDOInstDr',width:30,hidden:true},
				  {field:'PHUSDORowId',title:'PHUSDORowId',width:30,hidden:true}
				  ]];

	$('#mygrid').datagrid({ 
		width:'100%',
		height:'100%', 
		//toolbar:'#mytbar',
		//pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		scrollbarSize :0,
		showHeader:false, 
		pageSize:20,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		fitColumns: true,  //fitColumns	boolean	设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHUsageDosage",
			QueryName:"GetList",
			TypeDr : "",
			GenDr: GenDr,
			PointerType:PointerType,
			PointerDr:PointerDr
		},
		singleSelect:true,
		idField:'PHUSDORowId', 
		rownumbers:true,
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
					code:"Usage"
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
	$('#PDAAgeF').combobox({ 
		//url:Age_Dr_QUERY_ACTION_URL,
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHPatAgeList&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PDARowID',
		textField:'PDAAgeDesc',
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

///用法
function InitInstrucCmb()
{
	$('#PHEINInstrucF').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtInstruc&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEINRowId',
		textField:'PHEINDesc'
	});
}

///单次用药量单位
function InitOnceQtyCmb()
{
	$('#PHUSDOOnceQtyUomDrF').combobox({ 
		//url:UOM_DR_QUERY_ACTION_URL,
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtUom&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEURowId',
		textField:'PHEUDesc'
	});
}

///每日用药总量单位
function InitDayQtyCmb()
{
	$('#PHUSDOOneDayQtyUomDrF').combobox({ 
		//url:UOM_DR_QUERY_ACTION_URL,
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtUom&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEURowId',
		textField:'PHEUDesc'
	});
}

///首次用药量单位
function InitFristTimeCmb()
{
	$('#PHUSDOFristTimeQtyUomDrF').combobox({ 
		//url:UOM_DR_QUERY_ACTION_URL,
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtUom&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEURowId',
		textField:'PHEUDesc'
	});
}

///连用量单位
function InitDurationQtyCmb()
{
	$('#PHUSDODurationQtyUomDrF').combobox({ 
		//url:UOM_DR_QUERY_ACTION_URL,
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtUom&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEURowId',
		textField:'PHEUDesc'
	});
}

///用药间隔单位
function InitSpaceQtyCmb()
{
	$('#PHUSDOSpaceQtyUomDrF').combobox({ 
		//url:UOM_DR_QUERY_ACTION_URL,
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtUom&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEURowId',
		textField:'PHEUDesc'
	});
}

///每次最大量单位单位
function InitOnceMaxCmb()
{
	$('#PHUSDOOnceMaxQtyUomDrF').combobox({ 
		//url:UOM_DR_QUERY_ACTION_URL,
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtUom&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEURowId',
		textField:'PHEUDesc'
	});
}

///每日最大量单位
function InitOneDayMaxCmb()
{
	$('#PHUSDOOneDayMaxQtyUomDrF').combobox({ 
		//url:UOM_DR_QUERY_ACTION_URL,
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtUom&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEURowId',
		textField:'PHEUDesc'
	});
}

///年龄单位
function InitAgeUomCmb()
{
	$('#PDAUomDrF').combobox({ 
		//url:UOM_DR_QUERY_ACTION_URL,
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHPatAgeList&QueryName=GetDataForCmbYMD&ResultSetType=array",
		valueField:'PHEURowId',
		textField:'PHEUDesc'
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
				$("#LABIRelationF").combobox('enable'); 
				$("#LABIMinValF").attr("disabled",false); 
				$("#LABIMaxValF").attr("disabled",false); 
				$("#LABIUomDrF").combobox('enable'); 
						
			}else{
				 $("#LABIRelationF").combobox('disable'); 
				 $("#LABIMinValF").attr("disabled",true); 
				 $("#LABIMaxValF").attr("disabled",true); 
				 $("#LABIUomDrF").combobox('disable'); 

			}	
		}
	});
}
///逻辑
function InitRelationCmb()
{
	var relationCmb = $HUI.combobox("#LABIRelationF",{
		valueField:'id',
		textField:'text',
		data:[
			{id:'>',text:'大于'},
			{id:'<',text:'小于'},
			{id:'=',text:'等于'},
			{id:'!>',text:'不大于'},
			{id:'!<',text:'不小于'},
			{id:'<>',text:'不等于'}			
		]
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
	var diacolumns=[[
					{field:'opt',title:'操作',width:50,align:'center',  
						formatter:function(value,row,index){  
							var btn = '<a class="editcls" onclick="RemoveDia('+index+')" href="#">删除</a>';  
							return btn;  
						}  
					} ,  
				  {field:'PHDISLDiseaDesc',title:'描述',width:200}, 
				  {field:'PHDISLDiseaCode',title:'代码',width:115}, 
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
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHDrugDisease",
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
function InitUnDiaList()
{
	var diseaStr=getChoseDia();

	var unDiaColumns=[[ 
				  { field: 'ck', checkbox: true, width: '30' },  //复选框  	
				  {field:'PHDISLDiseaDesc',title:'病症描述',width:270}, 
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


////**************************************************************特殊人群列表多选初始化*****************************************************************/
///已选特殊人群列表
function InitPopuList()
{
	var Popucolumns=[[
					{field:'opt',title:'操作',width:50,align:'center',  
						formatter:function(value,row,index){  
							var btn = '<a class="editcls" onclick="RemovePopu('+index+')" href="#">删除</a>';  
							return btn;  
						}  
					} ,  
				  {field:'SPEDesc',title:'描述',width:220}, 
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
function InitUnPopuList()
{
	var PopuStr=getChosePopu();
	//alert(PopuStr)
	//特殊人群
	var unPopuColumns=[[ 
				  { field: 'ck', checkbox: true, width: '30' },  //复选框  	
				  {field:'SPEDesc',title:'描述',width:250}, 
				  {field:'SPECode',title:'代码',width:200,hidden:true}, 
				  {field:'SPERowId',title:'SPERowId',hidden:true}
				  ]];


	$('#unPopuGrid').datagrid({ 
		headerCls:'panel-header-gray',
		width:320,
		height:235, 
		pagination: true, 
	    pageSize:PageSizePop,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		displayMsg:"",
		bodyCls:'panel-header-gray',
		toolbar:'#myunPoputbar',
		fitColumns: true,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCSpecialPopu",
			QueryName:"GetUnSelPopuList",
			PopuStr : PopuStr
		},
		singleSelect:false,
		idField:'SPERowId', 
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
	//检验项目下拉框
	InitLabDrCmb();
	//检验项目指标值范围下拉框
	InitLabDrUomCmb();
	//逻辑下拉框
	InitRelationCmb();	
	
	///用法
	InitInstrucCmb();
	///单次用药量单位
	InitOnceQtyCmb();
	///每日用药总量单位
	InitDayQtyCmb();
	///首次用药量单位
	InitFristTimeCmb();
	///连用量单位
	InitDurationQtyCmb();
	///用药间隔单位
	InitSpaceQtyCmb();
	///每次最大量单位单位
	InitOnceMaxCmb();
	///每日最大量单位
	InitOneDayMaxCmb();
	
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
   ////*****************************特殊人群初始化结束*****************************************************************/
   
}
///新增、更新
function AddFunLib(opflag)
{            
	        		
	var code=$.trim($("#PHINSTTextF").val());


	/*var checkedRadioJObj = $("input[name='PHINSTSex']:checked");
	var sex=checkedRadioJObj.val()*/
	if (opflag==2)
	{
		//更新
		var row = $("#mygrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.PHUSDORowId;
		var instDr=row.PHUSDOInstDr;
	}
	
	if (code=="")
	{
		$.messager.alert('错误提示','描述不能为空!',"error");
		return;
	}

	if (opflag==1)
	{
		//增加
		var rowid="";
		var instDr="";

	}
	
	//获取已选病症
	var DiaIds=getChoseDiaIds(opflag);
	
	//获取已选特殊人群
	var PopuIds=getChosePopuIds(opflag);
	//alert(DiaIds+"&&"+PopuIds)
	
	$('#form-save').form('submit', { 
		url: SAVE_ACTION_URL, 
		onSubmit: function(param){
			param.PHUSDORowId = rowid,
			param.PHUSDOInstDr = instDr,
			param.PHINSTOrderNum = "0",
			param.PHINSTTypeDr = "USAGE",
			param.PHINSTLibDr = "DRUG",
			param.PHINSTGenDr = GenDr,
			param.PHINSTPointerDr = PointerDr,
			param.PHINSTPointerType = PointerType,
			param.PHINSTActiveFlag = "Y",
			param.PHINSTSysFlag = "Y",
			param.PHDISLDisea = DiaIds,
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
	var rowid=row.PHUSDORowId;
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
	var record = $("#mygrid").datagrid("getSelected"); 
	if (record){
		var InstId = record.PHUSDOInstDr;
		var rowid = record.PHUSDORowId;
		//var check ="F"
		$.cm({
			ClassName:"web.DHCBL.KB.DHCBusMainNew",
			MethodName:"OpenUsageDosageData",
			id:rowid
		},function(jsonData){
			var check = jsonData.PHINSTSex; 
			$HUI.radio("#sex"+check).setValue(true);	
			$('#form-save').form("load",jsonData);
			var selVal=jsonData.LABILabDr
			if(selVal!=""){
				$("#LABIRelationF").combobox('enable'); 
				$("#LABIMinValF").attr("disabled",false); 
				$("#LABIMaxValF").attr("disabled",false); 
				$("#LABIUomDrF").combobox('enable'); 
						
			}else{
				 $("#LABIRelationF").combobox('disable'); 
				 $("#LABIMinValF").attr("disabled",true); 
				 $("#LABIMaxValF").attr("disabled",true); 
				 $("#LABIUomDrF").combobox('disable'); 

			}	
				
		});	
		
		
		//刷新已选病症列表
		$('#diaGrid').datagrid('load',  {
			ClassName:"web.DHCBL.KB.DHCPHDrugDisease",
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

	//级别赋值
	$('#PHINSTModeF').combobox('setValue', mode);
	//清空病症数据
	$('#diaGrid').datagrid('loadData', { total: 0, rows: [] });
		
	//清空特殊人群数据
	$('#PopuGrid').datagrid('loadData', { total: 0, rows: [] });
	
	//逻辑、指标值范围不可用
	 $("#LABIRelationF").combobox('disable'); 
	 $("#LABIMinValF").attr("disabled",true); 
	 $("#LABIMaxValF").attr("disabled",true); 
	 $("#LABIUomDrF").combobox('disable');

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
function getChoseDiaIds(opflag)
{
	var ids = [];
	var datas=$('#diaGrid').datagrid('getRows');
	
	for(var i=0; i<datas.length; i++){
		if ((datas[i].PHDDRowId=="")||(opflag==1)){  //新增时获取全部，修改时只获取后加的数据
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


////**************************************************************特殊人群多选方法****************************************************************/
/*//点击添加特殊人群按钮
function UnPopuWindow()
{	
	$("#textPopu").val("");
	$('#unPopuWindow').window({ 
		 title:"特殊人群",
		 minimizable:false,
		 maximizable:false,
		 collapsible:false,
		 width:300,   
		 height:500,   
		 modal:false //modal-boolean定义窗口是不是模态（modal）窗口-true
	});
	InitUnPopuList();

}*/
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
function getChosePopuIds(opflag)
{
	var ids = [];
	var datas=$('#PopuGrid').datagrid('getRows');

	for(var i=0; i<datas.length; i++){
		if ((datas[i].SPEPIRowId=="")||(opflag==1)){
			var str=datas[i].SPEPISpecDr
			ids.push(str);
		}
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
						$('#PopuGrid').datagrid("loadData", rows);  // 重新载入当前页面数据  
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


