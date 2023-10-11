/*
* @Author: 基础数据平台-石萧伟
* @Date:   2019-04-17
* @描述:数据处理工厂 icd的增改功能
*/
var init=function()
{
    var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.MRCICDDx";
    
    //性别下拉框
	$("#MRCIDSexDRF").combobox({
        url:$URL+"?ClassName=web.DHCBL.CT.CTSex&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTSEXRowId',
		textField:'CTSEXDesc'
	});	

    /*
    *
        中医证型和中医诊断复选框的联动
        如果中医证型被选中则中医诊断必定被选
    */
    $('#MRCIDBillFlag1F').checkbox({
        onChecked:function(e,value){
            $HUI.checkbox("#MRCIDBillFlag3F").setValue(true);
        }
    })
    // $('#MRCIDBillFlag3F').checkbox({
    //     onUnchecked:function(e,value){
    //         var checkFlag = $('#MRCIDBillFlag1F').checkbox('getValue')
    //         if(checkFlag){
    //             $HUI.checkbox("#MRCIDBillFlag3F").setValue(true);
    //         }
    //     }
    // })
    //单机新增按钮
    /*$HUI.tooltip('#addicd_btn',{
        content:"新增ICD到ICD业务表",
        position: 'bottom' //top , right, bottom, left
    });
    $('#addicd_btn').click(function(e){
        AddICDData();
    })
    //单机修改按钮
    $HUI.tooltip('#editicd_btn',{
        content:"修改ICD业务表数据",
        position: 'bottom' //top , right, bottom, left
    });   
    $('#editicd_btn').click(function(e){
        UpdateICDData();
    })*/
    //修改方法
    UpdateICDData = function(e){
        $('#tabOther').tabs('select',0);
        var record = $('#ICDGrid').datagrid('getSelected'); 
        if(record)
        {     
            var id = record.MRCIDRowId;     
            $('#comgrid').datagrid('load',  { 
                ClassName:"web.DHCBL.CT.MRCICDAlias",
                QueryName:"GetList",
                aliasparref:id
            }); 

            $.cm({
                ClassName:"web.DHCBL.MKB.MKBStructuredData",
                MethodName:"OpenICDData",
                id:id
            },function(jsonData){
                //给是否可用单独赋值          
                if (jsonData.MRCIDMetastaticSite=="Y"){
                    $HUI.checkbox("#MRCIDMetastaticSiteF").setValue(true);     
                }else{
                    $HUI.checkbox("#MRCIDMetastaticSiteF").setValue(false);
                }    
                if (jsonData.MRCIDInjuryPoisoningCode=="Y"){
                    $HUI.checkbox("#MRCIDInjuryPoisoningCodeF").setValue(true);     
                }else{
                    $HUI.checkbox("#MRCIDInjuryPoisoningCodeF").setValue(false);
                }
                if (jsonData.MRCIDBillFlag1=="Y"){
                    $HUI.checkbox("#MRCIDBillFlag1F").setValue(true);     
                }else{
                    $HUI.checkbox("#MRCIDBillFlag1F").setValue(false);
                } 
                if (jsonData.MRCIDBillFlag3=="Y"){
                    $HUI.checkbox("#MRCIDBillFlag3F").setValue(true);     
                }else{
                    $HUI.checkbox("#MRCIDBillFlag3F").setValue(false);
                }                             
                $('#form-save').form("load",jsonData);  
            }); 
            $("#icd_updateWin").show();
            var ICDWin = $HUI.dialog("#icd_updateWin",{
                iconCls:'icon-updatelittle',
                resizable:true,
                title:'修改',
                modal:true,
                buttons:[{
                    text:'保存',
                    id:'save_btn',
                    handler:function(){
                        SaveICDFunLib(id)                        
                    }
                },{
                    text:'关闭',
                    handler:function(){
                        ICDWin.close();
                        editIndexOther = undefined;
                    }
                }],
                onClose:function(){
                    editIndexOther = undefined;
                }
            });                         
        }else{
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }

    }    
    //新增方法
    AddICDData = function(){
        $HUI.checkbox("#MRCIDMetastaticSiteF").setValue(false);
        $HUI.checkbox("#MRCIDInjuryPoisoningCodeF").setValue(false);  
        $HUI.checkbox("#MRCIDBillFlag1F").setValue(false);    
        $HUI.checkbox("#MRCIDBillFlag3F").setValue(false);
        
        $("#icd_updateWin").show();
        $('#comgrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.MRCICDAlias",
            QueryName:"GetList",
            aliasparref:"-1"
        });         
        var ICDWin = $HUI.dialog("#icd_updateWin",{
            iconCls:'icon-addlittle',
            resizable:true,
            title:'新增',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'保存',
                id:'save_btn',
                handler:function(){
                    SaveICDFunLib("")                    
                }
            },{
                text:'关闭',
                handler:function(){
                    $('#comgrid').datagrid('load',  { 
                        ClassName:"web.DHCBL.CT.MRCICDAlias",
                        QueryName:"GetList",
                        aliasparref:"-1"
                    }); 
                   
                    ICDWin.close();
                     editIndexOther = undefined;  
                     $('#form-save').form("clear");
                }
            }],
            onClose:function(){
                $('#comgrid').datagrid('load',  { 
                    ClassName:"web.DHCBL.CT.MRCICDAlias",
                    QueryName:"GetList",
                    aliasparref:"-1"
                }); 

                editIndexOther = undefined;
            }
    
        });
        $('#form-save').form("clear");
        $('#tabOther').tabs('select',0); 
    }
    //保存数据
    SaveICDFunLib = function(id){	
        //结束可编辑表格的可编辑状态
        endEditingOther();
        //判断别名是否为空
        var rows = $('#comgrid').datagrid('getRows');//获取当前页的数据行 
        for (var i = 0; i < rows.length; i++) {  
            if (rows[i]['ALIASText'] == "")
            {
                $.messager.alert('错误提示','常用名不能为空！','error');
                var newEditIndex=$('#comgrid').datagrid('getRowIndex',$('#comgrid').datagrid('getSelected'));
                comgrid.deleteRow(newEditIndex) 
                return                          
            }
        }                         
		var code=$.trim($("#MRCIDCodeF").val());
		var desc=$.trim($("#MRCIDDescF").val());
        var icd10code=$.trim($("#MRCIDICD9CMCodeF").val());
        var date = $("#MRCIDDateActiveFromF").datebox('getValue');
        var age1 = $("#MRCIDAgeFromF").val();
        var age2 = $("#MRCIDAgeToF").val();
        if(age1>180 || age1<0 || age2>180 || age2<0){
            $.messager.alert('错误提示','年龄不能小于0或大于180岁!',"error");
            return;           
        }
        if((age2-age1)<0){
            $.messager.alert('错误提示','最大年龄不能小于最小年龄!',"error");
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
        if (icd10code=="")
        {
            $.messager.alert('错误提示','icd10代码不能为空!',"error");
            return;
        } 
        if (date=="")
        {
            $.messager.alert('错误提示','开始日期不能为空!',"error");
            return;
        }                 
        $('#form-save').form('submit', { 
            url: SAVE_ACTION_URL, 
            onSubmit: function(param){
                param.MRCIDRowId = id;
            },
            success: function (data) { 
                var data=eval('('+data+')'); 
                if (data.success == 'true') {
                //保存别名
                var aliasparref = data.id;
                var dataforSave=""
                if(id==""){
                    var PYCode=Pinyin.GetJPU($("#MRCIDDescF").val());
                    dataforSave = ""+"^"+PYCode+"^"+aliasparref
                }
                var comdata=$('#comgrid').datagrid('getData');
                if(comdata.rows.length>0 || dataforSave!=""){
                    for(j=0;j<comdata.rows.length;j++)
                    {
                        //alert(otherdata.rows[i].DataAlias) 
                        var dataRow=comdata.rows[j].ALIASRowId+"^"+comdata.rows[j].ALIASText+"^"+aliasparref;
                        if(dataforSave=="")
                        {
                            dataforSave=dataRow;
                        }
                        else
                        {
                            dataforSave += "#"+dataRow;
                        }
                    }       
                    //保存别名        
                    tkMakeServerCall("web.DHCBL.CT.MRCICDAlias","SaveAll",dataforSave);
                }

                $('#comgrid').datagrid('load',  { 
                    ClassName:"web.DHCBL.CT.MRCICDAlias",
                    QueryName:"GetList",
                    aliasparref:"-1"
                }); 
                $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000}); 
                    /*$('#ICDGrid').datagrid('load',  { 
                        ClassName:"web.DHCBL.MKB.MKBStructuredData",
                        QueryName:"GetDataForCmb1"
                    });	*/
                    $('#MRCIDSexDRF').combobox('reload');//重新载入下拉框数据
                    $('#icd_updateWin').dialog('close');
                    var desc = $('#TexticdDesc').val()
                    var code = $('#TexticdCode').val()
                    $('#ICDGrid').datagrid('load',  { 
                        ClassName:"web.DHCBL.MKB.MKBStructuredData",
                        QueryName:"GetDataForCmb1",
                        desc:desc,
                        icd10:code
                    });	
                    $('#ICDGrid').datagrid('unselectAll')	
            
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
    //别名可编辑列表
    var editIndexOther = undefined;
    var rowsvalueOther=undefined;
    var oldrowsvalueOther=undefined;
    var oldrowsvalueOther="";
    var pycolumns =[[  
      {field:'ALIASRowId',title:'ALIASRowId',width:50,sortable:true,hidden:true,editor:'validatebox'},
      {field:'ALIASText',title:'别名',width:200,sortable:true,editor:'validatebox'}
     ]];    
    var comgrid = $HUI.datagrid("#comgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.MRCICDAlias",         ///调用Query时
            QueryName:"GetList"
        },
        //ClassTableName:'User.BDPTableList',
        //SQLTableName:'BDP_TableList',
        idField:'ALIASRowId',
        columns: pycolumns,  //列信息
        pagination: false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:15,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        remoteSort:false,  //定义是否从服务器排序数据。true
        onDblClickRow:function(rowIndex,rowData){
            DblClickFunOther(rowIndex,rowData)
        },
        onClickRow:function(rowIndex,rowData){
            $('#comgrid').datagrid('selectRow', rowIndex);
            //ClickFunOther();
        },
        onLoadSuccess:function(data){
        }
    });
    //用于单击非grid行保存可编辑行
    $(document).bind('click',function(){ 
        ClickFunOther();
    });
    $('#addo_btn').click(function (e){
        AddDataOther();

    });
    $('#delo_btn').click(function (e){
        //$('#knoExe').css('display','none'); 
        DelDataOther();
    });
    function DelDataOther(){
        var record=comgrid.getSelected();
        if(!record){
            $.messager.alert('提示','请选择一条记录！','error');
            return;
        }
        //console.log(mygrid.getSelected())
        if((record.ALIASRowId==undefined)||(record.ALIASRowId=="")){
            comgrid.deleteRow(editIndexOther)
            editIndexOther = undefined;
            return;
        }
        
        $.messager.confirm('确认','您要删除这条数据吗?',function(r){
            if(r){
                id=record.ALIASRowId;
                $.ajax({
                    url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDAlias&pClassMethod=DeleteData",
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
                            editIndexOther = undefined;
                            rowsvalueOther=undefined;
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
    function AddDataOther(){
        if(ClickFunOther('AddDataOther')==0){
            return
        }        
        oldrowsvalueOther=editIndexOther;
        ClickFunOther('AddDataOther')
        
        if (endEditingOther()){
            $('#comgrid').datagrid('insertRow',{index:0,row:{}});
            editIndexOther = 0;//$('#mygrid').datagrid('getRows').length-1;
            $('#comgrid').datagrid('selectRow', editIndexOther)
                    .datagrid('beginEdit', editIndexOther);
        }
        //AppendDom()
    }    
    function ClickFunOther(type){   //单击执行保存可编辑行
        if (endEditingOther()){
            //console.log(rowsvalueOther)
            if(rowsvalueOther!= undefined){
                if((rowsvalueOther.ALIASText!="")){
                    var rows = $('#comgrid').datagrid('getRows');//获取当前页的数据行    
                    for (var i = 0; i < rows.length; i++) {  
                        //total += rows[i]['SCORE']; //获取指定列
                        //alert(editIndexOther);
                        //alert(rows[i]['DataAlias']);
                        var valuerow = rows[i]['ALIASText'];
                        if (valuerow == rowsvalueOther.ALIASText && i != editIndexOther && editIndexOther!=undefined)
                        {
                            $.messager.alert('错误提示','别名重复！','error');
                            editIndexOther=undefined
                            /*$('#comgrid').datagrid('selectRow', editIndexOther)
                                .datagrid('beginEdit', editIndexOther);*/
                            var newEditIndex=$('#comgrid').datagrid('getRowIndex',$('#comgrid').datagrid('getSelected'));
                            comgrid.deleteRow(newEditIndex)                               
                            //AppendDom()
                            return                          
                        }
                    }                      
                    var differentflag="";
                    if(oldrowsvalueOther!= undefined){
                        var oldrowsvaluearr=JSON.parse(oldrowsvalueOther)
                        for(var params in rowsvalueOther){
                            if(oldrowsvaluearr[params]!=rowsvalueOther[params]){
                                differentflag=1
                            }
                        }
                    }
                    else{
                        differentflag=1
                    }
                    if(differentflag==1){
                        oldrowsvalueOther=editIndexOther
                        //SaveDataO (rowsvalueOther,type);
                    }
                    else{
                        //UpdataRow(rowsvalueOther,editIndexOther)
                        editIndexOther=undefined
                        rowsvalueOther=undefined
                    }
                }
                else{
                    //$.messager.alert('错误提示','别名不能为空！','error')
                    var newEditIndex=$('#comgrid').datagrid('getRowIndex',$('#comgrid').datagrid('getSelected'));
                    comgrid.deleteRow(newEditIndex)                    
                    $('.messager-window').click(stopPropagation)
                    /*$('#comgrid').datagrid('selectRow', editIndexOther)
                        .datagrid('beginEdit', editIndexOther);*/
                    //AppendDom()
                    return 0
                }
            }

        }
    }   
    function DblClickFunOther (index,row){   //双击激活可编辑   （可精简）
        
        if(index==editIndexOther){
            return
        }
        /*if((row!=undefined)&&(row.ALIASRowId!=undefined)){
            UpdataRow(row,index)
        }*/
        oldrowsvalueOther=editIndexOther
        if (editIndexOther != index){
            if (endEditingOther()){
                $('#comgrid').datagrid('selectRow', index)
                        .datagrid('beginEdit', index);
                editIndexOther = index;
            } else {
                $('#comgrid').datagrid('selectRow', editIndexOther);
            }
        }
        oldrowsvalueOther=JSON.stringify(row);   //用于和rowvalue比较 以判断是否行值发生改变
        //AppendDom()
    }
    function endEditingOther(){
        if (editIndexOther == undefined){return true}
        if ($('#comgrid').datagrid('validateRow', editIndexOther)){
            $('#comgrid').datagrid('endEdit', editIndexOther);
            rowsvalueOther=comgrid.getRows()[editIndexOther];    //临时保存激活的可编辑行的row   
            //editIndexOther = undefined;
            return true;
        } else {
            return false;
        }
    }
    //清除关联的icd
    $HUI.tooltip('#clean_icd',{
        content:"清除与诊断相关联的icd",
        position: 'bottom' //top , right, bottom, left
    });
    $('#clean_icd').click(function(e){
        var record = $('#leftgrid').datagrid('getSelected');
        var MKBSDMDr = "";
        var MKBSDMrc = "";
        var MKBSDICD = "";
        var resultIndex = $('#leftgrid').datagrid('getRowIndex',record)
        var result=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","EditUpdate",record.Rowid,"",MKBSDMDr,"","",record.MKBSDLocs);
        var data=eval('('+result+')');
        if(data.success=='true'){
            tkMakeServerCall("web.DHCBL.MKB.MKBStructIndex","DeleteIndex",record.MKBSDICD,record.Rowid);
            $.messager.popover({msg: '清除关联成功',type:'success',timeout: 1000});
            //tkMakeServerCall("web.DHCBL.MKB.MKBStructIndex","SingleSave",dataContainer.MKBSDICD,ICDRecord.Rowid);
        }
        $('#leftgrid').datagrid('getRows')[resultIndex].Rowid = data.id;
        $('#leftgrid').datagrid('getRows')[resultIndex].MKBSDMDr =  "";
        $('#leftgrid').datagrid('getRows')[resultIndex].MKBSDMrc = "";
        $('#leftgrid').datagrid('getRows')[resultIndex].MKBSDICD = "";
        $('#leftgrid').datagrid('refreshRow',resultIndex)
        loadViewTr(record);
    })

}

$(init);