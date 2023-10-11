/*
Creator:GuXueping
CreatDate:2017-12-27
Description:知识库编辑器-配伍禁忌
*/


//alert(GlPGenDr+","+GlPPointer+","+GlPPointerType)
var GenDr=GlPGenDr
var PointerType=GlPPointerType
var PointerDr=GlPPointer

var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseInteract&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDiseaseInteract";
var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseInteract&pClassMethod=UpdateData&pEntityName=web.Entity.KB.DHCPHDiseaseInteract";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseInteract&pClassMethod=DeleteData";
var CAT_TREE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetTreeProComboJson&lib=DRUG";
var init = function(){
	var mode=""
	
	var myColumns =[[  
				  {field:'PHINSTText',title:'描述',width:600},
				  {field:'PDINTGenDr',title:'药品dr',width:80,sortable:true,hidden:true},
				  {field:'PDINTCatDr',title:'分类dr',width:30,hidden:true},
				  {field:'PDINTRowId',title:'PDINTRowId',width:30,hidden:true}
				  ]];
				  
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.KB.DHCPHDiseaseInteract",
			QueryName:"GetList",
			TypeDr : "",
			GenDr: GenDr,
			PointerType:PointerType,
			PointerDr:PointerDr
		},
		showHeader:false,
		scrollbarSize :0,
		fitColumns: true,  //fitColumns	boolean	设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		singleSelect:true,
		idField:'PDINTRowId', 
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
					code:"InterEach"
				},function(txtData){
					mode=txtData
					$('#PHINSTModeF').combobox('setValue', mode);	
				});
		}

	});
	

	///分类TREE_URL
	var catTree = $HUI.combotree('#PDINTCatDrF',{
		url:CAT_TREE_URL,
		panelWidth:255,
		panelHeight:200,
		onSelect:function(record){
				if (PointerType=="ProName"){
					$("#PDINTDrugDrF").combobox('setValue',"");
					$("#PDINTGenDrF").val("");
				}
				else
				{
					$("#PDINTDrugDrF").val("");
					$("#PDINTGenDrF").combobox('setValue',"");
				}
			}
	});
	
	///药品
	if (PointerType=="ProName"){
		document.getElementById("PDINTGenDrF").style.display = "none"; //隐藏继续新增按钮
		document.getElementById("PDINTDrugDrF").style.display = "";
		var drugObj = $HUI.combobox("#PDINTDrugDrF",{ 
			url:$URL+"?ClassName=web.DHCBL.KB.DHCPHProName&QueryName=GetDataForCmb1&ResultSetType=array",
			valueField:'PHNRowId',
			textField:'PHNDesc',
			onSelect:function(record){
					$("#PDINTGenDrF").val("");
					$("#PDINTCatDrF").combotree('setValue',"");
				}
		});	
	}
	else{
		var drugObj = $HUI.combobox("#PDINTGenDrF",{ 
			url:$URL+"?ClassName=web.DHCBL.KB.DHCBusMainNew&QueryName=GetGenForCmb1&ResultSetType=array&code=DRUG",
			valueField:'PHEGRowId',
			textField:'PHEGDesc',
			onSelect:function(record){
					$("#PDINTDrugDrF").val("");
					$("#PDINTCatDrF").combotree('setValue',"");
				}
		});	
	}
	
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
			var rowid=row.PDINTRowId;
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
				param.PDINTRowId = rowid,
				param.PHINSTOrderNum = "1",
				param.PHINSTGenDr = GenDr,
				param.PHINSTPointerDr = PointerDr,
				param.PHINSTPointerType = PointerType,
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
		var rowid=row.PDINTRowId;
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
			var InstId = record.PDINTRowId;
			$.cm({
				ClassName:"web.DHCBL.KB.DHCBusMainNew",
				MethodName:"OpenInteractData",
				id:InstId
			},function(jsonData){
				//console.log(jsonData.list)
				var check = jsonData.PDINTFlag; 
				//console.log(check)
				$HUI.radio("#flag"+check).setValue(true)
				$('#form-save').form("load",jsonData);		
			});				
			
		}

	}

	///重置
	function ClearFunLib()
	{
		//清空表单
		$('#form-save').form('clear');
		//医嘱标识赋值
		$HUI.radio("#flag3").setValue(true);
	}

	

};
$(init);
