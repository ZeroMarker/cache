// /����: ʵ��������
// /����:  ʵ��������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.09.10
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrDetailParams='';
    var gStrParams='';
    var url=DictUrl+'instktkaction.csp';
    var gGroupId=session["LOGON.GROUPID"];
    var gLocId=session["LOGON.CTLOCID"];
    var gUserId=session["LOGON.USERID"];
    var PhaLoc = new Ext.ux.LocComboBox({
                fieldLabel : '����',
                id : 'PhaLoc',
                name : 'PhaLoc',
                anchor : '90%',
                width : 160,
                emptyText : '����...',
                listWidth : 250,
                //hideLabel:true,
                valueNotFoundText : '',
                groupId:gGroupId,
                stkGrpId : 'StkGrpType'
            });
    
    // ��ʼ����
    var StartDate = new Ext.ux.DateField({
                fieldLabel : '��ʼ����',
                id : 'StartDate',
                name : 'StartDate',
                anchor : '90%',
                
                width : 120,
                value : new Date().add(Date.DAY, - 7)
            });

    // ��������
    var EndDate = new Ext.ux.DateField({
                fieldLabel : '��������',
                id : 'EndDate',
                name : 'EndDate',
                anchor : '90%',
                
                width : 120,
                value : new Date()
            });

    var StkGrpType=new Ext.ux.StkGrpComboBox({ 
        id : 'StkGrpType',
        name : 'StkGrpType',
        StkType:App_StkTypeCode,     //��ʶ��������
        LocId:gLocId,
        UserId:gUserId,
        width : 140,
        childCombo : 'DHCStkCatGroup'
    }); 

    var DHCStkCatGroup = new Ext.ux.ComboBox({
                fieldLabel : '������',
                id : 'DHCStkCatGroup',
                name : 'DHCStkCatGroup',
                anchor : '90%',
                width : 140,
                store : StkCatStore,
                valueField : 'RowId',
                displayField : 'Description',
                params : {StkGrpId : 'StkGrpType'}
            });

    // ��ѯ�̵㵥
    var QueryBT = new Ext.Toolbar.Button({
                text : '��ѯ',
                tooltip : '�����ѯ',
                iconCls : 'page_find',
                width : 70,
                height : 30,
                handler : function() {
                    Query();
                }
            });

    
    //��ѯ�̵㵥
    function Query(){
    
        InstDetailGrid.store.removeAll();
        InstDetailGrid.getView().refresh();
        
        var StartDate = Ext.getCmp("StartDate").getValue().format(ARG_DATEFORMAT).toString();;
        var EndDate = Ext.getCmp("EndDate").getValue().format(ARG_DATEFORMAT).toString();
        var PhaLoc = Ext.getCmp("PhaLoc").getValue();   
        if(PhaLoc==""){
            Msg.info("warning", "��ѡ���̵����!");
            return;
        }
        if(StartDate==""||EndDate==""){
            Msg.info("warning", "��ѡ��ʼ���ںͽ�ֹ����!");
            return;
        }
        var CompFlag='Y';       //�������
        //var TkComplete='N';  //ʵ����ɱ�־
        var TkComplete=(Ext.getCmp('TkComplete').getValue()==true?'Y':'N');;  //ʵ����ɱ�־
        var AdjComplete='N';    //������ɱ�־
        var Page=GridPagingToolbar.pageSize;
        gStrParams=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete;
        
        if(TkComplete=="Y"){changeButtonEnable('0^1')}
        else{changeButtonEnable('1^0')}
        
        MasterInfoStore.removeAll();
        InstItmStore.removeAll();
        InstiStore.removeAll();
        InstDetailStore.removeAll();
        
		MasterInfoStore.setBaseParam('actiontype','Query');
		MasterInfoStore.setBaseParam('sort','instNo');
		MasterInfoStore.setBaseParam('dir','asc');
		MasterInfoStore.setBaseParam('Params',gStrParams);
		MasterInfoStore.removeAll();
        MasterInfoStore.load({params:{start:0, limit:Page}});
    }
    
    // ��ѯʵ����ϸ��ť
    var SearchBT = new Ext.Toolbar.Button({
                text : '��ѯ',
                tooltip : '�����ѯ',
                iconCls : 'page_find',
                width : 70,
                height : 30,
                handler : function() {
                    QueryDetail();
                }
            });
    
    // ��հ�ť
    var RefreshBT = new Ext.Toolbar.Button({
                text : '���',
                tooltip : '������',
                iconCls : 'page_clearscreen',
                width : 70,
                height : 30,
                handler : function() {
                    clearData();
                }
            });

    /**
     * ��շ���
     */
    function clearData() {
        
        Ext.getCmp("DHCStkCatGroup").setValue('');
        //Ext.getCmp("Complete").setValue(false);
        Ext.getCmp("StkGrpType").setValue('');
        
        InstDetailGrid.store.removeAll();
        InstDetailGrid.getView().refresh();
    }

    var CompleteBT=new Ext.Toolbar.Button({
        text:'ȷ�����',
        tooltip:'ȷ�����',
        iconCls:'page_gear',
        width:70,
        height:30,
        handler:function(){
            Complete();
        }
    });
    
    //����ʵ������
    function Complete(){
        var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
        if(selectRow==null){
        	Msg.info("warning","û����Ҫȷ�ϻ��ܵ��̵㵥!");
        	return;
        }
        var Inst=selectRow.get("inst");
        var InputType=selectRow.get("InputType");
        if(InputType==''){
        	Msg.info("warning","���̵㵥��δ����ʵ��¼��!");
        	return;
        }
       
        var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
        Ext.Ajax.request({
            url:url,
            params:{actiontype:'StkTkCompletet',Inst:Inst,UserId:gUserId,InputType:InputType},
            method:'post',
            waitMsg:'������...',
            success:function(response,opt){
                var jsonData=Ext.util.JSON.decode(response.responseText);
                 mask.hide();
                if(jsonData.success=='true'){
                    Msg.info('success','�����ɹ�!');
                    Query();
                }else{
                    var ret=jsonData.info;
                    if(ret=='-1'){
                        Msg.info('warning','û����Ҫȷ�ϵ��̵㵥!');
                    }else if(ret=='-99'){
                        Msg.info('error','����ʧ��!');
                    }else if(ret=='-2'){
                        Msg.info('error','ʵ�����Ѿ�ȷ�ϻ���!');
                    }else if(ret=='-5'){
                        Msg.info('error','����ʵ����ʧ��!');
                    }else if(ret=='-100'){
                        Msg.info('error','����ʵ�̱�־ʧ��!');
                    }else{
                        Msg.info('error','����ʧ��:'+ret);
                    }
                }
            }       
        });
    }
     var TkComplete=new Ext.form.Checkbox({
		fieldLabel:'�������',
		id:'TkComplete',
		name:'TkComplete',
		width:80,
		disabled:false
		//checked :true
	});
    //ȡ�����
    var CancelCompleteBT = new Ext.Toolbar.Button({
                text : '<font color=red>ȡ�����</font>',
                tooltip : 'ȡ������',
                iconCls:'page_gear',
                width : 70,
                height : 30,
                handler : function(){
                    Cancel();
                }
            });

     function Cancel(){
        var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
        if(selectRow==null){
        	Msg.info("warning","û����Ҫȡ�����ܵ��̵㵥!");
        	return;
        }
        
	    Ext.MessageBox.confirm("ȡ������","�Ƿ�ȷ��ȡ�����ܸ��̵㵥!",function(btn){
		    if(btn == 'yes'){
			    var Inst=selectRow.get("inst");
                var mask=ShowLoadMask(Ext.getBody(),"������...");
		        Ext.Ajax.request({
		            url:url,
		            params:{actiontype:'StkCancelComplete',Inst:Inst},
		            method:'post',
		            waitMsg:'������...',
		            success:function(response,opt){
		                var jsonData=Ext.util.JSON.decode(response.responseText);
		                if(jsonData.success=='true'){
		                    Msg.info('success','�����ɹ�!');
		                    Query();
		                }else{
		                    var ret=jsonData.info;
		                    if(ret=='-1'){
		                        Msg.info('warning','û����Ҫȷ�ϵ��̵㵥!');
		                    }else if(ret=='-2'){
		                        Msg.info('error','û����Ҫȷ�ϵ��̵㵥!');
		                    }else if(ret=='-3'){
		                        Msg.info('error','ʵ�����Ѿ�ȷ���̵�!');
		                    }else if(ret=='-4'){
		                        Msg.info('error','�ü�¼û�л��ܣ�');
		                    }else{
		                        Msg.info('error','����ʧ��:'+ret);
		                    }
		                }
		                mask.hide();
		            }       
		        })} 
		        });
     }
        function changeButtonEnable(str) {
			var list = str.split("^");
			for (var i = 0; i < list.length; i++) {
				if (list[i] == "1") {
					list[i] = false;
				} else {
					list[i] = true;
				}
			}
			//��ѯ^���^����^����^ɾ��^���^ȡ�����
			CompleteBT.setDisabled(list[0]);
			CancelCompleteBT.setDisabled(list[1]);
    }     
    // ָ���в���
    // ָ���в���
    var fields = ["inst","instNo", "date", "time","userName","status","locDesc", "comp", "stktkComp",
            "adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb","InputType"];
    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
                root : 'rows',
                totalProperty : "results",
                id : "inst",
                fields : fields
            });
    // ���ݼ�
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
                url : url,
                method : "POST"
            });
    var MasterInfoStore = new Ext.data.Store({
                proxy : proxy,
                reader : reader
            }); 
    
    function renderCompFlag(value){
        if(value=='Y'){
            return '���';
        }else{
            return 'δ���'
        }   
    }
    function renderManaFlag(value){
        if(value=='Y'){
            return '��';
        }else{
            return '��'
        }   
    }
    function renderYesNo(value){
        if(value=='Y'){
            return '��';
        }else{
            return '��'
        }   
    }
    
    var nm = new Ext.grid.RowNumberer();
    var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
                header : "RowId",
                dataIndex : 'inst',
                width : 100,
                align : 'left',
                sortable : true,
                hidden : true,
                hideable : false
            }, {
                header : "�̵㵥��",
                dataIndex : 'instNo',
                width : 120,
                align : 'left',
                sortable : true
            }, {
                header : "�̵�����",
                dataIndex : 'date',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : '�̵�ʱ��',
                dataIndex : 'time',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : '�̵���',
                dataIndex : 'userName',
                width : 70,
                align : 'left',
                sortable : true
            }, {
                header : '�ص��ע',
                dataIndex : 'manFlag',
                width : 50,
                align : 'left',
                renderer:renderManaFlag,
                sortable : true
            }, {
                header : "���̵�λ",
                dataIndex : 'freezeUom',
                width : 80,
                align : 'left',
                renderer:function(value){
                    if(value==1){
                        return '��ⵥλ';
                    }else{
                        return '������λ';
                    }
                },
                sortable : true
            }, {
                header : "����������",
                dataIndex : 'includeNotUse',
                width : 50,
                align : 'center',
                renderer:renderYesNo,
                sortable : true
            }, {
                header : "��������",
                dataIndex : 'onlyNotUse',
                renderer:renderYesNo,
                width : 50,
                align : 'center',
                sortable : true
            }, {
                header : "����",
                dataIndex : 'scgDesc',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "������",
                dataIndex : 'scDesc',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "��ʼ��λ",
                dataIndex : 'frSb',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "��ֹ��λ",
                dataIndex : 'toSb',
                width : 100,
                align : 'left',
                sortable : true
            },{
                header : "ʵ������",
                dataIndex : 'InputType',
                width : 100,
                align : 'left',
                sortable : true,
                renderer:function(value){
                    if(value=='1'){
                        return "������";
                    }else if(value=='2'){
                        return "��Ʒ��";
                    }else if(value=='3'){
						return "����ֵ����";
					}else{
                        return value;
                    }
                }
            }]);
    MasterInfoCm.defaultSortable = true;
    var GridPagingToolbar = new Ext.PagingToolbar({
                    store : MasterInfoStore,
                    pageSize : PageSize,
                    displayInfo : true
                });
    var MasterInfoGrid = new Ext.grid.GridPanel({
                id : 'MasterInfoGrid',
                title : '',
                height : 450,
                cm : MasterInfoCm,
                sm : new Ext.grid.RowSelectionModel({
                            singleSelect : true
                        }),
                store : MasterInfoStore,
                trackMouseOver : true,
                stripeRows : true,
                loadMask : true,
                bbar:[GridPagingToolbar]
            });
        // ˫���¼�
    MasterInfoGrid.on('rowclick', function(grid,rowindex,e) {
        QueryDetail();
    });
    
    //�����̵㵥����ϸ��Ϣ
    function QueryDetail(){
        
        //��ѯ�̵㵥��ϸ
        //var StkGrpId=Ext.getCmp('StkGrpType').getValue();
        //var StkCatId=Ext.getCmp('DHCStkCatGroup').getValue();
        var size=StatuTabPagingToolbar.pageSize;
        var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
        var Inst=selectRow.get("inst");
        gStrDetailParams=Inst;   //+'^'+ManaGrpId+'^'+StkGrpId+'^'+StkCatId+'^'+StkBinId+'^'+PhaWinId;
        InstiStore.removeAll();
        InstDetailStore.removeAll(); 
        InstItmStore.removeAll();
        InstItmStore.setBaseParam('sort', 'Inci');
        InstItmStore.setBaseParam('dir', 'ASC');
        InstItmStore.setBaseParam('Params', gStrDetailParams);
        InstItmStore.load({
        	params:{start:0,limit:size},
        	callback:function(r,options,success){
        		if(success==false){
        			Msg.info("error","��ѯ����, ��鿴��־!");
        		}
        	}
        });
    }
    
    //-------���ʻ���grid----------------------------------------------------------
    var nm = new Ext.grid.RowNumberer();
    var InstItmGridCm = new Ext.grid.ColumnModel([nm, {
                header : "rowid",
                dataIndex : 'Rowid',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : true
            }, {
                header : "Inci",
                dataIndex : 'Inci',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : true
            },{
                header : '����',
                dataIndex : 'InciCode',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "����",
                dataIndex : 'InciDesc',
                width : 250,
                align : 'left',
                sortable : true
            }, {
                header : "���",
                dataIndex : 'Spec',
                width : 120,
                align : 'left',
                sortable : true
            }, {
                header : '��������',
                dataIndex : 'FreezeQty',
                width : 120,
                align : 'right',
                sortable : true
            },{
                header:'ʵ������',
                dataIndex:'CountQty',
                width:120,
                align:'right',
                sortable:true
            },{
                header:'���½���(��ⵥλ)',
                dataIndex:'LastRp',
                width:150,
                align:'right'
            }]);
    InstItmGridCm.defaultSortable = true;

    // ���ݼ�
    var InstItmStore = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                    url : url + '?actiontype=CollectItmCountQty',
                    method : "POST"
                }),
                reader :  new Ext.data.JsonReader({
                    root : 'rows',
                    totalProperty : "results",
                    id : "Rowid",
                    fields : ["Rowid","Inci", "InciCode", "InciDesc", "Spec","PurUomDesc","FreezeQty", "CountQty", "LastRp"]
                })
    });
    var StatuTabPagingToolbar = new Ext.PagingToolbar({
                store : InstItmStore,
                pageSize : PageSize,
                displayInfo : true
            });
    var InstItmGrid = new Ext.grid.GridPanel({
    		title : '���ʻ���',
            id:'InstItmGrid',
            cm : InstItmGridCm,
            store : InstItmStore,
            trackMouseOver : true,
            stripeRows : true,
            height:400,
            view : new Ext.grid.GridView({forceFit : true}),
            sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
            bbar:StatuTabPagingToolbar,
            loadMask : true
        });
    // �����¼�
    InstItmGrid.on('rowclick', function(grid,rowindex,e) {
        var selectRow=InstItmGrid.getSelectionModel().getSelected();
        var inci=selectRow.get("Inci");
        var inst=gStrDetailParams;
        InstiStore.removeAll();
        InstDetailStore.removeAll();
        InstiStore.load({
        	params:{actiontype:'QueryItmTkWd',Inst:inst,Inci:inci},
        	callback:function(r,options,success){
        		if(success==false){
        			Msg.info("error","��ѯ����,��鿴��־!");
        			return;
        		}
        	}
        });
        InstDetailStore.load({
        	params:{actiontype:'QueryItmTkWdDetail',Inst:inst,Inci:inci},
        	callback:function(r,options,success){
        		if(success==false){
        			Msg.info("error","��ѯ����,��鿴��־!");
        			return;
        		}
        	}
        });       
    });
    
    //-------���ʻ���grid----------------------------------------------------------
    
    //-------��������grid----------------------------------------------------------
    var nm = new Ext.grid.RowNumberer();
    var InstiGridCm = new Ext.grid.ColumnModel([nm, {
                header : "rowid",
                dataIndex : 'Insti',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : true
            }, {
                header : "Inclb",
                dataIndex : 'Inclb',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : true
            },{
                header : '����',
                dataIndex : 'BatNo',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : "Ч��",
                dataIndex : 'ExpDate',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "��λ",
                dataIndex : 'FreUomDesc',
                width : 60,
                align : 'left',
                sortable : true
            }, {
                header : '��������',
                dataIndex : 'FreQty',
                width : 80,
                align : 'right',
                sortable : true
            },{
                header:'ʵ������',
                dataIndex:'CountQty',
                width:80,
                align:'right',
                sortable:true
            }]);
    InstiGridCm.defaultSortable = true;

    // ���ݼ�
    var InstiStore = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                    url : url,
                    method : "POST"
                }),
                reader :  new Ext.data.JsonReader({
                    root : 'rows',
                    totalProperty : "results",
                    id : "Insti",
                    fields : ["Insti","Inclb", "BatNo", "ExpDate", "FreUomDesc","FreQty","CountQty"]
                })
    });
    
    var InstiGrid = new Ext.grid.GridPanel({
    		title : '���λ���',
            id:'InstiGrid',
            cm : InstiGridCm,
            store : InstiStore,
            trackMouseOver : true,
            stripeRows : true,
            view : new Ext.grid.GridView({forceFit : true}),
            sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
            loadMask : true
        });     
    //-------��������grid----------------------------------------------------------
    
    //-------ʵ����ϸgrid----------------------------------------------------------
    var nm = new Ext.grid.RowNumberer();
    var InstDetailGridCm = new Ext.grid.ColumnModel([nm, {
                header : "rowid",
                dataIndex : 'Rowid',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : true
            }, {
                header : "Inclb",
                dataIndex : 'Inclb',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : true
            },{
                header : '����',
                dataIndex : 'BatNo',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : "Ч��",
                dataIndex : 'ExpDate',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "��λ",
                dataIndex : 'CountUom',
                width : 60,
                align : 'left',
                sortable : true
            },{
                header:'ʵ������',
                dataIndex:'CountQty',
                width:80,
                align:'right',
                sortable:true
            },{
                header:'ʵ������',
                dataIndex:'CountDate',
                width:80,
                align:'right',
                sortable:true
            },{
                header : "ʵ��ʱ��",
                dataIndex : 'CountTime',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header : "ʵ����",
                dataIndex : 'CountUserName',
                width : 80,
                align : 'left',
                sortable : true
            }]);
    InstDetailGridCm.defaultSortable = true;

    // ���ݼ�
    var InstDetailStore = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                    url : url,
                    method : "POST"
                }),
                reader :  new Ext.data.JsonReader({
                    root : 'rows',
                    totalProperty : "results",
                    id : "Rowid",
                    fields : ["Rowid","Inclb", "BatNo", "ExpDate", "CountUom","CountQty","CountDate", "CountTime", "CountUserName"]
                })
    });
    
    var InstDetailGrid = new Ext.grid.GridPanel({
    		title: '������ϸ',
            id:'InstDetailGrid',
            cm : InstDetailGridCm,
            store : InstDetailStore,
            trackMouseOver : true,
            stripeRows : true,
            view : new Ext.grid.GridView({forceFit : true}),
            sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
            loadMask : true
        });
        
    //-------ʵ����ϸgrid----------------------------------------------------------
        
    var formMain=new Ext.form.FormPanel({
    	region : 'north',
    	autoHeight : true,
        labelAlign : 'right',
        bodyStyle : 'padding:10px 0px 0px 0px;',
        style: 'padding:0 0 0 0;',
        frame:true,
        tbar:[QueryBT,'-',CompleteBT,'-',CancelCompleteBT],
        items:[{
        	xtype : 'fieldset',
        	title : '��ѯ����',
        	items :[PhaLoc,StartDate,EndDate,TkComplete]
        }]
    });

    // 5.2.ҳ�沼��
    var mainPanel = new Ext.ux.Viewport({
                layout : 'border',
                items :  [{
                            region:'west',  
                            width:300,
                            minSize:250,
                            maxSize:400,
                            split: true,
                            collapsible: true, 
                            title:'�̵㵥-ʵ��������',
                            layout:'border',
                            items:[formMain,{
                                        region:'center',
                                        layout:'fit',
                                        items:[MasterInfoGrid]
                                   }]
                        },{
                            region:'center',
                            layout:'border',
                            items:[{
                                        region:'north',
                                        height:400,
                                        minSize:250,
                                        maxSize:400,
                                        split: true,
                                        //collapsible: true, 
                                        layout:'fit',
                                        items:[InstItmGrid ]
                                   },{
                                        region:'east',
                                        width : '55%',
                                        split:true,
                                        minSize:50,
                                        maxSize:500,
                                        //collapsible: true,
                                        layout:'fit',
                                        items:[InstDetailGrid]
                                    },{
                                        region:'center',
                                        layout:'fit',
                                        items:[InstiGrid]
                                    }]
                            
                        }],                 
                renderTo : 'mainPanel'
    });

    Query();
})