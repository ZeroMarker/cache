/// 名称:检验项目 - 检验结果辅助诊断
/// 编写者:基础数据平台 - 丁亚男
/// 编写日期:2018-1-11

var GenDr=GlPGenDr
var PointerType=GlPPointerType
var PointerDr=GlPPointer

//var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibResultDiag&pClassQuery=GetList";
//var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibResultDiag&pClassMethod=OpenData";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibResultDiag&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHLibResultDiag";
var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibResultDiag&pClassMethod=UpdateData&pEntityName=web.Entity.KB.DHCPHLibResultDiag";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibResultDiag&pClassMethod=DeleteData";

///初始化主索引列表
var init = function(){

	//var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCLABDiseaseC&pClassQuery=GetListCon";
	var myColumns =[[  
				  {field:'PHINSTText',title:'描述',width:260},
				  {field:'PHINSTRowId',title:'PHINSTRowId',width:30,hidden:true},
				  {field:'PLRDRowId',title:'PLRDRowId',width:30,hidden:true}
				  ]];
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHLibResultDiag",
			QueryName:"GetList",
			TypeDr : "",
			GenDr: GenDr,
			PointerType:"Form",
			PointerDr:PointerDr
		},
		fitColumns: true,  //fitColumns	boolean	设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		rownumbers:true,
		fixRowNumber:true,
		showHeader:false,
		scrollbarSize :0,
		idField:'PHINSTRowId', 
		rownumbers:true,
		fit:true,
		remoteSort:false,
		sortOrder : 'asc', 
		columns:myColumns,
		onClickRow:ClickMyGrid
	});


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
		
		$('#form-save').form('submit', { 
			url: saveURL, 
			onSubmit: function(param){
				param.PLRDInstDr = rowid,
				param.PHINSTOrderNum = "1",
				param.PHINSTGenDr = GenDr,
				param.PHINSTPointerDr = PointerDr,
				param.PHINSTPointerType = "Form",
				param.PHINSTActiveFlag = "Y",
				param.PHINSTSysFlag = "Y"
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
				MethodName:"OpenDHCPHLibResultDiagData",
				id:InstId
			},function(jsonData){

				$('#form-save').form("load",jsonData);		
			});				
			
		}

	}

	///重置
	function ClearFunLib()
	{
		//清空表单
		$('#form-save').form('clear');
	}

	

};
$(init);