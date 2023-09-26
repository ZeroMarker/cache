//dhcpha.outpha.prescfy.js
//���﷢ҩ����
//Creator:liangjiaquan 
//CreatDate:2016-03-01

Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var htmlstr='<div <span style="font-size:12pt;font-family:���Ŀ���;">'+'��û��ѡ�д�����'+'</span> </div>';
	var PhLocDesc;
	var PhWinDesc;
	var FyUserName;
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.Ajax.timeout = 900000;
	
	var Url='dhcpha.outpha.prescfy.action.csp?';
	
	var title=GetPhTitle();
	if(title=="false"){Ext.Msg.show({title:'����',msg:'���س��������µ�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});return;}
	
	//���������б�
	var PatListStore=new Ext.data.JsonStore({
		auroDestroy:true,
		url:Url+"actiontype=PatListQuery",
		sotreId:'PatListStore',
		root:'rows',
		totalProperty:'results',
		idProperty:'PatID',
		fields:['PatID','PatNo','PatName','Staus']
	});
	
	// ͬ����ť
	var FindBT = new Ext.Toolbar.Button({
		id : "FindBT",
		text : 'ͬ��',
		tooltip : '���ͬ������ҩ�б�',
		width : 70,
		height : 30,
		//iconCls : 'page_find',
		iconCls : 'page_find',
		handler : function() {
			QueryPatList();  //ˢ���б�
		}
	});
	
	// �кŰ�ť
	var CallBT = new Ext.Toolbar.Button({
		id : "CallBT",
		text : '�к�',
		tooltip : '����к�',
		width : 70,
		height : 30,
		//iconCls : 'page_find',
		iconCls : 'page_find',
		handler : function() {
			//QueryPatList();  //ˢ���б�
			CallVioce();     //�к�
		}
	});
	
	// ���Ű�ť
	var DelayBT = new Ext.Toolbar.Button({
		id : "DelayBT",
		text : '����',
		tooltip : '�������',
		width : 70,
		height : 30,
		//iconCls : 'page_find',
		iconCls : 'page_find',
		handler : function() {
			Delay()
			QueryPatList();  //ˢ���б�
		}
	});
	
	//�Զ�ˢ��
    var AutoFindChk=new Ext.form.Checkbox({
		boxLabel : '�Զ�ˢ��',
		id : 'AutoFindChk',
		inputValue : '1',
		checked : true,
		listeners:{
			'check': function(){
				if (Ext.getCmp("AutoFindChk").getValue())
				{
					StartAutoLoad();
				}
				else{
					StopAutoLoad();
				}
			}
		}
	})
	var patcm=new Ext.grid.ColumnModel([{
			header:'Rowid',
			dataIndex:'PatID',
			width:50,
			align:'left',
			hidden:true
		},{
			header:'����',
			dataIndex:'PatName',
			width:100,
			align:'left'
		},{
			header:'�ǼǺ�',
			dataIndex:'PatNo',
			width:80,
			align:'left'
		},{
			header:'Staus',
			dataIndex:'Staus',
			width:100,
			align:'left',
			hidden:true
		}])
	
	var PatListGrid=new Ext.grid.GridPanel({
		id:'PatListGrid',
		//title:'<span style="color:red">'+'���������б�'+'</span>',
		store:PatListStore,
		//collapsible:true,
		tbar:[FindBT,'-',AutoFindChk],   //[CallBT,'-',DelayBT],
		cm:patcm,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		autoScroll:true,
		viewConfig : {
			getRowClass: function(record, rowIndex,rowParams,store){
				var flag=record.get('Staus');
				if(flag=="1"){return 'classPurple'}   //����
				else if(flag=="2") {return 'classOrange'}   //����
				else {return 'classGrassGreen'}   //�ȴ���ҩ
			}
		}
	})
	
	patcm.setRenderer(1, getColor);   //�������������С
	
	PatListGrid.addListener('rowclick',function(grid,rowindex,e){
		
		var rowData=PatListGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			//Msg.info("warning", "��ѡ����Ҫ��ҩ�Ĵ���!");
			return;
		}
		var PatNo=rowData.get("PatNo");
		Ext.getCmp("PatNo").setValue(PatNo);
		Query();
		
	});
	
	
	
	// ��ʼ����
	var stdatef=new Ext.form.DateField ({
		width : 120,
		xtype: 'datefield',
		format:'j/m/Y' ,
		fieldLabel: '��ʼ����',
		name: 'startdt',
		id: 'startdt',
		invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
		value:new Date().add(Date.DAY, -1)
	})
	
	
	//��ֹ����
	var enddatef=new Ext.form.DateField ({
		width : 120,
		format:'j/m/Y' ,
		fieldLabel: '��ֹ����',
		name: 'enddt',
		id: 'enddt',
		invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
		value:new Date().add(Date.DAY, 1)
	})
	
	//�ǼǺ�
	var PatNo = new Ext.form.TextField({
		fieldLabel : '�ǼǺ�',
		id : 'PatNo',
		name : 'PatNo',
		//anchor : '90%',
		width : 120,
		disabled : false,
		listeners:{
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var patno=field.getValue();
					//if (patno == null|| patno.length <= 0){return;}
					GetPapmiNo(patno);
					Query();
				}
			}
		}
	});
	
	
	// ��ݼ�
	PatNo.on('keydown', function(e) {
		alert(e.getKey())
		if (e.getKey() == Ext.EventObject.F2) {   //��ҩ
			DispAll();
		}
		if (e.getKey() == Ext.EventObject.F6) {   //����
			ReadCard_click();
		}
	})
	
	function stopDefault(e)
	{
		if (e&&e.preventDefault)
		{
			e.preventDefault();
			e.stopPropagation()
		}
		else
		{
			e.keyCode=0;
			e.cancelBubble=true
			window.event.returnValue = false;
		}
	}

	
	//����
	var CardNo = new Ext.form.TextField({
		fieldLabel : '����',
		id : 'CardNo',
		name : 'CardNo',
		//anchor : '90%',
		width : 120,
		disabled : false,
		listeners:{
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var cardno=field.getValue();
					if (cardno == null|| cardno.length <= 0){return;}
					GetPatNoFrCard(cardno);
				}
			}
		}
	});
	
	CardTypeStore = eval("(" + CardTypeArray + ')');
    
	var CardTypeComBo = new Ext.form.ComboBox({
			fieldLabel:'������',
			width : 90,
			typeAhead : true,
			height : 100,
			triggerAction : 'all',
			store : new Ext.data.ArrayStore({
				autoDestroy : true,
				fields : ['desc', 'value'],
				data : CardTypeStore
			
			}),
			mode : 'local',
			valueField : 'value',
			displayField : 'desc',
			listeners : {
				//change: LocChangeHandler
			}
		});
	
	//����
	var  ReadCardButton = new Ext.Button({
         width : 70,
         id:"ReadCardBtn",
         text: '����',
         icon:"../scripts/dhcpha/img/menuopera.gif",
         listeners:{
         	"click":function(){   
				ReadCard_click();
         	}   
         }
	})
	
	//ȡ������
	function GetCardTypeRowId() 
	{
		var CardTypeRowId = "";
		var CardTypeValue = CardTypeComBo.getValue();
		
		if (CardTypeValue != "") {
			var CardTypeArr = CardTypeValue.split("^");
			CardTypeRowId = CardTypeArr[0];
		}
		return CardTypeRowId;
    }
	
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
	
	//�ѷ�ҩ
	var DispFlag = new Ext.form.Checkbox({
		boxLabel : '�ѷ�ҩ',
		id : 'DispFlag',
		inputValue : '1',
		checked : false,
		listeners:{
			check:function(obj,ischecked){
				if(ischecked==true)
				{
					
				}
			}
		}
	});
	
	
	//ȫ��
	var AllFlag = new Ext.form.Checkbox({
		boxLabel : 'ȫ������',
		id : 'AllFlag',
		inputValue : '1',
		checked : false,
		listeners:{
			check:function(obj,ischecked){
				if(ischecked==true)
				{
					
				}
			}
		}
	});
	
	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
		id : "SearchBT",
		text : '��ѯ',
		tooltip : '�����ѯ',
		width : 70,
		height : 30,
		//iconCls : 'page_find',
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});
	
	// ��ҩ��ť
	var DispBT = new Ext.Toolbar.Button({
		id : "DispBT",
		text : '��ҩ',
		tooltip : '�����ҩ',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			Disp();
		}
	});
	
	// ȫ����ť
	var DispAllBT = new Ext.Toolbar.Button({
		id : "DispAllBT",
		text : 'ȫ��',
		tooltip : '���ȫ��',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			DispAll();
		}
	});
	
	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '���',
		tooltip : '������',
		width : 70,
		height : 30,
		iconCls : 'page_refresh',
		handler : function() {
			clearData();
		}
	});
	
	function clearData()
	{
		Ext.getCmp("PatNo").setValue("");
		Ext.getCmp("PatNo").setValue("");
		Ext.getCmp("startdt").setValue(new Date);
		Ext.getCmp("enddt").setValue(new Date);
		PrescGrid.store.removeAll();
		//htmlstr=OutPrescViewXY(45);
		htmlstr='<div style="width:785px;height:48px;background:#FFFFFF;">'+'<span style="margin:0px 0px 10px 15px;font-size:12pt;font-family:���Ŀ���;">'+'��û��ѡ�д�����'+'</span>'+'</div>';
		Ext.getCmp('reportPanel').body.update(htmlstr);
	}
	
	// ��ӡ��ť
	var PrintBT = new Ext.Toolbar.Button({
		id : "PrintBT",
		text : '��ӡ',
		tooltip : '�����ӡ',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			var rowData=PrescGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", "��ѡ����Ҫ��ӡ�Ĵ���!");
				return;
			}
			var prescno=rowData.get("PrescNo");			
		}
	});
	
	// �ܷ���ť
	var BadButton = new Ext.Button({
		id:"BadButton",
		text: '�ܾ�',
		icon:"../scripts/dhcpha/img/cancel.png",
		listeners:{
		"click":function(){
				RefuseDisp();
			}
		}

	})
	
	//�����б�
	var PrescStore=new Ext.data.JsonStore({
		auroDestroy:true,
		url:Url+"actiontype=PrescQuery",
		sotreId:'PrescStore',
		root:'rows',
		totalProperty:'results',
		idProperty:'PatID',
		fields:['phd','PatNo','PatName','PrescNo','InvNo','FYFlag','prt','FYStaus']
	});
	
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:PrescStore,
		pageSize:9999,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
	
	var cm=new Ext.grid.ColumnModel([{
			header:'Rowid',
			dataIndex:'phd',
			width:100,
			align:'left',
			hidden:true
		},{
			header:'�ǼǺ�',
			dataIndex:'PatNo',
			width:80,
			align:'left'
			//sortable:true
		},{
			header:'����',
			dataIndex:'PatName',
			width:90,
			align:'left'
			//sortable:true
		},{
			header:'������',
			dataIndex:'PrescNo',
			width:100,
			align:'left'
			//sortable:true
		},{
			header:'��Ʊ��',
			dataIndex:'InvNo',
			width:80,
			align:'left',
			//sortable:true,
			hidden:true
		},{
			header:'��ҩ��־',
			dataIndex:'FYFlag',
			width:70,
			align:'left',
			//sortable:true,
			hidden:true
		},{
			header:'prt',
			dataIndex:'prt',
			width:70,
			align:'left',
			//sortable:true,
			hidden:true
		},{
			header:'��ҩ',
			dataIndex:'FYStaus',
			width:40,
			align:'left',
			sortable:true
		}])
	
	var PrescGrid=new Ext.grid.GridPanel({
		id:'PrescGrid',
		//height:495,
		store:PrescStore,
		cm:cm,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		autoScroll:true,
		viewConfig : {
			getRowClass: function(record, rowIndex,rowParams,store){
				var fyflag=record.get('FYFlag');
				if(fyflag=="1"){return 'classOrange'}
				else{return 'classGrassGreen'}
				return '<font color=blue></font><span style="color:red;">' + Ext.util.Format.usMoney(val) + '</span>';
			}
		},
		bbar:[GridPagingToolbar]
	})
	
	function getColor(val) {  
	if (val != "") {  
			return '<span style="font-size:22px;">' + val + '</span> ' 
		}  
	}  
	cm.setRenderer(2, getColor);   //�������������С
	
	// ��ӱ�񵥻����¼�
	PrescGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var rowData = PrescStore.data.items[rowIndex];
		var phd = rowData.get("phd");
		htmlstr=OutPrescView(phd);
		Ext.getCmp('reportPanel').body.update(htmlstr);
	});
	
			
	var reportPanel=new Ext.Panel({
		id:'reportPanel',
		autoScroll:true,
		title:'<span style="color:red">'+'����Ԥ��'+'</span>',
		frame:true,
		defaults : {//����Ĭ������   
            bodyStyle:'background-color:#FFFFFF;padding:15px'//���������ı���ɫ   
        } ,  
        items: [   
            {   
                html : htmlstr,   
                id : 'p1'  
            }  
        ]
        
		//html:'<iframe id="reportFrame" height="100%" width="100%" src="../scripts/dhcmed/img/logon_bg2.jpg"/>'
	})
	
	var nbsp='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+
		'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+
		'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+
		'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+
		'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+
		'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+
		'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'

	var titleloc='<span style="font-size:12pt;">'+PhLocDesc+'</span>';
	var titlewin='<span style="font-size:12pt;font-family:���Ŀ���;">'+'��ҩ����:'+PhWinDesc+'</span>';
	var titlefyuser='<span style="font-size:12pt;font-family:���Ŀ���;">'+'��ҩ��:'+FyUserName+'</span>';
	var title=titleloc+nbsp+titlewin+nbsp+titlefyuser
	var TitlePanel= new Ext.form.FormPanel({
		labelwidth : 30,
		title: title
	})
	
	
	function Query()
	{
		PrescGrid.store.removeAll();
		htmlstr='<div style="width:785px;height:48px;background:#FFFFFF;">'+'<span style="margin:0px 0px 10px 15px;font-size:12pt;font-family:���Ŀ���;">'+'��û��ѡ�д�����'+'</span>'+'</div>';
		Ext.getCmp('reportPanel').body.update(htmlstr);
		var StartDate=Ext.getCmp("startdt").getValue().format('j/m/Y').toString();
		var EndDate=Ext.getCmp("enddt").getValue().format('j/m/Y').toString();
		var PatNo=Ext.getCmp("PatNo").getValue();
		//PatNo=GetWholePatID(PatNo);
		var DispFlag=Ext.getCmp("DispFlag").getValue();
		if(DispFlag==true){DispFlag="1";}
		else{DispFlag="0";}
		var AllFlag=Ext.getCmp("AllFlag").getValue();
		if(AllFlag==true){AllFlag="1";}
		else{AllFlag="0";}
		var ListParam=GPhl+'^'+GPhw+'^'+StartDate+'^'+EndDate+'^'+PatNo+'^'+DispFlag+'^'+AllFlag;
		Ext.getCmp("PatNo").setValue("");
		Ext.getCmp("CardNo").setValue("");
		var Page=9999 //GridPagingToolbar.pageSize;;
		PrescStore.setBaseParam("ParamStr",ListParam);
		PrescStore.removeAll();
		PrescGrid.store.removeAll();
		PrescStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options, success){
				if(success==false){
     				Msg.info("error", "��ѯ������鿴��־!");
     			}else{
     				if(r.length>0){
	     				PrescGrid.getSelectionModel().selectFirstRow();
	     				PrescGrid.getSelectionModel().fireEvent('rowselect',this,0);
	     				PrescGrid.getView().focusRow(0);
	     				//Ext.getCmp('PatNo').focus(false, 100);  //Ĭ�Ϲ��
     				}
     			}
			}
		});

	}
	
	
	
	function QueryPatList()
	{
		var ListParam=GPhl+'^'+GPhw
		//var Page=GridPagingToolbar.pageSize;
		var Page=9999;
		PatListStore.setBaseParam("ParamStr",ListParam);
		PatListStore.removeAll();
		PatListGrid.store.removeAll();
		PatListStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options, success){
				if(success==false){
     				Msg.info("error", "���������б������鿴��־!");
     			}else{
     				if(r.length>0){
	     				//Ext.getCmp('PatNo').focus(false, 100);  //Ĭ�Ϲ��
     				}
     			}
			}
		});

	}
	
	//ȫ��
	function DispAll()
	{
		var rowCount = PrescGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var prescno = PrescStore.getAt(i).get("PrescNo");
			var prt=PrescStore.getAt(i).get("prt");
			/*
			var adtresult=ChkAdtResult(prescno) ;   //LiangQiang 2014-12-22  �������
			adtresult="S";
			if (adtresult=="N"){
				Msg.info("warning", prescno+"�ô�����˲�ͨ��,��ֹ��ҩ!");
				continue;
		    } 
	     	if (adtresult=="S"){
		     	if(!confirm("��ʾ���ô���ҽ�����ύ����,���'ȷ��'��ͬ�����߼�����ҩ�����'ȡ��'��������ҩ������")) continue;
		     	
		     	//var conflag="0";
				//Ext.MessageBox.confirm(prescno+"��ʾ",prescno+"�ô���ҽ�����ύ����,���'��'��ͬ�����߼�����ҩ�����'��'��������ҩ������",function(e){if(e=="no")conflag="1";});
		    	//if(conflag=="1")continue;
		    }
		    var ref = GetPrescNoRefRet(prescno);   //LiangQiang 2014-12-22  �����ܾ�
		    if (ref=="N"){
				Msg.info("warning", prescno+"�ô����ѱ��ܾ�,��ֹ��ҩ!");
				continue;
			}
			if (ref=="A"){
				Msg.info("warning", prescno+"�ô����ѱ��ܾ�,��ֹ��ҩ!");
				continue;
			}
			if (ref=="S"){
				if(!confirm("��ʾ���ô���ҽ�����ύ����,���'ȷ��'��ͬ�����߼�����ҩ�����'ȡ��'��������ҩ������"))continue;
		     	
				//var conflag="0";
				//Ext.MessageBox.confirm("��ʾ",prescno+"�ô���ҽ�����ύ����,���'��'��ͬ�����߼�����ҩ�����'��'��������ҩ������",function(e){if(e=="no")conflag="1";});
				//if(conflag=="1")continue;
			}
			*/
			var shdr="";
			var pwin="";
			var newwin="";
			var usercode="";
			var retval=Dispensing(prt,GPhl,GPydr,GFydr,prescno,shdr,pwin,newwin,usercode)
		    if (retval<0) {continue;}
		    Msg.info("success", "��ҩ�ɹ�!");
		    //��ҩ�ɹ��ı��ɫ
		    changeBgColor(i,"#FFCC99");
		    var record = PrescGrid.getStore().getAt(i);
		    record.set("FYStaus","OK");
		}
		QueryPatList();  //��ҩ��ˢ�´���ҩ�б�
		Ext.getCmp('PatNo').focus(false, 100);  //Ĭ�Ϲ��
	}
	
	//��ҩ
	function Disp()
	{
		var rowData=PrescGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "��ѡ����Ҫ��ҩ�Ĵ���!");
			return;
		}
		var prescno=rowData.get("PrescNo");
		/*
		var adtresult=ChkAdtResult(prescno) ;   //LiangQiang 2014-12-22  �������
		if (adtresult=="N"){
			Msg.info("warning", "�ô�����˲�ͨ��,��ֹ��ҩ!");
			return;
	    } 
     	if (adtresult=="S"){
			Ext.MessageBox.confirm("��ʾ","�ô���ҽ�����ύ����,���'��'��ͬ�����߼�����ҩ�����'��'��������ҩ������",function(e){if(e=="no")return;});
	    }
	    var ref = GetPrescNoRefRet(prescno);   //LiangQiang 2014-12-22  �����ܾ�
	    if (ref=="N"){
			Msg.info("warning", "�ô����ѱ��ܾ�,��ֹ��ҩ!");
			return;
		}
		if (ref=="A"){
			Msg.info("warning", "�ô����ѱ��ܾ�,��ֹ��ҩ!");
			return;
		}
		if (ref=="S"){
			Ext.MessageBox.confirm("��ʾ","�ô���ҽ�����ύ����,���'��'��ͬ�����߼�����ҩ�����'��'��������ҩ������",function(e){if(e=="no")return;});
		}
		*/
		var shdr="";
		var pwin="";
		var newwin="";
		var usercode="";
		var prt=rowData.get("prt");
		var retval=Dispensing(prt,GPhl,GPydr,GFydr,prescno,shdr,pwin,newwin,usercode)
     	if (retval<0) {return;}
     	//��ҩ�ɹ��ı��ɫ
     	var rowCount = PrescGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var item = PrescStore.getAt(i).get("PrescNo");
			if (item == prescno) {
				changeBgColor(i,"#FFCC99")
				Msg.info("success", "��ҩ�ɹ�!");
				var record = PrescGrid.getStore().getAt(i);
		    	record.set("FYStaus","OK");
				QueryPatList();  //��ҩ��ˢ�´���ҩ�б�
				return ;
			}
		}
		
	}
	
	function Dispensing(prt,GPhl,GPydr,GFydr,prescno,shdr,pwin,newwin,usercode)
	{
		var retval=tkMakeServerCall("web.DHCOutPhDisp","UpdatePyd",prt,GPhl,GPydr,GFydr,prescno,shdr,pwin,newwin,usercode,"0")
		if (retval==-20)
		{
			Msg.info("error", "�ô���������,���ܷ�ҩ");
			return -20;
		}
		if (retval==-21)
		{
			Msg.info("error", "�ô���ҩƷ�ѷ�,�����ظ���ҩ");
			return -21;
		}
		if (retval==-4)
		{
			Msg.info("error", "�ô���ҽ����ͣ,���ܷ�ҩ");
			return -4;
		}
		if (retval==-7)
		{
			Msg.info("error", "��ҩʧ��,"+"ʧ��ԭ��: ��治��,��˲�");
			return -7;
		}
		if (retval==-24)
		{
			Msg.info("error", "��ҩʧ��,"+"ʧ��ԭ��: ��治��,��˲�");
			return -24;
		}
		if (retval<0)
		{
			Msg.info("error", "��ҩʧ��,"+"�������: "+retval);
			return -24;
		}
		if (!(retval>0))
		{
			Msg.info("error", "��ҩʧ��,"+"�������: "+retval);
			return -24;
		}
     	return retval;
	}
	
	// �任����ɫ
	function changeBgColor(row, color) {
		PrescGrid.getView().getRow(row).style.backgroundColor = color;
	}
	
	/*
	��ȡ�����ܾ���� LiangQiang 2014-12-22
	*/
	function GetPrescNoRefRet(prescno)
	{
		var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdRefResultByPresc",prescno);
		return ref;
	}
	
	 //����Ƿ�ܾ���ҩ
	function ChkAdtResult(prescno)
	{
        var retval=tkMakeServerCall("web.DHCOutPhCommon","GetOrdAuditResultByPresc",prescno)
        return retval ;
	}
	
	function RefuseDisp()
	{
		var rowData=PrescGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "��ѡ����Ҫ�ܷ��Ĵ���!");
			return;
		}
		var prescno=prescno=rowData.get("PrescNo");
		var ref = GetPrescNoRefRet(prescno);���� //LiangQiang 2014-12-22  �����ܾ�
		if (ref=="N"){
			Msg.info("warning", "�ô����ѱ��ܾ�,�����ظ�����!");
			return;
		}
		if (ref=="A"){
			Msg.info("warning", "�ô����ѱ��ܾ�,�����ظ�����!");
			return;
		}
		var adtresult=ChkAdtResult(prescno) ;
		if ((adtresult!="Y")&(adtresult!="")){
			Msg.info("warning", "�ô�����˲�ͨ��,��ֹ����!");
			return;
	    } 
	    var waycode ="8"
	    var retstr=showModalDialog('dhcpha.comment.selectreason.csp?orditm='+prescno+'&waycode='+waycode,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
	    if (!(retstr)){
        	return;
        }
        if (retstr==""){
        	return;
        }
        retarr=retstr.split("@");
        var ret="N";
		var reasondr=retarr[0];
		var advicetxt=retarr[2];
		var factxt=retarr[1];
		var phnote=retarr[3];
		var User=session['LOGON.USERID'] ;
		var grpdr=session['LOGON.GROUPID'] ;
		var input=ret+"^"+User+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+grpdr+"^"+prescno+"^OR"  //orditm;
		if (reasondr.indexOf("$$$")=="-1")
		{
			reasondr=reasondr+"$$$"+prescno ;
		}
		var retval=tkMakeServerCall("web.DHCSTCNTSOUTMONITOR","SaveOPAuditResult",reasondr,input)
		if(retval==0)
		{
			Msg.info("success", "�ܷ��ɹ�!");
			var patno=rowData.get("PatNo");
			Ext.getCmp("PatNo").setValue(patno);
			Query();  
		}
		else
		{
			Msg.info("error", "�ܾ�ʧ��!");
			return;
		}
	}
	
	//��ȫ�ǼǺ�
	function GetPapmiNo(patno)
	{
		var len=tkMakeServerCall("web.DHCOutPhAdd","GetPminoLen")
		var plen=patno.length;
		if(plen>len)
		{
			Msg.info("warning", "�ǼǺ��������");
			return;
		}
		var lszero=""
		if (plen<=len){
			for (i=1;i<=len-plen;i++)
		  	{
				lszero=lszero+"0"  
		    }
		    patno=lszero+patno;
		}
	 	Ext.getCmp("PatNo").setValue(patno);
	}
	
	///�س����� GetPatNoFrCard
	function GetPatNoFrCard(cardno)
	{
		///var myoptval=CardTypeComBo.getValue();
		//if(myoptval == null|| myoptval.length <= 0) return;
		var m_CardNoLength=12 //myoptval.split("^")[17];
		cardlen=cardno.length
		if (m_CardNoLength>cardlen){
			var lszero="";
			for (i=1;i<=m_CardNoLength-cardlen;i++)
			{
				lszero=lszero+"0"  
			}
			var cardno=lszero+cardno;
		}
		var patno=tkMakeServerCall("web.DHCOutPhCommon","GetPmiNoFrCardNo",cardno)
		Ext.getCmp("PatNo").setValue(patno);
		Query();
		Ext.getCmp("CardNo").setValue("");
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
	 		Ext.Msg.show({title:'����',msg:'����ID�Ŵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	 	 	return;
	 	 }
	     var retflag=tkMakeServerCall("web.DHCSTInterfacePH", "GetPapmiByPatno",RegNo);
	     if(retflag=="")
	     {
		     Ext.Msg.show({title:'����',msg:'����ID�Ŵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	 	 	 return;
		 }
	 	 Ext.getCmp('PatNo').setValue(RegNo);
	 	 return RegNo;
	
	}
	
	function GetPhTitle()
	{
		PhLocDesc=tkMakeServerCall("web.DHCOutPhDispFY","GetPhLocDesc",GPhl)
		if(PhLocDesc=="-1"){Ext.Msg.show({title:'����',msg:'ҩ�����Ҵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});return false;}
		if(PhLocDesc=="-2"){Ext.Msg.show({title:'����',msg:'ҩ�����Ҵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});return false;}
		PhWinDesc=tkMakeServerCall("web.DHCOutPhDispFY","GetPhWinDesc",GPhw)
		if(PhWinDesc=="-1"){Ext.Msg.show({title:'����',msg:'���ڴ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});return false;}
		FyUserName=tkMakeServerCall("web.DHCOutPhDispFY","GetFyUserName",GFydr)
		if(FyUserName=="-1"){Ext.Msg.show({title:'����',msg:'��Ա����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});return false;}
		if(FyUserName=="-2"){Ext.Msg.show({title:'����',msg:'����Ա����Ч!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});return false;}
		if(FyUserName=="-3"){Ext.Msg.show({title:'����',msg:'�ù���û�з�ҩȨ�ޣ����ʵ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});return false;}
		return true;
	}
	
	function CheckPhlUser()
	{
		if(GPhl==""){}
	}
	
	function ReadCard_click()
	{
		var CardInform=DHCACC_ReadMagCard("4","","","");   //ҽ����
		var myary=CardInform.split("^");
		var rtn=myary[0];
		if(rtn=="0")
		{
			var cardno=myary[1];
			GetPatNoFrCard(cardno);
		}
		else
		{
			var CardInform=DHCACC_GetAccInfo("2","2^01^ע��ҽ�ƿ�^NP^N^^^Y^Y^61091^^IE^N^ReadCard^2^^Read^12^Y^N^Name^N^ReadCard^Y^CA^UDHCCardInvPrt^^Y^PC^^CQU^Y^Y^Y^^")
    		var myary=CardInform.split("^");
    		var rtn=myary[0];
    		if(rtn=="0")
    		{
	    		var PatNo=myary[5];
	    		Ext.getCmp("PatNo").setValue(PatNo);
				Query();
	    	}
	    	else
	    	{
		    	Msg.info("warning", "��������!");
		    	Ext.getCmp('PatNo').focus(false, 100);  //Ĭ�Ϲ��
		    }
		}
	}
	
	
	function CallVioce()
	{
		var rowCount = PatListGrid.getStore().getCount();
		if (rowCount == 0) {
			Msg.info("warning", "û����Ҫ�Ĳ���!");
			return;
		}
		var pat_name = PatListStore.getAt(0).get("PatName");
		var IPAddress=GetComputerIp()
		var call_room=PhWinDesc;
		var dept_name=PhLocDesc;
		var input="<patient_info><IPaddress>"+IPAddress+"</IPaddress><pat_name>"+pat_name+"</pat_name>"+
			"<call_room>"+call_room+"</call_room><dept_name>"+dept_name+"</dept_name><pass_name></pass_name></patient_info>"
		var ret=tkMakeServerCall("web.DHCENS.BLL.CallStation.Method.CallPatientInfo","SetCallPatientInfo",input)
	}
	
	
	//����
	function Delay()
	{
		var rowData=PatListGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "��ѡ����Ҫ���ŵĲ���!");
			return;
		}
		var PatNo=rowData.get("PatNo");
		var PatID=rowData.get("PatID");
		var ret=tkMakeServerCall("web.DHCOutPhDispFY","Delay",GPhl,GPhw,PatNo,PatID)
		
	}
	
	function GetComputerIp() 
	{
	   var ipAddr="";
	   var locator = new ActiveXObject ("WbemScripting.SWbemLocator");  
	   var service = locator.ConnectServer("."); //���ӱ���������
	   var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration");  //��ѯʹ��SQL��׼ 
	   var e = new Enumerator (properties);
	   var p = e.item ();

	   for (;!e.atEnd();e.moveNext ())  
	   {
	  	var p = e.item ();  
	 	//document.write("IP:" + p.IPAddress(0) + " ");//IP��ַΪ��������,�������뼰Ĭ��������ͬ
		ipAddr=p.IPAddress(0); 
		if(ipAddr) break;
		}

		return ipAddr;
	}
	
	var mainForm = new Ext.form.FormPanel({
		id:'mainForm',
		//title:'<span style="color:red">'+'��ҩ��ѯ'+'</span>',
		tbar : [ClearBT,'-',SearchBT,'-',DispBT,'-',DispAllBT],
		bbar : [DispFlag,'-',AllFlag,'-',ReadCardButton,'-',PrintBT],
		labelWidth : 60,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		items:[{
			layout:'column',
			xtype: 'fieldset',
			title:'��ѯ����',
			style:'padding:0px 20px 0px 0px',
			items:[{
				//columnWidth: 0.5,
		    	border: false,
		    	items: [{
				    	layout : "form",
				    	items: [stdatef]
			    	},{
				    	layout : "form",
				    	items: [enddatef]
			    	},{
				    	layout : "form",
				    	items: [PatNo]
			    	},{
				    	layout : "form",
				    	items: [CardNo]
			    	}]
			}]
		}]						
	});
	
	
	var myPanel = new Ext.Viewport({
		renderTo:'mainPanel',
		layout : 'border',
		items : [{
			region:'north',
			layout:'fit',
			items:TitlePanel,
			height:30
		},{
			region:'west',
			width:190,
			collapsible:true,
			layout:'fit',
			title:'<span style="color:red">'+'���������б�'+'</span>',
			items:PatListGrid
		},{
			region:'center',
			title:'<span style="color:red">'+'��ҩ��ѯ'+'</span>',
			collapsible: true,
			layout:'border',
			items:[{  
                region:'north',
                layout: 'fit',
                items:mainForm,
                height:250            
            },{
	            region:'center',  
	            layout:'fit',
                items:PrescGrid
                }]
		},{
			region:'east',  
			width:800,
			layout:'fit',
			items:reportPanel
		}]
	})
	Ext.getCmp('PatNo').focus(false, 100);  //Ĭ�Ϲ��
	QueryPatList();
	
	var task_RealTimeMointor = {
		run : QueryPatList,  //ִ������ʱִ�еĺ���
		interval : 10000 
		//������������Ϊ��λ��������10��
    }
   
    //�����Զ�	
    function StartAutoLoad()
    {		
		Ext.TaskMgr.start(task_RealTimeMointor);
    }
   
    //�ر��Զ�
    function StopAutoLoad()
    {
		Ext.TaskMgr.stop(task_RealTimeMointor);       
    } 
    StartAutoLoad();
    
     /*
	// ��ݼ�
	PrescGrid.on('keydown', function(e) {
		if (e.getKey() == Ext.EventObject.F2) {   //��ҩ
			Disp();
		}
		if (e.getKey() == Ext.EventObject.F4) {   //ȫ��
			DispAll();
		}
		if (e.getKey() == Ext.EventObject.F6) {   //����
			ReadCard_click();
		}
	})
	*/
	// ��ݼ�
 	var map=new Ext.KeyMap(document,[{
		 	key:Ext.EventObject.F2,  //��ҩ
		 	fn:Disp,
		 	alt:false,
		 	scope:true
		}, {
			key:17,  //ctrlȫ��
		 	fn:DispAll,
		 	alt:false,
		 	scope:true
		}, {
			key:Ext.EventObject.F6,  //����
		 	fn:ReadCard_click,
		 	alt:false,
		 	scope:true
		}
	])
	map.enable();
})
