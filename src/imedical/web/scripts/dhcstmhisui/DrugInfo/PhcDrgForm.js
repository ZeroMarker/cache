var PHCDF="";
var INC_ROWID=""; 
function ShowPhc(inciRowId,Fn)
{	

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	if (inciRowId=='') return;

	PHCDF="";
	INC_ROWID=""; 
	PHCDF=GetPhcdf(inciRowId);  //���ҩѧ�ӱ�RowId
	if (PHCDF==-2)
	{
		Msg.info('error','����ά��ҽ���');
		return;
	}
	INC_ROWID=inciRowId;
  
   /*ҩѧ��rowid*/
	function GetPhcdf(inci)
	{
		var clsName="web.DHCSTMHUI.PHCDRGMAST";
		var methodName="GetPhcdf";
		var ret=tkMakeServerCall(clsName,methodName,inci) ;
		return ret;
	}
	
	/*��ά����ҩѧ��ʱ���Զ�ά��������λ*/
	function setBUom(inci)
	{
		var clsName="web.DHCSTMHUI.PHCDRGMAST";
		var methodName="GetBUom";
		var ret=tkMakeServerCall(clsName,methodName,inci) ;
		var ss=ret.split("^");
		var uom=ss[0];
		var uomDesc=ss[1];
		addComboData(CTUomStore,uom,uomDesc);
		Ext.getCmp("PHCDFCTUom").setValue(uom);
	
	}
	//��ѯҩѧ����Ϣ, 
	function retrievePhcDrgFrm(drgFrm)
	{
		if ((drgFrm ==null)||(drgFrm=="")||(drgFrm<0))
		{
			return;
		}
		var url = 'dhcstm.druginfomaintainaction.csp?actiontype=GetPhcDrgFrm&PhcdfId='+drgFrm;				

		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : '��ѯ��...',
			success : function(result, request) {
				var s = result.responseText;
				s=s.replace(/\r/g,"")
				s=s.replace(/\n/g,"") 
				var jsonData = Ext.util.JSON.decode(s);
				if (jsonData.success == 'true') {
					var ListData = jsonData.info;
					SetPhcDetail(ListData);
					SetFormOriginal(PHCDrgFormPanel);
					
				} else {
					Msg.info("error", "��ѯ����:"+jsonData.info);
				}
			},
			scope : this
		});
		
	}
	
	function SetPhcDetail(listData) {			
		if(listData==null || listData=="")
		{
			return;
		}
		var list=listData.split("^");
		if (list.length > 0) {			
			Ext.getCmp("PHCCCode").setValue(list[0]);
			Ext.getCmp("PHCCDesc").setValue(list[1]);
			addComboData(PhcFormStore,list[2],list[3]);
			Ext.getCmp("PHCForm").setValue(list[2]);
			addComboData(CTUomStore,list[4],list[5]);
			Ext.getCmp("PHCDFCTUom").setValue(list[4]);
			addComboData(PhcInStore,list[6],list[7]);
			Ext.getCmp("PHCDFPhCin").setValue(list[6]);
			addComboData(PhcDurationStore,list[8],list[9]);
			Ext.getCmp("PHCDuration").setValue(list[8]);
			Ext.getCmp("PHCDFBaseQty").setValue(list[10]);
			addComboData(PhManufacturerStore,list[11],list[12]);
			Ext.getCmp("PhManufacturer").setValue(list[11]);
			addComboData(PhcPoisonStore,list[13],list[14]);
			Ext.getCmp("PHCDFPhcDoDR").setValue(list[13]);
			//Ext.getCmp("").setValue(list[12]);  �޿��ҽ��
			addComboData(PhcFreqStore,list[15],list[16]);
			Ext.getCmp("PHCFreq").setValue(list[15]);
			Ext.getCmp("PHCDOfficialType").setValue(list[17]);
			addComboData(PhcGenericStore,list[18],list[19]);
			Ext.getCmp("PHCGeneric").setValue(list[18]);
			addComboData(PhcCatStore,list[20],list[21]);
			Ext.getCmp("PHCCat").setValue(list[20]);
			addComboData(PhcSubCatStore,list[22],list[23]);
			Ext.getCmp("PHCSubCat").setValue(list[22]);
			addComboData(PhcMinCatStore,list[24],list[25]);
			Ext.getCmp("PHCMinCat").setValue(list[24]);
			Ext.getCmp("PHCDLabelName11").setValue(list[26]);
			Ext.getCmp("PHCDLabelName12").setValue(list[27]);								
			Ext.getCmp("PHCDLabelName1").setValue(list[28]);
			Ext.getCmp("PHCDFOfficialCode1").setValue(list[29]);    //�Ƽ�ͨ����
			Ext.getCmp("PHCDFOfficialCode2").setValue(list[30]);	//ԭ��ͨ����
			Ext.getCmp("PHCDFDeductPartially").setValue(list[31]=='Y'?true:false);//סԺ��һ��������						
			Ext.getCmp("OpOneDay").setValue(list[32]=='Y'?true:false); //���ﰴһ��������
			Ext.getCmp("OpSkin").setValue(list[33]=='Y'?true:false); //����Ƥ��ԭҺ
			Ext.getCmp("IpSkin").setValue(list[34]=='Y'?true:false); //סԺƤ��ԭҺ
			Ext.getCmp("DDD").setValue(list[35]);		//DDDֵ	
			Ext.getCmp("EQQty").setValue(list[36]);		//��Ч����	
			Ext.getCmp("EQCTUom").setValue(list[37]);		//��Ч��λ
		}
	}	

	function clearData(){
		//ҩѧ��
		PHCCCode.setValue("");
		PHCCDesc.setValue("");
		PHCCat.setValue("");
		PHCCat.setRawValue("");
		PHCSubCat.setValue("");
		PHCSubCat.setRawValue("");
		PHCMinCat.setValue("");
		PHCMinCat.setRawValue("");
		PHCGeneric.setValue("");
		PHCGeneric.setRawValue("");
		PHCDFOfficialCode1.setValue("");
		PHCDFOfficialCode2.setValue("");
		PHCForm.setValue("");
		PHCForm.setRawValue("");	
		PHCDFCTUom.setValue("");
		PHCDFCTUom.setRawValue("");		
		PHCDFBaseQty.setValue("");
		PHCDFPhCin.setValue("");
		PHCDFPhCin.setRawValue("");
		EQCTUom.setValue("");
		EQQty.setValue("");
		PHCDLabelName1.setValue("");
		PhManufacturer.setValue("");
		PhManufacturer.setRawValue("");
		PHCFreq.setValue("");
		PHCFreq.setRawValue("");
		PHCDuration.setValue("");
		PHCDuration.setRawValue("");
		PHCDOfficialType.setValue("");
		PHCDOfficialType.setRawValue("");
		PHCDFPhcDoDR.setValue("");
		PHCDFPhcDoDR.setRawValue("");
		PHCDLabelName11.setValue("");
		PHCDLabelName12.setValue("");	
		OpSkin.setValue(false);
		IpSkin.setValue(false);
		OpOneDay.setValue(false);
		PHCDFDeductPartially.setValue(false);	
		DDD.setValue("");
		
	}
	

	var PHCCat = new Ext.ux.ComboBox({
		fieldLabel : '<font color=red>*����</font>',
		id : 'PHCCat',
		name : 'PHCCat',
		store : PhcCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PhccDesc'	 //����¼�����ݹ����������ݵĲ�������
	});

	PHCCat.on('change', function(e) {
		Ext.getCmp("PHCSubCat").setValue("");
		Ext.getCmp("PHCMinCat").setValue("");
	});

	var PHCSubCat = new Ext.ux.ComboBox({
		fieldLabel : '<font color=red>*�ӷ���</font>',
		id : 'PHCSubCat',
		name : 'PHCSubCat',
		store : PhcSubCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params : {PhcCatId:'PHCCat'}
	});

	PHCSubCat.on('change',function(e){
		Ext.getCmp("PHCMinCat").setValue("");
	});

	var PHCMinCat = new Ext.ux.ComboBox({
		fieldLabel : '��С����',
		id : 'PHCMinCat',
		name : 'PHCMinCat',
		store : PhcMinCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{PhcSubCatId:'PHCSubCat'}
	});

	var PHCGeneric = new Ext.ux.ComboBox({
		fieldLabel : '����ͨ����',
		//hidden:true,
		id : 'PHCGeneric',
		name : 'PHCGeneric',
		store : PhcGenericStore,
		anchor : '90%',
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PhcGeName'
	});
	
	//wyx add 2014-02-21 ���ӳ��̵�ά��
	var PhcGenericButton = new Ext.Button({
		id:'PhcGenericButton',
		anchor : '90%',
		text : '...',
		handler : function() {
		  var lnk="dhc.bdp.ext.default.csp?extfilename=App/Pharmacy/Phc_generic";
			 //location.href=lnk;
			 window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
			//PhcGenericMt();
		}
	});
	var PHCForm = new Ext.ux.ComboBox({
		fieldLabel:'<font color=red>*����</font>',
		id:'PHCForm',
		name : 'PHCForm',
		store : PhcFormStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHCFDesc',
		listeners : {
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'PHCDFCTUom');			
			}
		}
	});


	var PHCDFCTUom = new Ext.ux.ComboBox({
		fieldLabel : '<font color=red>*������λ</font>',
		id : 'PHCDFCTUom',
		name : 'PHCDFCTUom',
		store : CTUomStore,
		disabled:true,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'CTUomDesc',
		listeners : {
			'change' : function(e) {
				var phcuom=Ext.getCmp('PHCDFCTUom').getValue();
				var phcuomdesc=Ext.getCmp('PHCDFCTUom').getRawValue();
				if(phcuom!=""){
					//����������λ��ҩѧ��Ļ�����λһ��
					Ext.getCmp('INCICTUom').setValue(phcuom);
				}
			},
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'PHCDFPhCin');			
			}
		}
	});

	var PHCDFBaseQty = new Ext.form.NumberField({
		fieldLabel : '��������',
		id : 'PHCDFBaseQty',
		name : 'PHCDFBaseQty',
		anchor : '90%',
		allowNegative : false,
		selectOnFocus : true
	});

	var PHCDFOfficialCode1 = new Ext.form.TextField({
		fieldLabel : '�Ƽ�ͨ����',
		hidden:true,
		id : 'PHCDFOfficialCode1',
		name : 'PHCDFOfficialCode1',
		anchor : '90%',
		valueNotFoundText : ''
	});

	var PhcInStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : 'dhcstm.drugutil.csp?actiontype=PHCInstruc'
		}),
		reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
	});
	var PHCDFPhCin = new Ext.ux.ComboBox({
		fieldLabel : '<font color=red>*�÷�</font>',
		id : 'PHCDFPhCin',
		name : 'PHCDFPhCin',
		store : PhcInStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHCInDesc',
		listeners : {
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'PHCDuration');			
			}
		}
	});

	var EQCTUom = new Ext.form.TextField({
		fieldLabel : '��Ч��λ',
		id : 'EQCTUom',
		disabled:true,
		name : 'EQCTUom',
		anchor : '90%',
		readOnly : true,
		valueNotFoundText : ''
	});

	var eqCTUomButton = new Ext.Button({
		id:'PhcEquivButton',
		text : '��Ч��λ',
		handler : function() {
			var rowid=INC_ROWID;
			if(rowid!=""){
				DoseEquivEdit("", rowid,refresh);	
			}else
			{
				Msg.info("warning","��ѡ����Ҫά����Ч��λ��ҩѧ��!");
				return;
			}
		}
	});
	function refresh()
	{
		retrievePhcDrgFrm(PHCDF);
	}
	
	var EQQty = new Ext.form.NumberField({
		fieldLabel : '��Ч����',
		disabled:true,
		id : 'EQQty',
		name : 'EQQty',
		anchor : '90%',
		readOnly : true,
		allowNegative : false,
		selectOnFocus : true
	});

	var PHCDFOfficialCode2 = new Ext.form.TextField({
		fieldLabel : 'ԭ��ͨ����',
		hidden:true,
		id : 'PHCDFOfficialCode2',
		name : 'PHCDFOfficialCode2',
		anchor : '90%',
		valueNotFoundText : ''
	});

	var PHCFreq = new Ext.ux.ComboBox({
		fieldLabel : 'Ƶ��',
		id : 'PHCFreq',
		name : 'PHCFreq',
		store : PhcFreqStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PhcFrDesc'
	});

	var PhManufacturer = new Ext.ux.ComboBox({
		fieldLabel : '����',
		hidden:true,
		id : 'PhManufacturer',
		name : 'PhManufacturer',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName'
	});

	var PHCDuration = new Ext.ux.ComboBox({
		fieldLabel : '<font color=red>*�Ƴ�</font>',
		id : 'PHCDuration',
		name : 'PHCDuration',
		store : PhcDurationStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PhcDuDesc',
		listeners : {
			'specialkey':function(field,e){
				//talPanel.setActiveTab(1);
				SpecialKeyHandler(e,'ARCBillGrp');			
			}
		}
	});

	OfficeCodeStore.load();
	var PHCDOfficialType = new Ext.ux.ComboBox({
		fieldLabel : 'ҽ�����',
		hidden:true,
		id : 'PHCDOfficialType',
		name : 'PHCDOfficialType',
		mode:'local',
		store : OfficeCodeStore,
		valueField : 'RowId',
		displayField : 'Description'
	});

	var PHCDFPhcDoDR = new Ext.ux.ComboBox({
		fieldLabel : '���Ʒ���',
		hidden:true,
		id : 'PHCDFPhcDoDR',
		name : 'PHCDFPhcDoDR',
		store : PhcPoisonStore,
		valueField : 'RowId',
		displayField : 'Description'
	});

	var PHCDLabelName11 = new Ext.form.TextField({
		fieldLabel : 'Ӣ�Ĺ��ʷ�ר��ҩ��',
		id : 'PHCDLabelName11',
		name : 'PHCDLabelName11',
		anchor : '90%',
		valueNotFoundText : ''
	});

	var PHCDLabelName12 = new Ext.form.TextField({
		fieldLabel : '����ר��ҩ��',
		id : 'PHCDLabelName12',
		name : 'PHCDLabelName12',
		anchor : '90%',
		valueNotFoundText : ''
	});

	var PHCDLabelName1 = new Ext.form.TextField({
		fieldLabel : '��Ʒ��',
		hidden:true,
		id : 'PHCDLabelName1',
		name : 'PHCDLabelName1',
		anchor : '90%',
		valueNotFoundText : ''
	});

	var OpSkin = new Ext.form.Checkbox({
		fieldLabel : '����Ƥ����ԭҺ',
		id : 'OpSkin',
		name : 'OpSkin',
		anchor : '90%',
		checked : false
	});

	var IpSkin = new Ext.form.Checkbox({
		fieldLabel : 'סԺƤ����ԭҺ',
		id : 'IpSkin',
		name : 'IpSkin',
		anchor : '90%',
		checked : false
	});

	var OpOneDay = new Ext.form.Checkbox({
		fieldLabel : '���ﰴһ��������',
		id : 'OpOneDay',
		name : 'OpOneDay',
		anchor : '90%',
		checked : false
	});

	var PHCDFDeductPartially = new Ext.form.Checkbox({
		fieldLabel : 'סԺ��һ��������',
		id : 'PHCDFDeductPartially',
		name : 'PHCDFDeductPartially',
		anchor : '90%',
		checked : false
	});
		
	var DDD = new Ext.form.TextField({
		fieldLabel : 'DDDֵ',
		id : 'DDD',
		name : 'DDD',
		anchor : '90%',
		valueNotFoundText : ''
	});

	var PHCCCode = new Ext.form.TextField({
		fieldLabel : '<font color=red>*ҩѧ����</font>',
		id : 'PHCCCode',
		name : 'PHCCCode',
		anchor : '90%',
		valueNotFoundText : '',
		listeners : {
			'blur' : function(e) {
				CopyCode(Ext.getCmp('PHCCCode').getRawValue());
			},
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'PHCCDesc');
			}
		}
	});

	var PHCCDesc = new Ext.form.TextField({
		fieldLabel : '<font color=red>*ҩѧ����</font>',
		id : 'PHCCDesc',
		name : 'PHCCDesc',
		anchor : '90%',
		valueNotFoundText : '',
		listeners : {
			'blur' : function(e) {
				CopyDesc(Ext.getCmp('PHCCDesc').getRawValue());
			},
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'PHCForm');
			}
		}
	});
	
	// ҩѧ��Panel
	var PHCDrgFormPanel = new Ext.form.FormPanel({
		labelWidth : 80,
		labelAlign : 'right',
		frame : true,
		//autoScroll:true,
		layout:'fit',
		items : [
		 {
			 layout : 'column',
			 xtype:'fieldset',
			 style:'padding:5px 0px 0px 0px',
			 defaults:{border:false},		 
			 items : [
			 {
				 columnWidth : 0.5,
				 xtype:'fieldset',
				 items : [PHCCCode,/*PHCCat,PHCMinCat,*/PHCDFOfficialCode1,PHCForm,PHCDFBaseQty,
				 {xtype:'compositefield',items:[EQCTUom,eqCTUomButton]},PHCDLabelName1,PHCFreq,
				 PHCDOfficialType/*,PHCDLabelName11,DDD*/]
			 }
			 ,
			 {
				columnWidth : 0.5,
				xtype:'fieldset',
				items : [PHCCDesc,/*PHCSubCat,*/{xtype:'compositefield',items:[PHCGeneric,PhcGenericButton]},PHCDFOfficialCode2,PHCDFCTUom,PHCDFPhCin,EQQty,
				PhManufacturer,PHCDuration,PHCDFPhcDoDR/*,PHCDLabelName12*/]
			 }
			]				
		}
		/*,
		{
			layout:'column',
			xtype:'fieldset',
			labelWidth:120,
			style:'padding:10px 0px 0px 0px',
			defaults:{border:false},
			items:[{
				columnWidth:0.25,
				xtype:'fieldset',
				items:[OpSkin]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				items:[OpOneDay]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				items:[IpSkin]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				items:[PHCDFDeductPartially]
			}]
		}
		*/
		]
	}); 

	// ���水ť
	var SaveBT = new Ext.Toolbar.Button({
		id : "SaveBT",
		text : '����',
		tooltip : '�������',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			var data=getPhcList();
			savePhcData(PHCDF,data,INC_ROWID)
		}
	});
	function savePhcData(drgFrm,data,inci)
	{
		var url = 'dhcstm.druginfomaintainaction.csp?actiontype=SavePhcDrgFrm';			
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{PhcdfId:drgFrm,Data:data,inci:inci},
			waitMsg : '��ѯ��...',
			success : function(result, request) {
				var s = result.responseText;
	
				var jsonData = Ext.util.JSON.decode(s);
				if (jsonData.success == 'true') {
					var drgFrm = jsonData.info;
					Msg.info("success", "����ɹ���");
					retrievePhcDrgFrm(drgFrm);
				} else {
					if(jsonData.info==-61){Msg.info("error", "����Ϊ��!");}
					else if(jsonData.info==-62){Msg.info("error", "����Ϊ��!");}
					else if(jsonData.info==-63){Msg.info("error", "����Ϊ��!");}
					else if(jsonData.info==-64){Msg.info("error", "��λΪ��!");}
					else if(jsonData.info==-65){Msg.info("error", "�÷�Ϊ��!");}
					else if(jsonData.info==-51){Msg.info("error", "����ҩѧ������ʧ��!");}
					else if(jsonData.info==-62){Msg.info("error", "����ҩѧ���ӱ�ʧ��!");}
					else if(jsonData.info==-66){Msg.info("error", "��Ч��ҩѧ����ࡢ�ӷ���!");}
					else if(jsonData.info==-67){Msg.info("error", "��Ч��ҩѧС����!");}
					else if(jsonData.info==-68){Msg.info("error", "��Ч�Ĺ��Ʒ���!");}
					else if(jsonData.info==-69){Msg.info("error", "��Ч�Ĳ���!");}
					else if(jsonData.info==-70){Msg.info("error", "��Ч��ͨ����!");}
					else if(jsonData.info==-71){Msg.info("error", "��Ч�ļ���!");}
					else if(jsonData.info==-72){Msg.info("error", "��Ч��Ƶ��!");}
					else if(jsonData.info==-73){Msg.info("error", "��Ч���÷�!");}
					else if(jsonData.info==-74){Msg.info("error", "��Ч���Ƴ�!");}
					else if(jsonData.info==-75){Msg.info("error", "��Ч�Ļ�����λ!");}
					else if(jsonData.info==-76){Msg.info("error", "ҩѧ������ظ�!");}
					else if(jsonData.info==-77){Msg.info("error", "ҩѧ�������ظ�!");}
				}
			},
			scope : this
		});
	
	}
	
	// �رհ�ť
	var closeBT = new Ext.Toolbar.Button({
		text : '�ر�',
		tooltip : '�رս���',
		iconCls : 'page_delete',
		height:30,
		width:70,
		handler : function() {
			x.close();
		}
	});	
	function getPhcList(){	
		// ҩѧ�����ݴ�:����^����^����id^������λid^�÷�id^�Ƴ�id^��������^����id^���Ʒ���id^Ƶ��id^ҽ�����^����ͨ����^ҩѧ����id^ҩѧ����id^ҩѧС��id
		// ^Ӣ�Ĺ��ʷ�ר��ҩ��^����ר��ҩ��^��Ʒ��^�Ƽ�ͨ����^ԭ��ͨ����^סԺ��һ��������^���ﰴһ��������^����Ƥ����ԭҺ^סԺƤ����ԭҺ^DDDֵ
		
		//ҩѧ����Ϣ
		var PhcCode = Ext.getCmp("PHCCCode").getValue();  //����
		var PhcDesc=Ext.getCmp("PHCCDesc").getValue(); //����
		var FormId=Ext.getCmp("PHCForm").getValue(); //����
		var BuomId=Ext.getCmp("PHCDFCTUom").getValue(); //������λ
		var InstId=Ext.getCmp("PHCDFPhCin").getValue(); //�÷�
		var DuraId=Ext.getCmp("PHCDuration").getValue(); //�Ƴ�
		var BQty=Ext.getCmp("PHCDFBaseQty").getValue(); //��������
		var ManfId=Ext.getCmp("PhManufacturer").getValue(); //����
		var PosionId=Ext.getCmp("PHCDFPhcDoDR").getValue(); //���Ʒ���
		var FreqId=Ext.getCmp("PHCFreq").getValue(); //Ƶ��
		var InsuType=Ext.getCmp("PHCDOfficialType").getValue(); //ҽ�����
		var GenericId=Ext.getCmp("PHCGeneric").getValue(); //����ͨ����
		var PhcCatId=Ext.getCmp("PHCCat").getValue(); //ҩѧ����
		var PhcSubCatId = Ext.getCmp("PHCSubCat").getValue(); //ҩѧ����
		var PhcMinCatId=Ext.getCmp("PHCMinCat").getValue(); //ҩѧС��
		var LabelName11=Ext.getCmp("PHCDLabelName11").getValue();			//Ӣ�Ĺ��ʷ�ר��ҩ��
		var LabelName12=Ext.getCmp("PHCDLabelName12").getValue();   	//����ר��ҩ��
		var GoodName=Ext.getCmp("PHCDLabelName1").getValue(); //��Ʒ��
		var FregenName=Ext.getCmp("PHCDFOfficialCode1").getValue();		//�Ƽ�ͨ����
		var FregenName2=Ext.getCmp("PHCDFOfficialCode2").getValue();	//ԭ��ͨ����
		var partially=(Ext.getCmp("PHCDFDeductPartially").getValue()==true?'Y':'N'); //סԺ��һ��������
		var OpOneDay=(Ext.getCmp("OpOneDay").getValue()==true?'Y':'N'); //���ﰴһ��������
		var OpSkin=(Ext.getCmp("OpSkin").getValue()==true?'Y':'N'); //����Ƥ����ԭҺ
		var IpSkin=(Ext.getCmp("IpSkin").getValue()==true?'Y':'N'); //סԺƤ����ԭҺ
		var DDD=Ext.getCmp("DDD").getValue(); //DDDֵ
		
		var listPhc=PhcCode+"^"+PhcDesc+"^"+FormId+"^"+BuomId+"^"+InstId+"^"+DuraId+"^"+BQty+"^"+ManfId+"^"+PosionId+"^"+FreqId+"^"+InsuType+"^"+
		GenericId+"^"+PhcCatId+"^"+PhcSubCatId+"^"+PhcMinCatId+"^"+LabelName11+"^"+LabelName12+"^"+GoodName+"^"+FregenName+"^"+FregenName2+"^"+partially+"^"+OpOneDay+"^"+OpSkin+"^"+IpSkin+"^"+DDD+"^"+userId;

		return listPhc;
		
	}

	var x = new Ext.Window({
		title : 'ҩѧ��',
		id:'drgfrm',
		width :600,
		height : 300,
		minHeight:300,
		modal:true,
		layout : 'fit',
		items : [PHCDrgFormPanel],
		tbar : [  SaveBT/*, '-', DeleteBT, '-'*/, closeBT],
		listeners:
		{'show':function()
			{
				if (PHCDF!=""){
					retrievePhcDrgFrm(PHCDF);
				}
				else
				{
					clearData();
					//ȱʡ���õ�λ
					setBUom(INC_ROWID);
				}
			}
		}
	});

	x.show();
	
	
}