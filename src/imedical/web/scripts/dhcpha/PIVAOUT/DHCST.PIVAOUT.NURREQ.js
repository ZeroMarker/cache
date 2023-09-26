///Creator:BianShuai
///CreateDate:2013-10-01
///��ʿ��Һ����

var unitsUrl = 'DHCST.PIVAOUT.SAVEURL.csp';
function showWin(value)
{
	var index=value.indexOf("^");
        if  (index>=0) {
           var tmparr=value.split("^");
	   var dodis=tmparr[0];

        }else{
           var dodis=value;
        }
	OpenShowStatusWin("",dodis);
}

function showPatInfoWin(value)
{
	var index=value.indexOf("^");
        if  (index>=0) {
           var tmparr=value.split("^");
	   var dodis=tmparr[0];

        }else{
           var dodis=value;
        }

	OpenShowPatInfoWin(dodis);
}

Ext.onReady(function(){
	///��ģ��
	Ext.QuickTips.init();// ������Ϣ��ʾ
	Ext.Ajax.timeout = 900000;
	
	//����Ĭ�Ͽ���
	function setDefaultLoc()
	{
		
		if (phlocInfo.getTotalCount() > 0){
			PhaLocSelecter.setValue(phlocInfo.getAt(0).data.rowId);
		}
	}

	//����Ĭ�Ͽ�����
	function setDefaultCardType()
	{
		if (CardTypeDs.getTotalCount() > 0){
			var cardcount=CardTypeDs.getTotalCount();
			for (i=0;i<cardcount;i++)
			{
				var tmpcardvalue=CardTypeDs.getAt(i).data.value;
				var tmpcardarr=tmpcardvalue.split("^");
				var defaultflag=tmpcardarr[8];
				if (defaultflag=="Y")
				{
					CardTypeComBo.setValue(CardTypeDs.getAt(i).data.value);
				}
			}
			if (CardTypeComBo.getValue()=="")
			{
				CardTypeComBo.setValue(CardTypeDs.getAt(0).data.value);
			}
			
		}
	}

	///ҩ�����ҿؼ�
	var phlocInfo = new Ext.data.Store({
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			totalProperty:"results",root:'rows',id: 'rowId'},['phlocdesc','rowId'])
	});

	phlocInfo.on('beforeload',function(ds,o){
		var grpdr=session['LOGON.GROUPID'] ;		
		ds.proxy = new Ext.data.HttpProxy({
			url:unitsUrl+'?action=GetStockPhlocDs&GrpDr='+grpdr, method:'GET'});
		}
	);

	//ȡ������
	function GetCardTypeRowId() 
	{
		var CardTypeRowId = "";
		var CardTypeValue = CardTypeComBo.getValue();
		if (CardTypeValue != "")
		{
			var CardTypeArr = CardTypeValue.split("^");
			CardTypeRowId = CardTypeArr[0];
		}
		return CardTypeRowId;
	}

	///ҩ������
	var PhaLocSelecter = new Ext.form.ComboBox({
		id:'PhaLocSelecter',
		fieldLabel:'ҩ������',
		store: phlocInfo,
		valueField:'rowId',
		displayField:'phlocdesc',
		width : 180,
		listWidth:250,
		emptyText:'ѡ��ҩ������...',
		allowBlank: false,
		name:'PhaLocSelecter',
		mode: 'local'
	});
	

	//����Ĭ�Ͽ���
	phlocInfo.on("load",function(store,record,opts){ setDefaultLoc();});

	//���ۿ���
	var EmAreaInfo = new Ext.data.Store({
		autoLoad: false,
		proxy:"",
		reader: new Ext.data.JsonReader({
			totalProperty:"results",root:'rows',id: 'rowId'},['locdesc','rowId'])
	});

	EmAreaInfo.on('beforeload',function(ds,o){
		ds.proxy = new Ext.data.HttpProxy({
			url:unitsUrl+'?action=GetGetLgAreaDs', method:'GET'});
		}
	);

	///����
	var EmAreaSelecter = new Ext.form.ComboBox({
		id:'EmAreaSelecter',
		fieldLabel:'������',
		store: EmAreaInfo,
		valueField:'rowId',
		displayField:'locdesc',
		width : 180,
		emptyText:'ѡ�����ۿ���...',
		//allowBlank: false,
		name:'EmAreaSelecter',
		mode: 'local'
	});
	
	EmAreaInfo.load();
	//��ʼ����
	var StartDate=new Ext.form.DateField ({
		width : 120,
		format:'j/m/Y' ,
		fieldLabel: '��ʼ����',
		name: 'startdt',
		id: 'startdt',
		invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
		value:new Date
	})	

	///��ֹ����
	var EndDate=new Ext.form.DateField ({
		width : 120,
		format:'j/m/Y' ,
		fieldLabel: '��ֹ����',
		name: 'enddt',
		id: 'enddt',
		invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
		value:new Date
	})

	//��ѯ
	var RefreshButton = new Ext.Button({
		width : 70,
		id:"RefreshBtn",
		text: '��ѯ',
		icon:"../scripts/dhcpha/img/find.gif",
		listeners:{
			"click":function(){  
			 	var RegNo=GetWholePatID(Ext.getCmp('patientTxt').getValue());
				FindPatOrdDetailInfo(RegNo);
			}   
		}
	})

	//����
	var  ReadCardButton = new Ext.Button({
		width : 70,
		id:"ReadCardBtn",
		text: '����',
		icon:"../scripts/dhcpha/img/menuopera.gif",
		listeners:{
			"click":function(){   
				BtnReadCardHandler();
			}   
		}
	})

	///����
	var OkButton = new Ext.Button({
		width : 65,
		id:"OkButton",
		text: '����',
		icon:"../scripts/dhcpha/img/accept.png",
		listeners:{
			"click":function(){   
				SaveRequest();
			}   
		}
	})
	///�޸Ĵ��״̬
	var ChangeButton = new Ext.Button({
		width : 65,
		id:"ChangeButton",
		text: '�޸Ĵ��״̬',
		icon:"../scripts/dhcpha/img/accept.png",
		listeners:{
			"click":function(){   
				ChangeRequestPack();
			}   
		}
	})
	//������
	var OnlyReqChkbox=new Ext.form.Checkbox({
		boxLabel : '������',
		id : 'OnlyReqChk',
		inputValue : '1',
		checked : false,
		listeners:{
			'check': function(){
				//document.getElementById("TDSelectOrdItm").disabled="true";
			}
		}
	})
	//������
	var OnlyPivaAuditbox=new Ext.form.Checkbox({
		boxLabel : '�������',
		id : 'OnlyPivaAudit',
		inputValue : '1',
		checked : false,
		listeners:{
			'check': function(){
				//document.getElementById("TDSelectOrdItm").disabled="true";
			}
		}
	})
	///������
	CardTypeStore =eval("(" + CardTypeArray + ')');

	///������Store
	var CardTypeDs= new Ext.data.ArrayStore({
		autoDestroy : true,
		fields : ['desc', 'value'],
		data : CardTypeStore
	})

	///������
	var CardTypeComBo = new Ext.form.ComboBox({
		fieldLabel:'������',
		width : 120,
		typeAhead : true,
		height : 100,
		triggerAction :'all',
		store: CardTypeDs,
		mode: 'local',
		valueField : 'value',
		displayField : 'desc',
		listeners : {
			//change: LocChangeHandler
		}
	});

	setDefaultCardType();

	function selectbox(re,params,record,rowIndex){
		//var disableflag="";
		//var reqflag=record.data.requser;
		//if(reqflag!=""){
		//disableflag="disabled=true";}
		return '<input type="checkbox" id="TSelectz'+rowIndex+'" name="TSelectz'+rowIndex+'"  value="'+re+'"  >';
	}

	function packflagbox(re,params,record,rowIndex){

		var ch=record.get("pack")
		if (ch=="Y")
		{
			var chk="true"
			return '<input type="checkbox" id="Tpackflagz'+rowIndex+'" name="Tpackflagz'+rowIndex+'" checked="'+chk+'" value="'+re+'"  >';
		}else{
			var chk="false"
			return '<input type="checkbox" id="Tpackflagz'+rowIndex+'" name="Tpackflagz'+rowIndex+'" value="'+re+'"  >';
		}

		
	} 

	function showUrl(value, cellmeta, record, rowIndex, colIndex, store) {
		return "<a href='javascript:showWin(\""+record.get("dsprowid")+"\")'/>"+value+"</a>";
	}

	function showPatInfoUrl(value, cellmeta, record, rowIndex, colIndex, store) {
		return "<a href='javascript:showPatInfoWin(\""+record.get("dsprowid")+"\")'/>"+value+"</a>";
	}

	///�ǼǺ�
	var PatRegNoField=new Ext.form.TextField({
		width:120, 
		id:"patientTxt", 
		fieldLabel:"�ǼǺ�" ,
		listeners: {
			specialkey: function (textfield, e) {
				if (e.getKey() == Ext.EventObject.ENTER){
					var RegNo=GetWholePatID(Ext.getCmp('patientTxt').getValue());
					FindPatOrdDetailInfo(RegNo);
				}
			}
		}
	})

	///��������Դ
	var PatReqDetailGridDr = new Ext.data.Store({
		proxy:"",
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results'
		}, [
			'select',
			'packflag',
			'patno',
			'patname',
			'adm',
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
			'selectflag',
			'requser',
			'reqdate',
			'dsprowid',
			'psname',
			'pack'
		]),
		// turn on remote sorting
		remoteSort: true
	});

	///Grid��ģ��
	var PatReqDetailGridCm = new Ext.grid.ColumnModel([
		{
			header:'<input type="checkbox" id="TDSelectOrdItm" >',
			width:40,
			menuDisabled:true,
			dataIndex:'select',
			renderer:selectbox
		},{
			header:'���',
			width:40,
			menuDisabled:true,
			dataIndex:'packflag',
			renderer:packflagbox
		},{
			header:'�ǼǺ�',
			dataIndex:'patno',
			width: 80,
			menuDisabled :'false',
			renderer:showPatInfoUrl
		},{
			header:'����',
			dataIndex:'patname',
			width: 60,
			menuDisabled :'false'
		},{
			header:'adm',
			dataIndex:'adm',
			width: 60,
			menuDisabled :'false',
			hidden:true
		},{
			header:'��ҩ����',
			dataIndex:'orddate',
			width:140
		},{
			header:'������',
			dataIndex:'prescno',
			width:100,
			renderer:showUrl
		},{
			header:'������hide',
			dataIndex:'prescnoT',
			width:85,
			renderer:showUrl,
			hidden:true
		},{
			header:'ҩƷ����',
			dataIndex:'incidesc',
			width:200
		},{
			header:'����',
			dataIndex:'qty',
			width:40
		},{
			header:'��λ',
			dataIndex:'uomdesc',
			width:60
		},{
			header:'����',
			dataIndex:'dosage',
			width:80
		},{
			header:'Ƶ��',
			dataIndex:'freq',
			width:40
		},{
			header:'���',
			dataIndex:'spec',
			width:80
		},{
			header:'�÷�',
			dataIndex:'instruc',
			width:80
		},{
			header:'��ҩ�Ƴ�',
			dataIndex:'dura',
			width:60
		},{
			header:'����',
			dataIndex:'form',
			width:100
		},{
			header:'ҽ��',
			dataIndex:'doctor',
			width:60
		},{
			header:'ҽ����ע',
			dataIndex:'remark',
			width:60
		},{
			header:'selectflag',
			dataIndex:'selectflag',
			width:60
			//hidden:true
		},{
			header:'������',
			dataIndex:'requser',
			width:60
		},{
			header:'��������',
			dataIndex:'reqdate',
			width:135
		},{
			header:'dsprowid',
			dataIndex:'dsprowid',
			width:60
		},{
			header:'��ǰ״̬',
			dataIndex:'psname',
			width:80
		},{
			header:'�����־',
			dataIndex:'pack',
			width:60
		}
				
	]);

	///��ѯ����Panel
	var ConditionForm = new Ext.form.FormPanel({
		autoScroll:true,
		labelAlign : 'right',
		frame : true,
		bodyStyle : 'padding:5px;', 
		labelWidth:'60px',
	    bbar:[RefreshButton,'-',OkButton,'-',ReadCardButton,'-',ChangeButton],
		items : [{
			layout : "column",
			items : [{
				labelAlign : 'right',
				columnWidth :.2,
				layout : "form",
				items : [StartDate]
				},{ 
				labelAlign : 'right',
				columnWidth : .25,
				layout : "form",
				items : [PhaLocSelecter]
			},{ 
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : [PatRegNoField]
			},{ 
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : [OnlyPivaAuditbox]
			}]
		},{
			layout : "column",
			items : [{
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : [EndDate]
				},{ 
				labelAlign : 'right',
				columnWidth : .25,
				layout : "form",
				items : [EmAreaSelecter]
			},{ 
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : [CardTypeComBo]
			},{ 
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : [OnlyReqChkbox]
			}]
		}]
	})

	var PatReqDetailGridCmPagingToolbar = new Ext.PagingToolbar({	
		store:PatReqDetailGridDr,
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

	///Grid
	var PatReqDetailGrid = new Ext.grid.EditorGridPanel({
		stripeRows: true,
		region:'center',
		margins:'0 0 3 3', 
		autoScroll:true,
		id:'orddetailtbl',
		enableHdMenu : false,
		ds:PatReqDetailGridDr,
		cm:PatReqDetailGridCm,
		enableColumnMove : false,
		clicksToEdit: 1,
		trackMouseOver:'true',
		bbar:PatReqDetailGridCmPagingToolbar,
		listeners : {
			'rowdblclick':function(){}
		}  
	});

	//����
	function BtnReadCardHandler()
	{
		var CardTypeRowId = GetCardTypeRowId();
		var myoptval = CardTypeComBo.getValue();
		var myrtn;
		myrtn = DHCACC_GetAccInfo(CardTypeRowId, myoptval);
		if (myrtn==-200){ //����Ч
			Ext.Msg.show({title:'����',msg:'����Ч!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return;
		}

		var myary = myrtn.split("^");
		var rtn = myary[0];

		switch (rtn) {
			case "0":
				//����Ч
				PatientID = myary[4];
				var PatientNo = myary[5];
				var CardNo = myary[1]
				var NewCardTypeRowId = myary[8];
				Ext.getCmp('patientTxt').setValue(PatientNo);
				FindWardList();
				break;
			case "-200":
				//����Ч
				Ext.Msg.show({title:'����',msg:'����Ч!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				break;
			case "-201":
				//�ֽ�
				PatientID = myary[4];
				var PatientNo = myary[5];
				var CardNo = myary[1]
				var NewCardTypeRowId = myary[8];
				Ext.getCmp('patientTxt').setValue(PatientNo);
				FindWardList();
				break;
			default:
		}

	}

	///��0���˵ǼǺ�
	function GetWholePatID(RegNo)
	{    
		if (RegNo=="") {
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

	///������������
	function SaveRequest()
	{
		var view = PatReqDetailGrid.getView();
		var rows=view.getRows().length-1 ;
		if (rows==-1) return;
	if(CheckDataBeforeSave()==true){
		for (i=0;i<=rows;i++)
		{
			var cellselected=document.getElementById("TSelectz"+i).checked
			if (cellselected){
				var record = PatReqDetailGrid.getStore().getAt(i);
				var dsprowid =record.data.dsprowid ;
				if (document.getElementById("Tpackflagz"+i).checked){
					packflag="Y" ;
				}else{
					packflag="N" ;
					}
				SaveData(i,dsprowid,packflag);
			}
		}
	 }
	}
	
		///�޸Ĵ��״̬,���ѡ����
	function ChangeRequestPack()
	{
		var view = PatReqDetailGrid.getView();
		var rows=view.getRows().length-1 ;
		if (rows==-1) return;
		for (i=0;i<=rows;i++)
		{
			var cellselected=document.getElementById("TSelectz"+i).checked
			if (cellselected){
				var record = PatReqDetailGrid.getStore().getAt(i);
				var dsprowid =record.data.dsprowid ;
				var requeststat=record.data.psname;
				if (requeststat=="������"){
					Ext.Msg.alert("��ʾ","��"+(i+1)+"�з�������״̬!�޷��޸Ĵ��״̬!");
					return	
				}
				if (document.getElementById("Tpackflagz"+i).checked){
					packflag="Y" ;
				}else{
					packflag="N" ;
					}
				UpdatePackData(i,dsprowid,packflag);
			}
		}
	}
	///���ݿ⽻��
	function UpdatePackData(i,dsprowid,packflag)
	{
		var requesr=session['LOGON.USERID'] ;
		var ret=tkMakeServerCall("web.DHCSTPIVAOUTDISPREQ", "UpdateRequestPack",dsprowid,packflag,requesr);
		if (ret>0){
			var patreqrecord = PatReqDetailGrid.getStore().getAt(i);
			patreqrecord.set("pack",packflag);
			PatReqDetailGrid.getView().getRow(i).style.backgroundColor='#fe7287';
			
		}
		else if(ret==-1){
			Ext.Msg.alert("��ʾ","��"+(i+1)+"����δ���룬�����޸Ĵ��״̬!");
			}
		else if(ret==-3){
			Ext.Msg.alert("��ʾ","��"+(i+1)+"�в���������״̬�������޸Ĵ��״̬!");
			}
		else if(ret==-5){
			///������Աδ�޸Ĵ��״̬�������,��ִ�����в��� bianshuai 2015-12-07
			Ext.Msg.alert("��ʾ","<font style='color:red;font-weight:bold;font-size:20px;'>��"+(i+1)+"��\"���״̬\"δ�����仯,��ȷ���޸�״̬������!</font>");
			}
		else{
			Ext.Msg.alert("��ʾ","����ʧ��!����ֵ:"+ret);
		}
	} 

function CheckDataBeforeSave()
 {
           var view = PatReqDetailGrid.getView();
  	       var rows=view.getRows().length ;
  	       var retvalue=""
  	       var dsprowidstr=""
	 	       for (i=0;i<=rows-1;i++)
      	       { 
      	        var cellselected=document.getElementById("TSelectz"+i).checked
      	   	   	if (cellselected){
	      	      var record = PatReqDetailGrid.getStore().getAt(i);
                  var prescno =record.data.prescno;
                  var dsprowid =record.data.dsprowid;
                  if (dsprowidstr==""){dsprowidstr=dsprowid;}
                  else {dsprowidstr=dsprowidstr+"^"+dsprowid;}
      	   	   	}
      	      }
      	  if (dsprowidstr!="")  {var retvalue=tkMakeServerCall("web.DHCSTPIVAOUTDISPREQ", "CheckBillStatus",dsprowidstr);}  
      	  if (retvalue!="") { 
      	    Ext.Msg.show({title:'����',msg:'����'+retvalue+'Ѻ���㣬��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	     return false;
      	    }   

	return true;  	  
	 
 }  

	///���ݿ⽻��
	function SaveData(i,dsprowid,packflag)
	{
		var requesr=session['LOGON.USERID'] ;
		var ret=tkMakeServerCall("web.DHCSTPIVAOUTDISPREQ", "SaveRequest",dsprowid,packflag,requesr);
		if (ret>0){
			var patreqrecord = PatReqDetailGrid.getStore().getAt(i);
			patreqrecord.set("psname","������");
			patreqrecord.set("requser",session['LOGON.USERNAME']);
			patreqrecord.set("reqdate",getCurrentDateTime());
			patreqrecord.set("pack",packflag);
			PatReqDetailGrid.getView().getRow(i).style.backgroundColor='#fe7287';
		}
		else if(ret==-1){
			Ext.Msg.alert("��ʾ","��������������ظ�����");
			}
		else{
			Ext.Msg.alert("��ʾ","����ʧ��!����ֵ:"+ret);
		}
	} 

	function FindPatOrdDetailInfo(RegNo)
	{
	document.getElementById("TDSelectOrdItm").checked=false
		PatReqDetailGridDr.removeAll(); ///����
	  	    var sdate=Ext.getCmp("startdt").getRawValue().toString();
	        var edate=Ext.getCmp("enddt").getRawValue().toString();
	        var phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
		   if (sdate=="") {Ext.Msg.show({title:'ע��',msg:'��ʼ���ڲ���Ϊ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (edate=="") {Ext.Msg.show({title:'ע��',msg:'�������ڲ���Ϊ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (phlocdr=="") {Ext.Msg.show({title:'ע��',msg:'���Ҳ���Ϊ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
				     
		
		var input=GetListInput();
		waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ�������,���Ժ�..." }); 
		waitMask.show();

		PatReqDetailGridDr.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryWaitReqPatInfo&RegNo='+RegNo+"&Input="+input });		
		PatReqDetailGridDr.load({
			params:{start:0, limit:PatReqDetailGridCmPagingToolbar.pageSize},
			callback: function(r, options, success){
				waitMask.hide();
				if (success==false){
					Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				}
			}
		});
	}

	//���ز�ѯ����
	function GetListInput()
	{
		var sdate=Ext.getCmp("startdt").getRawValue().toString();
		var edate=Ext.getCmp("enddt").getRawValue().toString();
		var phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
		var onlyreq=Ext.getCmp('OnlyReqChk').getValue();
		var emlocdr=Ext.getCmp('EmAreaSelecter').getValue();
		var pivaaudit=Ext.getCmp('OnlyPivaAudit').getValue();
		var listinputstr=sdate+"^"+edate+"^"+phlocdr+"^"+onlyreq+"^"+emlocdr+"^"+pivaaudit;
		return listinputstr;
	}

	///��������嵥���¼�
	PatReqDetailGrid.on('cellclick',OrddetailGridCellClick);
	PatReqDetailGrid.on('headerclick', function(grid, columnIndex, e){
		if (columnIndex==0){
			SelectAllRows();
		};
	});

	//ȫѡ/ȫ���¼� bianshuai
	function SelectAllRows()
	{
		var selectflag=document.getElementById("TDSelectOrdItm").checked ;
		var view = PatReqDetailGrid.getView();
		var rows=view.getRows().length ;
		if (rows==0) return;
		for (var i=0;i<=rows-1;i++)
		{
			document.getElementById("TSelectz"+i).checked=selectflag;
		}
	}

	//�����е����¼� bianshuai
	function OrddetailGridCellClick(grid, rowIndex, columnIndex, e)
	{
		var IndexID="";
		if(columnIndex==0)
		{
			IndexID="TSelectz";
		}
		else if(columnIndex==1)
		{
			IndexID="Tpackflagz";
		}
		else{return;}

		var record = PatReqDetailGrid.getStore().getAt(rowIndex);
		var tmpmdisp =record.data.selectflag ;
		var tmpprescnoT =record.data.prescnoT ;

		var view = PatReqDetailGrid.getView();
		var store = PatReqDetailGrid.getStore();
		var checkflag=document.getElementById(IndexID+rowIndex).checked;

		for (var i=0;i<=view.getRows().length-1;i++)    //i=1
		{
			var record = PatReqDetailGrid.getStore().getAt(i);
			var disp =record.data.selectflag ; 
			var prescnoT =record.data.prescnoT ; 
			if ((tmpmdisp==disp)||(tmpprescnoT==prescnoT)){
				document.getElementById(IndexID+i).checked=checkflag;
			}
			else
			{
				if (i>rowIndex) break;
			}
		}
	}

	function getCurrentDateTime()
	{
	
		var d=new Date();
		var pt="";
		var c=":";	
		pt+=d.getFullYear()+"-";	
		pt+=(d.getMonth()+1)+"-";
		pt+=d.getDate();
		pt+=" "
		pt+=d.getHours()+c;
		pt+=d.getMinutes()+c;
		pt+=d.getSeconds();
		return pt
	}
	var ConditionPanel = new Ext.Panel({
		title:'��ʿ����',
		activeTab:0,
		region:'north',
		height:150,
		layout:'fit',
		items:[ConditionForm]                                
	});

	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[ConditionPanel,PatReqDetailGrid]//,
		//renderTo:'mainPanel'
	});
});