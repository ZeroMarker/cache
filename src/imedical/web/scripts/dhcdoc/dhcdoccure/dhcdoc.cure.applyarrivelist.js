var cureApplyAppArriveDataGrid;
$(function(){
	//�������б�
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
		text:'����',
		iconCls:'icon-add',
		handler:function(){
			
					var selected = cureApplyAppArriveDataGrid.datagrid('getSelected');
					var rows = cureApplyAppArriveDataGrid.datagrid("getSelections");
					if (rows.length==0) 
					{
						$.messager.alert("��ʾ","��ѡ��ԤԼ��Ŀ");
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
						$.messager.confirm('����',"ȷ��Ҫ������",function(r){
						if (r){
						if((typeof(selected.DCAARowId) != "undefined")&&(selected.DCAARowId!="")){
							var DCAARowId=selected.DCAARowId;
							//return false;
							$.dhc.util.runServerMethod("web.DHCDocCureApp","UpdateCureAppState","false",function testget(value){
								if(value == "0"){
									$.messager.show({title:"��ʾ",msg:"�ɹ�����"});  
								}else{
									if(value=="102") value="ԤԼ��¼����ԤԼ״̬,���ܵ���"
									$.messager.alert("��ʾ","����ʧ��:"+value);
									return;
								}
								loadCureApplyAppArriveDataGrid();
							},"","",DCAARowId,"Arrive",session['LOGON.USERID']);
						}
					  }
				   });
				}else{
					$.messager.alert("��ʾ","��ѡ��һ������ԤԼ��¼");
				}
			
			
		}
	},'-',{
		id:'BtnDelete',
		text:'ȡ������',
		iconCls:'icon-remove',
		handler:function(){
			
					var selected = cureApplyAppArriveDataGrid.datagrid('getSelected');
					if (selected){
						$.messager.confirm('����',"ȷ��Ҫȡ��������",function(r){
						if (r){
						if((typeof(selected.DCAARowId) != "undefined")&&(selected.DCAARowId!="")){
							var DCAARowId=selected.DCAARowId;
							$.dhc.util.runServerMethod("web.DHCDocCureApp","UpdateCureAppState","false",function testget(value){
								if(value == "0"){
									$.messager.show({title:"��ʾ",msg:"�ɹ�ȡ������"});  
								}else{
									if(value=="102") value="ԤԼ��¼���ǵ���״̬,����ȡ��"
									$.messager.alert("��ʾ","ȡ��ʧ��:"+value);
								}
								loadCureApplyAppArriveDataGrid();
							},"","",DCAARowId,"Cancel",session['LOGON.USERID']);
						}
					}
				});
			}else{
				$.messager.alert("��ʾ","��ѡ��һ������ԤԼ��¼");
			}
			
		}
	},'-',{
		id:'BtnClear',
		text:'���', 
		iconCls:'icon-cancel',  
		handler:function(){
			location.reload();
		}
	}];
	// ���Ƽ�¼���뵥Grid
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
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"DCAARowId",
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :[[
					{field:'RowCheck',checkbox:true},   
        			{field:'PatNo',title:'�ǼǺ�',width:100},   
        			{field:'PatName',title:'����',width:150},   
        			{field:'PatSex',title:'�Ա�',width:100,align:'right'},
        			{field:'PatAge',title:'����',width:100},
        			{field:'PatType',title:'��������',width:100},
        			{field:'PatTel',title:'��ϵ�绰',width:100},
        			{field:'PatAddress',title:'��ַ',width:100},
        			{field:'DCAArcimDesc',title:'������Ŀ',width:100},
        			{field:'DCATimes',title:'���ƴ���',width:100},
        			{field:'DCAAReqDate',title:'ԤԼ����',width:100},
        			{field:'DCAAReqTime',title:'ԤԼʱ���',width:100},
        			{field:'DCAAStatus',title:'ԤԼ״̬',width:100},
        			{field:'DCAADate',title:'��������',width:100},
        			{field:'DCAATime',title:'����ʱ��',width:100},
        			{field:'DCAARoom',title:'ԤԼ��������',width:100},
        			{field:'DCAAUseQty',title:'ռ����������',width:100},
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
