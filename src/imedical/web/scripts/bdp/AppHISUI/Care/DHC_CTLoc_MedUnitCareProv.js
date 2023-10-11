/// Function:医疗单元关联医护人员
/// Creator: gaoshanshan
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnitCareProv&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCCTLocMedUnitCareProv";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnitCareProv&pClassMethod=DeleteData";

var init = function(){
	var parref=GetURLParams("parref"); //父id
    var URL_Icon="../scripts/bdp/Framework/icons/";
	//医生
    $("#MUCPDoctorDR").combogrid({
		width:200,
		panelWidth:500,
		url: $URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.DHCCTLocMedUnitCareProv",
            QueryName:"CTPCPDR",
            'MURowid':parref
        }, 
		mode:'remote',
		method:"Get",
		fitColumns:true,
		idField:'RESCTPCPDR',
		textField:'CTPCPDesc',
		columns:[[  
			{field:'CTPCPDesc',title:'姓名',width:100}, 
			{field:'TCTPCPCode',title:'工号',width:100},  
			{field:'CTMUDesc',title:'所属医疗单元',width:100},  
			{field:'CTLOCDesc',title:'所属科室',width:100},  
			{field:'RESCTPCPDR',title:'RESCTPCPDR',width:100,hidden:true},  
			{field:'MUCPRowid',title:'MUCPRowid',width:100,hidden:true} 
			
		]],
		pagination:true,
		onBeforeLoad:function(param){
	        var desc=param['q'];
	        param = $.extend(param,{desc:desc});
	    },
		onSelect:function(index,rowData){
			$("#CTPCPCode").text(rowData.TCTPCPCode)
		}
	});
	//开始时间
	$("#MUCPTimeFrom").timespinner({
		showSeconds:true,
		hourStep:1,
		minutesStep:30
	});
	//结束时间
	$("#MUCPTimeTo").timespinner({
		showSeconds:true,
		hourStep:1,
		minutesStep:30
	});
    var columns =[[  
                    {field:'MUCPRowId',title:'MUCPRowId',hidden:true},
                    {field:'MUCPParRef',title:'MUCPParRef',hidden:true},
                    {field:'CTMUChildsub',title:'CTMUChildsub',hidden:true},
                    {field:'MUCPDoctorDR',title:'MUCPDoctorDR',hidden:true},
                    {field:'CTPCPDesc',title:'医生姓名',width:120,sortable:true},
                    {field:'CTPCPCode',title:'医生工号',width:100,sortable:true},
                    {field:'MUCPLeaderFlag',title:'组长标志',width:100,sortable:true,sortable:true,formatter:ReturnFlagIcon},
                    {field:'MUCPOPFlag',title:'门诊出诊标志',width:120,sortable:true,sortable:true,formatter:ReturnFlagIcon}, 
                    {field:'MUCPIPFlag',title:'住院出诊标志',width:120,sortable:true,sortable:true,formatter:ReturnFlagIcon}, 
                    {field:'MUCPDateFrom',title:'开始日期',width:100,sortable:true}, 
                    {field:'MUCPTimeFrom',title:'开始时间',width:100,sortable:true},
                    {field:'MUCPDateTo',title:'结束日期',width:100,sortable:true}, 
                    {field:'MUCPTimeTo',title:'结束时间',width:100,sortable:true}
                                   
                ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
         queryParams:{
            ClassName:"web.DHCBL.CT.DHCCTLocMedUnitCareProv",
            QueryName:"MedUnitPerson",
            'ParRef':parref
        }, 
        columns: columns,  //列信息
        ClassTableName:'User.DHCCTLocMedUnitCareProv',
        SQLTableName:'DHC_CTLoc_MedUnitCareProv',
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300], 
        singleSelect:true,
        idField:'MUCPRowId', 
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
    
     //查询方法
    function SearchFunLib(){
        var code=$.trim($("#TextCode").val());
        var desc=$.trim($('#TextDesc').val());
        var leaderdata=$HUI.checkbox("#checkhistory").getValue();
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.DHCCTLocMedUnitCareProv",
            QueryName:"MedUnitPerson" ,   
            'code':code,    
            'desc': desc,
            'checkhistory':leaderdata,
            'ParRef':parref
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
    //重置方法
    function ClearFunLib()
    {
        $("#TextCode").val("");
        $("#TextDesc").val("");
        $HUI.checkbox("#checkhistory").setValue(false);
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.DHCCTLocMedUnitCareProv",
            QueryName:"MedUnitPerson",
            'ParRef':parref
        });
        $('#mygrid').datagrid('unselectAll');
    }

     //点击新增按钮
    function AddData() { 
        $("#myWin").show(); 
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
        $("#MUCPParRef").val(parref)
        $("#CTPCPCode").text("")
        $('#MUCPDateFrom').datebox('setValue', getCurentDateStr());
        $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");
    }
    

    //点击修改按钮
    function UpdateData() {
        var record = mygrid.getSelected(); 
        if (record){            
             //调用后台openData方法给表单赋值
            var id = record.MUCPRowId;
            $.cm({
                ClassName:"web.DHCBL.CT.DHCCTLocMedUnitCareProv",
                MethodName:"OpenData2",
                id:id
            },function(jsonData){ 
                $('#form-save').form("load",jsonData);
                $("#MUCPDoctorDR").combogrid('setText',jsonData.CTPCPDesc)
                $("#CTPCPCode").text(jsonData.CTPCPCode)
                if(jsonData.MUCPLeaderFlag=="Y"){
					$HUI.checkbox("#MUCPLeaderFlag").setValue(true);
				}else{
					$HUI.checkbox("#MUCPLeaderFlag").setValue(false);
				}
				if(jsonData.MUCPOPFlag=="Y"){
					$HUI.checkbox("#MUCPOPFlag").setValue(true);
				}else{
					$HUI.checkbox("#MUCPOPFlag").setValue(false);
				}
				if(jsonData.MUCPIPFlag=="Y"){
					$HUI.checkbox("#MUCPIPFlag").setValue(true);
				}else{
					$HUI.checkbox("#MUCPIPFlag").setValue(false);
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
        var doctor=$("#MUCPDoctorDR").combogrid('getValue')
        var datefrom=$("#MUCPDateFrom").datebox("getValue");
        var dateto=$("#MUCPDateTo").datebox("getValue");
        var popflag= $HUI.checkbox("#MUCPOPFlag").getValue() 
        var pipflag =$HUI.checkbox("#MUCPIPFlag").getValue()
        var leaderdata=$HUI.checkbox("#MUCPLeaderFlag").getValue() 
        if (doctor=="")
        {
            $.messager.alert('错误提示','医生姓名不能为空!',"error");
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
        var tipInfo="确认要保存数据吗?"
        if (id==""){
        	if ((popflag=="")&(pipflag=="")){
        		tipInfo="医生出诊标志为空,确定要添加数据吗?"
        	}
        }
        $.messager.confirm('提示', tipInfo, function(r){
            if (r){
            	if (leaderdata=="1"){
		            var flag = "";
		            var flag = tkMakeServerCall("web.DHCBL.CT.DHCCTLocMedUnitCareProv","RequiredMUCPLeader",parref,id);
		            if(flag == "1"){   
		                 $.messager.alert('提示',"此单元组已经有组领导,不能再分配组领导!","error");
		                 return;
		             } 
		         }
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
                var rowid=row.MUCPRowId; 
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
    
};
$(init);