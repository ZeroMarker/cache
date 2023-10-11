/// Function:医疗单元
/// Creator: gaoshanshan
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnit&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCCTLocMedUnit";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnit&pClassMethod=DeleteData";

var init = function(){
    var URL_Icon="../scripts/bdp/Framework/icons/";
	
    ///科室 
	$("#CTLocDr").combobox({
	   url:$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'CTLOCRowID',
	    textField: 'CTLOCDesc',
	    panelWidth:350
	})
    var columns =[[  
                    {field:'MURowId',title:'MURowId',hidden:true},
                    {field:'CTLOCCode',title:'科室代码',width:180,sortable:true},
                    {field:'CTLOCDesc',title:'科室描述',width:180,sortable:true},
                    {field:'CTMUCode',title:'代码',width:180,sortable:true},
                    {field:'CTMUDesc',title:'描述',width:180,sortable:true}, 
                    {field:'CTMUActiveFlag',title:'是否激活',align:'center',width:120,sortable:true,formatter:ReturnFlagIcon},                    
                    {field:'CTMUDateFrom',title:'开始日期',width:160,sortable:true}, 
                    {field:'CTMUDateTo',title:'结束日期',width:160,sortable:true}
                                   
                ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
         queryParams:{
            ClassName:"web.DHCBL.CT.DHCCTLocMedUnit",
            QueryName:"QueryMedUnit1",
            'hospid':session['LOGON.HOSPID']
        }, 
        columns: columns,  //列信息
        ClassTableName:'User.DHCCTLocMedUnit',
        SQLTableName:'DHC_CTLoc_MedUnit',
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300], 
        singleSelect:true,
        idField:'MURowId', 
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
        onDblClickRow:function(rowIndex,rowData){
            UpdateData();
        }
    }); 
    ///医院检索
    var objectName="DHC_CTLoc_MedUnit"
	$("#HospList").combobox({
	   url:$URL+"?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename="+objectName,
	    valueField: 'HOSPRowId',
	    textField: 'HOSPDesc',
	    panelWidth:350,
	    editable:false,
	    onSelect:function(record){
	    	$('#TextCTLocDr').combobox('reload', $URL +"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array&hospid="+record.HOSPRowId);
	    	$('#TextCTLocDr').combobox('setValue',"");
	    	SearchFunLib();
	    }
	})
	var thisHospId=tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDefHospIdByTableName",objectName,session['LOGON.HOSPID'])
	$("#HospList").combobox('setValue',thisHospId) //初始赋值为当前登录科室的院区
	
	//公有数据不显示医院下拉框。 
	var DataType=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetDataType",objectName);  //公有G，私有S，绝对私有A，管控C
	var HospComboHiddenFlag=(tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut")=="Y")&&(DataType!="G")
	if (HospComboHiddenFlag){
		$("#Hosptd1,#Hosptd2").css("display","");//显示医院
	}else{
		$("#Hosptd1,#Hosptd2").css("display","none");//隐藏医院
	}
    
    ///科室检索 
	$("#TextCTLocDr").combobox({
	   url:$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array&hospid="+thisHospId,
	    valueField: 'CTLOCRowID',
	    textField: 'CTLOCDesc',
	    panelWidth:350,
	    onSelect:function(){
	    	SearchFunLib();
	    }
	})

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
    	var hosp=$("#HospList").combobox('getValue');
    	var loc=$("#TextCTLocDr").combobox('getValue');
        var code=$.trim($("#TextCode").val());
        var desc=$.trim($('#TextDesc').val());
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.DHCCTLocMedUnit",
            QueryName:"QueryMedUnit1" ,   
            'code':code,    
            'desc': desc,
            'CTLocDr':loc,
			'hospid':hosp
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
    //重置方法
    function ClearFunLib()
    {
    	var hosp=$("#HospList").combobox('getValue');
    	$("#TextCTLocDr").combobox('setValue',"");
        $("#TextCode").val("");
        $("#TextDesc").val("");
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.DHCCTLocMedUnit",
            QueryName:"QueryMedUnit1",
            'hospid':hosp
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
        $('#CTLocDr').combobox('reload', $URL +"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array&hospid="+$("#HospList").combobox('getValue'));
        $HUI.checkbox("#CTMUActiveFlag").setValue(true);
        $('#CTMUDateFrom').datebox('setValue', getCurentDateStr());
        $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");
    }
    

    //点击修改按钮
    function UpdateData() {
        var record = mygrid.getSelected(); 
        if (record){            
             //调用后台openData方法给表单赋值
            var id = record.MURowId;
            $.cm({
                ClassName:"web.DHCBL.CT.DHCCTLocMedUnit",
                MethodName:"OpenData2",
                id:id
            },function(jsonData){ 
            	$('#CTLocDr').combobox('reload', $URL +"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array&hospid="+$("#HospList").combobox('getValue'));
                $('#form-save').form("load",jsonData);  
                if(jsonData.CTMUActiveFlag=="Y"){
					$HUI.checkbox("#CTMUActiveFlag").setValue(true);
				}else{
					$HUI.checkbox("#CTMUActiveFlag").setValue(false);
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
    	var loc=$("#CTLocDr").combobox('getValue');
        var code=$.trim($("#CTMUCode").val());
        var desc=$.trim($("#CTMUDesc").val());
        var datefrom=$("#CTMUDateFrom").datebox("getValue");
        var dateto=$("#CTMUDateTo").datebox("getValue");
        var activeflag=$HUI.checkbox("#CTMUActiveFlag").getValue();
        if (loc=="")
        {
            $.messager.alert('错误提示','科室不能为空!',"error");
            return;
        }
        if (code=="")
        {
            $.messager.alert('错误提示','代码不能为空!',"error");
            return;
        }
        if (desc=="")
        {
            $.messager.alert('错误提示','描述不能为空!',"error");
            return;
        }
        if (datefrom=="")
        {
            $.messager.alert('错误提示','开始日期不能为空!',"error");
            return;
        }
        if ((datefrom != "") &&(dateto != "")) {   
            if (datefrom >dateto) {
                $.messager.alert('错误提示','开始日期不能大于结束日期!',"error"); 
                return;
            }
        }
        $.messager.confirm('提示', "确认要保存数据吗?", function(r){
            if (r){
                $('#form-save').form('submit', { 
                    url: SAVE_ACTION_URL,  
                    onSubmit:function(param){
                    	param.rowid=id,
						param.activeflag=activeflag
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
                var rowid=row.MURowId; 
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
    
    //点击关联医护人员按钮
    var windowHight = document.documentElement.clientHeight;        //可获取到高度
    var windowWidth = document.documentElement.clientWidth;
	$("#btnCareProv").click(function (e) { 
		var row = $("#mygrid").datagrid("getSelected"); 
        if (!(row))
        {   $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        } 
		$("#myWinCareProv").show();  
		var url="dhc.bdp.ct.dhcctlocmedunitcareprov.csp?parref="+row.MURowId
		if ("undefined"!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken()
		}
		var myWinCareProv = $HUI.dialog("#myWinCareProv",{
			resizable:true,
			title:'关联医护人员->'+row.CTMUDesc,
			width: windowWidth-50,    
            height: windowHight-50,
			modal:true,
			draggable :true,
			content:"<iframe scrolling='auto' frameborder='0' width='100%' height='100%' src='"+url+"'></iframe>"
		})
	});	
    
};
$(init);