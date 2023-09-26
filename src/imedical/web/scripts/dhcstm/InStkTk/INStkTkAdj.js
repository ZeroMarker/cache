// /����: �̵㵥����
// /����: �̵㵥����
// /��д�ߣ�zhangdongmei
// /��д����: 2012.09.12
var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM')
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrParams='';
    var gRowid='';
    var gGroupId=session["LOGON.GROUPID"];
    var url=DictUrl+'instktkaction.csp';
    var PhaLoc = new Ext.ux.LocComboBox({
                fieldLabel : '����',
                id : 'PhaLoc',
                name : 'PhaLoc',
                anchor : '90%',
                emptyText : '����...',
                groupId:gGroupId
            });
    
    // ��ʼ����
    var StartDate = new Ext.ux.DateField({
                fieldLabel : '��ʼ����',
                id : 'StartDate',
                value : new Date().add(Date.DAY, - 30)
            });

    // ��������
    var EndDate = new Ext.ux.DateField({
                fieldLabel : '��������',
                id : 'EndDate',
                value : new Date()
            });
    
    // ��ѯ��ť
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
        var CompFlag='Y';
        var TkComplete='Y';  //ʵ����ɱ�־
        var AdjComplete='N';    //������ɱ�־
        var Page=GridPagingToolbar.pageSize;
        gStrParams=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete;
        MasterInfoStore.load({params:{actiontype:'Query',start:0, limit:Page,sort:'instNo',dir:'asc',Params:gStrParams}});
    }
    
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
        
        gStrParams='';
        var stDate=new Date().add(Date.DAY, - 30);
        var edDate=new Date();
        Ext.getCmp("StartDate").setValue(stDate);
        Ext.getCmp("EndDate").setValue(edDate);
        MasterInfoStore.removeAll();
        InstDetailGrid.store.removeAll();
        InstDetailGrid.getView().refresh();
    }

    var CompleteBT=new Ext.Toolbar.Button({
        text:'ȷ��',
        tooltip:'���ȷ��',
        iconCls:'page_gear',
        width:70,
        height:30,
        handler:function(){
            Complete();
        }
    });
    
    function Complete(){
        
        var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
        if(selectRow==null || selectRow==""){
            Msg.info("Warning","��ѡ��Ҫ�������̵㵥!");
            return;
        }
       
        var inst=selectRow.get('inst');
        if(inst==null || inst==""){
            Msg.info("Warning","��ѡ��Ҫ�������̵㵥!");
            return;
        }
        var userId=session['LOGON.USERID'];
        var mask=ShowLoadMask(Ext.getBody(),"������...");
        Ext.Ajax.request({
            url:url,
            params:{actiontype:'StkTkAdj',Inst:inst,UserId:userId},
            method:'post',
            waitMsg:'������...',
            success:function(response,opt){
                var jsonData=Ext.util.JSON.decode(response.responseText);
                 mask.hide();
                if(jsonData.success=='true'){
                    Msg.info("success","�����ɹ�!");
                    Query();
                    InstDetailGrid.store.removeAll();
                    InstDetailGrid.getView().refresh();
                }else{
                    var ret=jsonData.info;
                    if(ret==-1){
                        Msg.info("error","���̵㵥������δ���!");
                    }else if(ret==-2){
                        Msg.info("error","���̵㵥ʵ������δ����!");
                    }else if(ret==-3){
                        Msg.info("error","���̵㵥�Ѿ�����!");
                    }else if(ret==-4){
                        Msg.info("error","���������ʧ��!");
                    }else if(ret==-6){
                        Msg.info("error","���������ϸʧ��!");
                    }else if(ret==-8){
                        Msg.info("error","�������ʧ��!");
                    }else{
                        Msg.info("error","����ʧ�ܣ�"+ret);
                    }
                }
                
               
            }           
        });
    }
	
	var PrintBT = new Ext.Toolbar.Button({
		text:'��ӡ',
		tooltip:'�����ӡ�̵㵥',
		iconCls:'page_print',
		width:70,
		height:30,
		handler:function(){
			var selectRow = MasterInfoGrid.getSelectionModel().getSelected();
			if(Ext.isEmpty(selectRow)){
				Msg.info("warning", "��ѡ��Ҫ��ӡ���̵㵥!");
				return;
			}
			var inst = selectRow.get('inst');
			PrintINStk(inst,0);
		}
	});
    
    // ָ���в���
    var fields = ["inst","instNo", "date", "time","userName","status","locDesc", "comp", "stktkComp",
            "adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb"];
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
    function renderManaFlag(value){
        if(value=='Y'){
            return '�ص��ע';
        }else{
            return '���ص��ע'
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
                header : '�ص��ע��־',
                dataIndex : 'manFlag',
                width : 80,
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
                width : 80,
                align : 'center',
                renderer:renderYesNo,
                sortable : true
            }, {
                header : "��������",
                dataIndex : 'onlyNotUse',
                renderer:renderYesNo,
                width : 60,
                align : 'center',
                sortable : true
            }, {
                header : "����",
                dataIndex : 'scgDesc',
                width : 80,
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
            }]);
    MasterInfoCm.defaultSortable = true;
    var GridPagingToolbar = new Ext.PagingToolbar({
                    store : MasterInfoStore,
                    pageSize : PageSize,
                    displayInfo : true,
                    displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
                    emptyMsg : "No results to display",
                    prevText : "��һҳ",
                    nextText : "��һҳ",
                    refreshText : "ˢ��",
                    lastText : "���ҳ",
                    firstText : "��һҳ",
                    beforePageText : "��ǰҳ",
                    afterPageText : "��{0}ҳ",
                    emptyMsg : "û������",
                    doLoad:function(C){
                        var B={},
                        A=this.getParams();
                        B[A.start]=C;
                        B[A.limit]=this.pageSize;
                        B[A.sort]='Rowid';
                        B[A.dir]='desc';
                        B['Params']=gStrParams;
                        B['actiontype']='Query';
                        if(this.fireEvent("beforechange",this,B)!==false){
                            this.store.load({params:B});
                        }
                    }
                });
    var MasterInfoGrid = new Ext.grid.GridPanel({
                id : 'MasterInfoGrid',
                title : '',
                height : 170,
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
    
    MasterInfoGrid.on('rowclick',function(grid,rowindex,e){
        var selectRow=MasterInfoStore.getAt(rowindex);
        gRowid=selectRow.get('inst');
        InstDetailStore.setBaseParam('Parref', gRowid);
        var VarianceFlag = Ext.getCmp('VarianceFlag').getValue().getGroupValue();
        var Others = VarianceFlag;
        InstDetailStore.setBaseParam('Params', Others);
        var size=StatuTabPagingToolbar.pageSize;
        InstDetailStore.load({params:{start:0,limit:size}});
    });
            
    var nm = new Ext.grid.RowNumberer();
    var InstDetailGridCm = new Ext.grid.ColumnModel([nm, {
                header : "rowid",
                dataIndex : 'rowid',
                width : 80,
                align : 'left',
                hidden : true
            },{
                header:"inclb",
                dataIndex:'inclb',
                width:80,
                align:'left',
                hidden:true
            },{
                header : '���ʴ���',
                dataIndex : 'code',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : "��������",
                dataIndex : 'desc',
                width : 200,
                align : 'left',
                sortable : true
            }, {
                header : "���",
                dataIndex : 'spec',
                width : 80,
                align : 'left'
            },{
                header:'����',
                dataIndex:'batchNo',
                width:80,
                align:'left'
            }, {
                header:'Ч��',
                dataIndex:'expDate',
                width:100,
                align:'left'
            }, {
                header : "��λ",
                dataIndex : 'uomDesc',
                width : 60,
                align : 'left'
            }, {
                header : "����",
                dataIndex : 'rp',
                width : 60,
                align : 'right'
            }, {
                header : '��������',
                dataIndex : 'freQty',
                width : 80,
                align : 'right'
            },{
                header:'ʵ������',
                dataIndex:'countQty',
                width:80,
                align:'right'            
            },{
                header:'��������',
                dataIndex:'variance',
                width:80,
                align:'right'             
            },{
                header:'������',
                dataIndex:'freezeRpAmt',
                width:80,
                align:'right'
            },{
                header:'ʵ�̽��',
                dataIndex:'countRpAmt',
                width:80,
                align:'right'
            },{
                header:'������۽��',
                dataIndex:'varianceRpAmt',
                width:80,
                align:'right'
            },{
                header : "����",
                dataIndex : 'manf',
                width : 100,
                align : 'left'
            }]);

    // ���ݼ�
    var InstDetailStore = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                    url : url,
                    method : "POST"
                }),
                reader :  new Ext.data.JsonReader({
                    root : 'rows',
                    totalProperty : "results",
                    id : "instw",
                    fields : ["rowid","inclb", "inci", "code", "desc","spec", "manf", "batchNo", "expDate",
                            "freQty", "uom", "uomDesc", "countQty","freDate","freTime","rp","freezeRpAmt","countRpAmt",
                            "countDate","countTime","countPersonName","variance","varianceRpAmt"]
                }),
                remoteSort:true,
                baseParams : {
                	actiontype:'QueryDetail',
                	sort:'desc',
                	dir:'ASC'
                }
    });

    var StatuTabPagingToolbar = new Ext.PagingToolbar({
                store : InstDetailStore,
                pageSize : PageSize,
                displayInfo : true
            });
    
    var InstDetailGrid = new Ext.ux.EditorGridPanel({
                id:'InstDetailGrid',
                region : 'center',
                cm : InstDetailGridCm,
                store : InstDetailStore,
                trackMouseOver : true,
                stripeRows : true,
                sm : new Ext.grid.RowSelectionModel(),
                loadMask : true,
                bbar : StatuTabPagingToolbar
            });

	var VarianceFlag=new Ext.form.RadioGroup({
		id:'VarianceFlag',
		columns:3,
		itemCls: 'x-check-group-alt',
		hideLabel : true,
		items:[
			{boxLabel:'����ӯ',name:'loss',id:'onlySurplus',inputValue:1},
			{boxLabel:'���̿�',name:'loss',id:'onlyLoss',inputValue:2},
			{boxLabel:'��������',name:'loss',id:'onlyBalance',inputValue:3},
			{boxLabel:'��������',name:'loss',id:'onlyNotBalance',inputValue:4},
			{boxLabel:'ȫ��',name:'loss',inputValue:0,id:'all',checked:true}
		],
		listeners : {
			change : function(radioGroup, checked){
				if(checked.getValue() == true){
					var record = MasterInfoGrid.getSelectionModel().getSelected();
					if(Ext.isEmpty(record)){
						return;
					}
					var rowIndex = MasterInfoGrid.getStore().indexOf(record);
					MasterInfoGrid.fireEvent('rowclick', MasterInfoGrid, rowIndex);
				}
			}
		}
	});
	
	var form = new Ext.form.FormPanel({
		region: 'north',
		autoHeight : true,
		labelAlign : 'right',
		frame : true,
		title:'�̵����',
		bodyStyle : 'padding:5px 0px 0px 0px;',
		tbar:[QueryBT,'-',CompleteBT,'-',RefreshBT,'-',PrintBT],
		layout : 'column',
		items:[{
			columnWidth : 0.5,
			xtype:'fieldset',
			title:'��ѯ����',
			layout: 'column',
			items : [{
				columnWidth: 0.5,
				layout: 'form',
				items: [PhaLoc]
			},{
				columnWidth: 0.5,
				layout: 'form',
				items: [StartDate, EndDate]
			}]
		},{
			style : 'margin-left:10px',
			columnWidth : 0.5,
			xtype:'fieldset',
			title:'���ݹ���',
			layout: 'column',
			items : [{
				columnWidth: 0.6,
				layout: 'form',
				items: [VarianceFlag]
			}]
		}]
	});

    var mainPanel = new Ext.ux.Viewport({
                layout : 'border',
                items : [form,{
                        region: 'west',
                        split: true,
                        collapsible: true,
                        width: 300,
                        minSize:250,
                        maxSize:400,
                        layout: 'fit',
                        items: MasterInfoGrid
                    }, {
                        region: 'center',
                        layout:'fit',
                        items:[InstDetailGrid]
                    }
                ],
                renderTo : 'mainPanel'
    });
    
    Query();
})