/// 名称: 批处理方法
/// 描述: 执行批处理方法，进行数据的导入导出
/// 编写者: 基础数据平台组-张云越
/// 编写日期: 2019-08-20
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBBatchProcess&pClassMethod=SaveEntity&pEntityName=web.Entity.MKB.MKBBatchProcess";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBBatchProcess&pClassMethod=DeleteData";

var init = function(){
    $('#myWinpro').window('close'); //进度窗口会自动弹出
    //document.getElementById('#ExcelImportPath').innerHTML('D:\\');
/*******************************************工具条*********************************************************/
    //新增按钮
    $('#add_btn').click(function (e){
        AddData();
    });
    //修改按钮
    $('#update_btn').click(function (e){
        UpdateData();
    });
    //删除按钮
    $('#del_btn').click(function (e){
        DelData();
    });

    //查询按钮
    $("#btnSearch").click(function (e) { 
        SearchFunLib();
    }) 

    //重置按钮
    $("#btnRefresh").click(function (e) { 
        ClearFunLib();
    });

    //下载导入模板
    $('#btnTemplates').click(function (e){
        DownloadTemplates("LoadPath");
    });

    //执行导入导出
    $('#btnImEx').click(function (e){
        ImExData();
    });

    //搜索查询框
    $('#TextDesc').searchcombobox({ 
        url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename=User.MKBBatchProcess",
        onSelect:function () 
        {   
            $(this).combobox('textbox').focus();
            SearchFunLib();            
        }
    });
    
    //绑定键盘事件
    $('#TextDesc').combobox('textbox').bind('keyup',function(e){ 
        if(e.keyCode==13){ 
            SearchFunLib();
        }
        if(e.keyCode==27){
            ClearFunLib();
        }
    }); 

    //新增弹窗中方法类型下拉框
    $('#Flag').combobox({
        valueField:'id',
        textField:'text',
        data:[
            {id:'导入',text:'导入'},
            {id:'导出',text:'导出'},
            {id:'其他',text:'其他'}
        ]
    });
    
    //批处理导入模板下载按钮
    /*$("#LoadPath").click(function (e) {
        LoadMKBData("LoadPath");
    }) 

    //下载批处理模板
    function LoadMKBData(id)
    {
        var filepath=""
        if (id=="LoadPath"){
            filepath = "../scripts/bdp/App/Study/导入四版本ICD.xls"; //要写为相对路径
        }  
        var isExists=IsExistsFile(filepath)
        if(isExists){
            location.href=filepath;
        }else{
            $.messager.alert('提示','该文件不存在!',"error");
        }
    }*/

    //重置方法
    ClearFunLib=function()
    {
        $("#TextDesc").combobox('setValue', '');//清空检索框
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBBatchProcess",
            QueryName:"GetList"
        });
        $('#mygrid').datagrid('unselectAll');
    }

    //点击新增按钮
    AddData=function () {
        var record = mygrid.getSelected(); 
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
            },
            {
                text:'继续新增',
                id:'save_btnagain',
                handler:function(){
                    SaveFunLibT("")
                }
            },
            {
                text:'关闭',
                handler:function(){
                    myWin.close();
                }
            }]
        });
        $('#form-save').form("clear");     
    }



    //截串方法（用于传方法名到后台）
    function getMethod(obj){
        var index=obj.indexOf(")");
        obj=obj.substring(index+2,obj.length);
        var index=obj.indexOf("(");
        obj=obj.substring(0,index);
        return obj;
    }
        
    //双击事件
    DblClickGrid=function(rowIndex, rowData)
    {
        UpdateData()
    }

//查询方法
    SearchFunLib=function (){
        var desc=$.trim($('#TextDesc').combobox('getText'));
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.MKB.MKBBatchProcess",
            QueryName:"GetList",
            'desc':desc //方法描述或方法命令
        });
        $('#mygrid').datagrid('unselectAll');       
    }
