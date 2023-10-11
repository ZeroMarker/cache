﻿/*
Creator:Dingyanan
CreatDate:2019-11-21
Description:手术知识库编辑器-术前检验
*/


//alert(GlPGenDr+","+GlPPointer+","+GlPPointerType)
var GenDr=GlPGenDr
var PointerType=GlPPointerType
var PointerDr=GlPPointer

var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPreoperLab&pClassMethod=SavePreoperLabData&pEntityName=web.Entity.KB.DHCPreoperLab";
var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPreoperLab&pClassMethod=UpdatePreoperLabData&pEntityName=web.Entity.KB.DHCPreoperLab";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPreoperLab&pClassMethod=DeleteData";
var AGE_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassMethod=getMaxMin";

var mode=""
///初始化主索引列表
function InitMyList()
{

	//var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPreoperLab&pClassQuery=GetList";
	var gencolumns =[[  
				  {field:'PHINSTText',title:'描述',width:260,sortable:true},
				  {field:'PHINSTRowId',title:'PHINSTRowId',width:30,hidden:true}
				  ]];

	$('#mygrid').datagrid({ 
		width:'100%',
		height:'100%',
		scrollbarSize :0,
		showHeader:false, 
		//toolbar:'#mytbar',
		//pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:20,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		fitColumns: true,  //fitColumns	boolean	设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		/*url:QUERY_ACTION_URL,
		queryParams:{
			TypeDr : "",
			GenDr: GenDr,
			PointerType:PointerType,
			PointerDr:PointerDr
		},*/
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPreoperLab",
			QueryName:"GetList",
			TypeDr : "",
			GenDr: GenDr,
			PointerType:PointerType,
			PointerDr:PointerDr,
			OPERInstLabelCode:"PreoperLab"
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


///年龄
function InitAgeCmb()
{
	$('#PDAAgeDrF').combobox({ 
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
		]

	});
}	

///检验项目
function InitLabDrCmb()
{
	$('#LABILabDrF').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtGeneric&QueryName=GetDataForCmb1&ResultSetType=array&code=LAB",
		valueField:'PHEGRowId',
		textField:'PHEGDesc'
	});
}

///界面加载代码
function BodyLoadHandler()
{

	//主索引列表
    InitMyList();
    //级别下拉框
	InitModeCmb();
	//检验项目下拉框
	InitLabDrCmb();
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
			param.OPERInstLabelCode = "PreoperLab"
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
	var record = $("#mygrid").datagrid("getSelected"); 
	if (record){
		var InstId = record.PHINSTRowId;
		
		//var check ="F"
		$.cm({
			ClassName:"web.DHCBL.KB.DHCPreoperLab",
			MethodName:"OpenPreoperLabData",
			id:InstId
		},function(jsonData){
			if (jsonData.LABIRepActiveFlag=="Y"){
				$HUI.checkbox("#LABIRepActiveFlagF").setValue(true);		
			}else{
				$HUI.checkbox("#LABIRepActiveFlagF").setValue(false);
			}
			$('#form-save').form("load",jsonData);	
			
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
	//是否为报告状态赋初值
	$HUI.checkbox("#LABIRepActiveFlagF").setValue(true);
}
