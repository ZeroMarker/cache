function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};

var cycleIdCookieNameOfKPIDS="cycleDr";
var schemIdCookieNameOfKPIDS="schemDr";
var deptIdCookieNameOfKPIDS="deptDr";
var nameStr=cycleIdCookieNameOfKPIDS+"^"+schemIdCookieNameOfKPIDS+"^"+deptIdCookieNameOfKPIDS;
var dataStr="";
var count1=0;
var count2=0;
var count3=0;


var CycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

CycleDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.paauditexe.csp?action=cycle&str='+Ext.getCmp('CycleField').getRawValue()+'&active=Y',method:'POST'})
	
});

var CycleField = new Ext.form.ComboBox({
	id: 'CycleField',
	fieldLabel:'���',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: CycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'CycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/* CycleDs.on('load', function(ds, o){
	CycleField.setValue(getCookie(cycleIdCookieNameOfKPIDS));
	count1=1;
});
 */
var SchemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','parRef','code','name','shortcut','appSysDr','frequency','KPIDr','KPIName','desc','level','appSys','quency','shortCutFreQuency'])
});

SchemDs.on('beforeload', function(ds, o){	
	
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.disttargetexe.csp?action=schem&searchField=name&searchValue='+encodeURIComponent(Ext.getCmp('SchemField').getRawValue())+'&active=Y',method:'POST'})
});
var SchemField = new Ext.form.ComboBox({
	id: 'SchemField',
	fieldLabel: '��ǰ����',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: SchemDs,
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

/* SchemDs.on('load', function(ds, o){
	SchemField.setValue(getCookie(schemIdCookieNameOfKPIDS));
	count2=1;
}); */

var dept1Ds = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['jxUnitDr','jxUnitName','shortCut'])
});

dept1Ds.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.disttargetexe.csp?action=dept&schemDr='+Ext.getCmp('SchemField').getValue(),method:'POST'})
	
});

var deptField = new Ext.form.ComboBox({
	id: 'deptField',
	fieldLabel: '����',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: dept1Ds,
	anchor: '90%',
	displayField: 'shortCut',
	valueField: 'jxUnitDr',
	triggerAction: 'all',
	emptyText:'ѡ�����...',
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

/* dept1Ds.on('load', function(ds, o){
	deptField.setValue(getCookie(deptIdCookieNameOfKPIDS));
	count3=1;
});
 */
SchemField.on("select",function(cmb,rec,id ){
    searchFun1(cmb.getValue());
});

function searchFun1(schemDr){
	deptField.setValue("");
	deptField.setRawValue("");
	//��Ч��λ
    dept1Ds.reload();
	
	/* if(getCookie(schemIdCookieNameOfKPIDS)==schemDr){
		setComboValueFromServer(deptField,deptIdCookieNameOfKPIDS);
	}else{
		dept1Ds.on('load', function(ds, o){
			deptField.setValue("");
		});
	} */
};
//==============================================================================================================================

//==============================================================================================================================
var vouchDetailST = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.pa.basedataviewexe.csp'}),
	reader: new Ext.data.JsonReader({
		root: 'rows',
	totalProperty: 'results'
	}),
	remoteSort: true
});

var autoHisOutMedCm = new Ext.grid.ColumnModel([]);

var find = new Ext.Toolbar.Button({
	text: '��ѯ',
    tooltip:'��ѯ',        
    iconCls:'add'
})

var updateYearData = new Ext.Toolbar.Button({
	text: '�������Ŀ��',
    tooltip:'�������Ŀ��',        
    iconCls:'add'
})
var updateValueData = new Ext.Toolbar.Button({
	text: 'Ŀ��ֵ�����ֵ����׼ֵ',
    tooltip:'����Ŀ��ֵ�����ֵ����׼ֵ����',        
    iconCls:'add',
	handler:function(){importExcel()}
})

var initField = new Ext.Toolbar.Button({
	text: '���ݳ�ʼ��',
    tooltip:'�����ݳ�ʼ��',        
    iconCls:'remove',
	handler:function(){init()}
})

var updateValue = new Ext.Toolbar.Button({
	text: '����ӿ�Ŀ��ֵ',
    tooltip:'����Ŀ��ֵ',        
    iconCls:'add',
	handler:function(){
		var cycleDr=Ext.getCmp('CycleField').getValue();
		var schemDr=Ext.getCmp('SchemField').getValue();
		var deptDr=Ext.getCmp('deptField').getValue();

		settvalue(cycleDr,schemDr,deptDr)}
})


var distKPI = new Ext.Toolbar.Button({
	text: 'ָ��ֽ�',
    tooltip:'ָ��ֽ�',        
    iconCls:'add'
})

