/*
Creator:ShiXiaowei
CreatDate:2018-01-10
Description:知识库编辑器-不良反应
*/

var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCECGAR&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCECGAR";
var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCECGAR&pClassMethod=UpdateData&pEntityName=web.Entity.KB.DHCECGAR";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCECGAR&pClassMethod=DeleteData";

var GenDr=GlPGenDr
var PointerType=GlPPointerType
var PointerDr=GlPPointer

///初始化主索引列表
function InitMyList()
{

	//var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCECGAR&pClassQuery=GetList";
	var gencolumns =[[  
				  {field:'PHINSTText',title:'描述',width:600,sortable:true},
				  {field:'PDAIOrdNum',title:'顺序',width:80,sortable:true,hidden:true},
				  {field:'PDAIRowId',title:'PDAIRowId',width:30,hidden:true},
				  {field:'PHINSTRowId',title:'PHINSTRowId',width:30,hidden:true},
				  {field:'opt',title:'上移/下移',width:80,align:'center',  
						formatter:function(value,row,index){  
							var upbtn='<a class="upcls" onclick="OrderFunLib(1,'+index+')" href="#"></a>'
							var downbtn='<a class="downcls" onclick="OrderFunLib(2,'+index+')" href="#"></a>'
							var btn = upbtn+'<span style="color:#666666;">/</span>'+downbtn;  
							var rows = $('#mygrid').datagrid('getRows');
							if(index==0){
	         					btn =downbtn;
	         				}
	         								
							if ((index+1)==rows.length){
								btn =upbtn;
							}
							return btn;  
						}  
					}
				  ]];

	$('#mygrid').datagrid({ 
		width:'100%',
		height:'100%', 
		//toolbar:'#mytbar',
		//pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:20,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		fitColumns: true,  //fitColumns	boolean	设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCECGAR",
			QueryName:"GetList",
			TypeDr : "",
			GenDr: GenDr,
			PointerType:PointerType,
			PointerDr:PointerDr
		},
		singleSelect:true,
		idField:'PHINSTRowId', 
		rownumbers:true,
		fixRowNumber:true,
		showHeader:false,
		scrollbarSize :0,
		fit:true,
		remoteSort:false,
		sortName : 'PDAIOrdNum',
		sortOrder : 'asc', 
		columns:gencolumns,
		onDblClickRow: function() {

		},
		onLoadSuccess:function(data){
			//隐藏行选择数，只按默认显示15个
			//$(".pagination-page-list").hide();
			$('.upcls').linkbutton({text:'',plain:true,iconCls:'icon-shiftup'}); 
			$('.downcls').linkbutton({text:'',plain:true,iconCls:'icon-shiftdown'}); 
		},
		onLoadError:function(){
		}
	});
}

///界面加载代码
function BodyLoadHandler()
{

	//主索引列表
    InitMyList();
	
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
	 
	 /*//上移
	$("#btnUp").click(function (e) { 

			OrderFunLib("up");

	 })  
	//下移
	$("#btnDown").click(function (e) { 

			OrderFunLib("down");

	 }) */
	 
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
	

	var centerrows = $('#mygrid').datagrid('getRows');
	var ordNum=centerrows.length+1
	$('#form-save').form('submit', { 
		url: saveURL, 
		onSubmit: function(param){
			param.PDAIInstDr = rowid,
			param.PHINSTOrderNum = "1",
			param.PHINSTGenDr = GenDr,
			param.PHINSTPointerDr = PointerDr,
			param.PHINSTPointerType = PointerType,
			param.PHINSTActiveFlag = "Y",
			param.PHINSTSysFlag = "Y",
			param.PDAIOrdNum = ordNum
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
	var record = $("#mygrid").datagrid("getSelected"); 
	if (record){
		var InstId = record.PHINSTRowId;	
		$("#PHINSTTextF").val(rowData.PHINSTText);
		
	}

}

///重置
function ClearFunLib()
{
	//清空表单
	$('#form-save').form('clear');
}

///上移下移
function OrderFunLib(type,index)
{            
	/*//更新
	var row = $("#mygrid").datagrid("getSelected"); 
	if (!(row))
	{
		$.messager.alert('错误提示','请先选择一条记录!',"error");
		return;
	}	   
	var index = $("#mygrid").datagrid('getRowIndex', row);	*/
	
	mysort(index, type, "mygrid")
	
	//遍历列表
	var order=""
	var rows = $('#mygrid').datagrid('getRows');	
	for(var i=0; i<rows.length; i++){	
		var id =rows[i].PDAIRowId; //频率id
		if (order!=""){
			order = order+"^"+id
		}else{
			order = id
		}
		
	}
	
	//获取级别默认值
	$.m({
		ClassName:"web.DHCBL.KB.DHCECGAR",
		MethodName:"SaveDragOrder",
		order:order
	},function(txtData){
		//alert(order+txtData)
	});

}

function mysort(index, type, gridname) {
    if (1 == type) {
        if (index != 0) {
            var toup = $('#' + gridname).datagrid('getData').rows[index];
            var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
            $('#' + gridname).datagrid('getData').rows[index] = todown;
            $('#' + gridname).datagrid('getData').rows[index - 1] = toup;
            $('#' + gridname).datagrid('refreshRow', index);
            $('#' + gridname).datagrid('refreshRow', index - 1);
            $('#' + gridname).datagrid('selectRow', index - 1);
        }
    } 
	else if (2 == type) {
        var rows = $('#' + gridname).datagrid('getRows').length;
        if (index != rows - 1) {
            var todown = $('#' + gridname).datagrid('getData').rows[index];
            var toup = $('#' + gridname).datagrid('getData').rows[index + 1];
            $('#' + gridname).datagrid('getData').rows[index + 1] = todown;
            $('#' + gridname).datagrid('getData').rows[index] = toup;
            $('#' + gridname).datagrid('refreshRow', index);
            $('#' + gridname).datagrid('refreshRow', index + 1);
            $('#' + gridname).datagrid('selectRow', index + 1);
        }
    }
    
	$('.upcls').linkbutton({text:'',plain:true,iconCls:'icon-shiftup'}); 
	$('.downcls').linkbutton({text:'',plain:true,iconCls:'icon-shiftdown'});
}﻿