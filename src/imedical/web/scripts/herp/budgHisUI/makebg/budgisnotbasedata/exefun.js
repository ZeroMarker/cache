
exefun = function (itemcode,yearmonth,deptdr,itemtype,editindex) {
	var $win;
    $win = $('#ExeWin').window({
        title: '执行数据筛选',
        width: 1000,
        height: 600,
        top: ($(window).height() - 600) * 0.5,
        left: ($(window).width() - 1000) * 0.5,
        shadow: true,
        modal: true,
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
        onClose:function(){ //关闭窗口后触发
        }
    });
    $win.window('open');
    //年月
    var YMBoxObj = $HUI.combobox("#YMBox",{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgIsNotBaseData&MethodName=YearOrYearMon",
        mode:'remote',
        valueField:'year',    
        textField:'year',
        value:yearmonth,
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.str = param.q;
        },
        onChange:function(n,o){
            if(n!=o){
                $('#DeptBox').combobox('clear');
                $('#DeptBox').combobox('reload');
            }
        }
    });
    //科室
    var DeptObj = $HUI.combobox("#DeptBox",{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgIsNotBaseData&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',
        value:deptdr,    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.YearMon= $('#YMBox').combobox('getValue');
            param.str    = param.q;
        },
        onShowPanel:function(){
            if($('#YMBox').combobox('getValue')==""){
                $(this).combobox('hidePanel');
                $.messager.popover({msg: '请先选择年月！',type:'info'});
                return false;
            }
        }
    });
    //科目分类
    var ItemTypeObj = $HUI.combobox("#ItemType",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemType",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        value:itemtype,
        onBeforeLoad:function(param){
            param.flag = 1;
            param.str = param.q;
        }
    });
   
    MainColumns=[[  
                {field:'ckbox',checkbox:true},//复选框
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'CompName',title:'医疗单位',width:100,hidden: true},
                {field:'yearmonth',title:'年月',width:140},
                {field:'deptname',title:'科室名称',width:200},
                {field:'itemname',title:'科目名称',width:300},
                {field:'value',title:'本期执行金额',width:200,align:'right',formatter:dataFormat}
            ]];
    var DetailGridObj = $HUI.datagrid("#detailGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgIsNotBaseData",
            MethodName:"DetailList",
            hospid :    hospid, 
            yearmonth:  $('#YMBox').combobox('getValue'),
            deptdr :    $('#DeptBox').combobox('getValue'),
            typecode:   $('#ItemType').combobox('getValue'),
            itemcode:   itemcode           
        },
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        autoSizeColumn:true, //调整列的宽度以适应内容
        rownumbers:true,//行号
        singleSelect: true, 
        checkOnSelect : true,//如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框。
        selectOnCheck : false,//如果设置为 true，点击复选框将会选中该行。如果设置为 false，选中该行将不会选中复选框
        nowap : true,//禁止单元格中的文字自动换行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        onDblClickRow:function(index,row){
	        
        	var mainrow = $('#MainGrid').datagrid('getSelected');
        	if(mainrow!=""){
	        	var rowIndex = $('#MainGrid').datagrid('getRowIndex',row);//获取行号
	        	
	        	
	        	/*
	        	// 得到columns对象
				var columns = $('#MainGrid').datagrid("options").columns;
				console.log(JSON.stringify(columns));
	        	var rows = $('#MainGrid').datagrid("getRows"); // 这段代码是// 对某个单元格赋值//
	        	rows[rowIndex+1][columns[0][5].field]=row.rowid;row.rowid
	        	rows[rowIndex][columns[0].CompName]=hospid;
	        	rows[rowIndex][columns[0].yearmonth]=row.yearmonth;
	        	rows[rowIndex][columns[0].bdeptname]=row.deptname;
	        	rows[rowIndex][columns[0].itemname]=row.itemname;
	        	rows[rowIndex][columns[0].rejmoney]=row.value;*/
				$('#MainGrid').datagrid('endEdit', rowIndex+1)
				console.log(row.value);
            	mainrow.bfrmId=row.rowid;
            	mainrow.CompName=hospid;
            	mainrow.yearmonth=row.yearmonth;
            	mainrow.bdeptname=row.deptname;
            	mainrow.itemcode=mainrow.itemname;
            	mainrow.rejmoney=row.value;
            	//$('#MainGrid').datagrid('updateRow', mainrow);
            	
            	$('#MainGrid').datagrid('endEdit', rowIndex+1).datagrid('refreshRow', rowIndex+1).datagrid('selectRow', rowIndex+1).datagrid('beginEdit', rowIndex+1);

            }
            $win.window('close');           
        },
        toolbar: '#tb'
    });
    
    
    // 查询函数
    var FindBtn= function()
    {
        var YearMonth = $('#YMBox').combobox('getValue'); // 年月
        var DeptDR  = $('#DeptBox').combobox('getValue'); // 方案类别
        var ItemType= $('#ItemType').combobox('getValue');// 科目类别
        DetailGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgIsNotBaseData",
                MethodName:"DetailList",
                hospid :    hospid, 
                yearmonth:  YearMonth,
                deptdr :    DeptDR,
                typecode:   ItemType,
                itemcode:   itemcode  
            })
    }

    // 点击查询按钮 
    $("#FindBn").click(FindBtn);
}	
	
											
