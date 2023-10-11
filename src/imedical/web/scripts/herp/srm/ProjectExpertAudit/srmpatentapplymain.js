
var usercode = session['LOGON.USERCODE'];
var projUrl = 'herp.srm.srmprojectexpertauditexe.csp';
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



/////////////////��������///////////////////////
var StartDateField = new Ext.form.DateField({
			fieldLabel: '��ʼ����',
			width:120,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
var EndDateField = new Ext.form.DateField({
			fieldLabel: '��������',
			width:120,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});

//////////////////////���//////////////////////////////////
var yearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('yearField').getRawValue()),
	method:'POST'});
});

var yearField = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '���',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:yearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////������///////////////////
var PatenteeDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


PatenteeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetPatentee&str='+encodeURIComponent(Ext.getCmp('Patentees').getRawValue()),
	method:'POST'});
});

var PatenteeField = new Ext.form.ComboBox({
	id: 'Patentees',
	fieldLabel: '������',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:PatenteeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ��������...',
	name: 'Patentees',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////////////////��Ŀ����///////////////////
var PatentName = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PatentName',
                fieldLabel: '��Ŀ����',
                blankText: '��Ŀ����'
            });
///��Ŀ��Դ
var SubSourceDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});
		
SubSourceDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.srm.projectmidchecknewexe.csp'+'?action=sourceList&str='+encodeURIComponent(Ext.getCmp('SubSourceCombo').getRawValue()), 
                        method:'POST'
					});
		});

