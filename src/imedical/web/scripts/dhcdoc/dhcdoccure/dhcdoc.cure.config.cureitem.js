
    var editRow = undefined; //����ȫ�ֱ�������ǰ�༭����
    var cureItemDataGrid; //����ȫ�ֱ���datagrid
$(function(){
	///������Ŀ�б�columns
	var cureItemToolBar = [{
            text: '���',
            iconCls: 'icon-add',
            handler: function() { //����б�Ĳ�����ť���,�޸�,ɾ����
                //���ʱ���ж��Ƿ��п����༭���У��������ѿ����༭�����н����༭
                if (editRow != undefined) {
                    //locDataGrid.datagrid("endEdit", editRow);
                    return;
                }else{
	                 //���ʱ���û�����ڱ༭���У�����datagrid�ĵ�һ�в���һ��
                    cureItemDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //���²������һ�п����༭״̬
                    cureItemDataGrid.datagrid("beginEdit", 0);
                    //locDataGrid.datagrid('addEditor',LocDescEdit);
                    //����ǰ�༭���и�ֵ
                    editRow = 0;
                }

            }
        },
        '-', {
            text: 'ɾ��',
            iconCls: 'icon-remove',
            handler: function() {
                //ɾ��ʱ�Ȼ�ȡѡ����
                var rows = cureItemDataGrid.datagrid("getSelections");
                //ѡ��Ҫɾ������
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].ArcimID);
                            }
                            //��ѡ�񵽵��д������鲢��,�ָ�ת�����ַ�����
                            //����ֻ��ǰ̨����û�������ݿ���н������Դ˴�ֻ�ǵ���Ҫ�����̨��id
                            var ArcimRowID=ids.join(',')
                            $.dhc.util.runServerMethod("web.DHCDocCureAppConfig","DeleteConfigCureItem","false",function testget(value){
						if(value=="0"){
							cureItemDataGrid.datagrid('load');
           					cureItemDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
						}else{
							$.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
						}
						editRow = undefined;
						},"","",ArcimRowID);
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
                }
            }
        },
        '-', {
            text: '����',
            iconCls: 'icon-save',
            handler: function() {
                //����ʱ������ǰ�༭���У��Զ�����onAfterEdit�¼����Ҫ���̨�����ɽ�����ͨ��Ajax�ύ��̨
                if (editRow != undefined)
                {
                	var editors = cureItemDataGrid.datagrid('getEditors', editRow);      
					var ArcimRowID =  editors[0].target.combobox('getValue');
                	$.dhc.util.runServerMethod("web.DHCDocCureAppConfig","SaveConfigCureItem","false",function testget(value){
	                	//console.info(value);
						if(value=="0"){
							cureItemDataGrid.datagrid("endEdit", editRow);
                			editRow = undefined;
							cureItemDataGrid.datagrid('load');
           					cureItemDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"��ʾ",msg:"����ɹ�"});           					
						}else{
							$.messager.alert('��ʾ',"����ʧ��:"+value);
							return false;
						}
						editRow = undefined;
						},"","",ArcimRowID);
            		}
             }
        },
        '-', {
            text: 'ȡ���༭',
            iconCls: 'icon-redo',
            handler: function() {
                //ȡ����ǰ�༭�аѵ�ǰ�༭�а�undefined�ع��ı������,ȡ��ѡ�����
                if (editRow!=undefined) cureItemDataGrid.datagrid("endEdit", editRow);
                editRow = undefined;
                cureItemDataGrid.datagrid("rejectChanges");
                cureItemDataGrid.datagrid("unselectAll");
            }
        }];
    cureItemColumns=[[    
        			{ field: 'ArcimDesc', title: '������Ŀ����', width: 100, align: 'center', sortable: true, resizable: true,
        			  editor :{  
							type:'combobox',  
							options:{
								url:"./dhcdoc.cure.query.combo.easyui.csp",
								valueField:'ArcimRowID',
								textField:'ArcimDesc',
								required:true,
								onBeforeLoad:function(param){
									param.ClassName = "web.DHCDocCureAppConfig";
									param.QueryName = "FindAllItem";
									param.ArgCnt = 0;
								},
								onSelect:function(rec){
								}
							  }
     					  }
        			},
					{ field: 'ArcimID', title: '������ĿID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true}
    			 ]];
     // �����ÿ����б�Grid
	cureItemDataGrid=$('#tabCureItemList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		url : './dhcdoc.cure.query.grid.easyui.csp',
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"ArcimID",
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :cureItemColumns,
    	toolbar :cureItemToolBar,
		onBeforeLoad:function(param){
			param.ClassName ='web.DHCDocCureAppConfig';
			param.QueryName ='FindConfigCureItem';
			param.ArgCnt =0;
		},
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		}
	});
});


