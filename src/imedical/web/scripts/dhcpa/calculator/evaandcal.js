var data="";
var monthStore="";
//Ext.Ajax.timeout=90000000000000; ������������ȡ��
var userCode=session['LOGON.USERCODE'];
var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.calculatorexe.csp?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'��������',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�񿼺�����...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '�ڼ�����',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value:'', //Ĭ��ֵ
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
	forceSelection: true
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){
		data=[['1','01��'],['2','02��'],['3','03��'],['4','04��'],['5','05��'],['6','06��'],['7','07��'],['8','08��'],['9','09��'],['10','10��'],['11','11��'],['12','12��']];
	}
	if(cmb.getValue()=="Q"){
		data=[['1','01����'],['2','02����'],['3','03����'],['4','04����']];
	}
	if(cmb.getValue()=="H"){
		data=[['1','1~6�ϰ���'],['2','7~12�°���']];
	}
	if(cmb.getValue()=="Y"){
		data=[['0','ȫ��']];
	}
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	anchor: '90%',
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


var schemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','parRef','code','name','shortcut','appSysDr','frequency','KPIDr','KPIName','desc','level','appSys','quency','shortCutFreQuency'])
});

schemDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.disttargetexe.csp?action=schem&searchField=name&searchValue='+encodeURIComponent(Ext.getCmp('schem').getRawValue())+'&active=Y&type='+Ext.getCmp('periodTypeField').getValue(),method:'POST'})
});
var schem = new Ext.form.ComboBox({
	id: 'schem',
	fieldLabel: '��ǰ����',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: schemDs,
	anchor: '90%',
	displayField:'shortCutFreQuency',
	valueField: 'rowid',
	triggerAction: 'all',
	emptyText:'ѡ��ǰ����...',
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var autohisoutmedvouchForm = new Ext.form.FormPanel({
		title:'�￼������',
		region:'north',
		frame:true,
		height:90,
		items:[{
			xtype: 'panel',
			layout:"column",
			height:25,
			hideLabel:true,
			isFormField:true,
			items:[
					{columnWidth:.0,xtype:'displayfield'},
					{columnWidth:.2,xtype:'label',text: '�� ��Ч����---�������� ��'}
				]
			},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			height:50,
			isFormField:true,
			items:[
					{columnWidth:.07,xtype:'label',text: '���:'},
					cycleField,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.15,xtype:'label',text: '�ڼ�����:'},
					periodTypeField,
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.1,xtype:'label',text: '�ڼ�:'},
					periodField,
					{columnWidth:.06,xtype:'displayfield'},
					{columnWidth:.15,xtype:'label',text:'���˷���:'},
					schem
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:30,
				isFormField:true,
				items:[
					{columnWidth:.07,xtype:'label',text: 'һ���ֲ�ʽ����'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:25,
				isFormField:true,
				items:[
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.08,xtype:'label',text: '1.����ָ�����:'},
					{columnWidth:.01,xtype:'displayfield'},
					{columnWidth:.05,xtype:'button',text: 'ָ�����',name: 'bc',tooltip: 'ָ�����',handler:function(){kpical()},iconCls: 'remove'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:25,
				isFormField:true,
				items:[
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.08,xtype:'label',text: '2.���˷ּ���:'},
					{columnWidth:.01,xtype:'displayfield'},
					{columnWidth:.05,xtype:'button',text: '���˷ּ���',name: 'bc',tooltip: '���˷ּ���',handler:function(){asscal()},iconCls: 'remove'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:20,
				isFormField:true,
				items:[
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.35,xtype:'label',text: '3.�ֲ�ʽ����˵��:'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:50,
				isFormField:true,
				items:[
					{columnWidth:.05,xtype:'displayfield'},
					{columnWidth:.6,xtype:'label',text:'�ֲ�ʽ���㲽�裺 ����ָ�����->���˷ּ���'}
				]
			}/*,{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:30,
				isFormField:true,
				items:[
					{columnWidth:.07,xtype:'label',text: '����ȫ������'},
					{columnWidth:.01,xtype:'displayfield'},
					{columnWidth:.05,
						xtype:'button',
						text: '����',
						name: 'bc',
						tooltip: 'ȫ������',
						iconCls: 'remove',
						handler:function(){
							//����ָ�����
							allcal();
							//���з�������
							allScoreCal();
						}
					}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:20,
				isFormField:true,
				items:[
					{columnWidth:.02,xtype:'displayfield'},
					{columnWidth:.15,xtype:'label',text: '1.ȫ������˵��:'}
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:50,
				isFormField:true,
				items:[
					{columnWidth:.05,xtype:'displayfield'},
					{columnWidth:.6,xtype:'label',text:'ȫ�����㣺 ��ɷֲ������ȫ����'}
				]
			}*/,{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				height:50,
				isFormField:true,
				items:[
					{columnWidth:.40,xtype:'displayfield'},
					{columnWidth:.2,xtype:'label',text: '�� ������ʾ�� ����ϸѡ��������� ��'}
				]
			}
		]
});

//�滻���ʽ�е�"{"����
replace3=function(expression){
	var re=/{/g; //����������ʽģʽ
	var newExpression=expression.replace(re,"(");
	return newExpression;
}

//�滻���ʽ�е�"}"����
replace4=function(expression){
	var re=/}/g; //����������ʽģʽ
	var newExpression=expression.replace(re,")");
	return newExpression;
}

//�滻���ʽ�е�"["����
replace1=function(expression){
	var re=/\[/g; //����������ʽģʽ
	var newExpression=expression.replace(re,"(");
	return newExpression;
}

//�滻���ʽ�е�"]"����
replace2=function(expression){
	var re=/]/g; //����������ʽģʽ
	var newExpression=expression.replace(re,")");
	return newExpression;
}

//���滻
totalReplace=function(expression){
	return replace4(replace3(replace2(replace1(expression))));
}

var cycleDr="";
var periodType="";
var period="";
var schemDr="";

//��ȡ����
getParams=function(){
	cycleDr=Ext.getCmp('cycleField').getValue();
	if(cycleDr==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	periodType=Ext.getCmp('periodTypeField').getValue();
	if(periodType==""){
		Ext.Msg.show({title:'ע��',msg:'���ڼ�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	period=Ext.getCmp('periodField').getValue();
	if(period==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���ڼ�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	schemDr=Ext.getCmp('schem').getValue();
	if(schemDr==""){
		 schemDr="1"
	}
	//alert("schemDr="+schemDr);
	/*
	if(schemDr==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ��!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}
	*/
	
}

//���㹫ʽ���С�0����ָ��,��Ҫ����ʾ�û�
var InfinityKPINameStr="";
//���㹫ʽ����Ϊ�յ�ָ��,��Ҫ����ʾ�û�
var noKPINameStr="";
//�µ��ַ�����Ϣ
var newAllInfo="";

//�����ַ�����ϢnewPeriod_"^"_jxUnitName_"^"_KPIName
strDeal = function(str){
	var allArray=str.split("!");
	var length=allArray.length;
							
	for(var i=0;i<length;i++){
		var info=allArray[i];
		var infoArray=info.split("^");
		var infoLength=infoArray.length;
		var expression=infoArray[infoLength-1];
		if(expression!=""){
			var newExpression=totalReplace(expression);
			//���㹫ʽ
			var value=eval(newExpression);
			//alert(value);	
			/*
			if(value=="Infinity"){
				var KPIName=infoArray[4];
				if(InfinityKPINameStr==""){
					InfinityKPINameStr=KPIName;
				}else{
					InfinityKPINameStr=InfinityKPINameStr+"^"+KPIName
				}
				if(newAllInfo==""){
					newAllInfo=allArray[i]+"^"+value;
				}else{
					newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
				}
			}else{
				if(newAllInfo==""){
					newAllInfo=allArray[i]+"^"+value;
				}else{
					newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
				}
			}
			*/
			if((value!="Infinity")||(value!="NaN")){
				var KPIName=infoArray[4];
				if(InfinityKPINameStr==""){
					InfinityKPINameStr=KPIName;
				}else{
					InfinityKPINameStr=InfinityKPINameStr+"^"+KPIName
				}
				if(newAllInfo==""){
					newAllInfo=allArray[i]+"^"+value;
				}else{
					newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
				}
			}else{
				if(newAllInfo==""){
					newAllInfo=allArray[i]+"^"+value;
				}else{
					newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
				}
			}
		}else{
			var value="";
			var KPIName=infoArray[4];
			if(noKPINameStr==""){
				noKPINameStr=KPIName;
			}else{
				noKPINameStr=noKPINameStr+"^"+KPIName
			}
			if(newAllInfo==""){
				newAllInfo=allArray[i]+"^"+value;
			}else{
				newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
			}
		}
	}
}

//�����ַ�����ϢnewPeriod_"^"_jxUnitName_"^"_KPIName
strDeal2 = function(str){
	var allArray=str.split("!");
	var length=allArray.length;
							
	for(var i=0;i<length;i++){
		var info=allArray[i];
		var infoArray=info.split("^");
		var infoLength=infoArray.length;
		var expression=infoArray[infoLength-1];
		if(expression!=""){
			var newExpression=totalReplace(expression);
			//���㹫ʽ
			var value=eval(newExpression);
			//alert(value);	
			/*
			if(value=="Infinity"){
				var KPIName=infoArray[4];
				if(InfinityKPINameStr==""){
					InfinityKPINameStr=KPIName;
				}else{
					InfinityKPINameStr=InfinityKPINameStr+"^"+KPIName
				}
				if(newAllInfo==""){
					newAllInfo=allArray[i]+"^"+value;
				}else{
					newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
				}
			}else{
				if(newAllInfo==""){
					newAllInfo=allArray[i]+"^"+value;
				}else{
					newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
				}
			}
			*/
			if((value!="Infinity")||(value!="NaN")){
				var KPIName=infoArray[4];
				if(InfinityKPINameStr==""){
					InfinityKPINameStr=KPIName;
				}else{
					InfinityKPINameStr=InfinityKPINameStr+"^"+KPIName
				}
				if(newAllInfo==""){
					newAllInfo=allArray[i]+"^"+value;
				}else{
					newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
				}
			}else{
				if(newAllInfo==""){
					newAllInfo=allArray[i]+"^"+value;
				}else{
					newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
				}
			}
		}else{
			var value="";
			var KPIName=infoArray[4];
			if(noKPINameStr==""){
				noKPINameStr=KPIName;
			}else{
				noKPINameStr=noKPINameStr+"^"+KPIName
			}
			if(newAllInfo==""){
				newAllInfo=allArray[i]+"^"+value;
			}else{
				newAllInfo=newAllInfo+"!"+allArray[i]+"^"+value;
			}
		}
	}
}

//���й�ʽ��ֻ���й�ʽΪ�յ����
expreNull=function(){
	getParams();
	function callback3(id){
		if(id=="yes"){
			Ext.Ajax.request({
				url: 'dhc.pa.calculatorexe.csp?action=calcul&allinfo='+newAllInfo,
				waitMsg:'������...',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'����ָ��ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					}else{
						if(jsonData.info=='false'){
							Ext.Msg.show({title:'��ʾ',msg:'����ָ��ʧ��,���ݱ��ع�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						if(jsonData.info=='NoDeal'){
							Ext.Msg.show({title:'��ʾ',msg:'������ʧ,���㲻ִ��,����δ��������,���������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					}
				},
				scope: this
			});
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('��ʾ',noKPINameStr+'��ָ���޼��㹫ʽ,ȷ��Ҫ������?',callback3);
}

//���й�ʽ��ֻ���з�ĸΪ0�����
zeroNull=function(){
	getParams();
	function callback2(id){
		if(id=="yes"){
			Ext.Ajax.request({
				url: 'dhc.pa.calculatorexe.csp?action=calcul&allinfo='+newAllInfo,
				waitMsg:'������...',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'����ָ��ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					}else{
						if(jsonData.info=='false'){
							Ext.Msg.show({title:'��ʾ',msg:'����ָ��ʧ��,���ݱ��ع�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						if(jsonData.info=='NoDeal'){
							Ext.Msg.show({title:'��ʾ',msg:'������ʧ,���㲻ִ��,����δ��������,���������������!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					}
				},
				scope: this
			});
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('��ʾ',InfinityKPINameStr+'��ָ���з�ĸΪ0,��鿴ָ���¼,ȷ��Ҫ������?',callback2);
}

//���й�ʽ�мȰ�����ʽΪ��,�ְ�����ĸΪ0�����
bothNull=function(){
	getParams();
	function callback4(id){
		if(id=="yes"){
			Ext.Ajax.request({
				url: 'dhc.pa.calculatorexe.csp?action=calcul&allinfo='+newAllInfo,
				waitMsg:'������...',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'����ָ��ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					}else{
						if(jsonData.info=='false'){
							Ext.Msg.show({title:'��ʾ',msg:'����ָ��ʧ��,���ݱ��ع�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						if(jsonData.info=='NoDeal'){
							Ext.Msg.show({title:'��ʾ',msg:'������ʧ,���㲻ִ��,����δ��������,���������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					}
				},
				scope: this
			});
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('��ʾ',noKPINameStr+'��ָ���޼��㹫ʽ,'+InfinityKPINameStr+'��ָ���з�ĸΪ0,��鿴ָ���¼,ȷ��Ҫ������?',callback4);
}

//���й�ʽ�мȲ�������ĸΪ0�ֲ�������ʽΪ�յ����
bothNoNull=function(){
	getParams();
	function callback1(id){
		if(id=="yes"){
			Ext.Ajax.request({
				url: 'dhc.pa.calculatorexe.csp?action=calcul&allinfo='+newAllInfo,
				waitMsg:'������...',
				failure: function(result,request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result,request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'����ָ��ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					}else{
						if(jsonData.info=='false'){
							Ext.Msg.show({title:'��ʾ',msg:'����ָ��ʧ��,���ݱ��ع�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						if(jsonData.info=='NoDeal'){
							Ext.Msg.show({title:'��ʾ',msg:'������ʧ,���㲻ִ��,����δ��������,���������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					}
				},
				scope: this
			});
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('��ʾ','ָ����㹫ʽ��ȫ��ȷ,ȷ��Ҫ������?',callback1);
}

//��������ִ�з���
publicFun=function(){
	//0��null
	if((noKPINameStr!="")&&(InfinityKPINameStr!="")){
		bothNull();
		//alert("a");
	}
	//null
	if((noKPINameStr!="")&&(InfinityKPINameStr=="")){
		expreNull();
		//alert("b");
	}
	//0
	if((noKPINameStr=="")&&(InfinityKPINameStr!="")){
		zeroNull();
		//alert("c");
	}
	//����
	if((noKPINameStr=="")&&(InfinityKPINameStr=="")){
		bothNoNull();
		//alert("d");
	}
}

//ָ����㷽��
kpical = function(){
	getParams();
	//alert('dhc.pa.calculatorexe.csp?action=getallinfo&period='+period+'&cycleDr='+cycleDr+'&periodType='+periodType+'&schemDr='+schemDr);
	Ext.Ajax.request({
		url: 'dhc.pa.calculatorexe.csp?action=getallinfo&period='+period+'&cycleDr='+cycleDr+'&periodType='+periodType+'&schemDr='+schemDr+'&userCode='+userCode,
		waitMsg:'������...',
		failure: function(result, request){
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true'){
				if(jsonData.info.split("%").length==1){
					if(jsonData.info=="UnCycle"){
						Ext.Msg.show({title:'��ʾ',msg:'������ȶ�ʧ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					if(jsonData.info=="UnFrequency"){
						Ext.Msg.show({title:'��ʾ',msg:'�ڼ����Ͷ�ʧ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					if(jsonData.info=="UnPeriod"){
						Ext.Msg.show({title:'��ʾ',msg:'�����ڼ䶪ʧ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
					if(jsonData.info=="NoCurrStratagem"){
						Ext.Msg.show({title:'��ʾ',msg:'�����ǰս�Ի��޵�ǰս��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						return false;
					}
				}else{
					var arr=jsonData.info.split("%");
					var flag=arr[1];
					if(flag=="true"){
					
						Ext.Msg.show({title:'��ʾ',msg:'������ָ��ִ�гɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}else{
						//��ʾ�û���鷵�ص�ָ��
						Ext.Msg.show({title:'��ʾ',msg:'ָ�����ִ��ʧ��,����'+arr[0]+'ָ���ټ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}
				}
			}
		},
		scope: this
	});
}

//���˷ּ���
asscal=function(){
	
	getParams();
	Ext.Ajax.request({
		url: 'dhc.pa.calculatorexe.csp?action=assscore&period='+period+'&cycleDr='+cycleDr+'&periodType='+periodType+'&schemDr='+schemDr+'&userCode='+userCode,
		waitMsg:'������...',
	
		
	
		failure: function(result, request){

			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
	/**
		failure: function(XMLHttpRequest, textStatus, errorThrown){
		alert(XMLHttpRequest.status); //500
		alert(XMLHttpRequest.readyState); // un 
		alert(textStatus); // obj
		},
	
**/
		success: function(result, request){
		
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true'){
			//alert(Ext.Ajax.timeout);
				Ext.Msg.show({title:'��ʾ',msg:'�÷����Ŀ��˷ּ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}else{
				if(jsonData.info=="NoCycle"){
					Ext.Msg.show({title:'��ʾ',msg:'��ȶ�ʧ,������ֹ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=="NoFreq"){
					Ext.Msg.show({title:'��ʾ',msg:'����Ƶ�ʶ�ʧ,������ֹ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=="NoPeriod"){
					Ext.Msg.show({title:'��ʾ',msg:'�����ڼ䶪ʧ,������ֹ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=="NoCurrStratagem"){
					Ext.Msg.show({title:'��ʾ',msg:'ȱ�ٵ�ǰս�Զ�ʧ,������ֹ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
			}
		},
	
		scope: this
	});
}
//====================================================================================================================
/*
//ȫ���������
//1.ȫ��ָ�����
allcal=function(){
	getParams();
	Ext.Ajax.request({
		url: 'dhc.pa.calculatorexe.csp?action=allcal',
		waitMsg:'������...',
		failure: function(result, request){
			
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true'){
				var arr=jsonData.info.split("%");
				var flag=arr[1];
				if(flag=="true"){
			     function callback(id){
						if(id=="yes"){
							//ȫ��ָ�����
							strDeal(arr[0]);
							publicFun();
						}else{
							return false;
						}
					
					Ext.MessageBox.confirm('��ʾ','�Ǽ�����ָ����ִ�гɹ�,��Ҫ����ִ�м�����ָ����?',callback);
				}else{
					Ext.Msg.show({title:'��ʾ',msg:'�Ǽ�����ָ��ִ��ʧ��,������ֹ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
		},
		 scope:this
	});


//2.ȫ����������
allScoreCal=function(){
	getParams();
	Ext.Ajax.request({
		url: 'dhc.pa.calculatorexe.csp?action=allScoreCal&cycleDr='+cycleDr,
		waitMsg:'������...',
		failure: function(result, request){
		
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true'){
				Ext.Msg.show({title:'��ʾ',msg:'�÷����Ŀ��˷ּ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}else{
				if(jsonData.info=="NoCycle"){
					Ext.Msg.show({title:'��ʾ',msg:'��ȶ�ʧ,������ֹ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
				if(jsonData.info=="NoCurrStratagem"){
					Ext.Msg.show({title:'��ʾ',msg:'ȱ�ٵ�ǰս�Զ�ʧ,������ֹ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
				if(jsonData.info=="NoCurrMonth"){
					Ext.Msg.show({title:'��ʾ',msg:'��ǰս�Եĵ�ǰ�·ݶ�ʧ,������ֹ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
		},
		scope: this
	});
}*/
