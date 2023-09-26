//����ؼ���ȫ�ֱ���

var data1=[['1','01��'],['2','02��'],['3','03��'],['4','04��'],['5','05��'],['6','06��'],['7','07��'],['8','08��'],['9','09��'],['10','10��'],['11','11��'],['12','12��']];
var data2=[['1','01����'],['2','02����'],['3','03����'],['4','04����']];
var data3=[['1','1~6�ϰ���'],['2','7~12�°���']];
var data4=[['0','00']];
var count1=0;
var count2=0;
var count3=0;
var deptdr=session['LOGON.CTLOCID'];
var userCode = session['LOGON.USERCODE'];
var userdr = session['LOGON.USERID'];

//==========================================================
function formatDate(value){
	return value?value.dateFormat('Y-m-d'):'';
};

function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};
var getFullPeriodType = function (date) {
  var d = date.getMonth();
  d=d/3+1;
  return "0"+parseInt(d);

}
var yearField = new Ext.form.TextField({
	id: 'yearField',
	fieldLabel: '���',
	width:50,
	regex: /^\d{4}$/,
	regexText:'���Ϊ��λ����',
	listWidth :50,
	triggerAction: 'all',
	emptyText:'',
	name: 'yearField',
	value:(new Date()).getFullYear(),
	minChars: 1,
	pageSize: 10,
	editable:true
});

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '�ڼ�����',
	width:60,
	listWidth :60,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	//anchor: '90%',
	value:'Q', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'ѡ���ڼ�����...',
	mode: 'local', //����ģʽ
	editable:false,
	//pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){
		data=[['01','01��'],['02','02��'],['03','03��'],['04','04��'],['05','05��'],['06','06��'],['07','07��'],['08','08��'],['09','09��'],['10','10��'],['11','11��'],['12','12��']];
	}
	if(cmb.getValue()=="Q"){
		data=[['01','01����'],['02','02����'],['03','03����'],['04','04����']];
	}
	if(cmb.getValue()=="H"){
		data=[['01','1~6�ϰ���'],['02','7~12�°���']];
	}
	if(cmb.getValue()=="Y"){
		data=[['00','ȫ��']];
	}
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});
periodStore.loadData([['01','01����'],['02','02����'],['03','03����'],['04','04����']]);
var PeriodField = new Ext.form.ComboBox({
	id: 'PeriodField',
	fieldLabel: '',
	width:80,
	listWidth : 80,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	value:getFullPeriodType(new Date()),
	//anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'��ѡ��...',
	mode: 'local', //����ģʽ
	editable:false,
	//pageSize: 12,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
///////////////////����/////////////////////////////  
var SchemDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['schemDr','schemname'])
	});
					
SchemDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:'dhc.pa.basicuintpacaluexe.csp'+'?action=listschems&str='+encodeURIComponent(Ext.getCmp('SchemCombox').getRawValue())+'&userCode='+userCode,method:'POST'});
	});
	
var SchemCombox = new Ext.form.ComboBox({
				    id :'SchemCombox',
				    fieldLabel: '����',
				    width:200,
				    listWidth :200,
				     resizable:true,
				    allowBlank : false, 
				    store: SchemDs,
				    valueField: 'schemDr',
				    displayField: 'schemname',
				    triggerAction: 'all',
				    //emptyText:'ѡ��...',
				    name: 'SchemCombox',
			    	minChars: 1,
				    pageSize: 10,
				    anchor: '95%',
				    selectOnFocus:true,
				    forceSelection:'true',
				    editable:true
			});
///////////////////״̬/////////////////////////////  
var StateDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['0', 'δ�ύ'],['10', '���δͨ��'], ['20', '���ύ'], ['30', '���ͨ��'], ['60', '����']]
	});		
		
