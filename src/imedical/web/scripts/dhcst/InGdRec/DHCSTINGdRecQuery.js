//Description:����ۺϲ�ѯ
//Creator:zhangdongmei
//CreatDate:2012-11-30
var gNewCatId="";
Ext.onReady(function(){

	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	
	if(gParam.length<1){
		GetParam();  //��ʼ����������
	}
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '<font color=blue>'+$g('����')+'</font>',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : '����...',
		groupId:gGroupId,
		listeners : {'select' : function(e) {SetDefaultSCG();}}
	});
	
	function SetDefaultSCG()
	{
		 var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
         StkGrpType.getStore().removeAll();
         StkGrpType.getStore().setBaseParam("locId",SelLocId)
         StkGrpType.getStore().setBaseParam("userId",UserId)
         StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
         StkGrpType.getStore().load();
	}
	
	var DateFrom = new Ext.ux.EditDate({
		fieldLabel : '<font color=blue>'+$g('��ʼ����')+'</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		value :DefaultStDate()
	});
		
	var DateTo = new Ext.ux.EditDate({
		fieldLabel : '<font color=blue>'+$g('��ֹ����')+'</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		value : DefaultEdDate()
	});
	
	// ҩƷ����
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		anchor:'90%',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:gLocId,
		UserId:gUserId
	}); 
	StkGrpType.on('select',function(){
		Ext.getCmp("DHCStkCatGroup").setValue("");
	});
	
	var InciDr = new Ext.form.TextField({
		fieldLabel : $g('ҩƷRowId'),
		id : 'InciDr',
		name : 'InciDr',
		anchor : '90%',
		valueNotFoundText : ''
	});

	var InciCode = new Ext.form.TextField({
		fieldLabel : $g('ҩƷ����'),
		id : 'InciCode',
		name : 'InciCode',
		anchor : '90%',
		valueNotFoundText : ''
	});
	var IncDesc = new Ext.form.TextField({
		fieldLabel : $g('ҩƷ����'),
		id : 'IncDesc',
		name : 'IncDesc',
		anchor : '90%',
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stkGrp=Ext.getCmp("StkGrpType").getValue();
					var inputText=field.getValue();
					GetPhaOrderInfo(inputText,stkGrp);
				}
			}
		}
	});
    /**
	 * ����ҩƷ���岢���ؽ��
	 */
	function GetPhaOrderInfo(item, group) {
					
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "", "",
					getDrugList);
		}
	}
		
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
		
		Ext.getCmp("InciDr").setValue(inciDr);
		Ext.getCmp("InciCode").setValue(inciCode);
		Ext.getCmp("IncDesc").setValue(inciDesc);
	}
	var ImpNO = new Ext.form.TextField({
		fieldLabel : $g('��ⵥ��'),
		id : 'ImpNO',
		name : 'ImpNO',
		anchor : '90%',
		valueNotFoundText : ''
	});	
	var DHCStkCatGroup = new Ext.ux.ComboBox({
		fieldLabel : $g('������'),
		id : 'DHCStkCatGroup',
		name : 'DHCStkCatGroup',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'StkGrpType'}
	});
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		anchor : '90%'
	});
				
	// ҩѧ����
	var PhcCat = new Ext.ux.ComboBox({
		fieldLabel : $g('ҩѧ����'),
		id : 'PhcCat',
		name : 'PhcCat',
		store : PhcCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PhccDesc'
	});

	PhcCat.on('change', function(e) {
		Ext.getCmp('PhcSubCat').setValue("");
		Ext.getCmp('PhcMinCat').setValue("");
	});

	// ҩѧ����
	var PhcSubCat = new Ext.ux.ComboBox({
		fieldLabel :$g( 'ҩѧ����'),
		id : 'PhcSubCat',
		name : 'PhcSubCat',
		store : PhcSubCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{PhcCatId:'PhcCat'}
	});

	PhcSubCat.on('change', function(e) {
		Ext.getCmp('PhcMinCat').setValue("");
	});

	// ҩѧС��
	var PhcMinCat = new Ext.ux.ComboBox({
		fieldLabel : $g('ҩѧС��'),
		id : 'PhcMinCat',
		name : 'PhcMinCat',
		store : PhcMinCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{PhcSubCatId:'PhcSubCat'}
	});
	var PHCCATALL = new Ext.form.TextField({
		fieldLabel : $g('ҩѧ����'),
		id : 'PHCCATALL',
		name : 'PHCCATALL',
		anchor : '100%',
		readOnly : true,
		valueNotFoundText : ''
	});
