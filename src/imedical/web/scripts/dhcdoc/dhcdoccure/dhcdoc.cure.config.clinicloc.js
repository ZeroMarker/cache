	var CurrLocId=""; //��¼ѡ�е���
	var CurrItemCatId="";
	var CurrArcimId="";
    var locDataGrid; //����ȫ�ֱ���datagrid
    var editRow = undefined; //����ȫ�ֱ�������ǰ�༭����
    var cureItemCatDataGrid ; //����ȫ�ֱ���datagrid
    var editRow2 = undefined; //����ȫ�ֱ�������ǰ�༭����
    var cureItemDataGrid; //����ȫ�ֱ���datagrid
    var editRow3 = undefined; //����ȫ�ֱ�������ǰ�༭����
    var cureItemCatAppendDataGrid; //����ȫ�ֱ���datagrid
    var editRow4 = undefined; //����ȫ�ֱ�������ǰ�༭����
    var cureItemAppendDataGrid; //����ȫ�ֱ���datagrid
    var editRow5 = undefined; //����ȫ�ֱ�������ǰ�༭����
$(function(){
	///�����б�columns
	var locToolBar = [{
            text: '���',
            iconCls: 'icon-add',
            handler: function() { //����б�Ĳ�����ť���,�޸�,ɾ����
                //���ʱ���ж��Ƿ��п����༭���У��������ѿ����༭�����н����༭
                if (editRow != undefined) {
                    //locDataGrid.datagrid("endEdit", editRow);
                    return;
                }else{
	                 //���ʱ���û�����ڱ༭���У�����datagrid�ĵ�һ�в���һ��
                    locDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //���²������һ�п����༭״̬
                    locDataGrid.datagrid("beginEdit", 0);
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
                var rows = locDataGrid.datagrid("getSelections");
                //ѡ��Ҫɾ������
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].LocId);
                            }
                            //��ѡ�񵽵��д������鲢��,�ָ�ת�����ַ�����
                            //����ֻ��ǰ̨����û�������ݿ���н������Դ˴�ֻ�ǵ���Ҫ�����̨��id
                            var LocID=ids.join(',')
                            $.dhc.util.runServerMethod("web.DHCDocCureAppConfig","DeleteClinicLoc","false",function testget(value){
						if(value=="0"){
							locDataGrid.datagrid('load');
           					locDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
						}else{
							$.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
						}
						editRow = undefined;
						},"","",LocID);
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
                }
            }
        },
        '-',/* {
            text: '�޸�',
            iconCls: 'icon-edit',
            handler: function() {
                //�޸�ʱҪ��ȡѡ�񵽵���
                var rows = locDataGrid.datagrid("getSelections");
                //���ֻѡ����һ������Խ����޸ģ����򲻲���
                if (rows.length == 1) {
                    //�޸�֮ǰ�ȹر��Ѿ������ı༭�У�������endEdit�÷���ʱ�ᴥ��onAfterEdit�¼�
                    if (editRow != undefined) {
                        locDataGrid.datagrid("endEdit", editRow);
                    }else{ 
                    	
                        //�������˵�ǰѡ���еı༭״̬֮��
                        //Ӧ��ȡ����ǰ�б������ѡ���У�Ҫ��Ȼ˫��֮���޷���ѡ�������н��б༭
                        var rowIndex = locDataGrid.datagrid("getRowIndex", rows[0]);
                        //�����༭
                        locDataGrid.datagrid("beginEdit", rowIndex);
                        //�ѵ�ǰ�����༭���и�ֵ��ȫ�ֱ���editRow
                        editRow = rowIndex; 
                        var selected=locDataGrid.datagrid('getRows');
                        var LocId=selected[rowIndex].LocId;  
                        var editors = locDataGrid.datagrid('getEditors', editRow);
                        //���ޱ༭��ʱ
                        //��ȡ����ǰѡ���е��±�
						editors[0].target.combobox('setValue',LocId);
						editors[1].target.combobox('setValue',NeedAppFlag);
						locDataGrid.datagrid("unselectAll");
 						//locDataGrid.datagrid('removeEditor',['LocDesc']);
                    }
                }
            }
        },
        '-',*/ {
            text: '����',
            iconCls: 'icon-save',
            handler: function() {
                //����ʱ������ǰ�༭���У��Զ�����onAfterEdit�¼����Ҫ���̨�����ɽ�����ͨ��Ajax�ύ��̨
                if (editRow != undefined)
                {
                	var editors = locDataGrid.datagrid('getEditors', editRow);      
					var LocId =  editors[0].target.combobox('getValue');
                	$.dhc.util.runServerMethod("web.DHCDocCureAppConfig","SaveClinicLoc","false",function testget(value){
	                	//console.info(value);
						if(value=="0"){
							locDataGrid.datagrid("endEdit", editRow);
                			editRow = undefined;
							locDataGrid.datagrid('load');
           					locDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"��ʾ",msg:"����ɹ�"});           					
						}else{
							$.messager.alert('��ʾ',"����ʧ��:"+value);
							return false;
						}
						editRow = undefined;
						},"","",LocId);
            		}
             }
        },
        '-', {
            text: 'ȡ���༭',
            iconCls: 'icon-redo',
            handler: function() {
                //ȡ����ǰ�༭�аѵ�ǰ�༭�а�undefined�ع��ı������,ȡ��ѡ�����
                if (editRow!=undefined) locDataGrid.datagrid("endEdit", editRow);
                editRow = undefined;
                locDataGrid.datagrid("rejectChanges");
                locDataGrid.datagrid("unselectAll");
            }
        }];
    locColumns=[[    
        			{ field: 'LocDesc', title: '��������', width: 100, align: 'center', sortable: true, resizable: true,
        			  editor :{  
							type:'combobox',  
							options:{
								url:"./dhcdoc.cure.query.combo.easyui.csp",
								valueField:'LocRowID',
								textField:'LocDesc',
								required:true,
								onBeforeLoad:function(param){
									param.ClassName = "web.DHCDocCureAppConfig";
									param.QueryName = "FindLoc";
									param.Arg1 = "";
									param.ArgCnt = 1;
								},
								onSelect:function(rec){
								}
							  }
     					  }
        			},
					{ field: 'LocId', title: '����ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true}
    			 ]];
     // �����ÿ����б�Grid
	locDataGrid=$('#tabCureLocList').datagrid({  
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
		idField:"LocId",
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :locColumns,
    	toolbar :locToolBar,
		onBeforeLoad:function(param){
			param.ClassName ='web.DHCDocCureAppConfig';
			param.QueryName ='FindClinicLoc';
			param.ArgCnt =0;
		},
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
			locDataGrid.datagrid('selectRow',rowIndex);
			var selected=locDataGrid.datagrid('getRows'); 
			var LocId=selected[rowIndex].LocId;
			loadcureItemCatDataGrid(LocId);
		}
	});
	//-------------������Ŀ�������---------------
	var cureItemCatToolBar = [{
            text: '���',
            iconCls: 'icon-add',
            handler: function() { //����б�Ĳ�����ť���,�޸�,ɾ����
                //���ʱ���ж��Ƿ��п����༭���У��������ѿ����༭�����н����༭
               if (CurrLocId!="")
               {
                if (editRow2 != undefined) {
                    //cureItemCatDataGrid.datagrid("endEdit", editRow2);
                    return;
                }else{
	                 //���ʱ���û�����ڱ༭���У�����datagrid�ĵ�һ�в���һ��
                    cureItemCatDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //���²������һ�п����༭״̬
                    cureItemCatDataGrid.datagrid("beginEdit", 0);
                    //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                    //����ǰ�༭���и�ֵ
                    editRow2 = 0;
                }
              }else{
	              $.messager.alert('��ʾ',"��ѡ��һ�����ƿ��Ҽ�¼");
	          }
            }
        },
        '-', {
            text: 'ɾ��',
            iconCls: 'icon-remove',
            handler: function() {
	            if (CurrLocId!="")
	            {
                //ɾ��ʱ�Ȼ�ȡѡ����
                var rows = cureItemCatDataGrid.datagrid("getSelections");
                //ѡ��Ҫɾ������
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].ItemCatId);
                            }
                            //��ѡ�񵽵��д������鲢��,�ָ�ת�����ַ�����
                            //����ֻ��ǰ̨����û�������ݿ���н������Դ˴�ֻ�ǵ���Ҫ�����̨��id
                            var cureItemCatID=ids.join(',')
                           //alert("ɾ��:"+CurrLocId+"^"+cureItemCatID)
                            $.dhc.util.runServerMethod("web.DHCDocCureAppConfig","DeletecureItemCat","false",function testget(value){
						if(value=="0"){
							cureItemCatDataGrid.datagrid('load');
           					cureItemCatDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
						}else{
							$.messager.alert('��ʾ',"ɾ��ʧ��");
						}
						editRow2 = undefined;
						},"","",CurrLocId,cureItemCatID);
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
                }
	          }else{
		           $.messager.alert('��ʾ',"��ѡ��һ�����ƿ��Ҽ�¼");	
		      }
            }
        },
        '-', /*{
            text: '�޸�',
            iconCls: 'icon-edit',
            handler: function() {
	            if (CurrLocId!="")
	            {
                //�޸�ʱҪ��ȡѡ�񵽵���
                var rows = cureItemCatDataGrid.datagrid("getSelections");
                //���ֻѡ����һ������Խ����޸ģ����򲻲���
                if (rows.length == 1) {
                    //�޸�֮ǰ�ȹر��Ѿ������ı༭�У�������endEdit�÷���ʱ�ᴥ��onAfterEdit�¼�
                    if (editRow2 != undefined) {
                        cureItemCatDataGrid.datagrid("endEdit", editRow2);
                    }else{ 
                    	
                        //�������˵�ǰѡ���еı༭״̬֮��
                        //Ӧ��ȡ����ǰ�б������ѡ���У�Ҫ��Ȼ˫��֮���޷���ѡ�������н��б༭
                        var rowIndex = cureItemCatDataGrid.datagrid("getRowIndex", rows[0]);
                        //�����༭
                        cureItemCatDataGrid.datagrid("beginEdit", rowIndex);
                        //�ѵ�ǰ�����༭���и�ֵ��ȫ�ֱ���editRow
                        editRow2 = rowIndex; 
                        var selected=cureItemCatDataGrid.datagrid('getRows');
                        var ItemCatId=selected[rowIndex].ItemCatId;   
                        var editors = cureItemCatDataGrid.datagrid('getEditors', editRow2);
                        //console.info("ItemCatId:="+ItemCatId)
                        //���ޱ༭��ʱ
                        //��ȡ����ǰѡ���е��±�
						editors[0].target.combobox('setValue',ItemCatId);
						cureItemDataGrid.datagrid("unselectAll");
 						//cureItemDataGrid.datagrid('removeEditor',['LocDesc']);
                    }
                }
              }else{
		           $.messager.alert('��ʾ',"��ѡ��һ�����ƿ��Ҽ�¼");	
		      }
            }
        },
        '-',*/ {
            text: '����',
            iconCls: 'icon-save',
            handler: function() {
	            if (CurrLocId!="")
	            {
                //����ʱ������ǰ�༭���У��Զ�����onAfterEdit�¼����Ҫ���̨�����ɽ�����ͨ��Ajax�ύ��̨
                if (editRow2 != undefined)
                {
                	var editors = cureItemCatDataGrid.datagrid('getEditors', editRow2);      
					var ItemCatId =  editors[0].target.combobox('getValue');
					//console.info("����:"+CurrLocId+"^"+ItemCatId)
                	$.dhc.util.runServerMethod("web.DHCDocCureAppConfig","SavecureItemCat","false",function testget(value){
	                	//console.info(value);
						if(value=="0"){
							cureItemCatDataGrid.datagrid("endEdit", editRow2);
                			editRow2 = undefined;
							cureItemCatDataGrid.datagrid('load');
           					cureItemCatDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"��ʾ",msg:"����ɹ�"});           					
						}else{
							$.messager.alert('��ʾ',"����ʧ��:"+value);
							return false;
						}
						editRow2 = undefined;
						},"","",CurrLocId,ItemCatId);
            		}
            	}else{
		           $.messager.alert('��ʾ',"��ѡ��һ�����ƿ��Ҽ�¼");	
		      }
             }
        },
        '-', {
            text: 'ȡ���༭',
            iconCls: 'icon-redo',
            handler: function() {
                //ȡ����ǰ�༭�аѵ�ǰ�༭�а�undefined�ع��ı������,ȡ��ѡ�����
                editRow2 = undefined;
                cureItemCatDataGrid.datagrid("rejectChanges");
                cureItemCatDataGrid.datagrid("unselectAll");
            }
        }];
    var cureItemCatColumns=[[    
        			{ field: 'ItemCatDesc', title: 'ҽ������', width: 100, align: 'center', sortable: true, resizable: true,
        			  editor :{  
							type:'combobox',  
							options:{
								url:"./dhcdoc.cure.query.combo.easyui.csp",
								valueField:'ItemCatRowID',
								textField:'ItemCatDesc',
								required:true,
								onBeforeLoad:function(param){
									param.ClassName = "web.DHCDocCureAppConfig";
									param.QueryName = "FindItemCat";
									param.ArgCnt = 0;
								},
								onSelect:function(rec){
								}
							  }
     					  }
        			},
					{ field: 'LocId', title: '����ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'ItemCatId', title: '����ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true}
    			 ]];
	cureItemCatDataGrid=$("#tabCureItemCatList").datagrid({  
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
		idField:"ItemCatId",
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :cureItemCatColumns,
    	toolbar :cureItemCatToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
			cureItemCatDataGrid.datagrid('selectRow',rowIndex);
			var selected=cureItemCatDataGrid.datagrid('getRows'); 
			var ItemCatId=selected[rowIndex].ItemCatId;
			loadcureItemDataGrid(ItemCatId);
			//loadItemCatAppendDataGrid(ItemCatId);
		}
	});
	//-------------������Ŀ����---------------
	var cureItemToolBar = [{
            text: '���',
            iconCls: 'icon-add',
            handler: function() { //����б�Ĳ�����ť���,�޸�,ɾ����
                //���ʱ���ж��Ƿ��п����༭���У��������ѿ����༭�����н����༭
               if ((CurrLocId!="")&&(CurrItemCatId!=""))
               {
                if (editRow3 != undefined) {
                    //cureItemDataGrid.datagrid("endEdit", editRow3);
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
                    //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                    //����ǰ�༭���и�ֵ
                    editRow3 = 0;
                }
              }else{
	              $.messager.alert('��ʾ',"��ѡ��һ��ҽ�������¼");
	          }
            }
        },
        '-', {
            text: 'ɾ��',
            iconCls: 'icon-remove',
            handler: function() {
	            if ((CurrLocId!="")&&(CurrItemCatId!=""))
	            {
                //ɾ��ʱ�Ȼ�ȡѡ����
                var rows = cureItemDataGrid.datagrid("getSelections");
                //console.info(rows);
                //ѡ��Ҫɾ������
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].ArcimId);
                            }
                            //��ѡ�񵽵��д������鲢��,�ָ�ת�����ַ�����
                            //����ֻ��ǰ̨����û�������ݿ���н������Դ˴�ֻ�ǵ���Ҫ�����̨��id
                            //console.info(ids);
                            var ArcimId=ids.join(',')
                            //console.info("ɾ��:"+CurrLocId+"^"+CurrItemCatId+"^"+ArcimId)
                            $.dhc.util.runServerMethod("web.DHCDocCureAppConfig","DeletecureItem","false",function testget(value){
						if(value=="0"){
							cureItemDataGrid.datagrid('load');
           					cureItemDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
						}else{
							$.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
						}
						editRow3 = undefined;
						},"","",CurrLocId,CurrItemCatId,ArcimId);
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
                }
	          }else{
		           $.messager.alert('��ʾ',"��ѡ��һ��ҽ�������¼");	
		      }
            }
        },
        '-',/* {
            text: '�޸�',
            iconCls: 'icon-edit',
            handler: function() {
	            if ((CurrLocId!="")&&(CurrItemCatId!=""))
	            {
                //�޸�ʱҪ��ȡѡ�񵽵���
                var rows = cureItemDataGrid.datagrid("getSelections");
                //���ֻѡ����һ������Խ����޸ģ����򲻲���
                if (rows.length == 1) {
                    //�޸�֮ǰ�ȹر��Ѿ������ı༭�У�������endEdit�÷���ʱ�ᴥ��onAfterEdit�¼�
                    if (editRow3 != undefined) {
                        cureItemDataGrid.datagrid("endEdit", editRow3);
                    }else{ 
                    	
                        //�������˵�ǰѡ���еı༭״̬֮��
                        //Ӧ��ȡ����ǰ�б������ѡ���У�Ҫ��Ȼ˫��֮���޷���ѡ�������н��б༭
                        var rowIndex = cureItemDataGrid.datagrid("getRowIndex", rows[0]);
                        //�����༭
                        cureItemDataGrid.datagrid("beginEdit", rowIndex);
                        //�ѵ�ǰ�����༭���и�ֵ��ȫ�ֱ���editRow
                        editRow3 = rowIndex; 
                        var selected=cureItemDataGrid.datagrid('getRows');
                        var ArcimId=selected[rowIndex].ArcimId; 
                        var editors = cureItemDataGrid.datagrid('getEditors', editRow3);
                        //console.info(ArcimId)
                        //���ޱ༭��ʱ
                        //��ȡ����ǰѡ���е��±�
						editors[0].target.combobox('setValue',ArcimId);
						cureItemDataGrid.datagrid("unselectAll");
 						//cureItemDataGrid.datagrid('removeEditor',['LocDesc']);
                    }
                }
              }else{
		           $.messager.alert('��ʾ',"��ѡ��һ��ҽ�������¼");	
		      }
            }
        },
        '-',*/ {
            text: '����',
            iconCls: 'icon-save',
            handler: function() {
	            if ((CurrLocId!="")&&(CurrItemCatId!=""))
	            {
                //����ʱ������ǰ�༭���У��Զ�����onAfterEdit�¼����Ҫ���̨�����ɽ�����ͨ��Ajax�ύ��̨
                if (editRow3 != undefined)
                {
                	var editors = cureItemDataGrid.datagrid('getEditors', editRow3);      
					var ArcimId =  editors[0].target.combobox('getValue');
                	$.dhc.util.runServerMethod("web.DHCDocCureAppConfig","SavecureItem","false",function testget(value){
	                	//console.info(value);
						if(value=="0"){
							cureItemDataGrid.datagrid("endEdit", editRow3);
                			editRow3 = undefined;
							cureItemDataGrid.datagrid('load');
           					cureItemDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"��ʾ",msg:"����ɹ�"});           					
						}else{
							$.messager.alert('��ʾ',"����ʧ��:"+value);
							return false;
						}
						editRow3 = undefined;
						},"","",CurrLocId,CurrItemCatId,ArcimId);
            		}
            	}else{
		           $.messager.alert('��ʾ',"��ѡ��һ��ҽ�������¼");	
		      }
             }
        },
        '-', {
            text: 'ȡ���༭',
            iconCls: 'icon-redo',
            handler: function() {
                //ȡ����ǰ�༭�аѵ�ǰ�༭�а�undefined�ع��ı������,ȡ��ѡ�����
                editRow3 = undefined;
                cureItemDataGrid.datagrid("rejectChanges");
                cureItemDataGrid.datagrid("unselectAll");
            }
        }];
    var cureItemColumns=[[    
        			{ field: 'ArcimDesc', title: 'ҽ��������', width: 100, align: 'center', sortable: true, resizable: true,
        			  editor :{  
							type:'combobox',  
							options:{
								url:"./dhcdoc.cure.query.combo.easyui.csp",
								valueField:'ArcimRowID',
								textField:'ArcimDesc',
								required:true,
								onBeforeLoad:function(param){
									param.ClassName = "web.DHCDocCureAppConfig";
									param.QueryName = "FindItem";
									//console.info(CurrItemCatId);
									param.Arg1 = CurrItemCatId;
									param.ArgCnt = 1;
								},
								onSelect:function(rec){
								}
							  }
     					  }
        			},
					{ field: 'ArcimId', title: 'ҽ����ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'ItemCatId', title: '����ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'LocId', title: '����ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true}   
    			 ]];
	cureItemDataGrid=$("#tabCureItemList").datagrid({  
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
		idField:"ArcimId",
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :cureItemColumns,
    	toolbar :cureItemToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
			cureItemDataGrid.datagrid('selectRow',rowIndex);
			var selected=cureItemDataGrid.datagrid('getRows'); 
			var ArcimId=selected[rowIndex].ArcimId;
			//loadItemAppendDataGrid(ArcimId);
		}
	});
	//-------------����󶨷���---------------
	var cureItemCatAppendToolBar = [{
            text: '���',
            iconCls: 'icon-add',
            handler: function() { //����б�Ĳ�����ť���,�޸�,ɾ����
                //���ʱ���ж��Ƿ��п����༭���У��������ѿ����༭�����н����༭
               if ((CurrLocId!="")&&(CurrItemCatId!=""))
               {
                if (editRow4 != undefined) {
                    //cureItemCatAppendDataGrid.datagrid("endEdit", editRow4);
                    return;
                }else{
	                 //���ʱ���û�����ڱ༭���У�����datagrid�ĵ�һ�в���һ��
                    cureItemCatAppendDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //���²������һ�п����༭״̬
                    cureItemCatAppendDataGrid.datagrid("beginEdit", 0);
                    //cureItemCatAppendDataGrid.datagrid('addEditor',LocDescEdit);
                    //����ǰ�༭���и�ֵ
                    editRow4 = 0;
                }
              }else{
	              $.messager.alert('��ʾ',"��ѡ��һ��ҽ�������¼");
	          }
            }
        },
        '-', {
            text: 'ɾ��',
            iconCls: 'icon-remove',
            handler: function() {
	            if ((CurrLocId!="")&&(CurrItemCatId!=""))
	            {
                //ɾ��ʱ�Ȼ�ȡѡ����
                var rows = cureItemCatAppendDataGrid.datagrid("getSelections");
                //console.info(rows);
                //ѡ��Ҫɾ������
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].ArcimId);
                            }
                            //��ѡ�񵽵��д������鲢��,�ָ�ת�����ַ�����
                            //����ֻ��ǰ̨����û�������ݿ���н������Դ˴�ֻ�ǵ���Ҫ�����̨��id
                            //console.info(ids);
                            var ArcimId=ids.join(',')
                            //console.info("ɾ��:"+CurrLocId+"^"+CurrItemCatId+"^"+ArcimId)
                            $.dhc.util.runServerMethod("web.DHCDocCureAppConfig","DeleteItemCatAppend","false",function testget(value){
						if(value=="0"){
							cureItemCatAppendDataGrid.datagrid('load');
           					cureItemCatAppendDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
						}else{
							$.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
						}
						editRow4 = undefined;
						},"","",CurrLocId,CurrItemCatId,ArcimId);
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
                }
	          }else{
		           $.messager.alert('��ʾ',"��ѡ��һ��ҽ�������¼");	
		      }
            }
        },
        '-', {
            text: '����',
            iconCls: 'icon-save',
            handler: function() {
	            if ((CurrLocId!="")&&(CurrItemCatId!=""))
	            {
                //����ʱ������ǰ�༭���У��Զ�����onAfterEdit�¼����Ҫ���̨�����ɽ�����ͨ��Ajax�ύ��̨
                if (editRow4 != undefined)
                {
                	var editors = cureItemCatAppendDataGrid.datagrid('getEditors', editRow4);      
					var ArcimId =  editors[0].target.combobox('getValue');
					//console.info(CurrLocId+","+CurrItemCatId+","+ArcimId);
                	$.dhc.util.runServerMethod("web.DHCDocCureAppConfig","SaveItemCatAppend","false",function testget(value){
	                	//console.info(value);
						if(value=="0"){
							cureItemCatAppendDataGrid.datagrid("endEdit", editRow4);
                			editRow4 = undefined;
							cureItemCatAppendDataGrid.datagrid('load');
           					cureItemCatAppendDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"��ʾ",msg:"����ɹ�"});           					
						}else{
							if(value=="100") value="��ѡ��ҽ����"
							if(value=="110") value="�Ѿ���������,������Ŀֻ�ܰ�һ��"
							$.messager.alert('��ʾ',"����ʧ��:"+value);
							return false;
						}
						editRow4 = undefined;
						},"","",CurrLocId,CurrItemCatId,ArcimId);
            		}
            	}else{
		           $.messager.alert('��ʾ',"��ѡ��һ��ҽ�������¼");	
		      }
             }
        },
        '-', {
            text: 'ȡ���༭',
            iconCls: 'icon-redo',
            handler: function() {
                //ȡ����ǰ�༭�аѵ�ǰ�༭�а�undefined�ع��ı������,ȡ��ѡ�����
                editRow4 = undefined;
                cureItemCatAppendDataGrid.datagrid("rejectChanges");
                cureItemCatAppendDataGrid.datagrid("unselectAll");
            }
        }];
    var cureItemCatAppendColumns=[[    
        			{ field: 'ArcimDesc', title: 'ҽ��������', width: 100, align: 'center', sortable: true, resizable: true,
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
					{ field: 'ArcimId', title: 'ҽ����ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'ItemCatId', title: '����ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'LocId', title: '����ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true}   
    			 ]];
	cureItemCatAppendDataGrid=$("#tabCureItemCatAppendList").datagrid({  
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
		//pagination : true,  //
		rownumbers : true,  //
		idField:"ArcimId",
		//pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :cureItemCatAppendColumns,
    	toolbar :cureItemCatAppendToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onDblClickRow:function(rowIndex, rowData){
		}
	});
	//-------------������Ŀ�󶨷���---------------
	var cureItemAppendToolBar = [{
            text: '���',
            iconCls: 'icon-add',
            handler: function() { //����б�Ĳ�����ť���,�޸�,ɾ����
                //���ʱ���ж��Ƿ��п����༭���У��������ѿ����༭�����н����༭
               //console.info("ADD:"+CurrLocId+"^"+CurrItemCatId+"^"+CurrArcimId); 
               if ((CurrLocId!="")&&(CurrItemCatId!="")&&(CurrArcimId!=""))
               {
                if (editRow5 != undefined) {
                    //cureItemAppendDataGrid.datagrid("endEdit", editRow5);
                    return;
                }else{
	                 //���ʱ���û�����ڱ༭���У�����datagrid�ĵ�һ�в���һ��
                    cureItemAppendDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //���²������һ�п����༭״̬
                    cureItemAppendDataGrid.datagrid("beginEdit", 0);
                    //cureItemAppendDataGrid.datagrid('addEditor',LocDescEdit);
                    //����ǰ�༭���и�ֵ
                    editRow5 = 0;
                }
              }else{
	              $.messager.alert('��ʾ',"��ѡ��һ��ҽ����Ŀ��¼");
	          }
            }
        },
        '-', {
            text: 'ɾ��',
            iconCls: 'icon-remove',
            handler: function() {
	            if ((CurrLocId!="")&&(CurrItemCatId!="")&&(CurrArcimId!=""))
	            {
                //ɾ��ʱ�Ȼ�ȡѡ����
                var rows = cureItemAppendDataGrid.datagrid("getSelections");
                //console.info(rows);
                //ѡ��Ҫɾ������
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].AppendArcimId);
                            }
                            //��ѡ�񵽵��д������鲢��,�ָ�ת�����ַ�����
                            //����ֻ��ǰ̨����û�������ݿ���н������Դ˴�ֻ�ǵ���Ҫ�����̨��id
                            //console.info(ids);
                            var AppendArcimId=ids.join(',')
                            //console.info("ɾ��:"+CurrLocId+"^"+CurrItemCatId+"^"+CurrArcimId)
                            $.dhc.util.runServerMethod("web.DHCDocCureAppConfig","DeleteItemAppend","false",function testget(value){
						if(value=="0"){
							cureItemAppendDataGrid.datagrid('load');
           					cureItemAppendDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
						}else{
							if (value=="100") value="��ѡ��һ��������Ŀ"
							else if (value=="110") value="��¼������"
							$.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
						}
						editRow5 = undefined;
						},"","",CurrLocId,CurrItemCatId,CurrArcimId,AppendArcimId);
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
                }
	          }else{
		           $.messager.alert('��ʾ',"��ѡ��һ��ҽ����Ŀ��¼");	
		      }
            }
        },
        '-', {
            text: '����',
            iconCls: 'icon-save',
            handler: function() {
	            if ((CurrLocId!="")&&(CurrItemCatId!="")&&(CurrArcimId!=""))
	            {
                //����ʱ������ǰ�༭���У��Զ�����onAfterEdit�¼����Ҫ���̨�����ɽ�����ͨ��Ajax�ύ��̨
                if (editRow5 != undefined)
                {
                	var editors = cureItemAppendDataGrid.datagrid('getEditors', editRow5);      
					var AppendArcimId =  editors[0].target.combobox('getValue');
					//console.info("Save:"+CurrLocId+","+CurrItemCatId+","+CurrArcimId+","+AppendArcimId)
                	$.dhc.util.runServerMethod("web.DHCDocCureAppConfig","SaveItemAppend","false",function testget(value){
	                	//console.info(value);
						if(value=="0"){
							cureItemAppendDataGrid.datagrid("endEdit", editRow5);
                			editRow5 = undefined;
							cureItemAppendDataGrid.datagrid('load');
           					cureItemAppendDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"��ʾ",msg:"����ɹ�"});           					
						}else{
							if(value=="100") value="��ѡ��ҽ����"
							if(value=="110") value="�Ѿ���������,������Ŀֻ�ܰ�һ��"
							$.messager.alert('��ʾ',"����ʧ��:"+value);
							return false;
						}
						editRow5 = undefined;
						},"","",CurrLocId,CurrItemCatId,CurrArcimId,AppendArcimId);
            		}
            	}else{
		           $.messager.alert('��ʾ',"��ѡ��һ��ҽ����Ŀ��¼");	
		      }
             }
        },
        '-', {
            text: 'ȡ���༭',
            iconCls: 'icon-redo',
            handler: function() {
                //ȡ����ǰ�༭�аѵ�ǰ�༭�а�undefined�ع��ı������,ȡ��ѡ�����
                editRow5 = undefined;
                cureItemAppendDataGrid.datagrid("rejectChanges");
                cureItemAppendDataGrid.datagrid("unselectAll");
            }
        }];
    var cureItemAppendColumns=[[    
        			{ field: 'ArcimDesc', title: 'ҽ��������', width: 100, align: 'center', sortable: true, resizable: true,
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
					{ field: 'ArcimId', title: 'ҽ����ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'AppendArcimId', title: '����ҽ����ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'ItemCatId', title: '����ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'LocId', title: '����ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true}   
    			 ]];
	cureItemAppendDataGrid=$("#tabCureItemAppendList").datagrid({  
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
		//pagination : true,  //
		rownumbers : true,  //
		idField:"AppendArcimId",
		//pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :cureItemAppendColumns,
    	toolbar :cureItemAppendToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onDblClickRow:function(rowIndex, rowData){
		}
	});
});
function loadcureItemCatDataGrid(LocId)
{
	if(LocId=="")return;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocCureAppConfig';
	queryParams.QueryName ='FindCurecureItemCat';
	queryParams.Arg1 =LocId;	
	queryParams.ArgCnt =1;
	var opts = cureItemCatDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureItemCatDataGrid.datagrid('load', queryParams);
	//console.info(LocId);
	CurrLocId=LocId;
	editRow2 = undefined;
	editRow3 = undefined;
	editRow4 = undefined;
	editRow5 = undefined;
}
function loadcureItemDataGrid(ItemCatId)
{
	if(ItemCatId=="")return;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocCureAppConfig';
	queryParams.QueryName ='FindCurecureItem';
	queryParams.Arg1 =CurrLocId;
	queryParams.Arg2 =ItemCatId;	
	queryParams.ArgCnt =2;
	var opts = cureItemCatDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureItemDataGrid.datagrid('load', queryParams);
	//console.info(ItemCatId);
	CurrItemCatId=ItemCatId;
	editRow3 = undefined;
	editRow4 = undefined;
	editRow5 = undefined;
}
function loadItemCatAppendDataGrid(ItemCatId)
{
	if(ItemCatId=="")return;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocCureAppConfig';
	queryParams.QueryName ='FindItemCatAppend';
	queryParams.Arg1 =CurrLocId;
	queryParams.Arg2 =ItemCatId;	
	queryParams.ArgCnt =2;
	var opts = cureItemCatAppendDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureItemCatAppendDataGrid.datagrid('load', queryParams);
	//console.info("ItemCatId:"+CurrLocId+","+ItemCatId);
	editRow4 = undefined;
}
function loadItemAppendDataGrid(ItemId)
{
	if(ItemId=="")return;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocCureAppConfig';
	queryParams.QueryName ='FindItemAppend';
	queryParams.Arg1 =CurrLocId;
	queryParams.Arg2 =CurrItemCatId;
	queryParams.Arg3 =ItemId;	
	queryParams.ArgCnt =3;
	var opts = cureItemAppendDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureItemAppendDataGrid.datagrid('load', queryParams);
	CurrArcimId=ItemId;
	editRow5 = undefined;
	//console.info("CurrArcimId:"+ItemId);
}
