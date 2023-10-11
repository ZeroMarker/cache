var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){//初始化
    Init();
}); 

function Init(){

    //增加按钮
    var AddBtn={
        id: 'AddDetail',
        iconCls: 'icon-add',
        text: '增加',
        handler: function(){
            AddRow()  //增加一行函数
        }
    }
    //保存按钮
    var SaveBtn= {
        id: 'AddSave',
        iconCls: 'icon-save',
        text: '保存',
        handler: function(){
            if (checkBeforeSave() == true) {
                saveOrder(); //保存方法
            }else {
                return;
            }
        }
    }
    //删除按钮
    var DelBt= {
        id: 'DelBt',
        iconCls: 'icon-del-diag',
        text: '删除',
        handler: function(){
            
            if (ChkBefDel() == true) {
                Del();
            } else {
                return;
            }
        }
    }
    MainColumns=[[  
                {field:'ckbox',checkbox:true},//复选框
                {field:'rowid',width:80,hidden: true},
                {field:'CompName',width:150,hidden: true},
                {field:'code',width:150,
                   editor: { 
                        type: 'text', 
                        options: { 
                            required: true,
                            onChange: function(){
                                var index=getRowIndex(this);
                                $('#MainGrid').datagrid('selectRow', index);
                            }
                        } 
                    }
                },
                {field:'name',width:150,
                   editor: { 
                        type: 'text', 
                        options: { 
                            required: true,
                            onChange: function(){
                                var index=getRowIndex(this);
                                $('#MainGrid').datagrid('selectRow', index);
                            }
                        } 
                    }
                },
                {field:'IsValid',width:150,
                    formatter:function(value,row,index) {
                        if(value==0){
                            value="否"
                            return '<span>' + value + '</span>';
                        }
                        if(value==1){
                            value="是"
                            return '<span>' + value + '</span>';
                        }
                    },
                    editor: { 
                        type: 'combobox', 
                        options: { 
                            valueField:'rowid',
                            textField:'name',
                            data: [{
                                        'rowid': 0,
                                        'name': "否"
                                    },{
                                        'rowid': 1,
                                        'name': "是"
                            }],
                            required: true,
                            onSelect: function(rec){
                                var index=getRowIndex(this);
                                $('#MainGrid').datagrid('selectRow', index);
                            }
                        } 
                    }
                }
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgProjFundType",
            MethodName:"List",
            hospid :    hospid
        },
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        ctrlSelec:true, //在启用多行选择的时候允许使用Ctrl键+鼠标点击的方式进行多选操作
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        onClickCell: function(index,field,value){   //在用户点击一个单元格的时候触发
            $('#MainGrid').datagrid('beginEdit', index); //当前行开启编辑
        },
        toolbar: [AddBtn,'-',SaveBtn,'-',DelBt]          
    });    
    //增加一行方法
    function AddRow(){
            $("#MainGrid").datagrid("insertRow", {
                index: 0, // index start with 0
                row: {
                    rowid:'',
                    CompName:'',
                    code:'',
                    name:'',
                    IsValid:''
                }
            });
            $("#MainGrid").datagrid('selectRow', 0);
            //将新插入的那一行开户编辑状态
            $("#MainGrid").datagrid("beginEdit", 0);
    }
    /*保存前数据检查*/
    function checkBeforeSave(){
        var indexs=$('#MainGrid').datagrid('getEditingRowIndexs')
        if(indexs.length>0){
            for(i=0;i<indexs.length;i++){
                $("#MainGrid").datagrid("endEdit", indexs[i]);
                var rowsData = $('#MainGrid').datagrid('getRows');
                var data=rowsData[indexs[i]];
                var code=data.code;
                var name=data.name;
                var IsValid=data.IsValid;
                if (!code) {
                    var message = "资金类型编码不能为空!";
                    $.messager.alert('提示',message,'info');
                   return false;
                }
                if (!name) {
                    var message = "资金类型名称不能为空!";
                    $.messager.alert('提示',message,'info');
                   return false;
                }
                if (!IsValid) {
                    var message = "是否有效不能为空!";
                    $.messager.alert('提示',message,'info');
                   return false;
                }

            }
        }
        return true;
    }
    //保存 
    var saveOrder = function() {
        var rows = $('#MainGrid').datagrid("getSelections");
        var length=rows.length;
        var str="",rowid="",code="",name="",IsValid=""
        if(length<1){
            $.messager.alert('提示','请先选中至少一行数据!','info');
            return false;
        }else{
            for(var i=0; i<length; i++){
                var row = rows[i];
                rowid=row.rowid;
                code=row.code;
                name=row.name;
                IsValid=row.IsValid;               
                if(rowid==""){
                    $.m({
                        ClassName:'herp.budg.udata.uBudgProjFundType',MethodName:'InsertRec',code:code,name:name,IsValid:IsValid,hospid:hospid},
                        function(Data){
                            if(Data==0){
                                $.messager.alert('提示','保存成功！','info');
                            }else{
                                $.messager.alert('提示','错误信息:' +Data,'error');
                            }
                        }
                    );
                }else{
                    $.m({
                        ClassName:'herp.budg.udata.uBudgProjFundType',MethodName:'UpdateRec',rowid:rowid,code:code,name:name,IsValid:IsValid,CompName:hospid},
                        function(Data){
                            if(Data==0){
                                $.messager.alert('提示','修改成功！','info');
                            }else{
                                $.messager.alert('提示','错误信息:' +Data,'error');
                            }
                        }
                    );
                }
            }
            $('#MainGrid').datagrid("reload");       
        }        
    }
    function ChkBefDel() {
        var rows = $('#MainGrid').datagrid("getSelections");
        var length=rows.length;
        if(length<1){
            $.messager.alert('提示','请先选中至少一行数据!','info');
            return false;
        }
        return true;
    };
    function Del() {
        $.messager.confirm('确定','确定要删除选定的数据吗？',function(t){
            if(t){
                var index = "";
                var rows = $('#MainGrid').datagrid("getSelections");
                var length=rows.length;
                for(var i=0; i<length; i++){
                    var row = rows[i];
                    rowid=rows[i].rowid;
                    index=$('#MainGrid').datagrid("getRowIndex",rows[i]);   
                    if(rowid==""){
                        $('#MainGrid').datagrid("deleteRow",index);
                        $.messager.alert('提示','移除成功！','info');
                    }else{
                        $.m({
                            ClassName:'herp.budg.udata.uBudgProjFundType',MethodName:'Delete',rowid:rowid},
                            function(Data){
                                if(Data==0){
                                    $.messager.alert('提示','删除成功！','info');
                                }else{
                                    $.messager.alert('提示','错误信息:' +Data,'error');
                                }
                            }
                        );
                    }
                }
                $('#MainGrid').datagrid("reload");   
            } 
        })  
    }
    //点击保存按钮 
    $("#SaveBn").click(saveOrder);


}