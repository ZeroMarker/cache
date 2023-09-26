//*name:�Բ鱨������������
  //*author:�Ʒ��
  //*Date:2015-5-18
/*var getFullPeriodType = function (date) {
  var d = date.getMonth();
  d=d/3+1;
  var m ="0"+parseInt(d)-1;
  if (m<1){return "04";}
  else
  {return m;}

}*/
var getFullPeriodType = function (date) {
  var d = date.getMonth();
 
  var m ="0"+parseInt(d)-1;
  if (m<1){return "12";}
  else
  {return m;}

}
var periodYear = new Ext.form.TextField({
	id: 'periodYear',
	fieldLabel: '���',
	width:50,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'��������λ���ֵ����',
	value:(new Date()).getFullYear(),
	name: 'periodYear',
	minChars: 1,
	pageSize: 10,
	editable:false
});

var dataStr="";

var data="";
var data1=[['01','01��'],['02','02��'],['03','03��'],['04','04��'],['05','05��'],['06','06��'],['07','07��'],['08','08��'],['09','09��'],['10','10��'],['11','11��'],['12','12��']];
var data2=[['01','01����'],['02','02����'],['03','03����'],['04','04����']];
var data3=[['01','1~6�ϰ���'],['02','7~12�°���']];
var data4=[['00','ȫ��']];
var count1=0;
var count2=0;

var monthStore="";



var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '�ڼ�����',
	width:50,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value:'M',
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
		nameDs.removeAll();   
        nameField.setValue('');
        nameDs.proxy = new Ext.data.HttpProxy({url:itemGridUrl+'?action=nameList&userID='+userID+'&periodType='+encodeURIComponent(Ext.getCmp('periodTypeField').getValue()),method:'POST'});
		nameDs.load({params:{start:0,limit:10}});
	}}   
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){data=data1;}
	if(cmb.getValue()=="Q"){data=data2;}
	if(cmb.getValue()=="H"){data=data3;}
	if(cmb.getValue()=="Y"){data=data4;}
	startperiodStore.loadData(data);
	endperiodStore.loadData(data);
	
});

startperiodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});
startperiodStore.loadData([['01','01��'],['02','02��'],['03','03��'],['04','04��'],['05','05��'],['06','06��'],['07','07��'],['08','08��'],['09','09��'],['10','10��'],['11','11��'],['12','12��']]);

var startperiodField = new Ext.form.ComboBox({
	id: 'startperiodField',
	fieldLabel: '',
	value:'01',
	width:80,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: startperiodStore,
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
endperiodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});
endperiodStore.loadData([['01','01��'],['02','02��'],['03','03��'],['04','04��'],['05','05��'],['06','06��'],['07','07��'],['08','08��'],['09','09��'],['10','10��'],['11','11��'],['12','12��']]);

var endperiodField = new Ext.form.ComboBox({
	id: 'endperiodField',
	fieldLabel: '',
	//value:'0'+getFullPeriodType(new Date()),
	value:'0'+getFullPeriodType(new Date()),
	width:80,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: endperiodStore,
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

var nameDs = new Ext.data.Store({   //��������Դ
           
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'	
			},['groupRowid','groupName'])	
});

nameDs.on('beforeload',function(ds,o){  //����Դ�����������ú�̨�෽����ѯ����
    var periodType=periodTypeField.getValue();
	ds.proxy = new Ext.data.HttpProxy({
		url:'dhc.pa.uirseaexe.csp'+'?action=nameList&userID='+userID+'&periodType='+periodType,method:'POST'
	});	
});

var nameField = new Ext.form.ComboBox({   //���嵥λ��Ͽؼ�
            id: 'nameField',
			fieldLabel: '�Բ�����',
			width: 120,
			listWidth: 240,
			selectOnFocus: true	,
			store: nameDs,
			anchor: '90%',
	        valueNotFoundText:'',
			displayField: 'groupName',
			valueField: 'groupRowid',
			triggerAction: 'all',
			emptyText: '��ѡ��...',
			typeAhead: true,
			forceSelection: true,
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
	        forceSelection: true		
});
        var CycleDr= periodYear.getValue();
        var startperiod = startperiodField.getValue();
        var endperiod = endperiodField.getValue();
        var periodType = periodTypeField.getValue();
        var name = nameField.getValue();
        var userID = session['LOGON.USERID'];

var itemGridUrl = '../csp/dhc.pa.uirseaexe.csp';
//�������Դ

var itemGridProxy= new Ext.data.HttpProxy({url: itemGridUrl + '?action=list&CycleDr='+ CycleDr+'&startperiod=' + startperiod+'&endperiod=' + endperiod+'&periodType=' + periodType+'&name=' + name+'&userID=' + userID
						});