var StateCombox = new Ext.form.ComboBox({
	                   id : 'StateCombox',
		           fieldLabel : '״̬',
	                   width : 100,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : StateDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		          
		           selectOnFocus : true,
		           forceSelection : true
						  });	
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'option',
	handler: function(){
	    var year = yearField.getValue();
		var pattern=/^\d{4}$/;
        if(!pattern.test(year)){
			Ext.Msg.show({title:'ע��',msg:'��ݸ�ʽ��������λ��Ч����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
			return null;
		}

	    var periodtype = periodTypeField.getValue();
		var period = PeriodField.getValue();
	    var schemDr = SchemCombox.getValue();
		var state = StateCombox.getValue();
		itemGrid.load({params:{start:0,limit:25,year:year,periodType:periodtype,period:period,userCode:userCode,schemDr:schemDr,state:state}});
	}
});

//���㰴ť
var CaluButton = new Ext.Toolbar.Button({
					text : '����',
					iconCls : 'add',
					handler : function() {
						 Calufun();
				   }
  });
//�ύ��ť
var SubmitButton = new Ext.Toolbar.Button({
   	        text : '�ύ',
			iconCls : 'option',
			handler : function() {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			 for(var i = 0; i < len; i++){
			    var  curstate=rowObj[i].get("auditstate");
				var procdesc = "";
				if (curstate=="���δͨ��")
				{
				Ext.Msg.show({title:'����',msg:'����ȡ���ύ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}else
			    if ((curstate=="���ύ")||(curstate=="���ͨ��")||(curstate=="����"))
				{
				Ext.Msg.show({title:'����',msg:curstate+'�����ύ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			    else
				{
				   Ext.Ajax.request({
					//url:'dhc.pa.basicuintpacaluexe.csp'+'?action=submit&schemrowid='
					//+rowObj[i].get("schemrowid")
					//+'&sprrowid='+rowObj[i].get("sprrowid")+'&userid='+userdr+'&procdesc='+procdesc
					//+'&desc='+encodeURIComponent(rowObj[i].get("auditdesc")),
					url:'dhc.pa.basedeptpacheckexe.csp?action=check&rowid='
					+rowObj[i].get("sprrowid")+"&userdr="+userdr+"&schemedr="+rowObj[i].get("schemrowid")+"&result="+20+"&deptdr="
					+deptdr+"&desc="+encodeURIComponent(rowObj[i].get("auditdesc")),
		
					waitMsg:'������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								//var apllycode = jsonData.info;
								Ext.Msg.show({title:'ע��',msg:'�ύ�ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});								 itemGrid.load({params:{start:0, limit:25,userCode:userCode}});
							}
							else
							{
								//var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'����',msg:'�ύʧ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
					},
					scope: this
			 });
				}
		     }
			}
		}
  });	
//ȡ���ύ��ť
var CancelSubmitButton = new Ext.Toolbar.Button({
   	        text : 'ȡ���ύ',
			iconCls : 'option',
			handler : function() {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫȡ���ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			for(var i = 0; i < len; i++){
			  var  curstate=rowObj[i].get("auditstate");
			  var procdesc="";
			  if (curstate=="���ύ"||curstate=="���δͨ��")
			  {
			     Ext.Ajax.request({
					//sprrowid url:'dhc.pa.basicuintpacaluexe.csp'+'?action=cancelsubmit&schemrowid='+rowObj[i].get("schemrowid")+'&sprrowid='+rowObj[i].get("sprrowid")+'&userid='+userdr+'&procdesc='+procdesc+'&desc='+encodeURIComponent(rowObj[i].get("auditdesc")),
					url:'dhc.pa.basedeptpacheckexe.csp?action=check&rowid='
					+rowObj[i].get("sprrowid")+"&userdr="+userdr+"&schemedr="+rowObj[i].get("schemrowid")+"&result="+0+"&deptdr="
					+deptdr+"&desc="+encodeURIComponent(rowObj[i].get("auditdesc")),
					waitMsg:'������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								//var apllycode = jsonData.info;
								Ext.Msg.show({title:'ע��',msg:'ȡ���ύ�ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});								itemGrid.load({params:{start:0, limit:25,userCode:userCode}});
							}
							else
							{
								//var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'����',msg:'ȡ���ύʧ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
					},
					scope: this
			 });
			  }
			else{
			   Ext.Msg.show({title:'����',msg:curstate+'���ܽ���ȡ���ύ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); 
			   }
			}
		   }
		}
  });	 

//�������շ���
var CopyScoreButton = new Ext.Toolbar.Button({
   	        text : '�������շ�',
			iconCls : 'option',
			handler : function() {
				
		    var year = yearField.getValue();
			var pattern=/^\d{4}$/;
       		if(!pattern.test(year)){
				Ext.Msg.show({title:'ע��',msg:'��ݸ�ʽ��������λ��Ч����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;
			}
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			var periodtype = periodTypeField.getValue();
			var period = PeriodField.getValue();
	    	//var schemDr = SchemCombox.getValue();
			var state = StateCombox.getValue();
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�������շ����ļ�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
			for(var i = 0; i < len; i++){
			  var  curstate=rowObj[i].get("auditstate");
			  var procdesc="";
			  if (curstate=="δ�ύ")
			  {
			     Ext.Ajax.request({
					url:'dhc.pa.basicuintpacaluexe.csp'+'?action=copyScore&schemDr='+rowObj[i].get("schemrowid")+'&year='+year+'&userCode='+userCode+'&period='+period+'&periodType='+periodtype,
					waitMsg:'������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								//var apllycode = jsonData.info;
								Ext.Msg.show({title:'ע��',msg:'�������շֳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});								
								itemGrid.load({params:{start:0, limit:25,userCode:userCode}});
							}
							else
							{
								//var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'����',msg:'�������շ�ʧ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
					},
					scope: this
			 });
			  }
			else{
			   Ext.Msg.show({title:'����',msg:'�ü�¼�����ٽ����������շ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); 
			   }
			}
		   }
		}
  });	 

  
function renderTopic(value, p, record){
	//console.log(record);
	    return String.format(
	    		"<b><a target=\"_blank\" href=\""+dhcReportUrl+"/runqianReport/report/jsp/dhccpmrunqianreport.jsp?cycleDr={1}&frequency={2}&period={3}&schemDr={4}&groupDr={5}&report=HERPJXLocSumReportForOther.raq&reportName=HERPJXLocSumReportForOther.raq&ServerSideRedirect=dhccpmrunqianreport.csp\">{0}</a></b>",
	            value, record.data.yearid,record.data.checkperiodType,record.data.changedperiod,record.data.schemrowid,record.data.GroupDr);
}

var itemGrid = new dhc.herp.Grid({
		    title: '������Ҽ�Ч���˼���',
		    region : 'north',
		    url: 'dhc.pa.basicuintpacaluexe.csp',
			listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {				
		                var record = grid.getStore().getAt(rowIndex);
						if ((record.data.auditstate== "δ�ύ")||(record.data.auditstate== "���ύ"))  
						{
						    if (columnIndex==15){
							  var cl1 = grid.getColumnModel().getIndexById("auditdesc");
							  grid.getColumnModel().setEditable(cl1,true);
		                      return true;
		                    } 
						}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
	                    var record = grid.getStore().getAt(rowIndex);
						if ((record.data.auditstate== "δ�ύ")||(record.data.auditstate== "���ύ")) 
						{
						    if (columnIndex==15){
							  var cl1 = grid.getColumnModel().getIndexById("auditdesc");
							  grid.getColumnModel().setEditable(cl1,true);
		                      return true;
		                    } 
						}
					   }
            },
			fields : [
			       new Ext.grid.CheckboxSelectionModel({hidden :false,editable:false
			       	
				     	
				      }),
			       {
						header : '����ID',
						dataIndex : 'schemrowid',
						editable:false,
						hidden : true
					},  {
						header : '״̬��ID',
						dataIndex : 'sprrowid',
						editable:false,
						hidden : true
					}, {
						id : 'yearid',
						header : '���ID',
						align:'center',
						editable:false,
						width : 80,
						hidden : true,
						dataIndex : 'yearid'

					},{
						id : 'GroupDr',
						header : '���ҷ���ID',
						align:'center',
						editable:false,
						width : 80,
						hidden : true,
						dataIndex : 'GroupDr'

					},{
						id : 'checkperiodType',
						header : '�����ڼ�ID',
						align:'center',
						editable:false,
						width : 80,
						hidden:true,
						dataIndex : 'checkperiodType'

					},{
						id : 'checkperiodTypeName',
						header : '�����ڼ�',
						align:'center',
						editable:false,
						width : 80,
						dataIndex : 'checkperiodTypeName'

					},{
						id : 'checkperiod',
						header : '������',
						align:'center',
						editable:false,
						width : 80,
						dataIndex : 'checkperiod'   

					},{
						id : 'changedperiod',
						header : '��κ�����',
						align:'center',
						editable:false,
						hidden:true,
						width : 80,
						dataIndex : 'changedperiod'   

					},{
						id : 'schemcode',
						header : '�������',
						align:'center',
						editable:false,
						width : 80,
						dataIndex : 'schemcode'

					},{
						id : 'schemname',
						header : '��������',
						align:'center',
						width : 180,
						editable:false,
						dataIndex : 'schemname'

					},{
						id : 'auditstate',
						header : '״̬',
						editable:false,
						align:'center',
						width : 80,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'auditstate'

					}, {
						id : 'maininfo',
						header : '�鿴���ܱ�',
						editable:false,
						align:'center',
						width : 120,
						renderer : renderTopic,
						dataIndex : 'maininfo'
					}, {
						id : 'auditor',
						header : '������',
						align:'center',
						editable:false,
						width : 120,
						dataIndex : 'auditor'

					},{
						id : 'auditdesc',
						header : '�������',
						width : 250,
						editable : false,
						align:'center',
						dataIndex : 'auditdesc'
						
					}],

						split : true,
						collapsible : true,
						containerScroll : true,
						xtype : 'grid',
						trackMouseOver : true,
						stripeRows : true,
						sm : new Ext.grid.RowSelectionModel({
									singleSelect : true
								}),
						loadMask : true,
						tbar:['���:',yearField,'-','�ڼ�����:',periodTypeField,'-','�ڼ�:',PeriodField,'-','����:',SchemCombox,'-','״̬:',StateCombox,'-',findButton,CaluButton,SubmitButton,CancelSubmitButton,CopyScoreButton],
						height:300,
						trackMouseOver: true,
						stripeRows: true
		});

    itemGrid.btnAddHide();  //�������Ӱ�ť
   	itemGrid.btnSaveHide();  //���ر��水ť
    itemGrid.btnResetHide();  //�������ð�ť
    itemGrid.btnDeleteHide(); //����ɾ����ť
    itemGrid.btnPrintHide();  //���ش�ӡ��ť

findButton.handler();
/*
itemGrid.load({	
	params:{start:0,limit:25,userCode:userCode},

	callback:function(record,options,success ){

	itemGrid.fireEvent('rowclick',this,0);
	}
});

//2016-8-24 add cyl
itemGrid.getSelectionModel().on('rowselect',function(sm,rowIndex,record){
         var rowObj = sm.getSelections();
  
		schemmainrowid = rowObj[0].get("schemrowid");
	    var url='dhc.pa.basicuintpacaluexe.csp?action=kpilist&schem='+schemmainrowid;
		kpiTreeLoader.dataUrl=url+"&parent=0";	
	
		Ext.getCmp('kpiGrid').getNodeById("roo").reload()
  });/*
  */
itemGrid.on('rowclick',function(grid,rowIndex,e){	
	
	var clickObj=e.target; //2016-06-14 add cyl
	var clickObjClass=$(clickObj).attr("class");
	
	if(clickObjClass!="x-grid3-row-checker"){
	    var rowObj = grid.getSelectionModel().getSelections();
  
		schemmainrowid = rowObj[0].get("schemrowid");
	    var url='dhc.pa.basicuintpacaluexe.csp?action=kpilist&schem='+schemmainrowid;
		kpiTreeLoader.dataUrl=url+"&parent=0";	
	
		Ext.getCmp('kpiGrid').getNodeById("roo").reload();
	}
		
});

// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//  ״̬
	if (columnIndex == 12) {
	var records = itemGrid.getSelectionModel().getSelections();
	var schemrowid = records[0].get("sprrowid");
	var title = records[0].get("schemname");
	StatesDetail(title,schemrowid);
	}
});

