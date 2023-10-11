AcctBook=IsExistAcctBook();


//��������ı���
var RepCodeFiled = new Ext.form.TextField({
            id:'RepCodeFiled',
			columnWidth : .1,
			width : 120,
			columnWidth : .12,
			selectOnFocus : true

		});
//���������ı���
var RepNameFiled = new Ext.form.TextField({
            id:'RepNameFiled',
			columnWidth : .1,
			width : 120,
			columnWidth : .12,
			selectOnFocus : true

		});

//�±���ѡ��
var MRepCheckbox = new Ext.form.Checkbox({ 
            id : 'MRepCheckbox', 
            name : "MRepCheckbox", 
            autoScroll : false, 
			//height:4,
            //width : 90, 
            anchor : "70%", 
            hideLabel : true
});

//������ѡ��
var QRepCheckbox = new Ext.form.Checkbox({ 
            id : 'QRepCheckbox', 
            name : "QRepCheckbox", 
            autoScroll : false, 
			//height:4,
            //width : 90, 
            anchor : "70%", 
            hideLabel : true
});

//���걨��ѡ��
var SRepCheckbox = new Ext.form.Checkbox({ 
            id : 'SRepCheckbox', 
            name : "SRepCheckbox", 
            //autoScroll : false, 
            anchor : "70%", 
            hideLabel : true
});
	
//�걨��ѡ��
var YRepCheckbox = new Ext.form.Checkbox({ 
            id : 'YRepCheckbox', 
            name : "YRepCheckbox", 
            autoScroll : false, 
			//height:4,
            //width : 90, 
            anchor : "70%", 
            hideLabel : true
});		

//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'find',
	handler: function(){
				//alert(year);
				var repCode=RepCodeFiled.getValue();
				var repName=RepNameFiled.getValue();
				itemMain.load({params : {start:0,limit:25,ReportCode:repCode,ReportName:repName,AcctBook:AcctBook}});
	}
});

//�������
var RepTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '����'], ['1', '�Զ���']]
		});
var RepTypeField = new Ext.form.ComboBox({
			id : 'RepTypeField',
			fieldLabel : '�������',
			width : 70,
			listWidth : 125,
			selectOnFocus : true,
			allowBlank : true,
			store : RepTypeStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
				


var BudgProAdditionalUrl = '../csp/herp.budg.budgproadditionalmainexe.csp';
var userid = session['LOGON.USERID'];

var queryPanel = new Ext.FormPanel({
	     title: '����ģ��ά��',
	     iconCls:'maintain',
		region: 'north',
		height: 75,
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px '
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '�������',
						style: 'padding:0 5px;'
						//width: 60
					}, RepCodeFiled,  {
						xtype: 'displayfield',
						value: '',
						width: 40
					}, {
						xtype: 'displayfield',
						value: '��������',
						style: 'padding:0 5px;'
						//width: 60
					}, RepNameFiled, {
						xtype: 'displayfield',
						value: '',
						width: 40
					}, 
					findButton
				]
			}
		]

	});
	
