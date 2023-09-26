/**
 * name:tab of database author:wang ying Date:2011-1-7 ��Ч������ϵͳָ������excel�ļ��ϴ�����
 */
var importExcel = function() {
	var data2 = "";
	var freStore = "";

	var data = "";
	var StratagemTabUrl = '../csp/dhc.bonus.deptbonuscalcexe.csp';
	var cycleDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty:'results',
							root:'rows'
						}, ['rowid','BonusYear'])
			});

	cycleDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : StratagemTabUrl
									+ '?action=yearlist&topCount=5&orderby=Desc',
							method : 'POST'
						})
			});

	var cycle = new Ext.form.ComboBox({
		id : 'cycle',
		fieldLabel : '�������',
		allowBlank : false,
		store : cycleDs,
		valueField : 'BonusYear',
		displayField : 'BonusYear',
		triggerAction : 'all',
		emptyText : '��ѡ��������...',
		// name : 'cycleField',
		mode : 'local', // ����ģʽ
		minChars : 1,
		anchor : '90%',
		pageSize : 10,
		selectOnFocus : true,
		forceSelection : true
			// editable : true
		});

	var pTypeStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue'],
				data : [['M', 'M-��'], ['Q', 'Q-��'], ['H', 'H-����'], ['Y', 'Y-��']]
			});
	var periodType = new Ext.form.ComboBox({
				id : 'periodType',
				fieldLabel : '�ڼ�����',
				// width:180,
				// listWidth : 180,
				selectOnFocus : true,
				allowBlank : false,
				store : pTypeStore,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : 'ѡ���ڼ�����...',
				mode : 'local', // ����ģʽ
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});

	periodType.on("select", function(cmb, rec, id) {
				if (cmb.getValue() == "M") {
					data2 = [['M01', '01��'], ['M02', '02��'], ['M03', '03��'],
							['M04', '04��'], ['M05', '05��'], ['M06', '06��'],
							['M07', '07��'], ['M08', '08��'], ['M09', '09��'],
							['M10', '10��'], ['M11', '11��'], ['M12', '12��']];
				}
				if (cmb.getValue() == "Q") {
					data2 = [['Q01', '01����'], ['Q02', '02����'], ['Q03', '03����'],
							['Q04', '04����']];
				}
				if (cmb.getValue() == "H") {
					data2 = [['H01', '�ϰ���'], ['H02', '�°���']];
				}
				if (cmb.getValue() == "Y") {
					data2 = [['Y00', 'ȫ��']];
				}
				pStore.loadData(data2);
			});
	pStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue']
			});

	var period = new Ext.form.ComboBox({
				id : 'period',
				fieldLabel : '�ڼ�ֵ',
				// width:180,
				// listWidth : 180,
				selectOnFocus : true,
				allowBlank : false,
				store : pStore,
				anchor : '90%',
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '��ѡ���ڼ�ֵ...',
				mode : 'local', // ����ģʽ
				editable : false,
				pageSize : 12,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});

	// ��������ѡ��
	var publicFieldSet = new Ext.form.FieldSet({
				title : '��������ѡ��',
				height : 100,
				labelSeparator : '��',
				items : [cycle, periodType, period]
			});

	
			
	var fileTypeDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});

	fileTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'../csp/dhc.bonus.bonustargetcollectexe.csp?action=TargetFileType&modeType=1&targetTable=dhc_bonus_data.EmpBonusPay&userCode='+session['LOGON.USERCODE'],method:'POST'})
	});

	var fileType = new Ext.form.ComboBox({
		id: 'fileType',
		fieldLabel:'�ļ�ģ��',
		allowBlank: false,
		store: fileTypeDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ���ļ����...',
		name:'fileType',
		minChars:1,
		anchor : '90%',
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
			
			
	var excelUpload = new Ext.form.TextField({
				id : 'excelUpload',
				name : 'Excel',
				anchor : '90%',
				height : 20,
				inputType : 'file',
				fieldLabel : '�����ļ�'
			});

	// �ļ�ѡ��
	var upLoadFieldSet = new Ext.form.FieldSet({
				title : '�ļ�ѡ��',
				height : 75,
				labelSeparator : '��',
				items : [fileType,excelUpload]
			});

	// ���ı���
	var textArea = new Ext.form.TextArea({
				id : 'textArea',
				width : 325,
				fieldLabel : '�Ѻ���ʾ',
				readOnly : true,
				disabled : true,
				emptyText : '����ϸ�˶�Ҫ�������ݵĸ�ʽ�Լ����ݵ���Ч�ԣ�'
			});

	// ����˵�����ı���
	var exampleFieldSet = new Ext.form.FieldSet({
				title : '���ݵ���������ʾ',
				height : 110,
				labelSeparator : '��',
				items : textArea
			});

	var formPanel = new Ext.form.FormPanel({
		labelWidth : 80,
		bodyStyle : 'padding:5 5 5 5',
		height : 515,
		width : 515,
		frame : true,
		fileUpload : true,
		items : [publicFieldSet,upLoadFieldSet, exampleFieldSet]
		});

	// ���尴ť
	var importB = new Ext.Toolbar.Button({
		text : '���ݵ���'
	});

	// ���ݵ��뺯��
	var handler = function(bt) {
		
		var year = Ext.getCmp('cycle').getValue();
		var month = Ext.getCmp('period').getValue();
		
	
	var flag ="";
     Ext.Ajax.request({
			url: '../csp/dhc.bonus.bonustargetcollectexe.csp?action=statejudgement&year=' + year + '&month='+ month ,
					waitMsg : '������...',
					failure : function(result, request) {
						Ext.Msg.show({
									title : '����',
									msg : '������������!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							flag = jsonData.info;
							if (flag==1) {
								Ext.Msg.show({
									title : 'ע��',
									msg : '�����Ѻ��㣬���ܽ��е�ǰ����!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
								}
							else if(flag==2) {
								Ext.Msg.show({
									title : 'ע��',
									msg : '�����ѽ��ˣ����ܽ��е�ǰ����!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
								}
							else if(flag < 0) {
								Ext.Msg.show({
									title : 'ע��',
									msg : '��������¼��״̬�����ܽ��е�ǰ����!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
								return;
								}
							else{
			    if (bt == "yes") {
			    function callback(id) {
				if (id == "yes") {
					var bYear = Ext.getCmp('cycle').getValue();
					var bPeriod = Ext.getCmp('period').getValue();

					var configFile=Ext.getCmp('fileType').getRawValue().split("-")[0];
					
					
					// �ж��Ƿ���ѡ�����Ҫ�ϴ���excel�ļ�
					var excelName = Ext.getCmp('excelUpload').getRawValue();// �ϴ��ļ����Ƶ�·��
					
					if (excelName == "") {
						Ext.Msg.show({
							title:'��ʾ',
							msg:'��ѡ��Excel�ļ�!',
							buttons:Ext.Msg.OK,
							icon:Ext.MessageBox.INFOR
						});
						return;
					} else {
						var array = new Array();
						array = excelName.split("\\");
						var fileName = "";
						var i = 0;
						for (i = 0; i < array.length; i++) {
							if (fileName == "") {
								fileName = array[i];
							} else {
								fileName = fileName + "/" + array[i];
							}
						}
									
						//dhcbaUrl ��Դ��scripts\dhcbonus\common\bonusConfig.js �磺var dhcbaUrl="http://192.168.100.230:8080"
	
						var fileTypeVale=fileType.getValue();
					    var fileRowID=fileTypeVale.split(",")[0];
						var fileTypeFlag=fileTypeVale.split(",")[1];
												
						var uploadUrl = dhcbaUrl+"/ImportEmpPay";
						var upUrl = uploadUrl+"?bYear="+bYear+"&bPeriod="+bPeriod+"&configFile="+configFile+"&fileRowID="+fileRowID+"&fileTypeID="+fileTypeFlag;
						//alert(upUrl)
						
						//window.prompt("url",upUrl);
						formPanel.getForm().submit({
							url : upUrl,
							method : 'POST',
							waitMsg : '���ݵ�����, ���Ե�...',
							success : function(form, action, o) {
								Ext.MessageBox.alert("��ʾ��Ϣ", "���ݳɹ�����!");
								// Ext.MessageBox.alert("Information",action.result.mess);
							},
							failure : function(form, action) {
								Ext.MessageBox
										.alert("��ʾ��Ϣ", action.result.mess);
							}
						});
					}
				} else {
					return;
				}
			}
			Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ������ļ��е�������?', callback);
		}
	
			Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ����excel������?', callback);
								}
							} 
//						else {
//								Ext.Msg.show({
//									title : '����',
//									msg : '����',
//								    buttons : Ext.Msg.OK,
//									icon : Ext.MessageBox.ERROR
//									});
//								}
						},
						scope : this
						});
	
// if (bt == "yes") {
// function callback(id) {
// if (id == "yes") {
// var bYear = Ext.getCmp('cycle').getValue();
// var bPeriod = Ext.getCmp('period').getValue();
//
// var configFile=Ext.getCmp('fileType').getRawValue().split("-")[0];
//					
// // �ж��Ƿ���ѡ�����Ҫ�ϴ���excel�ļ�
// var excelName = Ext.getCmp('excelUpload').getRawValue();// �ϴ��ļ����Ƶ�·��
// if (excelName == "") {
// Ext.Msg.show({
// title:'��ʾ',
// msg:'��ѡ��Excel�ļ�!',
// buttons:Ext.Msg.OK,
// icon:Ext.MessageBox.INFOR
// });
// return;
// } else {
// var array = new Array();
// array = excelName.split("\\");
// var fileName = "";
// var i = 0;
// for (i = 0; i < array.length; i++) {
// if (fileName == "") {
// fileName = array[i];
// } else {
// fileName = fileName + "/" + array[i];
// }
// }
// //cField.getValue();
// var fileTypeID=fileType.getValue();
//						
// //alert(configFile);
// var uploadUrl = "http://192.168.1.81:8080/dhchxbonus/commonImportExcel";
// if(configFile=="GHZB"){
// uploadUrl = "http://192.168.1.81:8080/dhchxbonus/regexcel";
// }
// if(configFile=="JKSJ"){
// uploadUrl = "http://192.168.1.81:8080/dhchxbonus/interfaceexcel";
// }
// var upUrl =
// uploadUrl+"?bYear="+bYear+"&bPeriod="+bPeriod+"&configFile="+configFile+"&fileTypeID="+fileTypeID;
//						
// formPanel.getForm().submit({
// url : upUrl,
// //url:'http://192.168.1.81:8080/dhchxbonus/abc',
// method : 'POST',
// waitMsg : '���ݵ�����, ���Ե�...',
// success : function(form, action, o) {
// Ext.MessageBox.alert("��ʾ��Ϣ", "���ݳɹ�����!");
// // Ext.MessageBox.alert("Information",action.result.mess);
// },
// failure : function(form, action) {
// Ext.MessageBox
// .alert("��ʾ��Ϣ", action.result.mess);
// }
// });
// }
// } else {
// return;
// }
// }
// Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ������ļ��е�������?', callback);
// }
// Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ����excel������?', callback);
	}
	
	// �������ݹ���
	var handler1 = function(bt) {
		if (bt == "yes") {
			function callback(id) {
				if (id == "yes") {
					// �ж��Ƿ���ѡ�����Ҫ�ϴ���excel�ļ�
					var excelName = Ext.getCmp('excelUpload').getRawValue();// �ϴ��ļ����Ƶ�·��
					if (excelName == "") {
						Ext.Msg.show({
							title:'��ʾ',
							msg:'��ѡ��Excel�ļ�!',
							buttons:Ext.Msg.OK,
							icon:Ext.MessageBox.INFOR
						});
						return;
					} else {
						var array = new Array();
						array = excelName.split("\\");
						var fileName = "";
						var i = 0;
						for (i = 0; i < array.length; i++) {
							if (fileName == "") {
								fileName = array[i];
							} else {
								fileName = fileName + "/" + array[i];
							}
						}
						//dhcbaUrl ��Դ��scripts\dhcbonus\common\bonusConfig.js �磺var dhcbaUrl="http://192.168.100.230:8080"

						var uploadUrl = dhcbaUrl+"/dhchxbonus/targetCalculateRateServlet";
						var uploadUrl2 = dhcbaUrl+"/dhchxbonus/targetCollect";
						var uploadUrl3 = dhcbaUrl+"/dhchxbonus/targetJCJ";
						var upUrl = uploadUrl3;
						
						formPanel.getForm().submit({
							url:uploadUrl3,
							method:'POST',
							waitMsg:'���ݵ�����, ���Ե�...',
							success:function(form, action) {
								Ext.MessageBox.alert("��ʾ��Ϣ", "���ݳɹ�����!");
							},
							failure : function(form, action) {
								// Ext.MessageBox.alert("��ʾ��Ϣ",
								// action.result.mess);
								alert("�ύʧ��");
							}
						});
					}
				} else {
					return;
				}
			}
			Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ������ļ��е�������?', callback);
		}
		Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ����excel������?', callback);
	}

	// ��Ӱ�ť����Ӧ�¼�
	importB.addListener('click', handler, false);

	// ����رհ�ť
	var cancelButton = new Ext.Toolbar.Button({
				text : '�رյ���'
			});

	// ����رհ�ť��Ӧ����
	cancelHandler = function() {
		window.close();
	}

	// ��ӹرհ�ť�����¼�
	cancelButton.addListener('click', cancelHandler, false);

	var window = new Ext.Window({
				title : '�������ָ������',
				width : 530,
				height : 400,
				minWidth : 530,
				minHeight : 400,
				layout : 'fit',
				plain : true,
				modal : true,
				bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [importB, cancelButton]
			});
	window.show();
}