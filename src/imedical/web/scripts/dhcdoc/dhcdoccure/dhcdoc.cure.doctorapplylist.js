var cureApplyAppArriveDataGrid;
$(function(){
	//卡类型列表
    $('#cardType').combobox({      
    	valueField:'CardTypeId',   
    	textField:'CardTypeDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'web.DHCDocCureApp';
						param.QueryName = 'FindCardType'
						param.ArgCnt =0;
		}  
	});
	$('#btnFind').bind('click', function(){
		   loadCureApplyAppDataGrid();
    });
    $('#patNo').bind('keydown', function(event){
		   if(event.keyCode==13)
		   {
			  var patNo=$("#patNo").val();
			  if(patNo=="") return;
			  for (var i=(10-patNo.length-1); i>=0; i--) {
				patNo="0"+patNo;
			}
			$("#patNo").val(patNo);
		   }
    });
    $('#cardNo').bind('keydown', function(event){
		   if(event.keyCode==13)
		   {  
		      var cardType=$("#cardType").combobox('getValue');
		      if (cardType=="") return;
		      var cardTypeInfo=tkMakeServerCall("web.DHCDocCureApp","GetCardTypeInfo",cardType);
			  if (cardTypeInfo=="") return;
			  var cardNoLength=cardTypeInfo.split("^")[16];
			  //alert(cardNoLength);
			  var cardNo=$("#cardNo").val();
			  if(cardNo=="") return;
			  if((cardNo.length<cardNoLength)&&(cardNoLength!=0)) {
					for (var i=(cardNoLength-cardNo.length-1);i>=0; i--) {
						cardNo="0"+cardNo;
					}
				}
			$("#cardNo").val(cardNo);
		   }
    });   
	cureApplyItemDataGrid=$('#tabCureItemList').datagrid({  
		
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		rownumbers: true,
		fitColumns : true,
		striped: true,
		autoRowHeight : false,
		selectOnCheck: true,
		checkOnSelect:true,  
		url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"OEORIRowId",
		pageList : [10,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :[[ 
        			{field:'ARCIMDesc',title:'治疗项目',width:100}, 
        			{field:'DCALocDesc',title:'治疗科室',width:100}, 
        			{field:'RelocId',title:'RelocId',width:100,hidden:true}, 
        			{field:'OEORIRowId',title:'OEORIRowId',width:100,hidden:true}, 
        			{field:'DCARowId',title:'DCARowId',width:100,hidden:true}    
    			 ]],
    		onSelect : function(rowIndex, rowData) {
			},
			onLoadSuccess:function(data){ 
				if(data){
					$.each(data.rows, function(index, item){		
						$('#tabCureItemList').datagrid('checkRow', index);

					});
				}  
			},
    		onClickRow:function(rowIndex, rowData){
		}
	
	});
	// 治疗记录申请单Grid
	cureApplyAppDataGrid=$('#tabCureApplyList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		rownumbers: true,
		fitColumns : true,
		striped: true,
		autoRowHeight : false,
		selectOnCheck: true,
		checkOnSelect:true,
		//scrollbarSize : '40px',
		url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"DCAARowId",
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :[[  
        			{field:'PatNo',title:'登记号',width:100},   
        			{field:'PatName',title:'姓名',width:150},   
        			{field:'PatSex',title:'性别',width:100,align:'right'},
        			{field:'PatAge',title:'年龄',width:100},
        			{field:'PatType',title:'病人类型',width:100},
        			{field:'PatTel',title:'联系电话',width:100},
        			{field:'PatAddress',title:'地址',width:100},
   					{field:'DCAAppPlan',title:'治疗方案',width:100},
        			{field:'DCAARowId',title:'DCAARowId',width:100,hidden:true}	   
    			 ]] ,
    	onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){ 
			if(data){
				$.each(data.rows, function(index, item){		
						$('#tabCureApplyList').datagrid('checkRow', index);

				});
			}  
		},
		onClickRow:function(rowIndex, rowData){

			cureApplyAppDataGrid.datagrid('selectRow',rowIndex);
			var selected=cureApplyAppDataGrid.datagrid('getRows'); 
			var DCARowId=selected[rowIndex].DCARowId;
			loadCureApplyItemDataGrid(DCARowId);
		
		}
	});
});
function loadCureApplyAppDataGrid()
{
	var cardType=$("#cardType").combobox('getValue');
	var cardNo=$("#cardNo").val();
	var patNo=$("#patNo").val();
	var sttDate=$('#sttDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocCureApp';
	queryParams.QueryName ='FindCureApplyAppDoctorList';
	queryParams.Arg1 =cardType;
	queryParams.Arg2 =cardNo;
	queryParams.Arg3 =patNo;
	queryParams.Arg4 =sttDate;
	queryParams.Arg5 =endDate;
	queryParams.Arg6 =session['LOGON.CTLOCID'];
	queryParams.ArgCnt =6;
	var opts = cureApplyAppDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureApplyAppDataGrid.datagrid('load', queryParams);
	cureApplyAppDataGrid.datagrid('unselectAll');
}
function loadCureApplyItemDataGrid(DCARowId)
{
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocCureApp';
	queryParams.QueryName ='FindApplyItemList';
	queryParams.Arg1 =DCARowId;
	queryParams.ArgCnt =1;
	var opts = cureApplyItemDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureApplyItemDataGrid.datagrid('load', queryParams);
	cureApplyItemDataGrid.datagrid('unselectAll');
	
}