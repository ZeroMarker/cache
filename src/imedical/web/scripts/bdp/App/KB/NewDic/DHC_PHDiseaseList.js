/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-08-08 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-11-07 15:43:23
* @描述:病症字典维护
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseList&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDiseaseList";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseList&pClassMethod=DeleteData";
var SAVE_ACTION_URL_ICD = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseItmList&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDiseaseItmList";
var DELETE_CON_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseItmList&pClassMethod=DeleteData";
var init=function()
{
   var disecolumns =[[
        {field:'PHDISLDiseaCode',title:'代码',sortable:true,width:100},
        {field:'PHDISLDiseaDesc',title:'诊断中心词',sortable:true,width:100},
        {field:'PHDISLKey',title:'拼音码',sortable:true,width:100},
        {field:'PHDISLCom',title:'常用名',sortable:true,width:100},
        {field:'comKey',title:'常用名拼音码',sortable:true,width:100},
        {field:'PHDISLAlias',title:'别名',sortable:true,width:100},
        {field:'PHDISLRemark',title:'备注',sortable:true,width:100},
        {field:'PHDISLActiveFlag',title:'是否可用',sortable:true,width:100,hidden:true,
              formatter:ReturnFlagIcon
        },
        {field:'PHDISLSysFlag',title:'系统标识',sortable:true,width:100,hidden:true,
              formatter:ReturnFlagIcon
        }, 
        {field:'PHDISLRowId',title:'rowid',sortable:true,width:100,hidden:true}
    ]];
    var disegrid = $HUI.datagrid("#disegrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHDiseaseList",
            QueryName:"GetList"
        },
        columns: disecolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.DHCPHExtPart',
		//SQLTableName:'DHC_PHExtPart',
        idField:'PHDISLRowId',
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
            	ClassName:"web.DHCBL.KB.DHCPHDiseaseItmList",
            	QueryName:"GetList",
            	parref:row.PHDISLRowId
    		}); 
            $('#linkgrid').datagrid('unselectAll');       	
        },
        onDblClickRow:function(index,row)
        {
            updateData();
        }		
    });
    //搜索
    $('#disesearch').click(function(e){
        SearchDise();
    });
    //搜索回车事件
    $('#diseDesc').keyup(function(event){
        if(event.keyCode == 13) {
          SearchDise();
        }
    });    
    //搜索方法
    SearchDise=function()
    {
        var desc=$('#diseDesc').val();
        $('#disegrid').datagrid('reload',  {
                ClassName:"web.DHCBL.KB.DHCPHDiseaseList",
                QueryName:"GetList",
                //allEn:"Y",
                desc:desc
        });
        $('#linkgrid').datagrid('reload',  {
            ClassName:"web.DHCBL.KB.DHCPHDiseaseItmList",
            QueryName:"GetList",
            parref:"-1"
        }); 
        $('#disegrid').datagrid('unselectAll');
        $('#linkgrid').datagrid('unselectAll');
        var editIndex = undefined;
        var editIndexS = undefined;        
    }    
    //重置
    $('#diseRefresh').click(function(e){
        $('#diseDesc').val("");
        $('#disegrid').datagrid('reload',  {
                ClassName:"web.DHCBL.KB.DHCPHDiseaseList",
                QueryName:"GetList"
        });
        $('#linkgrid').datagrid('reload',  {
            ClassName:"web.DHCBL.KB.DHCPHDiseaseItmList",
            QueryName:"GetList",
            parref:"-1"
        });
        $('#disegrid').datagrid('unselectAll');
        $('#linkgrid').datagrid('unselectAll');
        var editIndex = undefined;
        var editIndexS = undefined;  
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
    //弹窗按钮
    $('#guide_btn').click(function(e){
        guideLink(); 
    }); 
    guideLink=function()
    {
        var record = disegrid.getSelected(); 
        if(record)
        {
            var resutText=record.PHDISLDiseaDesc;
            $('#guideWin').show();
            var resultWin = $HUI.dialog("#guideWin",{
                iconCls:'icon-textbook',
                resizable:true,
                title:"病症指南"+"-"+resutText,
                modal:true
            }); 
        var parref=record.PHDISLRowId;   
        var parrefDesc=record.PHDISLDiseaDesc;               
        var url="../csp/dhc.bdp.kb.dhcphdiseaseguide.csp"+"?parref="+parref+"&parrefDesc="+parrefDesc;
	    //token改造 GXP 20230209
		if('undefined'!==typeof websys_getMWToken)
		{
			url+="&MWToken="+websys_getMWToken()
		}	
        $('#guide_iframe').attr("src",url);
        }
        else
        {
            $.messager.alert('错误提示','请先选择一条记录!',"error");           
        }        
    }
    //点击配置按钮
    $("#configure_btn").click(function(e){
        openConfigure();
        var editIndex = undefined;
        var editIndexS = undefined;  
    }); 
    //配置多选框的触发事件
    $HUI.checkbox('#AutoCode',{
        onChecked:function(e,value)
        {
            //alert("选中啦")
            $('#StartCode').attr("disabled",true);
            $('#CodeLen').attr("disabled",true);
        },
        onUnchecked:function(e,value)
        {
            //alert("去掉啦")
            $('#StartCode').attr("disabled",false);
            $('#CodeLen').attr("disabled",false);
        } 
    });
    openConfigure=function()
    {
        var AutoCode=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseList","ShowAutoCode","AutoCode");
        var CodeLen=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseList","ShowAutoCode","CodeLen");
        var StartCode=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseList","ShowAutoCode","StartCode"); 
        if(AutoCode=="true"){
            $('#StartCode').val('');
            $('#CodeLen').val('');
            $HUI.checkbox('#AutoCode').setValue(true);
            $('#StartCode').attr("disabled",true);
            $('#CodeLen').attr("disabled",true);            
        }else{
            $HUI.checkbox('#AutoCode').setValue(false);
            $('#StartCode').val(StartCode);
            $('#CodeLen').val(CodeLen);             
        }           
        $("#conWin").show();
        var conWin = $HUI.dialog("#conWin",{
            resizable:true,
            iconCls:'icon-w-batch-cfg',
            title:'代码生成规则',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'保存',
                id:'saveCon_btn',
                handler:function(){
                    saveConfigure()
                }
            },{
                text:'关闭',
                handler:function(){
                    conWin.close();
                }
            }]
        });   
    } 
    saveConfigure=function()
    {
        var configureFlag=$('#AutoCode').checkbox('getValue');
        if(configureFlag)
        {
            var StartCodeS="";
            var CodeLenS="";
            var AutoCodeS="true"
        }
        else
        {
            //未选中
           var StartCodeS=$('#StartCode').val();
           var CodeLenS=$('#CodeLen').val();
           var AutoCodeS=""
           var regex=/^[a-zA-Z]+$/;
           if (!StartCodeS.match(regex))
           {
                $.messager.alert('错误提示','代码起始字符必须为英文字母!',"error");
                return;  
           }
           if(StartCodeS.length==1)
           {
                $.messager.alert('错误提示','代码起始字符不能以单个字符为准!',"error");
                return;                 
           }
           if(StartCodeS=="")
           {
                $.messager.alert('错误提示','代码起始字符不能为空!',"error");
                return;            
           }
           if(CodeLenS=="")
           {
                $.messager.alert('错误提示','代码长度不能为空!',"error");
                return;            
           }           
        }
        //alert(AutoCodeS+"^"+CodeLenS+"^"+StartCodeS)
        var saveflag =tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseList","SaveAutoCode",AutoCodeS,CodeLenS,StartCodeS);
        if(saveflag==1)
        {
            $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});          
            $('#StartCode').val('');
            $('#CodeLen').val('');            
            $('#conWin').dialog('close');
        }
        else if (saveflag==2 && StartCodeS!="" & CodeLenS!="")
        {
            alert("代码起始字符的长度要小于代码长度");
        } 
        else
        {
            $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
            $('#conWin').dialog('close');
        }      
    }     
    //点击添加按钮方法
    AddData=function(){ 
        $("#myWin").show();
        $('#othergrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHDiseaseComList",
            QueryName:"GetList",
            dis:"-1",
            type:"A"
        });
        $('#comgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHDiseaseComList",
            QueryName:"GetList",
            dis:"-1",
            type:"C"
        });       
        var myWin = $HUI.dialog("#myWin",{
            iconCls:'icon-addlittle',
            resizable:true,
            title:'添加',
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
                    $('#othergrid').datagrid('load',  { 
                        ClassName:"web.DHCBL.KB.DHCPHDiseaseComList",
                        QueryName:"GetList",
                        dis:"-1",
                        type:"A"
                    });
                    $('#comgrid').datagrid('load',  { 
                        ClassName:"web.DHCBL.KB.DHCPHDiseaseComList",
                        QueryName:"GetList",
                        dis:"-1",
                        type:"C"
                    });                     
                    myWin.close();
                     editIndex = undefined;
                     editIndexS = undefined;  
                }
            }],
            onClose:function(){
                $('#othergrid').datagrid('load',  { 
                    ClassName:"web.DHCBL.KB.DHCPHDiseaseComList",
                    QueryName:"GetList",
                    dis:"-1",
                    type:"A"
                });
                $('#comgrid').datagrid('load',  { 
                    ClassName:"web.DHCBL.KB.DHCPHDiseaseComList",
                    QueryName:"GetList",
                    dis:"-1",
                    type:"C"
                }); 
                 editIndex = undefined;
                 editIndexS = undefined; 
            }
        });
        $('#form-save').form("clear");
        var codeTex=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseList","GetLastCode");
        $("#PHDISLDiseaCode").val(codeTex);
        //默认选中
        $HUI.checkbox("#PHDISLActiveFlag").setValue(true);
        $HUI.checkbox("#PHDISLSysFlag").setValue(true);
        $('#tabOther').tabs('select',0);  
    }
    SaveFunLib=function(id,flagT)
    {
         //结束可编辑表格的可编辑状态
         endEditing(); 
         endEditingC();      
        //判断别名是否为空
        var rows = $('#othergrid').datagrid('getRows');//获取当前页的数据行  
        for (var i = 0; i < rows.length; i++) {  
            //total += rows[i]['SCORE']; //获取指定列
            //alert(editIndex);
            //alert(rows[i]['DataAlias']);
            //
            if (rows[i]['PHDCLDesc'] == "")
            {
                $.messager.alert('错误提示','别名不能为空！','error');
                var newEditIndex=$('#othergrid').datagrid('getRowIndex',$('#othergrid').datagrid('getSelected'));
                othergrid.deleteRow(newEditIndex)
                return                          
            }
        } 

        //判断常用名是否为空
        var rows = $('#comgrid').datagrid('getRows');//获取当前页的数据行 
        for (var i = 0; i < rows.length; i++) {  
            //total += rows[i]['SCORE']; //获取指定列
            //alert(editIndex);
            //alert(rows[i]['DataAlias']);
            if (rows[i]['PHDCLDesc'] == "")
            {
                $.messager.alert('错误提示','常用名不能为空！','error');
                var newEditIndex=$('#comgrid').datagrid('getRowIndex',$('#comgrid').datagrid('getSelected'));
                comgrid.deleteRow(newEditIndex) 
                return                          
            }
        }                         
        //alert(flagT)
        var code=$.trim($("#PHDISLDiseaCode").val());
        var desc=$.trim($("#PHDISLDiseaDesc").val());   
        if (code=="")
        {
            $.messager.alert('错误提示','代码不能为空!',"error");
            return;
        }
        if (desc=="")
        {
            $.messager.alert('错误提示','诊断中心词不能为空!',"error");
            return;
        }  
        $('#form-save').form('submit', {
            url:SAVE_ACTION_URL,
            onSubmit: function(param){
                param.PHDISLRowId = id;
            },
        success: function (data) { 
            var data=eval('('+data+')'); 
            if (data.success == 'true') {
                var DataRefer=data.id;
                var otherdata=$('#othergrid').datagrid('getData');
                //alert(data.rows[0].DataAlias);
                //alert(otherdata.rows.length)
                var dataforSave="";
                for(i=0;i<otherdata.rows.length;i++)
                {
                    //alert(otherdata.rows[i].DataAlias)
                    var PHDCLKey=""; 
                    var dataRow=otherdata.rows[i].PHDCLRowId+"^"+otherdata.rows[i].PHDCLDesc+"^"+DataRefer+"^A^"+PHDCLKey;
                    if(dataforSave=="")
                    {
                        dataforSave=dataRow;
                    }
                    else
                    {
                        dataforSave += "#"+dataRow;
                    }
                }
                var comdata=$('#comgrid').datagrid('getData');
                for(j=0;j<comdata.rows.length;j++)
                {
                    //alert(otherdata.rows[i].DataAlias)
                    var PHDCLKey=""; 
                    var dataRow=comdata.rows[j].PHDCLRowId+"^"+comdata.rows[j].PHDCLDesc+"^"+DataRefer+"^C^"+PHDCLKey;
                    if(dataforSave=="")
                    {
                        dataforSave=dataRow;
                    }
                    else
                    {
                        dataforSave += "#"+dataRow;
                    }
                }               
               // if(dataforSave=="")
               // {
                 //   return false;
               // }
               // else
               // {
                    //alert(dataforSave)
                    var datao=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseComList","SaveAll",dataforSave);
                //}                
                /*$.messager.show({ 
                    title: '提示消息', 
                    msg: '提交成功', 
                    showType: 'show', 
                    timeout: 1000, 
                    style: { 
                    right: '', 
                    bottom: ''
                    } 
                }); */
            $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
            $('#disegrid').datagrid('reload');  // 重新载入当前页面数据 
            //alert(flagT)
            if(flagT==1)
            {
                $('#myWin').dialog('close'); // close a dialog
            }
            else
            {
                $('#form-save').form("clear");
                var codeTex=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseList","GetLastCode");
                $("#PHDISLDiseaCode").val(codeTex);                
                //默认选中
                $HUI.checkbox("#PHDISLActiveFlag").setValue(true);
                $HUI.checkbox("#PHDISLSysFlag").setValue(true);  
                $('#othergrid').datagrid('load',  { 
                    ClassName:"web.DHCBL.KB.DHCPHDiseaseComList",
                    QueryName:"GetList",
                    dis:"-1",
                    type:"A"
                });
                $('#comgrid').datagrid('load',  { 
                    ClassName:"web.DHCBL.KB.DHCPHDiseaseComList",
                    QueryName:"GetList",
                    dis:"-1",
                    type:"C"
                });                              
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
        $('#tabOther').tabs('select',0);
        var record = disegrid.getSelected(); 
        if(record)
        {
            var id=record.PHDISLRowId;
            $('#othergrid').datagrid('load',  { 
                ClassName:"web.DHCBL.KB.DHCPHDiseaseComList",
                QueryName:"GetList",
                dis:id,
                type:"A"
            });
            $('#comgrid').datagrid('load',  { 
                ClassName:"web.DHCBL.KB.DHCPHDiseaseComList",
                QueryName:"GetList",
                dis:id,
                type:"C"
            });                          
            $.cm({
                ClassName:"web.DHCBL.KB.DHCPHDiseaseList",
                MethodName:"NewOpenData",
                id:id
            },function(jsonData){
                //给是否可用单独赋值 
                //alert(jsonData.PHLFSysFlag)       
                //alert(jsonData.PHLFActiveFlag)        
                if (jsonData.PHDISLActiveFlag=="Y"){
                    $HUI.checkbox("#PHDISLActiveFlag").setValue(true);     
                }else{
                    $HUI.checkbox("#PHDISLActiveFlag").setValue(false);
                }    
                if (jsonData.PHDISLSysFlag=="Y"){
                    $HUI.checkbox("#PHDISLSysFlag").setValue(true);     
                }else{
                    $HUI.checkbox("#PHDISLSysFlag").setValue(false);
                }                            
                $('#form-save').form("load",jsonData);  
            }); 
            $("#myWin").show();
            var myWin = $HUI.dialog("#myWin",{
                iconCls:'icon-updatelittle',
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
                         editIndex = undefined;
                         editIndexS = undefined; 
                    }
                }],
                onClose:function(){
                     editIndex = undefined;
                     editIndexS = undefined; 
                }
            });                         
        }else{
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }
    }
    delData=function()
    {
        var row = $("#disegrid").datagrid("getSelected"); 
        if (!(row))
        {   $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        }
        var rowid=row.PHDISLRowId;
        $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
            if (r){
                $.ajax({
                    url:DELETE_ACTION_URL,  
                    data:{"id":rowid},  
                    type:"POST",   
                    //dataType:"TEXT",  
                    success: function(data){
                              //var datad=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseComList","DeleteAll","DHC_PHDiseaseList",data.id);
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
                                });*/
                                $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000}); 
                                 $('#disegrid').datagrid('reload');  // 重新载入当前页面数据 
                                 $('#disegrid').datagrid('unselectAll');  // 清空列表选中数据 
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
            ClassName:"web.DHCBL.KB.DHCExtIcdFeild",
            QueryName:"GetDataForCmb2"
        },
        columns: diacolumns,  //列信息
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        //ClassTableName:'User.MKBTermGJ',
        //SQLTableName:'MKB_Term',
        idField:'ICDRowId',
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data){
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        }
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
    //搜索
    $('#diasearch').click(function(e){
        SearchDia();
    });
    //搜索回车事件
    $('#diaDesc').keyup(function(event){
        if(event.keyCode == 13) {
          SearchDia();
        }
    });    
    //搜索方法
    SearchDia=function()
    {
        var diaDesc=$('#diaDesc').val();
        var linkdesc=$('#dialinkDesc').combobox('getValue');
        $('#diagrid').datagrid('reload',  {
                ClassName:"web.DHCBL.KB.DHCExtIcdFeild",
                QueryName:"GetDataForCmb2",
                desc:diaDesc,
                con:linkdesc
        });
        $('#diagrid').datagrid('unselectAll');        
    }    
    //重置
    $('#diaRefresh').click(function(e){
        $('#diaDesc').val("");
        $('#dialinkDesc').combobox('setValue','');
        $('#diagrid').datagrid('reload',  {
                ClassName:"web.DHCBL.KB.DHCExtIcdFeild",
                QueryName:"GetDataForCmb2"
        });
        $('#diagrid').datagrid('unselectAll');
    }); 
    //关联
    $('#linkbtn').click(function(e){
        LinkMethod();
    });
    LinkMethod=function()
    {  
        var record=$('#disegrid').datagrid('getSelected');
        var diarecord=$('#diagrid').datagrid('getSelected');
        if(!record)
        {
            $.messager.alert('错误提示','请选择需要关联的病症！',"error");
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
                param.PHDISLIDisDr = record.PHDISLRowId;
                param.PHDISLIICDDr = diarecord.ICDRowId;
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
                    }); */
                    $.messager.popover({msg: '关联成功！',type:'success',timeout: 1000}); 
                    $('#linkgrid').datagrid('load',{
                        ClassName:"web.DHCBL.KB.DHCPHDiseaseItmList",
                        QueryName:"GetList",
                        parref:record.PHDISLRowId
                    });
                    var diaDesc=$('#diaDesc').val();
                    var linkdesc=$('#dialinkDesc').combobox('getValue');
                    $('#diagrid').datagrid('reload',  {
                            ClassName:"web.DHCBL.KB.DHCExtIcdFeild",
                            QueryName:"GetDataForCmb2",
                            desc:diaDesc,
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
        //{field:'ck',checkbox:true },
        {field:'PHDISLIRowId',title:'RowId',width:150,sortable:true,hidden:true},
        {field:'PHDISLIDisDr',title:'病症',width:150,sortable:true},
        {field:'PHDISLIICDDr',title:'诊断',width:150,sortable:true},
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
        {field:'PHDISLIType',title:'诊断类型',width:150,sortable:true,hidden:true},
        {field:'PHDISLISysFlag',title:'系统标识',sortable:true,width:100,hidden:true,
                formatter:ReturnFlagIcon
        }, 
        {field:'opt',title:'操作',width:150,align:'center',
            formatter:function(){  
                //var btn = '<a class="contrast" href="#"  onclick="delLink()" style="border:0px;cursor:pointer">删除</a>';  
                var btn =  '<img class="contrast" onclick="delLink()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;cursor:pointer">' 
                return btn;  
            }  
        }
    ]];
    var linkgrid = $HUI.datagrid("#linkgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHDiseaseItmList",
            QueryName:"GetList"
        },
        columns: linkcolumns,  //列信息
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        //ClassTableName:'User.MKBTermGJ',
        //SQLTableName:'MKB_Term',
        singleSelect:true,
        //checkOnSelect:false,        
        idField:'PHDISLIRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        toolbar: [], //配置项toolbar为空时,会在标题与列头产生间距"
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onLoadSuccess:function(data){
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        }
    }); 
        //点击批量撤销按钮
    $('#cancleAllBtn').click(function(e){
        cancelLinkAll();
    });
    cancelLinkAll=function()
    {
        var rows=$('#linkgrid').datagrid('getSelections');
        //console.log(rows);
        //alert(rows.length)
        var ids=""
        //alert(rows.length)
        if(rows.length==0)
        {
            $.messager.alert('错误提示','请勾选数据!',"error");
            return;         
        }
        for(var i=0;i<rows.length;i++)
        {
            //alert(rows[i].PHDISLIRowId);
            if(rows[i].PHDISLIRowId!="")
            {
                if(i==0)
                {
                    ids=rows[i].PHDISLIRowId;
                }
                else
                {
                    ids=ids+"^"+rows[i].PHDISLIRowId;
                }
            }
        }
        $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
            if (r)
            {
                var data=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseItmList","DeleteDataStr",ids);
                var data=eval('('+data+')');
                if (data.success == 'true') {
                    /*$.messager.show({ 
                      title: '提示消息', 
                      msg: '批量删除成功', 
                      showType: 'show', 
                      timeout: 1000, 
                      style: { 
                        right: '', 
                        bottom: ''
                      } 
                    });*/
                    $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000}); 
                    $('#linkgrid').datagrid('reload');   
                }
                else
                {
                    var errorMsg ="对照失败！"
                    if (data.info) {
                        errorMsg =errorMsg+ '<br/>错误信息:' + data.info
                    }
                     $.messager.alert('操作提示',errorMsg,"error");             
                }               
            }   
        });     
    }
    delLink=function()
    {
        setTimeout(function(){
            var record=$('#linkgrid').datagrid('getSelected');
            if(record)
            {
                var diserecord=$('#disegrid').datagrid('getSelected');
                var rowid=record.PHDISLIRowId;
                //var data=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseItmList","DeleteData",rowid);
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
                                        ClassName:"web.DHCBL.KB.DHCPHDiseaseItmList",
                                        QueryName:"GetList",
                                        parref:diserecord.PHDISLRowId
                                    });
                                    var linkdesc=$('#dialinkDesc').combobox('getValue');
                                    $('#diagrid').datagrid('reload',  {
                                            ClassName:"web.DHCBL.KB.DHCExtIcdFeild",
                                            QueryName:"GetDataForCmb2",
                                            con:linkdesc
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
    //别名可编辑列表
    var editIndex = undefined;
    var rowsvalue=undefined;
    var oldrowsvalue=undefined;
    var preeditIndex="";
    var othercolumns =[[  
      {field:'PHDCLRowId',title:'AliasRowId',width:50,sortable:true,hidden:true,editor:'validatebox'},
      {field:'PHDCLDesc',title:'别名',width:200,sortable:true,editor:'validatebox'},
      {field:'PHDCLKey',title:'拼音码',width:200,sortable:true}
     ]];
    var othergrid = $HUI.datagrid("#othergrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHDiseaseComList",         ///调用Query时
            QueryName:"GetList"
        },
        //ClassTableName:'User.BDPTableList',
        //SQLTableName:'BDP_TableList',
        idField:'AliasRowId',
        columns: othercolumns,  //列信息
        pagination: false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:15,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        remoteSort:false,  //定义是否从服务器排序数据。true
        onDblClickRow:function(rowIndex,rowData){
            DblClickFun(rowIndex,rowData)
        },
        onClickRow:function(rowIndex,rowData){
            $('#othergrid').datagrid('selectRow', rowIndex);
            //ClickFun();
        },
        onLoadSuccess:function(data){
        }
    });
    //用于单击非grid行保存可编辑行
    $(document).bind('click',function(){ 
        ClickFun();
    });
    $('#addo_btn').click(function (e){
        AddDataO();

    });
    $('#delo_btn').click(function (e){
        //$('#knoExe').css('display','none'); 
        DelDataO();
    });
    function DelDataO(){
        var record=othergrid.getSelected();
        if(!record){
            $.messager.alert('提示','请选择一条记录！','error');
            return;
        }
        //console.log(mygrid.getSelected())
        if((record.PHDCLRowId==undefined)||(record.PHDCLRowId=="")){
            othergrid.deleteRow(editIndex)
            editIndex = undefined;
            return;
        }
        
        $.messager.confirm('确认','您要删除这条数据吗?',function(r){
            if(r){
                id=record.PHDCLRowId;
                $.ajax({
                    url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseComList&pClassMethod=DeleteData",
                    data:{"id":id},
                    type:'POST',
                    success:function(data){
                        var data=eval('('+data+')');
                        if(data.success=='true'){
                            /*$.messager.show({
                                title:'提示信息',
                                msg:'删除成功',
                                showType:'show',
                                timeout:1000,
                                style:{
                                    right:'',
                                    bottom:''
                                }
                            });*/
                            $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000}); 
                            $('#othergrid').datagrid('reload');
                            $('#othergrid').datagrid('unselectAll');
                            editIndex = undefined;
                            rowsvalue=undefined;
                        }
                        else{
                            var errorMsg="删除失败！";
                            if(data.info){
                                errorMsg=errorMsg+'</br>错误信息:'+data.info
                            }
                            $.messager.alert('错误提示',errorMsg,'error')
                        }
                    }
                });
            }
        });
    }    
    function AddDataO(){
        if(ClickFun('AddDataO')==0){
            return
        }        
        preeditIndex=editIndex;
        ClickFun('AddDataO')
        
        if (endEditing()){
            $('#othergrid').datagrid('insertRow',{index:0,row:{}});
            editIndex = 0;//$('#mygrid').datagrid('getRows').length-1;
            $('#othergrid').datagrid('selectRow', editIndex)
                    .datagrid('beginEdit', editIndex);
        }
        //AppendDom()
    }    
    function ClickFun(type){   //单击执行保存可编辑行
        if (endEditing()){
            //console.log(rowsvalue)
            if(rowsvalue!= undefined){
                if((rowsvalue.PHDCLDesc!="")){
                    var rows = $('#othergrid').datagrid('getRows');//获取当前页的数据行    
                    for (var i = 0; i < rows.length; i++) {  
                        //total += rows[i]['SCORE']; //获取指定列
                        //alert(editIndex);
                        //alert(rows[i]['DataAlias']);
                        var valuerow = rows[i]['PHDCLDesc'];
                        if (valuerow == rowsvalue.PHDCLDesc && i != editIndex && editIndex!=undefined)
                        {
                            $.messager.alert('错误提示','别名重复！','error');
                            editIndex=undefined
                            /*$('#othergrid').datagrid('selectRow', editIndex)
                                .datagrid('beginEdit', editIndex);*/
                            var newEditIndex=$('#othergrid').datagrid('getRowIndex',$('#othergrid').datagrid('getSelected'));
                            othergrid.deleteRow(newEditIndex)                               
                            //AppendDom()
                            return                          
                        }
                    }                      
                    var differentflag="";
                    if(oldrowsvalue!= undefined){
                        var oldrowsvaluearr=JSON.parse(oldrowsvalue)
                        for(var params in rowsvalue){
                            if(oldrowsvaluearr[params]!=rowsvalue[params]){
                                differentflag=1
                            }
                        }
                    }
                    else{
                        differentflag=1
                    }
                    if(differentflag==1){
                        preeditIndex=editIndex
                        //SaveDataO (rowsvalue,type);
                    }
                    else{
                        //UpdataRow(rowsvalue,editIndex)
                        editIndex=undefined
                        rowsvalue=undefined
                    }
                }
                else{
                    //$.messager.alert('错误提示','别名不能为空！','error')
                    var newEditIndex=$('#othergrid').datagrid('getRowIndex',$('#othergrid').datagrid('getSelected'));
                    othergrid.deleteRow(newEditIndex)                    
                    $('.messager-window').click(stopPropagation)
                    /*$('#othergrid').datagrid('selectRow', editIndex)
                        .datagrid('beginEdit', editIndex);*/
                    //AppendDom()
                    return 0
                }
            }

        }
    }   
    function DblClickFun (index,row){   //双击激活可编辑   （可精简）
        
        if(index==editIndex){
            return
        }
        /*if((row!=undefined)&&(row.AliasRowId!=undefined)){
            UpdataRow(row,index)
        }*/
        preeditIndex=editIndex
        if (editIndex != index){
            if (endEditing()){
                $('#othergrid').datagrid('selectRow', index)
                        .datagrid('beginEdit', index);
                editIndex = index;
            } else {
                $('#othergrid').datagrid('selectRow', editIndex);
            }
        }
        oldrowsvalue=JSON.stringify(row);   //用于和rowvalue比较 以判断是否行值发生改变
        //AppendDom()
    }
    function endEditing(){
        if (editIndex == undefined){return true}
        if ($('#othergrid').datagrid('validateRow', editIndex)){
            $('#othergrid').datagrid('endEdit', editIndex);
            rowsvalue=othergrid.getRows()[editIndex];    //临时保存激活的可编辑行的row   
            //editIndex = undefined;
            return true;
        } else {
            return false;
        }
    }
    //常用名可编辑列表
    var editIndexS = undefined;
    var rowsvalueS=undefined;
    var oldrowsvalueS=undefined;
    var preeditIndexS="";
    var comcolumns =[[  
      {field:'PHDCLRowId',title:'AliasRowId',width:50,sortable:true,hidden:true,editor:'validatebox'},
      {field:'PHDCLDesc',title:'常用名',width:200,sortable:true,editor:'validatebox'},
      {field:'PHDCLKey',title:'拼音码',width:200,sortable:true}
     ]];
    var comgrid = $HUI.datagrid("#comgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHDiseaseComList",         ///调用Query时
            QueryName:"GetList"
        },
        //ClassTableName:'User.BDPTableList',
        //SQLTableName:'BDP_TableList',
        idField:'AliasRowId',
        columns: comcolumns,  //列信息
        pagination: false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:15,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        remoteSort:false,  //定义是否从服务器排序数据。true
        onDblClickRow:function(rowIndex,rowData){
            DblClickFunC(rowIndex,rowData)
        },
        onClickRow:function(rowIndex,rowData){
            $('#comgrid').datagrid('selectRow', rowIndex);
            //ClickFun();
        },
        onLoadSuccess:function(data){
        }
    });
    //用于单击非grid行保存可编辑行
    $(document).bind('click',function(){ 
        ClickFunC();
    });
    $('#addc_btn').click(function (e){
        AddDataC();

    });
    $('#delc_btn').click(function (e){
        //$('#knoExe').css('display','none'); 
        DelDataC();
    });
    function DelDataC(){
        var record=comgrid.getSelected();
        if(!record){
            $.messager.alert('提示','请选择一条记录！','error');
            return;
        }
        //console.log(mygrid.getSelected())
        if((record.PHDCLRowId==undefined)||(record.PHDCLRowId=="")){
            comgrid.deleteRow(editIndexS)
            editIndexS = undefined;
            return;
        }
        
        $.messager.confirm('确认','您要删除这条数据吗?',function(r){
            if(r){
                id=record.PHDCLRowId;
                $.ajax({
                    url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseComList&pClassMethod=DeleteData",
                    data:{"id":id},
                    type:'POST',
                    success:function(data){
                        var data=eval('('+data+')');
                        if(data.success=='true'){
                            /*$.messager.show({
                                title:'提示信息',
                                msg:'删除成功',
                                showType:'show',
                                timeout:1000,
                                style:{
                                    right:'',
                                    bottom:''
                                }
                            });*/
                            $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000}); 
                            $('#comgrid').datagrid('reload');
                            $('#comgrid').datagrid('unselectAll');
                            editIndexS = undefined;
                            rowsvalueS=undefined;
                        }
                        else{
                            var errorMsg="删除失败！";
                            if(data.info){
                                errorMsg=errorMsg+'</br>错误信息:'+data.info
                            }
                            $.messager.alert('错误提示',errorMsg,'error')
                        }
                    }
                });
            }
        });
    }    
    function AddDataC(){
        if(ClickFunC('AddDataC')==0){
            return
        }        
        preeditIndexS=editIndexS;
        //ClickFunC('AddDataC')
        
        if (endEditingC()){
            $('#comgrid').datagrid('insertRow',{index:0,row:{}});
            editIndexS = 0;//$('#mygrid').datagrid('getRows').length-1;
            $('#comgrid').datagrid('selectRow', editIndexS)
                    .datagrid('beginEdit', editIndexS);
        }
        //AppendDom()
    }    
    function ClickFunC(type){   //单击执行保存可编辑行
        if (endEditingC()){
            //console.log(rowsvalue)
            if(rowsvalueS!= undefined){
                if((rowsvalueS.PHDCLDesc!="")){
                    var rows = $('#comgrid').datagrid('getRows');//获取当前页的数据行    
                    for (var i = 0; i < rows.length; i++) {  
                        //total += rows[i]['SCORE']; //获取指定列
                        //alert(editIndex);
                        //alert(rows[i]['DataAlias']);
                        var valuerow = rows[i]['PHDCLDesc'];
                        if (valuerow == rowsvalueS.PHDCLDesc && i != editIndexS && editIndexS !=undefined)
                        {
                            $.messager.alert('错误提示','常用名重复！','error');
                            editIndexS=undefined
                            /*$('#comgrid').datagrid('selectRow', editIndex)
                                .datagrid('beginEdit', editIndex);*/
                            var newEditIndex=$('#comgrid').datagrid('getRowIndex',$('#comgrid').datagrid('getSelected'));
                            comgrid.deleteRow(newEditIndex)                               
                            //AppendDom()
                            return                          
                        }
                    }                      
                    var differentflag="";
                    if(oldrowsvalueS!= undefined){
                        var oldrowsvaluearr=JSON.parse(oldrowsvalueS)
                        for(var params in rowsvalueS){
                            if(oldrowsvaluearr[params]!=rowsvalueS[params]){
                                differentflag=1
                            }
                        }
                    }
                    else{
                        differentflag=1
                    }
                    if(differentflag==1){
                        preeditIndexS=editIndexS
                        //SaveDataO (rowsvalue,type);
                    }
                    else{
                        //UpdataRow(rowsvalue,editIndex)
                        editIndexS=undefined
                        rowsvalueS=undefined
                    }
                }
                else{
                    //$.messager.alert('错误提示','常用名不能为空！','error')
                    var newEditIndex=$('#comgrid').datagrid('getRowIndex',$('#comgrid').datagrid('getSelected'));
                    comgrid.deleteRow(newEditIndex)                     
                    $('.messager-window').click(stopPropagation)
                    /*$('#comgrid').datagrid('selectRow', editIndexS)
                        .datagrid('beginEdit', editIndexS);*/
                    //AppendDom()
                    return 0
                }
            }

        }
    }   
    function DblClickFunC (index,row){   //双击激活可编辑   （可精简）
        if(index==editIndexS){
            return
        }
        /*if((row!=undefined)&&(row.AliasRowId!=undefined)){
            UpdataRow(row,index)
        }*/
        //alert(index)
        preeditIndexS=editIndexS
        if (editIndexS != index){
            if (endEditingC()){
                $('#comgrid').datagrid('selectRow', index)
                        .datagrid('beginEdit', index);
                editIndexS = index;
            } else {
                $('#comgrid').datagrid('selectRow', editIndexS);
            }
        }
        oldrowsvalueS=JSON.stringify(row);   //用于和rowvalue比较 以判断是否行值发生改变
        //AppendDom()
    }
    function endEditingC(){
        if (editIndexS == undefined){return true}
        if ($('#comgrid').datagrid('validateRow', editIndexS)){
            $('#comgrid').datagrid('endEdit', editIndexS);
            rowsvalueS=comgrid.getRows()[editIndexS];    //临时保存激活的可编辑行的row   
            //editIndex = undefined;
            return true;
        } else {
            return false;
        }
    }                                 	        
}
$(init);