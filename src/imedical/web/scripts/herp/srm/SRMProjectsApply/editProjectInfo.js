/////////////////////�޸Ĺ���/////////////////////
/**
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
**/
var prawValue = "";
var urawValue = "";
editFun = function(ParticipantsIDs,RelyUnitsIDs) {
	//alert(ParticipantsIDs);
	
	
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	//alert(rowObj[0].get("remark"));
	if(len < 1)
	{
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid"); 
	}

///////////////////����/////////////////////////////  
var eTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var eTypeCombox = new Ext.form.ComboBox({
	                   id : 'eTypeCombox',
		           fieldLabel : '����',
	                   width : 170,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : eTypeDs,
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
var eYearDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eYearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmprojectsapplyexe.csp'+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('eYearField').getRawValue()),
	method:'POST'});
});

var eYearField = new Ext.form.ComboBox({
	id: 'eYearField',
	fieldLabel: '���',
	width:170,
	listWidth : 250,
	allowBlank: false,
	store:eYearDs,
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
	width:170,
	name:'Name',
	fieldLabel: '��������',
	allowBlank: false,
	emptyText:'��������...'
	//anchor: '95%'
});
	

/////////////////����///////////////////////
var DeptsDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


DeptsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmprojectsapplyexe.csp'+'?action=deptList&str='+encodeURIComponent(Ext.getCmp('DeptFields').getRawValue()),
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
	name:'Dept',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
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
						url : 'herp.srm.srmprojectsapplyexe.csp'+'?action=applyerList&str='+encodeURIComponent(Ext.getCmp('HeadCombo').getRawValue()),
						method : 'POST'
					});
		});

var HeadCombo = new Ext.form.ComboBox({
            id: 'HeadCombo',
			fieldLabel: '������',
			store : HeadDs,
			displayField : 'name',
			valueField : 'rowid',
			name:'Head',
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
						url :'herp.srm.srmprojectsapplyexe.csp'+'?action=sourceList&str='+encodeURIComponent(Ext.getCmp('addSubSourceCombo').getRawValue()),
                        method:'POST'
					});
		});

var addSubSourceCombo = new Ext.form.ComboBox({
			id:'addSubSourceCombo',
			fieldLabel : '������Դ',
			store : addSubSourceDs,
			displayField : 'Name',
			valueField : 'rowid',
			name:'PTName',
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
						url :'herp.srm.srmprojectsapplyexe.csp'+'?action=GetRelyUnit&str='+encodeURIComponent(Ext.getCmp('addDepartmentCombo').getRawValue()),
                        method:'POST'
					});
		});

var addDepartmentCombo = new Ext.form.ComboBox({
			id:'addDepartmentCombo',
			fieldLabel : '�����',
			store : addDepartmentDs,
			displayField : 'name',
			valueField : 'rowid',
			name:'Department',
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
	id:'ProjectNumField',
    fieldLabel: '������',
	width:180,
	name:'SubNo',
    allowBlank: true,
    emptyText:'������...',
    anchor: '95%'
	});

///////////////////////���뾭��///////////////////////////
var AppFundsField = new Ext.form.TextField({
	id:'AppFundsField',
	fieldLabel: '���뾭��',
	width:180,
	name:'AppFunds',
	allowBlank: false,
	emptyText:'���뾭�ѣ���Ԫ��...',
	anchor: '95%'
});

/////////////////������ʼʱ��///////////////////////
var StartDateFields = new Ext.form.DateField({
			id:'StartDateFields',
			fieldLabel: '���⿪ʼ����',
			width:172,
			name:'StartDate',
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			/**
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			**/
			selectOnFocus:'true'
		});



////////////////////////�����ֹ����///////////////////////
var EndDateFields = new Ext.form.DateField({
			id:'EndDateFields',
			fieldLabel: '�����ֹ����',
			width:172,
			name:'EndDate',
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			/**
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			**/
			selectOnFocus:'true'
		});
		
		
