var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){//初始化
    Init();
}); 

function Init(){
	
    var splitmethdata=[ 
                {'rowid': 1,'name': "历史数据"},
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
        onSelect:function(rec){ 
        	$('#Schembox').combobox('clear');
            $('#Schembox').combobox('reload');
            $('#Deptbox').combobox('clear');
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
            param.flag   = 2;
            param.year   = $("#Yearbox").combobox("getValue");
            param.str    = param.q;
        },
        onSelect:function(rec){ 
        	$('#Deptbox').combobox('clear');
            $('#Deptbox').combobox('reload');
        }
    });
    // 科室的下拉框Schembox
    var DeptboxObj = $HUI.combobox("#Deptbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.schemedr   = $("#Schembox").combobox("getValue");
            param.flag   = 7
            param.str    = param.q;
        },
        onSelect:function(data){
	        var year    = $('#Yearbox').combobox('getValue'); 
        	var SchemDR = $('#Schembox').combobox('getValue'); // 预算方案
        	var ItemCode= $('#Itembox').val();  // 科目编码
        	if(!year||!SchemDR||!data.rowid)
  			{
            	$.messager.popover({msg: '年度、预算方案、科室为必选项!',type:'info'});
  				return;
  			}
        	MainGridObj.load({
            	ClassName:"herp.budg.hisui.udata.uBudgSchSplitYM",
           		MethodName:"List",
            	hospid :    hospid, 
            	year   :    year,
            	schemid:    SchemDR,
            	deptdr :    data.rowid,
            	code   : 	ItemCode
        	})
     	}
    });
  //保存按钮
    $("#SaveBn").click(function() {
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
                                    
    MainColumns=[[  
                {field:'ck',checkbox:true},
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'CompName',title:'医疗单位',width:80,hidden: true},
                {field:'year',title:'年度',width:80},
                {field:'deptDR',title:'科室编码',width:80,hidden: true},
                {field:'deptname',title:'科室名称',width:100},
                {field:'code',title:'科目编码',width:120},
                {field:'superCode',title:'上级编码',width:80,hidden: true},
                {field:'Sname',title:'科目名称',width:120},
                {field:'level',title:'预算级别',width:80,hidden: true},
                {field:'isLast',title:'是否末级',width:80,
	                formatter:function(value,row,index){
	                    if (value == 1) {
	                        return '<span>是</span>';
	                    } else {
	                        return '<span>否</span>';
	                    }
	                }
                },
                {field:'splitMeth',title:'分解方法设置',width:150,allowBlank:false,
                    //formatter:comboboxFormatter,
                    editor:{
                        type:'combobox',
                        options:{
                            valueField:'rowid',
                            textField:'name',
                            data: [{'rowid': 1,'name': "历史数据"},
                                   {'rowid': 2,'name': "历史数据*调节比例"},  
                                   {'rowid': 3,'name': "比例系数"},  
                                   {'rowid': 4,'name': "全面贯彻"},  
                                   {'rowid': 5,'name': "均摊"}] 
                        }
                    }
                },
                {field:'rate',title:'调节比例',width:100,
                formatter:function(value,row,index){
                    var sf = row.isLast;
					var sm = row.rowid;
					var fjff = row.splitMeth;
                    if ((sf == '1') && (sm != '')&& (fjff != '5')) {
                        return '<span class="grid-td-text">维护数据</span>';
                    } else {
                        '<span></span>';
                    }
                }},
                {field:'SplitLayer',title:'分解层',width:80,hidden: true}

            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchSplitYM",
            MethodName:"List",
            hospid :    hospid, 
            year   :    "",
            schemid:    "",
            deptdr :    "",
            code   : 	""
        },
        fitColumns: true,
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        pageSize:20,
        pageList:[10,20,30,50,100], 
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        onClickCell: function(index,field,value){   
            $('#MainGrid').datagrid('selectRow', index);
            var rowsData = $('#MainGrid').datagrid('getRows');
            var data = rowsData[index];
            var IsLast = data.isLast;
            if ((field=="splitMeth")&&(IsLast==1)){
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
        var DeptDR= $('#Deptbox').combobox('getValue'); // 
        var ItemCode= $('#Itembox').val();  // 科目编码
        if(!year||!SchemDR||!DeptDR)
  		{
            $.messager.popover({msg: '年度、预算方案、科室为必选项!',type:'info'});
  			return;
  		}
        MainGridObj.load({
            ClassName:"herp.budg.hisui.udata.uBudgSchSplitYM",
            MethodName:"List",
            hospid :    hospid, 
            year   :    year,
            schemid:    SchemDR,
            deptdr :    DeptDR,
            code   : 	ItemCode
        })
    }
    //点击查询按钮 
    $("#FindBn").click(FindBtn);
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
                        $.messager.popover({msg: info,type:'error'});
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
            ClassName:'herp.budg.udata.uBudgSchSplitYM',MethodName:'UpdateRec',hospid:hospid,id:row.rowid,
                schemid:row.SchemDR,year:row.year,code:row.code,splitmeth:row.splitMeth,isLast:row.isLast,deptdr:row.deptDR},
                function(Data){
                    if(Data==0){
                        $.messager.popover({
								          msg: '保存成功',
								          type:'success',
								          style:{"position":"absolute","z-index":"9999",
								          left:-document.body.scrollTop - document.documentElement.scrollTop/2}});
								          $('#MainGrid').datagrid("reload");
                    }else{
                        $.messager.popover({
									      msg: '保存失败！',
									      type:'error',
									      style:{"position":"absolute","z-index":"9999",
									      left:-document.body.scrollTop - document.documentElement.scrollTop/2}});
                    }
                }
        );            
    }

}