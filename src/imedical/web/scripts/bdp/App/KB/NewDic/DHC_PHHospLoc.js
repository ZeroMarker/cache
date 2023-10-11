/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-07-31 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-10-24 09:35:22
* @描述:科室字典
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHHospLoc&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHHospLoc";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHHospLoc&pClassMethod=DeleteData";
var SAVE_ACTION_URL_ICD = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHHospLocIcd&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHHospLocIcd";
var DELETE_CON_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHHospLocIcd&pClassMethod=DeleteData";
var init=function()
{
   var loccolumns =[[
        {field:'HOSPLCode',title:'代码',sortable:true,width:100},
        {field:'HOSPLDesc',title:'描述',sortable:true,width:100},
        {field:'HOSPLActiveFlag',title:'是否可用',sortable:true,width:100,
              formatter:ReturnFlagIcon
    	},
        {field:'HOSPLRowId',title:'rowid',sortable:true,width:100,hidden:true}
    ]];
    var locgrid = $HUI.datagrid("#locgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHHospLoc",
            QueryName:"GetList"
        },
        columns: loccolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.DHCPHExtPart',
		//SQLTableName:'DHC_PHExtPart',
        idField:'HOSPLRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data)
        {
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },
        onClickRow:function(index,row)
        {
	        $('#linkgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.KB.DHCPHHospLocIcd",
            	QueryName:"GetList",
            	parref:row.HOSPLRowId
    		});        	
        },
        onDblClickRow:function(index,row)
        {
            updateData();
        }		
    });
    //搜索
    $('#locSearch').click(function(e){
        SearchFunLib();
    });
    //搜索回车事件
    $('#TextLoc').keyup(function(event){
        if(event.keyCode == 13) {
          SearchFunLib();
        }
    });    
    //搜索方法
    SearchFunLib=function()
    {
         var desc=$('#TextLoc').val();
        $('#locgrid').datagrid('reload',  {
                ClassName:"web.DHCBL.KB.DHCPHHospLoc",
                QueryName:"GetList",
                desc:desc
        });
        $('#linkgrid').datagrid('reload',  {
            ClassName:"web.DHCBL.KB.DHCPHHospLocIcd",
            QueryName:"GetList"
        }); 
        $('#locgrid').datagrid('unselectAll');
        $('#linkgrid').datagrid('unselectAll');       
    }    
    //重置
    $('#locRefresh').click(function(e){
        $('#TextLoc').val("");
        $('#locgrid').datagrid('reload',  {
                ClassName:"web.DHCBL.KB.DHCPHHospLoc",
                QueryName:"GetList"
        });
        $('#linkgrid').datagrid('reload',  {
            ClassName:"web.DHCBL.KB.DHCPHHospLocIcd",
            QueryName:"GetList"
        });
        $('#locgrid').datagrid('unselectAll');
        $('#linkgrid').datagrid('unselectAll');
    });
    //点击添加按钮
    $('#add_btn').click(function(e){
        AddData();
    });
    //点击修改按钮
    $('#update_btn').click(function(){
        updateData();
    });
    //点击删除按钮
    $('#del_btn').click(function(e){
        delData();
    }); 
    //关联下拉框
    $('#dialinkDesc').combobox({
        valueField:'id',
        textField:'text',
        data:[
            {id:'Y',text:'是'},
            {id:'N',text:'否'}    
        ]
    });       
    //点击添加按钮方法
    AddData=function(){ 
       // $('#HOSPLCode').attr("disabled",false);
        //$('#HOSPLDesc').attr("disabled",false); 
        $('#HOSPLCode').attr("readonly",false);
        $('#HOSPLCode')[0].readonly=false;
        $('#HOSPLCode').css({'background-color':'#ffffff'});

        $('#HOSPLDesc').attr("readonly",false);
        $('#HOSPLDesc')[0].readonly=false;
        $('#HOSPLDesc').css({'background-color':'#ffffff'});                
        $("#myWin").show();
        var myWin = $HUI.dialog("#myWin",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'增加',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'保存',
                id:'save_btn',
                handler:function(){
                    SaveFunLib("",1)
                }
            },{
                text:'继续新增',
                id:'save_goon',
                handler:function(){
                    //goOnSaveData();
                    SaveFunLib("",2)
                }
            },{
                text:'关闭',
                handler:function(){
                    myWin.close();
                }
            }]
        });
        $('#form-save').form("clear");
        //默认选中
        $HUI.checkbox("#HOSPLActiveFlag").setValue(true); 
    }
    SaveFunLib=function(id,flagT)
    {
        //alert(flag)
        var code=$.trim($("#HOSPLCode").val());
        var desc=$.trim($("#HOSPLDesc").val());   
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
        var flag="N";
        if ($('#HOSPLActiveFlag').attr('checked')) 
        {
            var flag="Y" ;
        }   
        $('#form-save').form('submit', {
            url:SAVE_ACTION_URL,
            onSubmit: function(param){
                param.HOSPLRowId = id;
            },
        success: function (data) { 
            var data=eval('('+data+')'); 
            if (data.success == 'true') {
                /*$.messager.show({ 
                title: '提示消息', 
                msg: '提交成功', 
                showType: 'show', 
                timeout: 1000, 
                style: { 
                right: '', 
                bottom: ''
                } 
            });*/
            $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
            $('#locgrid').datagrid('reload');  // 重新载入当前页面数据 
            //alert(flagT)
            if(flagT==1)
            {
                //alert(flagT)
                $('#myWin').dialog('close'); // close a dialog
            }
            else
            {
                $('#form-save').form("clear");
                //默认选中
                $HUI.checkbox("#HOSPLActiveFlag").setValue(true);               
            }
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
    updateData=function()
    {
        var record = locgrid.getSelected(); 
        if(record)
        {
            var id=record.HOSPLRowId;
            $.cm({
                ClassName:"web.DHCBL.KB.DHCPHHospLoc",
                MethodName:"NewOpenData",
                id:id
            },function(jsonData){
                //给是否可用单独赋值 
                //alert(jsonData.PHLFSysFlag)       
                //alert(jsonData.PHLFActiveFlag)        
                if (jsonData.HOSPLActiveFlag=="Y"){
                    $HUI.checkbox("#HOSPLActiveFlag").setValue(true);     
                }else{
                    $HUI.checkbox("#HOSPLActiveFlag").setValue(false);
                }              
                $('#form-save').form("load",jsonData);  
            });
            //如果已对照则不能修改
            var contrastFlag=tkMakeServerCall("web.DHCBL.KB.DHCPHHospLoc","GetRefFlag",id);
            //alert(contrastFlag)
            if(contrastFlag.indexOf("科室字典对照表")>0)
            {
                //$('#HOSPLCode').attr("disabled",true);//代码不可修改
               // $('#HOSPLDesc').attr("disabled",true);//代码不可修改
                $('#HOSPLCode').attr("readonly",true);
                $('#HOSPLCode')[0].readonly=true;
                $('#HOSPLCode').css({'background-color':'#EBEBE4'});

                $('#HOSPLDesc').attr("readonly",true);
                $('#HOSPLDesc')[0].readonly=true;
                $('#HOSPLDesc').css({'background-color':'#EBEBE4'});
            }
            else
            {
                //$('#HOSPLCode').attr("disabled",false);
                //$('#HOSPLDesc').attr("disabled",false);
                $('#HOSPLCode').attr("readonly",false);
                $('#HOSPLCode')[0].readonly=false;
                $('#HOSPLCode').css({'background-color':'#ffffff'});

                $('#HOSPLDesc').attr("readonly",false);
                $('#HOSPLDesc')[0].readonly=false;
                $('#HOSPLDesc').css({'background-color':'#ffffff'});
            }                
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
                        SaveFunLib(id,1)
                    }
                },{
                    text:'关闭',
                    handler:function(){
                        myWin.close();
                    }
                }]
            });                         
        }else{
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }
    }
    delData=function()
    {
        var row = $("#locgrid").datagrid("getSelected"); 
        if (!(row))
        {   $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        }
        var rowid=row.HOSPLRowId;
        $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
            if (r){
                $.ajax({
                    url:DELETE_ACTION_URL,  
                    data:{"id":rowid},  
                    type:"POST",   
                    //dataType:"TEXT",  
                    success: function(data){
                              var data=eval('('+data+')'); 
                              if (data.success == 'true') {
                                /*$.messager.show({ 
                                  title: '提示消息', 
                                  msg: '删除成功', 
                                  showType: 'show', 
                                  timeout: 1000, 
                                  style: { 
                                    right: '', 
                                    bottom: ''
                                  } 
                                }); */
                                $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
                                 $('#locgrid').datagrid('reload');  // 重新载入当前页面数据 
                                 $('#locgrid').datagrid('unselectAll');  // 清空列表选中数据 
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
    //诊断
    var diacolumns =[[
        {field:'ICDRowId',title:'RowId',width:150,sortable:true,hidden:true},
        {field:'ICDCode',title:'代码',width:300,sortable:true},
        {field:'ICDDesc',title:'描述',width:300,sortable:true},
        {field:'ConFlag',title:'已关联',width:300,sortable:true,
                formatter:ReturnFlagIcon
        }
    ]];
    var diagrid = $HUI.datagrid("#diagrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHHospLocIcd",
            QueryName:"GetDataForLoc"
        },
        columns: diacolumns,  //列信息
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        //ClassTableName:'User.MKBTermGJ',
        //SQLTableName:'MKB_Term',
        idField:'ICDRowId',
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data){
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        }
    });
    //搜索
    $('#diaSearch').click(function(e){
        SearchDia();
    });
    //搜索回车事件
    $('#Textdia').keyup(function(event){
        if(event.keyCode == 13) {
          SearchDia();
        }
    });    
    //搜索方法
    SearchDia=function()
    {
        var Textdia=$('#Textdia').val();
        var linkdesc=$('#dialinkDesc').combobox('getValue');
        $('#diagrid').datagrid('reload',  {
                ClassName:"web.DHCBL.KB.DHCPHHospLocIcd",
                QueryName:"GetDataForLoc",
                desc:Textdia,
                con:linkdesc
        });
        $('#diagrid').datagrid('unselectAll');
    }    
    //重置
    $('#diaRefresh').click(function(e){
        $('#Textdia').val("");
        $('#dialinkDesc').combobox('setValue','');
        $('#diagrid').datagrid('reload',  {
                ClassName:"web.DHCBL.KB.DHCPHHospLocIcd",
                QueryName:"GetDataForLoc"
        });
        $('#diagrid').datagrid('unselectAll');
    }); 
    //关联
    $('#linkbtn').click(function(e){
        LinkMethod();
    });
    LinkMethod=function()
    {  
        var record=$('#locgrid').datagrid('getSelected');
        var diarecord=$('#diagrid').datagrid('getSelected');
        var linkdesc=$('#dialinkDesc').combobox('getValue');
        var Textdia=$('#Textdia').val();
        if(!record)
        {
            $.messager.alert('错误提示','请选择需要关联的科室！',"error");
            return;
        }
        if(!diarecord)
        {
            $.messager.alert('错误提示','请选择需要关联的诊断！',"error");
            return;
        }
        $('#link-save').form('submit', {
            url:SAVE_ACTION_URL_ICD,
            onSubmit: function(param){
                param.LOCILOCDr = record.HOSPLRowId;
                param.LOCIICDDr = diarecord.ICDRowId;
            },
            success: function (data) { 
                var data=eval('('+data+')'); 
                if (data.success == 'true')
                {
                    /*$.messager.show({ 
                    title: '提示消息', 
                    msg: '提交成功', 
                    showType: 'show', 
                    timeout: 1000, 
                    style: { 
                    right: '', 
                    bottom: ''
                        } 
                    });*/
                    $.messager.popover({msg: '关联成功！',type:'success',timeout: 1000}); 
                    $('#linkgrid').datagrid('load',{
                        ClassName:"web.DHCBL.KB.DHCPHHospLocIcd",
                        QueryName:"GetList",
                        desc:Textdia,
                        parref:record.HOSPLRowId
                    });
                    $('#diagrid').datagrid('reload',  {
                            ClassName:"web.DHCBL.KB.DHCPHHospLocIcd",
                            QueryName:"GetDataForLoc",
                            con:linkdesc
                    });                    
                } 
                else 
                { 
                    var errorMsg ="更新失败！"
                    if (data.errorinfo)
                    {
                        errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
                    }
                $.messager.alert('操作提示',errorMsg,"error");
                }

            } 
        });               
    }    
    //已关联
    var linkcolumns =[[
        {field:'LOCIRowId',title:'RowId',width:150,sortable:true,hidden:true},
        {field:'LOCILOCDr',title:'科室',width:150,sortable:true},
        {field:'LOCIICDDr',title:'诊断',width:150,sortable:true},
        {field:'ICDOpStatus',title:'操作状态',width:150,sortable:true,
            formatter:function(value,index,row)
            {
                if(value=="0")
                {
                    return "放弃";
                }
                else if(value=="1")
                {
                    return "确认";
                }

            }
        },
        {field:'ICDRemark',title:'备注',width:150,sortable:true},
        {field:'opt',title:'操作',width:150,align:'center',
            formatter:function(){  
                var btn =  '<img class="contrast" onclick="delLink()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;cursor:pointer">' 
                //var btn = '<a class="contrast" href="#"  onclick="delLink()" style="border:0px;cursor:pointer">删除</a>';  
                return btn;  
            }  
        }
    ]];
    var linkgrid = $HUI.datagrid("#linkgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHHospLocIcd",
            QueryName:"GetList"
        },
        columns: linkcolumns,  //列信息
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        //ClassTableName:'User.MKBTermGJ',
        //SQLTableName:'MKB_Term',
        idField:'LOCIRowId',
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        toolbar:[],//表头和数据之间的缝隙
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data){
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        }
    }); 
    delLink=function()
    {
        setTimeout(function(){
            var record=$('#linkgrid').datagrid('getSelected');
            if(record)
            {
                var locrecord=$('#locgrid').datagrid('getSelected');
                var rowid=record.LOCIRowId;
                $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
                if (r){
                    $.ajax({
                        url:DELETE_CON_ACTION_URL,  
                        data:{"id":rowid},  
                        type:"POST",   
                        //dataType:"TEXT",  
                        success: function(data){
                                  var data=eval('('+data+')'); 
                                  if (data.success == 'true') {
                                    /*$.messager.show({ 
                                      title: '提示消息', 
                                      msg: '删除成功', 
                                      showType: 'show', 
                                      timeout: 1000, 
                                      style: { 
                                        right: '', 
                                        bottom: ''
                                      } 
                                    }); */
                                    $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
                                     //$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
                                     //$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
                                    $('#linkgrid').datagrid('load',  {
                                        ClassName:"web.DHCBL.KB.DHCPHHospLocIcd",
                                        QueryName:"GetList",
                                        parref:locrecord.HOSPLRowId
                                    });
                                    $('#diagrid').datagrid('reload',  {
                                            ClassName:"web.DHCBL.KB.DHCPHHospLocIcd",
                                            QueryName:"GetDataForLoc"
                                    });                                      
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
        },100)        
    }       	        
}
$(init);