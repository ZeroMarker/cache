var startDateField = new Ext.form.DateField({
	id:'startDateField',
	fieldLabel: '��ʼ����',
	columnWidth : .1,
	allowBlank:true,
	format:'Y-m-d',
	selectOnFocus:'true'
});

var endDateField = new Ext.form.DateField({
	id:'endDateField',
	fieldLabel: '��ʼ����',
	columnWidth : .1,
	allowBlank:true,
	format:'Y-m-d',
	selectOnFocus:'true'
});

var fileNo = new Ext.form.TextField({
			columnWidth : .1,
			selectOnFocus : true
});
		
var IsApproveCombo = new Ext.form.ComboBox({
			fieldLabel : 'Ԥ���´�',
			store : [['0', '��'], ['1', '��']],
			edit:false,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			columnWidth : .1,
			listWidth : 120,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
});

///////////// ������ ///////////////////
projUrl='herp.budg.budgadjustdeptyearauditexe.csp';
var yearDs  = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});
yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:projUrl+'?action=yearlist',method:'POST'})
});
var yearField  = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '������',
	width : 100,
	listWidth : 100,
	store: yearDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	columnWidth : .1,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	listeners:{
            "select":function(combo,record,index){
	            AdjustNoStore.removeAll();     
				AdjustNo.setValue('');
				AdjustNoStore.proxy = new Ext.data.HttpProxy({url:projUrl+'?action=adjustno&year='+combo.value,method:'POST'})  
				AdjustNoStore.load({params:{start:0,limit:10}});      					
			}
	}	
});

////////////// ������� //////////////////////
var strInfo="��ѡ��..."
var AdjustNoStore = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','AdjustNo'])
});
AdjustNoStore.on('beforeload', function(ds, o){
	var year=yearField.getValue();	
	if(!year){
		Ext.Msg.show({title:'ע��',msg:'����ѡ�������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
});
var AdjustNo = new Ext.form.ComboBox({
	id: 'AdjustNo',
	fieldLabel: '�������',
	width : 100,
	listWidth : 225,
	store: AdjustNoStore,
	valueField: 'AdjustNo',
	displayField: 'AdjustNo',
	triggerAction: 'all',
	emptyText:'��ѡ��...',
	name: 'AdjustNo',
	minChars: 1,
	pageSize: 10,
	columnWidth : .1,
	selectOnFocus:true,
	//columnWidth:.15,
	forceSelection:'true',
	editable:true,
	listeners:{
		 "select":function(combo,record,index){
		 	/*itemGrid.load({
							params : {
								start: 0,
								limit: 25,
								Year:yearField.getValue(),
								AdjustNo : AdjustNo.getValue()
							}
			});  */ 
		}
	}
});


var startButton = new Ext.Toolbar.Button({
		text: '������������',
		tooltip: '������������',
		iconCls: 'add',
		handler: function(){
			var adjno = AdjustNo.getValue();
			var year = yearField.getValue();
			if((adjno=="")||(year=="")){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ⱥ͵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			if ((adjno!="")&&(year!=""))
			{
				Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫ���øõ�������?', 
    	    function(btn){
				if(btn=="yes"){
				
				var myMask = new Ext.LoadMask(Ext.getBody(), {
       			msg: '���������С�',
        		removeMask: true //��ɺ��Ƴ�
    			});
	
	 			myMask.show();
				//for(var i=0;i<len;i++){
				Ext.Ajax.request({
				url:'../csp/herp.budg.budgadjustexe.csp?action=start&Year='+year+'&AdjustNo='+adjno,
				waitMsg:'������...',
				failure: function(result, request){
					myMask.hide();
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						myMask.hide();
						Ext.Msg.show({title:'ע��',msg:'���óɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}else{
						var message = "";
						message = "SQLErr: " + jsonData.info;
						if(jsonData.info=='UNDO') message='�ü�¼��ִ�й���';
						else message='����ʧ�ܣ�';
						myMask.hide();
						Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this						
				});
			}
			else{return;}
			})										
		}
}
});


// ��ҳ���ѯ
var queryButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls: 'option',
			//width:120,
			handler : function() {
				var startDate=((startDateField.getValue()=='')?'':startDateField.getValue().format('Y-m-d'));
				var endDate=((endDateField.getValue()=='')?'':endDateField.getValue().format('Y-m-d'));
				var fileno = fileNo.getValue();
				var IsApprove = IsApproveCombo.getValue();
				itemGrid.load({
							params : {
								start: 0,
								limit: 25,
								startDate: startDate,
								endDate: endDate,
								AdjustFile : fileno,
								IsApprove : IsApprove
							}
				});
			}	
});

var queryPanel = new Ext.FormPanel({
	height : 120,
	region : 'north',
	frame : true,
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:150%">���Ԥ���������</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '��ʼ����:',
					columnWidth : .08
				},startDateField,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '��������:',
					columnWidth : .08
				},endDateField
				,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '�����ĺ�:',
					columnWidth : .08
				},fileNo
				,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : 'Ԥ���´�:',
					columnWidth : .08
				},IsApproveCombo
				,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},
				queryButton			
		]
	},{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '������:',
					columnWidth : .08
				},yearField,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},
				{
					xtype : 'displayfield',
					value : '�������:',
					columnWidth : .08
				},AdjustNo,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},startButton				
		]
	}]
});




