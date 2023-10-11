/*
* @Author: 基础数据平台-陈莹
* @Date:   2021-12-21 
* @描述:翻译界面第二版
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTranslation&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.BDPTranslation";
var init=function()
{
	//点击事件
	//点击查询按钮
	$("#btnSearch").click(function(e){
		SearchFunLib();
	});
	//点击重置按钮
	$("#btnRefresh").click(function(e){
		ClearFunLib();
	});
	//点击添加按钮
	$("#btnAdd").click(function(e){
		AddData();
	});
	//点击修改按钮
	$("#btnUpdate").click(function(e){
		UpdateData();
	});
	//点击删除按钮
	$("#btnDel").click(function (e) { 
		DelData();
	});	
	//语言 查询下拉框
	$('#TextLanguage').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.SSLanguage&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTLANCode',
		textField:'CTLANDesc'
	});
	
	
	$('#TextFieldName,#TextFieldDesc').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	    
	});		
	//查询
	SearchFunLib=function(){
		var tablename="";
		//var rows = $('#mygridLeft').datagrid('getSelections');  //取得所有选中行数据，返回元素记录的数组数据
		var rows = $('#mygridLeft').datagrid('getChecked');  //在复选框呗选中的时候返回所有行
		if(rows.length>0)
		{
			for(var i=0; i<rows.length; i++){
				tablename=tablename+rows[i].TableName+"^";
			}
		}
		var fieldname=$("#TextFieldName").val()
		var language=$("#TextLanguage").combobox('getValue')
		var fielddesc=$("#TextFieldDesc").val()
		$('#mygrid').datagrid('load',  { 
			'ClassName':"web.DHCBL.BDP.BDPTranslation",
			'QueryName':"GetListHISUI2",
			'language': language,
			'fielddesc': fielddesc,
			'tablename':tablename,
			'fieldname':fieldname
		});
		$('#mygrid').datagrid('unselectAll');
	}
	//重置
	ClearFunLib=function(){
		$("#TextFieldName").val("")
		$("#TextLanguage").combobox('setValue',"")
		$("#TextFieldDesc").val("")
		$('#mygrid').datagrid('load',  { 
			'ClassName':"web.DHCBL.BDP.BDPTranslation",
			'QueryName':"GetListHISUI2"			
		}); 
		$('#mygrid').datagrid('unselectAll');
	}
	
	//语言 下拉框
	$('#BTLanguages').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.SSLanguage&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTLANCode',
		textField:'CTLANDesc'
	});


	//类名 下拉框
	$('#BTTableName').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPTableList&QueryName=GetList&ResultSetType=array&uniteflag="+"Y",
		valueField:'TableName',
		textField:'TableDesc',
		
        onSelect:function(row){
        	$('#BTFieldName').combobox('enable');//启用
           	$('#BTFieldName').combobox('clear');
           	var parref=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetRowidByTableName",row.TableName);
          	var url=$URL+"?ClassName=web.DHCBL.BDP.BDPTableField&QueryName=GetList&ResultSetType=array&ParRef=" +parref+"&filterflag="+"Y";
          	$('#BTFieldName').combobox('reload',url);
         }

	});

	//字段名  下拉框
	$('#BTFieldName').combobox({ 
		valueField:'FieldName',
		textField:'FieldDesc'
	});
	//点击添加按钮
	AddData=function () 
	{	
		$('#BTTableName').combobox('reload');
		$('#BTFieldName').combobox('clear');
		$('#BTLanguages').combobox('reload');
		$("#myWin").show();
		$('#BTFieldName').combobox('disable');
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				//iconCls:'icon-save',
				id:'save_btn',
				handler:function(){					
					SaveFunLib("")								
				}
			},{
				text:'关闭',
				//iconCls:'icon-cancel',
				handler:function(){
					myWin.close();
				}
			}]
		});	
		$('#form-save').form("clear");
		//2022-1-19 翻译-数据翻译-在左侧【表结构登记】中选择任意记录，点击右侧【翻译数据】中的<新增>按钮，【类名】默认为空，而不是在左侧选中的记录的类名
		var rows = $('#mygridLeft').datagrid('getChecked');  //在复选框呗选中的时候返回所有行
		if(rows.length>0)
		{
			$("#BTTableName").combobox('setValue',rows[0].TableName)
			if (rows[0].TableName!="")
			{
				$('#BTFieldName').combobox('enable');//启用
				$('#BTFieldName').combobox('clear');
				var parref=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetRowidByTableName",rows[0].TableName);
				var url=$URL+"?ClassName=web.DHCBL.BDP.BDPTableField&QueryName=GetList&ResultSetType=array&ParRef=" +parref+"&filterflag="+"Y";
				$('#BTFieldName').combobox('reload',url);
			}
		}	

	}
	
	//点击修改按钮
	UpdateData=function () 
	{
		$('#BTTableName').combobox('reload');
		//$('#BTFieldName').combobox('reload');
		$('#BTLanguages').combobox('reload');
		var record=mygrid.getSelected();	
		if (!(record))
		{	
			$.messager.alert('提示','请先选择一条记录!',"info");
			return;
		}
		else{
			var id=record.ID;
			$.cm({
				ClassName:"web.DHCBL.BDP.BDPTranslation",
				MethodName:"OpenDataHISUI",
				id: id,      ///rowid
				RetFlag:"JSON"
			},
			function(jsonData){
				$('#BTFieldName').combobox('enable');//启用
				//$('#BTFieldName').combobox('clear');
				var parref=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetRowidByTableName",jsonData.BTTableName);
          		var url=$URL+"?ClassName=web.DHCBL.BDP.BDPTableField&QueryName=GetList&ResultSetType=array&ParRef=" +parref+"&filterflag="+"Y";
          		$('#BTFieldName').combobox('reload',url);
				//$('#BTFieldName').combobox('setValue', jsonData.BTFieldName);
				$('#form-save').form("load",jsonData);
				
			});	
			$("#myWin").show();
			
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[{
					text:'保存',
					id:'save_btn',
					handler:function(){
						SaveFunLib(id)
					}
				},{
					text:'关闭',
					handler:function(){
						myWin.close();
					}
				}]
			});			
		}						
	}
	///添加、修改
	SaveFunLib=function(id)
	{	
		var BTTableName=$("#BTTableName").combobox('getValue')
		if ((BTTableName==undefined)||(BTTableName=="undefined")||(BTTableName==""))
		{
			$.messager.alert('提示','表名请选择下拉列表里的值!',"info");
			return;
		}
		var BTFieldName=$("#BTFieldName").combobox('getValue')
		if ((BTFieldName==undefined)||(BTFieldName=="undefined")||(BTFieldName==""))
		{
			$.messager.alert('提示','字段名请选择下拉列表里的值!',"info");
			return;
		}
		var BTLanguages=$('#BTLanguages').combobox('getValue')
		if ((BTLanguages==undefined)||(BTLanguages=="undefined")||(BTLanguages==""))
		{
			$.messager.alert('提示','语言请选择下拉列表里的值!',"info");
			return;
		}
		var BTFieldDesc=$("#BTFieldDesc").val()
		if ($.trim(BTFieldDesc)=="")
		{
			$.messager.alert('提示','翻译前中文不能为空!',"info");
			return;
		}
		var BTTransDesc=$("#BTTransDesc").val()
		if ($.trim(BTTransDesc)=="")
		{
			$.messager.alert('提示','翻译后内容不能为空!',"info");
			return;
		}	

		var result= tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","Translated",id,BTTableName,BTFieldName,BTLanguages,BTFieldDesc);
		if(result==0){

			$.messager.confirm('提示', "确认要保存数据吗?", function(r){
				if (r){
					///保存
					$('#form-save').form('submit', { 
						url: SAVE_ACTION_URL,
						success: function (data) { 
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
									$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
									if (id!="")
									{
										$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
									}
									else{
										
										 $.cm({
											ClassName:"web.DHCBL.BDP.BDPTranslation",
											QueryName:"GetListHISUI2",
											rowid: data.id   
										},function(jsonData){
											$('#mygrid').datagrid('insertRow',{
												index:0,
												row:jsonData.rows[0]
											})
										})
										$('#mygrid').datagrid('unselectAll');
									}
									$('#myWin').dialog('close'); // close a dialog
							  } 
							  else { 
									var errorMsg ="提交失败！"
									if (data.errorinfo) {
										errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
									}
									$.messager.alert('操作提示',errorMsg,"error");
							  }
						} 
					});
				}
			})
		}else{
			$.messager.alert('操作提示',"该字段已翻译！","info");
		}
	}
	//点击删除按钮
	DelData=function()
	{
		var row = $("#mygrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('提示','请先选择一条记录!',"info");
			return;
		}
		var rowid=row.ID;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
				var datas = tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","DeleteData",rowid);
				var data = eval('('+datas+')');

			    if (data.success == 'true') {
			        $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
			        $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
					$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据 							 			       
			    }
			    else{
			        var errorMsg ="删除失败！"
					if (data.info) {
						errorMsg =errorMsg+ '<br/>错误信息:' + data.info
					}
					$.messager.alert('操作提示',errorMsg,"error");
			    }				
			}
		});
	}


	
	var columns =[[  
				  {field:'ID',title:'ID',width:60,sortable:true,hidden:true},
				  {field:'BTTableName',title:'类名',width:150,sortable:true},
				  {field:'BTFieldName',title:'字段名',width:100,sortable:true},
				  {field:'BTLanguages',title:'语言',width:50,sortable:true},
				  {field:'BTFieldDesc',title:'翻译前中文',width:100,sortable:true},
				  {field:'BTTransDesc',title:'翻译后内容',width:100,sortable:true}
	 ]];
	 
	///翻译数据列表
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.BDP.BDPTranslation",         ///调用Query时
			QueryName:"GetListHISUI2"
		},
		ClassTableName:'User.BDPTranslation',
		SQLTableName:'BDP_Translation',
		idField:'ID',
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:20,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		
		onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
        },
        onClickRow:function(rowIndex,rowData){
        
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }
	});
	
	

	
	
	$('#TextTableName').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLibLeft();
		}
		if(event.keyCode == 27) {
		  ClearFunLibLeft();
		}
	    
	});		
	$('#TextType').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLibLeft();
		}
		if(event.keyCode == 27) {
		  ClearFunLibLeft();
		}
	    
	});		
	//查询
	SearchFunLibLeft=function(){
		$('#mygridLeft').datagrid('load',  { 
			'ClassName':"web.DHCBL.BDP.BDPTableList",
			'QueryName':"GetList",
			'type': $("#TextType").val(),
			'code':$("#TextTableName").val()
		});
		$('#mygridLeft').datagrid('unselectAll');
	}
	//重置
	ClearFunLibLeft=function(){
		$("#TextTableName").val("")
		$("#TextType").val("")
		$('#mygridLeft').datagrid('load',  { 
			'ClassName':"web.DHCBL.BDP.BDPTableList",
			'QueryName':"GetList"			
		}); 
		$('#mygridLeft').datagrid('unselectAll');
	}
	$("#btnSearchLeft").click(function(e){
		SearchFunLibLeft();
	});
	//点击重置按钮
	$("#btnRefreshLeft").click(function(e){
		ClearFunLibLeft();
	});
	
    ///
    var columnsLeft =[[
    	{field:'checked',title:'sel',checkbox:true},
   		{field:'ID',title:'RowId',width:100,sortable:true,hidden:true},
	    {field:'TableName',title:'类名',width:100,sortable:true},
	    {field:'TableDesc',title:'描述',width:100,sortable:true},
	    {field:'Type',title:'产品组',width:100,sortable:true}
    ]];
    var mygridLeft= $HUI.datagrid("#mygridLeft",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.BDP.BDPTableList",
            QueryName:"GetList"
        },
        columns: columnsLeft,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        idField:'ID',
        singleSelect:false,  //允许多选
		//frozenColumns:[[ {field:'ck',checkbox:true}]],//多选框,位置固定在最左边
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        checkOnSelect:true,   //如果为true，当用户点击行的时候该复选框就会被选中或取消选中。如果为false，当用户仅在点击该复选框的时候才会呗选中或取消。
		selectOnCheck:true, //如果为true，单击复选框将永远选择行。如果为false，选择行将不选中复选框。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onCheck:function(index, row){  //选中数据时，checked的内容没有变化

			SearchFunLib();
		},
		onUncheck:function(index, row){ //取消选中数据时，checked的内容没有变化
			SearchFunLib();
		},
		onCheckAll:function(rows){  //选中数据时，checked的内容没有变化
			SearchFunLib();
		},
		onUncheckAll:function(rows){  //选中数据时，checked的内容没有变化
			SearchFunLib();
		},
        onLoadSuccess:function(data){
	        $("#mygridLeft").parent().find("div.datagrid-header-check").children("input[type='checkbox']").eq(0).attr("checked", false);
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
            $('#mygridLeft').datagrid('unselectAll');
		},
		onClickRow:function(rowIndex,rowData){
			
        }
	});
	
	
}
$(init);