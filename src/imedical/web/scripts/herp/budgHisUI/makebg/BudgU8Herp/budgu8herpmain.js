/**
Creator:Liu XiangSong
CreatDate:2018-08-25
Description:全面预算管理-预算执行管理-科室对照关系
CSPName:herp.budg.hisui.budgu8herp.csp
ClassName:herp.budg.hisui.udata.uU8Herp,
herp.budg.udata.uU8Herp
**/
var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){//初始化
    Init();
});

function Init(){
	var grid = $('#MainGrid');
// 数据来源的下拉框
    var DataboxObj = $HUI.combobox("#Databox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=DataFrom",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.flag   = 1;
            param.str = param.q;
        }
    });
// 科室类别
	var DeptTypeObj = $HUI.combobox("#DeptTypebox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=deptType",
        mode:'remote',
        delay:200,
        valueField:'name',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.str    = param.q;
        }
    });
//  预算科室的下拉框
    var BudgDeptObj = $HUI.combobox("#BudgDeptbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 1;
            param.str = param.q;
        }
    });
    var EndEditFun = function() {
        var indexs=grid.datagrid('getEditingRowIndexs')
        if(indexs.length>0){
            for(i=0;i<indexs.length;i++){
                grid.datagrid("endEdit", indexs[i]);
            }
        }
    }
    MainColumns=[[  
                {field:'ckbox',checkbox:true},
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'CompName',title:'医疗单位',width:80,hidden: true},
                {field:'SYSName',title:'数据来源',width:120,allowBlank:false,
                    editor:{
                        type:'combobox',
                        options:{
                            valueField:'code',
                            textField:'name',
                            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=DataFrom",
                            delay:200,
                            onBeforeLoad:function(param){
					            param.hospid = hospid;
					            param.flag   = 1;
					            param.str = param.q;
					        },
                            onSelect: function(rec){    
                                var rowIndex=getRowIndex(this);
                                grid.datagrid('getRows')[rowIndex]['SYSNo'] = rec.code;
                            }
                        }
                    }
                },
                {field:'TypeU',title:'对应类别',align:'left',width:120},
                {field:'CodeU',title:'对方科室编码',width:150,allowBlank:false,align:'right',
                	styler: function (value,row,index){
	                	if ((row.NameU).indexOf("新") != -1){
								return 'color:#e10601';
							}
	                	},
                    editor: { 
                        type: 'text'
                    }
                },
                {field:'NameU',title:'对方科室名称',width:150,allowBlank:false,
                	styler: function (value,row,index){
	                	if (value.indexOf("新") != -1){
								return 'color:#e10601';
							}
	                	},
                    editor: { 
                        type: 'text'
                    }                    
                },
                {field:'TypeH',title:'预算科室类别',width:120},
                {field:'CodeH',title:'预算科室编码',width:120,align:'right'},
                {field:'NameH',title:'预算科室名称',width:120,allowBlank:false,
                    editor:{
                        type:'combobox',
                        options:{
                            valueField:'code',
                            textField:'name',
                            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
                            delay:200,
                            onBeforeLoad:function(param){
                                param.hospid = hospid;
                                param.userdr = userid;
                                param.flag   = 1;
                                param.str = param.q;
                            },
                            onSelect: function(rec){   
                                var rowIndex=getRowIndex(this);
                                var row = grid.datagrid('getRows')[rowIndex];
                                row['CodeH'] = rec.code;
                            }
                        }
                    }
                },
                {field:'DTypeName',title:'执行部门类别',width:120,
                    editor:{
                        type:'combobox',
                        options:{
                            valueField:'rowid',
                            textField:'name',
                            mode: 'local',
                            data: [{
                                    rowid: '1',
                                    name: '门诊'
                                }, {
                                    rowid: '2',
                                    name: '住院'
                                }, {
                                    rowid: '3',
                                    name: '管理'
                                }, {
                                    rowid: '4',
                                    name: '医技'
                                }, {
                                    rowid: '5',
                                    name: '其他'
                                }
                            ],
                            onSelect: function(rec){    
                                var rowIndex=getRowIndex(this);
                                grid.datagrid('getRows')[rowIndex]['DTypeID'] = rec.rowid;
                            }
                        }
                    }
                },
                {field:'flag',title:'标记',width:80,hidden: true}
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uU8Herp",
            MethodName:"List",
            hospid :    hospid, 
            codeU  :    "",
            codeH  :    "",
            typeH  :   "",
            SYSNo  :   ""
        },
        fitColumns: true,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        singleSelect:false,
        rownumbers:true,//行号
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        onClickRow:function(rowIndex, rowData){
            EndEditFun();
            grid.datagrid('beginEdit', rowIndex);
        },
        toolbar: '#tb'     
    }); 
    //查询函数
    var FindBtn= function()
    {
        var CodeU = $('#Targetbox').val();    //对方系统科目
        var TypeH = $('#DeptTypebox').combobox('getValue');
        var CodeH = $('#BudgDeptbox').combobox('getValue');
        var SYSNo = $('#Databox').combobox('getValue');
        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uU8Herp",
                MethodName:"List",
                hospid :    hospid, 
                codeU  :    CodeU,
                codeH  :    CodeH,
                typeH  :    TypeH,
                SYSNo  :    SYSNo,
        })
    }
    //查询功能
    $("#FindBn").click(function(){
	    FindBtn()
	    })
    //增加功能
    $('#AddBn').click(function(){
        AddRow();
    });
    //增加一行
    var AddRow = function(row){
        EndEditFun();
        var editRow = undefined;
        var items = {
                rowid:'',
                CompName:'',
                SYSName:'',
                TypeU:'',
                CodeU:'',
                NameH:'',
                DTypeName:'',
                flag:'',
                NameU: ''
            };
        append(grid,items,editRow);
    }   
    /***********************保存函数*************************/
    //保存按钮
    $("#SaveBn").click(function(){
        EndEditFun();
        //取到发生变化的记录对象
        var rows = grid.datagrid("getChanges");
        var row="",data="";
        if(!rows.length){
            $.messager.alert('提示','没有内容需要保存！','info');
            return false;
        }else{
            $.messager.confirm('确定','确定要保存数据吗？',
                function(t){
                    if(t){
                        for(var i=0; i<rows.length; i++){
                            row=rows[i];
                            if (CheckDataBeforeSave(row) == true) {
                                var rowid = row.rowid;
                                var NameU = row.NameU;
                                var CodeU = row.CodeU;
                                var CodeH = row.CodeH;
                                var SYSNo = row.SYSNo;
                                var TypeU = "科室"
                                var DTypeID = row.DTypeID;
                                if (rowid == "") {
                                    $.m({
                                        ClassName:'herp.budg.hisui.udata.uU8Herp',MethodName:'InsertRec',CodeU:CodeU, NameU:NameU, CodeH:CodeH,  SYSNo:SYSNo, TypeU:TypeU, DTypeID:DTypeID},
                                            function(Data){
                                                if(Data==0){
                                                    $.messager.popover({msg: '插入成功！',type:'success'});
                                                }else if(Data=="RepCode"){
                                                    $.messager.popover({msg: "编码重复，已存在相应编码的对应关系",type:'error'});
                                                }else{
                                                    $.messager.popover({msg: "错误信息:"+Data,type:'error'});
                                                }                                                                                                   
                                            }
                                    ); 
                                } else {
                                    $.m({
                                        ClassName:'herp.budg.hisui.udata.uU8Herp',MethodName:'UpdateRec',rowid:rowid,CodeU:CodeU, NameU:NameU, CodeH:CodeH, SYSNo:SYSNo, TypeU:TypeU, DTypeID:DTypeID},
                                            function(Data){
                                                if(Data==0){
                                                    $.messager.popover({msg: '修改成功！',type:'success'});
                                                }else if(Data=="RepCode"){
                                                    $.messager.popover({msg: "编码重复，已存在相应编码的对应关系",type:'error'});
                                                }else{
                                                    $.messager.popover({msg: "错误信息:"+Data,type:'error'});
                                                }                                                    
                                            }
                                    );
                                }
                            }else {
                                continue;
                            }
                        }
                        grid.datagrid("reload");
                    }    
                }
            )
        }
    });
    function CheckDataBeforeSave(row) { 
        var fields=grid.datagrid('getColumnFields') 
        for (var j = 0; j < fields.length; j++) {
            var field=fields[j];
            var tmobj=grid.datagrid('getColumnOption',field);  
            if (tmobj != null) {
                var reValue="";
                reValue=row[field];
                if(reValue == undefined){
                    reValue = "";
                }
                if (tmobj.allowBlank == false) {
                    var title = tmobj.title;
                    if ((reValue== "")||(reValue == undefined)||(parseInt(reValue) == 0)) {
                        var info =title + "列为必填项，不能为空或零！";
                        $.messager.popover({msg: info,type:'error'});
                        return false;
                    }
                }
            }
        }
        return true;     

    }
    /***********************删除函数*************************/
    //删除按钮
    $("#DelBn").click(function(){
        var rows = grid.datagrid("getSelections");
        if (CheckDataBeforeDel(rows) == true) {
            del(grid,"herp.budg.udata.uU8Herp","Delete")
        } else {
            return;
        }
    });
    function CheckDataBeforeDel(rows) {
        if(!rows.length){
            $.messager.popover({msg: '请选中需要删除的数据！',type:'info'});
            return false;
        }
        return true;
    };
    //Excel导入
    $("#ImportBn").click(function(){
      addimportFun();
    })
}

