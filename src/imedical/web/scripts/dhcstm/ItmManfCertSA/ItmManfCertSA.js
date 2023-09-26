 
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
//====================================================
 var InciRowId="" ;
 
 var IMC="";
 var MCSA=""
 //����
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
	}
}

function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	InciRowId = record.get("InciDr");
	// var InciCode=record.get("InciCode");
	var InciDesc=record.get("InciDesc");
	Ext.getCmp("M_InciDesc").setValue(InciDesc);
	// Ext.getCmp("M_InciCode").setValue(InciCode);
	findSA.handler();
}
		
var conditionDescField = new Ext.form.TextField({
	fieldLabel : '��������',
	id : 'M_InciDesc',
	name : 'M_InciDesc',
	anchor : '90%',
	width : 150,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var stktype = ""
				GetPhaOrderInfo(field.getValue(), stktype);
			}
		}
	}
});	

  //ע��֤
 var certNo = new Ext.form.TextField({
    id:'certNo',
    fieldLabel:'ע��֤',
    allowBlank:true,
    listWidth:150,
    emptyText:'ע��֤...',
    anchor:'90%',
    selectOnFocus:true
});

 //����
var PhManufacturer = new Ext.ux.ComboBox({
	fieldLabel : '����',
	id : 'PhManufacturer',
	name : 'PhManufacturer',
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHMNFName'
	// ,
	// params : {LocId : 'PhaLoc',ScgId : 'StkGrpType'}
});

//��Ӧ��
var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '��Ӧ��',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '��Ӧ��...',
	listWidth : 250,
	rcFlag:true
	// ,
	// params : {LocId : 'locField',ScgId : 'groupField'}
});
 
 			
				
var itmManfCertSAGrid="";
//��������Դ
var itmManfCertSAUrl = 'dhcstm.itmmanfcertsaaction.csp';
var itmManfCertSAGridProxy= new Ext.data.HttpProxy({
	url:itmManfCertSAUrl+'?actiontype=querySAByManf'
	// ,
	// method:'POST'
});
var itmManfCertSADs = new Ext.data.GroupingStore({
    proxy:itmManfCertSAGridProxy,
	sortInfo:{field: 'manf', direction: 'ASC'},
	 groupOnSort: true,
	groupField:'manf',
    reader:new Ext.data.JsonReader({
		 idProperty:'RowId',
        root:'rows',
        totalProperty:'results'
    }, [
	    {name:'RowId'}, 
        {name:'manf'},
        {name:'certNo'},
        {name:'certNoExpDate'},
        {name:'vendor1'},
        {name:'vendor1ExpDate'},
        {name:'vendor2'},
        {name:'vendor2ExpDate'},
        {name:'vendor3'},
        {name:'vendor3ExpDate'},
		'vendor4', 'vendor4ExpDate',
        {name:'active'}
    ])
});


		
var itmManfCertSAGridCm = new Ext.grid.ColumnModel([
     new Ext.grid.RowNumberer(),
	 {
        header:"RowId",
        dataIndex:'RowId',
		hidden:true,
        align:'left',
        sortable:true
    },
     {
        header:"����",
        dataIndex:'manf',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"ע��֤",
        dataIndex:'certNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"ע��֤Ч��",
        dataIndex:'certNoExpDate',
        width:120,
        align:'left',
        sortable:true
		// ,
        // editor:new Ext.grid.GridEditor(SlgG),
        // renderer : Ext.util.Format.comboRenderer2(SlgG,"SlgId","SlgDesc")
    },{
        header:"��Ӧ��(һ��)",
        dataIndex:'vendor1',
        width:150,
        align:'left',
        sortable:true
		// ,
        // editor:new Ext.grid.GridEditor(LigG),
        // renderer : Ext.util.Format.comboRenderer2(LigG,"LigId","LigDesc")
    },{
        header:"��Ӧ��(һ��)Ч��",
        dataIndex:'vendor1ExpDate',
        width:120,
        align:'left',
        sortable:true
		
    },{
        header:"��Ӧ��(����)",
        dataIndex:'vendor2',
        width:150,
        align:'left',
        sortable:true

    },{
        header:"��Ӧ��(����)Ч��",
        dataIndex:'vendor2ExpDate',
        width:120,
        align:'left',
        sortable:true
		
    },{
        header:"��Ӧ��(����)",
        dataIndex:'vendor3',
        width:150,
        align:'left',
        sortable:true
		
    },{
        header:"��Ӧ��(����)Ч��",
        dataIndex:'vendor3ExpDate',
        width:120,
        align:'left',
        sortable:true
		
    },{
		header:"��Ӧ��(�ļ�)",
		dataIndex:'vendor4',
		width:150,
		align:'left',
		sortable:true
	},{
		header:"��Ӧ��(�ļ�)Ч��",
		dataIndex:'vendor4ExpDate',
		width:120,
		align:'left',
		sortable:true
	},{
		header:'����',
		 tooltip: "����ͼƬ",  
		 width:50,
		 renderer: function (value, meta, record) {  
  
			 var formatStr = "<button  onclick=browsePics() class='order_bit'>�鿴</button>";   
			 var resultStr = String.format(formatStr);  
			 return "<div class='controlBtn'>" + resultStr + "</div>";  
		 } .createDelegate(this),  
		 css: "text-align:center;height:8",  
		 sortable: false  
	}
]);
 
