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
		   loadCureApplyAppArriveDataGrid();
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
			  if ((cardNo.length<cardNoLength)&&(cardNoLength!=0)) {
					for (var i=(cardNoLength-cardNo.length-1); i>=0; i--) {
						cardNo="0"+cardNo;
					}
				}
			$("#cardNo").val(cardNo);
		   }
    });   
	// Toolbar
	var cureApplyAppArriveToolBar = [{
		id:'BtnAdd',
		text:'到达',
		iconCls:'icon-add',
		handler:function(){
			
					var selected = cureApplyAppArriveDataGrid.datagrid('getSelected');
					var rows = cureApplyAppArriveDataGrid.datagrid("getSelections");
					if (rows.length==0) 
					{
						$.messager.alert("提示","请选择预约项目");
						return;
					}
					var DCAARowIdStr=""
					/*
					for (var i=0; i<rows.length; i++) {
					var rowIndex = cureApplyAppArriveDataGrid.datagrid("getRowIndex", rows[i]);
					var selected=cureApplyAppArriveDataGrid.datagrid('getRows'); 
					var DCAARowId=selected[rowIndex].DCAARowId;
					if (DCAARowIdStr=="")DCAARowIdStr=DCAARowId;
					else DCAARowIdStr=DCAARowIdStr+"^"+DCAARowId;
    				}*/
					if (selected){
						$.messager.confirm('到达',"确认要到达吗",function(r){
						if (r){
						if((typeof(selected.DCAARowId) != "undefined")&&(selected.DCAARowId!="")){
							var DCAARowId=selected.DCAARowId;
							//return false;
							$.dhc.util.runServerMethod("web.DHCDocCureApp","UpdateCureAppState","false",function testget(value){
								if(value == "0"){
									$.messager.show({title:"提示",msg:"成功到达"});  
								}else{
									if(value=="102") value="预约记录不是预约状态,不能到达"
									$.messager.alert("提示","到达失败:"+value);
									return;
								}
								loadCureApplyAppArriveDataGrid();
							},"","",DCAARowId,"Arrive",session['LOGON.USERID']);
						}
					  }
				   });
				}else{
					$.messager.alert("提示","请选择一行治疗预约记录");
				}
			
			
		}
	},'-',{
		id:'BtnDelete',
		text:'取消到达',
		iconCls:'icon-remove',
		handler:function(){
			
					var selected = cureApplyAppArriveDataGrid.datagrid('getSelected');
					if (selected){
						$.messager.confirm('到达',"确认要取消到达吗",function(r){
						if (r){
						if((typeof(selected.DCAARowId) != "undefined")&&(selected.DCAARowId!="")){
							var DCAARowId=selected.DCAARowId;
							$.dhc.util.runServerMethod("web.DHCDocCureApp","UpdateCureAppState","false",function testget(value){
								if(value == "0"){
									$.messager.show({title:"提示",msg:"成功取消到达"});  
								}else{
									if(value=="102") value="预约记录不是到达状态,不能取消"
									$.messager.alert("提示","取消失败:"+value);
								}
								loadCureApplyAppArriveDataGrid();
							},"","",DCAARowId,"Cancel",session['LOGON.USERID']);
						}
					}
				});
			}else{
				$.messager.alert("提示","请选择一行治疗预约记录");
			}
			
		}
	},'-',{
		id:'BtnClear',
		text:'清空', 
		iconCls:'icon-cancel',  
		handler:function(){
			location.reload();
		}
	}];
	// 治疗记录申请单Grid
	cureApplyAppArriveDataGrid=$('#tabCureApplyAppArriveList').datagrid({  
		/*
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		selectOnCheck: true,
		checkOnSelect:true,
		*/
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
					{field:'RowCheck',checkbox:true},   
        			{field:'PatNo',title:'登记号',width:100},   
        			{field:'PatName',title:'姓名',width:150},   
        			{field:'PatSex',title:'性别',width:100,align:'right'},
        			{field:'PatAge',title:'年龄',width:100},
        			{field:'PatType',title:'病人类型',width:100},
        			{field:'PatTel',title:'联系电话',width:100},
        			{field:'PatAddress',title:'地址',width:100},
        			{field:'DCAArcimDesc',title:'治疗项目',width:100},
        			{field:'DCATimes',title:'治疗次数',width:100},
        			{field:'DCAAReqDate',title:'预约日期',width:100},
        			{field:'DCAAReqTime',title:'预约时间段',width:100},
        			{field:'DCAAStatus',title:'预约状态',width:100},
        			{field:'DCAADate',title:'到达日期',width:100},
        			{field:'DCAATime',title:'到达时间',width:100},
        			{field:'DCAARoom',title:'预约治疗诊室',width:100},
        			{field:'DCAAUseQty',title:'占用治疗数量',width:100},
        			{field:'DCAARowId',title:'DCAARowId',width:100,hidden:true}	   
    			 ]] ,
    	toolbar : cureApplyAppArriveToolBar,
    	onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){ 
			if(data){
				$.each(data.rows, function(index, item){		
						$('#tabCureApplyAppArriveList').datagrid('checkRow', index);

				});
			}  
		},
		onClickRow:function(rowIndex, rowData){
		}
	});
	loadCureApplyAppArriveDataGrid();
});
function loadCureApplyAppArriveDataGrid()
{
	var cardType=$("#cardType").combobox('getValue');
	var cardNo=$("#cardNo").val();
	var patNo=$("#patNo").val();
	var sttDate=$('#sttDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocCureApp';
	queryParams.QueryName ='FindCureApplyAppArriveList';
	queryParams.Arg1 =cardType;
	queryParams.Arg2 =cardNo;
	queryParams.Arg3 =patNo;
	queryParams.Arg4 =sttDate;
	queryParams.Arg5 =endDate;
	queryParams.Arg6 =session['LOGON.CTLOCID'];
	queryParams.ArgCnt =6;
	var opts = cureApplyAppArriveDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureApplyAppArriveDataGrid.datagrid('load', queryParams);
	cureApplyAppArriveDataGrid.datagrid('unselectAll');
}
