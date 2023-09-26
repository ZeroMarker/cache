var userid=session['LOGON.USERID'];
var deptdr=session['LOGON.CTLOCID'];
var userCode = session['LOGON.USERCODE'];
var getFullPeriodType = function (date) {
  var d = date.getMonth();
  d=d/3+1;
  return "0"+parseInt(d);

}
var yearField = new Ext.form.TextField({
	id: 'yearField',
	fieldLabel: '���',
	width:100,
	regex: /^\d{4}$/,
	regexText:'���Ϊ��λ����',
	listWidth : 245,
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
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value:'Q', //Ĭ��ֵ
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
var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '',
	value:getFullPeriodType(new Date()),
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


//״̬
var stateStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['0','δ�ύ'],['10','���δͨ��'],['20','���ύ'],['30','���ͨ��'],['60','����'],['','ȫ��']]
});
var stateField = new Ext.form.ComboBox({
	id: 'state',
	fieldLabel: '״̬',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	//allowBlank: false,
	store: stateStore,
	anchor: '90%',
	//value:'M', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'ѡ��״̬����...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var auditbutton = new Ext.Toolbar.Button({
		text : '����',
		iconCls : 'option',
		handler : function() {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			if (len>0){
				for(var i = 0; i < len; i++){
					var rowObj=itemGrid.getSelectionModel().getSelections();
					var rowid = rowObj[i].get("rowid"); 
					var srowid=rowObj[i].get("srowid"); 
					var state=rowObj[i].get("auditstate");
					
					if (!(state=="���ͨ��")){
						Ext.Msg.show({title:'ע��',msg:state+'״̬���ܷ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
						return null;
					} else{
						Ext.Ajax.request({
							url:'dhc.pa.basedeptpacheckexe.csp?action=audit&rowid='+rowid+"&userdr="+userid+"&schemedr="+srowid+"&result="+60+"&deptdr="+deptdr+"&desc="+encodeURIComponent(rowObj[i].get("desc")),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true'){
									Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
									itemGrid.load();
									itemGridDetail.load();
								}
							},
							scope: this
						});
					}
				}	
			}
		}
  });

  var unauditbutton = new Ext.Toolbar.Button({
   	        text : 'ȡ������',
			iconCls : 'option',
			handler : function() {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫȡ������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			if (len>0){
				for(var i = 0; i < len; i++){
					var rowObj=itemGrid.getSelectionModel().getSelections();
					var rowid = rowObj[i].get("rowid"); 
					var srowid=rowObj[i].get("srowid"); 
					var state=rowObj[i].get("auditstate"); 
					if (state!="����"){
						Ext.Msg.show({title:'ע��',msg:'�Ƿ���״̬����ȡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
						return null;
					}    
				
					Ext.Ajax.request({
						url:'dhc.pa.basedeptpacheckexe.csp?action=audit&rowid='
							+rowid+"&userdr="+userid+"&schemedr="+srowid+"&result="+30+"&deptdr="+deptdr,		
						waitMsg:'ȡ��������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ȡ���������!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
								itemGrid.load();
								itemGridDetail.load();
							}
						},
						scope: this
					});
				}
			}
		}
  });

var findButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls:'option',
			handler : function() {
				var pattern=/^\d{4}$/;
				
				
				year=yearField.getValue();
				if(!pattern.test(year)){
					Ext.Msg.show({title:'ע��',msg:'��ݸ�ʽ��������λ��Ч����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
					return null;}
				
	
				type = periodTypeField.getValue();
	
				period = periodField.getValue();
	
				result=stateField.getValue();
				
				period=year+""+period

				itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								userdr: userid,
								type : type,
								period : period,
								result:result
							}
						});

			}
			
		})
		
// ����
var calbutton = new Ext.Toolbar.Button({
					text : '����',
					iconCls : 'add',
					handler : function() {
						 Calufun();
				   }
  });	
 //�������տ��˷� 2016-04-25 cyl add
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
			var period = periodField.getValue();
	    	//var schemDr = SchemCombox.getValue();
			var state = stateField.getValue();
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
					url:'dhc.pa.basicuintpacaluexe.csp'+'?action=copyScore&schemDr='+rowObj[i].get("srowid")+'&year='+year+'&userCode='+userCode+'&period='+period+'&periodType='+periodtype,
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