var deptMain = new Ext.grid.EditorGridPanel({
	title:'�ﰴ����',
	store:vouchDetailST,
	cm:autoHisOutMedCm,
	region:'center',
	autoScroll:true,
	clicksToEdit:1,
	trackMouseOver:true,
	stripeRows:true,
	loadMask:true,
	tbar:['���:',CycleField,'-','���˷���:',SchemField,'-','����:',deptField,'-',find,'-',initField,'-',updateValue,'-',updateValueData]  // ȥ���˸������Ŀ��ֵ��ָ��ֽ� updateYearData,'-',distKPI,'-',
});

vouchDetailST.load();
function nodeClicked(node){
}

var tree="";

init2=function(){

	Ext.Ajax.request({
		url:'../csp/dhc.pa.disttargetexe.csp?action=init&cycleDr='+Ext.getCmp('CycleField').getValue()+'&schemDr='+Ext.getCmp('SchemField').getValue()+'&userCode='+userCode,
		waitMsg:'...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success=='true'){
				Ext.Msg.show({title:'��ʾ',msg:'���ݳ�ʼ�����!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
			}else{
				if(jsonData.info=='Copyed'){
					Ext.Msg.show({title:'��ʾ',msg:'��ǰս���Ѿ���ʼ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='NoCurrRecord'){
					Ext.Msg.show({title:'��ʾ',msg:'û�е�ǰս��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='RepCurrRecord'){
					Ext.Msg.show({title:'��ʾ',msg:'�����ǰս��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='false1'){
					Ext.Msg.show({title:'��ʾ',msg:'��ǰս�Է�����ʼ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='false2'){
					Ext.Msg.show({title:'��ʾ',msg:'��ǰս�Է�����ϸ��ʼ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='false3'){
					Ext.Msg.show({title:'��ʾ',msg:'��ǰս�Լӿ۷ַ���ʼ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='false4'){
					Ext.Msg.show({title:'��ʾ',msg:'��ǰս�����䷨��ʼ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='nullUnit'){
					Ext.Msg.show({title:'��ʾ',msg:'�÷�����û�п���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
			
			}
		},
		scope: this
	});
}

init = function(){
	var cycleDr=Ext.getCmp('CycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var schemDr=Ext.getCmp('SchemField').getValue();
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	Ext.MessageBox.confirm('��ʾ','ȷʵҪ��ʼ��������?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:'../csp/dhc.pa.disttargetexe.csp?action=judgeinit&schemDr='+Ext.getCmp('SchemField').getValue(),
					waitMsg:'...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if(jsonData.info=='Copyed'){
							Ext.MessageBox.confirm('��ʾ','��ǰս���Ѿ���ʼ��,Ҫ���³�ʼ����?',
								function(btn) {
									if(btn == 'yes'){
										init2();
									}	
								}
							)
						}else if(jsonData.info=='NoCurrRecord'){
							Ext.Msg.show({title:'��ʾ',msg:'û�е�ǰս��,������ֹ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}else if(jsonData.info=='RepCurrRecord'){
							Ext.Msg.show({title:'��ʾ',msg:'�����ǰս��,������ֹ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}else{
							//���������γ�ʼ������
							//Ext.MessageBox.confirm('��ʾ','ȷʵҪ��ʼ����?',
							//function(btn) {
							//if(btn == 'yes'){
										init2();
							//	}	
							//	}
							//)
						}
					},
					scope: this
				});
			}
		}
	)
}


//��ѯ��ť������
finddept = function(){
	var cycleDr=Ext.getCmp('CycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var schemDr=Ext.getCmp('SchemField').getValue();
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var deptDr=Ext.getCmp('deptField').getValue();
	if((deptDr=="")||(deptDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	dataStr=cycleIdCookieNameOfKPIDS+"^"+cycleDr+"!"+schemIdCookieNameOfKPIDS+"^"+schemDr+"!"+deptIdCookieNameOfKPIDS+"^"+deptDr;
	setBathCookieValue(dataStr);
	Ext.Ajax.request({
		url:'dhc.pa.kpitargetsetexe.csp?action=getTitleInfo&cycleDr='+cycleDr+'&schemDr='+schemDr,
		waitMsg:'...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			var cmConfig = {}; 
			var jsonHeadList = jsonData.rows; 
			var columns=[]; 
			for(var i=0;i<jsonHeadList.length;i++){
				if((jsonHeadList[i].name=="jxUnitDr")||(jsonHeadList[i].name=="KPIDr")){
					cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:0,sortable:false,align:'left',hidden:true};
				}else if(jsonHeadList[i].name=="KPIName"){
					cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:180,sortable:false,align:'left'};
				}else if(jsonHeadList[i].name=="KPICode"){
					cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:105,sortable:false,align:'left'};
				}else{
					cmConfig = {
						header:jsonHeadList[i].title,
						dataIndex:jsonHeadList[i].name, 
						width:60,
						sortable:false,
						//renderer:format,
						align:'right'
					};
				}
				columns.push(cmConfig);
			}
			
			deptMain.removeAll();
			
			LoaderHandler=function(){
				return new Ext.tree.TreeLoader({
					dataUrl:'../scripts/ext2/cost/report/test11.csp',
					clearOnLoad:true,
					uiProviders:{
						'col': Ext.tree.ColumnNodeUI
					}
				})
			}
			
			var loader=LoaderHandler();
				
			loader.on('beforeload', function(loader,node){
				var url="dhc.pa.kpitargetsetexe.csp?action=schemdetaillist";
				loader.dataUrl=url+"&parent="+node.id+'&schemDr='+schemDr+'&deptDr='+deptDr;
			});
			
			RootHandler=function(){
				return new Ext.tree.AsyncTreeNode({
					id:'roo',
					text:'ָ�����',
					//layer:0,
					//draggable:false,
					expanded:false
				})
			}
			
			TreeHanler=function(){
				return new Ext.tree.ColumnTree({
					height:650,
					//width:900,
					rootVisible:true,
					autoScroll:true,
					containerScroll:true,
					columns:columns,
					loader:loader,
					root:RootHandler(),
					listeners:{click:{fn:nodeClicked}}
				})
			}
			
			tree=TreeHanler();
			deptMain.add(tree);
			deptMain.doLayout(); //�ؼ�
			
			/*
			//�ڵ�ɱ༭�ؼ�����
			var teEditor = new Ext.tree.ColumnTreeEditor(tree,{
				completeOnEnter:true,
				autosize:true,
				ignoreNoChange:true,
				expanded:true,
				grow:true, 
				listeners:{
					specialkey:function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
						
							//var sm = tree.getSelectionModel();
							//var node = sm.getSelectedNode();
							//var colValue=node.attributes.leaf;
							var colsObj=tree.columns[index];
							var dataIndex=colsObj.dataIndex;
							
							//alert(dataIndex);
							
							
							//��ȡ�ڵ�
							
							
							alert(this.editColIndex);
							
							//���»�ȡ�õ�Ԫ���ֵ
							var newValue=teEditor.getValue();
							//var colsObj=detailReport.columns[i];
							//var dataIndex=colsObj.dataIndex;
							
							
							var cols=detailReport.columns;
							//�����ж���
							for(var i=0;i<cols.length;i++){
								//��ȡ����
								var colObj=detailReport.columns[i];
								
								
								//��ȡ����dataIndex
								var dataIndex=colObj.dataIndex;
								//��ȡ�ýڵ㵥�е�ԭʼֵ
								var colValue=node.attributes[dataIndex];
								//����ַ���
								var objStr=i+"^"+dataIndex+"^"+colValue;
							}
							
						}
					}
				}
			});
			*/
		},
		scope:this
	});
}

find.addListener('click',finddept,false);


//������Ⱥ���
updateyear = function(){
	var cycleDr=Ext.getCmp('CycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var schemDr=Ext.getCmp('SchemField').getValue();
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var deptDr=Ext.getCmp('deptField').getValue();
	if((deptDr=="")||(deptDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	
	var sm = tree.getSelectionModel();
	var node=sm.getSelectedNode();
	if(node==null){
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫ�������Ŀ��ļ�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
		return false;
	}else{ 
		var yearDataField=new Ext.form.NumberField({
			id:'yearDataField',
			fieldLabel:'�������Ŀ��',
			width:200,
			allowBlank:false,
			blankText:'����д���Ŀ��',
			msTarget:'qtip'
		})
		
		var form = new Ext.form.FormPanel({
			height:100,
			width:300,
			frame:true,
			labelSeparator:':',
			labelWidth:80,
			labelAlign:'right',
			items:[
				yearDataField
			]
		});
		
		//��ʼ�����ð�ť
		setButton = new Ext.Toolbar.Button({
			text:'ȷ��'
		});
		
		//�������ð�ť��Ӧ����
		setHandler = function(){
			//��ȡKPIָ��Dr
			var KPIDr=node.attributes.id;
			if((KPIDr=="")||(KPIDr=="null")){
				Ext.Msg.show({title:'ע��',msg:'ָ����������,����ü�¼��Դ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:350});
				return false;
			}
			//��ȡ���Ŀ������
			var yearData=yearDataField.getValue();
			if(yearData==""){
				yearData=0;
			}
			
			Ext.Ajax.request({
				url: 'dhc.pa.kpitargetsetexe.csp?action=setyeardata&schemDr='+schemDr+'&kpiDr='+KPIDr+'&yearData='+yearData+'&deptDr='+deptDr+'&cycleDr='+cycleDr,
				waitMsg:'������...',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						win.close();
						Ext.Msg.show({title:'ע��',msg:'���Ŀ�����óɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:250});
						finddept();
					}else{
						if(jsonData.info=='NoDatas'){
							Ext.Msg.show({title:'��ʾ',msg:'û�����ݸ��»�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
						}
					}
				},
				scope: this
			});
		}
			
	
		//������ð�ť�ļ����¼�
		setButton.addListener('click',setHandler,false);
		
		//��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});
		
		//����ȡ����ť����Ӧ����
		cancelHandler = function(){
			win.close();
		}
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//��ʼ������
		win = new Ext.Window({
			title: '����������ݴ���',
			width: 350,
			height:150,
			minWidth: 350, 
			minHeight: 150,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyBorder:false, 
			buttonAlign:'center',
			border:false, 
			items:form,
			buttons: [
				setButton,
				cancelButton
			]
		});
		
		//������ʾ
		win.show();
	}
}
updateYearData.addListener('click',updateyear,false);

//ָ��ֽ�
dist = function(){
	var sm = tree.getSelectionModel();
	var node=sm.getSelectedNode();
	if(node==null){
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫ�ֽ��ָ���¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
		return false;
	}else{
		if(node.attributes.leaf==false){
			Ext.Msg.show({title:'��ʾ',msg:'��Ҷ�ӽڵ㲻��ִ��ָ��ֽ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
			return false;
		}else{
			//��ȡ�������
			var yearData = node.attributes.month00;
			if(yearData==0){
				Ext.Msg.show({title:'��ʾ',msg:'���Ŀ��Ϊ0,����Ҫ�ֽ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
				return false;
			}
			//��ȡ�ֽⷽ��
			var distMethodDr = node.attributes.distMethodDr;
//alert(distMethodDr);
			if(distMethodDr==""){
				Ext.Msg.show({title:'��ʾ',msg:'ָ��ֽⷽ��Ϊ��,�������÷���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:350});
				return false;
			}
			if(distMethodDr==0){
				Ext.Msg.show({title:'��ʾ',msg:'��ָ��ֽⷽ��Ϊ���ֽ�,�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:350});
				return false;
			}
			var cycleDr=Ext.getCmp('CycleField').getValue();
			if((cycleDr=="")||(cycleDr=="null")){
				Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
				return false;
			}
			var schemDr=Ext.getCmp('SchemField').getValue();
			if((schemDr=="")||(schemDr=="null")){
				Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
				return false;
			}
			var deptDr=Ext.getCmp('deptField').getValue();
			if((deptDr=="")||(deptDr=="null")){
				Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
				return false;
			}
			//��ȡKPIָ��Dr
			var KPIDr=node.attributes.id;
			if((KPIDr=="")||(KPIDr=="null")){
				Ext.Msg.show({title:'ע��',msg:'ָ����������,����ü�¼��Դ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:350});
				return false;
			}
			//��ȡ����
			Ext.Ajax.request({
				url: 'dhc.pa.kpitargetsetexe.csp?action=distkpi&schemDr='+schemDr+'&kpiDr='+KPIDr+'&yearData='+yearData+'&deptDr='+deptDr+'&cycleDr='+cycleDr+'&distMethodDr='+distMethodDr,
				waitMsg:'������...',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:200});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'ָ��ֽ�ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:200});
						finddept();
					}else{
						if(jsonData.info=='false'){
							Ext.Msg.show({title:'��ʾ',msg:'ָ��ֽ�ʧ��,���ݱ��ع�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
						}
						if(jsonData.info=='NoCycleDr'){
							Ext.Msg.show({title:'��ʾ',msg:'������ݶ�ʧ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
						}
						if(jsonData.info=='NoSchemDr'){
							Ext.Msg.show({title:'��ʾ',msg:'���˷�����ʧ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
						}
						if(jsonData.info=='NoKPIDr'){
							Ext.Msg.show({title:'��ʾ',msg:'����ָ�궪ʧ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
						}
						if(jsonData.info=='NoDeptDr'){
							Ext.Msg.show({title:'��ʾ',msg:'���˲��Ŷ�ʧ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
						}
						if(jsonData.info=='NoYearData'){
							Ext.Msg.show({title:'��ʾ',msg:'��ָ��û��ȱ�����Ŀ��ֵ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
						}
						if(jsonData.info=='UnDistMethodDr'){
							Ext.Msg.show({title:'��ʾ',msg:'��ָ��ȱ��ָ��ֽⷽ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
						}
						if(jsonData.info=='NoDatas'){
							Ext.Msg.show({title:'��ʾ',msg:'û����ѡ������������ָ�걻�ֽ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:350});
						}
					}
				},
				scope: this
			});
		}
	}
}
distKPI.addListener('click',dist,false);