/***********************************************************点击修改按钮***************************************************/
    UpdateData=function () {
        var record = $("#mygrid").datagrid("getSelected"); 
        if (record){    
             //调用后台openData方法给表单赋值
            var id = record.ID;
            $.cm({
                ClassName:"web.DHCBL.MKB.MKBBatchProcess",
                MethodName:"NewOpenData",
                id:id
            },function(jsonData){
                $('#form-save').form("load",jsonData); 
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
            });                       
        }else{
            $.messager.alert('错误提示','请先选择一条记录!',"error");
            return
        }
    
    }           
/******************************************************************新增和继续新增方法***********************************************************************/  
    ///新增、更新
    SaveFunLib=function(id)
    {            
        //alert($('#myWin').panel('options').title);                    
        var desc=$.trim($("#MethodDesc").val());
        var name=$.trim($("#MethodName").val());

        if (desc=="")
        {
            $.messager.alert('错误提示','方法描述不能为空!',"error");
            return;
        }
        if (name=="")
        {
            $.messager.alert('错误提示','方法命令不能为空!',"error");
            return;
        }

        $('#form-save').form('submit', { 
            url: SAVE_ACTION_URL,
            success: function (data) { 
                //alert(data);
                var data=eval('('+data+')'); 
                if (data.success == 'true') {
                    $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
                    $('#mygrid').datagrid('reload');  // 重新载入当前页面数据    
                    $('#myWin').dialog('close'); // close a dialog
                } 
                else { 
                    var errorMsg ="提交失败！"
                    if (data.errorinfo) {
                        errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
                    }
                    $.messager.alert('操作提示',errorMsg,"error");
                }
            } 
        });  
    }
    
    //继续新增
    SaveFunLibT=function(id)
    {            
        var desc=$.trim($("#MethodDesc").val());
        var name=$.trim($("#MethodName").val());
        if (desc=="")
        {
            $.messager.alert('错误提示','方法描述不能为空!',"error");
            return;
        }
        if (name=="")
        {
            $.messager.alert('错误提示','方法命令不能为空!',"error");
            return;
        }

        $('#form-save').form('submit', { 
            url: SAVE_ACTION_URL, 
            success: function (data) { 
                var data=eval('('+data+')'); 
                if (data.success == 'true') {
                    $('#form-save').form("clear");
                    $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
                    $('#mygrid').datagrid('reload');  // 重新载入当前页面数据    
                    //$('#myWin').dialog('close'); // close a dialog
                } 
                else { 
                    var errorMsg ="提交失败！"
                    if (data.errorinfo) {
                        errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
                    }
                    $.messager.alert('操作提示',errorMsg,"error");
                }
            } 
        });  
        
        
    }