var itemMain = new dhc.herp.Grid({
    //title: '����ģ��ά��',
	//iconCls:'maintain',
    region : 'center',
    atLoad : false, // �Ƿ��Զ�ˢ��
    url: 'herp.acct.reportempletaddexe.csp',
    viewConfig : {forceFit : true},
	//tbar : ['�������', RepCodeFiled,'-','��������', RepNameFiled, '-', findButton],
	listeners :{
		'cellclick':function(grid, rowIndex, columnIndex, e) {
			var record = grid.getStore().getAt(rowIndex);
			var CheckState=record.get("CheckState")
			//alert(CheckState);
			if((CheckState=="���")&&((columnIndex==9)||(columnIndex==2)||(columnIndex==3)||(columnIndex==4)||(columnIndex==5)||(columnIndex==6)||(columnIndex==7)||(columnIndex==8)||(columnIndex==10))){
				//YRepCheckbox.disable();
				//itemMain.btnSaveHide();
				return false;
			}else{return true;}
			 
		},
		
		'celldblclick':function(grid, rowIndex, columnIndex, e) {
			var record = grid.getStore().getAt(rowIndex);
			var CheckState=record.get("CheckState")
			//alert(CheckState);
			if((CheckState=="���")&&((columnIndex==9)||(columnIndex==2)||(columnIndex==3)||(columnIndex==4)||(columnIndex==5)||(columnIndex==6)||(columnIndex==7)||(columnIndex==8)||(columnIndex==10))){
				 return false;
			}else{return true;}
			 
		}
		
	},
    fields: [
    //new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'ReportCode',
						header : '�������',
						dataIndex : 'ReportCode',
						width : 80,
						editable:true,
						allowBlank : false,
						hidden : false

					}, {
						id : 'ReportName',
						header : '��������',
						width : 150,
						editable:true,
						allowBlank : false,
						dataIndex : 'ReportName'

					}, {
						id : 'ReportType',
						header : '�������',
						align : 'center',
						width : 120,
						editable:true,
						type:RepTypeField,
						allowBlank : true,
						dataIndex : 'ReportType'

					},{
						id : 'MonthReport',
						header : '�±�',
						editable:true,
						align : 'center',
						type:MRepCheckbox,
						renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//����ֵ����checkbox�Ƿ�ѡ
						width : 60,
						dataIndex : 'MonthReport'

					}, {
						id : 'QuartReport',
						header : '����',
						editable:true,
						align : 'center',
						width : 60,
						type:QRepCheckbox,
						renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//����ֵ����checkbox�Ƿ�ѡ
						dataIndex : 'QuartReport'

					}, {
					    id:'SemyearReport',
						header : '���걨',
						width : 60,
						editable : true,
						align : 'center',
						type:SRepCheckbox,
						renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//����ֵ����checkbox�Ƿ�ѡ
						dataIndex : 'SemyearReport'

					},{
						id : 'YearReport',
						header : ' �걨',
						width : 60,
						editable:true,
						align : 'center',
						type : YRepCheckbox,
						renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//����ֵ����checkbox�Ƿ�ѡ
						hidden:false,
						dataIndex : 'YearReport'

					}, {
						id : 'LenWayArray',
						header : '��������',
						width : 75,
						editable : true,
						align : 'center',
						allowBlank : true,
						dataIndex : 'LenWayArray'
						
					},{
					    id:'ReportExplain',
						header : '����˵���ļ�',
						editable : false,
						align : 'center',
						width:120,
						//type:excelUpload,
						renderer : function(v, p, r) {
							//return '<input type="file" />';
								return '<span style="color:blue;cursor:hand"><u>�ϴ�</u></span>';								
						},
						dataIndex : 'ReportExplain'
					},{
						id : 'IsStop',
						header : '�Ƿ�ͣ��',
						align : 'center',
						width : 75,
						editable:false,
						dataIndex : 'IsStop'

					},{
						id : 'CheckState',
						header : '���״̬',
						width : 75,
						align : 'center',
						editable:false,
						//hidden:true,
						dataIndex : 'CheckState'

					},{
						id : 'StartDate',
						header : '��������',
						width : 75,
						editable:false,
						//hidden:true,
						dataIndex : 'StartDate'

					},{
						id : 'Checkers',
						header : '�����',
						width : 110,
						align : 'center',
						editable:false,
						//hidden:true,
						dataIndex : 'Checkers'

					},{
						id : 'CheckDate',
						header : '���ʱ��',
						width : 100,
						align : 'center',
						editable:false,
						//hidden:true,
						dataIndex : 'CheckDate'

					},{
						id : 'IsEarly',
						header : '',
						width : 50,
						editable:false,
						hidden:true,
						dataIndex : 'IsEarly'
                       //����ʱ���Ƿ����׵�ǰʱ��
					}],
	
	split : true,
	//collapsible : true,
	//containerScroll : true,
	xtype : 'grid',
	//trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	loadMask : true,	
	//height:120,
	//trackMouseOver: true,
	stripeRows: true

});

itemMain.btnPrintHide(); 	//���ش�ӡ��ť
itemMain.btnResetHide(); 	//�������ð�ť
itemMain.load(({params:{start:0,limit:25,userid:userid,AcctBook:AcctBook}}));

itemMain.on('rowclick',function(grid,rowIndex,e){	
	var MainRowid='';
	var selectedRow = itemMain.getSelectionModel().getSelections();
	MainRowid=selectedRow[0].data['rowid'];
	var CheckState=selectedRow[0].data['CheckState'];
	if(CheckState=="���"){itemMain.btnDisable();
	}else{
		itemMain.btnEnable();
	}
	var limits=Ext.getCmp("PageSizePluginhss").getValue();
			 //alert(limits);
	         if(!limits){limits=25};
	itemDetail.load({params:{start:0, limit:limits,MainRowid:MainRowid}});	
});

// ����gird�ĵ�Ԫ���¼�
 itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	// alert(columnIndex)
	// ǰ�÷�������
	if (columnIndex == 10) {
		var records = itemMain.getSelectionModel().getSelections();
	    var repCode=records[0].get("ReportCode");
		var RepName=records[0].get("ReportName");
	  
		if(repCode==""){
			Ext.Msg.show({title:'��ʾ',msg:'���ȱ����������ϴ�����˵���ļ� ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		}else{
			doimport(repCode,RepName);
		
		}
		
	}
	// else if(columnIndex==5){
		// alert(columnIndex);
		// MRepCheckbox.checked=true;
	// }
}); 


