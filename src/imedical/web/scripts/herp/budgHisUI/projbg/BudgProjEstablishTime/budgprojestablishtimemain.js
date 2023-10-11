var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){//初始化
    Init();
}); 

function Init(){
    var YMboxObj = $HUI.combobox("#YMbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
        }
    });
    // 责任科室的下拉框
    var DutyDRObj = $HUI.combobox("#DutyDR",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 3;
            param.str    = param.q;
        }
    });

    MainColumns=[[  
                {field:'ckbox',checkbox:true},//复选框
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'Year',title:'年度',width:80},
                {field:'DutyDeptDR',title:'责任科室ID',width:100,hidden: true},
                {field:'DCode',title:'责任科室编码',align:'left',width:120,hidden: true},
                {field:'DName',title:'责任科室',align:'left',width:80},
                {field:'StartDate',title:'编制开始时间',align:'left',width:120,
                    editor:{type:'datebox',options:{
                        required:'true'//,
                        // onSelect: function(date){
                        //     // console.log(date.getFullYear()+"/"+(date.getMonth()+1)+"/"+date.getDate())
                        //     var index = getRowIndex(this)
                        // }

                    }}
                },
                {field:'EndDate',title:'编制结束时间',align:'left',width:120,
                    editor:{type:'datebox',options:{
                        required:'true'//,
                        // onSelect: function(date){
                        //     // console.log(date.getFullYear()+"/"+(date.getMonth()+1)+"/"+date.getDate())
                        //     var end=date.getFullYear()+"/"+(date.getMonth()+1)+"/"+date.getDate();
                        //     var index = getRowIndex(this)
                        //     var ed = $('#MainGrid').datagrid('getEditor', {index:index,field:'StartDate'});
                        //     var tmp = $(ed.target).combobox('getValue');
                        //     // var datetmp=tmp.split("/")[2]+"-"+tmp.split("/")[1]+"-"+tmp.split("/")[0];
                        //     console.log(date+"^"+tmp);
                        //     if(date<tmp){
                        //         console.log(1)
                                
                        //     }else{
                        //         console.log(2)
                        //         $.messager.alert('提示', '开始时间不能大于结束时间！', 'info');
                        //     }
                        // }

                    }}
                }
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgPrjEstablishTime",
            MethodName:"List",
            hospid :    hospid, 
            Year :      "",
            DutyDeptDR: ""
        },
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        ctrlSelec:true, //在启用多行选择的时候允许使用Ctrl键+鼠标点击的方式进行多选操作
        // singleSelect: true, //只允许选中一行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        rowStyler: function(index,row){
            if(index%2==1){
                return 'background-color:#FAFAFA;';
            }
        },
        onClickCell: function(index,field,value){   //在用户点击一个单元格的时候触发
            if ((field=="StartDate")||(field=="EndDate")) {
               $('#MainGrid').datagrid('beginEdit', index); //索引为index的行开启编辑
            }
        },
        toolbar: '#tb'       
    });    
    //查询函数
    var FindBtn= function()
    {
        var year    = $('#YMbox').combobox('getValue'); // 申请年度
        var DutyDR  = $('#DutyDR').combobox('getValue'); // 责任科室
        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgPrjEstablishTime",
                MethodName:"List",
                hospid :    hospid, 
                Year :      year,
                DutyDeptDR: DutyDR
            })
    }

    //点击查询按钮 
    $("#FindBn").click(FindBtn);

    //保存 
    var saveOrder = function() {
        var rows = $('#MainGrid').datagrid("getSelections");
        var length=rows.length;
        var str="",rowid="",StartDate="",EndDate="",DutyDeptDR="",Year=""
        if(length<1){
            $.messager.alert('提示','请先选中至少一行数据!','info');
            return false;
        }else{
            var indexs=$('#MainGrid').datagrid('getEditingRowIndexs')
            if(indexs.length>0){
                for(i=0;i<indexs.length;i++){
                    $("#MainGrid").datagrid("endEdit", indexs[i]);
                }
            }
            for(var i=0; i<length; i++){
                var row = rows[i];
                rowid=row.rowid;
                Year=row.Year;
                DutyDeptDR=row.DutyDeptDR;
                if (!row.StartDate) {
                    var message = "编制开始时间不能为空!";
                    $.messager.alert('提示',message,'info');
                   return false;
                }
                if (!row.EndDate) {
                    var message = "编制结束时间不能为空!";
                    $.messager.alert('提示',message,'info');
                   return false;
                }
                StartDate=row.StartDate.split("/")[2]+"-"+row.StartDate.split("/")[1]+"-"+row.StartDate.split("/")[0];
                EndDate=row.EndDate.split("/")[2]+"-"+row.EndDate.split("/")[1]+"-"+row.EndDate.split("/")[0];                
                if(rowid==""){
                    $.m({
                        ClassName:'herp.budg.hisui.udata.uBudgPrjEstablishTime',MethodName:'InsertRec',Year:Year,StartDate:StartDate,EndDate:EndDate,DutyDeptDR:DutyDeptDR},
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
                        ClassName:'herp.budg.hisui.udata.uBudgPrjEstablishTime',MethodName:'UpdateRec',rowid:rowid,Year:Year,StartDate:StartDate,EndDate:EndDate,DutyDeptDR:DutyDeptDR},
                        function(Data){
                            if(Data==0){
                                $.messager.alert('提示','保存成功！','info');
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
    //点击保存按钮 
    $("#SaveBn").click(saveOrder);

    /**批量设置截止时间  开始**/
    var SetFun=function() {
        var $win;
        $win = $('#BtchWin').window({
            title: '设置项目明细编制时间',
            width: 320,
            height: 260,
            top: ($(window).height() - 260) * 0.5,
            left: ($(window).width() - 320) * 0.5,
            shadow: true,
            modal: true,
            iconCls: 'icon-save',
            closed: true,
            minimizable: false,
            maximizable: false,
            collapsible: false,
            resizable: true,
            onClose:function(){ //关闭关闭窗口后触发
                $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
            }
        });
        $win.window('open');
        // 年度的下拉框
        var BYMboxObj = $HUI.combobox("#BYMbox",{
            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
            mode:'remote',
            delay:200,
            valueField:'year',    
            textField:'year',
            value: new Date().getFullYear(),
            onBeforeLoad:function(param){
                param.str = param.q;
            }
        });
        // 责任科室的下拉框
        var BDutyDRObj = $HUI.combobox("#BDutyDR",{
            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
            mode:'remote',
            delay:200,
            valueField:'rowid',    
            textField:'name',
            onBeforeLoad:function(param){
                param.hospid = hospid;
                param.userdr = userid;
                param.flag   = 3;
                param.str    = param.q;
            }
        });

        //批量设置 
        $("#BtchSave").unbind('click').click(function(){
            var BStdate="",BEddate=""
            BStdate=$('#BStdate').datebox('getValue');
            BEddate=$('#BEddate').datebox('getValue');
            if (BStdate) {
                BStdate=BStdate.split("/")[2]+"-"+BStdate.split("/")[1]+"-"+BStdate.split("/")[0];
            }
            if (BEddate) {
                BEddate=BEddate.split("/")[2]+"-"+BEddate.split("/")[1]+"-"+BEddate.split("/")[0];
            }
            if (!BStdate) {
                var message = "开始时间不能为空!";
                $.messager.alert('提示',message,'info');
               return false;
            }
            if (!BEddate) {
                var message = "结束时间不能为空!";
                $.messager.alert('提示',message,'info');
               return false;
            }
            if (BStdate>BEddate) {
                var message = "开始时间不能大于结束时间!";
                $.messager.alert('提示',message,'info');
               return false;
            }
            $.m({
                ClassName:'herp.budg.hisui.udata.uBudgPrjEstablishTime',MethodName:'SetTime',Year:$('#BYMbox').combobox('getValue'),StartDate:BStdate,EndDate:BEddate,DutyDeptDR:$('#BDutyDR').combobox('getValue')},
                function(Data){
                    if(Data==0){
                        $.messager.alert('提示','设置成功！','info');
                    }else{
                        $.messager.alert('提示','错误信息:' +Data,'error');
                    }
                }
            );
            $win.window('close');
        });
        //取消 
        $("#BtchClose").unbind('click').click(function(){
            $win.window('close');
        });

    }
    $("#BatchBn").click(SetFun);   
    /**批量设置截止时间  结束**/


}