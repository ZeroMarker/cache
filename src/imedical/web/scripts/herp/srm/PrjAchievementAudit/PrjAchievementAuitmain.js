var userdr = session['LOGON.USERCODE'];

var ListUrl='herp.srm.prjachievementapplyexe.csp';

var itemGridUrl='herp.srm.auditprjachievementexe.csp';

Date.dayNames = ["��", "һ", "��", "��", "��", "��", "��"];  
    Date.monthNames=["1��","2��","3��","4��","5��","6��","7��","8��","9��","10��","11��","12��"];  
    if (Ext.DatePicker) {  
        Ext.apply(Ext.DatePicker.prototype, {  
            todayText: "����",  
            minText: "��������С����֮ǰ",  
            maxText: "�������������֮��",  
            disabledDaysText: "",  
            disabledDatesText: "",  
            monthNames: Date.monthNames,  
            dayNames: Date.dayNames,  
            nextText: '���� (Control+Right)',  
            prevText: '���� (Control+Left)',  
            monthYearText: 'ѡ��һ���� (Control+Up/Down ���ı���)',  
            todayTip: "{0} (Spacebar)",  
            okText: "ȷ��",  
            cancelText: "ȡ��" 
        });  
    }  
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};
///////////////////����/////////////////////////////  
var TypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var TypeCombox = new Ext.form.ComboBox({
	                   id : 'TypeCombox',
		           fieldLabel : '����',
	                   width : 120,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : TypeDs,
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
//////���
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : ListUrl+'?action=yearList&str='+encodeURIComponent(Ext.getCmp('YearCombo').getRawValue()), 
                        method:'POST'
					});
		});

var YearCombo = new Ext.form.ComboBox({
			id:'YearCombo',
			fieldLabel : '���',
			store : YearDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			// emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

 ///��������
var RewardTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
RewardTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : ListUrl+'?action=rewardTypeList&str='+encodeURIComponent(Ext.getCmp('RewardTypeCombo').getRawValue()), 
                        method:'POST'
					});
		});

var RewardTypeCombo = new Ext.form.ComboBox({
			id:'RewardTypeCombo',
			fieldLabel : '��������',
			store : RewardTypeDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			// emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
///��������
var RewardDictDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
RewardDictDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : ListUrl+'?action=rewardDictList&str='+encodeURIComponent(Ext.getCmp('RewardDictCombo').getRawValue()), 
                        method:'POST'
					});
		});

var RewardDictCombo = new Ext.form.ComboBox({
			id:'RewardDictCombo',
			fieldLabel : '��������',
			store : RewardDictDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			// emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
	
// ////////////��������
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

/////////////////��˽��///////////////////////////
var AuditStateStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','�ȴ�����'],['2','��ͨ��'],['3','δͨ��']]
});

