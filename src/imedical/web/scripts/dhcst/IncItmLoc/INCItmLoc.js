// /����: ���ҿ����ά��
// /����: ���ҿ����ά��
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.21
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gIncId='';
    var gGroupId=session['LOGON.GROUPID'];  
    var gLocId=session['LOGON.CTLOCID'];
    var gUserId=session['LOGON.USERID'];

    var PhaLoc = new Ext.ux.LocComboBox({
        fieldLabel : $g('����'),
        id : 'PhaLoc',
        name : 'PhaLoc',
        anchor : '90%',
        valueNotFoundText : '',
        groupId:gGroupId,
        listeners : {
			'select' : function(e) {
                          var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
                          StkGrpType.getStore().removeAll();
                          StkGrpType.getStore().setBaseParam("locId",SelLocId)
                          StkGrpType.getStore().setBaseParam("userId",gUserId)
                          StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
                          StkGrpType.getStore().load();
			}
	    }
    });
    
    // ҩƷ����
    var StkGrpType=new Ext.ux.StkGrpComboBox({ 
        id : 'StkGrpType',
        name : 'StkGrpType',
        StkType:App_StkTypeCode,     //��ʶ��������
        UserId:gUserId,
        LocId:gLocId,
        anchor : '90%',
        fieldLabel : $g('����')
    }); 
    
    var InciDesc = new Ext.form.TextField({
                fieldLabel : $g('ҩƷ����'),
                id : 'InciDesc',
                name : 'InciDesc',
                anchor : '90%',
                listeners : {
                    specialkey : function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var inputDesc=field.getValue();
                            var stkGrp=Ext.getCmp("StkGrpType").getValue();
                            GetPhaOrderInfo(inputDesc,stkGrp);
                        }
                    }
                }
            });
    /**
     * ����ҩƷ���岢���ؽ��
     */
    function GetPhaOrderInfo(item, stktype) {
        if (item != null && item.length > 0) {
            GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
        }
    }
    /**
     * ���ط���
     */
    function getDrugList(record) {
        if (record == null || record == "") {
            return;
        }
        gIncId = record.get("InciDr");
        var incDesc=record.get("InciDesc");
        Ext.getCmp("InciDesc").setValue(incDesc);
    }

    var NotUseFlag = new Ext.form.Checkbox({
        fieldLabel : $g('����������'),
        id : 'NotUseFlag',
        name : 'NotUseFlag',
        //anchor : '90%',
        checked : false
    });
    
    //��������������
	var LockFlagStore = new Ext.data.SimpleStore({
				fields : ['RowId', 'Description'],
				data : [['ALL', $g('����/סԺ')], ['OUT', $g('����')], ['IN', $g('סԺ')]]
			});
	var LockFlagCon = new Ext.form.ComboBox({
				fieldLabel : $g('������־'),
				id : 'LockFlagCon',
				name : 'LockFlagCon',
				anchor : '90%',
				store : LockFlagStore,
				triggerAction : 'all',
				mode : 'local',
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : true,
				triggerAction : 'all',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				valueNotFoundText : ''
			});
    
    
    var StkBin = new Ext.form.ComboBox({
        fieldLabel : $g('��λ'),
        id : 'StkBin',
        name : 'StkBin',
        anchor : '90%',
        store : LocStkBinStore,
        valueField : 'RowId',
        displayField : 'Description',
        allowBlank : true,
        triggerAction : 'all',
        selectOnFocus : true,
        forceSelection : true,
        minChars : 1,
        pageSize : 10,
        listWidth : 250,
        valueNotFoundText : '',
        listeners : {
            'beforequery' : function(e) {
            	LocStkBinStore.removeAll();
                var LocId=Ext.getCmp("PhaLoc").getValue();
                LocStkBinStore.setBaseParam('LocId',LocId);
                LocStkBinStore.setBaseParam('Desc',Ext.getCmp('StkBin').getRawValue());
                LocStkBinStore.load({params:{start:0,limit:10}});                   
            }
        }
    }); 
    
    var StockTypeStore=new Ext.data.SimpleStore({
        fields : ['RowId', 'Description'],
        data : [['-1', $g('�����')], ['0', $g('����')], ['1', $g('�����')]]
    });
    var StockType=new Ext.form.ComboBox({
        fieldLabel : $g('�������'),
        id : 'StockType',
        name : 'StockType',
        anchor : '90%',
        store : StockTypeStore,
        mode : 'local',
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
        enableKeyEvents : true
    });
    
    Ext.getCmp('StockType').setValue('');
    
    var LocManGrp=new Ext.form.ComboBox({
        fieldLabel : $g('������'),
        id : 'LocManGrp',
        name : 'LocManGrp',
        anchor : '90%',
        store : LocManGrpStore,
         mode : 'local',
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
        listeners:{
            'beforequery':function(e){
                this.store.removeAll();
                var loc=Ext.getCmp("PhaLoc").getValue();
                LocManGrpStore.load({params:{locId:loc}});              
            }
        }
    });
    var LocManGrpG=new Ext.form.ComboBox({
        fieldLabel : $g('������'),
        id : 'LocManGrpG',
        name : 'LocManGrpG',
        anchor : '90%',
        store : LocManGrpStore,
         mode : 'local',
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
        listeners:{
            'beforequery':function(e){
                this.store.removeAll();
                var loc=Ext.getCmp("PhaLoc").getValue();
                LocManGrpStore.load({params:{locId:loc}});              
            }
        }
    });
    
    // ��ѯ��ť
    var SearchBT = new Ext.Toolbar.Button({
                text : $g('��ѯ'),
                tooltip : $g('�����ѯ'),
                iconCls : 'page_find',
                width : 70,
                height : 30,
                handler : function() {
                    Query();
                }
            });

    /**
     * ��ѯ����
     */
    function Query() {
        // ��ѡ����
        var phaLoc = Ext.getCmp("PhaLoc").getValue();
        if (phaLoc == null || phaLoc.length <= 0) {
            Msg.info("warning", $g("���Ҳ���Ϊ�գ�"));
            Ext.getCmp("PhaLoc").focus();
            return;
        }
        if(Ext.getCmp("InciDesc").getValue()==""){
            gIncId="";
        }
		ItmLocStore.removeAll();
        var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
        var StockType = Ext.getCmp("StockType").getValue();
        var IncludeNotUse=(Ext.getCmp("NotUseFlag").getValue()==true?1:0);
        var LockFlagCon=Ext.getCmp("LockFlagCon").getValue();
        var StkBinId=Ext.getCmp("StkBin").getValue();
        var LocManGrpId=Ext.getCmp("LocManGrp").getValue();
        gStrParam=[phaLoc,gIncId,StkGrpRowId,IncludeNotUse,StkBinId,"",StockType,LocManGrpId,LockFlagCon].join("^");
        var PageSize=StatuTabPagingToolbar.pageSize;
        ItmLocStore.setBaseParam('Params',gStrParam);   //��ҳʱ�����������ᶪʧ
        ItmLocStore.load({
	        params:{start:0,limit:PageSize},
			callback : function(o,response,success) { 
				if (success == false){  
					Ext.MessageBox.alert($g("��ѯ����"),ItmLocStore.reader.jsonData.Error);  
				}
			}});

    }
		// ��水ť
	var SaveAsBT = new Ext.Toolbar.Button({
		text : $g('���'),
		tooltip : $g('���ΪExcel'),
		iconCls : 'page_excel',
		width : 70,
		height : 30,
		handler : function() {
			ExportAllToExcel(ItmLocGrid);
			//gridSaveAsExcel(StockQtyGrid);
		}
	});
    // ��հ�ť
    var RefreshBT = new Ext.Toolbar.Button({
        text : $g('���'),
        tooltip : $g('������'),
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
        gStrParam='';   
        gIncId='';
        SetLogInDept(GetGroupDeptStore,'PhaLoc')
        Ext.getCmp("InciDesc").setValue('');
        Ext.getCmp("NotUseFlag").setValue(false);
        
        Ext.getCmp("StkBin").setValue('');
        Ext.getCmp("StockType").setValue('');
        Ext.getCmp("LocManGrp").setValue('');
        Ext.getCmp("LockFlagCon").setValue('');
        
        StkGrpType.getStore().setBaseParam("locId",gLocId);
		StkGrpType.getStore().setBaseParam("userId",gUserId);
		StkGrpType.getStore().setBaseParam("type",App_StkTypeCode);
		StkGrpType.getStore().load();
        //ItmLocGrid.store.removeAll();
        ItmLocGrid.getStore().removeAll();
        ItmLocGrid.store.load({params:{start:0,limit:0}});
        ItmLocGrid.getView().refresh();
    }
    
    // ���水ť
    var SaveBT = new Ext.Toolbar.Button({
        id : "SaveBT",
        text : $g('����'),
        tooltip : $g('�������'),
        width : 70,
        height : 30,
        iconCls : 'page_save',
        handler : function() {	
            // ������ҿ�������Ϣ                   
            save();                     
        }
    });
    
    function save(){    
    	var ListDetail="";
        var mr=ItmLocStore.getModifiedRecords();
        var data="";
        var rows="";
        for(var i=0;i<mr.length;i++){
            var Rowid = mr[i].data["incil"].trim();
            var Incsc = mr[i].data["incsb"].trim();
            var RepLev = mr[i].data["repLev"];
            var RepQty = mr[i].data["repQty"];
            var MaxQty = mr[i].data["maxQty"];
             var EnforceStock='';
            var MinQty = mr[i].data["minQty"];
            var LockFlag = mr[i].data["lockFlag"];
            var InLockFlag = mr[i].data["InLockFlag"];
            var SpStkBin = mr[i].data["spStkBin"];
            var PivaFlag = mr[i].data["pivaPack"];  //��Һ�����־
            //var sd = mr[i].data["SdDesc"].trim();         
            var ManFlag = mr[i].data["manFlag"].trim();   
            ManFlag=ManFlag=='Y'?1:0;	//��1,0����      
            //var mt = mr[i].data["MtDesc"].trim();         
            var Lmg = mr[i].data["inciLmg"].trim();
            var PlanFlag = mr[i].data["planFlag"].trim();
            var IfPivaFlag=mr[i].data["pivaflag"].trim();  //�Ƿ���Һ
            var DrugSendFlag=mr[i].data["drugsendflag"].trim();
            var DrugPackFlag=mr[i].data["drugpackflag"].trim();
           if((MaxQty != "") && (MinQty != "")&&(Number(MaxQty)<Number(MinQty))){Msg.info("warning",$g("������޲���С������!"));return;}

            var dataRow =Rowid + "^" + Incsc+"^"+RepLev+"^"+RepQty+"^"+MaxQty+"^"+MinQty+"^"+LockFlag
                +"^"+SpStkBin+"^"+EnforceStock+"^"+PivaFlag+"^"+ManFlag+"^"+Lmg+"^"+PlanFlag+"^"+IfPivaFlag
                +"^"+DrugSendFlag+"^"+DrugPackFlag+"^"+InLockFlag;
            //alert(dataRow);
            if(ListDetail==""){
                
                ListDetail = dataRow;
            }else{
                ListDetail = ListDetail+xRowDelim()+dataRow;
            }
        }
        var url = DictUrl
                + "incitmlocaction.csp?actiontype=Save";
        Ext.Ajax.request({
                    url : url,
                    params:{Detail:ListDetail},
                    method : 'POST',
                    waitMsg : $g('������...'),
                    success : function(result, request) {
                        var jsonData = Ext.util.JSON
                                .decode(result.responseText);
                        if (jsonData.success == 'true') {
                             
                            Msg.info("success", $g("����ɹ�!"));
                            // ˢ�½���
                            Query();

                        } else {
                            var ret=jsonData.info;
                            if(ret==-1){
                                Msg.info("error", $g("û����Ҫ���������!"));
                            }else {
                                Msg.info("error", $g("������ϸ���治�ɹ���")+ret);
                            }
                            
                        }
                    },
                    scope : this
                });

    }
    
      // ����������
    var CreatLimtBT = new Ext.Toolbar.Button({
                text : $g('����������'),
                tooltip : $g('�������������'),
                iconCls : 'page_find',
                width : 70,
                height : 30,
                handler : function() {
                    CreatLimtsConWin(Query);
                }
            });
    
    var GridStkBin = new Ext.ux.ComboBox({
        fieldLabel : $g('��λ'),
        id : 'GridStkBin',
        name : 'GridStkBin',
        anchor : '90%',
        store : LocStkBinStore,
        valueField : 'RowId',
        displayField : 'Description',
		filterName : 'Desc',
		params : {LocId:'PhaLoc'}
    }); 
    
    var ChkLockFlag=new Ext.grid.CheckColumn({
       header: '<font color=blue>'+$g('�������')+'</font>',
       dataIndex: 'lockFlag',
       width: 80
    });
    
    var ChkInLockFlag=new Ext.grid.CheckColumn({
       header: '<font color=blue>'+$g('סԺ����')+'</font>',
       dataIndex: 'InLockFlag',
       width: 80
    });
    
    var ChkPivaFlag=new Ext.grid.CheckColumn({
       header: '<font color=blue>'+$g('��Һ�����־')+'</font>',
       dataIndex: 'pivaPack',
       width: 80
    });
    
    var ChkManFlag=new Ext.grid.CheckColumn({
        header:'<font color=blue>'+$g('����ҩ��־')+'</font>',
        dataIndex:'manFlag',
        width:80
    });
    var ChkPlanFlag=new Ext.grid.CheckColumn({
        header:'<font color=blue>'+$g('�Զ��ɹ���־')+'</font>',
        dataIndex:'planFlag',
        width:80
    })
    var PivaFlag=new Ext.grid.CheckColumn({
        header:'<font color=blue>'+$g('�Ƿ���Һ��־')+'</font>',
        dataIndex:'pivaflag',
        width:80
    })
    var DrugSendFlag=new Ext.grid.CheckColumn({
        header:'<font color=blue>'+$g('��ҩ����־')+'</font>',
        dataIndex:'drugsendflag',
        sortable : true,
        width:80
    })
    var DrugPackFlag=new Ext.grid.CheckColumn({
        header:'<font color=blue>'+$g('�ְ�����־')+'</font>',
        dataIndex:'drugpackflag',
        width:80,
        sortable : true
    })

    var nm = new Ext.grid.RowNumberer();
    var ItmLocCm = new Ext.grid.ColumnModel([nm, {
                header : "Rowid",
                dataIndex : 'incil',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : true
            }, {
                header : $g('����'),
                dataIndex : 'code',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : false
            }, {
                header : $g("����"),
                dataIndex : 'desc',
                width : 200,
                align : 'left',
                sortable : true
            },{
                header : $g("���"),
                dataIndex : 'spec',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header : $g("������ҵ"),
                dataIndex : 'manf',
                width : 200,
                align : 'left',
                sortable : true
            },{
                header : $g("������λ"),
                dataIndex : 'bUomDesc',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header : $g("��װ��λ"),
                dataIndex : 'pUomDesc',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header : "<font color=blue>"+$g("�������")+"</font>",
                dataIndex : 'maxQty',
                width : 80,
                align : 'left',
                sortable : true,
                editor:new Ext.form.NumberField({
                    selectOnFocus:true,
                    listeners:{
                        specialkey: function(field, e){
                            var num=e.getKey();
                            
                            if(num == e.ENTER){                                 
                                var index=GetColIndex(ItmLocGrid,"minQty");
                                var cell=ItmLocGrid.getSelectionModel().getSelectedCell();
                                var row=cell[0];
                                ItmLocGrid.startEditing(row,index);
                            }
                        }
                    }
                })
                
            },{
                header:"<font color=blue>"+$g("�������")+"</font>",
                dataIndex:"minQty",
                width : 80,
                align : 'left',
                sortable : true,
                editor:new Ext.form.NumberField({
                    selectOnFocus:true,
                    listeners:{
                        specialkey:function(field,e){
                            var keycode=e.getKey();
                            if(keycode==e.ENTER){
                                var index=GetColIndex(ItmLocGrid,"repQty");
                                var cell=ItmLocGrid.getSelectionModel().getSelectedCell();
                                var row=cell[0];
                                ItmLocGrid.startEditing(row,index);
                            }
                        }
                    }
                })
            
            },{
                header:$g("���"),
                dataIndex:"stkQty",
                width : 80,
                align : 'left',
                sortable : true
            },{
                header:$g("���ÿ��"),
                dataIndex:"avaQty",
                width : 80,
                align : 'left',
                sortable : true
            },{
                header:"<font color=blue>"+$g("��׼���")+"</font>",
                dataIndex:"repQty",
                width : 80,
                align : 'left',
                sortable : true,
                editor:new Ext.form.NumberField({
                    selectOnFocus:true,
                    listeners:{
                        specialkey:function(field,e){
                            var keycode=e.getKey();
                            if(keycode==e.ENTER){
                                var col=GetColIndex(ItmLocGrid,"repLev");
                                var cell=ItmLocGrid.getSelectionModel().getSelectedCell();
                                var row=cell[0];
                                ItmLocGrid.startEditing(row,col);
                            }
                        }
                    }
                })
            
            },{
                header:"<font color=blue>"+$g("������׼")+"</font>",
                dataIndex:"repLev",
                width : 80,
                align : 'left',
                sortable : true,
                editor:new Ext.form.NumberField({
                    selectOnFocus:true,
                    listeners:{
                        specialkey:function(field,e){
                            var keycode=e.getKey();
                            if(keycode==e.ENTER){
                                var col=GetColIndex(ItmLocGrid,"incsb");
                                var cell=ItmLocGrid.getSelectionModel().getSelectedCell();
                                var row=cell[0];
                                ItmLocGrid.startEditing(row,col);
                            }
                        }
                    }
                })
            
            },{
				header:$g("��λ"),
                dataIndex:"incsb",
                width : 150,
                align : 'left',
                sortable : true
            },{
                header:"<font color=blue>"+$g("���û�λ")+"</font>",
                dataIndex:"spStkBin",
                width : 100,
                align : 'left',
                sortable : true,
                hidden:true,
                editor:new Ext.form.TextField({
                    
                })          
            },{
                header : $g("���Ʒ���"),
                dataIndex : 'phcpoCode',
                width : 100,
                align : 'left',
                sortable : true
            },
            { 
                header:"<font color=blue>"+$g("������")+"</font>",
                dataIndex:'inciLmg',
                editor:LocManGrpG,
                width : 100,
                renderer:Ext.util.Format.comboRenderer2(LocManGrp,"inciLmg","inciLmgDesc")   
            },
            ChkLockFlag,
            ChkInLockFlag,
            ChkPivaFlag,
            ChkManFlag,
            PivaFlag,
            DrugSendFlag,
            DrugPackFlag,
            ChkPlanFlag,
            {
            header : $g("������"),
            dataIndex : 'NotUseFlag',
            width : 75,
            align : 'center',
            renderer : function(v,p,record) {
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
            },
			sortable : true
            },{
                header:$g("����������"),
                dataIndex:"lastUpdUser",
                width : 80,
                align : 'left',
                sortable : true
            },{
                header:$g("������������"),
                dataIndex:"lastUpdDate",
                width : 100,
                align : 'left',
                sortable : true
            },{
                header:$g("��������ʱ��"),
                dataIndex:"lastUpdTime",
                width : 100,
                align : 'left',
                sortable : true
            }
			]);
    ItmLocCm.defaultSortable = true;

    // ����·��
    var DspPhaUrl = DictUrl
                + 'incitmlocaction.csp?actiontype=Query&start=&limit=';
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
                url : DspPhaUrl,
                method : "POST"
            });
    // ָ���в���
    var fields = ["incil", "inci", "code","desc","spec","manf","pUom","pUomDesc","bUom",
    "bUomDesc","maxQty","minQty","stkQty","avaQty","repQty","repLev","incsb","sbDesc","phcpoCode",
    "lockFlag","spStkBin","pivaPack","manFlag","inciLmg","inciLmgDesc","planFlag","NotUseFlag",
    "sp","pivaflag","drugsendflag","drugpackflag","lastUpdUser","lastUpdDate","lastUpdTime","InLockFlag"]; 
    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
                root : 'rows',
                totalProperty : "results",
                id : "incil",
                fields : fields
            });
    // ���ݼ�
    var ItmLocStore = new Ext.data.Store({
                proxy : proxy,
                pruneModifiedRecords : true,
                reader : reader,
                remoteSort:true
            });
    var StatuTabPagingToolbar = new Ext.PagingToolbar({
        store : ItmLocStore,
        pageSize : PageSize,
        displayInfo : true,
        displayMsg : $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼'),
        emptyMsg : "No results to display",
        prevText : $g("��һҳ"),
        nextText : $g("��һҳ"),
        refreshText : $g("ˢ��"),
        lastText :$g( "���ҳ"),
        firstText : $g("��һҳ"),
        beforePageText : $g("��ǰҳ"),
        afterPageText : $g("��{0}ҳ"),
        emptyMsg :$g( "û������")
    });
    var ItmLocGrid = new Ext.grid.EditorGridPanel({
                id:'ItmLocGrid',
                region : 'center',
                cm : ItmLocCm,
                store : ItmLocStore,
                trackMouseOver : true,
                stripeRows : true,
                sm : new Ext.grid.CellSelectionModel({}),
                clicksToEdit : 1,
                bbar:StatuTabPagingToolbar,
                plugins: [ChkLockFlag,ChkInLockFlag,ChkPivaFlag,ChkManFlag,ChkPlanFlag,PivaFlag,DrugSendFlag,DrugPackFlag],
                loadMask : true
            });




    var HisListTab = new Ext.form.FormPanel({
        title:$g('����ҩƷ��Ϣά��'),
        labelWidth : 80,
        height : DHCSTFormStyle.FrmHeight(3),
        labelAlign : 'right',
        region: 'north',
        frame : true,
        tbar : [SearchBT, '-',SaveBT,'-',CreatLimtBT,'-',SaveAsBT,'-',RefreshBT],            
        items : [{
            layout:'column',
            title:$g('��ѯ����'),
            xtype:'fieldset',
            style:DHCSTFormStyle.FrmPaddingV,
            defaults: {border:false}, 
            items:[{
                    columnWidth:0.25,
                    xtype:'fieldset',
                    defaults: {width: 180},
                    items:[PhaLoc,StkGrpType,LockFlagCon]
                  },{
                    columnWidth:0.25,
                    xtype:'fieldset',
                    defaults: {width: 180},
                    items:[InciDesc,StockType]
                  },{
                    columnWidth:0.25,
                    xtype:'fieldset',
                    defaults: {width: 150},
                    items:[StkBin,LocManGrp]    
                  },{
                    columnWidth:0.25,
                    xtype:'fieldset',
                    defaults: {width: 150},
                    items:[NotUseFlag]    
                  }
                  
                  
                  ]
        }]
    });

    // 5.2.ҳ�沼��
    var mainPanel = new Ext.Viewport({
        layout : 'border',
        items : [  HisListTab,
            {
                 region: 'center',                                      
                 title: $g('���ҿ����---<font color=blue>��ɫ��ʾ����Ϊ�ɱ༭��</font>'),
                 layout: 'fit', // specify layout manager for items
                 items: ItmLocGrid                             
            }
        ],
        renderTo : 'mainPanel'
    });
	})