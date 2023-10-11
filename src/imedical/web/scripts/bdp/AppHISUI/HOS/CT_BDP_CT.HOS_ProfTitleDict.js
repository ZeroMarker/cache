/// Function:职务字典代码
///	Creator: lujunwen
//Date：2023-2-7
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.HOSProfTitleDict&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.HOSProfTitleDict";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HOSProfTitleDict&pClassMethod=DeleteData";

var init = function(){
    var columns =[[  
                  {field:'PROFTCCode',title:'代码',width:180,sortable:true},
                  {field:'PROFTCDesc',title:'名称',width:180,sortable:true},
                  {field:'PROFTCType',title:'职务分类',width:180,sortable:true},
                  {field:'PROFTCPROFRCode',title:'职务等级',width:180,sortable:true},
                  {field:'PROFTCRankRange',title:'职级范围',width:180,sortable:true},
                  {field:'PROFTCActivity',title:'是否有效',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon},  
                  {field:'PROFTCStartDate',title:'开始日期',width:180,sortable:true},
                  {field:'PROFTCEndDate',title:'结束日期',width:180,sortable:true},
                  {field:'PROFTCSeqNo',title:'排序号',width:180,sortable:true},
                  {field:'PROFTCPYCode',title:'拼音码',width:180,sortable:true},
                  {field:'PROFTCWBCode',title:'五笔码',width:180,sortable:true},
                  {field:'PROFTCMark',title:'备注',width:180,sortable:true},
                  {field:'ID',title:'ID',hidden:true}
                  ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
         queryParams:{
            ClassName:"web.DHCBL.CT.HOSProfTitleDict",
            QueryName:"GetList"
        }, 
        columns: columns,  //列信息
        ClassTableName:'CT.BDP.CT.HOSProfTitleDict',
        SQLTableName:'CT_BDP_CT.HOS_ProfTitleDict',
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
	$('#TextDesc,#TextCode').keyup(function(event){
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
	
	//职务分类下拉框
    $('#PROFTCType').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTOccupation&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTOCCRowId',
		textField:'CTOCCDesc'
	});
	
	//职务等级下拉框
    $('#PROFTCPROFRCode').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.HOSProfRank&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'ID',
		textField:'PROFRDesc'
	});	
	
	//职务分类查询下拉框
    $('#PROFTCTypeSearch').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTOccupation&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTOCCRowId',
		textField:'CTOCCDesc',
		onSelect:function(record){
        SearchFunLib();
        },
         onShowPanel:function(){
            $(this).combobox("reload")
        }       
	});	
	
	
     //查询方法
    function SearchFunLib(){
        var code=$.trim($("#TextCode").val());
        var desc=$.trim($('#TextDesc').val());
        var proftctypesearch=$("#PROFTCTypeSearch").combobox('getValue') 
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSProfTitleDict",
            QueryName:"GetList" ,   
            'code':code,    
            'desc': desc,
            'proftctypesearch':proftctypesearch
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
    //重置方法
    function ClearFunLib()
    {
        $("#TextCode").val("");
        $("#TextDesc").val("");
        $("#PROFTCTypeSearch").combobox('setValue','');  ///职务分类
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSProfTitleDict",
            QueryName:"GetList"
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
     //失焦事件
     $('#PROFTCDesc').bind('blur',function(){
          var PROFTCDesc=$("#PROFTCDesc").val()  
          var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",PROFTCDesc) 
          var WBCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetSWBCODE",PROFTCDesc,1) 
          $("#PROFTCPYCode").val(PYCode)
          $("#PROFTCWBCode").val(WBCode)                                           
      });
    
     //点击新增按钮
    function AddData() { 
        $("#myWin").show();
        var url=$URL+"?ClassName=web.DHCBL.CT.CTOccupation&QueryName=GetDataForCmb1&ResultSetType=array";
		$('#PROFTCType').combobox('reload',url);        
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
		$('#PROFTCStartDate').datebox('setValue', getCurentDateStr());
        $HUI.checkbox("#PROFTCActivity").setValue(true); 
        $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");                   
    }
 

    //点击修改按钮
    function UpdateData() {
        var record = mygrid.getSelected(); 
        var url=$URL+"?ClassName=web.DHCBL.CT.CTOccupation&QueryName=GetDataForCmb1&ResultSetType=array";
		$('#PROFTCType').combobox('reload',url);     
        if (record){            
             //调用后台openData方法给表单赋值
            var id = record.ID;
            $.cm({
                ClassName:"web.DHCBL.CT.HOSProfTitleDict",
                MethodName:"OpenData",
                id:id
            },function(jsonData){ 
                $('#form-save').form("load",jsonData);
                if (jsonData.PROFTCActivity=="Y")
				{	
					$HUI.checkbox("#PROFTCActivity").setValue(true);	
				}else{
					$HUI.checkbox("#PROFTCActivity").setValue(false);
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
        var code=$.trim($("#PROFTCCode").val());
        var desc=$.trim($("#PROFTCDesc").val());
        var datefrom=$("#PROFTCStartDate").datebox("getValue");
        var dateto=$("#PROFTCEndDate").datebox("getValue");
        if (code=="")
        {
            $.messager.alert('错误提示','代码不能为空!',"error");
            return;
        }
        if (desc=="")
        {
            $.messager.alert('错误提示','名称不能为空!',"error");
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