var AuditStateField = new Ext.form.ComboBox({
	id: 'AuditState',
	fieldLabel: '��˽��',
	width:120,
	listWidth : 120,
	allowBlank: true,
	store:AuditStateStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	// emptyText:'��ѡ����˽��...',
	mode : 'local',
	name: 'AuditState',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

/////////////////����ʱ��///////////////////////
var RewardDateField = new Ext.form.DateField({
	        id: 'RewardDateField',
			fieldLabel: '����ʱ��',
			width:180,
			allowBlank:false,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
		
/////////////////��ѯ��ť��Ӧ����//////////////
function SearchFun()
{
	    var year = YearCombo.getValue();
	    var rewardtype= RewardTypeCombo.getValue();
	    var rewarddict  = RewardDictCombo.getValue();
	    var prjname = titleText.getValue();   
	    var auditstate =  AuditStateField.getValue();
		var type =TypeCombox.getValue();
	    var data= year+'|'+rewardtype+'|'+rewarddict+'|'+prjname+'|'+auditstate+'|'+userdr+'|'+type;

	itemGrid.load({
		    params:{
		    data:data,
		    sortField:'',
		    sortDir:'',
		    start:0,
		    limit:25   
		   }
	  });
	
}

//////////////////////////////////////////////

var queryPanel = new Ext.FormPanel({
	autoHeight : true,
	region : 'north',
	frame : true,
	iconCls : 'search',	
	title : '���гɹ���˲�ѯ',
	frame : true,
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">����</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},TypeCombox,{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">���</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},YearCombo,{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">�������</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},RewardTypeCombo,{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">��������</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},RewardDictCombo,
				{
				xtype:'displayfield',
				value:'',
				width:30
				},{
					xtype : 'button',
					width:30,
					text: '��ѯ',
					iconCls: 'search',
					handler: function(){SearchFun()}
				}]
	},{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">��Ŀ����</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},titleText,{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">���״̬</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},AuditStateField]
	}]	
});

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: '���гɹ���˲�ѯ�б�',
			iconCls: 'list',
			url : itemGridUrl,
			listeners:{
	        'cellclick' : function(grid, rowIndex, columnIndex, e) {
	                   var record = grid.getStore().getAt(rowIndex);
	                   if((record.get('CheckResult') == 'ͨ��')&&(record.get('IsReward')=='�ѽ���')&&((columnIndex==13)||(columnIndex==14)))
					   {
					   //Ext.Msg.show({title:'ע��',msg:'���������,�����޸�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					   }
					   else{
					   return true;
					   }
	        }},	
			fields : [
			      //new Ext.grid.CheckboxSelectionModel({editable:false}),
			    {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						header : '������ID',
						dataIndex : 'rewardinforowid',
						hidden : true
					},{
						id : 'Type',
						header : '����',
						width : 40,
						editable:false,
						dataIndex : 'Type'

					},{
						id : 'Year',
						header : '���',
						width : 60,
						editable:false,
						dataIndex : 'Year'

					},{
						id : 'RewardTypeName',
						header : '�������',
						editable:false,
						width : 100,
						dataIndex : 'RewardTypeName'
					},{
						id : 'RewardName',
						header : '����ȼ�',
						editable:false,
						width : 80,
						dataIndex : 'RewardName'

					},  {
						id : 'RewardLevel',
						header : '�����ȴ�',
						width :80,
						editable:false,
						hidden:false,
						dataIndex : 'RewardLevel'

					},{
						id : 'Name',
						header : '����Ŀ����',
						width : 180,
						editable:false,
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						},
						// renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           // return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						// },
						dataIndex : 'Name'

					},{
						id : 'Participants',
						header : '������λ��',
						width : 80,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['rowid']
						if (sf != "") {
							return '<span style="color:blue;cursor:hand"><u>���������Ա</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand"></span>';
						}},
						dataIndex : 'Participants'
					},{
						id : 'RewardUnit',
						header : '��׼��λ',
						width :180,
						editable:false,
						hidden:false,
						dataIndex : 'RewardUnit',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id : 'RewardDate',
						header : '������',
						width :80,
						editable:false,
						hidden:false,
						dataIndex : 'RewardDate'
					},{
						id : 'CompleteUnit',
						header : '��Ժ��λλ��',
						width :80,
						editable:false,
						hidden:false,
						dataIndex : 'CompleteUnit'

					},{
						id : 'IsReward',
						header : '�Ƿ���',
						width :80,
						editable:false,
						hidden:true,
						dataIndex : 'IsReward'
					},{
						id : 'RewardAmount',
						header : '�������(Ԫ)',
						width :100,
						align:'right',
						editable:true,
						dataIndex : 'RewardAmount',
						renderer: function(val) 
						{
       						var val = Ext.util.Format.number(val,'0.00');
							return format(val);
    					}

					},{
						id : 'eRewardDate',
						header : '����ʱ��',
						editable:true,
						width : 80,
						dataIndex : 'eRewardDate',
						type:RewardDateField,
						renderer : function(v, p, r, i) {			
						if (v instanceof Date) {
							return new Date(v).format("Y-m-d");
						} else {return v;}
			          }
			         },{
						id : 'SubUser',
						header : '������',
						width : 60,
						editable:false,
						dataIndex : 'SubUser'
					},{
						id : 'SubDeptName',
						header : '�����˿���',
						width : 120,
						editable:false,
						dataIndex : 'SubDeptName',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id : 'SubDate',
						header : '����ʱ��',
						width : 80,
						editable:false,
						dataIndex : 'SubDate'

					},{
						id : 'DataStatus',
						header : '����״̬',
						width : 80,
						editable:false,
						hidden: true,
						dataIndex : 'DataStatus'
					},{
						id : 'Chercker',
						header : '�����',
						width : 60,
						editable:false,
						dataIndex : 'Chercker'
					},{
						id : 'CheckDeptName',
						header : '����˿���',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'CheckDeptName'
					},{
						id : 'CheckDate',
						header : '���ʱ��',
						width : 100,
						editable:false,
						dataIndex : 'CheckDate'

					},{
						id : 'CheckResult',
						header : '���״̬',
						width : 80,
						editable:false,
						hidden:true,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['CheckResult']
						if (sf == "�ȴ�����") {return '<span style="color:blue;cursor:hand">'+value+'</span>';} 
						if (sf == "ͨ��") {return '<span style="color:red;cursor:hand">'+value+'</span>';} 
						if (sf == "��ͨ��"){return '<span style="color:gray;cursor:hand">'+value+'</span>';}
						},
						dataIndex : 'CheckResult'
					},{
						id : 'ChkProcDesc',
						header : '��˽��',
						width : 100,
						editable:false,
						hidden:false,
						dataIndex : 'ChkProcDesc'
					},{
						id : 'Desc',
						header : '������',
						editable:false,
						width : 100,			
						hidden:false,
						dataIndex : 'Desc'
					},{
						id : 'ParticipantsIDs',
						header : '�μ���ԱID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'ParticipantsIDs'
					},{
							id:'download',
							header: '����֤��',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
					    } 
					},{
							id:'download1',
							header: '��ʾ',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'download1',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
					    } 
					},{
							id:'download2',
							header: '��֤��',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'download2',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
					    } 
					}
					
					
					]				
		});