var userID = session['LOGON.USERID'];
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
	         'rowid',
			'deptname',
			'cmd',
			'startperiod',
			'endperiod',
			'period',
			'code',
			'periodYear',
			'periodmonth',
			'periodType',
			'submitStateName',
			'auditStateName',
			'updateStateName',
			'namedr',
			'name',
			'updateUserName',
			'updateDate',
			'submiUserName',
			'submiDate',
			'auditUserName',
			'auditDate'
		]),
	    remoteSort: true
});

//��Ӹ�ѡ��
var sm = new Ext.grid.CheckboxSelectionModel();
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"//,

});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('rowid', 'Name');








//var tmpTitle='�����ȼ�';

//���ݿ�����ģ��
var itemGridCm = new Ext.grid.ColumnModel([
    sm,
        new Ext.grid.RowNumberer(),
         {
			header : 'ID',
			dataIndex : 'rowid',
			width : 40,
			hidden : true,
			sortable : true
		}, {

            id:'deptname',
            header: '����',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'deptname'
            
           
       },{

            id:'cmd',
            header: 'cmd',
            allowBlank: false,
            width:100,
            editable:false,
            hidden : true,
            dataIndex: 'cmd'
            
           
       },  {
		    id:'period',
			header: '�ڼ�',
			dataIndex: 'period',
		    width: 100,		  
			
			sortable: true
		},{
            id:'code',
            header: '�Բ����',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'code'
            
       },{
            id:'name',
            header: '�Բ�����',
            allowBlank: false,
            width:100,
           editable:false,
            
            dataIndex: 'name'
            
       },{
            id:'submitStateName',
            header: '״̬',
            allowBlank: false,
            width:100,
            editable:false,
            
            renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) {
	            var sf = record.data['submitStateName']
						           //return '<span style="color:blue;cursor:hand">'+value+'</span>';
						 if (sf == "���ύ") {
								return '<span style="color:blue;cursor:hand"><u>'
										+ value + '</u></span>';
							} else  {
								return '<span style="color:red;cursor:hand"><u>'
										+value + '</u></span>';
							}
	             
	             
	             },
            dataIndex: 'submitStateName'
            
       },{
            id:'submiUserName',
            header: '�ύ��',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'submiUserName'
            
       }, {
            id:'submiDate',
            header: '�ύʱ��',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'submiDate'
            
       }, {
            id:'auditStateName',
            header: '����״̬',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'auditStateName'
            
       },{
            id:'auditUserName',
            header: '������',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'auditUserName'
            
       },{
            id:'auditDate',
            header: '����ʱ��',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'auditDate'
            
       }, {
            id:'updateStateName',
            header: '�޸�״̬',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'updateStateName'
            
       },{
            id:'updateUserName',
            header: '�޸���',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'updateUserName'
            
       },{
            id:'updateDate',
            header: '�޸�ʱ��',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'updateDate'
            
       },{
							id:'download',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
								//alert(itemGrid1);
							return '<span style="color:blue"><u>����</u></span>';
							//return '<span style="color:gray;cursor:hand">���</span>';
					    } 
       }
			    
]);