/////////////////����ʱ��///////////////////////
var ConDateFields = new Ext.form.DateField({
			id:'ConDateFields',
			fieldLabel: '��������',
			width:180,
			name:'ConDate',
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


		
//////////////////////���е�λ//////////////////////////////////
var RelyUnitDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
RelyUnitDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.srm.srmprojectsapplyexe.csp'+'?action=GetRelyUnit&str='+encodeURIComponent(Ext.getCmp('eRelyUnits').getRawValue()),
                        method:'POST'
					});
		});

var RelyUnitCombo = new Ext.form.ComboBox({
			id:'eRelyUnits',
			fieldLabel : '���е�λ',
			store : RelyUnitDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ�����е�λ',
			width : 172,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
var RelyUnitsGrid = new Ext.grid.GridPanel({
		id:'RelyUnitsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:'herp.srm.srmprojectsapplyexe.csp?action=RelyUnitsID&start='+0+'&limit='+25+'&RelyUnitsIDs='+RelyUnitsIDs,
		method:'POST'}),
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '���е�λID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '���е�λ����', dataIndex: 'name',align:'center',width: 258}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 260,
    height: 100
});

///////////////��Ӷ�����е�λ��ť////////////////
var eaddRelyUnits  = new Ext.Button({
		text: '���',
		handler: function(){
			var RelyUnitsId;
			var id = Ext.getCmp('eRelyUnits').getValue();
			var RelyUnitsName = Ext.getCmp('eRelyUnits').getRawValue();
			var utotal = RelyUnitsGrid.getStore().getCount();
			if(utotal>0){	
				for(var i=0;i<utotal;i++){
					var erow = RelyUnitsGrid.getStore().getAt(i).get('rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ�����е�λ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
							RelyUnitsId=id;
						}
					}else{
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵ����е�λ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵ����е�λ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					RelyUnitsId=id;
				}	
			}	
			var data = new Ext.data.Record({'rowid':RelyUnitsId,'name':RelyUnitsName});
			RelyUnitsGrid.stopEditing(); 
			RelyUnitsGrid.getStore().insert(utotal,data);
			if(utotal>0){
				urawValue = RelyUnitsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<utotal;i++){
				  var urow = RelyUnitsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  urawValue = urawValue+","+urow;
				}
			}
		}
	});	

	var edelRelyUnits = new Ext.Button({
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
			var utotal = RelyUnitsGrid.getStore().getCount();
			if(utotal>0){
				urawValue = RelyUnitsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<utotal;i++){
				  var urow = RelyUnitsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  urawValue = urawValue+","+urow;
				}
			}
		}}
	});
	
	

/////////////////////��ע//////////////////////////
var RemarkField = new Ext.form.TextField({
	id:'RemarkField',
    fieldLabel: '��ע',
	width:180,
	//height: 200,
	name:'Remark',
    allowBlank: true,
    emptyText:'��ע...',
    anchor: '95%'
	});


//////////////////�μ���Ա///////////////////////
var eParticipantssDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eParticipantssDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmprojectsapplyexe.csp?action=applyerList&str='+encodeURIComponent(Ext.getCmp('eParticipants').getRawValue()),
	method:'POST'});
});

