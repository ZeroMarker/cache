/*
Creator:石萧伟
CreatDate:2017-03-07
Description:知识审核
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredBase&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBStructuredBase";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredBase&pClassMethod=DeleteData";

var init = function(){
    var columns =[[ 
            {field:'Rowid',width:100,title:'rowid',sortable:true,hidden:true},
            {field:'MKBSTBDesc',width:100,title:'名称',sortable:true},
            //{field:'MKBSTBICDDr',title:'ICD知识库dr',hidden:true,sortable:true,width:100},
            {field:'MKBSTBStrDr',title:'结构化模块dr',width:100,sortable:true,hidden:true},   
            //{field:'MKBSTBLocDr',title:'实际科室ID',sortable:true,width:100,hidden:true},
            //{field:'MKBSTBLoc',title:'实际科室',sortable:true,width:100},
            {field:'MKBSTBICD',title:'ICD配置',sortable:true,width:100},
            {field:'MKBSTBStr',title:'结构化配置',sortable:true,width:100},
            {field:'MKBSTBSource',title:'数据来源',sortable:true,width:100,
                formatter:function(value,row,index){
                    var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
                    return content;    
                }
        
            },
            {field:'MKBSTBODFlag',title:'标识',sortable:true,width:100},
            /*{field:'MKBSTBFlag',title:'当前医院',sortable:true,width:100,
                formatter:function(v,row,index){  
                    if(v=='N'){return '否';}
                    if(v=='Y'){return '是';}
                }
            },*/
            /*{field:'MKBSTBNonstandardFlag',title:'是否录入非标ICD诊断',sortable:true,width:100,
                formatter:function(v,row,index){  
                    if(v=='N'){return '否';}
                    if(v=='Y'){return '是';}
                }
            }*/

        ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.MKBStructuredBase",
            QueryName:"GetList"
        },
        columns: columns,  //列信息
        //frozenColumns:[[{field:'MKBKMDesc',title:'名称'}]],
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
        singleSelect:true,
        idField:'Rowid',
        ClassTableName:'User.MKBStructuredBase',
        SQLTableName:'MKB_StructuredBase', 
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        //scrollbarSize :15,
        remoteSort:false,
        //sortName:'MKBKMRowId',
        //sortOrder:'desc',
        onClickRow:function(index,row)
        {
        },
        onLoadSuccess:function(data){
            $(this).datagrid('columnMoving');
        },
        onDblClickRow:function(rowIndex,rowData){
            var menuid=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.stb."+rowData.Rowid);
            var parentid="" //tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.mtm");
            var menuimg="" //tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetIconByID",menuid);
            //判断浏览器版本
            var Sys = {};
            var ua = navigator.userAgent.toLowerCase();
            var s;
            (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
            (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
            (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
            (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
            (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
            //双击时跳转到对应界面
            //if(!Sys.ie){
            window.parent.closeNavTab(menuid)
    
            window.parent.showNavTab(menuid,rowData.MKBSTBDesc,'dhc.bdp.ext.sys.csp?BDPMENU='+menuid,parentid,menuimg)
    
        }        
    });

    $('#TextDesc').searchcombobox({ 
        url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename=User.MKBStructuredBase",
        onSelect:function () 
        {   
            $(this).combobox('textbox').focus();
            SearchFunLib()
            
        }
    });
    $('#TextDesc').combobox('textbox').bind('keyup',function(e){ 
        if(e.keyCode==13){ 
            SearchFunLib(); 
        }
    });
    $("#btnSearch").click(function (e) { 
            SearchFunLib();
    })           
    //重置按钮
    $("#btnRefresh").click(function (e) { 
            ClearFunLib();
     })
      //查询方法
    function SearchFunLib(){
        var desc=$("#TextDesc").combobox('getText');
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBStructuredBase",
            QueryName:"GetList",        
            'desc': desc
        });
        
    }
    //重置方法
    function ClearFunLib()
    {
        $("#TextDesc").combobox('setValue', '');
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBStructuredBase",
            QueryName:"GetList"
        });
        $('#mygrid').datagrid('unselectAll');
    } 
    /*//icd选项下拉框
    $('#MKBSTBICDDr').combobox({
        url:$URL+"?ClassName=web.DHCBL.MKB.MKBStructuredBase&QueryName=GetICDBaseList&ResultSetType=array&cat=1",
        valueField:'MKBTBRowId',
        textField:'MKBTBDesc'
    })*/
    //icd选项下拉框
    /*$('#MKBSTBLocDr').combobox({
        url:$URL+"?ClassName=web.DHCBL.MKB.MKBStructuredBase&QueryName=GetICDBaseList&ResultSetType=array&cat=2",
        valueField:'MKBTBRowId',
        textField:'MKBTBDesc'
    })*/
    //结构化诊断下拉框
    $('#MKBSTBStrDr').combobox({
        url:$URL+"?ClassName=web.DHCBL.MKB.MKBStructuredBase&QueryName=GetTermBaseList&ResultSetType=array",
        valueField:'MKBTBRowId',
        textField:'MKBTBDesc'

    });
    //数据类型下拉框
    var SelectType=""
    $("#MKBSTBODFlag").combobox({
        valueField:'id',
        textField:'text',
        data:[
            {id:'Diagnosis',text:'诊断'},
            {id:'Operation',text:'手术'}
        ]
    });

    /*********************************************数据来源配置开始************************************************* */   
    var indexExtendProConfig="";

    AddExtendProConfig=function(){
        if(indexExtendProConfig!==""){
               $('#mygridExtendProConfig').datagrid('endEdit', indexExtendProConfig);
            }
        $('#mygridExtendProConfig').datagrid('appendRow',{  
             ConfigName : "" 
        }) 
        var editIndex = $('#mygridExtendProConfig').datagrid('getRows').length - 1;
        indexExtendProConfig=editIndex
        $('#mygridExtendProConfig').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
        var editor = $('#mygridExtendProConfig').datagrid('getEditor', { index: editIndex, field: 'ConfigName' });
        if (editor) {
            editor.target.focus();
        } else {
            var editors = $('#mygridExtendProConfig').datagrid('getEditors', editIndex);
            if (editors.length) {
                editors[0].target.focus();
            }
        }
    }
    
        //知识库扩展属性配置项删除
    DelExtendProConfig=function(){
        var record = $("#mygridExtendProConfig").datagrid("getSelected"); 
        if (!(record))
        {   
            $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        }  else {
               $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
                if (r){ 
                    var index=$('#mygridExtendProConfig').datagrid('getRowIndex',record);
                    /*if ((record.ConfigNum!="")&(record.ConfigNum!="undefined")&(record.ConfigNum!=undefined)) //后台删除
                    {
                        var saveFlag =tkMakeServerCall("web.DHCBL.MKB.MKBTermBaseExtendPro","DeleteConfig",extendproid,index);
                        if(saveFlag=="true")
                        {
                            $.messager.alert('提示','删除成功!',"info");
                            //$('#mygridExtendProConfig').datagrid('reload');
                        }
                        else
                        {
                            $.messager.alert('错误提示',saveFlag,"error");
                        }
                    }*/
                    $('#mygridExtendProConfig').datagrid('deleteRow',index);
                    $('#mygridExtendProConfig').datagrid('clearSelections'); 
                }
            });
        }
    }

    $("#mygridExtendProConfig").datagrid({
        columns: [[  
          {field:'ConfigName',title:'配置来源名称',width:150,sortable:true,editor:{type:'validatebox'}}
          ]],  //列信息
        pagination: false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizePop,
        pageList:[5,10,12,15,20,25,30,50,75,100,200,300,500,1000], 
        singleSelect:true,
        idField:'ConfigName', 
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        remoteSort:false,  //定义是否从服务器排序数据。true
        toolbar:[{
            iconCls:'icon-add',
            text:'新增',
            id:'add_btn_ExtendProConfig',
            handler:AddExtendProConfig  
        },{
            iconCls:'icon-cancel',
            text:'删除',
            id:'del_btn_ExtendProConfig',
            handler:DelExtendProConfig
        }],
        onClickRow:function(rowIndex,rowData){
        },
        onClickCell:function(index, field, value){
        if(indexExtendProConfig!==""){
            $(this).datagrid('endEdit', indexExtendProConfig);
        }
        $(this).datagrid('beginEdit', index);
        $(this).datagrid('selectRow', index);
        indexExtendProConfig=index;
        },
        onAfterEdit:function(index, row, changes){
            if (row.ConfigName==""){
                $.messager.alert('错误提示','配置项名称不能为空!',"error");
                $('#mygridExtendProConfig').datagrid('deleteRow',index);
                return;
            }else{
                var record = $("#mygridExtendProConfig").datagrid("getSelected"); 
                var existFlag="";
                var dataConfig = $('#mygridExtendProConfig').datagrid('getRows');   
                for(var i =0; i< dataConfig.length;i++){  
                    if ((row.ConfigName==dataConfig[i].ConfigName)&(record!=dataConfig[i])){
                        existFlag="Y";                  
                    }   
                }  
                if (existFlag=="Y")
                    {
                        $.messager.alert('错误提示','该配置项已存在!',"error");
                        $('#mygridExtendProConfig').datagrid('deleteRow',index);
                    return;
                    }
            }
        }
    });
    /*if ((configJson!="")&(configJson!=undefined)){ //未保存后台配置项数据加载
        var data = $.parseJSON(configJson);  
        $('#mygridExtendProConfig').datagrid('loadData', data); //将数据绑定到datagrid  
    }else{ //已保存后台配置项数据加载
        $('#mygridExtendProConfig').datagrid({   
            url:$URL,
            queryParams:{
                ClassName:"web.DHCBL.MKB.MKBTermBaseExtendPro",         ///调用Query时
                QueryName:"GetConfigList",
                'rowid': extendproid
            }
        }); 
    }*/
    /*********************************************数据来源配置结束************************************************* */   

    //新增
    $('#add_btn').click(function(e){
        AddData();       
    })  
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
                id:'save_btn',
                handler:function(){
                    SaveFunLib("")
                }
            },{
                text:'关闭',
                handler:function(){
                    myWin.close();
                    //alert($("#MKBSTBFlag").checkbox('getValue'))
                }
            }]
        });
        //$HUI.checkbox("#MKBSTBFlag").setValue(false); 
        //$HUI.checkbox("#MKBSTBNonstandardFlag").setValue(false);  
        $('#form-save').form("clear");
        $('#mygridExtendProConfig').datagrid('loadData',{total:0,rows:[]});

       
    }
    //修改
    $('#update_btn').click(function(e){
        UpdateData();
    })
    //点击修改按钮
    UpdateData=function () {
        //$('#mygridExtendProConfig').datagrid('loadData', ''); 
        var record = mygrid.getSelected(); 
        if (record){    
             //调用后台openData方法给表单赋值
            var id = record.Rowid;
            $.cm({
                ClassName:"web.DHCBL.MKB.MKBStructuredBase",
                MethodName:"OpenData",
                id:id
            },function(jsonData){
                //给是否可用单独赋值             
                /*if (jsonData.MKBSTBFlag=="Y"){
                    $HUI.checkbox("#MKBSTBFlag").setValue(true);        
                }else{
                    $HUI.checkbox("#MKBSTBFlag").setValue(false);
                }*/

                /*if (jsonData.MKBSTBNonstandardFlag=="Y"){
                    $HUI.checkbox("#MKBSTBNonstandardFlag").setValue(true);     
                }else{
                    $HUI.checkbox("#MKBSTBNonstandardFlag").setValue(false);
                }*/

                //加载数据来源配置项
                var MKBSTBSource = jsonData.MKBSTBSource;
                var source = new Array();
                if(MKBSTBSource != ""){
                    for(var i = 0; i < MKBSTBSource.split(',').length; i ++){
                        source.push({"ConfigName":MKBSTBSource.split(',')[i]});
                    }    
                }
                $('#mygridExtendProConfig').datagrid('loadData',source);

                $('#form-save').form("load",jsonData);  
            });             
            
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
                        SaveFunLib(id)
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
    ///新增、更新
    function SaveFunLib(id)
    {
        var desc=$.trim($("#MKBSTBDesc").val());
        //var icd=$("#MKBSTBICDDr").combobox('getValue')
        //var loc=$("#MKBSTBLocDr").combobox('getValue')
        var result=$("#MKBSTBStrDr").combobox('getValue')
        var MKBSTBODFlagResult=$("#MKBSTBODFlag").combobox('getValue')
        if (desc=="")
        {
            $.messager.alert('错误提示','描述为空!',"error");
            return;
        }
        if (desc.length>100)
        {
            $.messager.alert('错误提示','描述长度不能超过100!',"error");
            return;
        }
        /*if (icd=="")
        {
            $.messager.alert('错误提示','ICD配置不能为空!',"error");
            return;
        }*/
        if (result=="")
        {
            $.messager.alert('错误提示','结构化配置不能为空!',"error");
            return;
        }
        if (MKBSTBODFlagResult=="")
        {
            $.messager.alert('错误提示','标识不能为空!',"error");
            return;
        }
        /*if (loc=="")
        {
            $.messager.alert('错误提示','实际科室配置不能为空!',"error");
            return;
        }*/        
        var active="N";
        //alert($('#MKBSTBFlag').checkbox('getValue'))
        /*if ($('#MKBSTBFlag').checkbox('getValue')) 
        {
            active="Y" ;
        }*/

        var ICDactive="N";
        //alert($('#MKBSTBFlag').checkbox('getValue'))
        /*if ($('#MKBSTBNonstandardFlag').checkbox('getValue')) 
        {
            ICDactive="Y" ;
        }*/

        /*if(active == "Y"){
            var result = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredBase","JusthaveY")
            if(result.split("*")[1] != id && result.split("*")[1] != ""){
                $.messager.alert('错误提示','<font color=red>'+result.split("*")[0]+'</font>已设置为当前医院，请检查!',"error");
                return;    
            }
        }*/
        $('#mygridExtendProConfig').datagrid('endEdit',$('#mygridExtendProConfig').datagrid('getRows').length-1);
        var source = $('#mygridExtendProConfig').datagrid('getRows');
        //console.log(source)
        var sourcedata = ""
        for(var i = 0; i<source.length; i++){
            if(sourcedata==""){
                sourcedata = source[i].ConfigName;
            }else{
                sourcedata = sourcedata + "," + source[i].ConfigName;
            }
        }

        $('#form-save').form('submit', {
            url: SAVE_ACTION_URL,
            onSubmit: function(param){
                param.Rowid = id;
                //param.MKBSTBFlag = active;
                param.MKBSTBSource = sourcedata;
                //param.MKBSTBNonstandardFlag = ICDactive;
            },
            success: function (data) {
                var data=eval('('+data+')');
                if (data.success == 'true') {
                    $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
                    $('#mygrid').datagrid('reload');  // 重新载入当前页面数据
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
    $('#del_btn').click(function(e){
        DelData()
    });
    //移除数据
    function DelData()
    {
        //更新
        var row = $("#mygrid").datagrid("getSelected"); 
        if (!(row))
        {   $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        }
        var rowid=row.Rowid;
        $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
            if (r){        
                $.ajax({
                    url:DELETE_ACTION_URL,  
                    data:{"id":rowid},  
                    type:"POST",    
                    success: function(data){
                              var data=eval('('+data+')'); 
                              if (data.success == 'true') {
                                 $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
                                 $('#mygrid').datagrid('reload');  // 重新载入当前页面数据
                                 $('#mygrid').datagrid('unselectAll');  // 清空列表选中数据  
                              } 
                              else { 
                                var errorMsg ="删除文件失败！"
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
     //拖拽和右键列
    ShowUserHabit('mygrid');
}
$(init);