var cureRBCResSchduleDataGrid;
$(function(){
	$('#btnSearchApp').bind("click",function(){
		LoadCureRBCResSchduleDataGrid();	
	})
	
	$('#Apply_AppDate').datebox({"onSelect":function(date){
		LoadCureRBCResSchduleDataGrid()
	}})
	InitCureRBCResSchduleDataGrid();		
});


function InitCureRBCResSchduleDataGrid()
{  
	var cureRBCResSchduleToolBar = [{
            text: 'ԤԼ',
            iconCls: 'icon-add',
            handler: function() {
	            var OperateType=$('#OperateType').val();
	            if (OperateType=="ZLYS")
	            {
		            $.messager.alert("����", "ֻ������ǰ̨��ҽ��������ԤԼ",'error')
		            return false;
		        }
	            var DCARowId=$('#DCARowId').val();
	            if(DCARowId=="")
	            {
		            $.messager.alert("����", "��ѡ��һ�����뵥", 'error')
        			return false;
		        }
                var rows = cureRBCResSchduleDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].Rowid);
                            }
                            var ID=ids.join(',')
                            var Para=DCARowId+"^"+ID+"^"+"M"+"^"+session['LOGON.USERID'];
                            var value=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","AppInsert",Para)
                            if (value=="0"){
	                             	cureRBCResSchduleDataGrid.datagrid('load');
           					        cureRBCResSchduleDataGrid.datagrid('unselectAll');
           					         $.messager.alert('��ʾ',"ԤԼ�ɹ�");
           					       if((parent)&&(typeof(parent.loadCureApplyDataGrid()) == "function")) parent.loadCureApplyDataGrid();
                            }else{
	                              var err=value
							       if (value==100) err="�в���Ϊ��";
							       if (value==101) err="ͣ����Ű಻��ԤԼ";
							       if (value==102) err="���Ű��Ѿ�����ԤԼʱ��,����ԤԼ";
							       if (value==103) err="�����뵥��������Ŀ�����Ѿ�Լ��";
							       if ((value==104)||(value==105)) err="����ִ�м�¼����";
							       if (value==106) err="���Ű���ԤԼ��,������ԤԼ";
							       $.messager.alert('��ʾ',"ԤԼʧ��:"+err);
	                         }
                            /*
							$.dhc.util.runServerMethod("DHCDoc.DHCDocCure.Appointment","AppInsert","false",function testget(value){
						        if(value=="0"){
							       cureRBCResSchduleDataGrid.datagrid('load');
           					       cureRBCResSchduleDataGrid.datagrid('unselectAll');
           					       $.messager.show({title:"��ʾ",msg:"ԤԼ�ɹ�"});
           					       if((parent)&&(typeof(parent.loadCureApplyDataGrid()) == "function")) parent.loadCureApplyDataGrid();
						        }else{
							       var err=value
							       if (value==100) err="�в���Ϊ��";
							       if (value==101) err="ͣ����Ű಻��ԤԼ";
							       if (value==102) err="���Ű��Ѿ�����ԤԼʱ��,����ԤԼ";
							       if (value==103) err="�����뵥��������Ŀ�����Ѿ�Լ��";
							       if ((value==104)||(value==105)) err="����ִ�м�¼����";
							       if (value==106) err="���Ű���ԤԼ��,������ԤԼ";
							       $.messager.alert('��ʾ',"ԤԼʧ��:"+err);
						        }
						  
						   },"","",Para);
						   */
                } else {
                    $.messager.alert("��ʾ", "��ѡ��ҪԤԼ����Դ", "error");
                }
            }
        }];
	var cureRBCResSchduleColumns=[[    
                    { field: 'Rowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'DDCRSDate', title:'����', width: 25, align: 'center', sortable: true, resizable: true  
					},
					{ field: 'LocDesc', title:'����', width: 60, align: 'center', sortable: true, resizable: true  
					},
        			{ field: 'ResourceDesc', title: '��Դ', width: 20, align: 'center', sortable: true, resizable: true
					},
					{ field: 'TimeDesc', title: 'ʱ��', width: 40, align: 'center', sortable: true, resizable: true
					},
					{ field: 'StartTime', title: '��ʼʱ��', width: 30, align: 'center', sortable: true,resizable: true
					},
					{ field: 'EndTime', title: '����ʱ��', width: 30, align: 'center', sortable: true,resizable: true
					},
					{ field: 'ServiceGroupDesc', title: '������', width: 50, align: 'center', sortable: true,resizable: true
					},
					{ field: 'DDCRSStatus', title: '״̬', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'AppedNumber', title: '��ԤԼ��', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'MaxNumber', title: '���ԤԼ��', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'AutoNumber', title: '�Զ�ԤԼ��', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'ChargeTime', title: '��ֹ�ɷ�ʱ��', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'AvailPatType', title: '��������', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'AutoAvtiveFlag', title: '�Զ�ԤԼ���ÿ���', width: 20, align: 'center', sortable: true
					}
    			 ]];
	cureRBCResSchduleDataGrid=$('#tabCureRBCResSchdule').datagrid({  
		fit : true,
		width :450,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '������..',  
		pagination : true,  //�Ƿ��ҳ
		rownumbers : false,  //
		idField:"Rowid",
		pageList : [15,50,100,200],
		columns :cureRBCResSchduleColumns,
		toolbar:cureRBCResSchduleToolBar,
		onClickRow:function(rowIndex, rowData){
			Rowid=rowData.Rowid
		}
	});
	//LoadCureRBCResSchduleDataGrid("");
}
function LoadCureRBCResSchduleDataGrid()
{
	var DCARowId=$('#DCARowId').val();
	var AppDate=$('#Apply_AppDate').datebox('getValue');
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.RBCResSchdule';
	queryParams.QueryName ='QueryAvailResApptSchdule';
	queryParams.Arg1 =DCARowId;
	queryParams.Arg2 =AppDate;
	queryParams.ArgCnt =2;
	var opts = cureRBCResSchduleDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	cureRBCResSchduleDataGrid.datagrid('load', queryParams);
}