//���ñ�ͷ��ʾ������û�б�ͷ������������ļ�HERPJXLocSumReport.raq 		
function renderTopic(value, p, record){
	    return String.format(
	    		"<b><a target=\"_blank\" href=\""+dhcReportUrl+"/runqianReport/report/jsp/dhccpmrunqianreport.jsp?cycleDr={1}&frequency={2}&period={3}&schemDr={4}&groupDr={5}&report=HERPJXLocSumReportForOther.raq&reportName=HERPJXLocSumReportForOther.raq&ServerSideRedirect=dhccpmrunqianreport.csp\">���˻��ܱ�</a></b>",
	            value, record.data.yearid,record.data.frequency,record.data.changedperiod,record.data.srowid,record.data.GroupDr
	            );
}

function renderBlue(value, p, record){
	    return String.format(
	    		"<font color=\"blue\"><b>"+value+"</b></font>",
	            value);
}

var itemGrid = new dhc.herp.Grid({
        title: 'ҽ�񴦼�Ч���˼���',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.pa.medicalpacalexe.csp',	  
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [
        new Ext.grid.CheckboxSelectionModel({editable:false}),
        {
	         id:'rowid',
		     header: '����״̬id',
		     allowBlank: false,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'rowid'
		}, {
	         id:'yearid',
		     header: 'yearid',
		     allowBlank: false,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'yearid'
		}, {
		     id:'period',
		     header: '������',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'period'
		}, {
		     id:'code',
		     header: '�������',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'code'
		}, {
		     id:'name',
		     header: '��������',
		     allowBlank: false,
		     width:160,
		     editable:false,
		     dataIndex: 'name'
		}, {
		 	 id:'nothing',
		     header: '���˻��ܱ�',
		     allowBlank: false,
		     width:150,
		     editable:false,
		     dataIndex: 'nothing',
		     renderer : renderTopic
		}, {
		     id:'auditdr',
		     header: '������',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     //hidden:true,
		     dataIndex: 'auditdr'
		}, {
		     id:'auditstate',
		     header: '״̬',
		     allowBlank: false,
		     
		     width:100,
		     editable:false,
		     dataIndex: 'auditstate',
		     renderer:renderBlue
		}, {
		     id:'desc',
		     header: '�������',
		     allowBlank: false,
		     width:100,
		     //editable:false,
		     //hidden:true,
		     dataIndex: 'desc'
		}, {
		     id:'auditdate',
		     header: '�������',
		     allowBlank: false,
		     width:100,
		     //hidden:true,
		     editable:false,
		     dataIndex: 'auditdate'
		}, {
		     id:'srowid',
		     header: '����id',
		     allowBlank: false,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'srowid'

		}, {
		     id:'frequency',
		     header: '�ڼ�����',
		     allowBlank: false,
		     hidden:true,
		     width:100,
		     editable:false,
		     dataIndex: 'frequency'
		}, {
		     id:'upschemdr',
		     header: '�ϼ�����',
		     allowBlank: false,
		     hidden:true,
		     width:100,
		     editable:false,
		     dataIndex: 'upschemdr'

		},{
			id : 'GroupDr',
			header : '���ҷ���ID',
			align:'center',
			editable:false,
			width : 80,
			hidden : true,
			dataIndex : 'GroupDr'
			
		},{
			id : 'changedperiod',
			header : '������',
			align:'center',
			editable:false,
			hidden : true,
			width : 80,
			dataIndex : 'changedperiod'  
		}],
        
        tbar:['���',yearField,'�ڼ�����',periodTypeField,'�ڼ�',periodField,'״̬',stateField,findButton,auditbutton,'-',unauditbutton,'-',calbutton,"-",CopyScoreButton]
        
});
findButton.handler();

 //�����޸İ�ť��Ӧ����
auditHandler = function(){
		
       
};
itemGrid.btnAddHide() ;	//�������Ӱ�ť
itemGrid.btnSaveHide(); 	//���ر��水ť
itemGrid.btnResetHide(); 	//�������ð�ť
itemGrid.btnDeleteHide(); //����ɾ����ť
itemGrid.btnPrintHide() ;	//���ش�ӡ��ť

// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//  ״̬

	var records = itemGrid.getSelectionModel().getSelections();
	var srowid = records[0].get("srowid");
	var period = records[0].get("period");
	var type = periodTypeField.getValue();
	itemGridDetail.load({
							params : {
								start : 0,
								limit : 100,
								userdr:userid,
								schemedr: srowid,
								type: type,
								period : period
							}
						});
	
});
// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//  ״̬
	if (columnIndex == 9) {
	var records = itemGrid.getSelectionModel().getSelections();
	var schemrowid = records[0].get("rowid");
	var title = records[0].get("name");
	StatesDetail(title,schemrowid);
	}
});
