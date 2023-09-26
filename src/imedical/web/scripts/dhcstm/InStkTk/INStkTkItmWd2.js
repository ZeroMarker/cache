// /����: ʵ�̣�¼�뷽ʽ�������������¼�뷽ʽ��
// /����: ʵ�̣�¼�뷽ʽ�������������¼�뷽ʽ��
// /��д�ߣ�zhangdongmei
// /��д����: 2012.09.05
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrDetailParams='';
    var url=DictUrl+'instktkaction.csp';
	var gUserId=session['LOGON.USERID'];
    
    var LocManaGrp = new Ext.form.ComboBox({
                fieldLabel : '������',
                id : 'LocManaGrp',
                name : 'LocManaGrp',
                anchor : '90%',
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
					'beforequery':function(combox){
						LocManGrpStore.removeAll();
						LocManGrpStore.setBaseParam('locId',gLocId);
						LocManGrpStore.load({params:{start:0,limit:20}});   
					}
				}
            });     
        
    var PhaWindow = new Ext.ux.ComboBox({
            fieldLabel : 'ʵ�̴���',
            id : 'PhaWindow',
            name : 'PhaWindow',
            anchor : '90%',
            store : INStkTkWindowStore,
            valueField : 'RowId',
            displayField : 'Description',
            emptyText : 'ʵ�̴���...',
            disabled:true,
            valueParams:{LocId:gLocId}
        }); 
	INStkTkWindowStore.load({
		params:{start:0,limit:99,'LocId':gLocId},
		callback:function(){
			Ext.getCmp("PhaWindow").setValue(gInstwWin);
		}
	});
	
    var StkGrpType=new Ext.ux.StkGrpComboBox({ 
        id : 'StkGrpType',
        name : 'StkGrpType',
        StkType:App_StkTypeCode,     //��ʶ��������
		LocId:gLocId,
		UserId:gUserId,
        anchor:'90%',
        width : 140
    });
    
	StkGrpType.on('change',function(){
		Ext.getCmp("DHCStkCatGroup").setValue("");
	});
	
    var DHCStkCatGroup = new Ext.ux.ComboBox({
                fieldLabel : '������',
                id : 'DHCStkCatGroup',
                name : 'DHCStkCatGroup',
                store : StkCatStore,
                valueField : 'RowId',
                displayField : 'Description',
                params:{StkGrpId:'StkGrpType'}
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
            'beforequery' : function(e) {
            	LocStkBinStore.removeAll();
            	LocStkBinStore.setBaseParam('LocId',gLocId);
            	LocStkBinStore.setBaseParam('Desc',this.getRawValue());
				LocStkBinStore.load({params:{start:0,limit:20}});                   
            }
        }
    }); 
 var label = new Ext.form.TextField({
	fieldLabel:'����',
	id : 'label',
	name : 'label',
	anchor : '90%'
});
    var InstNo=new Ext.form.TextField({
        id : 'InstNo',
        name : 'InstNo',
        fieldLabel:'�̵㵥��',
        anchor:'90%',
        width:140,
        disabled:true
    });
    
    // ¼�밴ť
    var AddBT = new Ext.Toolbar.Button({
                text : '¼��',
                tooltip : '���¼��',
                iconCls : 'page_add',
                width : 70,
                height : 30,
                handler : function() {
                    AddNewRow();
                }
            });
    
    function AddNewRow(){
		var rowCount = InstDetailGrid.getStore().getCount();
		var col=GetColIndex(InstDetailGrid,'desc');
		if (rowCount > 0) {
			var rowData = InstDetailStore.data.items[rowCount - 1];
			var data = rowData.get("inci");
			if (data == null || data.length <= 0) {
				InstDetailGrid.startEditing(InstDetailStore.getCount() - 1, col);
				return;
			}
		}
        var record=Ext.data.Record.create([
            {name:'instw',type:'string'},
            {name:'insti',type:'string'},
            {name:'inclb',type:'string'},
            {name:'inci',type:'string'},
            {name:'code',type:'string'},
            {name:'desc',type:'string'},
            {name:'spec',type:'string'},
            {name:'manf',type:'string'},
            {name:'batexp',type:'string'},
            {name:'uom',type:'string'},
            {name:'countQty',type:'string'},
            {name:'countDate',type:'string'},
            {name:'countTime',type:'string'},
            {name:'userName',type:'string'}
        ]);
        
        var newRecord=new record({
            instw:'',
            insti:'',
            inclb:'',
            inci:'',
            code:'',
            desc:'',
            spec:'',
            manf:'',
            batexp:'',
            uom:'',
            countQty:'',
            countDate:'',
            countTime:'',
            userName:''     
        });
        
        InstDetailGrid.getStore().add(newRecord);
        var row=InstDetailGrid.getStore().getCount()-1;
        InstDetailGrid.getSelectionModel().select(row,col);
        InstDetailGrid.startEditing(row,col);
    }
    
    // ��ѯ��ť
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
        Ext.getCmp("StkBin").setValue('');      
        Ext.getCmp("StkGrpType").setValue('');
        Ext.getCmp("PhaWindow").setValue('');
        Ext.getCmp("LocManaGrp").setValue('');
        Select();
        InstDetailGrid.store.removeAll();
        InstDetailGrid.getView().refresh();
    }

    var SaveBT=new Ext.Toolbar.Button({
        text:'����',
        tooltip:'�������',
        iconCls:'page_add',
        width:70,
        height:30,
        handler:function(){
            save();
        }
    });
    
    //����ʵ������
    function save(){
		if(InstDetailGrid.activeEditor != null){
			InstDetailGrid.activeEditor.completeEdit();
		}
        var rowCount=InstDetailStore.getCount();
        var ListDetail='';
        for(var i=0;i<rowCount;i++){
            var rowData=InstDetailStore.getAt(i);
            //�������޸Ĺ�������
            if(rowData.dirty || rowData.data.newRecord){
                var Parref=rowData.get('insti');
                var Rowid=rowData.get('instw');
                var UserId=session['LOGON.USERID'];
                var CountQty=rowData.get('countQty');
                if(CountQty==''){
                	CountQty=0;
                }
                var CountUomId=rowData.get('uom');
                var StkBin='';
                var PhaWin=Ext.getCmp('PhaWindow').getValue();
                if(Parref==null || Parref==""){
                    continue;
                }
                var Detail=Parref+'^'+Rowid+'^'+UserId+'^'+CountQty+'^'+CountUomId+'^'+StkBin+'^'+PhaWin;
                if(ListDetail==''){
                    ListDetail=Detail;
                }else{
                    ListDetail=ListDetail+xRowDelim()+Detail;
                }
            }
        }
        if(ListDetail==''){
            Msg.info('Warning','û����Ҫ���������!');
            return;
        }
        var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
        Ext.Ajax.request({
            url:url,
            params:{actiontype:'SaveTkItmWd',Params:ListDetail},
            method:'post',
            waitMsg:'������...',
            success:function(response,opt){
                var jsonData=Ext.util.JSON.decode(response.responseText);
                 mask.hide();
                if(jsonData.success=='true'){
                    Msg.info('success','����ɹ�!');
                    QueryDetail();
                }else{
                    var ret=jsonData.info;
                    if(ret=='-1'){
                        Msg.info('warning','û����Ҫ���������!');
                    }else if(ret=='-2'){
                        Msg.info('error','����ʧ��!');
                    }else{
                        Msg.info('error','�������ݱ���ʧ��:'+ret);
                    }
                }
            }       
        });
    }
        
    //�����̵㵥����ϸ��Ϣ
    function QueryDetail(){
        
        //��ѯ�̵㵥��ϸ
        var StkGrpId=Ext.getCmp('StkGrpType').getValue();
        var StkCatId=Ext.getCmp('DHCStkCatGroup').getValue();
        var StkBinId=Ext.getCmp('StkBin').getValue();
        var PhaWinId=Ext.getCmp('PhaWindow').getValue();
        var ManaGrpId=Ext.getCmp('LocManaGrp').getValue();
        var size=StatuTabPagingToolbar.pageSize;
        
        gStrDetailParams=gRowid+'^'+ManaGrpId+'^'+StkGrpId+'^'+StkCatId+'^'+StkBinId+'^'+PhaWinId;
        InstDetailStore.removeAll();
        InstDetailStore.load({params:{actiontype:'INStkTkItmWd',start:0,limit:size,sort:'desc',dir:'ASC',Params:gStrDetailParams}});
    }
    
    //��ѯ�̵㵥������Ϣ
    function Select(){
        if(gRowid==null || gRowid==""){
            return;
        }
        var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
        Ext.Ajax.request({
            url:url,
            params:{actiontype:'Select',Rowid:gRowid},
            method:'post',
            success:function(response,opt){
                var jsonData=Ext.util.JSON.decode(response.responseText);
                 mask.hide();
                if(jsonData.success=='true'){
                    var info=jsonData.info;
                    if(info!=""){
                        var detail=info.split("^");
                        var InstNo=detail[0];
                        var StkGrpId=detail[17];
                        var StkCatId=detail[18];
                        var StkCatDesc=detail[19];
                        var StkGrpDesc=detail[28];
                        Ext.getCmp("InstNo").setValue(InstNo);
                        addComboData(null,StkGrpId,StkGrpDesc,StkGrpType);
                        Ext.getCmp("StkGrpType").setValue(StkGrpId);
                        addComboData(StkCatStore,StkCatId,StkCatDesc);
                        Ext.getCmp("DHCStkCatGroup").setValue(StkCatId);
                    }
                }
            }
        
        });
    }
    
    /**
     * �������ʴ��岢���ؽ��
     */
    function GetPhaOrderInfo(item, stkgrp) {
            
        if (item != null && item.length > 0) {
            GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, "", "", "0", "",
                    getDrugList);
        }
    }
    
    var BatExpStore=new Ext.data.Store({
            proxy : new Ext.data.HttpProxy({
                        url : url
                    }),
            reader : new Ext.data.JsonReader({
                        totalProperty : "results",
                        root : 'rows'
                    },['RowId','Description'])
        
    });
    
    // ��λ
    var CTUom = new Ext.form.ComboBox({
                fieldLabel : '��λ',
                id : 'CTUom',
                name : 'CTUom',
                anchor : '90%',
                width : 120,
                store : CTUomStore,
                valueField : 'RowId',
                displayField : 'Description',
                allowBlank : false,
                triggerAction : 'all',
                emptyText : '��λ...',
                selectOnFocus : true,
                forceSelection : true,
                minChars : 1,
                pageSize : 10,
                listWidth : 250,
                valueNotFoundText : '',
                listeners:{
                    'beforequery':function(combox){
                    	CTUomStore.removeAll();
                        var cell=InstDetailGrid.getSelectionModel().getSelectedCell();
                        var record=InstDetailGrid.getStore().getAt(cell[0]);
                        var inciDr=record.get("inci");
                        CTUomStore.setBaseParam('actiontype','INCIUom');
                        CTUomStore.setBaseParam('ItmRowid',inciDr);
                        CTUomStore.load();
                    }
                }
    });
            
    //����Ч��
    var BatExp = new Ext.form.ComboBox({
                fieldLabel : '����Ч��',
                id : 'BatExp',
                name : 'BatExp',
                anchor : '90%',
                width : 120,
                store : BatExpStore,
                valueField : 'RowId',
                displayField : 'Description',
                allowBlank : false,
                triggerAction : 'all',
                emptyText : '��λ...',
                selectOnFocus : true,
                forceSelection : true,
                minChars : 1,
                pageSize : 10,
                listWidth : 250,
                valueNotFoundText : '',
                listeners:{
                    'beforequery':function(combobox){
                    	this.store.removeAll();
                        var cell=InstDetailGrid.getSelectionModel().getSelectedCell();
                        var record=InstDetailGrid.getStore().getAt(cell[0]);
                        var inciDr=record.get("inci");
                        BatExpStore.load({params:{actiontype:'GetItmFreezeBatch',Inst:gRowid,Inci:inciDr}});
                    }
                }
    });
    /**
     * ���ط���
    */
    function getDrugList(record) {
        if (record == null || record == "") {
            return;
        }
        var inciDr = record.get("InciDr");
        var inciCode=record.get("InciCode");
        var inciDesc=record.get("InciDesc");
        var spec=record.get("Spec");
        var puom=record.get("PuomDr");      
        var puomDesc=record.get("PuomDesc");    
        BatExpStore.load({
            params:{actiontype:'GetItmFreezeBatch',Inst:gRowid,Inci:inciDr},
            callback:function(r,opts){
                var count=r.length;
                //¼���ҩ���ڱ��̵㵥
                if(count<1){
                    Msg.info("warning","�����ʲ��ڱ��̵㵥��Χ������¼��!")
                    return;
                }
                var cell = InstDetailGrid.getSelectionModel().getSelectedCell();
                // ѡ����
                var row = cell[0];
                var rowData = InstDetailGrid.getStore().getAt(row);     
                rowData.set("code",inciCode);
                rowData.set("desc",inciDesc);
                rowData.set("inci",inciDr);
                var DefaultBat=BatExpStore.getAt(0);
                if(DefaultBat){
                    rowData.set("insti",DefaultBat.get("RowId"));
                    //alert(rowData.get("insti"));
                }
                
                addComboData(CTUomStore,puom,puomDesc);
                rowData.set("uom",puom);
                rowData.set("spec",spec);
                //�����������
                var col=GetColIndex(InstDetailGrid,"countQty")
                InstDetailGrid.startEditing(row, col);  
            }
        });     
    }
    
    var nm = new Ext.grid.RowNumberer();
    var InstDetailGridCm = new Ext.grid.ColumnModel([nm, {
                header : "rowid",
                dataIndex : 'instw',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : true
            }, {
                header : "parref",
                dataIndex : 'insti',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : true
            },{
                header:"inclb",
                dataIndex:'inclb',
                width:80,
                align:'left',
                sortable:true,
                hidden:true             
            },{
                header : '����',
                dataIndex : 'code',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : "����",
                dataIndex : 'desc',
                width : 200,
                align : 'left',
                sortable : true,
                editor:new Ext.form.TextField({
                    selectOnFocus : true,
                    allowBlank : false,
                    listeners : {
                        specialkey : function(field, e) {
                            var keyCode=e.getKey();
                            
                            if (keyCode == Ext.EventObject.ENTER) {                             
                                var stkGrp = Ext.getCmp("StkGrpType").getValue();
                                
                                GetPhaOrderInfo(field.getValue(),stkGrp);
                            }
                        }
                    }
                })
            }, {
                header : "���",
                dataIndex : 'spec',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header:'����~Ч��',
                dataIndex:'insti',
                width:150,
                align:'left',
                sortable:true,
                editor:BatExp,
                //renderer:Ext.util.Format.comboRenderer(BatExp),
                renderer:Ext.util.Format.comboRenderer2(BatExp,'insti','batNo','expDate'),   
                listeners:{
                    'specialkey' : function(field, e) {
                                if (e.getKey() == Ext.EventObject.ENTER) {  
                                    var cell=InstDetailGrid.getSelectionModel().getSelectedCell();
                                    var col=GetColIndex(InstDetailGrid,"countQty")
                                    InstDetailGrid.startEditing(cell[0], col);                                  
                                }
                            }                   
                }
            }, {
                header : "��λ",
                dataIndex : 'uom',
                width : 60,
                align : 'left',
                sortable : true,
                editor:CTUom,
                renderer:Ext.util.Format.comboRenderer2(CTUom,'uom','uomDesc')
                
            },{
                header:'ʵ������',
                dataIndex:'countQty',
                width:80,
                align:'right',
                sortable:true,
                editor:new Ext.form.NumberField({
                    selectOnFocus : true,
                    //allowBlank : false,
                    allowNegative : false,
                    listeners:{
                        'specialkey':function(field,e){
                                var keyCode=e.getKey();
                                var col=GetColIndex(InstDetailGrid,'countQty');
                                var cell=InstDetailGrid.getSelectionModel().getSelectedCell();
                                var rowCount=InstDetailGrid.getStore().getCount();
                                if(keyCode==Ext.EventObject.ENTER){
                                    var qty=field.getValue();
                                    if(qty<0){
                                        Msg.info('warning','ʵ����������С����!');
                                        return;
                                    }                                   
                                    AddNewRow();
                                }
                                if(keyCode==Ext.EventObject.UP){
                                    var row=cell[0]-1;
                                    if(row>=0){
                                        InstDetailGrid.startEditing(row,col);
                                    }
                                }
                                if(keyCode==Ext.EventObject.DOWN){
                                    var row=cell[0]+1;
                                    if(row<rowCount){
                                        InstDetailGrid.startEditing(row,col);
                                    }
                                }
                        }
                    }
                })
            },{
                header : "����",
                dataIndex : 'manf',
                width : 100,
                align : 'left',
                sortable : true
            },{
                header:'ʵ������',
                dataIndex:'countDate',
                width:80,
                align:'left',
                sortable:true
            },{
                header : "ʵ��ʱ��",
                dataIndex : 'countTime',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header:'ʵ����',
                dataIndex:'userName',
                width:80,
                align:'left',
                sortable:true
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
                    id : "instw",
                    fields : ["instw","insti", "inclb","inci","code", "desc","spec", "manf", "batNo", "expDate",
                            "freQty", "uom", "uomDesc","buom","buomDesc", "rp", "sp", "countQty",
                            "countDate","countTime","userName"]
                }),
                pruneModifiedRecords:true
    });

    var StatuTabPagingToolbar = new Ext.PagingToolbar({
                store : InstDetailStore,
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
                    B['Params']=gStrDetailParams;
                    B['actiontype']='INStkTkItmWd';
                    if(this.fireEvent("beforechange",this,B)!==false){
                        this.store.load({params:B});
                    }
                }
            });
        
    StatuTabPagingToolbar.addListener('beforechange',function(toolbar,params){
		if(InstDetailGrid.activeEditor != null){
			InstDetailGrid.activeEditor.completeEdit();
		}
		var records=InstDetailStore.getModifiedRecords();
		if(records.length>0){
			Msg.info("warning","��ҳ���ݷ����仯�����ȱ��棡");
			return false;
		}
    });
    
    var InstDetailGrid = new Ext.grid.EditorGridPanel({
                id:'InstDetailGrid',
                region : 'center',
                title:'�̵���ϸ��Ϣ',
                cm : InstDetailGridCm,
                store : InstDetailStore,
                trackMouseOver : true,
                stripeRows : true,
                sm : new Ext.grid.CellSelectionModel(),
                loadMask : true,
                bbar : StatuTabPagingToolbar,
                clicksToEdit:1
            });
    
        var form = new Ext.form.FormPanel({
            labelwidth : 30,
            labelAlign : 'right',
            region:'north',
            height:250,
            title:'ʵ��:¼�뷽ʽ��(���������)',
            frame : true,
            bodyStyle : 'padding:10px 0px 0px 0px;',
            tbar:[SearchBT,'-',SaveBT,'-',AddBT,'-',RefreshBT],
            items:[{
                    xtype:'fieldset',
                    title:'��ѯ����',
                    layout: 'column',
                    style: 'padding:5px 0 5 0;',
                    defaults: {border:false},
                    items : [{              
                        columnWidth: 0.34,
                        xtype: 'fieldset',
                        items: [LocManaGrp,StkBin]
                        
                    },{                 
                        columnWidth: 0.33,
                        xtype: 'fieldset',
                  		items: [StkGrpType,DHCStkCatGroup]
                        
                    },{                 
                        columnWidth: 0.33,
                        xtype: 'fieldset',
                        items: [PhaWindow,InstNo]
                        
                    }]
            },{
                xtype:'fieldset',
                    title:'ɨ������¼��',
                    layout: 'column',
                    style: 'padding:5px 0 5 0;',
                    defaults: {border:false}, 
                    items : [{   
                        columnWidth: 0.33,
                        xtype:'fieldset',
                        defaults: {border:false},    // Default config options for child items
                        items: [label] } ]
            }]
                   
        });
    
        // 5.2.ҳ�沼��
        var mainPanel = new Ext.ux.Viewport({
                    layout : 'border',
                    items :  [form,InstDetailGrid]
        });
        
        Select();
})