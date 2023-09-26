var QMSchemF;
var QMSchemFl;
var namef;
 
editFun = function(itemGrid) {
	//���ֵ
	var itemObj=itemGrid.getSelectionModel().getSelections();
	var itemLen = itemObj.length;
	if(itemLen>1){
		Ext.Msg.show({title:'��ʾ',msg:'���ܶԶ��������޸�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
	}else if(itemLen<1){
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ��һ�������޸�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
	}else{
	
		//ȡֵ
		var itemData=itemObj[0].data;
	
		var CheckEndDate=itemData.CheckEndDate;
		var CheckStartDate=itemData.CheckStartDate;
		var Rowid=itemData.Rowid;
		var Title=itemData.Title;
		var deptGroupDr=itemData.deptGroupDr;
		var deptGroupName=itemData.deptGroupName;
		var qmschemDr=itemData.qmschemDr;
		var qmschemName=itemData.qmschemName;
		var taskEndData=itemData.taskEndData;
		var taskStart=itemData.taskStart;
		var checkUserName=itemData.checkUserName;
			var checkUser=itemData.checkUser;
		//title��Ϊ�꣬�ڼ䣬�ڼ�����
		var year=Title.substr(0,4);
		var period=Title.substr(5,4);
		var periodType=Title.substr(7,1);
		var title=Title.substr(9,Title.length);
		var getFullPeriodType = function (date) {
		  var d = date.getMonth();
		  d=d/3+1;
		  var m ="0"+(parseInt(d)-1);
		  //alert(m);
		  if (m<1){return "04";}
		  else
		  {return m;}
  
		}
var periodYear = new Ext.form.TextField({
	id: 'periodYear',
	fieldLabel: '��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��',
	anchor:'95%',
	//listWidth : 213,
	triggerAction: 'all',
	emptyText:'��������λ���ֵ����',
	value:(new Date()).getFullYear(),
	regex:/^\d{4}$/,
	regexText:'��������Ч�����',
	name: 'periodYear',
	minChars: 1,
	pageSize: 10,
	
	editable:false
});

var dataStr="";

var data="";
var data1=[['01','01�·�'],['02','02�·�'],['03','03�·�'],['04','04�·�'],['05','05�·�'],['06','06�·�'],['07','07�·�'],['08','08�·�'],['09','09�·�'],['10','10�·�'],['11','11�·�'],['12','12�·�']];
var data2=[['01','01����'],['02','02����'],['03','03����'],['04','04����']];

var count1=0;
var count2=0;

var monthStore="";

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','��'],['Q','��']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '�ڼ�����',
	anchor:'95%',
	//listWidth : 213,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	
	//value:'Q',
	valueNotFoundText:periodType,
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'ѡ���ڼ�����...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true,
	listeners:{"select":function(combo,record,index){ 
		
	}}   
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){data=data1;}
	if(cmb.getValue()=="Q"){data=data2;}
	
	startperiodStore.loadData(data);
	
	
});

startperiodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});
startperiodStore.loadData([['01','01����'],['02','02����'],['03','03����'],['04','04����']]);

var startperiodField = new Ext.form.ComboBox({
	id: 'startperiodField',
	fieldLabel: '��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��',
	//value:getFullPeriodType(new Date()),
	anchor:'95%',
	//listWidth : 213,
	selectOnFocus: true,
	allowBlank: false,
	store: startperiodStore,
	
	valueNotFoundText:period,
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'��ѡ��...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 12,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var noname=new Ext.form.TextField({
	fieldLabel: '��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��',
	anchor:'95%',
	value:'��Ч����'
	})

var CheckStartDate1 = new Ext.form.DateField({
			id:'CheckStartDate1',
			//format:'Y-m-d',
			fieldLabel:'��ʼʱ��',
			anchor:'95%',
			disabled:false,
			emptyText: '��ѡ����ʼʱ��...',

			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(startDate.getValue()!=""){
							endDate.focus();
						}else{
							Handler = function(){startDate.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'��ʼʱ�䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				}
			}
		});
		
		//�������ʱ��ؼ�
		var CheckEndDate1 = new Ext.form.DateField({
			id:'CheckEndDate1',
			//format:'Y-m-d',
			fieldLabel:'����ʱ��',
			anchor:'95%',
			disabled:false,
			emptyText: '��ѡ�����ʱ��...',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(endDate.getValue()!=""){
							
						}else{
							Handler = function(){endDate.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'����ʱ�䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				}
			}
		});

var userDs = new Ext.data.Store({   //��������Դ
           autoLoad:true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'	
			},['grupRowid','grupName'])	
});

