var projUrl = 'herp.srm.prjachievementapplyexe.csp';

var userdr = session['LOGON.USERCODE'];

//var username = session['LOGON.USERCODE'];

var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{ var userdr=""
	}
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{ var userdr=""
	}

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

//���
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=yearList&str='+encodeURIComponent(Ext.getCmp('YearCombo').getRawValue()), 
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
			emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
 //��������
var RewardTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
RewardTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=rewardTypeList&str='+encodeURIComponent(Ext.getCmp('RewardTypeCombo').getRawValue()), 
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
			emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
//��������
var RewardDictDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
RewardDictDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=rewardDictList&str='+encodeURIComponent(Ext.getCmp('RewardDictCombo').getRawValue()), 
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
			emptyText : '',
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

/////////////////// ��ѯ��ť 
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	width:30,
	iconCls: 'search',
	handler: function(){
	    var year = YearCombo.getValue();
	    var rewardtype= RewardTypeCombo.getValue();
	    var rewarddict  = RewardDictCombo.getValue();
	    var prjname = titleText.getValue();    
		var type = TypeCombox.getValue();
	    var data= year+'|'+rewardtype+'|'+rewarddict+'|'+prjname+'|'+userdr+'|'+type;
		itemGrid.load({
		    params:{
		    data:data,
		    sortField:'',
		    sortDir:'',
		    start:0,
		    limit:25   
		   }
	  })
  }
});


var queryPanel = new Ext.FormPanel({
	iconCls : 'search',	
	title : '���гɹ������ѯ',
	autoHeight : true,
	region : 'north',
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
				value : '<p style="text-align:right;">����Ŀ</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},titleText,{
				xtype:'displayfield',
				value:'',
				width:30
				},findButton]
	},{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">�����</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},RewardTypeCombo,
				{
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
				},RewardDictCombo]
	}]	
});

///////////////////��Ӱ�ť///////////////////////
var addButton = new Ext.Toolbar.Button({
		text: '����',
		iconCls: 'edit_add',
		handler: function(){
			addFun();}
});

/////////////////�޸İ�ť/////////////////////////
var editButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		iconCls: 'pencil',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var state = rowObj[0].get("DataStatus");	
				var participantids = rowObj[0].get("ParticipantsIDs")
				if((state == "δ�ύ")||(groupdesc=="���й���ϵͳ(��Ϣ�޸�)" ) ){editFun(participantids);}
				else {Ext.Msg.show({title:'����',msg:'�������ύ���������޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
			}
});