function browsePics()
{
  
  var sm=Ext.getCmp('mcsagrid').getSelectionModel();
  var rec=sm.getSelected();
  if (!rec)
  {
	  return;  
  }
  var rowid=rec.get('RowId');
  
	var PicUrl = 'dhcstm.itmmanfcertsaaction.csp?actiontype=GetSaPic';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
		url : PicUrl,
		method : "POST"
	});
	
	// ָ���в���
	var fields = ["rowid", "venid","vendesc", "picsrc","type"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		// id : "rowid",
		fields : fields
	});
	// ���ݼ�
	var PicStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	var FnDel=function(rowid,picsrc)
		{
			   var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
				Ext.Ajax.request({
					url:'dhcstm.apcvendoraction.csp?actiontype=DeletePic&rowid='+rowid+'&picsrc='+picsrc,
					waitMsg:'ɾ����...',
					failure: function(result, request) {
						 mask.hide();
						Msg.info("error", "������������!");
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						 mask.hide();
						if (jsonData.success=='true') {
							Msg.info("success", "ɾ���ɹ�!");
				  
						}else{ 
								Msg.info("error", "ɾ��ʧ��!");
						}
					},
					scope: this
				});
			}

	ShowPicWindow(PicStore,rowid,FnDel)  
}
var clearSA = new Ext.Toolbar.Button({
    text:'���',
    tooltip:'���',
    iconCls:'page_clearscreen',
    width : 70,
    height : 30,
    handler:function(){
		Ext.getCmp('PhManufacturer').setValue('');
		Ext.getCmp('Vendor').setValue('');
		Ext.getCmp('certNo').setValue('');
		
		itmManfCertSAGrid.getStore().removeAll();
        itmManfCertSAGrid.getView().refresh();
    }
});

var findSA = new Ext.Toolbar.Button({
    text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
    width : 70,
    height : 30,
    handler:function(){	
    	// itmManfCertSADs.setBaseParam("sort",'Rowid');
		var manf=Ext.getCmp('PhManufacturer').getValue();
		var cert=Ext.getCmp('certNo').getValue();
		var vendor=Ext.getCmp('Vendor').getValue();
		if(Ext.getCmp('M_InciDesc').getValue() == ''){
			InciRowId = '';
		}
		var inci=InciRowId;  //Ʒ��
        itmManfCertSADs.load({params:{start:0,limit:itmManfCertSAToolBar.pageSize,manf:manf,cert:cert,vendor:vendor,inci:inci}});
    }
});

var findItmListButton=new Ext.Toolbar.Button({
	text:'����Ʒ���б�...',
	iconCls:'page_refresh',
	width:70,
	height:30,
	handler:function()
	{
		var sm=itmManfCertSAGrid.getSelectionModel();		
		var rec=sm.getSelected();
		if(rec==null){
			Msg.info("warning", "��ѡ����Ȩ��!");
			return;
		}
		var sa=rec.get('RowId');
		if (sa==''){return;}
		//����
		
		MCSAItmList(sa);
		
	}
});


var formPanel = new Ext.ux.FormPanel({
	title:'���ʹ�������Ȩ��Ϣ',
    tbar:[findSA,'-',clearSA,'-',findItmListButton],
    items : [{
		xtype : 'fieldset',
		title : '��ѯ����',
		layout : 'column',
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,columnWidth : .33,xtype:'fieldset'},
		items : [{
				items : [PhManufacturer,certNo]
			}, {
				items : [Vendor]
			}, {
				items : [conditionDescField]
		}]
    }]
});

//��ҳ������
var itmManfCertSAToolBar = new Ext.PagingToolbar({
    store:itmManfCertSADs,
    pageSize:PageSize,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼"
});

//���
itmManfCertSAGrid = new Ext.grid.EditorGridPanel({
	title:'������Ȩ��',
	id:'mcsagrid',
    store:itmManfCertSADs,
    cm:itmManfCertSAGridCm,
    trackMouseOver:true,
    region:'center',
    stripeRows:true,
	view: new Ext.grid.GroupingView({
        forceFit: true,
		headersDisabled :true,
			hideGroupedColumn :true,
        // custom grouping text template to display the number of items per group
        groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "��" : "��"]})'
    }),
    sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
    // plugins: [ActiveF,ReqAllItmF],
    //plugins:[B,BB] ReqAllItmF,
    
    loadMask:true,
    bbar:itmManfCertSAToolBar,
    clicksToEdit:2
});

//=========================������չ��Ϣ=============================

//===========ģ����ҳ��=============================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    var panel = new Ext.Panel({
        title:'���ʹ�������Ȩ��Ϣ',
        activeTab:0,
        region:'north',
        height:170,
        layout:'fit',
        items:[formPanel]
    });
    
    var mainPanel = new Ext.ux.Viewport({
        layout:'border',
        items:[formPanel,itmManfCertSAGrid],
        renderTo:'mainPanel'
    });
});
//===========ģ����ҳ��=============================================