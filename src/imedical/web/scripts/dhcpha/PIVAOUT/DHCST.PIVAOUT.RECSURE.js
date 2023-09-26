///��Һ����
///Copy:��Һ����
///Creator:BianShuai
///CreatDate:2013-09-22
///DHCST.PIVAOUT.RECSURE.js

var unitsUrl = 'DHCST.PIVAOUT.SAVEURL.csp';
var waitMask;

Ext.onReady(function(){

	Ext.QuickTips.init();// ������Ϣ��ʾ
	Ext.Ajax.timeout = 900000;

	///ҩ�����ҿؼ�
	var phlocInfo = new Ext.data.Store({
		autoLoad: true,
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['phlocdesc','rowId'])
			
	});

	phlocInfo.on(
		'beforeload',
		function(ds, o){
		    var grpdr=session['LOGON.GROUPID'] ;
			ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetStockPhlocDs&GrpDr='+grpdr, method:'GET'});
	
		}
	);
	
	var PhaLocSelecter = new Ext.form.ComboBox({
		id:'PhaLocSelecter',
		fieldLabel:'ҩ������',
		store: phlocInfo,
		valueField:'rowId',
		displayField:'phlocdesc',
		width : 120,
		listWidth:250,
		emptyText:'ѡ��ҩ������...',
		allowBlank: false,
		name:'PhaLocSelecter',
		mode: 'local'
	});
	

	phlocInfo.on("load",function(store,record,opts){ setDefaultLoc(); });

	//ˢ��
	var  RefreshButton = new Ext.Button({
		width : 70,
		id:"RefreshBtn",
		text: '��ѯ',
		icon:"../scripts/dhcpha/img/find.gif",
		listeners:{
			"click":function(){   
				FindCheckedPatInfo();
			}   
		}
	})
  



	var OkButton = new Ext.Button({
		width : 65,
		id:"OkButton",
		text: '����',
		icon:"../scripts/dhcpha/img/update.png",
		listeners:{
			"click":function(){   
				SaveSure();
			}   
		}
	})
        
	var PrtButton = new Ext.Button({
		width : 65,
		id:"PrtButton",
		text: '��ӡ',
		iconCls:'page_print',
		listeners:{
			"click":function(){   
				//CommontOk();
			}   
		}
	})

	///�ѽ���
	var OnlyAdtChkbox=new Ext.form.Checkbox({
		boxLabel : '�ѽ���',
		id : 'OnlyAdtChk',
		inputValue : '1',
		checked : false,
		listeners:{
			'check': function(){
			}
		}
	})

	 ///ҽ����ϸ����table
	function selectbox(re,params,record,rowIndex)
	{
		return '<input type="checkbox" id="TSelectz'+rowIndex+'" name="TSelectz'+rowIndex+'"  value="'+re+'"  >';
	} 

	var orddetailgridcm = new Ext.grid.ColumnModel({
		columns:[
		    {header:'<input type="checkbox" id="TDSelectOrdItm" >',width:40,menuDisabled:true,dataIndex:'select',renderer:selectbox}, 
		    {header:'�ǼǺ�',dataIndex:'patid',width:90},
		    {header:'����',dataIndex:'patname',width:90},
		    {header:'��ҩ����',dataIndex:'orddate',width:120},
		    {header:'������',dataIndex:'prescno',width:120},
		    {header:'������hide',dataIndex:'prescnoT',width:120,hidden:true}, 
		    {header:'ҩƷ����',dataIndex:'incidesc',width:200},
		    {header:'����',dataIndex:'qty',width:40},
		    {header:'��λ',dataIndex:'uomdesc',width:60},
		    {header:'����',dataIndex:'dosage',width:60},
		    {header:'Ƶ��',dataIndex:'freq',width:50},
		    {header:'���',dataIndex:'spec',width:80},
		    {header:'�÷�',dataIndex:'instruc',width:80},
		    {header:'��ҩ�Ƴ�',dataIndex:'dura',width:70},
		    {header:'����',dataIndex:'form',width:80},
		    {header:'ҽ��',dataIndex:'doctor',width:60},
		    {header:'ҽ����ע',dataIndex:'remark',width:120},
		    {header:'rowid',dataIndex:'orditm',hidden:true},
		    {header:'dsprowid',dataIndex:'dsprowid',width:60},
		    {header:'pogid',dataIndex:'pogid',width:60},
		    {header:'�Ƿ���',dataIndex:'packflag',width:120},
		    {header:'����',dataIndex:'barcode',width:120}
		    ]
	});
 
	var orddetailgridds = new Ext.data.Store({
		proxy: "",
	    reader: new Ext.data.JsonReader({
	    root: 'rows',
	    totalProperty: 'results'
	    }, [
	        'select',
	        'patid',
	        'patname',
	        'orddate',
	        'prescno',
	        'prescnoT',
	        'incidesc',
	        'qty',
		    'uomdesc',
		    'dosage',
		    'freq',
		    'spec',
		    'instruc',
		    'dura',
		    'form',
		    'doctor',
		    'remark',
		    'orditm',
		    'selectflag',
		    'dsprowid',
		    'pogid',
		    'packflag',
		    'barcode'
		    
		]),
	remoteSort: true
	});
     
	var orddetailgridcmPagingToolbar = new Ext.PagingToolbar({	
		store:orddetailgridds,
		pageSize:200,
		//��ʾ���½���Ϣ
		displayInfo:true,
		displayMsg:'��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
		prevText:"��һҳ",
		nextText:"��һҳ",
		refreshText:"ˢ��",
		lastText:"���ҳ",
		firstText:"��һҳ",
		beforePageText:"��ǰҳ",
		afterPageText:"��{0}ҳ",
		emptyMsg: "û������"
	});
 
 
	var orddetailgrid = new Ext.grid.GridPanel({
		stripeRows: true,
		region:'center',
		margins:'3 3 3 3', 
		autoScroll:true,
		id:'orddetailtbl',
		enableHdMenu : false,
		ds: orddetailgridds,
		cm: orddetailgridcm,
		enableColumnMove : false,
		bbar:orddetailgridcmPagingToolbar,
		trackMouseOver:'true',
		viewConfig:{
			forceFit:true,
			enableRowBody : true,
			getRowClass :function(record,rowIndex,rowParams,store){
				var cls="";
				if(record.data.packflag=="Y"){
					cls = 'x-grid-record-lightgreen';}
					return cls;
				}
		}
	});

	orddetailgrid.on('cellclick',OrddetailGridCellClick)
	orddetailgrid.on('headerclick', function(grid, columnIndex, e) { 
	if (columnIndex==0){
	selectAllRows();
	};
	});
 
	///��ʼ����
	var stdatef=new Ext.form.DateField ({
		width : 120,
		xtype: 'datefield',
		format:'j/m/Y' ,
		fieldLabel: '��ʼ����',
		name: 'startdt',
		id: 'startdt',
		invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
		value:new Date
	})

	///��ֹ����
	var enddatef=new Ext.form.DateField ({
		width : 120,
		format:'j/m/Y' ,
		fieldLabel: '��ֹ����',
		name: 'enddt',
		id: 'enddt',
		invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
		value:new Date
	})

	//���˵ǼǺŲ�ѯ����

	var patientField=new Ext.form.TextField({
		width:120, 
		id:"patientTxt", 
		fieldLabel:"�ǼǺ�" ,
		listeners: {
		specialkey: function (textfield, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				//FindOrdDetailData();
				FindCheckedPatInfo();
			}
		}
		}
	})
     
	///ƿǩ����
	var BarcodeField=new Ext.form.TextField({
		width : 120, 
		id:"BarcodeTxt", 
		fieldLabel:"ƿǩ����" ,
		listeners: {
			specialkey: function (textfield, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var barcode=Ext.getCmp('BarcodeTxt').getValue();
					SetLabelStat(barcode);
					}
			},
			afterrender : function (textfield, e) {
				Ext.getCmp('BarcodeTxt').focus(true,true); 
			},

			render : function SetTip(textfield, e){
				this.getEl().dom.setAttribute("ext:qtip", "ɨ��ǰȷ�Ͻ�����ƶ�������!");
			}
		}
	})
     
	var DatePanel = new Ext.Panel({
		title:'��ʿ����',
		frame : true,
		margins:'1 0 0 0', 
		bbar:[RefreshButton,"-",OkButton],
		labelWidth:80,
		region:'center',
		items : [{
				layout : "column",
				items : [{
				            labelAlign : 'right',
							columnWidth : .2,
							layout : "form",
							items : [ PhaLocSelecter   ]
						 }, {
						    labelAlign : 'right',
							columnWidth : .2,
							layout : "form",
							items : [  stdatef   ]
				    
					
					        },{
			        
					        labelAlign : 'right',
							columnWidth : .2,
							layout : "form",
							items : [  BarcodeField ]
					
					        },{
			        
					        labelAlign : 'right',
							columnWidth : .4,
							layout : "form",
							items : []
					
					        } ]
					   
					   
					   
					   
				},{
						layout : "column",
						items : [{ 
						            labelAlign : 'right',
									columnWidth : .2,
									layout : "form",
									items : [  patientField  ]
								 },{
			        
					        labelAlign : 'right',
							columnWidth : .2,
							layout : "form",
							items : [  enddatef ]
					
					        },{
			        
					        labelAlign : 'right',
							columnWidth : .2,
							layout : "form",
							items : [  OnlyAdtChkbox ]
					
					        }
			        
					        ]
				  },{
						layout : "column",
						items : [{ 
						            labelAlign : 'right',
									columnWidth : .4,
									layout : "form",
									items : []
								 }]
				  }
				]
	})
    
	var centerform = new Ext.Panel({
		id:'centerform',
		region: 'center',
		margins:'1 0 0 0', 
		frame : false,
		layout:{  
		        type:'vbox', 
		        align: 'stretch',  
		        pack: 'start'  
		}, 
		items: [{           
		 	  flex: 2,
		 	  layout:'border',
		 	  items:[DatePanel]  
		 	 },{           
		 	  flex: 8,
		 	  layout:'border',
		 	  items:[orddetailgrid]  
		 	 }]
	});
	
	var port = new Ext.Viewport({
		layout : 'border',
		items : [centerform]
	});

	 ///////////////////////Event//////////////////	
	 ///����Ĭ�Ͽ���
	function setDefaultLoc()
	{
		if (phlocInfo.getTotalCount() > 0)
		{
			PhaLocSelecter.setValue(phlocInfo.getAt(0).data.rowId);
		}
	}	
			
	///��������б�ѡ������
	function GetListInput()
	{
		sdate=Ext.getCmp("startdt").getRawValue().toString();
		edate=Ext.getCmp("enddt").getRawValue().toString();
		phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
		patid=Ext.getCmp('patientTxt').getValue();
		onlyadt=Ext.getCmp('OnlyAdtChk').getValue();
		barcodetxt=Ext.getCmp('BarcodeTxt').getValue();
		var listinputstr=sdate+"^"+edate+"^"+phlocdr+"^"+patid+"^"+onlyadt+"^"+barcodetxt;
		return listinputstr
	}		

	///������Һ������Ϣ		
	function FindOrdDetailData()
	{
		var RegNo=Ext.getCmp('patientTxt').getValue();
		var RegNo=GetWholePatID(RegNo);
		var input=GetListInput();
		waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ�������,���Ժ�..." }); 
		waitMask.show();  
		orddetailgridds.removeAll();
		orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindOrdDetailData&RegNo='+RegNo+"&Input="+input });		
		orddetailgridds.load({
		params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize},
		callback: function(r, options, success){
			waitMask.hide();
			if (success==false){
				Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
			}
			}
		});
	}				
			
	///��0���˵ǼǺ�
	function GetWholePatID(RegNo)
	{    
		if(RegNo==""){
			return RegNo;
		}
		var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetPatRegNoLen");
		var plen=RegNo.length;
		if (plen>patLen){
			Ext.Msg.show({title:'����',msg:'����ǼǺŴ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return;
		}
		for (i=1;i<=patLen-plen;i++)
		{
			RegNo="0"+RegNo;  
		}
		Ext.getCmp('patientTxt').setValue(RegNo);
		return RegNo;
	}
	
	//ִ�н���״̬			
	function SaveSure()
	{
		var view = orddetailgrid.getView();
		var rows=view.getRows().length-1 ;
		if (rows==-1) return;
		var user=session['LOGON.USERID'] ;
		var h=0;  //ѡ���־
		var m=0;
		var dspstr="";printno="";
		for (i=0;i<=rows;i++)
		{
			var cellselected=document.getElementById("TSelectz"+i).checked
			if (!(cellselected))  continue;
			h=h+1;
			var record = orddetailgrid.getStore().getAt(i);
			var prescno =record.data.prescno;
			var dsprowid =record.data.dsprowid;
			var selectflag =record.data.selectflag ;
			if (selectflag!=""){
				var pogid =record.data.pogid;
				var ret=tkMakeServerCall("web.DHCSTPIVAOUTRECSURE", "SaveRecSure",pogid,user);
				if(ret=="-1"){alert("��һ״̬�ǽ���״̬��");}
				if(ret=="-13"){alert("�ѽ��գ������ظ����գ�");}
				if(ret=="-14"){alert("����PIVAʧ�ܣ�");}
			}
		}	
 
		 FindCheckedPatInfo(); //������֮�����¼��� 
	}

	function FindCheckedPatInfo()
	{
		document.getElementById("TDSelectOrdItm").checked=false;
		var RegNo=Ext.getCmp('patientTxt').getValue();
		var RegNo=GetWholePatID(RegNo);
		var sdate=Ext.getCmp("startdt").getRawValue().toString();
		var edate=Ext.getCmp("enddt").getRawValue().toString();
		var phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
		if (sdate=="") {Ext.Msg.show({title:'ע��',msg:'��ʼ���ڲ���Ϊ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (edate=="") {Ext.Msg.show({title:'ע��',msg:'�������ڲ���Ϊ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (phlocdr=="") {Ext.Msg.show({title:'ע��',msg:'���Ҳ���Ϊ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		
		var input=GetListInput();
		waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ�������,���Ժ�..." }); 
		waitMask.show();  
		ClearDocument();
		orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindCheckedPatInfo&RegNo='+RegNo+"&Input="+input });		
		orddetailgridds.load({
			params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize},
			callback: function(r, options, success){
				waitMask.hide();
				if (success==false){
					Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				}
			}
		});
	}

	//���
	function ClearDocument()
	{
		orddetailgridds.removeAll();
	}
	    	//�е����¼�
	function OrddetailGridCellClick(grid, rowIndex, columnIndex, e)
	{
		if (columnIndex==0){
			var newmoeori="";
			var record = orddetailgrid.getStore().getAt(rowIndex);
			var moeori =record.data.selectflag ;
			var mprescnoT =record.data.prescnoT ;

			var view = orddetailgrid.getView();
			var store = orddetailgrid.getStore();

			if (document.getElementById("TSelectz"+rowIndex).checked)
			{
				for (i=0;i<=view.getRows().length-1;i++)
				{
					if(document.getElementById("TSelectz"+i).checked){       
						//rsm.deselectRow(i)  
					}
					else
					{ 
						var record = orddetailgrid.getStore().getAt(i);
						var newmoeori =record.data.selectflag ;
						var newprescnoT =record.data.prescnoT ;

						if ((newmoeori==moeori)||(newprescnoT==mprescnoT)){
							document.getElementById("TSelectz"+i).checked=true;
						}
						else
						{
							if (i>rowIndex) break;
						}
					}
				}
			}else{
				for (i=0;i<=view.getRows().length-1;i++)
				{
					if(document.getElementById("TSelectz"+i).checked)
					{       
						var record = orddetailgrid.getStore().getAt(i);
						var newmoeori =record.data.selectflag ;
						var newprescnoT =record.data.prescnoT ;
						if ((newmoeori==moeori)||(newprescnoT==mprescnoT)){
							document.getElementById("TSelectz"+i).checked=false;
						}
						else
						{
							if (i>rowIndex) break;
						}
					}
				}
			}
		}
	}
			
	//ȫѡ/ȫ���¼�
	function selectAllRows()
	{
		var cellselected=document.getElementById("TDSelectOrdItm").checked ;
		var view = orddetailgrid.getView();
		var rows=view.getRows().length ;
		if (rows==0) return;
		for (i=0;i<=rows-1;i++)
		{
			if (cellselected){
				document.getElementById("TSelectz"+i).checked=true;
			}else{
				document.getElementById("TSelectz"+i).checked=false;
			}
		}
	}
  
	function SetLabelStat(LabelCode)
	{
		var user=session['LOGON.USERID'];
		var view = orddetailgrid.getView();
		var rows=view.getRows().length;
		if (rows==0) return;
		var h=0;
		for (var i=0;i<rows;i++)
		{
			var record = orddetailgrid.getStore().getAt(i);
			var prescno =record.data.prescno;
			var pogid =record.data.pogid;
			var barcode =record.data.barcode;
			if(LabelCode==barcode)
			{
				if (prescno!="")
				{
					var pogid =record.data.pogid;
					var ret=tkMakeServerCall("web.DHCSTPIVAOUTRECSURE", "SaveRecSure",pogid,user);
					if(ret=="-1"){
						Ext.Msg.alert("��ʾ","��һ״̬�ǽ���״̬");
						}
					else if(ret=="-14"){
						Ext.Msg.alert("��ʾ","����PIVAʧ��");
						}
						
					if(ret!="0"){break;}
				}
				//orddetailgrid.getView().addRowClass(i,'x-grid-record-red');
				orddetailgrid.getView().getRow(i).style.backgroundColor='#FF0000';
				h++;
			}
			if((LabelCode!=barcode)&(h!=0)) break;  //�ҵ�ɨ��ǩ֮���˳�
		}
		if(h==0){Ext.Msg.alert("��ʾ","δ�ҵ�ƥ����");}
	}
			
});