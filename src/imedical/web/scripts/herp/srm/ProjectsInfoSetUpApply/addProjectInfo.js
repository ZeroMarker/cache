var userdr = session['LOGON.USERCODE'];

var projUrl='herp.srm.srmprojectsinfoexe.csp';

var prawValue = "";
var urawValue = "";
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
/////////////////��ӹ���/////////////////
addFun = function() {
	
///////////////////����/////////////////////////////  
var aTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var aTypeCombox = new Ext.form.ComboBox({
	                   id : 'aTypeCombox',
		           fieldLabel : '����',
	                   width : 170,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : aTypeDs,
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
//////////////////////���//////////////////////////////////
var aYearDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


aYearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('aYearField').getRawValue()),
	method:'POST'});
});

var aYearField = new Ext.form.ComboBox({
	id: 'aYearField',
	fieldLabel: '���',
	width:170,
	listWidth : 250,
	allowBlank: false,
	store:aYearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'YearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});		
///////////////////////��������//////////////////////////////
var ProjectsNameFields = new Ext.form.TextField({
	id:'ProjectsNameFields',
	width:180,
	fieldLabel: '��������',
	allowBlank: false,
	emptyText:'��������...',
	anchor: '95%'
});
	

/////////////////����///////////////////////
var DeptsDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


DeptsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=deptList&str='+encodeURIComponent(Ext.getCmp('DeptFields').getRawValue()),
	method:'POST'});
});

var DeptFields = new Ext.form.ComboBox({
	id: 'DeptFields',
	fieldLabel: '����',
	width:172,
	listWidth : 250,
	allowBlank: false,
	store:DeptsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'DeptFields',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////////////////������////////////////////////////
var HeadDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

HeadDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList&str='+encodeURIComponent(Ext.getCmp('HeadCombo').getRawValue()),
						method : 'POST'
					});
		});

var HeadCombo = new Ext.form.ComboBox({
            id: 'HeadCombo',
			fieldLabel: '������',
			store : HeadDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			allowBlank: false,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ������...',
			width : 172,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});


//////////////////////������Դ//////////////////////////////////
var addSubSourceDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});
		
addSubSourceDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=sourceList&str='+encodeURIComponent(Ext.getCmp('addSubSourceCombo').getRawValue()),
                        method:'POST'
					});
		});

var addSubSourceCombo = new Ext.form.ComboBox({
			id : 'addSubSourceCombo',
			fieldLabel : '��������',
			store : addSubSourceDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 172,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			listeners : {      //�Զ���д��һ��
				    	 select:{
                       fn:function(combo,record,index) { 
                     	 Ext.Ajax.request({			        
                     url: projUrl+'?action=GetMatchPercent&subsource='+addSubSourceCombo.getValue(),		
					           success: function(result, request){
					         	 var jsonData = Ext.util.JSON.decode( result.responseText );				         
							         var data = jsonData;
                       MatchPercentField.setValue(data);          
				         	   }
				      	});    
                  }
                }
              }
		});
		
//////////////////////�����//////////////////////////////////
var addDepartmentDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
addDepartmentDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=GetRelyUnit&str='+encodeURIComponent(Ext.getCmp('addDepartmentCombo').getRawValue()),
                        method:'POST'
					});
		});

var addDepartmentCombo = new Ext.form.ComboBox({
			id : 'addDepartmentCombo',
			fieldLabel : '�����',
			store : addDepartmentDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 172,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});		
/////////////////////ƥ�����//////////////////////////
var MatchPercentField = new Ext.form.TextField({
	id:'MatchPercentField',
    fieldLabel: 'ƥ�����',
	width:180,
    allowBlank: true,
    emptyText:'ƥ�����...',
    anchor: '95%'
	});
		
/////////////////////������//////////////////////////
var ProjectNumField = new Ext.form.TextField({
	id:'PatentNumField',
    fieldLabel: '������',
	width:180,
    allowBlank: true,
    emptyText:'������...',
    anchor: '95%'
	});

///////////////////////���뾭��///////////////////////////
var AppFundsField = new Ext.form.TextField({
	id:'AppFundsField',
	fieldLabel: '���뾭��',
	width:180,
	allowBlank: false,
	emptyText:'���뾭�ѣ���Ԫ��...',
	anchor: '95%'
});

