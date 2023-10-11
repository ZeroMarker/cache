/// Function:HOS组织人员岗位基本信息
///	Creator: gaoshanshan
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.HOSEmpPost&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.HOSEmpPost";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HOSEmpPost&pClassMethod=DeleteData";

var init = function(){
    var URL_Icon="../scripts/bdp/Framework/icons/";
    var personid=GetURLParams("personid"); //父id

    ///组织部门 CT.BDP.CT.HOSDepartment
	$("#EMPPOSTDeptCode").combobox({
	   url:$URL+"?ClassName=web.DHCBL.CT.HOSPerson&QueryName=GetDepartmentForCmb1&ResultSetType=array&personid="+personid,
	    valueField: 'ID',
	    textField: 'DEPTDesc' 
	})
	///岗位 CT.BDP.CT.HOSPost
	$("#EMPPOSTPOSTCode").combobox({
	    url:$URL+"?ClassName=web.DHCBL.CT.HOSPost&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'ID',
	    textField: 'POSTDesc'
	})
    var columns =[[  
                  {field:'EMPPOSTPAPersonID',title:'人员',width:120,sortable:true,hidden:true},
                  {field:'EMPPOSTORGDesc',title:'组织部门',width:180,sortable:true},
                  {field:'EMPPOSTPOSTDesc',title:'岗位',width:180,sortable:true},
                  {field:'EMPPOSTBeginDate',title:'上岗日期',width:150,sortable:true},
                  {field:'EMPPOSTRemoveDate',title:'下岗日期',width:150,sortable:true},
                  {field:'EMPPOSTStatus',title:'是否在岗',align:'center',width:120,sortable:true,formatter:ReturnFlagIcon},
                  {field:'EMPPOSTDefaultFlag',title:'是否默认岗位',align:'center',width:120,sortable:true,formatter:ReturnFlagIcon},  
                  {field:'EMPPOSTActivity',title:'是否有效',align:'center',width:120,sortable:true,formatter:ReturnFlagIcon},  
                  {field:'EMPPOSTStartDate',title:'开始日期',width:150,sortable:true},  
                  {field:'EMPPOSTEndDate',title:'结束日期',width:150,sortable:true},  
                  {field:'EMPPOSTSeqNo',title:'排序号',width:120,sortable:true},  
                  {field:'EMPPOSTPYCode',title:'拼音码',width:120,sortable:true},  
                  {field:'EMPPOSTWBCode',title:'五笔码',width:120,sortable:true},  
                  {field:'EMPPOSTMark',title:'备注',width:120,sortable:true},  
                  {field:'ID',title:'ID',hidden:true}
                  ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.HOSEmpPost",
            QueryName:"GetList",
            personid:personid
        }, 
        columns: columns,  //列信息
        ClassTableName:'CT.BDP.CT.HOSEmpPost',
        SQLTableName:'CT_BDP_CT.HOS_EmpPost',
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
    
    //组织部门查询框 CT.BDP.CT.HOSDepartment
	$("#TextDeptCode").combobox({
	    //url:$URL+"?ClassName=web.DHCBL.CT.HOSPerson&QueryName=GetDepartmentForCmb1&ResultSetType=array&personid="+personid,
	    valueField: 'ID',
	    textField: 'DEPTDesc' ,
	    onShowPanel:function(){
	    	$('#TextDeptCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.HOSPerson&QueryName=GetDepartmentForCmb1&ResultSetType=array&personid="+personid)
	    },
	    onSelect:function(){
	    	SearchFunLib();
	    }
	})
    
	//岗位代码查询框 CT.BDP.CT.HOSPost
	$("#TextPOSTCode").combobox({
	    //url:$URL+"?ClassName=web.DHCBL.CT.HOSPost&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'ID',
	    textField: 'POSTDesc',
	    onShowPanel:function(){
	    	$('#TextPOSTCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.HOSPost&QueryName=GetDataForCmb1&ResultSetType=array")
	    },
	    onSelect:function(){
	    	SearchFunLib();
	    }
	})
	
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
    	var deptcode=$("#TextDeptCode").combobox('getValue');
        var postcode=$("#TextPOSTCode").combobox('getValue');
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSEmpPost",
            QueryName:"GetList" ,   
            'personid':personid,
            'deptcode':deptcode,
            'postcode':postcode
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
    //重置方法
    function ClearFunLib()
    {
        $("#TextDeptCode").combobox('setValue',"");
        $("#TextPOSTCode").combobox('setValue',"");
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSEmpPost",
            QueryName:"GetList",
            'personid':personid
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
     //点击新增按钮
    function AddData() { 
        $("#myWin").show(); 
        $("#EMPPOSTDeptCode,#EMPPOSTPOSTCode").combobox('reload')
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
        $('#form-save').form("clear"); 
        $("#EMPPOSTPAPersonID").val(personid)
        $HUI.checkbox("#EMPPOSTActivity").setValue(true);
        $('#EMPPOSTStartDate').datebox('setValue', getCurentDateStr());
        $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");
    }
 

    //点击修改按钮
    function UpdateData() {
        var record = mygrid.getSelected(); 
        if (record){            
             //调用后台openData方法给表单赋值
            var id = record.ID;
            $.cm({
                ClassName:"web.DHCBL.CT.HOSEmpPost",
                MethodName:"OpenData",
                id:id
            },function(jsonData){ 
                $('#form-save').form("load",jsonData);  
				if(jsonData.EMPPOSTActivity=="Y"){
					$HUI.checkbox("#EMPPOSTActivity").setValue(true);
				}else{
					$HUI.checkbox("#EMPPOSTActivity").setValue(false);
				}
				if(jsonData.EMPPOSTStatus=="Y"){
					$HUI.checkbox("#EMPPOSTStatus").setValue(true);
				}else{
					$HUI.checkbox("#EMPPOSTStatus").setValue(false);
				}
				if(jsonData.EMPPOSTDefaultFlag=="Y"){
					$HUI.checkbox("#EMPPOSTDefaultFlag").setValue(true);
				}else{
					$HUI.checkbox("#EMPPOSTDefaultFlag").setValue(false);
				}
            });
                     
            $("#myWin").show(); 
            $("#EMPPOSTDeptCode,#EMPPOSTPOSTCode").combobox('reload')
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
    	var deptcode=$("#EMPPOSTDeptCode").combobox('getValue');
        var code=$("#EMPPOSTPOSTCode").combobox('getValue');
        var datefrom=$("#EMPPOSTStartDate").datebox("getValue");
        var dateto=$("#EMPPOSTEndDate").datebox("getValue");
        var datebegin=$("#EMPPOSTBeginDate").datebox("getValue"); //上岗日期
        var dateremove=$("#EMPPOSTRemoveDate").datebox("getValue"); //下岗日期
        if (deptcode=="")
        {
            $.messager.alert('错误提示','组织部门不能为空!',"error");
            return;
        }
        if (code=="")
        {
            $.messager.alert('错误提示','岗位不能为空!',"error");
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
   		if ((datebegin != "") && (dateremove != "")) {   
        	if (datebegin >dateremove) {
        		$.messager.alert('错误提示','上岗日期不能大于下岗日期!',"error"); 
          		return;
      		}
   		}
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				$('#form-save').form('submit', { 
					url: SAVE_ACTION_URL, 
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