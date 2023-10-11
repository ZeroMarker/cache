
//Creator:sunfengchao
//CreatDate:2021-07-18  
//Description: 多院区服务
/// 多院区服务
var SERVINCE_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.BDPMultiHospitalService&pClassMethod=SaveData&pEntityName=web.Entity.CT.BDPMultiHospitalService";
var SERVINCE_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPMultiHospitalService&pClassMethod=DeleteData";

/// 多院区服务配置
var CONFIG_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.BDPHospitalServiceConfig&pClassMethod=SaveData&pEntityName=web.Entity.CT.BDPHospitalServiceConfig";
var CONFIG_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPHospitalServiceConfig&pClassMethod=DeleteData";

/// 多院区服务配置明细
var DETAIL_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.BDPHospSerConfigCategory&pClassMethod=SaveData&pEntityName=web.Entity.CT.BDPHospSerConfigCategory";
var DETAIL_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPHospSerConfigCategory&pClassMethod=DeleteData";
  
var init = function(){
      var tableName = "BDP_HospitalServiceConfig";
      var hospComp=GenHospComp('BDP_HospitalServiceConfig'); //多院区下拉框
      hospComp.options().onSelect=function(){  
            var HospID=hospComp.getValue();
            var row = $("#servincegrid").datagrid("getSelected"); 
            if (row){
                $('#configgrid').datagrid('reload',  {
                    ClassName:"web.DHCBL.CT.BDPHospitalServiceConfig",
                    QueryName:"GetList",
                    ParRef:row.ID,
                    hospital:HospID
                }); 
                $('#detailgrid').datagrid('reload',{
                    ClassName:"web.DHCBL.CT.BDPHospSerConfigCategory",
                    QueryName:"GetList" 
                }); 
                $('#configgrid').datagrid('unselectAll');
                $('#detailgrid').datagrid('unselectAll');                    
            }
      }
     
    $HUI.combobox("#BDPMHOSPServiceType",{
        valueField:'value',
        textField:'text',
        data:[
            {value:'L',text:'受限'},
            {value:'UL',text:'不受限'} 
        ]
    });
    
     ///  当前医院
     $("#BDPSerConfigCurrenHospDR").combobox({  
        url: $URL + '?ClassName=web.DHCBL.CT.CTHospital&QueryName=GetDataForCmb1&ResultSetType=array' ,
        method: 'GET',
        valueField: 'HOSPRowId',
        textField: 'HOSPDesc'   
    });
    
    /// 可操作医院
     $("#BDPSerConfigOperateHospDR").combobox({
        url: $URL + '?ClassName=web.DHCBL.CT.CTHospital&QueryName=GetDataForCmb1&ResultSetType=array' ,
        method: 'GET',
        valueField: 'HOSPRowId',
        textField: 'HOSPDesc'  
    });
    ///服务配置 类型  按登录、按就诊、按开单、按接收
    $HUI.combobox("#BDPSerConfigType",{
        valueField:'value',
        textField:'text',
        data:[
            {value:'DL',text:'按登录'},
            {value:'KD',text:'按开单'},
            {value:'JZ',text:'按就诊'} , 
            {value:'JS',text:'按接收'}
        ]
    }); 
    
    //项目  科室L、医嘱项O、医嘱子类I
    $HUI.combobox("#BDPSerConfigCategory",{
        valueField:'value',
        textField:'text',
        data:[
            {value:'LOC',text:'科室'},
            {value:'ORD',text:'医嘱项'} ,
            {value:'ORDCAT',text:'医嘱子类'}
        ]  
    });
      
    //多院区业务  新增按钮
    $("#ServicebtnAdd").click(function (e) 
    {    
          AddServiceData();
    }) 
    //多院区业务  修改按钮
    $("#ServicebtnUpdate").click(function (e) 
    { 
          UpdateServiceData(); 
    }) 
      //多院区业务  删除按钮
    $("#ServicebtnDel").click(function (e) 
    { 
          DelServiceData(); 
    }) 
    
      
    //多院区业务  新增方法
    function AddServiceData(){  
        $("#myWinService").show();  
		$("#BDPMHOSPServiceID").val("");   /// 新增时将 ID 置空一下
        $("#BDPMHOSPServiceCode").val("");  
        $("#BDPMHOSPServiceDesc").val("");
        $("#BDPMHOSPServiceType").combobox("setValue",""); 
        var myWinService = $HUI.dialog("#myWinService",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'新增',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'保存', 
                id:'save_btn',
                handler:function(){
                    SaveServinceFunLib("")
                }
            },{
                text:'关闭', 
                handler:function(){
                    myWinService.close();
                }
            }]
        }); 
            
    }
     //多院区业务  修改方法
    function UpdateServiceData(){   
        var record = servincegrid.getSelected(); 
        if (record){      
            var id = record.ID;
            $.cm({
                ClassName:"web.DHCBL.CT.BDPMultiHospitalService",
                MethodName:"OpenData",
                id:id
            },function(jsonData){
                $('#form-save').form("load",jsonData);  
            });    
            $("#myWinService").show(); 
            var myWinService = $HUI.dialog("#myWinService",{
                iconCls:'icon-w-edit',
                resizable:true,
                title:'修改',
                modal:true,
                buttons:[{
                    text:'保存', 
                    id:'save_btn',
                    handler:function(){
                        SaveServinceFunLib(id)
                    }
                },{
                    text:'关闭', 
                    handler:function(){
                        myWinService.close();
                    }
                }]
            });             
        }else{
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }    
    } 
    
    //多院区业务  删除方法
    function DelServiceData(){ 
        var row = $("#servincegrid").datagrid("getSelected"); 
        if (!(row))
        {   $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        }
        var rowid=row.ID; 
        var flag= tkMakeServerCall("web.DHCBL.CT.BDPMultiHospitalService","GetRefFlag",rowid);
        if (flag==1){
            $.messager.confirm('提示', '该业务已有关联数据，是否继续删除?', function(r){
                if (r){  
                    ExecuteDelService(rowid);
                }
            }); 
        }
        else{
            $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
                if (r){  
                    ExecuteDelService(rowid);
                }
            }); 
        }       
    }  
    function ExecuteDelService(rowid){
            $.ajax({
                        url:SERVINCE_DELETE_ACTION_URL,  
                        data:{"id":rowid},  
                        type:"POST",    
                        success: function(data){
                                  var data=eval('('+data+')'); 
                                  if (data.success == 'true') { 
                                    $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000}); 
                                    $('#servincegrid').datagrid('reload');  // 重新载入 多院区业务 列表  
                                    $('#servincegrid').datagrid('unselectAll');
                                    $('#configgrid').datagrid('reload');  // 重新载入 多院区业务配置
                                    $('#configgrid').datagrid('unselectAll');
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
    
    //多院区业务  保存 方法
    function SaveServinceFunLib(id)
    {            
        var BDPMHOSPServiceCode=$.trim($("#BDPMHOSPServiceCode").val());
        var BDPMHOSPServiceDesc=$.trim($("#BDPMHOSPServiceDesc").val()); 
        var BDPMHOSPServiceType=$("#BDPMHOSPServiceType").combobox("getValue"); 
        if (BDPMHOSPServiceCode=="") {
            $.messager.alert('错误提示','多院区服务代码不能为空!',"error");
            return;
        }
        if (BDPMHOSPServiceDesc==""){ 
            $.messager.alert('错误提示','多院区服务功能不能为空!',"error");
            return;
        }
        if (BDPMHOSPServiceType==""){
            $.messager.alert('错误提示','多院区服务类型不能为空!',"error");
            return;
        }
       $.messager.confirm('提示', "确认要保存数据吗?", function(r){
            if (r){
                $('#form-save').form('submit', { 
                    url: SERVINCE_SAVE_ACTION_URL,  
                    success: function (data) { 
                      var data=eval('('+data+')'); 
                      if (data.success == 'true') {
                        $.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
                        
                        $('#servincegrid').datagrid('reload');  // 重新载入当前页面数据 
                        $('#servincegrid').datagrid('unselectAll');
                        $('#myWinService').dialog('close'); // close a dialog
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
     
    var columns =[[  
          {field:'BDPMHOSPServiceCode',title:'代码',width:120},
          {field:'BDPMHOSPServiceDesc',title:'功能',width:120},
          {field:'BDPMHOSPServiceType',title:'类型',width:120},
          {field:'ID',title:'ID',width:120,hidden:true}
    ]];
    
    /// 多院区服务 定义列表
    var servincegrid = $HUI.datagrid("#servincegrid",{
        url:$URL,
        pagination: false,   
        queryParams:{
            ClassName:"web.DHCBL.CT.BDPMultiHospitalService",
            QueryName:"GetList",
            rows:100 
        },
        columns: columns,   
        striped:true, 
        singleSelect:true, 
        idField:'myDate',   //标识字段
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        toolbar:'#mytbar', 
        onLoadSuccess:function(data)
        {
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },
        onDblClickRow:function(rowIndex,rowData){
            UpdateServiceData();
        },
        onClickRow:function(index,row)
        {
            var HospID=hospComp.getValue();
            $('#configgrid').datagrid('reload',  {
                ClassName:"web.DHCBL.CT.BDPHospitalServiceConfig",
                QueryName:"GetList",
                ParRef:row.ID,
                hospital:HospID     
            }); 
            $('#detailgrid').datagrid('reload',{
                    ClassName:"web.DHCBL.CT.BDPHospSerConfigCategory",
                    QueryName:"GetList" 
            });  
            $('#configgrid').datagrid('unselectAll');    
            $('#detailgrid').datagrid('unselectAll');          
        }    
    });
    
    
    // 多院区配置 
    var configcolumns =[[ 
              {field:'BDPSerConfigType',title:'类型',width:120},
              {field:'BDPSerConfigCurrenHospDR',title:'当前医院',width:120}, 
              {field:'BDPSerConfigOperateHospDR',title:'可操作医院',width:90},
              {field:'BDPSerConfigCategory',title:'项目',width:90},
              {field:'ID',title:'ID',width:60,hidden:true} 
    ]];
              
    var configgrid = $HUI.datagrid("#configgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.BDPHospitalServiceConfig",
            QueryName:"GetList",
            queryParams:{
                 
            }, 
            rows:1000 
        },
        columns: configcolumns,  //列信息
        pagination: false,  
        singleSelect:true,
        idField:'ID', 
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true ,
        onDblClickRow:function(rowIndex,rowData){
            UpdateConfigData();
        },      
        onClickRow:function(index,row){ 
            $('#detailgrid').datagrid('reload',{
                ClassName:"web.DHCBL.CT.BDPHospSerConfigCategory",
                QueryName:"GetList",
                ParRef:row.ID
            });
            $('#detailgrid').datagrid('unselectAll');              
        }, 
        toolbar:[{
            iconCls:'icon-add',
            text:'新增',
            id:'exclude_btn_holiday',
            handler:AddConfigFun 
        },{ 
            iconCls:'icon-write-order',
            text:'修改',
            id:'update_btn_holiday',
            handler:UpdateConfigData 
        },{
            iconCls:'icon-cancel',
            text:'删除',
            id:'del_btn_holiday',
            handler:DelConfigData
        }]
    });
     
    //多院区业务配置  新增方法
    function AddConfigFun(){  
        var record = servincegrid.getSelected(); 
        if (!record){  
            $.messager.alert('错误提示','请先选择一条服务记录!',"error");     
        }
        else{ 
            var ParRef = record.ID;     //调用后台openData方法给表单赋值
			var BDPMHOSPServiceType=record.BDPMHOSPServiceType; 
			if (BDPMHOSPServiceType=="不受限"){
				$.messager.alert('错误提示','多院区服务类型为不受限,不能做多院区业务配置!',"error");  
			}
			else{
				$("#ServinceParRef").val(ParRef);
				$("#BDPHSRowId").val('');
				var HospID=hospComp.getValue();         
				$("#BDPSerConfigCurrenHospDR").combobox("setValue",HospID); 
				$("#myWinConfig").show();  
				$("#BDPSerConfigType").combobox("setValue","");  
				$("#BDPSerConfigOperateHospDR").combobox("setValue",""); 
				$("#BDPSerConfigCategory").combobox("setValue",""); 
				$("#BDPSerConfigCategory").combobox("enable");
				var myWinConfig = $HUI.dialog("#myWinConfig",{
					iconCls:'icon-w-add',
					resizable:true,
					title:'新增',
					modal:true,
					buttonAlign : 'center',
					buttons:[{
						text:'保存', 
						id:'save_btn',
						handler:function(){
							SaveConfigFunLib("");
						}
					},{
						text:'关闭', 
						handler:function(){
							myWinConfig.close();
						}
					}]
				}); 
			}
        }   
    }
     //多院区业务配置    修改方法
    function UpdateConfigData(){   
        var record = configgrid.getSelected(); 
        if (record){   
            var id = record.ID;
			var servicerecord=servincegrid.getSelected();   // 左侧多院区服务的列表
			var BDPMHOSPServiceType=servicerecord.BDPMHOSPServiceType; 
			if (BDPMHOSPServiceType=="不受限"){
				$.messager.alert('错误提示','多院区服务类型为不受限,不能做多院区业务配置!',"error");  
			}
			else{
				$.cm({
					ClassName:"web.DHCBL.CT.BDPHospitalServiceConfig",
					MethodName:"OpenData",
					id:id
				},function(jsonData){
					$('#form-saveconfig').form("load",jsonData);  
				});   
				var flag= tkMakeServerCall("web.DHCBL.CT.BDPHospitalServiceConfig","GetRefFlag",id);
				if (flag==1){
					 $("#BDPSerConfigCategory").combobox("disable");
				} 
				else{
					 $("#BDPSerConfigCategory").combobox("enable");
				}
				$("#myWinConfig").show(); 
				var myWinConfig = $HUI.dialog("#myWinConfig",{
					iconCls:'icon-w-edit',
					resizable:true,
					title:'修改',
					modal:true,
					buttons:[{
						text:'保存', 
						id:'save_btn',
						handler:function(){
							SaveConfigFunLib(id)
						}
					},{
						text:'关闭', 
						handler:function(){
							myWinConfig.close();
						}
					}]
				});
			}			
        }else{
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }   
    } 
    
    
    //多院区业务配置  保存 方法
    function SaveConfigFunLib(id)
    {     
        var ServinceParRef= $("#ServinceParRef").val();
        var BDPSerConfigCurrenHospDR= $("#BDPSerConfigCurrenHospDR").combobox("getValue");  
        var BDPSerConfigOperateHospDR=$("#BDPSerConfigOperateHospDR").combobox("getValue"); 
        var BDPSerConfigType= $("#BDPSerConfigType").combobox("getValue"); 
        var BDPSerConfigCategory=$("#BDPSerConfigCategory").combobox("getValue"); 
        if (BDPSerConfigCurrenHospDR=="") {
            $.messager.alert('错误提示','当前医院不能为空!',"error");
            return;
        }
        if (BDPSerConfigOperateHospDR==""){ 
            $.messager.alert('错误提示','可操作医院不能为空!',"error");
            return;
        }
        if (BDPSerConfigType==""){
            $.messager.alert('错误提示','多院区服务配置类型不能为空!',"error");
            return;
        }
       $.messager.confirm('提示', "确认要保存数据吗?", function(r){
            if (r){ 
                $('#form-saveconfig').form('submit', { 
                    url: CONFIG_SAVE_ACTION_URL,  
                    success: function (data) { 
                      var data=eval('('+data+')'); 
                      if (data.success == 'true') {
                        $.messager.popover({msg: '提交成功！',type:'success',timeout: 1000}); 
                        $('#configgrid').datagrid('reload');  // 重新载入当前页面数据  
                        $('#configgrid').datagrid('unselectAll');
                        $('#myWinConfig').dialog('close'); // close a dialog
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
    
    //多院区业务  删除方法
    function DelConfigData(){ 
        var row = $("#configgrid").datagrid("getSelected"); 
        if (!(row))
        {   $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        } 
        var rowid=row.ID; 
        var flag= tkMakeServerCall("web.DHCBL.CT.BDPHospitalServiceConfig","GetRefFlag",rowid);
        if (flag==1){
            $.messager.confirm('提示', '该业务已有关联数据，是否继续删除?', function(r){
                if (r){   
                    $.ajax({
                        url:CONFIG_DELETE_ACTION_URL,  
                        data:{"id":rowid},  
                        type:"POST",    
                        success: function(data){
                              var data=eval('('+data+')'); 
                              if (data.success == 'true') { 
                                $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000}); 
                                $('#configgrid').datagrid('reload');  // 重新载入当前页面数据  
                                $('#configgrid').datagrid('unselectAll');
                                $("#detailgrid").datagrid('reload');  
                                $('#detailgrid').datagrid('unselectAll');
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
        else{
            $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
                if (r){  
                    $.ajax({
                        url:CONFIG_DELETE_ACTION_URL,  
                        data:{"id":rowid},  
                        type:"POST",    
                        success: function(data){
                              var data=eval('('+data+')'); 
                              if (data.success == 'true') { 
                                $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000}); 
                                $('#configgrid').datagrid('reload');  // 重新载入当前页面数据  
                                $('#configgrid').datagrid('unselectAll');
                                $("#detailgrid").datagrid('reload');  
                                $('#detailgrid').datagrid('unselectAll');
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
    }  
        
         
    
    
    // 配置明细列表
    var configcolumns =[[  
                  {field:'BDPMHOSPCateReference',title:'项目名称',width:180}, 
                  {field:'ID',title:'ID',width:120,hidden:true}  
      ]];
    var detailgrid = $HUI.datagrid("#detailgrid",{
        url:$URL,
        width:500,
        queryParams:{
            ClassName:"web.DHCBL.CT.BDPHospSerConfigCategory",
            QueryName:"GetList",
            rows:100
        },
        columns: configcolumns,  //列信息 
        singleSelect:true,
        idField:'ID', 
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
        onLoadSuccess:function(data)
        {
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },
        onDblClickRow:function(rowIndex,rowData){
            UpdateConfigdetailFun();
        }, 
        toolbar:[{ 
            iconCls:'icon-write-order',
            text:'新增',
            id:'add_btn_configdetail',
            handler: AddConfigdetailFun
            },{ 
            iconCls:'icon-write-order',
            text:'修改',
            id:'update_btn_configdetail',
            handler: UpdateConfigdetailFun
        },{
            iconCls:'icon-cancel',
            text:'删除', 
            id:'del_btn_configdetail',
            handler: DeleteConfigdetailFun
        } ]
    });
    
     
    //多院区业务 明细  新增方法
    function AddConfigdetailFun(){  
		var servicerecord=servincegrid.getSelected();   // 左侧多院区服务的列表
		if (!servicerecord){
			$.messager.alert('错误提示','请先选择一条服务记录!',"error");
		}
		else{
			var BDPMHOSPServiceType=servicerecord.BDPMHOSPServiceType; 
			if (BDPMHOSPServiceType=="不受限"){
					$.messager.alert('错误提示','多院区服务类型为不受限,不能做多院区业务明细配置!',"error");  
			}
			else{
				var record = configgrid.getSelected(); 
				if (!record){  
					$.messager.alert('错误提示','请先选择一条服务记录!',"error");     
				}
				else{   
					var DetailParRef = record.ID;       //调用后台openData方法给表单赋值 
					var Type="";
					Type=record.BDPSerConfigCategory; 
					var HospID=record.BDPSerConfigOperateHospDR;  // 可用医院的 医院描述
					var ComboURL=$URL + "?ClassName=web.DHCBL.CT.BDPHospSerConfigCategory&QueryName=GetComboList&hospid="+HospID+"&ResultSetType=array&Type="+Type
					ComboURL=encodeURI(ComboURL)
					$("#BDPMHOSPCateReference").combobox({
						url: ComboURL ,
						method: 'GET',
						valueField: 'RowId',
						textField: 'ItemDesc' 
					});
					$("#ServinceDetailParRef").val(DetailParRef);  
					$("#BDPMHOSPCateReference").combobox("setValue",""); 
					$("#BDPMHOSPCateID").val('');
					$("#myWinDetail").show();   
					var myWinDetail = $HUI.dialog("#myWinDetail",{
						iconCls:'icon-w-add',
						resizable:true,
						title:'新增',
						modal:true,
						buttonAlign : 'center',
						buttons:[{
							text:'保存', 
							id:'save_btn',
							handler:function(){
								SaveConfigdetailFunLib("");
							}
						},{
							text:'关闭', 
							handler:function(){
								myWinDetail.close();
							}
						}]
					}); 
				}  
			}	
		}		
    }
     //多院区业务 明细    修改方法
    function UpdateConfigdetailFun(){  
		var servicerecord=servincegrid.getSelected();   // 左侧多院区服务的列表
		if (!servicerecord){
			$.messager.alert('错误提示','请先选择一条服务记录!',"error");
		}
		else{
			var BDPMHOSPServiceType=servicerecord.BDPMHOSPServiceType; 
			if (BDPMHOSPServiceType=="不受限"){
					$.messager.alert('错误提示','多院区服务类型为不受限,不能做多院区业务明细配置!',"error");  
			}
			else{	
				var record = detailgrid.getSelected(); 
				if (record){   
					var id = record.ID;
					$.cm({
						ClassName:"web.DHCBL.CT.BDPHospSerConfigCategory",
						MethodName:"OpenData",
						id:id
					},function(jsonData){
						$('#form-savedetail').form("load",jsonData);  
					});    
					$("#myWinDetail").show();
					var Configrecord = configgrid.getSelected(); 
					if (Configrecord){   
						var DetailParRef = Configrecord.ID;     //调用后台openData方法给表单赋值 
						var Type=Configrecord.BDPSerConfigCategory;  
						var HospID=record.BDPSerConfigOperateHospDR;  // 可用医院的 医院描述
						var ComboURL=$URL + '?ClassName=web.DHCBL.CT.BDPHospSerConfigCategory&QueryName=GetComboList&hospid='+HospID+'&ResultSetType=array&Type='+Type;
						ComboURL=encodeURI(ComboURL)
						$("#BDPMHOSPCateReference").combobox({
							url: ComboURL  , 
							method: 'GET',
							valueField: 'RowId',
							textField: 'ItemDesc' 
						});
					}
					var myWinDetail = $HUI.dialog("#myWinDetail",{
						iconCls:'icon-w-edit',
						resizable:true,
						title:'修改',
						modal:true,
						buttons:[{
							text:'保存', 
							id:'save_btn',
							handler:function(){
								SaveConfigdetailFunLib(id)
							}
						},{
							text:'关闭', 
							handler:function(){
								myWinDetail.close();
							}
						}]
					});             
				}else{
					$.messager.alert('错误提示','请先选择一条记录!',"error");
				}  
			}	
		}		
    } 
    
    
    //多院区业务 明细  保存 方法
    function SaveConfigdetailFunLib(id)
    {      
        var ServinceDetailParRef= $("#ServinceDetailParRef").val();  
        var BDPMHOSPCateReference=$("#BDPMHOSPCateReference").combobox("getValue"); 
        if (BDPMHOSPCateReference=="") {
            $.messager.alert('错误提示','项目不能为空!',"error");
            return;
        }  
       $.messager.confirm('提示', "确认要保存数据吗?", function(r){
            if (r){
                $('#form-savedetail').form('submit', { 
                    url: DETAIL_SAVE_ACTION_URL,  
                    success: function (data) { 
                      var data=eval('('+data+')'); 
                      if (data.success == 'true') {
                        $.messager.popover({msg: '提交成功！',type:'success',timeout: 1000}); 
                        $('#detailgrid').datagrid('reload');  // 重新载入当前页面数据  
                        $('#detailgrid').datagrid('unselectAll');
                        $('#myWinDetail').dialog('close'); // close a dialog
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
    
    //多院区业务明细  删除方法
    function DeleteConfigdetailFun(){ 
        var row = $("#detailgrid").datagrid("getSelected"); 
        if (!(row))
        {   $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        } 
        $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
            if (r){ 
                var rowid=row.ID; 
                $.ajax({
                    url:DETAIL_DELETE_ACTION_URL,  
                    data:{"id":rowid},  
                    type:"POST",    
                    success: function(data){
                              var data=eval('('+data+')'); 
                              if (data.success == 'true') { 
                                $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000}); 
                                $('#detailgrid').datagrid('reload');  // 重新载入当前页面数据  
                                $('#detailgrid').datagrid('unselectAll');
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
       
    var wid=($(window).width()-350)/2
    $('#maintain').layout('panel', 'east').panel("resize", { width: wid,right:0,left:$(window).width()-wid-3});  //-3是因为有一点边框距离
    $('#maintain').layout('panel', 'center').panel("resize", { width: wid });
     
};
$(init);