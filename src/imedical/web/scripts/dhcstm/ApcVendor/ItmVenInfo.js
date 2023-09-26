
//创建编辑窗口(弹出)
//rowid :供应商rowid
var remarkWindow;
var list='';
function CreateEditWin(List){
	list=List;
	if(remarkWindow){
		remarkWindow.show();
		return;
	}
	
	//厂商代码
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel:'<font color=red>厂商代码</font>',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'厂商代码...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	//厂商名称
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel:'<font color=red>厂商名称</font>',
		allowBlank:false,
		width:150,
		listWidth:150,
		//emptyText:'厂商名称...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	})	
	//厂商地址
	var addressField = new Ext.form.TextField({
		id:'addressField',
		fieldLabel:'厂商地址',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'厂商地址...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	//厂商电话
	var phoneField = new Ext.form.TextField({
		id:'phoneField',
		fieldLabel:'厂商电话',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'厂商电话...',
		anchor:'90%',
		regex:/^[^\u4e00-\u9fa5]{0,}$/,
		regexText:'不正确的电话号码',
		disabled:true,
		selectOnFocus:true
	});
	
	//上级厂商
	var lastPhManfField = new Ext.form.ComboBox({
		id:'lastPhManfField',
		fieldLabel:'上级厂商',
		anchor:'90%',
		allowBlank:true,
		store:PhManufacturerStore,
		valueField:'RowId',
		displayField:'Description',
		//emptyText:'上级厂商...',
		triggerAction:'all',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		disabled:true,
		editable:true
	});
	
	//药物生产许可
	var drugProductPermitField = new Ext.form.TextField({
		id:'drugProductPermitField',
		fieldLabel:'药物生产许可',
		width:200,
		listWidth:200,
		//emptyText:'药物生产许可...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//药物生产许可有效期
	var drugProductExpDate = new Ext.ux.DateField({ 
		id:'drugProductExpDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100,  
		disabled:true
	});  
	
	//材料生产许可
	var matProductPermitField = new Ext.form.TextField({
		id:'matProductPermitField',
		fieldLabel:'材料生产许可',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'材料生产许可...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//材料生产许可有效期
	var matProductExpDate = new Ext.ux.DateField({ 
		id:'matProductExpDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100, 
		disabled:true
	});
	
	//工商执照许可
	var comLicField = new Ext.form.TextField({
		id:'comLicField',
		fieldLabel:'工商执照许可',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'工商执照许可...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//工商执照许可有效期
	var comLicExpDate = new Ext.ux.DateField({ 
		id:'comLicExpDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100, 
		disabled:true
	});
	//工商注册号
	var BusinessRegNoField = new Ext.form.TextField({
		id:'BusinessRegNoField',
		fieldLabel:'工商注册号',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'工商注册号...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//工商注册号有效期
	var BusinessRegExpDate = new Ext.ux.DateField({ 
		id:'BusinessRegExpDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100, 
		disabled:true
	});
	//组织机构代码
	var OrgCodeField = new Ext.form.TextField({
		id:'OrgCodeField',
		fieldLabel:'组织机构代码',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'组织机构代码...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//组织机构代码有效期
	var OrgCodeExpDate = new Ext.ux.DateField({ 
		id:'OrgCodeExpDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100,  
		disabled:true
	});
	//税务登记号
	var TaxRegNoField = new Ext.form.TextField({
		id:'TaxRegNoField',
		fieldLabel:'税务登记号',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'税务登记号...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
		//激活
	var activeField = new Ext.form.Checkbox({
		id: 'activeField',
		fieldLabel:'激活',
		hideLabel:false,
		allowBlank:false,
		disabled:true,
		checked:true  //默认是"激活"状态
	})
	//资质信息
	//商标
	var LabelField = new Ext.form.TextField({
		id:'LabelField',
		fieldLabel:'商标',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'商标...',
		anchor:'90%',
		selectOnFocus:true
	});
	//原批准文号
	var LastTextField = new Ext.form.TextField({
		id:'LastTextField',
		fieldLabel:'原批准文号',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'原批准文号...',
		anchor:'90%',
		selectOnFocus:true
	});
	//药品批准文号（医疗器械注册证号）
	var NewTextField = new Ext.form.TextField({
		id:'NewTextField',
		fieldLabel:'批准文号',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'批准文号...',
		anchor:'90%',
		selectOnFocus:true
	});
	//批准文号（注册证号）有效期
	var TextExpDate = new Ext.ux.DateField({ 
		id:'TextExpDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	//修改日期
	var UpDate = new Ext.ux.DateField({ 
		id:'UpDate',
		fieldLabel:'修改日期',  
		allowBlank:true,
		width:298,
		listWidth:298   
	});
	var UpUserFieldStore=new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			                url : DictUrl
								+ 'itmvenaction.csp?actiontype=GroupUser&start=0&limit=999'
					}),
		baseParams:{'GrpDesc':'物资库管'},
		reader:new Ext.data.JsonReader({
			totalProperty : "results",
						root : 'rows'
					}, ['Name', 'Rowid'])			
		})
	
       UpUserFieldStore.load();
		// 修改人
	var UpUserField=new Ext.form.ComboBox({
		fieldLabel:'修改人',
		id:'UpUserField',
		name:'UpUserField',
		anchor : '90%',
		store : UpUserFieldStore,
		disabled:true,
		valueField : 'Rowid',
		displayField : 'Name',
		triggerAction : 'all',
		valueNotFoundText : ''
	});

	//认证情况
	var CertificatField = new Ext.form.TextField({
		id:'CertificatField',
		fieldLabel:'认证情况',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'认证情况...',
		anchor:'90%',
		selectOnFocus:true
	});
   //进口注册证书
	var RegCertNoField = new Ext.form.TextField({
		id:'RegCertNoField',
		fieldLabel:'进口注册证书',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'进口注册证书...',
		anchor:'90%',
		selectOnFocus:true
	});
	//进口注册证效期 
	var RegCertExpDate = new Ext.ux.DateField({ 
		id:'RegCertExpDate',
		fieldLabel:'有效期',  
		allowBlank:true,
		width:100,
		listWidth:100   
	});
	//厂商

	//初始化添加按钮
	var okButton = new Ext.Toolbar.Button({
		text:'确定',
		handler:function(){	
		  	var ss=getVendorDataStr();
			if (typeof(ss)=='undefined' || ss==""){return;}
			if (list!='') {
				ss=list+'^'+ss;
				//UpdVendorInfo(ss);  //执行更新
				InsVendorInfo(ss); 
			}
		}
	});
	
	//初始化取消按钮
	var cancelButton = new Ext.Toolbar.Button({
		text:'取消',
		handler:function(){
			//alert(Ext.getCmp('codeField').getValue());
			if (remarkWindow){
				remarkWindow.hide();
			}
		}
	});
	
	//初始化面板
	var vendorPanel = new Ext.form.FormPanel({
		labelwidth : 30,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		items : [{
			xtype : 'fieldset',
			title : '基本信息',
			autoHeight : true,
			items : [{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[codeField]},
						{columnWidth:.5,layout:'form',items:[nameField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[drugProductPermitField]},
						{columnWidth:.5,layout:'form',items:[drugProductExpDate ]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[matProductPermitField]},
						{columnWidth:.5,layout:'form',items:[matProductExpDate]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[comLicField]},
						{columnWidth:.5,layout:'form',items:[comLicExpDate]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[BusinessRegNoField]},  
						{columnWidth:.5,layout:'form',items:[BusinessRegExpDate]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[OrgCodeField]},
						{columnWidth:.5,layout:'form',items:[OrgCodeExpDate]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[TaxRegNoField]},  
						{columnWidth:.5,layout:'form',items:[lastPhManfField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[phoneField]},
						{columnWidth:.4,layout:'form',items:[addressField]},
						{columnWidth:.3,layout:'form',items:[activeField]}
					]
				}]
			},{
				xtype : 'fieldset',
				title : '资质信息',
				autoHeight : true,
				items : [{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[LabelField]},
						{columnWidth:.5,layout:'form',items:[LastTextField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[NewTextField]},
                        {columnWidth:.5,layout:'form',items:[TextExpDate]}
					]
				},{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[UpUserField]},
						{columnWidth:.5,layout:'form',items:[CertificatField]}
					]
				},{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[RegCertNoField]},
						{columnWidth:.5,layout:'form',items:[RegCertExpDate]}
					]
				}]
		}]
	});
	
	
	//初始化窗口
	remarkWindow = new Ext.Window({
		closeAction:'hide',
		title:'物资厂商信息',
		width:900,
		height:500,
		minWidth:900,
		minHeight:500,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'right',
		items:vendorPanel,
		buttons:[okButton, cancelButton],
		listeners:{
			'show':function(){
				if (list!=''){
					SetVendorInfo(list);
				}
			},
			'close' : function(p){
				remarkWindow=null;
			}
		}
	});
	remarkWindow.show();

	//显示供应商信息
	function SetVendorInfo(list){
		Ext.Ajax.request({
			url: APCVendorGridUrl+'?actiontype=select&list='+list,
			failure: function(result, request) {
				Msg.info("error",'失败！');
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					var value = jsonData.info;
					var arr = value.split("^");
					//基础信息
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					Ext.getCmp('drugProductPermitField').setValue(arr[2]);
					Ext.getCmp('drugProductExpDate').setRawValue(arr[3]);
					Ext.getCmp('matProductPermitField').setValue(arr[4]);
					Ext.getCmp('matProductExpDate').setValue(arr[5]);
					Ext.getCmp('comLicField').setValue(arr[6]);
					Ext.getCmp('comLicExpDate').setValue(arr[7]);
					Ext.getCmp('BusinessRegNoField').setValue(arr[8]);
					Ext.getCmp('BusinessRegExpDate').setValue(arr[9]);
					Ext.getCmp('OrgCodeField').setValue(arr[10]);
					Ext.getCmp('OrgCodeExpDate').setValue(arr[11]);
					Ext.getCmp('TaxRegNoField').setValue(arr[12]);
					Ext.getCmp('activeField').setValue(arr[16]=="Y"?true:false);
					addComboData(lastPhManfField.getStore(), arr[13],arr[26]);
					Ext.getCmp('lastPhManfField').setValue(arr[13]);
					Ext.getCmp('phoneField').setValue(arr[14]);
					Ext.getCmp('addressField').setValue(arr[15]);
					//资质信息
					Ext.getCmp('LabelField').setValue(arr[17]);
					Ext.getCmp('LastTextField').setValue(arr[18]);
					Ext.getCmp('NewTextField').setValue(arr[19]);
					Ext.getCmp('TextExpDate').setValue(arr[20]);
					Ext.getCmp('UpUserField').setValue(arr[21]);
					Ext.getCmp('UpUserField').setRawValue(arr[22]);
					Ext.getCmp('CertificatField').setValue(arr[23]);
					Ext.getCmp('RegCertNoField').setValue(arr[24]);
					Ext.getCmp('RegCertExpDate').setValue(arr[25]);
				}
			},
			scope: this
		});
	}
	
	//取得供应商串
	function  getVendorDataStr(){
		//厂商资质
		var Label=LabelField.getValue();  //商标 
		var LastText=LastTextField.getValue(); //原器械注册证号
		var NewText=NewTextField.getValue();  //器械注册证号 
		var TextExpDate = Ext.getCmp('TextExpDate').getValue();  //有效期
		if((TextExpDate!="")&&(TextExpDate!=null)){
			TextExpDate = TextExpDate.format(ARG_DATEFORMAT);
		}
		var UpDate = Ext.getCmp('UpDate').getValue();  //修改日期
		var UpDate="";
		if((UpDate!="")&&(UpDate!=null)){
			UpDate = UpDate.format(ARG_DATEFORMAT);
		}
		//var UpUser=UpUserField.getValue(); // 修改人gUserId
		var UpUser=gUserId;
		var Certificat=CertificatField.getValue(); //认证情况
		var RegCertNo=RegCertNoField.getValue();  //进口注册证书
		var RegCertExpDate = Ext.getCmp('RegCertExpDate').getValue();  //进口注册证效期
		if((RegCertExpDate!="")&&(RegCertExpDate!=null)){
			RegCertExpDate = RegCertExpDate.format(ARG_DATEFORMAT);
		}
		//拼data字符串
		var data=Label+"^"+LastText+"^"+NewText+"^"+TextExpDate+"^"+UpDate+"^"+UpUser+"^"+Certificat
		         +"^"+RegCertNo+"^"+RegCertExpDate;
		
		return data;
	}
 
	//插入供应商
	function InsVendorInfo(data){
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url: APCVendorGridUrl+'?actiontype=insert',
			params : {data:data},
			method:'post',
			waitMsg:'处理中...',
			failure: function(result, request) {
				Msg.info("error","请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				 mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success", "保存成功!");
					remarkWindow.close();
				}else{
					if(jsonData.info==-1){
						Msg.info("error","名称和代码重复!");
					}else if(jsonData.info==-2){
						Msg.info("error","代码重复!");
					}else if(jsonData.info==-3){
						Msg.info("error","名称重复!");
					}else{
						Msg.info("error", "保存失败!");
					}
				}
			},
			scope: this
		});	
	}
}	