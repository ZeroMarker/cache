/**
Creator:Liu XiangSong
CreatDate:2018-08-25
Description:全面预算管理-预算执行管理-科目执行维护
CSPName:herp.budg.hisui.budgfactrealmonthdetail.csp
ClassName:herp.budg.hisui.udata.uBudgFactRealMonthDetail,
herp.budg.udata.uBudgFactRealMonthDetail
**/
var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){//初始化
    Init();
}); 

function Init(){

    var grid = $('#MainGrid');
    var YMboxObj = $HUI.combobox("#YMbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.flag = 1;
            param.str = param.q;
        },
        onChange:function(n,o){
            if(n!=o){
                $('#Itembox').combobox('clear');
                $('#Itembox').combobox('reload'); 
            }
        }
    });               

// 科室名称的下拉框
    var DeptboxObj = $HUI.combobox("#Deptbox",{
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
// 数据来源的下拉框
    var DataboxObj = $HUI.combobox("#Databox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=DataFrom",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.flag   = 1;
            param.str = param.q;
        }
    });
// 科目分类的下拉框
    var ItemTypeboxObj = $HUI.combobox("#ItemTypebox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemType",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.flag = 1;
            param.str = param.q;
        }
    });
// 科目名称的下拉框
    var ItemboxObj = $HUI.combobox("#Itembox",{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgFactRealMonthDetail&MethodName=ItemName",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.yearmonth = $('#YMbox').combobox('getValue');
            param.str = param.q;
        }
    });

    //增加按钮
    $("#AddBn").click(function(){
        AddRow()  //增加一行函数
    });
   //保存按钮
    $("#SaveBn").click(function(){
        EndEditFun();
        //取到发生变化的记录对象
        var rows = grid.datagrid("getChanges");
        var row="",data="";
        console.log(rows.length);
        if(!rows.length){
            $.messager.popover({msg: '没有内容需要保存！',type:'info'});
            return false;
        }else{
            $.messager.confirm('确定','确定要保存数据吗？',
                function(t){
                    if(t){
                        for(var i=0; i<rows.length; i++){
                            row=rows[i];
                            if (CheckDataBeforeSave(row) == true) {
                                var rowid = row.rowid;
                                var yearmonth = row.yearmonth;
                                var deptdr = row.deptdr;
                                var itemcode = row.itemcode;
                                var value = row.value;
                                var datafrom = row.datafrom;

                                var dataStr = rowid + "^" + yearmonth + "^" + deptdr
                                     + "^" + itemcode + "^" + value + "^" + datafrom
                                if (data == "") {
                                    data = dataStr;
                                } else {
                                    data = data + "|" + dataStr;
                                }
                            }else {
                                continue;
                            }
                        }
                        if(data!=""){
                            saveOrder(data); //保存方法
                            grid.datagrid("reload");
                        }                        
                    }    
                }
            )
        }
    });
    
    //删除按钮
    $("#DelBn").click(function(){
        var rows = grid.datagrid("getSelections");
        if (CheckDataBeforeDel(rows) == true) {
            del(rows)
        } else {
            return;
        }
    });
    //审核按钮
    $("#CheckBn").click(function(){
        var rows = grid.datagrid("getSelections");
        if (CheckDataBeforeAudit(rows) == true) {
            Audit(rows)
        } else {
            return;
        }
    });
    //取消审核按钮
    $("#UnCheckBn").click(function(){
        var rows = grid.datagrid("getSelections");
        if (CheckDataBeforeNoAudit(rows) == true) {
            NoAudit(rows)
        } else {
            return;
        }
    });
    //统计计算按钮
    $("#ChartSumBn").click(function(){
        if (CheckDataBeforeCalculate() == true) {
            Calculate()
        } else {
            return;
        }
    });
    //按年统计按钮
    $("#ChartYearBn").click(function(){
        if (CheckDataBeforeCalculate() == true) {
            YearCalculate();
        } else {
            return;
        } 
    });
    //执行数据重新导入按钮
    $("#ImportResetBn").click(function(){
        if (CheckBeforeExeData() == true) {
            ExeData();
        } else {
            return;
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
                {field:'ckbox',checkbox:true},//复选框
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'compname',title:'医疗单位',width:100,hidden: true},
                {field:'yearmonth',title:'年月',width:80,align:'right',allowBlank:false,
					editor:{
						type:'combobox',
						options:{
							valueField:'year',
							textField:'year',
                            mode:'remote',
							url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
							delay:200,
		                    onBeforeLoad:function(param){
					            param.flag = 1;
            					param.str = param.q;
					        },
		                    onSelect: function(rec){   
		                        var rowIndex=getRowIndex(this);
		                        YearSelect(rec.year,rowIndex); 
		                    },                             
                            required:true
						}
					}
		        },
                {field:'deptdr',title:'科室ID',width:80,allowBlank:false,hidden: true},
                {field:'deptname',title:'科室名称',width:150,allowBlank:false,
					editor:{
						type:'combobox',
						options:{
							valueField:'rowid',
							textField:'name',
                            mode:'remote',
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
                                var depttd=$('.datagrid-body td[field="deptdr"]')[rowIndex];
                                var depttarget = $(depttd).find('div')[0];
                                var row = grid.datagrid('getRows')[rowIndex]
                                row['deptdr'] = rec.rowid;
                            },                             
                            required:true
						}
					}
		        },
                {field:'itemcode',title:'科目编码',width:120,align:'right',hidden: true},
                {field:'itemname',title:'科目名称',width:200,allowBlank:false,
					editor:{
						type:'combobox',
						options:{
							valueField:'rowid',
							textField:'name',
                            mode:'remote',
							url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgFactRealMonthDetail&MethodName=ItemName",
							delay:200,
		                    onBeforeLoad:function(param){
					            param.hospid = hospid;
					            param.str = param.q;
					        },
                            onSelect: function(rec){   
                                var rowIndex=getRowIndex(this);
                                var itemtd=$('.datagrid-body td[field="itemcode"]')[rowIndex];
                                var itemtarget = $(itemtd).find('div')[0];
                                var row = grid.datagrid('getRows')[rowIndex];
                                row['itemcode'] = rec.rowid;
                            },                             
                            required:true
						}
					}
		        },
                {field:'datafrom',title:'数据来源ID',width:120,allowBlank:false,hidden: true},
                {field:'datafromco',title:'数据来源编码',width:120,align:'right',hidden: true},
                {field:'datafromna',title:'数据来源',width:120,
					editor:{
						type:'combobox',
						options:{
							valueField:'rowid',
							textField:'name',
                            mode:'remote',
							url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=DataFrom",
							delay:200,
		                    onBeforeLoad:function(param){
					            param.hospid = hospid;
					            param.flag   = 1;
					            param.str = param.q;
					        },
                            onSelect: function(rec){   
                                var rowIndex=getRowIndex(this);
                                var datatd=$('.datagrid-body td[field="datafrom"]')[rowIndex];
                                var datatarget = $(datatd).find('div')[0];
                                var row = grid.datagrid('getRows')[rowIndex]
                                row['datafrom'] = rec.rowid;
                            }
						}
					}
		        },
                {field:'value',title:'执行金额',width:120,align:'right',allowBlank:false,formatter:dataFormat,
                    editor: { 
                        type: 'numberbox', 
                        options: { 
                            precision:2,                             
                            required:true
                        } 
                    }
                },
                {field:'chkstate',title:'审核状态',width:90,
                    formatter:function(value,row,index){
                        if (value == 0) {
                            return '<span>未审核</span>';
                        } 
                        if(value == 1) {
                            return '<span>已审核</span>';
                        }
                    }
                },
                {field:'oprator',title:'操作员',width:120},
                {field:'optime',title:'操作时间',align:'right',width:100}
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgFactRealMonthDetail",
            MethodName:"List",
            hospid :    hospid, 
            yearmonth: "",
            deptdr :    "",
            datafrom:   "",
            typecode:   "",
            itemcode:   ""
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
        onBeforeEdit:function(rowIndex, rowData){
            if (rowData.datafromco== "MI"||rowData.datafromco== "") {
                return true;
            } else {
                return false;
            }            
        },
        onClickRow:function(rowIndex, rowData){
            EndEditFun();
            grid.datagrid('beginEdit', rowIndex);
        },
        toolbar: '#tb'     
    });    

    //查询函数
    var FindBtn= function()
    {
        var yearmonth = $('#YMbox').combobox('getValue'); 
        var deptdr    = $('#Deptbox').combobox('getValue');  
        var datafrom   = $('#Databox').combobox('getValue'); 
        var typecode   = $('#ItemTypebox').combobox('getValue');
        var itemcode   = $('#Itembox').combobox('getValue');  
        if (yearmonth == "") {
            $.messager.popover({msg: '请按照年月查询！',type:'info'});
            return;
        }
        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgFactRealMonthDetail",
                MethodName:"List",
                hospid :    hospid, 
                yearmonth:  yearmonth,
                deptdr :    deptdr,
                datafrom:   datafrom,
                typecode:   typecode,
                itemcode:   itemcode
        })
    }
    // 点击查询按钮 
    $("#FindBn").click(FindBtn);

    //增加一行
    var AddRow = function(row){
        EndEditFun();
    	var editRow = undefined;
        var items = {
                rowid:'',
                compname:'',
                yearmonth:'',
				deptdr:'',
				deptname:'',
				itemcode:'',
				itemname:'',
				value:'',
				datafrom:'',
				datafromco:'',
				datafromna:'',
				chkstate:'',
				oprator:'',
				optime:''
            };
        append(grid,items,editRow);
    }

    /*年月选择后*/
    function YearSelect(Year,rowIndex){
        var target = grid.datagrid('getEditor', {'index':rowIndex,'field':'itemname'}).target; 
        target.combobox('clear'); //清除原来的数据
        var url = $URL+"?ClassName=herp.budg.hisui.udata.uBudgFactRealMonthDetail&MethodName=ItemName&yearmonth="+Year;
        target.combobox('reload', url);//联动下拉列表重载
    }

    /***********************保存函数*************************/
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
    //保存方法
    var saveOrder=function(data) {       
        $.m({
            ClassName:'herp.budg.udata.uBudgFactRealMonthDetail',MethodName:'SaveRec',data:data,hospid:hospid,userdr:userid},
                function(Data){
                    if(Data==0){
                        $.messager.popover({msg: '保存成功！',type:'success'});
                    }else{
                        $.messager.popover({msg: "错误信息:"+Data,type:'error'});
                    }
                }
        );            
    }
    /***********************删除函数*************************/
    function CheckDataBeforeDel(rows) {
        if(!rows.length){
            $.messager.popover({msg: '请选中需要删除的数据！',type:'info'});
            return false;
        }
        //检查数据合法性
        for (var i = 0; i < rows.length; i++) {
            var billstate = rows[i].chkstate;
            var datafromco = rows[i].datafromco;
            if ((billstate !== "0") || (datafromco !== "MI")) {
                $.messager.popover({msg: '请选择手工录入、未审核单据！',type:'alert'});
                return false;
            }
        }
        return true;
    };

    function del(rows){        
        var row="",data="";
        $.messager.confirm('确定','确定要删除选中的数据行吗？',
            function(t){
                if(t){
                    for(var i=0; i<rows.length; i++){
                        row=rows[i];
                        alert(row)
                        if (CheckDataBeforeDel(rows) == true) {
                            var dataStr = row.rowid;       
	                        
                            if (data == "") {
                                data = dataStr;
                            } else {
                                data = data + "^" + dataStr;
                            }
                        }else {
                            continue;
                        }
                    }
                    $.m({
                        ClassName:'herp.budg.udata.uBudgFactRealMonthDetail',MethodName:'Delete',data:data},
                            function(Data){
                                if(Data==0){
                                    $.messager.popover({msg: '删除成功！',type:'success'});
                                }else{
                                    $.messager.popover({msg: "错误信息:"+Data,type:'error'});
                                }
                            }
                    );
                    grid.datagrid("reload");
                }    
            }
        )
    }
    /***********************审核函数*************************/
    function CheckDataBeforeAudit(rows) {
        if(!rows.length){
            $.messager.popover({msg: '请选中需要审核的数据！',type:'info'});
            return false;
        }
        //检查数据合法性
        for (var i = 0; i < rows.length; i++) {
            var billstate = rows[i].chkstate;
            var datafromco = rows[i].datafromco;
            if ((billstate !== "0") || (datafromco !== "MI")) {
                $.messager.popover({msg: '请选择手工录入、未审核单据！',type:'alert'});            
                return false;
            }
        }
        return true;
    };

    function Audit(rows) {
        var row="",data="";
        $.messager.confirm('确定','确定要审核选中的数据吗？',
            function(t){
                if(t){
                    for(var i=0; i<rows.length; i++){
                        row=rows[i];
                        var dataStr = row.rowid;
                        if (data == "") {
                            data = dataStr;
                        } else {
                            data = data + "^" + dataStr;
                        }
                    }
                    $.m({
                        ClassName:'herp.budg.udata.uBudgFactRealMonthDetail',MethodName:'Audit',data:data,userdr:userid},
                            function(Data){
                                if(Data==0){
                                    $.messager.popover({msg: '审核成功！',type:'success'}); 
                                    grid.datagrid("reload");
                                }else{
                                    $.messager.popover({msg: "错误信息:"+Data,type:'error'}); 
                                    grid.datagrid("reload");
                                }
                            }
                    );
                }    
            }
        )       
    };
    /***********************取消审核函数*************************/
    function CheckDataBeforeNoAudit(rows) {
        if(!rows.length){
            $.messager.popover({msg: '请选中需要取消审核的数据！',type:'info'});
            return false;
        }
        //检查数据合法性
        for (var i = 0; i < rows.length; i++) {
            var billstate = rows[i].chkstate;
            var datafromco = rows[i].datafromco;
            if ((billstate !== "1") || (datafromco !== "MI")) {
                $.messager.popover({msg: '请选择手工录入、未审核单据！',type:'alert'});
                return false;
            }
        }
        return true;
    };

    function NoAudit(rows) {
        var row="",data="";
        $.messager.confirm('确定','确定要取消审核选中的数据吗？',
            function(t){
                if(t){
                    for(var i=0; i<rows.length; i++){
                        row=rows[i];
                        var dataStr = row.rowid;
                        if (data == "") {
                            data = dataStr;
                        } else {
                            data = data + "^" + dataStr;
                        }
                    }
                    $.m({
                        ClassName:'herp.budg.udata.uBudgFactRealMonthDetail',MethodName:'NoAudit',data:data,userdr:userid},
                            function(Data){
                                if(Data==0){
                                    $.messager.popover({msg: '取消审核成功！',type:'success'}); 
                                    grid.datagrid("reload");
                                }else{
                                    $.messager.popover({msg: "错误信息:"+Data,type:'error'}); 
                                    grid.datagrid("reload");
                                }
                            }
                    );
                    
                }    
            }
        )       
    };
    /***********************统计计算函数*************************/
    function CheckDataBeforeCalculate() {
    	var yearmonth = $('#YMbox').combobox('getValue'); 
        if(yearmonth == ""){
            $.messager.popover({msg: '请选择年月！',type:'info'});
            return false;
        }
        return true;
    };
    function Calculate() {
        var yearmonth = $('#YMbox').combobox('getValue'); 
        $.messager.confirm('确定','确实要统计记录吗？',
            function(t){
                if(t){
                    $.m({
                        ClassName:'herp.budg.udata.uBudgFactRealMonthDetail',MethodName:'Calculate',yearmonth:yearmonth,hospid:hospid},
                            function(Data){
                                if(Data==0){
                                    $.messager.popover({msg: '统计成功！',type:'success'}); 
                                }else{
                                    $.messager.popover({msg: "错误信息:"+Data,type:'error'});
                                }
                            }
                    );
                }    
            }
        )       
    };
    function YearCalculate() {
        var yearmonth = $('#YMbox').combobox('getValue'); 
        $.messager.confirm('确定','确实要统计记录吗？',
            function(t){
                if(t){
                    $.m({
                        ClassName:'herp.budg.udata.uBudgFactRealMonthDetail',MethodName:'YearCalculate',yearmonth:yearmonth,hospid:hospid},
                            function(Data){
                                if(Data==0){
                                    $.messager.popover({msg: '统计成功！',type:'success'}); 
                                }else{
                                    $.messager.popover({msg: "错误信息:"+Data,type:'error'});
                                }
                            }
                    );
                }    
            }
        )       
    };
    /***********************执行数据重新导入函数*************************/
    function CheckBeforeExeData() {
    	var yearmonth = $('#YMbox').combobox('getValue'); 
    	var datafrom = $('#Databox').combobox('getValue'); 
        if(yearmonth == ""){
            $.messager.popover({msg: '请选择年月！',type:'info'}); 
            return false;
        }
        if(datafrom == ""){
            $.messager.popover({msg: '请选择数据来源！',type:'info'}); 
            return false;
        }
        return true;
    };

    function ExeData() {

		var yearmonth = $('#YMbox').combobox('getValue'); 
    	var datafrom2 = $('#Databox').combobox('getText');
		var arr = datafrom2.split("_");
		var datafromname = arr[0];
		var datafrom = arr[1];

		var ExeAction = "";
		if (!((datafrom == 'HISO')||(datafrom == 'HISI')||(datafrom == 'CA')||(datafrom == 'KD'))) {
            $.messager.popover({msg: '此系统不能重新导入！',type:'info'}); 
			return;
		}

		$.messager.confirm('提示','确实要统计记录吗？',
            function(t){
                if(t){
                	$.m({
                        ClassName:'herp.budg.udata.uBudgExedata',MethodName:'ExeData',yearmonth:yearmonth,datafrom:datafrom},
                            function(Data){
                                if(Data==0){
                                    $.messager.popover({msg: '获取成功！',type:'success'});
                                }else{
                                    $.messager.popover({msg: "获取错误:"+Data,type:'error'});
                                }
                            }
                    );
                }
            }
        )
			
	}

}