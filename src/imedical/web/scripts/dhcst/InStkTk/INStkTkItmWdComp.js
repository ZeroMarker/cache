// /����: ʵ����ȷ��
// /����:  ʵ����ȷ��
// /��д�ߣ�zhangdongmei
// /��д����: 2012.09.10
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrDetailParams='';
    var gStrParams='';
    var url=DictUrl+'instktkaction.csp';
    Ext.Ajax.timeout = 900000;
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
                groupId:gGroupId
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
            
    var LocManaGrp = new Ext.form.ComboBox({
                fieldLabel : '������',
                id : 'LocManaGrp',
                name : 'LocManaGrp',
                //anchor : '95%',
                width : 140,
                store : LocManGrpStore,
                valueField : 'RowId',
                displayField : 'Description',
                allowBlank : true,
                triggerAction : 'all',
                emptyText : '������...',
                selectOnFocus : true,
                forceSelection : true,
                minChars : 1,
                pageSize : 20,
                listWidth : 250,
                valueNotFoundText : '',
                listeners:{
                    'expand':function(combox){
                            var LocId=Ext.getCmp('PhaLoc').getValue();
                            LocManGrpStore.load({params:{start:0,limit:20,locId:LocId}});   
                    }
                }
            });     
        
    var PhaWindow = new Ext.form.ComboBox({
            fieldLabel : 'ʵ�̴���',
            id : 'PhaWindow',
            name : 'PhaWindow',
            //anchor : '95%',
            width : 140,
            store : PhaWindowStore,
            valueField : 'RowId',
            displayField : 'Description',
            allowBlank : true,
            triggerAction : 'all',
            emptyText : 'ʵ�̴���...',
            selectOnFocus : true,
            forceSelection : true,
            minChars : 1,
            pageSize : 20,
            listWidth : 250,
            valueNotFoundText : '',
            listeners:{
                'beforequery':function(e){
                    var desc=Ext.getCmp('PhaWindow').getRawValue();
                    if(desc!=null || desc.length>0){
                        PhaWindowStore.load({params:{start:0,limit:20,Desc:desc}});
                    }
                }
            }
        });         
    
    var StkGrpType=new Ext.ux.StkGrpComboBox({ 
        id : 'StkGrpType',
        name : 'StkGrpType',
        StkType:App_StkTypeCode,     //��ʶ��������
        LocId:gLocId,
        UserId:gUserId,
        width : 140
    }); 

    var DHCStkCatGroup = new Ext.form.ComboBox({
                fieldLabel : '������',
                id : 'DHCStkCatGroup',
                name : 'DHCStkCatGroup',
                anchor : '90%',
                width : 140,
                store : StkCatStore,
                valueField : 'RowId',
                displayField : 'Description',
                allowBlank : true,
                triggerAction : 'all',
                selectOnFocus : true,
                forceSelection : true,
                minChars : 1,
                valueNotFoundText : '',
                listeners:{
                    'beforequery':function(e){
                        var grp=Ext.getCmp("StkGrpType").getValue();
                        StkCatStore.removeAll();
                        StkCatStore.load({params:{start:0,limit:20,StkGrpId:grp}})
                    }
                }
            });
        
    var StkBin = new Ext.form.ComboBox({
        fieldLabel : '��λ',
        id : 'StkBin',
        name : 'StkBin',
        anchor : '90%',
        width : 140,
        store : LocStkBinStore,
        valueField : 'RowId',
        displayField : 'Description',
        allowBlank : true,
        triggerAction : 'all',
        selectOnFocus : true,
        forceSelection : true,
        minChars : 1,
        pageSize : 20,
        listWidth : 250,
        valueNotFoundText : '',
        enableKeyEvents : true,
        listeners : {
            'expand' : function(e) {
                var LocId=Ext.getCmp("PhaLoc").getValue();
                LocStkBinStore.load({params:{LocId:LocId,Desc:Ext.getCmp('StkBin').getRawValue(),start:0,limit:20}});                   
            }
        }
    }); 
    
    var NullInputFlag=new Ext.form.RadioGroup({
        id:'NullInputFlag',
        anchor: '95%',
        columns: 1,
        style: 'padding:5px 5px 5px 5px;',
        items : [{
                    checked: true,                           
                    boxLabel: 'δ����Ĭ��Ϊ0',
                    id: 'InputSelFlag1',
                    name:'InputSelFlag',
                    inputValue: 0
                },{
                    checked: false,                          
                    boxLabel: 'δ����Ĭ��Ϊ������',
                    id: 'InputSelFlag2',
                    name:'InputSelFlag',
                    inputValue: '1'                           
                }]  
    });
    
	var TkComplete=new Ext.form.Checkbox({
		fieldLabel:'ʵ�����',
		id:'TkComplete',
		name:'TkComplete',
		width:80,
		disabled:false
		//checked :true
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
        
        var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
        var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
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
        InstItmStore.load({params:{start:0,limit:0}});
	 	InstItmGrid.getView().refresh();
        InstiStore.removeAll();
        InstDetailStore.removeAll();
        
		MasterInfoStore.setBaseParam('actiontype','Query');
		MasterInfoStore.setBaseParam('sort','instNo');
		MasterInfoStore.setBaseParam('dir','asc');
		MasterInfoStore.setBaseParam('Params',gStrParams);
		MasterInfoStore.removeAll();
        MasterInfoStore.load({params:{start:0, limit:Page}});
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
    
		// ��水ť
	var SaveAsBT = new Ext.Toolbar.Button({
				text : '���',
				tooltip : '���ΪExcel',
				iconCls : 'page_excel',
				width : 70,
				height : 30,
				handler : function() {
					ExportAllToExcel(InstItmGrid);
				}
			});
    // ��հ�ť
    var RefreshBT = new Ext.Toolbar.Button({
                text : '����',
                tooltip : '�������',
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
        Ext.getCmp("StkBin").setValue('');
        //Ext.getCmp("Complete").setValue(false);
        Ext.getCmp("StkGrpType").setValue('');
        Ext.getCmp("PhaWindow").setValue('');
        Ext.getCmp("LocManaGrp").setValue('');
        
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
        if(InputType==0){
        	Msg.info("warning","���̵㵥��δ����ʵ��¼��!");
        	return;
        }
        var InputSelValue="";
        var selectRadio = Ext.getCmp('NullInputFlag').getValue();   
        if(selectRadio){
            InputSelValue =selectRadio.inputValue;    // selectRadio.getValue();                
        }
        
        if(InputSelValue===""){
            Msg.info('warning','��ѡ��δ��ʵ����Ĭ�Ϸ�ʽ!');
            return;
        }
        if(Inst==null || Inst==""){
            Msg.info('warning','û����Ҫȷ�ϻ��ܵ��̵㵥!');
            return;
        }
        var mask=ShowLoadMask(Ext.getBody(),"������...");
        Ext.Ajax.request({
            url:url,
            params:{actiontype:'StkTkCompletet',Inst:Inst,UserId:gUserId,InputNullFlag:InputSelValue,InputType:InputType},
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
                
                mask.hide();
            }       
        });
    }
     var CancelCompleteBT = new Ext.Toolbar.Button({
                text : 'ȡ������',
                tooltip : 'ȡ������',
                iconCls : 'page_gear',
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
                    }else if(ret=='-5'){
                        Msg.info('error','���ּ�¼�Ѿ���ɵ����������̵���������޸�ʵ��������������̵㣡');
                    }else{
                        Msg.info('error','����ʧ��:'+ret);
                    }
                }
                mask.hide();
            }       
        });
     }
            
            
            
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
            return '����ҩ';
        }else{
            return '�ǹ���ҩ'
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
                header : '����ҩ��־',
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
                    if(value==1){
                        return "������";
                    }else if(value==2){
                        return "��Ʒ��";
                    }else{
                        return "";
                    }                   
                }
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
                    emptyMsg : "û������"
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
        var size=StatuTabPagingToolbar.pageSize;
        var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
        var Inst=selectRow.get("inst");
        gStrDetailParams=Inst;   //+'^'+ManaGrpId+'^'+StkGrpId+'^'+StkCatId+'^'+StkBinId+'^'+PhaWinId;
        InstiStore.removeAll();
        InstDetailStore.removeAll(); 
        InstItmStore.removeAll();
        InstItmStore.load({
        	params:{actiontype:'CollectItmCountQty',start:0,limit:size,sort:'Rowid',dir:'ASC',Params:gStrDetailParams},
        	callback:function(r,options,success){
        		if(success==false){
        			Ext.MessageBox.alert("��ѯ����", InstItmStore.reader.jsonData.Error);
        		}
        	}
        });
    }
    
    //-------ҩƷ����grid----------------------------------------------------------
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
                width : 150,
                align : 'right',
                sortable : true
            },{
                header:'ʵ������',
                dataIndex:'CountQty',
                width:150,
                align:'right',
                sortable:true
            }, {
                header : '��������(������λ)',
                dataIndex : 'FreezeBQty',
                width : 150,
                align : 'right',
                sortable : false,
                hidden:true
            },{
                header:'ʵ������(������λ)',
                dataIndex:'CountBQty',
                width:150,
                align:'right',
                sortable:true,
                sortable : false,
                hidden:true
            },{
                header:'������۽��',
                dataIndex:'FreezeRpAmt',
                width:150,
                align:'right',
                sortable:true,
                sortable : false
            },{
                header:'ʵ�̽��۽��',
                dataIndex:'CountRpAmt',
                width:150,
                align:'right',
                sortable:true,
                sortable : false
            }]);
    InstItmGridCm.defaultSortable = true;

    // ���ݼ�
    var InstItmStore = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                    url : url,
                    method : "POST"
                }),
                reader :  new Ext.data.JsonReader({
                    root : 'rows',
                    totalProperty : "results",
                    id : "Rowid",
                    fields : ["Rowid","Inci", "InciCode", "InciDesc", "Spec","PurUomDesc","FreezeQty", "CountQty", "CountDate", "CountTime","FreezeBQty","CountBQty","FreezeRpAmt","CountRpAmt"]
                }),
                remoteSort:true
    });
    var StatuTabPagingToolbar = new Ext.PagingToolbar({
                store : InstItmStore,
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
                    B[A.dir]='asc';
                    B['Params']=gStrDetailParams;
                    B['actiontype']='CollectItmCountQty';
                    if(this.fireEvent("beforechange",this,B)!==false){
                        this.store.load({params:B});
                    }
                }
            });
    var InstItmGrid = new Ext.grid.GridPanel({
            id:'InstItmGrid',
            cm : InstItmGridCm,
            store : InstItmStore,
            trackMouseOver : true,
            stripeRows : true,
            height:400,
            sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
            bbar:StatuTabPagingToolbar,
            loadMask : true,
            viewConfig:{
	            	getRowClass : function(record,rowIndex,rowParams,store){ 
						var freezeqty=record.get("FreezeBQty");
						var countqty=record.get("CountBQty");
						var colorflag="";					
						if (Number(freezeqty)>Number(countqty)) {colorflag="-1";}
						else if (Number(freezeqty)<Number(countqty)) {colorflag="1";}
						switch(colorflag){
							case "1":
								return 'classAquamarine';
								break;
							case "-1":
								return 'classSalmon';
								break;
						}
					}
            }
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
    
    //-------ҩƷ����grid----------------------------------------------------------
    
    //-------ҩƷ����grid----------------------------------------------------------
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
                width : 100,
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
            id:'InstiGrid',
            cm : InstiGridCm,
            store : InstiStore,
            trackMouseOver : true,
            stripeRows : true,
            height:400,
            sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
            loadMask : true,
                    viewConfig:{
	            	getRowClass : function(record,rowIndex,rowParams,store){ 
						var freezeqty=record.get("FreQty");
						var countqty=record.get("CountQty");
						var colorflag="";					
						if (Number(freezeqty)>Number(countqty)) {colorflag="-1";}
						else if (Number(freezeqty)<Number(countqty)) {colorflag="1";}
						switch(colorflag){
							case "1":
								return 'classAquamarine';
								break;
							case "-1":
								return 'classSalmon';
								break;
						}
					}
            }
        });     
    //-------ҩƷ����grid----------------------------------------------------------
    
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
                width : 100,
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
                width:90,
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
            id:'InstDetailGrid',
            cm : InstDetailGridCm,
            store : InstDetailStore,
            trackMouseOver : true,
            stripeRows : true,
            height:400,
            sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
            loadMask : true
        });
        
    //-------ʵ����ϸgrid----------------------------------------------------------
        
        var formMain=new Ext.form.FormPanel({
            labelWidth : 80,
            labelAlign : 'right',
            autoScroll : false,
            frame:true,
            tbar:[QueryBT,'-',CompleteBT,'-',CancelCompleteBT,'-',SaveAsBT],
        	items:[{
				xtype:'fieldset',
				title:'��ѯ����',
				style:DHCSTFormStyle.FrmPaddingV,
				defaults:{width:160},
				items : [PhaLoc,StartDate,EndDate,TkComplete,NullInputFlag]					
			}]
        
        });
        // 5.2.ҳ�沼��
        var mainPanel = new Ext.Viewport({
                    layout : 'border',
                    items :  [{
                                region:'west',  
                                width:350,
                                minSize:250,
                                maxSize:400,
                                //autoScroll:true,
                                split: true,
                                //collapsible: true, 
                                title:'�̵㵥-ʵ��������',
                                layout:'border',
                                items:[{
                                            region:'north',
                                            height:DHCSTFormStyle.FrmHeight(6)-10,
                                            layout:'fit',                                           
                                            items:[formMain ]
                                       },{
                                            region:'center',
                                            layout:'fit',
                                            autoScroll:false,
                                            items:[MasterInfoGrid]
                                       }]
                                
                            },{
                                region:'center',
                                title:'�̵���ϸ',
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
                                                title:'ʵ��������ϸ',
                                                region:'east',
                                                width:500,
                                                split:true,
                                                minSize:50,
                                                maxSize:500,
                                                //collapsible: true,
                                                layout:'fit',
                                                items:[InstDetailGrid]
                                            },{
	                                         title:'����������ϸ',
                                                region:'center',
                                                layout:'fit',
                                                items:[InstiGrid]
                                            }]
                                
                            }],                 
                    renderTo : 'mainPanel'
        });
    
        Query();
})