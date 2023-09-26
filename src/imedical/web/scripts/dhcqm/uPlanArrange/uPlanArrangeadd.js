var QMSchemF;
var QMSchemFl;
var namef;
 
sysorgaffiaddFun = function(store,itemGridPagingToolbar) {
	
var getFullPeriodType = function (date) {
  var d = date.getMonth()+1;
  
  var m= Math.floor( ( d% 3 == 0 ? ( d/ 3 ) : ( d / 3 + 1 ) ) );
 return "0"+m;
  
}


var periodYear = new Ext.form.TextField({
	id: 'periodYear',
	fieldLabel: '��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��',
	anchor: '95%',
	listWidth : 213,
	triggerAction: 'all',
	emptyText:'��������λ���ֵ����',
	regex:/^\d{4}$/,
	regexText:'��������Ч�����',
	value:(new Date()).getFullYear(),
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
	anchor: '95%',
	//listWidth : 213,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	
	value:'Q',
	valueNotFoundText:'',
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
	value:getFullPeriodType(new Date()),
	anchor: '95%',
	//listWidth : 213,
	selectOnFocus: true,
	allowBlank: false,
	store: startperiodStore,
	
	valueNotFoundText:'',
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
	anchor: '95%',
	value:'��Ч����'
	})

var CheckStartDate1 = new Ext.form.DateField({
	id:'CheckStartDate1',
	//format:'Y-m-d',
	fieldLabel:'��ʼʱ��',
	anchor: '95%',
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
	anchor: '95%',
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
		url:'dhc.qm.uPlanArrangeexe.csp'+'?action=userList&str='+encodeURIComponent(Ext.getCmp('userField').getRawValue()),method:'POST'
	});	
});

var userField = new Ext.form.ComboBox({   //���嵥λ��Ͽؼ�
            id: 'userField',
			fieldLabel: '��&nbsp;&nbsp;��&nbsp;&nbsp;��',
			anchor: '95%',
			//listWidth: 213,
			selectOnFocus: true	,
			store: userDs,
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
			anchor: '95%',
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
			anchor: '95%',
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
				anchor: '80%',
				emptyText:'��ѡ����Ŀ',
				editable:false,
				disabled:true,
				selectOnFocus:'true',
				itemCls:'sex-female', //���󸡶�,����ؼ�����
				clearCls:'allow-float' //�������߸���
				
			});	
	
/*var QMSchemButton = new Ext.Toolbar.Button({
		text: '��&nbsp;&nbsp;��',
		handler: function(){QMSchem(itemGridDs,itemGrid,itemGridPagingToolbar,"add" );
		}
});
*/
 nameField = new Ext.form.TextField({
				id:'nameField',
				fieldLabel: '��鲡��',
				allowBlank: true,
				anchor: '80%',
				emptyText:'��ѡ����',
				editable:false,
				disabled:true,
				selectOnFocus:'true',
				itemCls:'sex-female', //���󸡶�,����ؼ�����
				clearCls:'allow-float' //�������߸���
				
			});	
/*	
var nameButton = new Ext.Toolbar.Button({
		text: '��&nbsp;&nbsp;��',
		handler: function(){
			//�����ȣ��ڼ����ͺ��ڼ��ֵ
			var CycleDr=periodYear.getValue();
			var periodType=periodTypeField.getValue()=="Q"?"��":"��";
			var period=startperiodField.getValue();
			var user = userField.getValue();
			
			//alert(CycleDr+"  "+yearVal.test(CycleDr));
			//���ô���
			var periodtxt=CycleDr+"��"+period+periodType;
			var yearPeriod=CycleDr+period;
			var yearVal=/^\d{4}$/;
			if(!yearVal.test(CycleDr)){
			
				Ext.Msg.show({title:'��ʾ',msg:"��������Ч�����!",buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;

			}else{
				Name(itemGridDs,itemGrid,itemGridPagingToolbar,"add",periodtxt,yearPeriod,user,"");
			}
		}
});
*/

QMSchemButtonFun =  function(){QMSchem(itemGridDs,itemGrid,itemGridPagingToolbar,"add" );
		};
nameButtonFun = function(){
			//�����ȣ��ڼ����ͺ��ڼ��ֵ
			var CycleDr=periodYear.getValue();
			var periodType=periodTypeField.getValue()=="Q"?"��":"��";
			var period=startperiodField.getValue();
			var user = userField.getValue();
			
			//alert(CycleDr+"  "+yearVal.test(CycleDr));
			//���ô���
			var periodtxt=CycleDr+"��"+period+periodType;
			var yearPeriod=CycleDr+period;
			var yearVal=/^\d{4}$/;
			if(!yearVal.test(CycleDr)){
			
				Ext.Msg.show({title:'��ʾ',msg:"��������Ч�����!",buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;

			}else{
				Name(itemGridDs,itemGrid,itemGridPagingToolbar,"add",periodtxt,yearPeriod,user,"");
			}
		};
//��ȡ��Ա����

	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 90,
			items : [periodYear,periodTypeField,startperiodField,noname,CheckStartDate1,CheckEndDate1, userField,StartDate,EndDate,QMSchemField,nameField]
		});
	 var formLayCount=0
	 formPanel.on('afterlayout', function(panel, layout) { 
			if(formLayCount==0){
				$("input#QMSchemField").after('<button  type="button" onclick="QMSchemButtonFun()">��&nbsp;&nbsp;��</button>');
				$("input#nameField").after('<button  type="button" onclick="nameButtonFun()">��&nbsp;&nbsp;��</button>');

				formLayCount++;
			}
			
	 }); 
	var addWin = new Ext.Window({    
		title : '�½�',
		width : 400,
		height : 400,
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : formPanel,
		buttons : [{		 
			text : '����',
			handler : function() {
			if (formPanel.form.isValid()) {
					var CycleDr=periodYear.getValue();
					var period=periodYear.getValue()+startperiodField.getValue();
					var title=periodYear.getValue()+encodeURIComponent('��')+startperiodField.getValue()+encodeURIComponent((periodTypeField.getValue()=='Q'?'����':'�·�'))+encodeURIComponent(noname.getValue());
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
					if(user!=""){
						
					}else{
						Ext.Msg.show({title:'��ʾ',msg:'�����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
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
					var QMSchem = QMSchemF.trim();
					var  name = namef.trim();
				
					Ext.Ajax.request({
						url:'dhc.qm.uPlanArrangeexe.csp?action=add&title='+title+'&CycleDr='+CycleDr+'&period='+period+'&CheckStartDate1='+CheckStartDate1+'&CheckEndDate1='+CheckEndDate1+'&user='+user+'&StartDate='+StartDate+'&EndDate='+EndDate+'&QMSchem='+QMSchem+'&name='+name,
						
						waitMsg:'������...',
						failure: function(result,request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
													console.log(result.responseText);
							if (jsonData.success=='true'){				
									Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
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
	};