//��ѯ����
var SearchButton = new Ext.Toolbar.Button({
    text: '��ѯ', 
    tooltip:'��ѯ',        
    iconCls:'search',
	handler:function(){	
         var CycleDr= periodYear.getValue();
        var startperiod = startperiodField.getValue();
        var endperiod = endperiodField.getValue();
        var periodType = periodTypeField.getValue();
        var name = nameField.getValue();
        var userID = session['LOGON.USERID'];
       if((CycleDr=="")||(CycleDr=="null")){
			Ext.Msg.show({title:'ע��',msg:'��ݲ���Ϊ��,���������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}
		
		if((startperiod=="")||(startperiod=="null")){
			Ext.Msg.show({title:'ע��',msg:'��ʼ�ڼ䲻��Ϊ��,��ѡ��ʼ�ڼ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}
		if((endperiod=="")||(endperiod=="null")){
			Ext.Msg.show({title:'ע��',msg:'�����ڼ䲻��Ϊ��,��ѡ������ڼ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}
		if((periodType=="")||(periodType=="null")){
			Ext.Msg.show({title:'ע��',msg:'�ڼ����Ͳ���Ϊ��,��ѡ���ڼ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}
		
	itemGridDs.load(({params:{start:0,limit:itemGridPagingToolbar.pageSize,CycleDr:CycleDr,startperiod:startperiod,endperiod:endperiod,periodType:periodType,name:name,userID:userID}}));
	
	}
});
///����ť
var AuditingButton = new Ext.Toolbar.Button({
			text : '����',
			tooltip : '����',
			iconCls : 'audit',
			handler : function() {
				itemAuditing(itemGrid, itemGridDs);
			}
		});
function itemAuditing(itemGrid, itemDs) {
    
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1) {
		Ext.Msg.show({
					title : 'ע��',
					msg : '��ѡ����Ҫ���������!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}

	var rowid = rowObj[0].get("rowid")
	var isCalc = rowObj[0].get("submitStateName")
	var IsAuditing = rowObj[0].get("auditStateName")
    var userID = session['LOGON.USERID'];
	if (isCalc == "δ�ύ") {
		Ext.Msg.show({
					title : 'ע��',
					msg : '�÷���δ�ύ�����Ƚ����ύ!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}
	if (IsAuditing == "���ͨ��") {
		Ext.Msg.show({
					title : 'ע��',
					msg : '�ü�¼�Ѿ����!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}

	Ext.MessageBox.confirm('��ʾ', 'ȷʵҪ��˸ü�¼��?', Auditing);

	function Auditing(id) {

		if (id == 'yes') {

			Ext.Ajax.request({
				url : itemGridUrl + '?action=Auditing&rowid=' + rowid+'&userID=' + userID
						+ '&IsAuditing=1',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var rtn = result.responseText;
					if (rtn == 0) {
						Ext.Msg.show({
									title : 'ע��',
									msg : '������˳ɹ�!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
						itemGridDs.load({
							params : {
								CycleDr : Ext.getCmp('periodYear').getValue(),
								startperiod : Ext.getCmp('startperiodField').getValue(),
								endperiod : Ext.getCmp('endperiodField').getValue(),
								periodType : Ext.getCmp('periodTypeField').getValue(),
								name : Ext.getCmp('nameField').getValue(),
								userID : session['LOGON.USERID'],
								start : 0,
								limit : itemGridPagingToolbar.pageSize
							}
						});

						window.close();
					} else {
						var message = "";
						message = "��¼���ʧ�ܣ�";
						Ext.Msg.show({
									title : '����',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					}
				},
				scope : this
			});

		}
	}

}
var editButton = new Ext.Toolbar.Button({
					text : '�����޸�',
					tooltip : '�����޸�',
					iconCls : 'edit',
					handler : function() {
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
		 var rowId = rowObj[0].get("rowid");                 
		var isCalc = rowObj[0].get("submitStateName")
	var IsAuditing = rowObj[0].get("auditStateName")
    var update = rowObj[0].get("updateStateName")
	if (isCalc == "δ�ύ") {
		Ext.Msg.show({
					title : 'ע��',
					msg : '�÷���δ�ύ�����Ƚ����ύ!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}
	if (IsAuditing == "���ͨ��") {
		Ext.Msg.show({
					title : 'ע��',
					msg : '�ü�¼�Ѿ����!�޷��޸�',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}		
	if (update == "�����޸�") {
		Ext.Msg.show({
					title : 'ע��',
					msg : '�ü�¼�Ѿ������޸�',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}		
				//var type = uTypeField.getValue(); 
              
                Ext.Ajax.request({
				url:'dhc.pa.uirseaexe.csp?action=edit&rowId='+rowId,
				
				waitMsg:'������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize,CycleDr:Ext.getCmp('periodYear').getValue(),startperiod:Ext.getCmp('startperiodField').getValue(),endperiod:Ext.getCmp('endperiodField').getValue(),periodType:Ext.getCmp('periodTypeField').getValue(),name:Ext.getCmp('nameField').getValue(),userID:session['LOGON.USERID']}});
					
								
										
				}
				else
					{
						var message="�Ѵ�����ͬ��¼";
						Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					};
			},
				scope: this
			});
			
		}

				});

var itemGrid = new Ext.grid.GridPanel({
			//title: 'ϵͳģ�鶨��',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'dhc.pa.uirseaexe.csp',
		    //atLoad : true, // �Ƿ��Զ�ˢ��
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: sm,
			loadMask: true,
			tbar:['���:','-',periodYear,'�ڼ�����:','-',periodTypeField,'-','��ʼ�ڼ�:','-',startperiodField,'-','�����ڼ�:','-',endperiodField,'-','�Բ�����:','-',nameField,'-',SearchButton,'-',AuditingButton,'-',editButton],
			bbar:itemGridPagingToolbar
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});


// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	 //alert(columnIndex)
	if (columnIndex ==8) {
		var records = itemGrid.getSelectionModel().getSelections();
		var rowid = records[0].get("rowid");
		var submitStateName = records[0].get("submitStateName");
		if(submitStateName== '���ύ'){
		
		sysdeptkindeditFun (submitStateName,rowid);
		}
		else {}
	}
	if (columnIndex ==17) {
		var records = itemGrid.getSelectionModel().getSelections();
		var UDRDDr = records[0].get("cmd");
		//alert(UDRDDr);
		/*var submitStateName = records[0].get("submitStateName");
		if(submitStateName== '���ύ'){
		
		sysdeptkindeditFun (submitStateName,rowid);
		}
		else {}*/
		downloadFun(UDRDDr,itemGrid);
	}
	});
	