var SubSourceCombo = new Ext.form.ComboBox({
			id:'SubSourceCombo',
			fieldLabel : '��Ŀ��Դ',
			store : SubSourceDs,
			displayField : 'Name',
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

/////////////////��ѯ��ť��Ӧ����//////////////
function SearchFun()
{			
	    var startdate= StartDateField.getValue()
		if(startdate!=""){
			//startdate.format("Y-m-d");
		};
		var enddate= EndDateField.getValue()
		if(enddate!=""){
			//enddate.format("Y-m-d");
		};
	    
        var Patentee = PatenteeField.getValue();
        var year= yearField.getValue();
        var Name = PatentName.getValue();
        var SubSource = SubSourceCombo.getValue();
		
	itemGrid.load({params:{start:0,limit:25,startdate:startdate,enddate:enddate,YearDr:year,SubUser:Patentee,Title:Name,SubSource:SubSource,usercode:usercode}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel
(
	{
		autoHeight : true,
		region : 'north',
		frame : true,
		title : '��Ŀ����ר����˲�ѯ',
		iconCls : 'search',	

		defaults : 
		{
			bodyStyle : 'padding:5px'
		},
		items : 
		[ 
			{
				columnWidth : 1,
				xtype : 'panel',
				layout : 'column',
				items : 
				[
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">���</p>',
						width : 60			
					},	
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					yearField,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">������</p>',
						width : 60
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					PatenteeField,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">��������</p>',
						width : 60	
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					StartDateField,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:center;">��</p>',
						width : 20			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					EndDateField,
					{
						xtype : 'displayfield',
						value : '',
						width : 30
					},		
					{
						xtype : 'button',
						text : '��ѯ',
						handler : function(b){SearchFun();},
						iconCls : 'search',
						width : 30
					}
				]
			}, 
			{
				columnWidth : 1,
				xtype : 'panel',
				layout : "column",
				items : 
				[
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">��Ŀ����</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					PatentName,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">��Ŀ��Դ</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					SubSourceCombo
				]
			}
		]
	}
);



var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: '��Ŀ����ר����˲�ѯ�б�',
			iconCls: 'list',
			url : projUrl,
		
			fields : [
			 new Ext.grid.CheckboxSelectionModel({editable:false}),
			{			id:'rowid',
						header:'ID',
						dataIndex:'rowid',
						align:'center',
						hidden:true
					},{
						id:'year',
						header:'��� ',
						width:60,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'year'

					},{
						id:'Title',
						header:'��Ŀ����',
						width:180,
						editable:false,
						align:'left',
						
						dataIndex:'Title',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id:'SubSource',
						header:'��Ŀ��Դ',
						width:180,
						editable:false,
						align:'left',
						dataIndex:'SubSource',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					}, /* {
						id:'SubUser',
						header:'������',
						width:60,
						editable:false,
						align:'left',
						dataIndex:'SubUser'

					},{
						id:'DeptDr',
						header:'�����˿���',
						editable:false,
						width:120,
						align:'left',
						dataIndex:'DeptDr',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					}, */{
						id:'SubDate',
						header:'����ʱ��',
						editable:false,
						width:80,
						align:'left',
						dataIndex:'SubDate'
					},{
						id:'DeptDr',
						header:'����˿���',
						editable:false,
						width:100,
						hidden:true,
						align:'left',
						dataIndex:'DeptDr'
					},{
						id:'DataStatus',
						header:'�ύ״̬',
						width:100,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'DataStatus'
					},{
						id:'subStatus',
						header:'�Ƿ����ύ�����д�',
						width:120,
						editable:false,
						align:'left',
						//hidden:true,
						dataIndex:'DataStatus'
					},{
						id:'IsGraduate',
						header:'�Ƿ��������',
						width:80,
						editable:false,
						align:'left',
						hidden:false,
						dataIndex:'IsGraduate'
					},{
						id:'ExpertName',
						header:'רҵ�����',
						width:80,
						editable:false,
						align:'left',
						dataIndex:'ExpertName'
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
						id:'Index1score',
						header:'Ŀ����ȷ��',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index1score'
					},{
						id:'Index2score',
						header:'�������ճ̶�',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index2score'
					}
					,{
						id:'Index3score',
						header:'��ƿ�ѧ��',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index3score'
					}
					,{
						id:'Index4score',
						header:'���ⴴ����',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index4score'
					}
					,{
						id:'Index5score',
						header:'���ۿ�����',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index5score'
					}
					,{
						id:'Index6score',
						header:'����������',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index6score'
					}
					,{
						id:'Index7score',
						header:'��Ա������',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index7score'
					}
					,{
						id:'Index8score',
						header:'�ⲿ����������',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index8score'
					}
					,{
						id:'Index9score',
						header:'Ԥ�������',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index9score'
					}
					,{
						id:'Index10score',
						header:'�����߼�������',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index10score'
					}
					,{
						id:'Index11score',
						header:'�������Ԥ��',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index11score'
					}
					,{
						id:'Index12score',
						header:'ǰ�ڹ�������',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index12score'
					},{	id:'prjrowid',
						header:'prjrowid',
						dataIndex:'prjrowid',
						align:'center',
						hidden:true
					}
//					,{
//				header:'רҵ��˽��',
//					text:"�鿴",
//					width:130,
//					align:"center",
//					renderer:function(value,cellmeta){
//					var returnStr = "<INPUT type='button' value='�鿴'>";
//					return returnStr;
//					}
					
					]
		});

var ListButton = new Ext.Toolbar.Button({
	text: '����',  
    iconCls:'pencil',
    handler:function(){
	var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�����Ŀ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			for(var j= 0; j < len; j++){
			if(rowObj[j].get("DataStatus")!='δ�ύ')
	       {
		      Ext.Msg.show({title:'ע��',msg:'�������ύ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	       }else{
				
				var prjrowid = rowObj[0].get("rowid");	
				editFun(prjrowid);
				}
			}
			}
});
var AuditButton = new Ext.Toolbar.Button({
	text: '�ύ�����д�',  
    iconCls:'pencil',
    handler:function(){
	//���岢��ʼ���ж���
	var usercode = session['LOGON.USERCODE'];
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	for(var j= 0; j< len; j++){
	     //alert(rowObj[j].get("RewardAmount"))
	   if(rowObj[j].get("DataStatus")!='δ�ύ')
	 {
		      Ext.Msg.show({title:'ע��',msg:'�������ύ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	 }
	 
	}
	function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:projUrl+'?action=sub&rowid='+rowObj[i].get("rowid"),
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},   
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'�ύ�ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25,usercode:usercode}});								
							}else{
							Ext.Msg.show({title:'����',msg:'�ύʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						    }
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ�ύ��ѡ��¼��?�ύ�����޸�',handler);
    }
});



	itemGrid.addButton('-');
	itemGrid.addButton(ListButton);
	itemGrid.addButton('-');
	itemGrid.addButton(AuditButton);
	

  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//������Ӱ�ť
  itemGrid.btnSaveHide(); 	//���ر��水ť
  itemGrid.load({params:{start:0, limit:12, usercode:usercode}});
 
  
 // ����gird�ĵ�Ԫ���¼�
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
    
	/*
	var records = itemGrid.getSelectionModel().getSelections();
	
	var patenttype = records[0].get("PatentTypeList");
	//alert(patenttype);
	
	 
	if(patenttype!="����ר��")
	{
	 
	  Ext.getCmp("download").disable();//����Ϊ������
	  return;
	}
	else{
		
	  Ext.getCmp("download").enable();//����Ϊ����
	  return;
	}*/
}); 
 


//uploadMainFun(itemGrid,'rowid','P005',24);
downloadMainFun(itemGrid,'prjrowid','P011',12);