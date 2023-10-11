/**
Creator:Liu XiangSong
CreatDate:2018-08-25
Description:全面预算管理-预算编制准备-全院预算分解方法设置（年度-月）
CSPName:herp.budg.hisui.budgschemsplityearmonth.csp
ClassName:herp.budg.hisui.udata.uBudgSchemSplitYearMonth,
herp.budg.udata.uBudgSchemSplitYearMonth,
herp.budg.udata.uBudgSpilt
**/
var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){//初始化
    Init();
}); 

function Init(){
	
    var splitmethdata=[{'rowid': 1,'name': "历史数据"},
                {'rowid': 2,'name': "历史数据*调节比例"},  
                {'rowid': 3,'name': "比例系数"},  
                {'rowid': 4,'name': "全面贯彻"},  
                {'rowid': 5,'name': "均摊"}]  
    //预算年度
    var YearboxObj = $HUI.combobox("#Yearbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.flag="";
            param.str = param.q;
        },
        onChange:function(n,o){
            if(n!=o){
                $('#Schembox').combobox('clear');
                $('#Schembox').combobox('reload'); 
            }
        }
    });
    // 预算方案的下拉框Schembox
    var SchemboxObj = $HUI.combobox("#Schembox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=BudgSchem",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 1;
            param.year   = $("#Yearbox").combobox("getValue");
            param.str    = param.q;
        },
        onShowPanel:function(){
            if($('#Yearbox').combobox('getValue')==""){
                $(this).combobox('hidePanel');
                $.messager.popover({msg: '请先选择预算年度！',type:'info'});
                return false;
            }
        },
        onSelect:function(data){
	        var year    = $('#Yearbox').combobox('getValue'); 
        	//var SchemDR = $('#Schembox').combobox('getValue'); // 预算方案
        	var IBigType= $('#IBigType').combobox('getValue'); // 预算项大类
        	var IType   = $('#ITypebox').combobox('getValue'); // 预算项类别
        	var ItemCode= $('#Itembox').val();  // 预算项编码
        	if(!year){
            	$.messager.popover({msg: '请先选择预算年度！',type:'info'});
            	return false;
        	}
        	MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemSplitYearMonth",
                MethodName:"List",
                hospid :    hospid, 
                Year   :    year,
                BSMName:    data.rowid,
                Code   :    ItemCode,
                BITName:    IType,
                BIDTypeFirstName:IBigType
        	})
     	}
    });
    // 预算项大类的下拉框
    var IBigTypeObj = $HUI.combobox("#IBigType",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        data: [{
                    'rowid': 1,
                    'name': "会计科目"
                },{
                    'rowid': 2,
                    'name': "医疗指标"                
        }],
        onSelect:function(data){
	        var year    = $('#Yearbox').combobox('getValue'); 
        	var SchemDR = $('#Schembox').combobox('getValue'); // 预算方案
        	//var IBigType= $('#IBigType').combobox('getValue'); // 预算项大类
        	var IType   = $('#ITypebox').combobox('getValue'); // 预算项类别
        	var ItemCode= $('#Itembox').val();  // 预算项编码
        	if(!year){
            	$.messager.popover({msg: '请先选择预算年度！',type:'info'});
            	return false;
        	}
        	if(!SchemDR){
            	$.messager.popover({msg: '请先选择预算方案！',type:'info'});
            	return false;
        	}
        	MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemSplitYearMonth",
                MethodName:"List",
                hospid :    hospid, 
                Year   :    year,
                BSMName:    SchemDR,
                Code   :    ItemCode,
                BITName:    IType,
                BIDTypeFirstName:data.rowid
        	})
     	}
     });
	// 预算项类别的下拉框
    var ITypeboxObj = $HUI.combobox("#ITypebox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemType",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.flag   = 1;
            param.str    = param.q;
        },
        onSelect:function(data){
	        var year    = $('#Yearbox').combobox('getValue'); 
        	var SchemDR = $('#Schembox').combobox('getValue'); // 预算方案
        	var IBigType= $('#IBigType').combobox('getValue'); // 预算项大类
        	//var IType   = $('#ITypebox').combobox('getValue'); // 预算项类别
        	var ItemCode= $('#Itembox').val();  // 预算项编码
        	if(!year){
            	$.messager.popover({msg: '请先选择预算年度！',type:'info'});
            	return false;
        	}
        	if(!SchemDR){
            	$.messager.popover({msg: '请先选择预算方案！',type:'info'});
            	return false;
        	}
        	MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemSplitYearMonth",
                MethodName:"List",
                hospid :    hospid, 
                Year   :    year,
                BSMName:    SchemDR,
                Code   :    ItemCode,
                BITName:    data.code,
                BIDTypeFirstName:IBigType
        	})
     	}
    });
                                    
    MainColumns=[[  
                {field:'ck',checkbox:true},
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'CompName',title:'医疗单位',width:80,hidden: true},
                {field:'bidyear',title:'预算年度',width:80},
                {field:'bidcode',title:'预算项编码',width:120},
                {field:'bidname',title:'预算项名称',width:200},
                {field:'bssmsplitmeth',title:'分解方法设置',width:150,allowBlank:false,
                    formatter:comboboxFormatter,
                    editor:{
                        type:'combobox',
                        options:{
                            valueField:'rowid',
                            textField:'name',
                            data: splitmethdata
                        }
                    }
                },
                {field:'coefficient',title:'调解比例系数',width:120,
                formatter:function(value,row,index){
                    var islast = row.bidislast;
                    var ID = row.rowid;
                    var tmpvalue="维护数据"
                    if ((islast == 1) && (ID != "")) {
                        return '<a href="#" class="grid-td-text" onclick=DetailFun('+ID+')>' + tmpvalue + '</a>';
                        // return '<span class="grid-td-text">维护数据</span>';
                    } else {
                        '<span></span>';
                    }
                }},
                {field:'bidislast',title:'是否末级',width:80,hidden: true}

            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchemSplitYearMonth",
            MethodName:"List",
            hospid :    hospid, 
            Year   :    "",
            BSMName:    "",
            Code   :    "",
            BITName:    "",
            BIDTypeFirstName:""
        },
        fitColumns: true,
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        // singleSelect: true, //只允许选中一行
        pageSize:20,
        pageList:[10,20,30,50,100], 
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        onClickCell: function(index,field,value){   
            $('#MainGrid').datagrid('selectRow', index);
            var rowsData = $('#MainGrid').datagrid('getRows');
            var data = rowsData[index];
            var IsLast = data.bidislast;
            if ((field=="bssmsplitmeth")&&(IsLast==1)){
                $('#MainGrid').datagrid('beginEdit', index);
            }
        },
        toolbar: '#tb'       
    });    

    //查询函数
    var FindBtn= function()
    {
        var year    = $('#Yearbox').combobox('getValue'); 
        var SchemDR = $('#Schembox').combobox('getValue'); // 预算方案
        var IBigType= $('#IBigType').combobox('getValue'); // 预算项大类
        var IType   = $('#ITypebox').combobox('getValue'); // 预算项类别
        var ItemCode= $('#Itembox').val();  // 预算项编码
        if(!year){
            $.messager.popover({msg: '请先选择预算年度！',type:'info'});
            return false;
        }
        if(!SchemDR){
            $.messager.popover({msg: '请先选择预算方案！',type:'info'});
            return false;
        }
        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemSplitYearMonth",
                MethodName:"List",
                hospid :    hospid, 
                Year   :    year,
                BSMName:    SchemDR,
                Code   :    ItemCode,
                BITName:    IType,
                BIDTypeFirstName:IBigType
            })
    }
    //点击查询按钮 
    $("#FindBn").click(FindBtn);
    //分解方法+调节比例
    $("#BtchBn").click(function(){
        batchEditFun(splitmethdata);
    }) 
    //保存按钮
    $("#SaveBn").click(function(){
        var grid = $('#MainGrid');
        var indexs=grid.datagrid('getEditingRowIndexs')
        if(indexs.length>0){
            for(i=0;i<indexs.length;i++){
                grid.datagrid("endEdit", indexs[i]);
            }
        }
        var rows = grid.datagrid("getChanges");
        var rowIndex="",row="";
        if(rows.length>0){
            $.messager.confirm('确定','确定要保存选定的数据吗？',function(t){
                if(t){
                    for(var i=0; i<rows.length; i++){
                        row=rows[i];
                        rowIndex = grid.datagrid('getRowIndex', row);
                        grid.datagrid('endEdit', rowIndex);
                        if (checkBeforeSave(grid,row) == true) {
                            saveOrder(row); //保存方法
                        }else {
                            continue;
                        }
                    }
                    grid.datagrid("reload");
                }
            })
        }
    })
    //保存前检查函数
    function checkBeforeSave(grid,row){ 
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
                    if ((reValue== "")||(reValue = undefined)||(parseInt(reValue) == 0)) {
                        var info =title + "列为必填项，不能为空或零！";
                        $.messager.popover({msg:info,type:'error'});
                        return false;
                    }
                }
            }
        }
        return true;
    }
    //保存方法
    var saveOrder=function(row) {       
        $.m({
            ClassName:'herp.budg.udata.uBudgSchemSplitYearMonth',MethodName:'UpdateRec',hospid:hospid,rowid:row.rowid,
                bidyear:row.bidyear,bidcode:row.bidcode,bssmsplitmeth:row.bssmsplitmeth,bidislast:row.bidislast},
                function(Data){
                    if(Data==0){
                        $.messager.popover({msg:'保存成功！',type:'success'});
                    }else{
                        $.messager.popover({msg:"错误:"+Data,type:'error'});
                    }
                }
        );            
    }

}