////////////////ɾ����ť//////////////////////////
var delButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		iconCls:'edit_remove',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len<1){
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫɾ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				for(var i = 0; i < len; i++){
				var state = rowObj[i].get("DataStatus");
				//alert(state);			
				if(state == "δ�ύ" ){delFun()}
				else {Ext.Msg.show({title:'����',msg:'�������ύ������ɾ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
});

///////////////�ύ��ť//////////////////////////
var submitButton = new Ext.Toolbar.Button({
		text:'�ύ',
		iconCls: 'pencil',
		handler:function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len<1){
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�ύ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				for(var i = 0; i < len; i++){
				var state = rowObj[i].get("DataStatus");
				//alert(state);			
				if(state == "δ�ύ" ){subFun()}
				else {Ext.Msg.show({title:'����',msg:'�������ύ�������ظ��ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}	
});


var itemGrid = new dhc.herp.Grid({
		    region : 'center',
			title: '���гɹ������ѯ�б�',
			iconCls: 'list',
		    //viewConfig : {forceFit : false},
		    autoscroll:true,
		    url: projUrl,
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
						header : '�����',
						editable:false,
						width : 100,
						dataIndex : 'RewardTypeName'
					},{
						id : 'RewardName',
						header : '��������',
						editable:false,
						width : 100,
						dataIndex : 'RewardName',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					}, {
						id : 'RewardLevel',
						header : '����ȴ�',
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
						header : '������Աλ��',
						width : 80,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['ParticipantsIDs']
						if (sf != "") {
							return '<span style="color:blue;cursor:hand"><u>��Ŀ������Ա</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand"></span>';
						}},
						dataIndex : 'Participants'
					},{
							id:'upload',
							header: '����֤��',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>�ϴ�</u></span>';
							}
					},{
							id:'upload2',
							header: '��ʾ',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>�ϴ�</u></span>';
							}
					},{
							id:'upload3',
							header: '��֤��',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>�ϴ�</u></span>';
							}
					},{
							id:'download',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
					    } 
					},{
						id : 'DataStatus',
						header : '����״̬',
						width : 60,
						editable:false,
						dataIndex : 'DataStatus'
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
						id : 'RewardAmount',
						header : '�������(Ԫ)',
						width :100,
						align:'right',
						editable:false,
						dataIndex : 'RewardAmount',
						renderer: function(val) 
						{
       						var val = Ext.util.Format.number(val,'0.00');
							return format(val);
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
						id : 'YearID',
						header : '���ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'YearID'
					},{
						id : 'RewardTypeID',
						header : '�����ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'RewardTypeID'
					},{
						id : 'RewardNameID',
						header : '��������ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'RewardNameID'
					},{
						id : 'RewardLevelID',
						header : '����ȴ�ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'RewardLevelID'
					},{
						id : 'RewardUnitID',
						header : '��׼��λID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'RewardUnitID'
					},{
						id : 'CompleteUnitID',
						header : '��Ժ��λλ��ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'CompleteUnitID'
					},{
						id : 'PrjName',
						header : '���л�������',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'PrjName'
					},{
						header : '�������п��п���(Ժ��)',
						dataIndex : 'OutPrjName',
						hidden : true
					},{
						id : 'PrjDR',
						header : '������ĿID',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'PrjDR'
					},{
						id : 'TypeID',
						header : '����ID',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'TypeID'
					}]
				});

  itemGrid.addButton('-');
  itemGrid.addButton(addButton);
  itemGrid.addButton('-');
  itemGrid.addButton(editButton);
  itemGrid.addButton('-');
  itemGrid.addButton(delButton);
  itemGrid.addButton('-');
  itemGrid.addButton(submitButton);



  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//������Ӱ�ť
  itemGrid.btnSaveHide(); 	//���ر��水ť

var data="||||"+userdr+"|";
itemGrid.load({	params:{start:0, limit:25,data:data}});

/**
itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var rowid= '';
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	rowid=selectedRow[0].data['rowid'];
        
	DetailGrid.load({params:{start:0, limit:12,rowid:rowid}});	
});

**/

// ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

		var records = itemGrid.getSelectionModel().getSelections();
	    // if (columnIndex == 7) {
		  // var title   = records[0].get("Name");
		  // titleFun(title);
		// }
		if(columnIndex == 9){
		  var title= records[0].get("Name");
		  var authorinfo = records[0].get("ParticipantsIDs");
		  //alert(ParticipantsIDs);
		  AuthorInfoList(title,authorinfo);
		}
		
		/**
		if (columnIndex == 22) {
		var records = itemGrid.getSelectionModel().getSelections();
		var state = records[0].get("DataStatus");
		if (state=="���ύ"){Ext.Msg.show({title:'����',msg:'�������ύ���������ϴ�������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}
		else{uploadMainFun(itemGrid,'rowid','SRMReward001',22);}
	}
	if (columnIndex == 23) {
		var records = itemGrid.getSelectionModel().getSelections();
		var state = records[0].get("DataStatus");
		if (state=="���ύ"){Ext.Msg.show({title:'����',msg:'�������ύ���������ϴ�������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}
		else{uploadMainFun(itemGrid,'rowid','SRMReward002',23);}
	}
	if (columnIndex == 24) {
		var records = itemGrid.getSelectionModel().getSelections();
		var state = records[0].get("DataStatus");
		if (state=="���ύ"){Ext.Msg.show({title:'����',msg:'�������ύ���������ϴ�������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}
		else{uploadMainFun(itemGrid,'rowid','SRMReward003',24);}
	}**/
	
});

 if (groupdesc=="���й���ϵͳ(��Ϣ�޸�)")
{
	 addButton.disable();//����Ϊ������
	  delButton.disable();//����Ϊ������
	  submitButton.disable();//����Ϊ������
}
if (groupdesc=="���й���ϵͳ(��Ϣ��ѯ)")
{
	 addButton.disable();//����Ϊ������
	 editButton.disable();//����Ϊ������
	  delButton.disable();//����Ϊ������
	  submitButton.disable();//����Ϊ������
}

uploadMainFun(itemGrid,'rowid','SRMReward001',10);
uploadMainFun(itemGrid,'rowid','SRMReward002',11);
uploadMainFun(itemGrid,'rowid','SRMReward003',12);
downloadMainFun(itemGrid,'rowid','SRMReward001,SRMReward002,SRMReward003',13);