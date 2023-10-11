/**
CSP: herp.budg.hisui.budgschemwidehos.csp
*/

var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
var selectmainindex="";
$(function(){//��ʼ��
    Init();
    Detail();
}); 

function Init(){
    //���
    var YBoxObj = $HUI.combobox("#YBox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
        },
        /**onSelect:function(){
            $('#DBox').combobox('clear');
			$('#DBox').combobox('reload');			
        	MainGridObj.load({
            	ClassName:"herp.budg.hisui.udata.uBudgProjEstablish",
            	MethodName:"ListMain",
            	hospid :    hospid, 
            	year   :    $("#YBox").combobox('getValue'),
				budgdept:   "",
				state:      "",
				userid:     userid
        	})
     	}**/
    });
	var DBoxObj = $HUI.combobox("#DBox",{
		url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Deptnamelist",
        mode:'remote',
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
        }
	});
	var XBoxObj = $HUI.combobox("#XBox",{
		valueField:"id",
		textField:"text",
		defaultFilter:4,
		data:[{id:'1',text:'�½�'},
			  {id:'2',text:'ִ��'},
			  {id:'4',text:'ȡ��'}],
	});
    MainColumns=[[  
                //{field:'ckbox',checkbox:true},//��ѡ��
                {field:'rowid',title:'��ĿID',width:100,hidden:true},
				{field:'projadjdr',title:'����ID',width:80,hidden:true},
                {field:'CompName',title:'ҽ�Ƶ�λ',width:60,hidden:true},
				{field:'code',title:'��Ŀ����',width:140},
				{field:'name',title:'��Ŀ����',width:200},
				{field:'year',title:'���',width:60},
				{field:'chkstate',title:'��Ŀ����״̬',width:90,hidden:true},
				{field:'chkstatelist',title:'����״̬',width:80},
				{field:'fundtotal',title:'��Ԥ��',width:120},
				{field:'dataIndex1',title:'��������',width:120},
				{field:'dataIndex2',title:'������',width:120},
				{field:'dataIndex3',title:'�Գ��ʽ�',width:120},
				{field:'property',title:'��Ŀ����',width:100,hidden: true},
				{field:'propertylist',title:'��Ŀ����',width:100},
				{field:'isgovbuy',title:'�����ɹ�',width:50,hidden: true},
				{field:'isgovbuylist',title:'�����ɹ�',width:75},
				{field:'deptdr',title:'���ο���',width:100,hidden: true},
				{field:'deptname',title:'���ο���',width:100},
				{field:'bdeptname',title:'Ԥ�����',width:100},
				{field:'dutydr',title:'��Ŀ������',width:100,hidden: true},
				{field:'username',title:'��Ŀ������',width:100},
				{field:'state',title:'��Ŀ״̬',width:100,hidden: true},
				{field:'statelist',title:'��Ŀ״̬',width:75},
				{field:'filedesc',title:'����',width:100},
				{field:'changefag',title:'������',width:110,hidden:true},
				{field:'basriscurstep',title:'�Ƿ�Ϊ��ǰ����',width:110 },
				{field:'CurStepNO',title:'��ǰ����˳���',width:110,hidden:true},
				{field:'bsarstepno',title:'��������˳���',width:110,hidden:true },
				{field:'StepNo',title:'����������˳���',width:150,hidden:true },
				{field:'realedate',title:'ʵ�ʽ���ʱ��',width:120,hidden:true }
        
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgProjEstablish",
            MethodName:"ListMain",
            hospid :    hospid, 
            year   :    "",
		    budgdept:   "",
			state:      "",
			userid:     userid        
        },
        delay:200,
        fitColumns: false,
        loadMsg:"���ڼ��أ����Եȡ�",
        autoRowHeight: true,
		singleSelect:true,
		striped:true,
        rownumbers:true,//�к�
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
        fit:true,
        columns:MainColumns,
		onClickCell:function(index,field,value){
			var rows = $('#MainGrid').datagrid('getRows');
			var BillState = rows[index].chkstate;
			if (BillState =='1'){
				$('#DBackBn').linkbutton("enable");
				$('#DSubBn').linkbutton("disable");
				$('#AddBn').linkbutton("disable");
				$('#UpdataBn').linkbutton("disable");
				$('#DelBn').linkbutton("disable");
			}else if (BillState == '0'){
				$('#DBackBn').linkbutton("disable");
				$('#DSubBn').linkbutton("enable");
				$('#AddBn').linkbutton("enable");
				$('#UpdataBn').linkbutton("enable");
				$('#DelBn').linkbutton("enable");
			}else{
				$('#DBackBn').linkbutton("disable");
				$('#DSubBn').linkbutton("disable");
				$('#AddBn').linkbutton("disable");
				$('#UpdataBn').linkbutton("disable");
				$('#DelBn').linkbutton("disable");
			}
		},
		onClickRow:function(index,row){
	        selectmainindex=index;
        	//$("#detailfm").form("clear");
            $('#DetailGrid').datagrid('load',{
                ClassName:"herp.budg.hisui.udata.uBudgProjEstablish",
                MethodName:"ListDetail",
                hospid :    hospid, 
                projadjdr :  row.projadjdr    
            });     
        },
        toolbar: '#tb'
    }); 
    // ��ѯ����
    var FindBtn= function()
    {
        //var Year = $('#YBox').combobox('getValue'); 
        //var Budgdept = $('#DBox').combobox('getValue'); 
        //var State = $('#XBox').combobox('getValue'); 		
        MainGridObj.load({
            ClassName:"herp.budg.hisui.udata.uBudgProjEstablish",
            MethodName:"ListMain",
            hospid :    hospid, 
            year   :    $('#YBox').combobox('getValue'),
		    budgdept:   $('#DBox').combobox('getValue'),
			state:      $('#XBox').combobox('getValue'),
			userid:     userid 
        })
    };

    // �����ѯ��ť 
    $("#FindBn").click(FindBtn);

    // �ύ����
    var SubmitBtn = function()
    {
		//alert('ok');
		$.messager.confirm('ȷ��','ȷ��Ҫ�ύ������',function(t){
           if(t){
            var rows = $('#MainGrid').datagrid('getSelections');
            var len = rows.length;
			for(var i=0;i<rows.length;i++){
				var rowid=rows[i]['rowid'];
				var fundown=rows[i]['dataIndex3'];
				var fundgov=rows[i]['dataIndex1'];
                $.m({
                ClassName:'herp.budg.hisui.udata.uBudgProjEstablish',
				MethodName:'Submit',
				id:rowid,
				userid:userid,
				fundown:"",
				fundgov:""},
                function(Data){
                    if(Data==0){
	                $.messager.popover({
					msg: '�ύ�ɹ���',
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
					 
				});
                $('#MainGrid').datagrid("reload")
                    }else{
	                     $.messager.popover({
					msg: '�ύʧ��! ������Ϣ:' +Data,
					type: 'error',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                $('#MainGrid').datagrid("reload")
              
                    }
                }
            );
			}; 
           } 
        })  
	};	
	// ����ύ��ť
	$("#DSubBn").click(SubmitBtn);
	
	// �ύ����
    var DBackBtn = function()
    {
		//alert('ok');
		$.messager.confirm('ȷ��','ȷ��Ҫ����������',function(t){
           if(t){
            var rows = $('#MainGrid').datagrid('getSelections');
            var len = rows.length;
			for(var i=0;i<rows.length;i++){
				var rowid=rows[i]['rowid'];
				var projadjdr=rows[i]['projadjdr'];
                $.m({
                ClassName:'herp.budg.hisui.udata.uBudgProjEstablish',
				MethodName:'CancelSubmit',
				rowid:rowid,
				projadjdr:projadjdr,
				userid:userid},
                function(Data){
                    if(Data==0){
	                $.messager.popover({
					msg: '�����ɹ���',
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
					 
				});
                $('#MainGrid').datagrid("reload")
                    }else{
	                     $.messager.popover({
					msg: '����ʧ��! ������Ϣ:' +Data,
					type: 'error',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                $('#MainGrid').datagrid("reload")
              
                    }
                }
            );
			}; 
           } 
        })  
	};	
	// ����ύ��ť
	$("#DBackBn").click(DBackBtn);
	
}