//GetAllCatNew("kkk");
function GetAllCatNew(catdescstr,newcatid){
	//if ((catdescstr=="")&&(newcatid=="")) {return;}
	Ext.getCmp("PHCCATALL").setValue(catdescstr);
	gNewCatId=newcatid;
	
	
}

var PHCCATALLButton = new Ext.Button({
	id:'PHCCATALLButton',
	text : $g('ҩѧ����'),
	handler : function() {	
       //var lnk="dhcst.phccatall.csp?gNewCatId="+gNewCatId;
       //window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
    /*
     var retstr=showModalDialog('dhcst.phccatall.csp?gNewCatId='+gNewCatId,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
       if (!(retstr)){
          return;
        }
        
        if (retstr==""){
          return;
        }
     
	var phacstr=retstr.split("^")
	GetAllCatNew(phacstr[0],phacstr[1])
	*/
	PhcCatNewSelect(gNewCatId,GetAllCatNew)
    }
});
	var PHCDFPhcDoDR = new Ext.ux.ComboBox({
		fieldLabel : $g('���Ʒ���'),
		id : 'PHCDFPhcDoDR',
		name : 'PHCDFPhcDoDR',
		anchor : '90%',
		store : PhcPoisonStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		valueNotFoundText : ''
	});

	var PhManufacturer = new Ext.ux.ComboBox({
		fieldLabel :$g( '������ҵ'),
		id : 'PhManufacturer',
		name : 'PhManufacturer',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName'
	});

	var PHCDOfficialType = new Ext.form.ComboBox({
		fieldLabel : $g('ҽ�����'),
		id : 'PHCDOfficialType',
		name : 'PHCDOfficialType',
		anchor : '90%',
		store : OfficeCodeStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		valueNotFoundText : ''
	});

	var PHCForm = new Ext.ux.ComboBox({
		fieldLabel : $g('����'),
		id : 'PHCForm',
		name : 'PHCForm',
		store : PhcFormStore,
		valueField : 'Description',
		displayField : 'Description',
		filterName:'PHCFDesc'
	});

	var PublicBiddingStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['1', $g('�б�')], ['0', $g('���б�')]]
	});
	var PublicBidding = new Ext.form.ComboBox({
		fieldLabel : $g('�б�'),
		id : 'PublicBidding',
		name : 'PublicBidding',
		anchor : '90%',
		store : PublicBiddingStore,
		valueField : 'RowId',
		displayField : 'Description',
		mode : 'local',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		listWidth : 150,
		forceSelection : true
	});

	var INFOPBLevel = new Ext.form.ComboBox({
		fieldLabel : $g('�б꼶��'),
		id : 'INFOPBLevel',
		name : 'INFOPBLevel',
		anchor : '90%',
		store : INFOPBLevelStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		listWidth : 150,
		forceSelection : true
	});

	var SpFlag = new Ext.form.Checkbox({
		//fieldLabel : '�����ۼ۲������ۼ�',
		id : 'SpFlag',
		name : 'SpFlag',
		anchor : '90%',
		checked : false,
		boxLabel:$g('�����ۼ۲������ۼ�')
	});
	
	MarkTypeStore.load();
	var INFOMT = new Ext.form.ComboBox({
		fieldLabel : $g('��������'),
		id : 'INFOMT',
		name : 'INFOMT',
		anchor : '90%',
		store : MarkTypeStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		forceSelection : true
	});
		
	// �������
	var OperateInType = new Ext.form.ComboBox({
		fieldLabel :$g( '�������'),
		id : 'OperateInType',
		name : 'OperateInType',
		anchor : '90%',
		store : OperateInTypeStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		valueNotFoundText : ''
	});
	OperateInTypeStore.load();
		
	var ImportStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [[$g('����'), $g('����')], [$g('����'), $g('����')], [$g('����'), $g('����')]]
	});
	var INFOImportFlag = new Ext.form.ComboBox({
		fieldLabel : $g('���ڱ�־'),
		id : 'INFOImportFlag',
		name : 'INFOImportFlag',
		anchor : '90%',
		store : ImportStore,
		valueField : 'RowId',
		displayField : 'Description',
		mode : 'local'
	});
	var InvNo = new Ext.form.TextField({
		fieldLabel : $g('��Ʊ��'),
		id : 'InvNo',
		name : 'InvNo',
		anchor : '90%',
		valueNotFoundText : ''
	});
			
	var MinSp = new Ext.form.TextField({
		fieldLabel : $g('����ۼ�'),
		id : 'MinSp',
		name : 'MinSp',
		anchor : '90%',
		valueNotFoundText : ''
	});
			
	var MaxSp = new Ext.form.TextField({
		fieldLabel : $g('����ۼ�'),
		id : 'MaxSp',
		name : 'MaxSp',
		anchor : '90%',
		valueNotFoundText : ''
	});
	var MaxRp = new Ext.form.TextField({
		fieldLabel : $g('��߽���'),
		id : 'MaxRp',
		name : 'MaxRp',
		anchor : '90%',
		valueNotFoundText : ''
	});
	var MinRp = new Ext.form.TextField({
		fieldLabel : $g('��ͽ���'),
		id : 'MinRp',
		name : 'MinRp',
		anchor : '90%',
		valueNotFoundText : ''
	});
	
	var DateFlag=new Ext.form.Checkbox({
		//fieldLabel:'���������ͳ��',
		id:'DateFlag',
		anchor:'90%',
		boxLabel:$g('���������ͳ��')
	});
	var searchBT=new Ext.Toolbar.Button({
		id:'searchBT',
		text:$g('��ѯ'),
		tooltip : $g('�����ѯ�����ϸ'),
		height:30,
		width:70,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});
	
	var clearBT=new Ext.Toolbar.Button({
		id:'clearBT',
		text:$g('����'),
		tooltip : $g('�������'),
		height:30,
		width:70,
		iconCls : 'page_clearscreen',
		handler : function() {
			ClearData();
		}
	});
	
	function ClearData(){
		Ext.getCmp('mainForm').getForm().items.each(function(f){ 
			f.setValue("");
		});
		SetLogInDept(PhaLoc.getStore(),"PhaLoc")
		SetDefaultSCG();
		Ext.getCmp("DateFrom").setValue(DefaultStDate());
		Ext.getCmp("DateTo").setValue(DefaultEdDate());
		Ext.getCmp("StkGrpType").getStore().load();
		DetailGrid.store.removeAll();
		Ext.getCmp("PHCCATALL").setValue("");
		gNewCatId=""
	}
	
	//��ѯ�����ϸ
	function Query(){
		
		
		var StartDate = Ext.getCmp("DateFrom").getValue();
			if(StartDate!=""){
				StartDate=StartDate.format(App_StkDateFormat);
			}else{
				Msg.info("warning",$g("��ѡ��ʼ����!"));
				return;
			}
			
			var EndDate = Ext.getCmp("DateTo").getValue()
			if(EndDate!=""){
				EndDate=EndDate.format(App_StkDateFormat);
			}else{
				Msg.info("warning",$g("��ѡ���ֹ����!"));
				return;
			}
		
		//var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();;
		//var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();;
		var LocId=Ext.getCmp("PhaLoc").getValue();		
		var RetFlag=0;
		if(LocId==null || LocId==""){
			Msg.info("warning",$g("���Ҳ���Ϊ��!"));
			return;
		}
		if(StartDate==null || StartDate==""){
			Msg.info("warning",$g("��ʼ���ڲ���Ϊ��!"));
			return;
		}
		if(EndDate==null || EndDate==""){
			Msg.info("warning",$g("��ֹ���ڲ���Ϊ��!"));
			return;
		}
		var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
		var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//������id
		var StkCatDesc=Ext.getCmp("DHCStkCatGroup").getRawValue();
		var IncDesc=Ext.getCmp("IncDesc").getValue();
		var ImpNO=Ext.getCmp("ImpNO").getValue();
		var IncRowid="";
		if(IncDesc!=null&IncDesc!=""){
			IncRowid=Ext.getCmp("InciDr").getValue();				//�����id
			if (IncRowid == undefined) {
				IncRowid = "";
			}
		}
		var MarkType=Ext.getCmp("INFOMT").getValue();				//��������
		var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();		//���ڱ�־
		var BatNo='';											//��������
		var PbFlag=Ext.getCmp("PublicBidding").getValue();		//�б��־
		if (PbFlag=="�б�") {PbFlag=1}
		else if (PbFlag=="���б�") {PbFlag=0}
		var PbLevel=Ext.getCmp("INFOPBLevel").getValue();			//�б꼶��
		var PhcCatId=(Ext.getCmp("PhcCat").getRawValue()==""?"":Ext.getCmp("PhcCat").getValue());				//ҩѧ����id
		var PhcSubCatId=Ext.getCmp("PhcSubCat").getValue();			//ҩѧ����id
		var PhcMinCatId=Ext.getCmp("PhcMinCat").getValue();			//ҩѧС��id
		var ManfId=Ext.getCmp("PhManufacturer").getValue();			//������ҵid
		var Form=Ext.getCmp("PHCForm").getValue();					//����
		var InsuType=Ext.getCmp("PHCDOfficialType").getRawValue();		//ҽ������
		var PosionCat=Ext.getCmp("PHCDFPhcDoDR").getValue();		//���Ʒ���
		var VendorId=Ext.getCmp("Vendor").getValue();				//��Ӫ��ҵid
		var OperateType=Ext.getCmp("OperateInType").getValue();		//�������
		
		var MinSp=Ext.getCmp("MinSp").getValue();				//����ۼ�
		var MaxSp=Ext.getCmp("MaxSp").getValue();				//����ۼ�
		var MinRp=Ext.getCmp("MinRp").getValue();				//��ͽ���
		var MaxRp=Ext.getCmp("MaxRp").getValue();				//��߽���
		var InvNo=Ext.getCmp("InvNo").getValue();				//��Ʊ��
		var SpFlag=Ext.getCmp("SpFlag").getValue();				//�����ۼ۲������ۼ۱�־
		if(SpFlag==true){
			SpFlag=1;
		}
		else{
			SpFlag=0;
		}
		var StatFlag=(Ext.getCmp("DateFlag").getValue()==true?'Y':'N');
		var Others=GrpType+"^"+StkCatId+"^"+IncRowid+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag
		+"^"+PbLevel+"^"+PhcCatId+"^"+PhcSubCatId+"^"+PhcMinCatId+"^"+ManfId+"^"+Form+"^"+InsuType+"^"+PosionCat
		+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp+"^"+MaxRp+"^"+InvNo+"^"+SpFlag+"^"+StatFlag+"^"+ImpNO+"^"+gNewCatId;
		
		var pageSize=PagingToolBar.pageSize;
		DetailStore.setBaseParam("LocId",LocId);
		DetailStore.setBaseParam("StartDate",StartDate);
		DetailStore.setBaseParam("EndDate",EndDate);
		DetailStore.setBaseParam("Others",Others);
		DetailStore.load({params:{start:0,limit:pageSize}});
		
			
	}
	var DetailStore=new Ext.data.JsonStore({
		autoDestroy:true,
		url:DictUrl+"ingdrecaction.csp?actiontype=jsQueryRecDetail",
		storeId:'DetailStore',
		remoteSort:true,
		idProperty:'',
		root:'rows',
		totalProperty:'results',
		fields:['IngrNo','InvNo','IngrCreateDate','InciCode','InciDesc','PurUom','Qty',
		'Rp','RpAmt','Sp','SpAmt','Vendor','BatNo','ExpDate','Manf','StkBin','InvDate','SpType',
		'PbFlag','PbLevel','InsuType','Status','IngrDate','Spec'],
		baseParams:{
			LocId:'',
			StartDate:'',
			EndDate:'',
			Others:''
		}
	});
	var nm=new Ext.grid.RowNumberer();
	var DetailCm=new Ext.grid.ColumnModel([nm,
		{
			header:$g('��ⵥ��'),
			dataIndex:'IngrNo',
			width:100,
			sortable:true
		},{
			header:$g('�Ƶ�����'),
			dataIndex:'IngrCreateDate',
			width:80,
			sortable:true
		},{
			header:$g('ҩƷ����'),
			dataIndex:'InciCode',
			width:100,
			sortable:false
		},{
			header:$g('ҩƷ����'),
			dataIndex:'InciDesc',
			width:100,
			sortable:true
		},{
			header:$g('��λ'),
			dataIndex:'PurUom',
			width:100,
			sortable:false
		},{
			header:$g('����'),
			dataIndex:'Qty',
			width:100,
			align:'right',
			sortable:false
		},{
			header:$g('����'),
			dataIndex:'Rp',
			width:100,
			align:'right',
			sortable:false
		},{
			header:$g('���۽��'),
			dataIndex:'RpAmt',
			width:100,
			align:'right',
			sortable:false
		},{
			header:$g('�ۼ�'),
			dataIndex:'Sp',
			width:100,
			align:'right',
			sortable:false
		},{
			header:$g('�ۼ۽��'),
			dataIndex:'SpAmt',
			width:100,
			align:'right',
			sortable:false
		},{
			header:$g('��Ӫ��ҵ'),
			dataIndex:'Vendor',
			width:100,
			sortable:true
		},{
			header:$g('����'),
			dataIndex:'BatNo',
			width:100,
			sortable:false
		},{
			header:$g('Ч��'),
			dataIndex:'ExpDate',
			width:100,
			sortable:false
		},{
			header:$g('������ҵ'),
			dataIndex:'Manf',
			width:100,
			sortable:false
		},{
			header:$g('��λ'),
			dataIndex:'StkBin',
			width:100,
			sortable:false
		},{
			header:$g('��Ʊ��'),
			dataIndex:'InvNo',
			width:100,
			sortable:false
		},{
			header:$g('��Ʊ����'),
			dataIndex:'InvDate',
			width:100,
			sortable:false
		},{
			header:$g('��������'),
			dataIndex:'SpType',
			width:100,
			sortable:false
		},{
			header:$g('�б��־'),
			dataIndex:'PbFlag',
			width:100,
			sortable:false
		},{
			header:$g('�б꼶��'),
			dataIndex:'PbLevel',
			width:100,
			sortable:false
		},{
			header:$g('ҽ�����'),
			dataIndex:'InsuType',
			width:100,
			sortable:false
		},{
			header:$g('����״̬'),
			dataIndex:'Status',
			width:100,
			sortable:false
		},{
			header:$g('�������'),
			dataIndex:'IngrDate',
			width:100,
			sortable:true
		},{
			header:$g('���'),
			dataIndex:'Spec',
			width:100,
			sortable:true
		}	
	]);
	
	var PagingToolBar=new Ext.PagingToolbar({
		id:'PagingToolBar',
		store:DetailStore,
		displayInfo:true,
		pageSize:PageSize,
		displayMsg:$g("��ǰ��¼{0}---{1}��  ��{2}����¼"),
		emptyMsg:$g("û������"),
		firstText:$g('��һҳ'),
		lastText:$g('���һҳ'),
		prevText:$g('��һҳ'),
		refreshText:$g('ˢ��'),
		nextText:$g('��һҳ')		
	});
	var DetailGrid=new Ext.grid.GridPanel({
		title:'�����ϸ',
		id:'DetailGrid',
		height : 180,
		store:DetailStore,
		loadMask:true,
		cm:DetailCm,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:PagingToolBar
	});
	
	var myForm=new Ext.form.FormPanel({
		id:'mainForm',
		title:$g('�����ϸ��ѯ---<font color=blue>��ɫ��ʾ��ѡ����</font>'),
		autoHeight:true,
		frame:true,
		labelAlign:'right',
		tbar:[searchBT,'-',clearBT],
		items:[{
			xtype:'fieldset',
			title:$g('��ѯ����'),
			layout:'column',
			style:DHCSTFormStyle.FrmPaddingV,
			defaults:{border:false},
			items:[{
				columnWidth:0.25,
				xtype:'fieldset',
				defaults:{width:200},
				labelWidth:60,
				items:[PhaLoc,DateFrom,DateTo,StkGrpType,DHCStkCatGroup,IncDesc]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				defaults:{width:120},
				labelWidth:60,
				items:[OperateInType,INFOImportFlag,PublicBidding,INFOPBLevel,MaxSp,InvNo]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				defaults:{width:180},
				labelWidth:60,
				items:[Vendor,PhManufacturer,PHCForm,INFOMT,MinSp,SpFlag]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				defaults:{width:180},
				labelWidth:60,
				items:[PHCDFPhcDoDR,ImpNO,MinRp,MaxRp,{xtype:'compositefield',width:240,items:[PHCCATALL,PHCCATALLButton]},DateFlag]
			}]
		}]
		
	});

	var view=new Ext.Viewport({
		layout:'border',
		items:[{
			region:'north',
			height:DHCSTFormStyle.FrmHeight(6),
			layout:'fit',
			items:myForm		
		},{
			region:'center',
			layout:'fit',
			items:DetailGrid
		}]
	});
	
	//��ȡurl����
	function getparastr(strname)
  {
   var hrefstr,pos,parastr,para,tempstr;
   hrefstr = window.location.href;
   pos = hrefstr.indexOf("?")
   parastr = hrefstr.substring(pos+1);
   para = parastr.split("&");
   tempstr="";
   for(i=0;i<para.length;i++)
   {
    tempstr = para[i];
    pos = tempstr.indexOf("=");
    if(tempstr.substring(0,pos) == strname)
    {
     return tempstr.substring(pos+1);
     }
   }
   return null;
  }

  function ExecQuery(){
  	var params=QueryParamsStr ; // getparastr("QueryParams");
  	if(params==null||(!params)){
  		return;
  	}
  	var arrparams=params.split(",");
  	if(arrparams[0]==null||arrparams[1]==null||arrparams[2]==null){
  		return;
  	}
  	
  	Ext.getCmp("PhaLoc").setValue(arrparams[0]);
  	//Ext.getCmp("PhaLoc").setRawValue(arrparams[6]);
  	Ext.getCmp("DateFrom").setValue(arrparams[1]);
  	Ext.getCmp("DateTo").setValue(arrparams[2]);
  	Ext.getCmp("InciDr").setValue(arrparams[3]);
  	var RetStr=tkMakeServerCall("web.DHCST.DHCINGdRecItm","GetDescByLocAndInci",arrparams[0]+"^"+arrparams[3])
  	var RetStrArr=RetStr.split("^")
  	Ext.getCmp("PhaLoc").setRawValue(RetStrArr[0]);
  	Ext.getCmp("IncDesc").setValue(RetStrArr[1]);
  	if(arrparams[5]==1){
  		Ext.getCmp("DateFlag").setValue(true);
  	}
  	Query();
  }
  
  ExecQuery();
});