var eParticipantsFields = new Ext.form.ComboBox({
	id: 'eParticipants',
	fieldLabel: '�μ���Ա',
	width:172,
	listWidth : 250,
	//allowBlank: false,
	store:eParticipantssDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'������ѡ��μ���Ա...',
	name: 'eParticipants',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
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
///////////////////�Ƿ�Ժ/////////////////////////////  
var IsTheHosDs = new Ext.data.SimpleStore({
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
						  });	




var ParticipantsGrid = new Ext.grid.GridPanel({
		id:'ParticipantsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:'herp.srm.srmhorizonalprjapplyexe.csp'+'?action=ParticipantsID&start='+0+'&limit='+25+'&ParticipantsIDs='+ParticipantsIDs,
		method:'POST'}),
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},
		['rowid','name','rangerowid','range','isthehosrowid','isthehos'])
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
            {header: '����λ��', dataIndex: 'range',align:'center',width: 80},
            {id: 'isthehosrowid', header: '�������ʱ���ID', width: 129, sortable: true, dataIndex: 'isthehosrowid',hidden:true},
            {header: '�������ʱ���', dataIndex: 'isthehos',align:'center',width: 80}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 260,
    height: 100
});
///////////////��Ӷ���μ���Ա��ť////////////////
var eaddParticipants  = new Ext.Button({
		text: '���',
		handler: function(){
			var ParticipantsId;
			var RangeId;
			var IsTheHosId;
			var id = Ext.getCmp('eParticipants').getValue();
			var rangeid = Ext.getCmp('AuthorRangeCombox').getValue();
			var isthehosid = Ext.getCmp('IsTheHosCombox').getValue();
			
			var ParticipantsName = Ext.getCmp('eParticipants').getRawValue();
			var AuthorRange = Ext.getCmp('AuthorRangeCombox').getRawValue();
			var IsTheHos = Ext.getCmp('IsTheHosCombox').getRawValue();
			var ptotal = ParticipantsGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = ParticipantsGrid.getStore().getAt(i).get('rowid');
					var tmprange = ParticipantsGrid.getStore().getAt(i).get('range');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
//	                        if(tmprange==AuthorRange)
//							{
//								Ext.Msg.show({title:'����',msg:'��ͬ�Ĳ�����Ա��ѡ������ͬ��λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//							  return;
//							}
                               if((rangeid=="")&&((isthehosid=='0')||(isthehosid=='1')))
							{
							  Ext.Msg.show({title:'����',msg:'��ѡ�������Աλ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
							ParticipantsId=id;
							RangeId=rangeid;
						    IsTheHosId=isthehosid;
							}
						}
					}else{
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵĲμ���Ա!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵĲμ���Ա!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
				if((rangeid=="")&&((isthehosid=='0')||(isthehosid=='1')))
							{
							  Ext.Msg.show({title:'����',msg:'��ѡ�������Աλ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
					ParticipantsId=id;
					RangeId=rangeid;
				    IsTheHosId=isthehosid;
					}
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
		}
	});	

	var edelParticipants = new Ext.Button({
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
			var ptotal = ParticipantsGrid.getStore().getCount();
			if(ptotal>0){
				prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  prawValue = prawValue+","+prow;
				}
			}
		}}
	});
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
////////////////////ҽԺ�Գ�//////////////////////
var FundOwnField = new Ext.form.TextField({
	id:'FundOwnField',
    fieldLabel: 'ҽԺ�Գ�',
	width:180,
    allowBlank: true,
    emptyText:'ҽԺ�Գ��Ԫ��...',
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
			allowBlank : true,
			store : IsGovBuyStore,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : true,
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
			fieldLabel : '�Ƿ���������',
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
			editable : true,
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
				bodyStyle:'padding:5px 5px 0',
				border: false
			},            
			items: [
				{
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						},
					   eTypeCombox,
					   eYearField,
					   ProjectsNameFields,                          
					   DeptFields,
					   HeadCombo,
					   ParticipantsGrid,
					   eParticipantsFields,
					   IsTheHosCombox,
					   AuthorRangeCombox,
					   {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
							xtype : 'displayfield',
							columnWidth : .05
							},eaddParticipants,{
							xtype : 'displayfield',
							columnWidth : .07
							},edelParticipants]
						},
						addSubSourceCombo,
						CompleteUnitCombox,
						addDepartmentCombo
						
					]	 
				}, {
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						{
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						},
						RelyUnitsGrid,
					    RelyUnitCombo,
					    {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
							xtype : 'displayfield',
							
							columnWidth : .05
							},eaddRelyUnits,{
							xtype : 'displayfield',
							
							columnWidth : .07
							},edelRelyUnits]
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
  var editFormPanel = new Ext.form.FormPanel({
    labelWidth: 80,
	frame: true,
    items: colItems
	});
	
	editFormPanel.on('afterlayout', function(panel, layout) {
			var rowObj=itemGrid.getSelectionModel().getSelections(); 
			this.getForm().loadRecord(rowObj[0]);
			//"rowid^Dept^Name^Head^Participants^PTName^SubNo^RelyUnit^PrjCN^FundGov^FundOwn^FundMatched^IsGovBuy^AlertPercent^SEndDate^ConDate^Remark"
	    //"^SubUser^SubDate^DataStatuslist^Desc^ProjStatus^ResAudit^HeadDr^ParticipantsIDs^RelyUnitIDs"
			FundGovField.setValue(rowObj[0].get("FundGov"));	
			FundOwnField.setValue(rowObj[0].get("FundOwn"));
			FundMatchedField.setValue(rowObj[0].get("FundMatched"));			
			IsGovBuyField.setRawValue(rowObj[0].get("IsGovBuy"));
			EndDateFields.setValue(rowObj[0].get("EndDate"));
		  StartDateFields.setValue(rowObj[0].get("StartDate"));
			RemarkField.setValue(rowObj[0].get("Remark"));
			AppFundsField.setValue(rowObj[0].get("AppFund"));
			AlertPercentField.setValue(rowObj[0].get("AlertPercent"));
			IsEthicalApprovalField.setRawValue(rowObj[0].get("IsEthicalApproval"));
			CompleteUnitCombox.setRawValue(rowObj[0].get("CompleteUnit"));
			eTypeCombox.setRawValue(rowObj[0].get("Type"));
			eYearField.setRawValue(rowObj[0].get("YearCode"));
		});

  // define window and show it in desktop
  var editWindow = new Ext.Window({
  	title: '�޸���Ŀ���������ϱ���Ϣ',
    width: 600,
    height:540,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: editFormPanel,
    buttons: [{
      text : '����', 
      handler: function() {
	      
      	// check form value
      var ProjectsName = ProjectsNameFields.getValue();
      var DeptDr = DeptFields.getValue();
			var HeadDr = HeadCombo.getValue();
			var ptotal = ParticipantsGrid.getStore().getCount();
			if(ptotal>0){
				//prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
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
				};
			}
			var Participants = prawValue;
			var SubSource = addSubSourceCombo.getValue();
			var AppFunds = AppFundsField.getValue();
		    var StartDate = StartDateFields.getValue();
		    var EndDate = EndDateFields.getValue();
			var ConDate = ConDateFields.getValue();
			var utotal = RelyUnitsGrid.getStore().getCount();
			if(utotal>0){
				urawValue = RelyUnitsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<utotal;i++){
				  var urow = RelyUnitsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  urawValue = urawValue+","+urow;
				};
			}
			var RelyUnit = urawValue;
			//alert(RelyUnit);
			var SubUser = userdr;
			var Remark = RemarkField.getValue();  
            var FundGov = FundGovField.getValue();
			var FundOwn = FundOwnField.getValue();
			var FundMatched = FundMatchedField.getValue();
			var IsGovBuy = IsGovBuyField.getValue();
			var AlertPercent = AlertPercentField.getValue();
			var MatchPercent = MatchPercentField.getValue();
			var CompleteUnit = CompleteUnitCombox.getValue();
			var IsEthicalApproval = IsEthicalApprovalField.getValue();
			var Type = eTypeCombox.getValue();
			var Year = eYearField.getValue();
			var Department = addDepartmentCombo.getValue();
			
			ProjectsName = ProjectsName.trim();
            DeptDr = DeptDr.trim();
			HeadDr = HeadDr.trim();	
			Participants = Participants.trim();
            SubSource = SubSource.trim();
			AppFunds = AppFunds.trim();
			RelyUnit = RelyUnit.trim();
            Remark = Remark.trim();
            Department = Department.trim();
      		
      		//ProjectsName, Participants, HeadDr, EndDate, SubSource, AppFunds, StartDate, SubUser, DeptDr, RelyUnit, Remark, FundGov, FundOwn, FundMatched, IsGovBuy, AlertPercent
	      	var projectname=rowObj[0].get("Name");
	        var participants=rowObj[0].get("Participants");
	        var headdr=rowObj[0].get("Head");
	        var startdate=rowObj[0].get("StartDate");
	        var enddate=rowObj[0].get("EndDate");
	        var deptdr=rowObj[0].get("Dept");
	        var relyunit=rowObj[0].get("RelyUnit");
	        var remark=rowObj[0].get("Remark");
	        var fundgov=rowObj[0].get("FundGov");
	        var fundown=rowObj[0].get("FundOwn");
	        var fundmatched=rowObj[0].get("FundMatched");
	        var appfund=rowObj[0].get("AppFund");
	      	var isgovbuy=rowObj[0].get("IsGovBuy");
	      	var alertpercent=rowObj[0].get("AlertPercent");
	      	var subsource=rowObj[0].get("PTName");
	      	var isethicalapproval=rowObj[0].get("IsEthicalApproval");
	      	var completeunit=rowObj[0].get("CompleteUnit");
      	    var type=rowObj[0].get("Type");
			var year = rowObj[0].get("YearCode");
			var department = rowObj[0].get("Department");
			if(StartDate>EndDate)
			{
				Ext.Msg.show({title:'����',msg:'��������������ڿ�ʼ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
			}
			if(eTypeCombox.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			
			if(eYearField.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(ProjectsNameFields.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��Ŀ����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(DeptFields.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(HeadCombo.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
      		if(addSubSourceCombo.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'������ԴΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
      		if(CompleteUnitCombox.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�ڼ���ɵ�λΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
            if(IsEthicalApprovalField.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�Ƿ���������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};

			if(StartDateFields.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��Ŀ��ʼʱ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
      		if(EndDateFields.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��Ŀ����ʱ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
            if(AppFundsField.getRawValue()=="")
      		{
      			Ext.Msg.show({title:'����',msg:'���뾭�Ѳ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
//      		if(FundGov!="")
//      		{
//      			var Percent = FundOwn/FundGov*100;
//      			if (Percent<MatchPercent){
//      				Ext.Msg.show({title:'����',msg:'ҽԺ�Գ����ϼ��������Ӧ����'+MatchPercent+'%',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//      			  return;
//      				}
//      			
//      		};

		     if(projectname==ProjectsName){ProjectsName="";}
		     if(participants==Participants){Participants="";}
			 if(headdr==HeadDr){HeadDr="";}
			 if(startdate==StartDate){StartDate="";}
			 if(enddate==EndDate){EndDate="";}
			 if(deptdr==DeptDr){DeptDr="";}
			 if(relyunit==RelyUnit){RelyUnit="";}
			 if(remark==Remark){Remark="";}
			 if(fundgov==FundGov){FundGov="";}
			 if(fundown==FundOwn){FundOwn="";}
			 if(fundmatched==FundMatched){FundMatched="";}
			 if(appfund==AppFunds){AppFunds="";}
			 if(isgovbuy==IsGovBuy){IsGovBuy="";}
			 if(alertpercent==AlertPercent){AlertPercent="";}
			 if(subsource==SubSource){SubSource="";}
			 if(isethicalapproval==IsEthicalApproval){IsEthicalApproval="";}
			 if(completeunit==CompleteUnit){CompleteUnit="";}
			 if(type==Type){Type="";}
			 if(year==Year){Year="";}
			 if(department==Department){Department="";}
        	if (editFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url:  'herp.srm.srmprojectsapplyexe.csp?action=edit&rowid='+myRowid+'&ProjectsName='+encodeURIComponent(ProjectsName)+'&Participants='+Participants+'&HeadDr='+HeadDr+'&EndDate='+EndDate+'&SubSource='+SubSource+'&AppFunds='+AppFunds+'&StartDate='+StartDate+'&SubUser='+SubUser+'&DeptDr='+DeptDr+'&RelyUnit='+RelyUnit+'&Remark='+encodeURIComponent(Remark)+'&FundGov='+FundGov+'&FundOwn='+FundOwn+'&FundMatched='+FundMatched+'&IsGovBuy='+encodeURIComponent(IsGovBuy)+'&AlertPercent='+AlertPercent+'&IsEthicalApproval='+IsEthicalApproval+'&CompleteUnit='+CompleteUnit+'&Type='+Type+'&Year='+Year+'&Department='+Department,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:25,userdr:userdr}});
									editWindow.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									//if(jsonData.info!=0) message='��Ϣ�޸�����!';
									if(jsonData.info=='RepProjects') message='�������Ŀ�Ѿ�����!';	
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}          
			   
	    	}

    	},
    	
    	{
			text: 'ȡ��',
        handler: function(){editWindow.close();}
      }]
      
      
    });

    editWindow.show();
};