userDs.on('beforeload',function(ds,o){  //����Դ�����������ú�̨�෽����ѯ����
    var periodType=periodTypeField.getValue();
	ds.proxy = new Ext.data.HttpProxy({
		//url:'dhc.qm.uPlanArrangeexe.csp'+'?action=userList&str='+encodeURIComponent(Ext.getCmp('userField').getRawValue()),method:'POST'
		url:'dhc.qm.uPlanArrangeexe.csp'+'?action=userList&str=',method:'POST'
	});	
});

var userField = new Ext.form.ComboBox({   //���嵥λ��Ͽؼ�
            id: 'userField',
			fieldLabel: '��&nbsp;&nbsp;��&nbsp;&nbsp;��',
			anchor:'95%',
			//listWidth: 213,
			selectOnFocus: true	,
			store: userDs,
			
	        valueNotFoundText:checkUserName,
			displayField: 'grupName',
			valueField: 'grupRowid',
			triggerAction: 'all',
			emptyText: '��ѡ��...',
			//typeAhead: true,
			forceSelection: true,
			minChars: 1,
			pageSize: 10,
			//selectOnFocus: true,
	        forceSelection: true		
});
var StartDate = new Ext.form.DateField({
			id:'StartDate',
			//format:'Y-m-d',
			fieldLabel:'����ʼ����',
			anchor:'95%',
			disabled:false,
			emptyText: '��ѡ��ʼʱ��...',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(StartDate.getValue()!=""){
							
						}else{
							Handler = function(){endDate.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'��ʼʱ�䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				}
			}
		});
var EndDate = new Ext.form.DateField({
			id:'EndDate',
			//format:'Y-m-d',
			fieldLabel:'�����ֹ����',
			anchor:'95%',
			disabled:false,
			emptyText: '��ѡ���ֹʱ��...',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(endDate.getValue()!=""){
							
						}else{
							Handler = function(){endDate.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'��ֹʱ�䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				}
			}
		});
 QMSchemField = new Ext.form.TextField({
				id:'QMSchemField',
				fieldLabel: '�����Ŀ',
				allowBlank: true,
				anchor:'80%',
				emptyText:'��ѡ����Ŀ',
				editable:false,
				disabled:true,
				selectOnFocus:'true',
				valueNotFoundText:qmschemName,
				itemCls:'sex-female', //���󸡶�,����ؼ�����
				clearCls:'allow-float' //�������߸���
				
			});	
	





 nameField = new Ext.form.TextField({
				id:'nameField',
				fieldLabel: '��鲡��',
				allowBlank: true,
				anchor:'80%',
				emptyText:'��ѡ����',
				editable:false,
				disabled:true,
				valueNotFoundText:deptGroupName,
				selectOnFocus:'true',
				itemCls:'sex-female', //���󸡶�,����ؼ�����
				clearCls:'allow-float' //�������߸���
				
			});	
	
var nameButton = new Ext.Toolbar.Button({
		text: '��&nbsp;&nbsp;��',
		
		handler: function(){
			//�����ȣ��ڼ����ͺ��ڼ��ֵ
			var CycleDr=periodYear.getValue();
			var periodType=periodTypeField.getValue()=="Q"?"��":"��";
			var period=startperiodField.getValue().substring(0,2);
			var user = userField.getValue();
			
			var periodtxt=CycleDr+"��"+period+periodType;
			
			var yearPeriod=CycleDr+period;
			var yearVal=/^\d{4}$/;
			if(!yearVal.test(CycleDr)){
			
				Ext.Msg.show({title:'��ʾ',msg:"��������Ч�����!",buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;

			}else{
			Name(itemGridDs,itemGrid,itemGridPagingToolbar,"edit",periodtxt,yearPeriod,user,Rowid);
			}
		}
});

//��ȡ��Ա����

	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 90,
			items : [periodYear,periodTypeField,startperiodField,noname,CheckStartDate1,CheckEndDate1, userField,StartDate,EndDate,
			QMSchemField,nameField]
		});
	 //������
	 var formLayCount=0
    formPanel.on('afterlayout', function(panel, layout) { 
     

			/*CheckStartDate1.setValue(CheckStartDate);
			CheckEndDate1.setValue(CheckEndDate);
			StartDate.setValue(taskStart);
			EndDate.setValue(taskEndData);
			//userField.setValue(1);	
			//Ext.getCmp('periodTypeField').setValue(itemData.CheckUser);
			Ext.getCmp('userField').setRawValue(checkUserName);
			periodYear.setValue(year);
			Ext.getCmp('periodTypeField').setRawValue(periodType);
			Ext.getCmp('startperiodField').setRawValue(period);
			noname.setValue(title);*/
			Ext.getCmp('nameField').setRawValue(deptGroupName);
			Ext.getCmp('QMSchemField').setRawValue(qmschemName);
			Ext.getCmp('periodTypeField').setRawValue(periodType);
			Ext.getCmp('startperiodField').setRawValue(period);
			
			if(formLayCount==0){
				$("input#QMSchemField").after('<button  type="button" onclick="QMSchemButtonFun()">��&nbsp;&nbsp;��</button>');
				$("input#nameField").after('<button  type="button" onclick="nameButtonFun()">��&nbsp;&nbsp;��</button>');

				formLayCount++;
			}
			
	 }); 
	 
	periodYear.setValue(year);
	CheckStartDate1.setValue(CheckStartDate);
	StartDate.setValue(taskStart);
	EndDate.setValue(taskEndData);
	CheckEndDate1.setValue(CheckEndDate);
	//var perType=periodType=="��"?"Q":"M"
	Ext.getCmp('periodTypeField').setValue(periodType=="��"?"Q":"M");
	Ext.getCmp('userField').setValue(checkUser);
	Ext.getCmp('startperiodField').setValue(period);
	noname.setValue(title);
	Ext.getCmp('nameField').setValue(deptGroupDr);
	Ext.getCmp('QMSchemField').setValue(qmschemDr);
	var addWin = new Ext.Window({
		    
			title : '�޸�',
			width : 400,
			height : 430,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			resizable:false,
			buttons : [{		 
				text : '����',
				handler : function() {
					if (formPanel.form.isValid()) {
						var CycleDr=periodYear.getValue();
						var period=encodeURIComponent(CycleDr+startperiodField.getValue().substring(0,2));
						var title=CycleDr+encodeURIComponent('��')+startperiodField.getValue().substring(0,2)+encodeURIComponent(periodTypeField.getValue()=="M"?"�·�":"����")+encodeURIComponent(noname.getValue());
		
					var CheckStartDate1 = Ext.getCmp('CheckStartDate1').getValue();
					
				if(CheckStartDate1!=""){
					CheckStartDate1 = CheckStartDate1.format('Y-m-d');
				}else{
					Ext.Msg.show({title:'��ʾ',msg:'��ʼ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
				var CheckEndDate1 = Ext.getCmp('CheckEndDate1').getValue();
				if(CheckEndDate1!=""){
					CheckEndDate1 = CheckEndDate1.format('Y-m-d');
				}else{
					Ext.Msg.show({title:'��ʾ',msg:'��������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
				if(checkDate(CheckStartDate1,CheckEndDate1)){
					
				}else{
					Ext.Msg.show({title:'��ʾ',msg:'��ʼ���ڴ��ڽ�������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
					
					
					
					var user = userField.getValue();
					
					var StartDate = Ext.getCmp('StartDate').getValue();
					if(StartDate!=""){
					StartDate = StartDate.format('Y-m-d');
				}else{
					Ext.Msg.show({title:'��ʾ',msg:'��ʼ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
					var EndDate = Ext.getCmp('EndDate').getValue();
					if(EndDate!=""){
					EndDate = EndDate.format('Y-m-d');
				}else{
					Ext.Msg.show({title:'��ʾ',msg:'��ֹ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
				if(checkDate(StartDate,EndDate)){
					
				}else{
					Ext.Msg.show({title:'��ʾ',msg:'����ʼ���ڴ��ڽ�ֹ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
					var QMSchem = QMSchemF;
					var  name = namef;
				
					Ext.Ajax.request({
					url:'dhc.qm.uPlanArrangeexe.csp?action=eidtRecord&title='+title+'&CycleDr='+CycleDr+'&period='+period+'&CheckStartDate1='+CheckStartDate1+'&CheckEndDate1='+CheckEndDate1+'&user='+user+'&StartDate='+StartDate+'&EndDate='+EndDate+'&QMSchem='+QMSchem+'&name='+name+'&rowId='+Rowid,
					
					waitMsg:'������...',
					failure: function(result,request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
											
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						}
						else
						{
							var message="�ظ����";
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text : '�ر�',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	}
	QMSchemButtonFun=function (){
		
	QMSchem(itemGridDs,itemGrid,itemGridPagingToolbar,"edit" );
		};
 nameButtonFun=function (){
		
			//�����ȣ��ڼ����ͺ��ڼ��ֵ
			var CycleDr=periodYear.getValue();
			var periodType=periodTypeField.getValue()=="Q"?"��":"��";
			var period=startperiodField.getValue().substring(0,2);
			var user = userField.getValue();
			
			var periodtxt=CycleDr+"��"+period+periodType;
			
			var yearPeriod=CycleDr+period;
			var yearVal=/^\d{4}$/;
			if(!yearVal.test(CycleDr)){
			
				Ext.Msg.show({title:'��ʾ',msg:"��������Ч�����!",buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;

			}else{
			Name(itemGridDs,itemGrid,itemGridPagingToolbar,"edit",periodtxt,yearPeriod,user,Rowid);
			}
		
};

	};