var IsApproveCombo2 = new Ext.form.ComboBox({
			fieldLabel : 'Ԥ���´�',
			store : [['0', '��'], ['1', '��']],
			edit:false,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 200,
			listWidth : 120,
			pageSize : 10,
			minChars : 1,
			//columnWidth : .1,
			selectOnFocus : true
});


var adjustUrl = 'herp.budg.budgadjustexe.csp';
var addProxy = new Ext.data.HttpProxy({url: adjustUrl+'?action=list'});
var startDs = new Ext.data.Store({
	proxy: addProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
		}, [
     		'rowid',
     		'CompDR',
     		'Year',
			'AdjustNo',
			'AdjustDate',
			'AdjustFile',
			'Memo',
			'IsApprove',
			'IsElast',
			'ElastMonth',
			'schemeName',
			'itemCode'
		]),
    remoteSort: true
});

var itemGrid = new dhc.herp.Grid({
        title: 'Ԥ����ȵ���',
        width: 400,
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.budg.budgadjustexe.csp',	  
		tbar:[addButton],
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [ new Ext.grid.CheckboxSelectionModel({sm:'sm',editable:false}),
        {
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'CompDR',
            header: 'ҽ�Ƶ�λ',
			width:120,
			hidden: true,
            dataIndex: 'CompDR'
        },{
            id:'Year',
            header: '������',
			allowBlank: false,
			//hidden: true,
			editable:false,
			width:120,
			update:true,
            dataIndex: 'Year'
        },{								//rowid CompDR  Year AdjustNo AdjustAate AdjustFile Memo IsApprove IsElast ElastMonth
            id:'AdjustNo',
            header: '�������',
           	editable:false,
            allowBlank: false,
			width:120,
            dataIndex: 'AdjustNo',
        	renderer : function(value, cellmeta, record, rowIndex, columnIndex, store)
						{ 
							return '<span style="color:blue;cursor:hand">'+value+'</span>'	 
						}
        },{
            id:'AdjustDate',
            header: '��������',
			//hidden: true,
			width:120,
			editable:false,
            dataIndex: 'AdjustDate',
            //type:"dateField" ,   
            altFormats:'Y-m-d'
        },{
            id:'AdjustFile',
            header: '�����ĺ�',
			//hidden: true,
			width:120,
			editable:false,
            dataIndex: 'AdjustFile'
        },{
            id:'IsApprove',
            header: '�Ƿ�ָ���´�',
			width:120,
			editable:false,
			type:IsApproveCombo2,
			dataIndex: 'IsApprove'
           
        },{
            id:'Memo',
            header: '����˵��',
			width:120,
			editable:false,
            dataIndex: 'Memo'
        },{
            id:'IsElast',
            header: '�Ƿ���Ԥ��',
			width:150,
			editable:false,
            dataIndex: 'IsElast',
            hidden: true
        },{
            id:'ElastMonth',
            header: '���Ե����·�',
			width:150,
			editable:false,
            dataIndex: 'ElastMonth',
            hidden: true
        },{
            id:'schemeName',
            header: '��Ӧ����',
            edit:false,
			width:120,
			editable:false,
           // dataIndex: 'schemeName',
            renderer : function(value, cellmeta, record, rowIndex, columnIndex, store)
						{ 
							return '<span style="color:blue;cursor:hand">��Ӧ����</span>'	 
						}
        },{
            id:'itemCode',
            header: 'Ԥ����Ϣ',
			width:120,
			editable:false,
			hidden: true,
            dataIndex: 'itemCode'
            /*,renderer : function(value, cellmeta, record, rowIndex, columnIndex, store)
						{ 
							return '<span style="color:blue;cursor:hand">'+value+'</span>'	 
						}*/
        }] 
});

    //itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);
	itemGrid.btnAddHide(); 		//�������Ӱ�ť
  	itemGrid.btnSaveHide(); 	//���ر��水ť
    itemGrid.btnResetHide() ;	//�������ð�ť
    itemGrid.btnPrintHide() ;	//���ش�ӡ��ť

// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	var records = itemGrid.getSelectionModel().getSelections();
	if (columnIndex == 5) {         	
		var rowid  = records[0].get("rowid");
		var CompDR  = records[0].get("CompDR");
		var Year  = records[0].get("Year");
		var AdjustNo  = records[0].get("AdjustNo");
		var AdjustDate  = records[0].get("AdjustDate");
		var AdjustFile  = records[0].get("AdjustFile");
		var Memo  = records[0].get("Memo");
		var IsApprove  = records[0].get("IsApprove");
		var IsElast  = records[0].get("IsElast");
		var ElastMonth  = records[0].get("ElastMonth");
		
		editFun(rowid,CompDR,Year, AdjustNo, AdjustDate, AdjustFile,Memo,IsApprove, IsElast,ElastMonth);
	    //alert("����");
	}
	else if(columnIndex == 12)
		{
			var Year  = records[0].get("Year");
			var adjustNo = records[0].get("AdjustNo");
			var Memo = records[0].get("Memo");
			var rowid  = records[0].get("rowid");
			budginstructionFun(rowid,Year,adjustNo, Memo);
			//alert("shide");
		}
	/*else if (columnIndex == 13) {
		var year= records[0].get("Year");
		var adjustNo= records[0].get("AdjustNo");	
		var itemCode= records[0].get("itemCode");
		budginfoFun(year, adjustNo, itemCode);
		//alert(itemCode);
		
	}*/
});