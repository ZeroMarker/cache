	var CurrLocId=""; //��¼ѡ�е���
    var locDataGrid; //����ȫ�ֱ���datagrid
    var editRow = undefined; //����ȫ�ֱ�������ǰ�༭����
    var locRoomDataGrid; //����ȫ�ֱ���datagrid
    var editRow2 = undefined; //����ȫ�ֱ�������ǰ�༭����
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
                            $.dhc.util.runServerMethod("web.DHCDocCureAppConfig","DeleteLoc","false",function testget(value){
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
        '-', /*{
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
                        //console.info(LocId)
                        //���ޱ༭��ʱ
                        //��ȡ����ǰѡ���е��±�
						editors[0].target.combobox('setValue',LocId);
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
					if (LocId=="")
					{
						$.messager.alert('��ʾ',"��ѡ�����");
						return false;
					}
                	$.dhc.util.runServerMethod("web.DHCDocCureAppConfig","SaveLoc","false",function testget(value){
	                	//console.info(value);
						if(value=="0"){
							locDataGrid.datagrid("endEdit", editRow);
                			editRow = undefined;
							locDataGrid.datagrid('load');
           					locDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"��ʾ",msg:"����ɹ�"});           					
						}else{
							$.messager.alert('��ʾ',"����ʧ��:"+value);
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
                editRow = undefined;
                locDataGrid.datagrid("rejectChanges");
                locDataGrid.datagrid("unselectAll");
            }
        }];
    var LocRowID=""
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
			param.QueryName ='FindCureLoc';
			param.ArgCnt =0;
		},
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
			//console.info(rowIndex);
			locDataGrid.datagrid('selectRow',rowIndex);
			var selected=locDataGrid.datagrid('getRows'); 
			var LocId=selected[rowIndex].LocId;
			//console.info(LocId)
			loadLocRoomDataGrid(LocId);
		}
	});
	//--------------���Ҵ���---------------
	var locRoomToolBar = [{
            text: '���',
            iconCls: 'icon-add',
            handler: function() { //����б�Ĳ�����ť���,�޸�,ɾ����
                //���ʱ���ж��Ƿ��п����༭���У��������ѿ����༭�����н����༭
               if (CurrLocId!="")
               {
                if (editRow2 != undefined) {
                    //locRoomDataGrid.datagrid("endEdit", editRow2);
                    return;
                }else{
	                 //���ʱ���û�����ڱ༭���У�����datagrid�ĵ�һ�в���һ��
                    locRoomDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //���²������һ�п����༭״̬
                    locRoomDataGrid.datagrid("beginEdit", 0);
                    //locRoomDataGrid.datagrid('addEditor',LocDescEdit);
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
                var rows = locRoomDataGrid.datagrid("getSelections");
                //ѡ��Ҫɾ������
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].RoomId);
                            }
                            //��ѡ�񵽵��д������鲢��,�ָ�ת�����ַ�����
                            //����ֻ��ǰ̨����û�������ݿ���н������Դ˴�ֻ�ǵ���Ҫ�����̨��id
                            var LocRoomID=ids.join(',')
                            //console.info("ɾ��:"+CurrLocId+"^"+LocRoomID)
                            $.dhc.util.runServerMethod("web.DHCDocCureAppConfig","DeleteLocRoom","false",function testget(value){
						if(value=="0"){
							locRoomDataGrid.datagrid('load');
           					locRoomDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
						}else{
							$.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
						}
						editRow2 = undefined;
						},"","",CurrLocId,LocRoomID);
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
        '-', {
            text: '�޸�',
            iconCls: 'icon-edit',
            handler: function() {
	            if (CurrLocId!="")
	            {
                //�޸�ʱҪ��ȡѡ�񵽵���
                var rows = locRoomDataGrid.datagrid("getSelections");
                //���ֻѡ����һ������Խ����޸ģ����򲻲���
                if (rows.length == 1) {
                    //�޸�֮ǰ�ȹر��Ѿ������ı༭�У�������endEdit�÷���ʱ�ᴥ��onAfterEdit�¼�
                    if (editRow2 != undefined) {
                        locRoomDataGrid.datagrid("endEdit", editRow2);
                    }else{ 
                    	
                        //�������˵�ǰѡ���еı༭״̬֮��
                        //Ӧ��ȡ����ǰ�б������ѡ���У�Ҫ��Ȼ˫��֮���޷���ѡ�������н��б༭
                        var rowIndex = locRoomDataGrid.datagrid("getRowIndex", rows[0]);
                        //�����༭
                        locRoomDataGrid.datagrid("beginEdit", rowIndex);
                        //�ѵ�ǰ�����༭���и�ֵ��ȫ�ֱ���editRow
                        editRow2 = rowIndex; 
                        var selected=locRoomDataGrid.datagrid('getRows');
                        var RoomId=selected[rowIndex].RoomId;
                        var NeedAppFlag=selected[rowIndex].NeedAppFlag; 
                        var AppStartTime=selected[rowIndex].AppStartTime;
                        var AppTimeLength=selected[rowIndex].AppTimeLength;
                        var AppTimeRangeLimit=selected[rowIndex].AppTimeRangeLimit;   
                        var editors = locRoomDataGrid.datagrid('getEditors', editRow2);
                        //console.info(RoomId+"^"+AppStartTime+"^"+AppTimeLength)
                        //���ޱ༭��ʱ
                        //��ȡ����ǰѡ���е��±�
						editors[0].target.combobox('setValue',RoomId);
						editors[1].target.combobox('setValue',NeedAppFlag);
						editors[2].target.combobox('setValue',AppStartTime);
						editors[3].target.combobox('setValue',AppTimeLength);
						editors[4].target.numberbox('setValue',AppTimeRangeLimit);
						locRoomDataGrid.datagrid("unselectAll");
 						//locRoomDataGrid.datagrid('removeEditor',['LocDesc']);
                    }
                }
              }else{
		           $.messager.alert('��ʾ',"��ѡ��һ�����ƿ��Ҽ�¼");	
		      }
            }
        },
        '-', {
            text: '����',
            iconCls: 'icon-save',
            handler: function() {
	            if (CurrLocId!="")
	            {
                //����ʱ������ǰ�༭���У��Զ�����onAfterEdit�¼����Ҫ���̨�����ɽ�����ͨ��Ajax�ύ��̨
                if (editRow2 != undefined)
                {
                	var editors = locRoomDataGrid.datagrid('getEditors', editRow2);      
					var RoomId =  editors[0].target.combobox('getValue');
					var NeedAppFlag =  editors[1].target.combobox('getValue');
					var AppStartTime =  editors[2].target.combobox('getValue');
					var AppTimeLength =  editors[3].target.combobox('getValue');
					var AppTimeRangeLimit =  editors[4].target.numberbox('getValue');
					if (NeedAppFlag==0){
						if (RoomId==""){
						$.messager.alert("��ʾ","����д����");
						return false;
							
						}
							
					}else{
						if ((RoomId=="")||(NeedAppFlag=="")||(AppStartTime=="")||(AppTimeLength=="")||(AppTimeRangeLimit==""))
						{
						$.messager.alert("��ʾ","����������д����");
						return false;
						}
						
					}
					
					//console.info("����:"+RoomId+"^"+AppStartTime+"^"+AppTimeLength+"^"+AppTimeRangeLimit)
                	$.dhc.util.runServerMethod("web.DHCDocCureAppConfig","SaveLocRoom","false",function testget(value){
	                	//console.info(value);
						if(value=="0"){
							locRoomDataGrid.datagrid("endEdit", editRow2);
                			editRow2 = undefined;
							locRoomDataGrid.datagrid('load');
           					locRoomDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"��ʾ",msg:"����ɹ�"});           					
						}else{
							$.messager.alert('��ʾ',"����ʧ��:"+value);
						}
						editRow2 = undefined;
						},"","",CurrLocId,RoomId,NeedAppFlag,AppStartTime,AppTimeLength,AppTimeRangeLimit);
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
                locRoomDataGrid.datagrid("rejectChanges");
                locRoomDataGrid.datagrid("unselectAll");
            }
        }];
    var locRoomColumns=[[    
        			{ field: 'RoomDesc', title: '��������', width: 100, align: 'center', sortable: true, resizable: true,
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
        			{ field: 'NeedAppDesc', title: '�Ƿ�����ԤԼ', width: 100, align: 'center', sortable: true, resizable: true,
					  editor:{  
							type:'combobox',  
							options:{
								valueField:'AppFlag',
								textField:'AppFlagDesc',
								required:true,
								data: [{
										AppFlagDesc: '��',
										AppFlag: '1'
									},{
										AppFlagDesc: '��',
										AppFlag: '0'
									}],
								onSelect:function(rec){
									
								}
							}
						}
					},
					{ field: 'AppStartTime', title: 'ԤԼ��ʼʱ��', width: 100, align: 'center', sortable: true, resizable: true,
					  editor:{  
							type:'combobox',  
							options:{
								valueField:'TimeValue',
								textField:'TimeDesc',
								required:true,
								data: [{
										TimeDesc: '6:00',
										TimeValue: '6:00'
									},{
										TimeDesc: '7:00',
										TimeValue: '7:00'
									},{
										TimeDesc: '8:00',
										TimeValue: '8:00'
									},{
										TimeDesc: '9:00',
										TimeValue: '9:00'
									},{
										TimeDesc: '10:00',
										TimeValue: '10:00'
									},{
										TimeDesc: '11:00',
										TimeValue: '11:00'
									},{
										TimeDesc: '12:00',
										TimeValue: '12:00'
									},{
										TimeDesc: '13:00',
										TimeValue: '13:00'
									},{
										TimeDesc: '14:00',
										TimeValue: '14:00'
									},{
										TimeDesc: '15:00',
										TimeValue: '15:00'
									}],
								onSelect:function(rec){
									
								}
							}
						}
					},
					{ field: 'AppTimeLengthDesc', title: 'ԤԼʱ��γ���', width: 100, align: 'center', sortable: true, resizable: true,
					  editor:{  
							type:'combobox',  
							options:{
								valueField:'TimeLengthValue',
								textField:'TimeLengthDesc',
								required:true,
								data: [{
										TimeLengthDesc: '30����',
										TimeLengthValue: '1800'
									},{
										TimeLengthDesc: '1Сʱ',
										TimeLengthValue: '3600'
									},{
										TimeLengthDesc: '1����Сʱ',
										TimeLengthValue: '5400'
									},{
										TimeLengthDesc: '2Сʱ',
										TimeLengthValue: '7200'
									}],
								onSelect:function(rec){
									
								}
							}
						}
					},
					{ field: 'AppTimeRangeLimit', title: 'ÿ��ʱ������˴�', width: 100, align: 'center', sortable: true, resizable: true,
						editor:{  
							type:'numberbox',
							options:{
								min:1,
								required:true   
							}  
						}
					},
					{ field: 'LocId', title: '����ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'RoomId', title: '����ID', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},
					{ field: 'NeedAppFlag', title: 'ԤԼFlag', width: 100, align: 'center', sortable: true, resizable: true,hidden:true},	    	    
					{ field: 'AppTimeLength', width: 100, align: 'center', sortable: true, resizable: true,hidden:true}	 	    	    
    			 ]];
	locRoomDataGrid=$("#tabCureLocRoomList").datagrid({  
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
		idField:"RoomId",
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :locRoomColumns,
    	toolbar :locRoomToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onDblClickRow:function(rowIndex, rowData){
		}
	});
});
function loadLocRoomDataGrid(LocId)
{
	if(LocId=="")return;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocCureAppConfig';
	queryParams.QueryName ='FindCureLocRoom';
	queryParams.Arg1 =LocId;	
	queryParams.ArgCnt =1;
	var opts = locRoomDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	locRoomDataGrid.datagrid('load', queryParams);
	//console.info(LocId);
	CurrLocId=LocId;
	editRow2 = undefined;
}
