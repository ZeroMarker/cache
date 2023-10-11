/// Function:版本字典表(诊断/手术)
///	Creator: 鲁俊文 陈莹
///CreateTime:2022年10月26日
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.BDVersionDict&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.BDVersionDict";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDVersionDict&pClassMethod=DeleteData";
var init = function(){
	
	
	//类型下拉框
	/*$('#Type').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.BDVersionDict&QueryName=GetTypeDataForCmb1&ResultSetType=array",
		placeholder:'如需新增类型，可手动输入',
		valueField:'Type',
		textField:'Type'
		
	});*/
	//类型下拉框
	$HUI.combobox("#Type",{
		valueField:'value',
		textField:'text',
		data:[
			{value:'User.MRCICDDx',text:'诊断'},
			{value:'User.ORCOperation',text:'手术'}
		]
	});
	$HUI.combobox("#TextType",{
		valueField:'value',
		textField:'text',
		data:[
			{value:'User.MRCICDDx',text:'诊断'},
			{value:'User.ORCOperation',text:'手术'}
		],
		onSelect:function(){
			SearchFunLib();
		}
	});
    //搜索回车事件
	$('#TextDesc,#TextCode').keyup(function(event){
		if(event.keyCode == 13)
		{
			SearchFunLib();
		}
	});  
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
	
	
     //查询方法
    function SearchFunLib(){
        var code=$.trim($("#TextCode").val());
        var desc=$.trim($('#TextDesc').val());
        var type= $('#TextType').combobox('getValue');
        //var type=$.trim($('#TextType').val());   
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.BDVersionDict",
            QueryName:"GetList" ,   
            'code':code,    
            'desc': desc,
            'type':type
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
    //重置方法
    function ClearFunLib()
    {
        $("#TextCode").val("");
        $("#TextDesc").val("");
        $('#TextType').combobox('setValue','');  
        //$("#TextType").val("");  ///类型
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.BDVersionDict",
            QueryName:"GetList"
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
    
     //点击新增按钮
    function AddData() { 
        $("#myWin").show();
        $('#Type').combobox('reload'); //下拉框重新加载
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
        $('#form-save').form("clear"); //优化弹窗清空
        $HUI.checkbox("#IsSyncToMr").setValue(false);
        $HUI.checkbox("#IsChineseMedicineFlag").setValue(false);
        $HUI.checkbox("#IsInsuFlag").setValue(false);
        $('#DateFrom').datebox('setValue', getCurentDateStr());
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
                ClassName:"web.DHCBL.CT.BDVersionDict",
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
				if (jsonData.IsChineseMedicineFlag=="Y")
				{
					$HUI.checkbox("#IsChineseMedicineFlag").setValue(true);	
				}else{
					$HUI.checkbox("#IsChineseMedicineFlag").setValue(false);
				}
				if (jsonData.IsInsuFlag=="Y")
				{
					$HUI.checkbox("#IsInsuFlag").setValue(true);	
				}else{
					$HUI.checkbox("#IsInsuFlag").setValue(false);
				}
				
				
            });
                     
            $("#myWin").show(); 
            $('#Type').combobox('reload'); //下拉框重新加载
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
    
    //点击医保对照版本同步维护
	$('#BtnVersionLinkInsu').bind('click', function(){
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var dictdr=record.ID;
		$("#winVersionLinkInsu").show();  
		var url= "dhc.bdp.ct.bdversiondictinsu.csp?dictdr="+dictdr;
		if ('undefined'!==typeof websys_getMWToken)
        {
			url += "&MWToken="+websys_getMWToken() // 增加token
		}
		$('#winVersionLinkInsu').window({
			iconCls:'icon-w-list',
			title:record.VersionName+"-医保对照版本同步维护",
			width:(document.documentElement.clientWidth-40),
			height:(document.documentElement.clientHeight-40),
			modal:true,
			resizable:true,
			draggable :true,
			content:"<iframe scrolling='auto' frameborder='0'  width='100%' height='100%' iconCls='icon-w-home' src='"+url+"'></iframe>"
		});
	});
    
    
	
	
    ///新增、更新
    function SaveFunLib(id)
    {
    	//var type=$HUI.combobox('#Type').getText();
		var type=$HUI.combobox('#Type').getValue();
		if(type=="")
		{
			$.messager.alert('错误提示','类型不能为空！','error');
			return;
		}
        var code=$.trim($("#VersionCode").val());
        var desc=$.trim($("#VersionName").val());
        var datefrom=$("#DateFrom").datebox("getValue");
        var dateto=$("#DateTo").datebox("getValue");      
        if (code=="")
        {
            $.messager.alert('错误提示','版本代码不能为空!',"error");
            return;
        }
        if (desc=="")
        {
            $.messager.alert('错误提示','版本名称不能为空!',"error");
            return;
        }
        var flag= tkMakeServerCall("web.DHCBL.CT.BDVersionDict","FormValidate",$.trim($("#ID").val()),$.trim($("#VersionCode").val()),"");
		if (flag==1)
		{
			$.messager.alert('错误提示','版本代码已经存在!',"info");
			return;
		}
		var flag= tkMakeServerCall("web.DHCBL.CT.BDVersionDict","FormValidate",$.trim($("#ID").val()),"",$.trim($("#VersionName").val()));
		if (flag==1)
		{
			$.messager.alert('错误提示','版本名称已经存在!',"info");
			return;
		}
        if (datefrom=="")
        {
            $.messager.alert('错误提示','开始日期不能为空!',"error");
            return;
        }
        if ((datefrom != "") && (dateto != "")) {   
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
						param.Type = type;
						//param.ID = id;
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
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.CT.BDVersionDict",
										QueryName:"GetList",
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
	          {field:'Type',title:'类型',width:100,sortable:true,
	          		formatter:function(v,row,index){  
						if(v=='User.MRCICDDx'){return '诊断';}
						else if(v=='User.ORCOperation'){return '手术';}
						else {return v;}
					}
				},
			  {field:'VersionCode',title:'版本代码',width:100,sortable:true},
			  {field:'VersionName',title:'版本名称',width:100,sortable:true},
              {field:'DateFrom',title:'开始日期',width:100,sortable:true},
              {field:'DateTo',title:'结束日期',width:100,sortable:true},
              {field:'IsSyncToMr',title:'同步到病案系统',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon}, 
              {field:'IsChineseMedicineFlag',title:'中医数据标识',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon},
              {field:'IsInsuFlag',title:'医保数据标识',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon}
              ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.BDVersionDict",
            QueryName:"GetList"
        }, 
        columns: columns,  //列信息
        ClassTableName:'CT.BDP.CT.BDVersionDict',
        SQLTableName:'CT_BDP_CT.BDVersionDict',
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
    //HISUI_Funlib_Sort('mygrid');
    ShowUserHabit('mygrid');
};
$(init);