
exefun = function (itemcode,yearmonth,deptdr,itemtype,editindex) {
	var $win;
    $win = $('#ExeWin').window({
        title: 'ִ������ɸѡ',
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
        onClose:function(){ //�رմ��ں󴥷�
        }
    });
    $win.window('open');
    //����
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
    //����
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
                $.messager.popover({msg: '����ѡ�����£�',type:'info'});
                return false;
            }
        }
    });
    //��Ŀ����
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
                {field:'ckbox',checkbox:true},//��ѡ��
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'CompName',title:'ҽ�Ƶ�λ',width:100,hidden: true},
                {field:'yearmonth',title:'����',width:140},
                {field:'deptname',title:'��������',width:200},
                {field:'itemname',title:'��Ŀ����',width:300},
                {field:'value',title:'����ִ�н��',width:200,align:'right',formatter:dataFormat}
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
        fitColumns: false,//�й̶�
        loadMsg:"���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        autoSizeColumn:true, //�����еĿ������Ӧ����
        rownumbers:true,//�к�
        singleSelect: true, 
        checkOnSelect : true,//�������Ϊ true�����û����ĳһ��ʱ�����ѡ��/ȡ��ѡ�и�ѡ���������Ϊ false ʱ��ֻ�е��û�����˸�ѡ��ʱ���Ż�ѡ��/ȡ��ѡ�и�ѡ��
        selectOnCheck : false,//�������Ϊ true�������ѡ�򽫻�ѡ�и��С��������Ϊ false��ѡ�и��н�����ѡ�и�ѡ��
        nowap : true,//��ֹ��Ԫ���е������Զ�����
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
        fit:true,
        columns:MainColumns,
        onDblClickRow:function(index,row){
	        
        	var mainrow = $('#MainGrid').datagrid('getSelected');
        	if(mainrow!=""){
	        	var rowIndex = $('#MainGrid').datagrid('getRowIndex',row);//��ȡ�к�
	        	
	        	
	        	/*
	        	// �õ�columns����
				var columns = $('#MainGrid').datagrid("options").columns;
				console.log(JSON.stringify(columns));
	        	var rows = $('#MainGrid').datagrid("getRows"); // ��δ�����// ��ĳ����Ԫ��ֵ//
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
    
    
    // ��ѯ����
    var FindBtn= function()
    {
        var YearMonth = $('#YMBox').combobox('getValue'); // ����
        var DeptDR  = $('#DeptBox').combobox('getValue'); // �������
        var ItemType= $('#ItemType').combobox('getValue');// ��Ŀ���
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

    // �����ѯ��ť 
    $("#FindBn").click(FindBtn);
}	
	
											
