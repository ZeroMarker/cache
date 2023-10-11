/// Function:流程岗位与业务岗位关系
///	Creator: lujunwen
//Date：2022-2-8
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.HOSPostRelBusPost&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.HOSProcPostRelPost";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HOSPostRelBusPost&pClassMethod=DeleteData";

var init = function(){
    var columns =[[  
                  {field:'PPRPProcPostCode',title:'流程岗位',width:180,sortable:true},
                  {field:'PPRPPostCode',title:'业务岗位',width:180,sortable:true},
                  {field:'PPRPActivity',title:'是否有效',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon},  
                  {field:'PPRPStartDate',title:'开始日期',width:180,sortable:true},
                  {field:'PPRPEndDate',title:'结束日期',width:180,sortable:true},
                  {field:'PPRPSeqNo',title:'排序号',width:180,sortable:true},
                  {field:'PPRPPYCode',title:'拼音码',width:180,sortable:true},
                  {field:'PPRPWBCode',title:'五笔码',width:180,sortable:true},
                  {field:'PPRPMark',title:'备注',width:180,sortable:true},
                  {field:'ID',title:'ID',hidden:true}
                  ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
         queryParams:{
            ClassName:"web.DHCBL.CT.HOSPostRelBusPost",
            QueryName:"GetList"
        }, 
        columns: columns,  //列信息
        ClassTableName:'CT.BDP.CT.HOSProcPostRelPost',
        SQLTableName:'CT_BDP_CT.HOS_ProcPostRelPost',
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300], 
        singleSelect:true,
        idField:'ID', 
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
		onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
		}
    });
    
   //搜索回车事件
	$('#ProcpostCode,#PostCode').keyup(function(event){
		if(event.keyCode == 13) {
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
	
	//流程岗位下拉框
    $('#PPRPProcPostCode').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.HOSProcPost&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'ID',
		textField:'PPOSTDesc'
	});
	
	//流程岗位查询下拉框
    $('#ProcpostCode').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.HOSProcPost&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'ID',
		textField:'PPOSTDesc',
		onSelect:function(record){
        SearchFunLib();
        },
         onShowPanel:function(){
            $(this).combobox("reload")
        }       
	});
	
	//业务岗位下拉框
    $('#PPRPPostCode').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.HOSPost&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'ID',
		textField:'POSTDesc'
	});
	
	//业务岗位查询下拉框
    $('#PostCode').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.HOSPost&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'ID',
		textField:'POSTDesc',
		onSelect:function(record){
        SearchFunLib();
        },
         onShowPanel:function(){
            $(this).combobox("reload")
        }       
	});		
	
	
     //查询方法
    function SearchFunLib(){
        var procpostcode=$("#ProcpostCode").combobox('getValue') 
        var postcode=$("#PostCode").combobox('getValue')
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSPostRelBusPost",
            QueryName:"GetList" ,   
  			'procpostcode':procpostcode,
            'postcode':postcode
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
    //重置方法
    function ClearFunLib()
    {
        $("#ProcpostCode").combobox('setValue','');  ///流程岗位
        $("#PostCode").combobox('setValue','');  ///业务岗位
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSPostRelBusPost",
            QueryName:"GetList"
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
     //失焦事件
     $('#PPRPProcPostCode').bind('blur',function(){
          var PPRPProcPostCode=$("#PPRPProcPostCode").val()  
          var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",PPRPProcPostCode) 
          var WBCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetSWBCODE",PPRPProcPostCode,1) 
          $("#PPRPPYCode").val(PYCode)
          $("#PPRPWBCode").val(WBCode)                                           
      });
    
     //点击新增按钮
    function AddData() { 
        $("#myWin").show();
        var url=$URL+"?ClassName=web.DHCBL.CT.HOSProcPost&QueryName=GetDataForCmb1&ResultSetType=array";
		$('#PPRPProcPostCode').combobox('reload',url);
        var url=$URL+"?ClassName=web.DHCBL.CT.HOSPost&QueryName=GetDataForCmb1&ResultSetType=array";
		$('#PPRPPostCode').combobox('reload',url);		
		        
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
                    SaveFunLib("");
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
		$('#PPRPStartDate').datebox('setValue', getCurentDateStr());
        $HUI.checkbox("#PPRPActivity").setValue(true); 
        $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");                   
    }
 

    //点击修改按钮
    function UpdateData() {
        var record = mygrid.getSelected(); 
        var url=$URL+"?ClassName=web.DHCBL.CT.HOSProcPost&QueryName=GetDataForCmb1&ResultSetType=array";
		$('#PPRPProcPostCode').combobox('reload',url);
        var url=$URL+"?ClassName=web.DHCBL.CT.HOSPost&QueryName=GetDataForCmb1&ResultSetType=array";
		$('#PPRPPostCode').combobox('reload',url);    
        if (record){            
             //调用后台openData方法给表单赋值
            var id = record.ID;
            $.cm({
                ClassName:"web.DHCBL.CT.HOSPostRelBusPost",
                MethodName:"OpenData",
                id:id
            },function(jsonData){ 
                $('#form-save').form("load",jsonData);
                if (jsonData.PPRPActivity=="Y")
				{	
					$HUI.checkbox("#PPRPActivity").setValue(true);	
				}else{
					$HUI.checkbox("#PPRPActivity").setValue(false);
				}                

            });
                     
            $("#myWin").show(); 
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
                    	SaveFunLib(id);
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
        }else{
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }
    }
	
    ///新增、更新
    function SaveFunLib(id)
    {   
        
		var pprpprocpostcode=$("#PPRPProcPostCode").combobox('getValue');
		var pprppostcode=$("#PPRPPostCode").combobox('getValue');		        
        var datefrom=$("#PPRPStartDate").datebox("getValue");
        var dateto=$("#PPRPEndDate").datebox("getValue");
		if (datefrom=="")
        {
            $.messager.alert('错误提示','开始日期不能为空!',"error");
            return;
        }
 		if (pprpprocpostcode=="")
        {
            $.messager.alert('错误提示','流程岗位不能为空!',"error");
            return;
        }
 		if (pprppostcode=="")
        {
            $.messager.alert('错误提示','业务岗位不能为空!',"error");
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
						param.ID = id;
					},
					success: function (data) { 
						var data=eval('('+data+')'); 
						if (data.success == 'true') { 
							$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000}); 
							$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
							$('#mygrid').datagrid('unselectAll');
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

    ///删除
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
    HISUI_Funlib_Translation('mygrid');
    HISUI_Funlib_Sort('mygrid');
};
$(init);