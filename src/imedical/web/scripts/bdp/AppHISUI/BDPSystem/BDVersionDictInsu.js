/// Function:版本字典表与医保对照的关联表
///	Creator: 鲁俊文 陈莹
/// CreateTime:2022年10月26日
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.BDVersionDictInsu&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.BDVersionDictInsu";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDVersionDictInsu&pClassMethod=DeleteData";
var init = function(){
	
	var dicttype=tkMakeServerCall("web.DHCBL.CT.BDVersionDict","GetTypeByRowId",dictdr);	///获取版本字典对应的类型
	
	
   
	//工具条-医保对照版本查询框
	$('#TextVersionDictDr').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.BDVersionDict&QueryName=GetDataForCmb1&ResultSetType=array&type="+dicttype,
		valueField:'ID',
		textField:'VersionName'
	});
	
	//医保对照版本下拉框
	$('#VersionInsuDr').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.BDVersionDict&QueryName=GetDataForCmb1&ResultSetType=array&type="+dicttype,
		valueField:'ID',
		textField:'VersionName'
	});
	
     //查询方法
    function SearchFunLib(){
	    var insudr=$("#TextVersionDictDr").combobox('getValue')
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.BDVersionDictInsu",
            QueryName:"GetList" ,       
            versiondictdr:dictdr,
            versioninsudr:insudr
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
    //重置方法
    function ClearFunLib()
    {
		$("#TextVersionInsuDr").combobox('setValue',"");
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.BDVersionDictInsu",
            QueryName:"GetList",
            versiondictdr:dictdr
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
     //查询按钮
    $("#btnSearch").click(function (e) {
	    SearchFunLib();
     })  
     
    //重置按钮
    $("#btnRefresh").click(function (e) {
	    ClearFunLib();
     })  
	
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
		DeleteData();
	});
     //点击新增按钮
    function AddData() { 
    	$("#myWin").show(); 
        
        $HUI.checkbox("IsSyncToMr").setValue(false);
        $('#VersionInsuDr').combobox('reload'); //下拉框重新加载
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
        $("#VersionDictDr").val(dictdr);  //对版本字典dr赋值
        $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");
    }
    //点击修改按钮
    function UpdateData() 
    {
        var record = mygrid.getSelected();
        if (record)
        {            
             //调用后台openData方法给表单赋值
            var id = record.ID;
            $.cm({
                ClassName:"web.DHCBL.CT.BDVersionDictInsu",
                MethodName:"OpenData",
                id:id
            },function(jsonData){ 
            	$('#form-save').form("load",jsonData); 
                if (jsonData.IsSyncToMr=="Y")
				{
					$HUI.checkbox("#IsSyncToMr").setValue(true);	
				}else{
					$HUI.checkbox("#IsSyncToMr").setValue(false);
				}
				
            });
                     
            $("#myWin").show(); 
            $('#VersionInsuDr').combobox('reload'); //下拉框重新加载
            var myWin = $HUI.dialog("#myWin",{
                iconCls:'icon-w-edit',
                resizable:true,
                title:'修改',
                modal:true,
                buttons:[{
                    text:'保存',
                    //iconCls:'icon-save',
                    id:'save_btn',
                    handler:function(){
                    	SaveFunLib(id)
                    }
                },{
                    text:'关闭',
                    //iconCls:'icon-cancel',
                    handler:function(){
                        myWin.close();
                    }
                }]
            });   
            $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");           
        }
        else
        {
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }
    }
	
    ///新增、更新
    function SaveFunLib(id)
    {            
      
        var datefrom=$("#DateFrom").datebox("getValue");
        var dateto=$("#DateTo").datebox("getValue");      
  		if ($("#VersionInsuDr").combobox('getValue')=="")
		{
			$.messager.alert('错误提示','医保版本不能为空!',"info");
			return;
		}
		var flag= tkMakeServerCall("web.DHCBL.CT.BDVersionDictInsu","FormValidate",$.trim($("#ID").val()),$.trim($("#VersionDictDr").val()),$.trim($("#VersionInsuDr").combobox('getValue')));
		if (flag==1)
		{
			$.messager.alert('错误提示','该对照已经存在!',"info");
			return;
		}
        if (datefrom=="")
        {
            $.messager.alert('错误提示','开始日期不能为空!',"error");
            return;
        }
        if (datefrom != "" && dateto != "") {   
        	if (datefrom >dateto) {
        		$.messager.alert('错误提示','开始日期不能大于结束日期!',"error"); 
          		return;
      		}
   		}
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				$('#form-save').form('submit', { 
					url: SAVE_ACTION_URL, 
					onSubmit: function(param){
						param.VersionDictDr = dictdr;
					},
					success: function (data) { 
					  var data=eval('('+data+')'); 
					  if (data.success == 'true')
					  {
						  	$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
							if (id!="")
							{
									$('#mygrid').datagrid('reload');  // 重新载入当前页面数据
									$('#mygrid').datagrid('unselectAll');									
							}
							else{/*
								alert(data.id)
								 $.cm({
									ClassName:"web.DHCBL.CT.BDVersionDictInsu",
									QueryName:"GetList",
									rowid: data.id   
								},function(jsonData){
									$('#mygrid').datagrid('insertRow',{
										index:0,
										row:jsonData.rows[0]
									})
								})
								$('#mygrid').datagrid('unselectAll');*/
								ClearFunLib();
							}
							$('#myWin').dialog('close'); // close a dialog
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
	})
	 
   }

    //删除 
    function DeleteData()
    {    
        //更新
        var row = $("#mygrid").datagrid("getSelected"); 
        if (!(row))
        {   $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        }
		
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){	
				var rowid=row.ID; 
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{"id":rowid},  
					type:"POST",   
					//dataType:"TEXT",  
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
								  
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
								
								$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
								$('#mygrid').datagrid('unselectAll');
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
    var columns =[[
			  {field:'ID',title:'ID',hidden:true},
			  {field:'VersionDictDr',title:'版本字典',width:100,sortable:true,hidden:true},
              {field:'VersionInsuDr',title:'医保版本',width:100,sortable:true},
              {field:'DateFrom',title:'开始日期',width:100,sortable:true},
              {field:'DateTo',title:'结束日期',width:100,sortable:true},
              {field:'IsSyncToMr',title:'同步到病案系统',width:180,sortable:true,align:'center',formatter:ReturnFlagIcon}
              ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.BDVersionDictInsu",
            QueryName:"GetList",
            versiondictdr:dictdr
        }, 
        columns: columns,  //列信息
        ClassTableName:'CT_BDP_CT.BDVersionDictInsu',
        SQLTableName:'CT_BDP_CT.BDVersionDictInsu',
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
        singleSelect:true,
        idField:'ID', 
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        //remoteSort:false,  //定义是否从服务器排序数据。定义是否从服务器排序数据。true
        //toolbar:'#mytbar' 
		onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
		}
    });

    var pg = $("#mygrid").datagrid("getPager");
    if(pg)
    {
   		$(pg).pagination({
       onRefresh:function(pageNumber,pageSize){
           $('#mygrid').datagrid('unselectAll');
        },
       onChangePageSize:function(){
            $('#mygrid').datagrid('unselectAll');
        },
       onSelectPage:function(pageNumber,pageSize){
           $('#mygrid').datagrid('unselectAll');
        }
   		});
	}
	
   // HISUI_Funlib_Translation('mygrid');
   // HISUI_Funlib_Sort('mygrid');
   ShowUserHabit('mygrid');
};
$(init);