/////////////////������ʼʱ��///////////////////////
var StartDateFields = new Ext.form.DateField({
			fieldLabel: '���⿪ʼ����',
			width:172,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});



////////////////////////�����ֹ����///////////////////////
var EndDateFields = new Ext.form.DateField({
			fieldLabel: '�����ֹ����',
			width:172,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
		
		
/////////////////����ʱ��///////////////////////
var ConDateFields = new Ext.form.DateField({
			fieldLabel: '��������',
			width:172,
			allowBlank:true,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});


		
//////////////////////��λ//////////////////////////////////
var RelyUnitDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
RelyUnitDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url :projUrl+'?action=GetRelyUnit&str='+encodeURIComponent(RelyUnitCombo.getRawValue()),
                        method:'POST'
					});
		});

var RelyUnitCombo = new Ext.form.ComboBox({
			id:'RelyUnitCombo',
			name:'RelyUnitCombo',
			fieldLabel : '��λ',
			store : RelyUnitDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			allowBlank:false,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ��λ',
			width : 172,
			listWidth : 240,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

///////////////////��λ����/////////////////////////////  
var aUnitTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '���е�λ'],['2', '������λ']]
	});		
		
var aUnitTypeCombox = new Ext.form.ComboBox({
	                   id : 'aUnitTypeCombox',
					   name : 'aUnitTypeCombox',
		           fieldLabel : '��λ����',
	                   width : 170,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : aUnitTypeDs,
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

var RelyUnitsGrid = new Ext.grid.GridPanel({
		id:'RelyUnitsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.MemoryProxy(),
		reader: new Ext.data.ArrayReader({}, [  
			 {name: 'unittypeid'},  
			 {name: 'rowid'},  
			 {name: 'unittype'},
			 {name: 'name'}
         ])  
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
		    {id: 'unittypeid', header: '��λ����Id', width: 129, sortable: true, dataIndex: 'unittypeid',hidden:true},
            {id: 'rowid', header: '��λID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '��λ����', dataIndex: 'unittype',align:'center',width: 125},
			{header: '��λ����', dataIndex: 'name',align:'center',width: 125}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 260,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////��Ӷ�����е�λ��ť////////////////
var addRelyUnits  = new Ext.Button({
		text: '���',
		handler: function(){
			var UnitTypeId;
			var RelyUnitId;
			var id = RelyUnitCombo.getValue();
			var unittypeid = aUnitTypeCombox.getValue();
			var RelyUnitName = RelyUnitCombo.getRawValue();
			var UnitTypeName = aUnitTypeCombox.getRawValue();
			var utotal = RelyUnitsGrid.getStore().getCount();
			
			if(utotal>0){	
				for(var i=0;i<utotal;i++){
					var erow = RelyUnitsGrid.getStore().getAt(i).get('rowid');
					var unittyperow=RelyUnitsGrid.getStore().getAt(i).get('unittypeid');
					if(unittypeid!=""){
						if(id!=""){
							if((id==erow)&&(unittyperow==unittypeid)){
								Ext.Msg.show({title:'����',msg:'��������ظ��ĵ�λ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								return;
							}else{
								RelyUnitId=id;
								UnitTypeId=unittypeid;
							}
					   }else{
							Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵĵ�λ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
					   }
					}else{
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵĵ�λ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(unittypeid==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵĵ�λ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					if(id==""){
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵĵ�λ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}else{
						RelyUnitId=id;
						UnitTypeId=unittypeid;
				}	
				}
			}
			var data = new Ext.data.Record({'unittypeid':UnitTypeId,'rowid':RelyUnitId,'unittype':UnitTypeName,'name':RelyUnitName});
			RelyUnitsGrid.stopEditing(); 
			RelyUnitsGrid.getStore().insert(utotal,data);
			if(utotal>0){
				urawValue = RelyUnitsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<utotal;i++){
				  var urow = RelyUnitsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  urawValue = urawValue+","+urow;
				}
			}
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delRelyUnits= new Ext.Button({
		text:'ɾ��',
		handler: function() {  
			var rows = RelyUnitsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = RelyUnitsGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				RelyUnitsGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}

			var utotal = RelyUnitsGrid.getStore().getCount();
			//alert(total);
			if(utotal>0){
				urawValue = RelyUnitsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<utotal;i++){
				  var urow = RelyUnitsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  urawValue = urawValue+","+urow;
				}
			}
			
		}
	});


/////////////////////��ע//////////////////////////
var RemarkField = new Ext.form.TextField({
	id:'RemarkField',
    fieldLabel: '��ע',
	width:180,
    allowBlank: true,
    emptyText:'��ע...',
    anchor: '95%'
	});

//////////////////�μ���Ա///////////////////////
var ParticipantssDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


ParticipantssDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=applyerList&str='+encodeURIComponent(Ext.getCmp('Participantsss').getRawValue()),
	method:'POST'});
});

var ParticipantsFields = new Ext.form.ComboBox({
	id: 'Participantsss',
	fieldLabel: '��ĿԺ�ڲμ���Ա',
	width:172,
	listWidth : 250,
	allowBlank: true,
	store:ParticipantssDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ����ĿԺ�ڲμ���Ա...',
	name: 'Participantsss',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
	/* listeners:{"select":function(combo,record,index){ 
		if(ParticipantsFields.getValue()!="")		
		{
			OutPersonField.disable();
		}
		else{
			OutPersonField.enable();
		}
	}}   */
});
////////////////////��ĿԺ�������Ա//////////////////////////
var OutPersonField = new Ext.form.TextField({
	id:'OutPersonField',
    fieldLabel: '��ĿԺ�������Ա',
	width:180,
    allowBlank: true,
    emptyText:'��ĿԺ�������Ա...',
    anchor: '95%'
	});
/* if (ParticipantsFields.getValue()!=""){
	OutPersonField.disable();
}
if (OutPersonField.getValue()!=""){
	alert(OutPersonField.getValue());
	ParticipantsFields.disable();
} */

///////////////////����λ��/////////////////////////////  
var AuthorRangeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��һ'],['2', '�ڶ�'], ['3', '����'], ['4', '����'], ['5', '����'],['6', '����'],['7', '����'],['8', '�ڰ�']]
	});		
		
var AuthorRangeCombox = new Ext.form.ComboBox({
	                   id : 'AuthorRangeCombox',
		           fieldLabel : '������λ��',
	               width : 172,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : AuthorRangeDs,
		          // anchor : '95%',			
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
///////////////////��Ŀ������Ա��λ/////////////////////////////  
/* var IsTheHosDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��Ժְ��'],['0', '��Ժ��Ա'],['2','��ʿ�о���'],['3','˶ʿ�о���']]
	});		
		
var IsTheHosCombox = new Ext.form.ComboBox({
	                   id : 'IsTheHosCombox',
		           fieldLabel : '�������ʱ���',
	               width : 172,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : IsTheHosDs,
		          // anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   listeners:{
                           "select":function(combo,record,index){
						           if((combo.value=='2')||(combo.value=='3'))
								   {
                                   AuthorRangeCombox.setValue('');
								   AuthorRangeCombox.disable();  //��Ϊ�ң����ɱ༭
                                   //AuthorRangeCombox.disabled=true;   //����Ϊ�ң����ɱ༭	
                                   }				
                                   else{
								   AuthorRangeCombox.enable();  	
								   }								   
			}
	}	
 });	 */
var IsTheHosDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
IsTheHosDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=GetRelyUnit&str='+encodeURIComponent(Ext.getCmp('IsTheHosCombox').getRawValue()),
                        method:'POST'
					});
		});

var IsTheHosCombox = new Ext.form.ComboBox({
			id : 'IsTheHosCombox',
			name :'IsTheHosCombox',
			fieldLabel : '������Ա��λ',
			store : IsTheHosDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 172,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});		
		
		
var ParticipantsGrid = new Ext.grid.GridPanel({
		id:'ParticipantsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.MemoryProxy(),
		reader: new Ext.data.ArrayReader({}, [  
			 {name: 'rowid'},  
			 {name: 'name'},
			 {name: 'rangerowid'},
			 {name: 'range'},  
			 {name: 'isthehosrowid'},
			 {name: 'isthehos'}
         ])  
    }),
 colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '�μ���ԱID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '�μ���Ա����', dataIndex: 'name',align:'center',width: 100},
            {id: 'rangerowid', header: '��������ID', width: 129, sortable: true, dataIndex: 'rangerowid',hidden:true},
            {header: '��Աλ��', dataIndex: 'range',align:'center',width: 80},
            {id: 'isthehosrowid', header: '������Ա��λID', width: 129, sortable: true, dataIndex: 'isthehosrowid',hidden:true},
            {header: '������Ա��λ', dataIndex: 'isthehos',align:'center',width: 80}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 260,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////��Ӷ���μ���Ա��ť////////////////
var addParticipants  = new Ext.Button({
		text: '���',
		handler: function(){
			var ParticipantsId;
			var RangeId;
			var IsTheHosId;
			var ParticipantsName;
			var id = Ext.getCmp('Participantsss').getValue();
			if (id==""){
				id="";
				participantname = Ext.getCmp('OutPersonField').getRawValue();
			}else
			{
				participantname = Ext.getCmp('Participantsss').getRawValue();
			}
			var rangeid = Ext.getCmp('AuthorRangeCombox').getValue();
			var isthehosid = Ext.getCmp('IsTheHosCombox').getValue();
			var outperson = OutPersonField.getValue();
			//alert(id);
			//var ParticipantsName = Ext.getCmp('Participantsss').getRawValue();
			var AuthorRange = Ext.getCmp('AuthorRangeCombox').getRawValue();
			var IsTheHos = Ext.getCmp('IsTheHosCombox').getRawValue();
			var ptotal = ParticipantsGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = ParticipantsGrid.getStore().getAt(i).get('rowid');
					var tmpname = ParticipantsGrid.getStore().getAt(i).get('name');
					var tmprange = ParticipantsGrid.getStore().getAt(i).get('range');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
						   if(isthehosid=="")
						   {
						   Ext.Msg.show({title:'����',msg:'��ѡ����Ա��λ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						   }
						   else{
						       if((tmprange==AuthorRange)&&(tmprange!="")&&(AuthorRange!=""))
							   {
									Ext.Msg.show({title:'����',msg:'��ͬ�Ĳ�����Ա��ѡ������ͬ��λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									return;
							   }
							   else 
							   {
									ParticipantsId=id;
									ParticipantsName=participantname;
									RangeId=rangeid;
									IsTheHosId=isthehosid;
									//alert(ParticipantsId);
									ParticipantsFields.setValue('');
									ParticipantsFields.setRawValue('');
								}
						}
					}
					}else{
						if(OutPersonField.getValue()==""){
						Ext.Msg.show({title:'��ʾ',msg:'����д��Ŀ��Ժ�����Ա!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;}
						else 
						{
							if(participantname==tmpname){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
						   if(isthehosid=="")
						   {
						   Ext.Msg.show({title:'����',msg:'��ѡ����Ա��λ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				    return;
						   }
						   else{
						   {
						   if((tmprange==AuthorRange)&&(tmprange!="")&&(AuthorRange!=""))
							{
								Ext.Msg.show({title:'����',msg:'��ͬ�Ĳ�����Ա��ѡ������ͬ��λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							ParticipantsId=id;
							ParticipantsName=participantname;
							RangeId=rangeid;
						    IsTheHosId=isthehosid;
							ParticipantsFields.setValue('');
							ParticipantsFields.setRawValue('');
						   }
						}
					}
						}
					}	
				}
			}else{
				if((id=="")&&(outperson=="")){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ժ�ڲ�����Ա����дԺ�������Ա!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				if(isthehosid=="")
					{
					Ext.Msg.show({title:'����',msg:'��ѡ�������Ա��λ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				    return;
					}
				if(rangeid=="")
					{
					Ext.Msg.show({title:'����',msg:'��ѡ�������Աλ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
					}
				else{
					ParticipantsId=id;
					ParticipantsName=participantname;
					RangeId=rangeid;
				    IsTheHosId=isthehosid;	
					ParticipantsFields.setValue('');
					ParticipantsFields.setRawValue('');
				}	
			}
			var data = new Ext.data.Record({'rowid':ParticipantsId,'name':ParticipantsName,'rangerowid':RangeId,'isthehosrowid':IsTheHosId,'range':AuthorRange,'isthehos':IsTheHos});
			ParticipantsGrid.stopEditing(); 
			ParticipantsGrid.getStore().insert(ptotal,data);
			if(ptotal>0){
			   // prawValue=ParticipantsGrid.getStore().getAt(i).get('rowid');
				var authorid = ParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorrangeid = ParticipantsGrid.getStore().getAt(0).get('rangerowid');
				var authoristhehosid = ParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
				prawValue = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				for(var i=1;i<ptotal;i++){
				  //var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  var authorid = ParticipantsGrid.getStore().getAt(i).get('rowid');
				  var authorrangeid = ParticipantsGrid.getStore().getAt(i).get('rangerowid');
				  var authoristhehosid = ParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				  var prow = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				  prawValue = prawValue+","+prow;
				}
			}
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delParticipants = new Ext.Button({
		text:'ɾ��',
		handler: function() {  
			var rows = ParticipantsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = ParticipantsGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				ParticipantsGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}

			var ptotal = ParticipantsGrid.getStore().getCount();
			//alert(total);
			if(ptotal>0){
				prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  prawValue = prawValue+","+prow;
				}
			}
			
		}
	});
 //FundGov, FundOwn, FundMatched, IsGovBuy, AlertPercent,PrjCN, PrjDestination, PrjRescContent, PrjCheck
 // ////////////�ϼ�����////////
var FundGovField = new Ext.form.TextField({
	id:'FundGovField',
    fieldLabel: '�ϼ�����',
	width:180,
    allowBlank: true,
    emptyText:'�ϼ������Ԫ��...',
    anchor: '95%',
	selectOnFocus : true
});
////////////////////ҽԺƥ��//////////////////////
var FundOwnField = new Ext.form.TextField({
	id:'FundOwnField',
    fieldLabel: 'ҽԺƥ��',
	width:180,
    allowBlank: true,
    emptyText:'ҽԺƥ�䣨��Ԫ��...',
    anchor: '95%',
	selectOnFocus : true
});
///////////////////���´�//////////////////////
var FundMatchedField = new Ext.form.TextField({
	id:'FundMatchedField',
    fieldLabel: '��ƥ��',
	width:180,
    allowBlank: true,
    emptyText:'��ƥ�䣨��Ԫ��...',
    anchor: '95%',
	selectOnFocus : true
});
//////////////////////�Ƿ������ɹ�/////////////////////
var IsGovBuyStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '��'], ['1', '��']]
		});
var IsGovBuyField = new Ext.form.ComboBox({
			fieldLabel : '�Ƿ������ɹ�',
			width : 172,
			listWidth : 172,
			selectOnFocus : true,
			//allowBlank : false,
			store : IsGovBuyStore,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			disabled:true,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//////////////////////������/////////////////////////
var AlertPercentField = new Ext.form.TextField({
	id:'AlertPercentField',
    fieldLabel: '������',
	width:180,
    allowBlank: true,
    emptyText:'90...',
    anchor: '95%',
	selectOnFocus : true
});

///////////////////��Ժ��λλ��/////////////////////////////  
var CompleteUnitDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��һ��ɵ�λ'],['2', '�ڶ���ɵ�λ'], ['3', '������ɵ�λ'],
		        ['4', '������ɵ�λ'],['5', '������ɵ�λ'],['6', '������ɵ�λ'],
		        ['7', '������ɵ�λ'],['8', '�ڰ���ɵ�λ']]
	});		
		
var CompleteUnitCombox = new Ext.form.ComboBox({
	               id : 'CompleteUnit',
		           fieldLabel : '��Ժ��λλ��',
	               width : 172,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : CompleteUnitDs,
		          // anchor : '95%',			
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
						  
//////////////////////�Ƿ���Ҫ��������/////////////////////
var IsEthicalApprovalStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '��'], ['1', '��']]
		});
var IsEthicalApprovalField = new Ext.form.ComboBox({
			fieldLabel : '�Ƿ���Ҫ��������',
			width : 172,
			listWidth : 172,
			selectOnFocus : true,
			allowBlank : false,
			store : IsEthicalApprovalStore,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
var colItems =	[
	    	{
			layout: 'column',
			border: false,
			defaults: {
				columnWidth: '.5',
				//bodyStyle:'padding:5px 5px 0',
				border: false
			},            
			items: [
				{
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						/* {
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						}, */
					   aTypeCombox,
					   aYearField,
					   ProjectsNameFields,                          
					   DeptFields,
					   HeadCombo,
					   ParticipantsGrid,
					   ParticipantsFields,
					   OutPersonField,
					   IsTheHosCombox,
					   AuthorRangeCombox,  
					   {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
							xtype : 'displayfield',
							columnWidth : .05
							},addParticipants,{
							xtype : 'displayfield',
							columnWidth : .07
							},delParticipants]
						},
						addSubSourceCombo,
						CompleteUnitCombox,
						addDepartmentCombo
						
					]	 
				}, {
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						/* {
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						}, */
						RelyUnitsGrid,
						aUnitTypeCombox,
					    RelyUnitCombo,
					    {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
							xtype : 'displayfield',
							
							columnWidth : .05
							},addRelyUnits,{
							xtype : 'displayfield',
							
							columnWidth : .07
							},delRelyUnits]
						},
						IsEthicalApprovalField,
						StartDateFields,
						EndDateFields,
						RemarkField,
						IsGovBuyField,
						AppFundsField,
						FundGovField,
						FundOwnField,
						FundMatchedField,
						AlertPercentField
						
					]
				 }]
		}
	]		
	// create form panel
  var addFormPanel = new Ext.form.FormPanel({
    labelWidth: 80,
	frame: true,
    items: colItems
	});
    
  // define window and show it in desktop
  var addWindow = new Ext.Window({
  	title: '�����Ŀ������Ϣ',
    width: 600,
    height:600,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: addFormPanel,
    buttons: [{
    	text: '����', 
      handler: function() {
      		// check form value
      var ProjectsName = ProjectsNameFields.getValue();
      var DeptDr = DeptFields.getValue();
			var HeadDr = HeadCombo.getValue();
			var ptotal = ParticipantsGrid.getStore().getCount();
			if(ptotal>0){
				//prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorid = ParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorname=""
				if(authorid!==""){
					authorname="";
				}
				else{ authorname = encodeURIComponent(ParticipantsGrid.getStore().getAt(0).get('name'));}
				var authorrangeid = ParticipantsGrid.getStore().getAt(0).get('rangerowid');
				var authoristhehosid = ParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
				prawValue = authorid+"-"+authorname+"-"+authorrangeid+"-"+authoristhehosid;
				for(var i=1;i<ptotal;i++){
				  //var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  var tmpauthorid = ParticipantsGrid.getStore().getAt(i).get('rowid');
				  var tmpauthorname = "";
				  if(tmpauthorid!=""){
					tmpauthorname="";
				  }else{
					tmpauthorname=encodeURIComponent(ParticipantsGrid.getStore().getAt(i).get('name'));}
				  var tmpauthorrangeid = ParticipantsGrid.getStore().getAt(i).get('rangerowid');
				  var tmpauthoristhehosid = ParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				  var tmpprow = tmpauthorid+"-"+tmpauthorname+"-"+tmpauthorrangeid+"-"+tmpauthoristhehosid;
				  prawValue = prawValue+","+tmpprow;
				};
			}
			var Participants = prawValue;
			//alert(Participants);
      	    var SubSource = addSubSourceCombo.getValue();
			var SubNo = ProjectNumField.getValue();
			var AppFunds = AppFundsField.getValue();
      		var StartDate = StartDateFields.getValue();
        	var EndDate = EndDateFields.getValue();
			var ConDate = ConDateFields.getValue();
			var utotal = RelyUnitsGrid.getStore().getCount();
			if(utotal>0){
				urawValue = RelyUnitsGrid.getStore().getAt(0).get('unittypeid')+"-"+RelyUnitsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<utotal;i++){
				  var unittype=RelyUnitsGrid.getStore().getAt(i).get('unittypeid');
				  var unitrowid = RelyUnitsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  var tmprawvalue=unittype+"-"+unitrowid;
				  urawValue = urawValue+","+tmprawvalue;
				};
			}
			var RelyUnit = urawValue;
			var SubUser = userdr;
			var Remark = RemarkField.getValue();
			
			var FundGov = FundGovField.getValue();
			var FundOwn = FundOwnField.getValue();
			var FundMatched = FundMatchedField.getValue();
			//var IsGovBuy = IsGovBuyField.getValue();
			var IsGovBuy = "";
			var AlertPercent = AlertPercentField.getValue();
			var MatchPercent = MatchPercentField.getValue();
			var CompleteUnit=CompleteUnitCombox.getValue();//�ڼ���ɵ�λ
			var IsEthicalApproval = IsEthicalApprovalField.getValue();
			var Type = aTypeCombox.getValue();
			var Year = aYearField.getValue();
			var Department = addDepartmentCombo.getValue();
			
			ProjectsName = ProjectsName.trim();
      		DeptDr = DeptDr.trim();
			HeadDr = HeadDr.trim();
			
			Participants = Participants.trim();////ȥ�����ҵĿո�
      		SubSource = SubSource.trim();
      		//SubNo = SubNo.trim();
			AppFunds = AppFunds.trim();
			RelyUnit = RelyUnit.trim();
      		Remark = Remark.trim();
      		Department = Department.trim();
      		
			if(Type=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(Year=="")
      		{
      			Ext.Msg.show({title:'����',msg:'���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(ProjectsName=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��Ŀ����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(DeptDr=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(HeadDr=="")
      		{
      			Ext.Msg.show({title:'����',msg:'������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		//alert(Participants);
			if(Participants=="")
      		{
      			Ext.Msg.show({title:'����',msg:'���������ԱΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(SubSource=="")
      		{
      			Ext.Msg.show({title:'����',msg:'������ԴΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(CompleteUnit=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�ڼ���ɵ�λΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(IsEthicalApproval=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�Ƿ���������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		      		
			if(RelyUnit=="")
      		{
      			Ext.Msg.show({title:'����',msg:'���е�λΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      	
      		if(StartDate=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��Ŀ��ʼʱ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(EndDate=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��Ŀ����ʱ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};

      		if(AppFunds=="")
      		{
      			Ext.Msg.show({title:'����',msg:'���뾭��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
//      		if(FundGov!="")
//      		{
//      			var Percent = FundOwn/FundGov*100;
//      			if (Percent<MatchPercent){
//      				Ext.Msg.show({title:'����',msg:'ҽԺ�Գ����ϼ��������Ӧ����'+MatchPercent+'%',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//      			  return;
//      				}	
//      		};

          

      	    if (addFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'herp.srm.srmprojectsinfoexe.csp?action=add&ProjectsName='+encodeURIComponent(ProjectsName)+'&Participants='+Participants+'&HeadDr='+HeadDr+'&EndDate='+EndDate+'&SubSource='+SubSource+'&SubNo='+''+'&AppFunds='+AppFunds+'&StartDate='+StartDate+'&SubUser='+SubUser+'&DeptDr='+DeptDr+'&ConDate='+ConDate+'&RelyUnit='+RelyUnit+'&Remark='+encodeURIComponent(Remark)+'&FundGov='+FundGov+'&FundOwn='+FundOwn+'&FundMatched='+FundMatched+'&IsGovBuy='+encodeURIComponent(IsGovBuy)+'&AlertPercent='+AlertPercent+'&IsEthicalApproval='+IsEthicalApproval+'&CompleteUnit='+CompleteUnit+'&Type='+Type+'&Year='+Year+'&Department='+Department,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								  srmprjitemGrid.load({params:{start:0, limit:25,userdr:userdr}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepProjects') message='�������Ŀ�Ѿ�����!';	
									//if(jsonData.info=='RepName') message='�����ר�������Ѿ�����!';							
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
						addWindow.close();
        	}
        	else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
		
    	{
				text: 'ȡ��',
        handler: function(){addWindow.close();}
      }]
    });

    addWindow.show();
};