var doimport = function(repCode,RepName){
	var data2="";
	var freStore="";
 var URL="";
 var username="";
 var Password="";
 var Server="";
 var port="";
	 Ext.Ajax.request({
        url:'../csp/herp.acct.reportempletaddexe.csp?action=GetInfo&AcctBook='+ AcctBook,
        method: 'GET',
        success: function(result, request) {
        var jsonData = Ext.util.JSON.decode( result.responseText );
        if (jsonData.success=='true'){
       var result=jsonData.info;
	 //  alert(result);
	   var info= result.split("^");	
	    URL=info[0];
		username=info[1];
		Password=info[2];
		Server=info[3];
		path=info[4];
		//alert(URL+username+Password);
                  }
             }	 
});


	var excelUpload = new Ext.form.TextField({   
		id:'excelUpload', 
		name:'Excel',   
		anchor:'90%',
		region:'right',
		height:25,   
		inputType: 'file',
		fieldLabel:'�ļ�ѡ��',
		width:40
		
	});
				
	//�ļ�ѡ��
	var upLoadFieldSet = new Ext.form.FieldSet({
		title:'�ļ�ѡ��',
		labelSeparator:'��',
		height:100,
		bodyStyle:'padding:15px;',
		align:'center',
		items:[excelUpload]
	});
				
	//���ı���
	
	var textArea = new Ext.form.TextArea({
		id:'textArea',
		width:325,
		fieldLabel:'�Ѻ���ʾ',
		readOnly:true,
		disabled:true,
		emptyText:'��ѡ��'+RepName+'����˵���ļ�'
	
	});

	//����˵�����ı���
	var exampleFieldSet = new Ext.form.FieldSet({
		title:'�ļ��ϴ�������ʾ',
		labelSeparator:'��',
		items:textArea
	});

	var formPanel = new Ext.form.FormPanel({
		//title:'Excel���ݵ���',
		formId:'formUp',
		labelWidth:80,
		labelAlign:'right',
		bodyStyle:'padding:10 10 10 10',
		height:515,
		width:515,
		frame:true,
		fileUpload:true,
		items: [exampleFieldSet,upLoadFieldSet]
	});
			
	//���尴ť
	var importB = new Ext.Button({
		text:'�ļ��ϴ�',
		type:'submit'
	});


	
	function callback(id){
		if(id=="yes"){
			//��ȡ������Ϣ
	
			var excelName = Ext.getCmp('excelUpload').getRawValue();//�ϴ��ļ����Ƶ�·��
			if(excelName==""){
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ��'+RepName+'����˵���ļ�!',buttons: Ext.Msg.OK,icon:Ext.Msg.INFO});
				return;
			}else{
				var array=new Array();
				array=excelName.split("\\");
				var fileName="";
				var i=0;
				for(i=0;i<array.length;i++){
					if(fileName==""){
						fileName=array[i];
					}else{
						fileName=fileName+"/"+array[i];
					}
				}

				
			//var uploadUrl="http://localhost:8080/HerpFtpFileUpload/FtpUploadServlet";
			//var uploadUrl="http://localhost:8080/herpacctFtpUplod/HerpAcctFtpServlet";
			var uploadUrl="http://"+URL+"/herpacctFtpUplod/HerpAcctFtpServlet";
			var upUrl=uploadUrl+"?AcctBookID="+AcctBook+"&file="+fileName+"&ReportCode="+repCode+"&username="+username+"&Password="+Password+"&Server="+Server+"&path="+path;
		     //alert(upUrl);
				formPanel.getForm().submit({
					url:upUrl,
					method:'POST',
					waitMsg:'�ļ��ϴ���, ���Ե�...',
					success:function(form, action) {
						//console.log(action);
						//�жϵ�ǰ�����ʱ��Ϊie������ie11
						var userAgent = navigator.userAgent;   
						var rMsie = /(msie\s|trident.*rv:)([\w.]+)/;   
						var ua = userAgent.toLowerCase(); 
						var match = rMsie.exec(ua);  
						if(match != null){
						//alert(action.result);
						if(action.result!=""&& action.result!=undefined){
							
							Ext.MessageBox.alert("��ʾ��Ϣ","�ļ��ϴ��ɹ�! ");
						}else
						{
						    Ext.MessageBox.alert("��ʾ��Ϣ","�ļ��ϴ�ʧ��!�������� ");
						}
					  }else{
							Ext.MessageBox.alert("��ʾ��Ϣ","�ļ��ϴ��ɹ�! ");
					  }
					},
					failure:function(form, action) {
					
							Ext.MessageBox.alert("Error","�ļ��ϴ�ʧ��! ");
					}
				});
		
			}		
		}else{
			return;
		}
	}	
			  
	//�������ݹ���
	var handler = function(bt){
		var excelName = Ext.getCmp('excelUpload').getRawValue();//�ϴ��ļ����Ƶ�·��
		if(excelName==""){
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ��'+RepName+'����˵���ļ�!',buttons: Ext.Msg.OK,icon:Ext.Msg.WARNING});
				return;
			}
			
		if(bt=="yes"){
		
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ�ϴ����ļ���? ',callback);
		}
		Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ�ϴ��ļ���? ',callback);
		
	};

	

	//��Ӱ�ť����Ӧ�¼�
	importB.addListener('click',handler,false);

	var window = new Ext.Window({
		title: '����˵���ļ��ϴ�',
		width: 520,
		height:325,
		minWidth: 530,
		minHeight: 400,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [
			importB
		]
	});
	window.show();
};