/******************************************************删除方法**************************************************************************************************/
    ///删除
    DelData=function()
    {                  
        var row = $("#mygrid").datagrid("getSelected"); 
        if (!(row))
        {   
            $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        }
        var rowid=row.ID;
        $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
            if (r){
                $.ajax({
                    url:DELETE_ACTION_URL,  
                    data:{"id":rowid},  
                    type:"POST",   
                    //dataType:"TEXT",  
                    success: function(data)
                    {
                        var data=eval('('+data+')'); 
                        if (data.success == 'true') {
                            $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
                            $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
                            $('#mygrid').datagrid('unselectAll');  // 清空列表选中数据 
                        } 
                        else 
                        { 
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

/***********************************************************下载导入模板***************************************************************/
    //浏览器控制，只能ie下进行导入导出
    var Sys = {};
    function checkBrowser() {
        var ua = navigator.userAgent.toLowerCase();
        var s;
        (s = ua.match(/rv:([\d.]+)\) like gecko/)) ? Sys.ie = s[1]:
            (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
            (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
            (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
            (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
            (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
        //if(Sys.ie) alert("ie");
        //if(Sys.firefox) alert("firefox");
        //if(Sys.chrome) alert("chrome");
        //if(Sys.opera) alert("opera");
        //if(Sys.safari) alert("safari");
    }
    checkBrowser();
    DownloadTemplates=function()
    {      
        if(Sys.ie)
        {            
            var row = $('#mygrid').datagrid("getSelected");
            if (!(row))
            {   
                $.messager.alert('错误提示','请先选择一条导入方法!',"error");
                return;
            }else if(row.Flag!='导入')
            {
                $.messager.alert('错误提示','请选择导入方法!',"error");
                return;
            };
            var Desc=row.MethodDesc;
            //$.messager.confirm('提示', '确定要下载所选的方法的模板?', function(r){
            //    if(r){
            var filepath=""
            if (Desc.indexOf("导入ICD到各版本")!=-1){ //字符串包含
                filepath = "../scripts/bdp/MKB/Doc/Template/导入各版本ICD.csv"; //要写为相对路径
            }  
            if (Desc.indexOf("导入分词到各版本")!=-1){ //字符串包含
                filepath = "../scripts/bdp/MKB/Doc/Template/导入ICD对照界面的分词.csv"; //要写为相对路径
            } 
            var isExists=IsExistsFile(filepath)
            if(isExists){
                location.href=filepath;
            }else{
                $.messager.alert('提示','该文件不存在,请联系开发人员!',"error");
            }
        //    }
        //});
        }
        else /*************************************除ie外的浏览器给提示*********************************************/
        {
            var emsg="请在IE下操作，并在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!"
            $.messager.alert('提示',emsg,"error");
        }
    }

    function IsExistsFile(filepath)
    {
        var xmlhttp=new ActiveXObject("Microsoft.XMLHTTP"); //ie用
        xmlhttp.open("GET",filepath,false);
        xmlhttp.send();

        if(xmlhttp.readyState==4){   
            if(xmlhttp.status==200) return true; //url存在   
            else if(xmlhttp.status==404) return false; //url不存在   
            else return false;//其他状态   
        } 
    }

/******************************************************执行导入导出按钮**********************************************************************************/
    

    //导入按钮
    $("#ImportData").click(function (e) {
        ImportMKBData();
    }); 

    //点选择按钮时候获取路径
    doChange=function (file){
        var upload_file = $.trim($("#fileParth").val());    //获取上传文件
        $('#ExcelImportPath').val(upload_file);     //赋值给自定义input框
    }

    //导出按钮
    $('#ExportData').click(function (e){
        ExportMKBData();
    });

    //执行导入导出按钮
    ImExData = function(row)
    {
        //alert(row);
        //var row = $("#mygrid").datagrid("getSelected");       
        if (!(row))
        {   
            $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        }else if(row.Flag=='导入'){
            //$.messager.confirm("导入", "确定要导入数据吗?", function (r) {
                //if (r) {
            $(".load").attr("href","#");
            $(".load").removeAttr("download");
            $(".load").removeAttr("target");           
            var imkbclassname = "web.DHCBL.MKB.ImportMKBData";
            var method = getMethod(row.MethodName); //截方法名的串
            var IMPORT_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.ImportMKBData&pClassMethod="+method;
            $("#importWin").show();
            var importWin = $HUI.dialog("#importWin",{
                resizable:true,
                title:'批处理方法数据导入',
                modal:true,
                buttonAlign : 'center',
                buttons:[
                {
                    text:'关闭',
                    handler:function(){
                        importWin.close();
                    }
                }]
            });
            var path=""
            ImportMKBData = function()
            {
                path = $('#ExcelImportPath').val(); 
                $.ajax({
                        url:IMPORT_ACTION_URL,  
                        data:{"filePath":path},  
                        type:"POST",   
                        //dataType:"TEXT", 
                        error : function() {
                            $('#myWinpro').window('open');  
                                var progressText = "导入失败";
                                $('#pro').progressbar({
                                    text:progressText,
                                    value: 0
                                });  
                                $("#exportWin").window('close');
                                $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
                                $('#mygrid').datagrid('unselectAll');  // 清空列表选中数据 
                        }, 
                        success: function(data)
                        {       
                            if (data.indexOf("失败")!=-1){
                                  $('#myWinpro').window('open');
                                $('#pro').progressbar({
                                    text:"导入失败",
                                    value: 0
                                });                   
                            }else{
                                $('#myWinpro').window('open');  
                                var progressText = "导入成功!"  //,共导出"+data.sum+"条记录!";
                                $('#pro').progressbar({
                                    text:progressText,
                                    value: 100
                                });                                     
                            }                    
                            $("#importWin").window('close');
                            $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
                            $('#mygrid').datagrid('unselectAll');  // 清空列表选中数据         
                        }  
                    })                              
            }
            $('#form-save1').form("clear"); 
            $('#ExcelImportPath').val('D:\\Import');
               //} 
            //}); 
        }else if(row.Flag=='导出'){      
            var emkbclassname = "web.DHCBL.MKB.ExportMKBData";
            var method = getMethod(row.MethodName);
            var EXPORT_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.ExportMKBData&pClassMethod="+method;
            if(Sys.chrome)
            {
                var str=row.ArgValue
                if(str.indexOf("fileName")!=-1) //表格里参数值列要包含fileName
                {
                    //alert("1");
                    $(".load").removeAttr("href");
                    var filename = tkMakeServerCall("web.DHCBL.MKB.ExportMKBData",method+"Chrome");
                    if(filename!=""){   
                        //$.messager.progress('close');   
                        $(".load").attr("href","#");
                        $(".load").removeAttr("download");
                        $(".load").removeAttr("target");
                        filepath ="../scripts/bdp/MKB/DataExport/"+filename;
                        $(".load").attr("href",filepath);
                        $(".load").attr("download",filename);
                        //判断浏览器是否支持a标签 download属性
                        var isSupportDownload = 'download' in document.createElement('a');
                        if(isSupportDownload){
                            var fileType = filename.split(".")[filename.split(".").length-1];
                            if((fileType!="pdf")&&(fileType!="PDF")){
                                objIframe=document.createElement("IFRAME");
                                document.body.insertBefore(objIframe);
                                objIframe.outerHTML=   "<iframe   name=a1   style='width:0;hieght:0'   src="+$(".load").attr("href")+"></iframe>";
                                pic   =   window.open($(".load").attr("href"),"a1");
                                document.all.a1.removeNode(true)
                            }else{
                                alert("此浏览器使用另存下载");
                                $(".load").attr("target","_blank");
                            }
                        }
                    }else{
                        $.messager.alert("提示","导出失败,请联系开发人员！","error")
                        //$.messager.progress('close');
                    }
                }
                else
                {
                    $(".load").attr("href","#");
                    $(".load").removeAttr("download");
                    $(".load").removeAttr("target");
                    $.messager.alert('错误提示','该功能不支持在谷歌浏览器导出，请使用ie浏览器!',"error");
                    return; 
                }
            }
            else
            {
                $(".load").attr("href","#");
                $(".load").removeAttr("download");
                $(".load").removeAttr("target");
                $("#exportWin").show();
                var ExportWin = $HUI.dialog("#exportWin",{
                    resizable:true,
                    title:'批处理方法数据导出',
                    modal:true,
                    buttonAlign : 'center',
                    buttons:[
                    {
                        text:'关闭',
                        handler:function(){
                            ExportWin.close();
                        }
                    }]
                });               
                ExportMKBData = function()
                {
                    var Folder = $('#FilePath').val();
                    var FileName = $('#FileName').val();
                    if (FileName==""){//不需要输入文件名的导出
                        $.ajax({
                            url:EXPORT_ACTION_URL,  
                            data:{"filePath":Folder},  
                            type:"POST",   
                            //dataType:"TEXT", 
                            error : function() {
                                $('#myWinpro').window('open');  
                                    var progressText = "导出失败";
                                    $('#pro').progressbar({
                                        text:progressText,
                                        value: 0
                                    });  
                                    $("#exportWin").window('close');
                                    $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
                                    $('#mygrid').datagrid('unselectAll');  // 清空列表选中数据 
                            }, 
                            success: function(data)
                            {                           
                                    $('#myWinpro').window('open');  
                                    var progressText = "导出成功";
                                    $('#pro').progressbar({
                                        text:progressText,
                                        value: 100
                                    });  
                                    $("#exportWin").window('close');
                                    //$.messager.popover({msg: '导出成功，共导出'+data.info+'个文件！',type:'success',timeout: 1000});                              
                                    $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
                                    $('#mygrid').datagrid('unselectAll');  // 清空列表选中数据          
                            }  
                        })
                    }else{//需要输入文件名的导出
                        $.ajax({
                            url:EXPORT_ACTION_URL,  
                            data:{"filePath":Folder,"fileName":FileName},  
                            type:"POST",   
                            //dataType:"TEXT", 
                            error : function() {
                                $('#myWinpro').window('open');  
                                    var progressText = "导出失败";
                                    $('#pro').progressbar({
                                        text:progressText,
                                        value: 0
                                    });  
                                    $("#exportWin").window('close');
                                    $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
                                    $('#mygrid').datagrid('unselectAll');  // 清空列表选中数据 
                            }, 
                            success: function(data)
                            {       
                                    $('#myWinpro').window('open');  
                                    var progressText = "导出成功!";
                                    $('#pro').progressbar({
                                        text:progressText,
                                        value: 100
                                    });                                     
                                $("#exportWin").window('close');
                                $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
                                $('#mygrid').datagrid('unselectAll');  // 清空列表选中数据         
                            }  
                        })
                    }                
                    
                }
                $('#form-save2').form("clear"); 
                $('#FilePath').val('D:\\Export\\');     
            }           
            
        }else{
            $.messager.alert('错误提示','请选择导入或导出方法!',"error");
            return;
        }
    }

    //列表内的按钮操作
    ImExData1 = function()
    { 
        setTimeout(ImExData,100);
    }


    //知识库批处理管理主界面
    var columns=[[
        {field:'ID',title:'ID',width:80,sortable:true,hidden:true},
        {field:'MethodDesc',title:'方法描述',width:200,sortable:true,showTip:true},
        {field:'MethodName',title:'方法命令',width:400,sortable:true,showTip:true},
        {field:'ArgDesc',title:'参数描述',width:150,sortable:true,showTip:true},
        {field:'ArgValue',title:'参数值',width:150,sortable:true,showTip:true},
        {field:'Flag',title:'方法类型标志',width:150,sortable:true},
        {field:'opt',title:'操作',width:50,align:'center',
            formatter:function(value,row,index){   
                var rowStr = JSON.stringify(row);  //对象转字符串
                //var btn = "<a class='load' href='#'  onclick='ImExData("+rowStr+")' style='border:0px;cursor:pointer'>执行</a>"; 
                var btn = "<a class='load' href='#'  onclick='ImExData("+rowStr+")' style='border:0px;cursor:pointer'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/run.png' /></a>";   
                return btn;  
            }  
        }

    ]];

    var mygrid = $HUI.datagrid("#mygrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.MKBBatchProcess",         ///调用Query时
            QueryName:"GetList"
        },
        ClassTableName:'User.MKBBatchProcess',
        SQLTableName:'MKB_BatchProcess',
        idField:'ID',
        columns: columns,  //列信息
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        remoteSort:false,  //定义是否从服务器排序数据。true

        onDblClickRow:function(rowIndex,rowData){
            UpdateData();
        },

        onLoadSuccess:function(data){
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
            $(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }
    });
    ShowUserHabit('mygrid');
}
$(init);
