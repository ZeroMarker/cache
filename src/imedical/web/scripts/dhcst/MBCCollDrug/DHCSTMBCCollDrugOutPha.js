
var unitsUrl = 'dhcst.mbccolldrugaction.csp';
var gParentId=""
var NumberI='70' //���﷢��
Ext.onReady(function() {
       var gUserId = session['LOGON.USERID'];
	Ext.QuickTips.init();// ������Ϣ��ʾ
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

var BarCode = new Ext.form.TextField({
		fieldLabel : '����',
		id : 'BarCode',
		name : 'BarCode',
		anchor : '90%',
		width : 140,
		listeners : {
			specialkey : function(field, e) {
			var keyCode=e.getKey();
			if ( keyCode== Ext.EventObject.ENTER) {
			   MainGridDs.removeAll();
			   var outphaed=Ext.getCmp('OutPhaEd').getValue();
			   if (outphaed==false) {
			    DecSaveCom();}
			    else 
			    {    
			         var prescno=Ext.getCmp("BarCode").getValue();
			         MainGridDs.setBaseParam("Prescno",prescno)
                     MainGridDs.setBaseParam("User",gUserId)
                     MainGridDs.load();}
			}
		    }
		}
		});	

   //�ѷ���
   var OutPhaEdChkbox=new Ext.form.Checkbox({
        
		boxLabel : '�ѷ���',
		id : 'OutPhaEd',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
	
					}
		}
    })

//ɨ�豣��
function DecSaveCom(){

              var prescno=Ext.getCmp("BarCode").getValue();
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		 Ext.Ajax.request({
			 url: unitsUrl+'?action=OutPhaSave',
			 params: {Prescno:prescno,User:gUserId},
			 failure: function(result, request) {
			     mask.hide();
			     Msg.info("error", "������������!");
			    },
			  success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					 
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
                                           MainGridDs.removeAll();
                                           MainGridDs.setBaseParam("Prescno",prescno)
                                           MainGridDs.setBaseParam("User",gUserId)
                                           MainGridDs.load();
					}else if (jsonData.info=="-10"){
					     Msg.info("error", "������Ϊ��!");
					}
					 else if (jsonData.info=="-20"){
					     Msg.info("error", "�Ǵ��崦��!");
				       }
					 else if (jsonData.info=="-30"){
					      Msg.info("error", "�ô���δ��ҩ!")
					}
					else if (jsonData.info.indexOf("-40")>=0){
						  var nextstatestr=jsonData.info.split("^")
						  var nextstate=nextstatestr[1]
					      Msg.info("warning", "�ô�������һ״̬�������﷢��״̬!"+"״̬ӦΪ:"+nextstate+"!")
					}
					else if (jsonData.info=="-50"){
					      Msg.info("warning", "�����Ų�����!")
					}
					else if (jsonData.info=="-60"){
					      Msg.info("warning", "�ô�������δ��ҩ!")
					}					
					
					else{
					      Msg.info("error", "����ʧ��!");
						
					}
				},
				scope: this
			});
 	 Ext.getCmp("BarCode").setValue("");
        Ext.getCmp("BarCode").focus();
	}
	
   function addNewRow() {
	var record = Ext.data.Record.create([
                    
                    {
			  name : 'MBCId',
			  type : 'string'
			},
                    {
			  name : 'PatLoc',
			  type : 'string'
			}, {
			  name : 'PatNo',
			  type : 'string'
			}, {
			  name : 'PatName',
			  type : 'string'
		       }, {
			  name : 'Prescno',
			  type : 'string'
			}, {
			  name : 'State',
			  type : 'string'
		       }
	]);
					
   }
    
    var MainGridProxy= new Ext.data.HttpProxy({url:unitsUrl+'?action=GetOutPhaPresc',method:'GET'});
    var MainGridDs = new Ext.data.Store({
	proxy:MainGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [      {name:'MBCId'},
		{name:'PatLoc'},
		{name:'PatNo'},
		{name:'PatName'},
		{name:'Prescno'},
		{name:'State'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
    });
    //ģ��
    var MainGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"rowid",
        dataIndex:'MBCId',
        width:100,
        align:'left',
        sortable:true,
        hidden:true
	 }, {
        header:"����",
        dataIndex:'PatLoc',
        width:100,
        align:'left',
        sortable:true
	 },{
        header:"�ǼǺ�",
        dataIndex:'PatNo',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"��������",
        dataIndex:'PatName',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"������",
        dataIndex:'Prescno',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"״̬",
        dataIndex:'State',
        width:200,
        align:'left',
        sortable:true
	 }
	 
	 ])
    MainGrid = new Ext.grid.EditorGridPanel({
	store:MainGridDs,
	cm:MainGridCm,
	trackMouseOver:true,
	stripeRows:true,
	//sm:new Ext.grid.CellSelectionModel({}),
	sm : new Ext.grid.RowSelectionModel({
		 singleSelect : true
		 }),
	loadMask:true,
    tbar:[BarCode,"����",'-',OutPhaEdChkbox],
	clicksToEdit:1
    });

      var ChildGridProxy= new Ext.data.HttpProxy({url:unitsUrl+'?action=GetOutPhaPrescDetail',method:'GET'});
    var ChildGridDs = new Ext.data.Store({
	proxy:ChildGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [{name:'DrugCode'},
		{name:'DrugDesc'},
		{name:'DrugQty'},
		{name:'DrugUom'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
    });
    //ģ��
    var ChildGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"ҩƷ����",
        dataIndex:'DrugCode',
        width:100,
        align:'left',
        sortable:true
	 }, {
        header:"ҩƷ����",
        dataIndex:'DrugDesc',
        width:100,
        align:'left',
        sortable:true
	 },{
        header:"ҩƷ����",
        dataIndex:'DrugQty',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"��λ",
        dataIndex:'DrugUom',
        width:200,
        align:'left',
        sortable:true
	 }
	 
	 ])
    ChildGrid = new Ext.grid.EditorGridPanel({
	store:ChildGridDs,
	cm:ChildGridCm,
	trackMouseOver:true,
	stripeRows:true,
	//sm:new Ext.grid.CellSelectionModel({}),
	sm : new Ext.grid.RowSelectionModel({
		 singleSelect : true
		 }),
	loadMask:true
    });    
 	// ��ӱ�񵥻����¼�
	MainGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var Prescno = MainGridDs.getAt(rowIndex).get("Prescno");
			ChildGridDs.setBaseParam('Prescno',Prescno)
			ChildGridDs.load();
		});
		
 	// ��ӱ��load�¼�
	MainGridDs.on('load', function() {
                       MainGrid.getSelectionModel().selectFirstRow();
		});		
		
        
    var MainPanel = new Ext.Panel({
		title:'���﷢������',
		activeTab: 0,
		region:'center',
		layout:'fit',
		items:[MainGrid]                                 
	});        	  
        
    var ChildPanel = new Ext.Panel({
		title:'���﷢��������ϸ',
		activeTab: 0,
		region:'south',
		height: 450,
		layout:'fit',
		items:[ChildGrid]                                 
	});  
	var por = new Ext.Viewport({

				layout : 'border', // ʹ��border����

				items : [MainPanel,ChildPanel]

			});

	 Ext.getCmp("BarCode").setValue("");
        Ext.getCmp("BarCode").focus();
});
