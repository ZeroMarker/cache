/**
Creator:Liu XiangSong
CreatDate:2018-08-25
Description:全面预算管理-指标预算管理-医疗指标维护
CSPName:herp.budg.hisui.budgtemp.csp
ClassName:herp.budg.hisui.udata.uBudgTemp,
herp.budg.udata.uBudgTemp
**/
var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){//初始化
    Init();
});

function Init(){
	var grid = $('#MainGrid');
// 年度的下拉框
    var YearboxObj = $HUI.combobox("#Yearbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
        }
    });
//  预算科室的下拉框
    var BudgDeptObj = $HUI.combobox("#BudgDeptbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
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
    			{field:'ckbox',checkbox:true,rowspan:2},//复选框 
		        {field:'',colspan:3,hidden:true},
		        {field:'IdxType',title:'指标类别',colspan:1,rowspan:2,width:80},
		        {field:'',colspan:1,hidden:true},
		        {field:'ItemName',title:'科目名称',colspan:1,rowspan:2,width:200},
		        {field:'UnitName',title:'单位',colspan:1,rowspan:2,width:40},
		        {field:'',title:'前年',colspan:2},
		        {field:'',title:'去年',colspan:4},
		        {field:'',title:'本年度',colspan:3}            
		        ],[
                {field:'rowid',title:'ID',width:80,hidden:true},
                {field:'CompName',title:'医疗单位',width:80,hidden:true},
                {field:'Year',title:'年度',width:80,width:80,hidden:true},
                {field:'ItemCode',title:'科目编码',width:120,hidden:true},
                {field:'PreLastPlanValue',title:'前年预算',width:120,align:'right',formatter:dataFormat},
                {field:'PreLastExeValue',title:'前年执行',width:120,align:'right',formatter:dataFormat},
                {field:'LastPlanValue',title:'预算',width:120,align:'right',formatter:dataFormat},
                {field:'Last9ExeValue',title:'1-9月执行',width:120,align:'right',formatter:dataFormat},
                {field:'Last10PlanValue',title:'10-12月预算',width:120,align:'right',formatter:dataFormat},
                {field:'diffrate1',title:'增长率(%)',align:'right',width:70},
                {field:'PlanValue',title:'预算',align:'right',width:120,formatter:dataFormat,
		    	    editor: { 
		                type: 'numberbox', 
		                options: { 
		                    precision:2
		                } 
		            }
		    	},
                {field:'diffrate2',title:'增长率(%)',align:'right',width:70},
                {field:'ChkDesc',title:'填报说明',width:120,
                    editor: { 
                        type: 'text'
                    }
                }
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgTemp",
            MethodName:"List",
            userid  : userid,
            Year    : "", 
            Dept    : "",
            ItemCode: ""
        },
        fitColumns: false,
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
    $("#FindBn").click(function(){
    	FindBtn()
    });
    var FindBtn= function()
    {
        var Year = $('#Yearbox').combobox('getValue');    
        var DeptDR = $('#BudgDeptbox').combobox('getValue');
        if(Year==""){
            var message ="请选择年度！";
            $.messager.popover({msg: message,type:'info'});
            return;
        }
        if(DeptDR==""){
            var message ="请选择科室！";
            $.messager.popover({msg: message,type:'info'});
            return;
        }
        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgTemp",
                MethodName:"List",
                userid  : userid,
	            Year    : Year, 
	            Dept    : DeptDR,
	            ItemCode: ""
        })
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
                            var rowid = row.rowid;
                            var PlanValue = row.PlanValue;
                            var ChkDesc = row.ChkDesc;
                            $.m({
                                ClassName:'herp.budg.udata.uBudgTemp',MethodName:'UpdateRec',rowid:rowid,PlanValue:PlanValue, ChkDesc:ChkDesc},
                                    function(Data){
                                        if(Data==0){
                                            $.messager.popover({msg: '保存成功！',type:'success'});
                                        }else{
                                            $.messager.popover({msg: "错误信息:"+Data,type:'error'});
                                        }                                                    
                                    }
                            );
                        }
                        grid.datagrid("reload");
                    }    
                }
            )
        }
    });

}