var AuditButton  = new Ext.Toolbar.Button({
		text: 'ͨ��',  
        id:'auditButton', 
        iconCls:'pencil',
        handler:function(){
			
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		var checker = session['LOGON.USERCODE'];
		
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
        for(var j= 0; j < len; j++){
		 if(rowObj[j].get("CheckResult")!="�ȴ�����")
		 {
			      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:itemGridUrl+'?action=audit&&rowid='+rowObj[i].get("rowid")+'&checker='+checker,
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								var inputdata="|||||"+userdr;
								itemGrid.load({params:{start:0,limit:25,data:inputdata}});
							}else{
								Ext.Msg.show({title:'����',msg:'���ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ��˸�����¼��?',handler);
    }
});


  var NoAuditButton = new Ext.Toolbar.Button({
					text : '��ͨ��',
					iconCls : 'pencil',
					handler : function() {
						var rowObj=itemGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						for(var j= 0; j < len; j++){
							 if(rowObj[j].get("CheckResult")!="�ȴ�����")
							 {
								      Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								       return;
							 }else{noauditfun();}
						}
						
						
				   }
  });
  var RewardAuditButton = new Ext.Toolbar.Button({
    id:'RewardAudit',
	text: '�������',  
    iconCls:'pencil',
    handler:function(){
	//���岢��ʼ���ж���
	var usercode = session['LOGON.USERCODE'];
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	for(var j= 0; j< len; j++){
	     //alert(rowObj[j].get("RewardAmount"))
	    /* var state=rowObj[j].get("ChkResult");
		//alert(state);
	    if(state!="ͨ��"){
	      Ext.getCmp('RewardAudit').disable();//����Ϊ������
	       return;
	   } */
	   /**
	   if(rowObj[j].get("IsReward")!='δ����')
	 {
		      Ext.Msg.show({title:'ע��',msg:'�������ѽ���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	 }
	 **/
		 if(rowObj[j].get("RewardAmount")==""){
			Ext.Msg.show({title:'ע��',msg:'��������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
		if(rowObj[j].get("eRewardDate")==""){
			Ext.Msg.show({title:'ע��',msg:'����ʱ�䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
	}
	function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					
					
					var rewardamount = rowObj[i].get("RewardAmount");  
					  var erewarddate=rowObj[i].get("eRewardDate"); 
					  if(rowObj[i].isModified("eRewardDate")){
						 
						     erewarddate=erewarddate.format('Y-m-d');
						  
						  } 
					
					    Ext.Ajax.request({
						url:itemGridUrl+'?action=rewardaudit&rowid='+rowObj[i].get("rowid")+'&rewardamount='+rewardamount+'&rewarddate='+erewarddate,
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},   
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'������˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});                              
								var inputdata="|||||"+userdr;
								itemGrid.load({params:{start:0, limit:25,data:inputdata}});								
							}else{
							    var ErrMSG="";
							    ErrMSG=jsonData.info;
							    Ext.Msg.show({title:'����',msg:ErrMSG,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						    }
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ�����ѡ��¼��?��˺����޸�',handler);
    }
});

  itemGrid.addButton('-');
  itemGrid.addButton(AuditButton);
  itemGrid.addButton('-');
  itemGrid.addButton(NoAuditButton);
  itemGrid.addButton('-');
  itemGrid.addButton(RewardAuditButton);

  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//������Ӱ�ť
  itemGrid.btnSaveHide(); 	//���ر��水ť
  
  var data="|||||"+userdr+'|';
  itemGrid.load({params:{start:0, limit:25, data:data}});
  /**
  itemGrid.on('cellclick',function(g,rowIndex,columnIndex,e){
  	var rowObj=itemGrid.getSelectionModel().getSelections();
		if(rowObj[0].get("Title")=="Reward7"){
			alert("abcdefg");
			paperPublishDetail(itemGrid);	
		}    
	 if(rowObj[0].get("Title")=="Reward3")
	 {
	 	alert("12345");
	 	paperPublishDetail2(itemGrid);	
	 	}
	});
**/
// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

		var records = itemGrid.getSelectionModel().getSelections();
	    // if (columnIndex == 6) {
		  // var title   = records[0].get("IdentifyName");
		  // titleFun(title);
		// }
		if(columnIndex == 9){
		  var title= records[0].get("Name");
		  var authorinfo = records[0].get("ParticipantsIDs");
		  //alert(ParticipantsIDs);
		  AuthorInfoList(title,authorinfo);
		}
		var records = itemGrid.getSelectionModel().getSelections();
	    var state = records[0].get("CheckResult");
	    //alert(state);
	    if(state!="ͨ��")
	    {
	      Ext.getCmp('RewardAudit').disable();//����Ϊ������
	      return;
	    }
	    else{
	      Ext.getCmp('RewardAudit').enable();//����Ϊ����
	      return;
	    }
	
});
downloadMainFun(itemGrid,'rowid','SRMReward001',27);
downloadMainFun(itemGrid,'rowid','SRMReward002',28);
downloadMainFun(itemGrid,'rowid','SRMReward003',29);