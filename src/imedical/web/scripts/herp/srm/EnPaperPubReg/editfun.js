var userid = session['LOGON.USERCODE'];

EditFun = function(AuthorInfoID,CorrAuthorInfoID) {
	

	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	//alert(rowObj[0].get("remark"));
	if(len < 1)
	{
		Ext.Msg.show({title:'提示',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		var editRowid = rowObj[0].get("rowid"); 
		var tmptypeid = rowObj[0].get("TypeID"); 
		var tmpyearid = rowObj[0].get("YearID"); 
		var tmprecordtypeid = rowObj[0].get("RecordTypeID"); 
		var tmpjournaldr = rowObj[0].get("JournalDR"); 
		var tmpjourlevelid = rowObj[0].get("JourLevelID"); 
		var tmppapertypeid = rowObj[0].get("PaperTypeID"); 
		var tmpcompunitid = rowObj[0].get("CompleteUnitID"); 
		var tmpprjdr = rowObj[0].get("PrjDR"); 
	}

////////////////////期刊名称///////////////////
var eJNameDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});
	
eJNameDs.on('beforeload', function(ds, o){
	    ds.proxy=new Ext.data.HttpProxy({
			 url:projUrl+'?action=GetJournalDict&str='+encodeURIComponent(Ext.getCmp('eJNameField').getRawValue()),method:'POST'});
		var year=YearField.getValue();	
		if(!year){
			Ext.Msg.show({title:'注意',msg:'请先选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return ;
		}
});

///////////////////期刊名称/////////////////////////////  
var eJNameField = new Ext.form.ComboBox({
				    id : 'eJNameField',
				    fieldLabel: '期刊名称',
				    width:180,
				    listWidth : 260,
				    allowBlank :false,
				    store: eJNameDs,
				    valueField: 'rowid',
				    displayField: 'name',
				    triggerAction: 'all',
				    //emptyText:'选择...',
				    name: 'eJNameField',
			    	minChars: 1,
				    pageSize: 10,
				    anchor: '95%',
				    selectOnFocus:true,
				    //mode : 'local',
				    forceSelection:'true',
				    editable:true,
					labelSeparator:'',
					value:tmpjournaldr,
				    listeners:{"select":function(combo,record,index){ 
				   	    Ext.Ajax.request({				   	    			        
                     url: projUrl+'?action=GetJournalInfo&year='+encodeURIComponent(YearField.getValue())+'&jdr='+encodeURIComponent(eJNameField.getValue()),
					           success: function(result, request){
					         	 var jsonData = Ext.util.JSON.decode( result.responseText );  
						         if (jsonData.success=='true'){
							         var data = jsonData.info;	
							         var dataarr = data.split("^",-1);
							         var typename = dataarr[2];
							         var levelname = dataarr[3]; 			
							         var ifs = dataarr[4];	         
                       //RecordType.setValue(typename);       
                       JourLevel.setValue(levelname);  
                       IF.setValue(ifs);
					         	}
				         	},
					       scope: this
				   	    });           
			        }}  
});	
///////////////////被收录数据库/////////////////////////////  
/**
var RecordType = new Ext.form.TextField({
				fieldLabel: '被收录数据库',
				width:180,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '被收录数据库......',
				selectOnFocus:'true',
				disabled:true

			});
**/

			
	/* var RecordTypeDs = new Ext.data.Store({
		        autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});	
	
	
	RecordTypeDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:projUrl+'?action=GetJournalTypes&str='+encodeURIComponent(Ext.getCmp('RecordType').getRawValue()),method:'POST'});
				
	}); */
	var eRecordTypeDs = new Ext.data.Store({
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : "results",
								root : 'rows'
							}, ['rowid', 'name'])
				});

		eRecordTypeDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
			         url : projUrl+'?action=GetJournalTypes&str='+encodeURIComponent(Ext.getCmp('eRecordTypeField').getRawValue()),
			         method : 'POST'
				});
		});
	
	var eRecordTypeField = new Ext.form.ComboBox({
					id:'eRecordTypeField',
			        name:'eRecordTypeField',
			        fieldLabel : '被收录数据库',
					store : eRecordTypeDs,
					displayField : 'name',
					valueField : 'rowid',
					//typeAhead : true,
					allowBlank : false, 
					anchor: '95%',
					forceSelection : true,
					triggerAction : 'all',
					//emptyText : '',
					width : 180,
					value:tmprecordtypeid,
					listWidth : 260,
                    editable:true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					labelSeparator:''
 });			
 
 ///////////////////期刊级别/////////////////////////////  
var JourLevel = new Ext.form.TextField({
				fieldLabel: '期刊级别',
				width:180,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '期刊级别......',
				selectOnFocus:'true',
        disabled:true,
		labelSeparator:''
			});

///////////////////论文题目/////////////////////////////  
var Title = new Ext.form.TextArea({
				fieldLabel: '论文题目',
				width:180,
				allowBlank : false, 
				anchor: '95%',
        ////emptyText: '科目名称......',
				selectOnFocus:'true',
				labelSeparator:''

			});
			
///////////////////论文类别/////////////////////////////  
var EnPaperTypeDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
	});
					
EnPaperTypeDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:projUrl+'?action=GetPaperType&str='+encodeURIComponent(Ext.getCmp('EnPaperType').getRawValue()),method:'POST'});
	});
	
var EnPaperType = new Ext.form.ComboBox({
				    id :'EnPaperType',
				    fieldLabel: '论文类别',
				    width:180,
				    listWidth : 260,
				    allowBlank :true,
				    store: EnPaperTypeDs,
				    valueField: 'code',
				    displayField: 'name',
				    triggerAction: 'all',
				    ////emptyText:'选择...',
				    name: 'EnPaperType',
					value:tmppapertypeid,
			    	minChars: 1,
				    pageSize: 10,
				    anchor: '95%',
				    selectOnFocus:true,
				    forceSelection:'true',
				    editable:true,
					labelSeparator:''
			});

///////////////////第一作者/////////////////////////////  
var FristAuthorDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});
					
FristAuthorDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('FristAuthor').getRawValue()),method:'POST'});
	});
	
var FristAuthor = new Ext.form.ComboBox({
				    id :'FristAuthor',
				    fieldLabel: '第一作者',
				    width:180,
				    listWidth : 260,
				    allowBlank :true,
				    store: FristAuthorDs,
				    valueField: 'rowid',
				    displayField: 'name',
				    triggerAction: 'all',
				    ////emptyText:'选择...',
				    name: 'FristAuthor',
			    	minChars: 1,
				    pageSize: 10,
				    anchor: '95%',
					disabled:true,
				    selectOnFocus:true,
				    forceSelection:'true',
				    editable:true,
					labelSeparator:''
			});	

////*************作者ID、排名、是否本院**************////////
//////////////////作者///////////////////////
var ParticipantssDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


ParticipantssDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('Participantsss').getRawValue()),
	method:'POST'});
});

var ParticipantsFields = new Ext.form.ComboBox({
	id: 'Participantsss',
	fieldLabel: '作者',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:ParticipantssDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择作者...',
	name: 'Participantsss',
	minChars: 1,
	pageSize: 10,
	anchor: '95%',
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

///////////////////作者位次/////////////////////////////  
var AuthorRangeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '第一'],['2', '第二'], ['3', '第三'], ['4', '第四'], ['5', '第五'],['6', '第六'],['7', '第七'],['8', '第八'],['9', '其他']]
	});		
		
var AuthorRangeCombox = new Ext.form.ComboBox({
	                   id : 'AuthorRangeCombox',
		           fieldLabel : '作者位次',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : AuthorRangeDs,
		           anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:''
						  });	
///////////////////是否本院/////////////////////////////  
var IsTheHosDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '本院职工'],['0', '外院人员'],['2','博士研究生'],['3','硕士研究生']]
	});		
		
var IsTheHosCombox = new Ext.form.ComboBox({
	                   id : 'IsTheHosCombox',
		           fieldLabel : '论文发表时身份',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : IsTheHosDs,
		           anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:'',
				   listeners:{
                           "select":function(combo,record,index){
						           if((combo.value=='2')||(combo.value=='3'))
								   {
								   AuthorRangeCombox.setValue('');
								   AuthorRangeCombox.disable();  //变为灰；不可编辑
                                   //AuthorRangeCombox.disabled=true;   //不变为灰；不可编辑	
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
		url:projUrl+'?action=GetPaperAuthorInfo&start='+0+'&limit='+25+'&IDs='+AuthorInfoID,
		method:'POST'}),
	  reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','rangerowid','range','isthehosrowid','isthehos'])

    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '作者ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '作者名称', dataIndex: 'name',align:'center',width: 80},
            {id: 'rangerowid', header: '作者排名ID', width: 129, sortable: true, dataIndex: 'rangerowid',hidden:true},
            {header: '作者位次', dataIndex: 'range',align:'center',width: 80},
            {id: 'isthehosrowid', header: '论文发表时身份ID', width: 129, sortable: true, dataIndex: 'isthehosrowid',hidden:true},
            {header: '论文发表时身份', dataIndex: 'isthehos',align:'center',width: 100}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 280,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'添加',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////添加多个参加人员按钮////////////////
var addParticipants  = new Ext.Button({
		text: '增加',
		iconCls: 'edit_add',
		handler: function(){
			var ParticipantsId;
			var RangeId;
			var IsTheHosId;
			var id = Ext.getCmp('Participantsss').getValue();
			var rangeid = Ext.getCmp('AuthorRangeCombox').getValue();
			var isthehosid = Ext.getCmp('IsTheHosCombox').getValue();
			var ParticipantsName = Ext.getCmp('Participantsss').getRawValue();
			var AuthorRange = Ext.getCmp('AuthorRangeCombox').getRawValue();
			var IsTheHos = Ext.getCmp('IsTheHosCombox').getRawValue();
			var firstauthor = FristAuthor.getValue();
		
      if(id==firstauthor )
			{
				if( rangeid!=1)
				{
				   Ext.Msg.show({title:'错误',msg:'第一作者位次必须为第一位!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				   return;
			  }
			}
			var ptotal = ParticipantsGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = ParticipantsGrid.getStore().getAt(i).get('rowid');
					var tmprange = ParticipantsGrid.getStore().getAt(i).get('range');
					
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'错误',msg:'您选择了同一个人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
						   if((rangeid=="")&&((isthehosid=='0')||(isthehosid=='1')))
							{
							  Ext.Msg.show({title:'错误',msg:'请选择作者位次!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else {
							if((tmprange==AuthorRange)&&((isthehosid=='0')||(isthehosid=='1')))
							{
								Ext.Msg.show({title:'错误',msg:'不同的作者您选择了相同的位次!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
							if(rangeid=='1'){
							FristAuthor.setValue(id);FristAuthor.setRawValue(ParticipantsName);
							}
						    ParticipantsId=id;
						    RangeId=rangeid;
						    IsTheHosId=isthehosid;
						  }
						}
					}
					}else{
						Ext.Msg.show({title:'提示',msg:'请选择作者!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}
					
					
				if((AuthorRange=="")&&((isthehosid=='0')||(isthehosid=='1')))
							{
								Ext.Msg.show({title:'错误',msg:'请选择作者位次!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							
							if(IsTheHos=="")
							{
								Ext.Msg.show({title:'错误',msg:'请选择论文发表时身份!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'提示',msg:'请选择作者!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				if((AuthorRange=="")&&((isthehosid=='0')||(isthehosid=='1')))
							{
								Ext.Msg.show({title:'错误',msg:'请选择作者位次!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							
							if(IsTheHos=="")
							{
								Ext.Msg.show({title:'错误',msg:'请选择论文发表时的身份!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
				else{		
				       if(rangeid=='1'){
							FristAuthor.setValue(id);FristAuthor.setRawValue(ParticipantsName);
					    }
						ParticipantsId=id;
						RangeId=rangeid;
						IsTheHosId=isthehosid;			
				}	
			}
			var data = new Ext.data.Record({'rowid':ParticipantsId,'name':ParticipantsName,'rangerowid':RangeId,'isthehosrowid':IsTheHosId,'range':AuthorRange,'isthehos':IsTheHos});
			ParticipantsGrid.stopEditing(); 
			ParticipantsGrid.getStore().insert(ptotal,data);
			if(ptotal>0){
				prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  prawValue = prawValue+","+prow;
				}
			}
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delParticipants = new Ext.Button({
		text:'删除',
		iconCls: 'edit_remove',
		handler: function() {  
			var rows = ParticipantsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = ParticipantsGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				var temprangerowid = ParticipantsGrid.getStore().getAt(rRowid).get('rangerowid')
				//alert("temprangerowid:"+temprangerowid);
				if(temprangerowid=='1'){FristAuthor.setValue("");FristAuthor.setRawValue("");}
				ParticipantsGrid.getStore().removeAt(rRowid);//移除所选中的一行
			}

			var ptotal = ParticipantsGrid.getStore().getCount();
			//alert(total);
			if(ptotal>0){
				prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  prawValue = prawValue+","+prow;
				}
			}
			
		}
	});
////*************作者ID、排名、是否本院**************////////

///////////////////第一通讯作者/////////////////////////////  
var CorrAuthorDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});
			
			
CorrAuthorDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('CorrAuthor').getRawValue()),method:'POST'});
	});
	
var CorrAuthor = new Ext.form.ComboBox({
				    id :'CorrAuthor',
				    fieldLabel: '第一通讯作者',
				    width:180,
				    listWidth : 260,
				    allowBlank :true,
				    store: CorrAuthorDs,
				    valueField: 'rowid',
				    displayField: 'name',
				    triggerAction: 'all',
				    ////emptyText:'选择...',
				    name: 'CorrAuthor',
			    	minChars: 1,
				    pageSize: 10,
				    anchor: '95%',
					disabled:true,
				    selectOnFocus:true,
				    forceSelection:'true',
				    editable:true,
					labelSeparator:''
			});	
			
////*************通讯作者ID、排名、是否本院**************////////
//////////////////通讯作者///////////////////////
var CorrParticipantssDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


CorrParticipantssDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('CorrParticipantsss').getRawValue()),
	method:'POST'});
});

var CorrParticipantsFields = new Ext.form.ComboBox({
	id: 'CorrParticipantsss',
	fieldLabel: '通讯作者',
	width:180,
	listWidth : 260,
	anchor:'95%',
	allowBlank: true,
	store:CorrParticipantssDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择其他通讯作者...',
	name: 'CorrParticipantsss',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

///////////////////通讯作者位次/////////////////////////////  
var CorrAuthorRangeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '第一'],['2', '并列']]
		//data : [['1', '第一'],['2', '第二'], ['3', '第三'], ['4', '第四'], ['5', '第五'],['6', '第六'],['7', '第七'],['8', '第八']]
	});		
		
var CorrAuthorRangeCombox = new Ext.form.ComboBox({
	                   id : 'CorrAuthorRangeCombox',
		           fieldLabel : '通讯作者位次',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : CorrAuthorRangeDs,
		           anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:''
						  });	
///////////////////通讯作者是否本院/////////////////////////////  
var CorrIsTheHosDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '本院职工'],['0', '外院人员'],['2','博士研究生'],['3','硕士研究生']]
	});		
		
var CorrIsTheHosCombox = new Ext.form.ComboBox({
	                   id : 'CorrIsTheHosCombox',
		           fieldLabel : '发表论文时身份',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : CorrIsTheHosDs,
		           anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:'',
				   listeners:{
                           "select":function(combo,record,index){
						           if((combo.value=='2')||(combo.value=='3'))
								   {
								   CorrAuthorRangeCombox.setValue('');
								   CorrAuthorRangeCombox.disable();  //变为灰；不可编辑
                                   //CorrAuthorRangeCombox.disabled=true;   //不变为灰；不可编辑	
                                   }				
                                   else{
								   CorrAuthorRangeCombox.enable();  	
								   }								   
			}
	}	
						  });	
						  
var CorrParticipantsGrid = new Ext.grid.GridPanel({
		id:'CorrParticipantsGrid',
    store: new Ext.data.Store({
    autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:projUrl+'?action=GetPaperAuthorInfo&start='+0+'&limit='+25+'&IDs='+CorrAuthorInfoID,
		method:'POST'}),
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','rangerowid','range','isthehosrowid','isthehos'])
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '通讯作者ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '通讯作者名称', dataIndex: 'name',align:'center',width: 80},
            {id: 'rangerowid', header: '通讯作者排名ID', width: 129, sortable: true, dataIndex: 'rangerowid',hidden:true},
            {header: '通讯作者位次', dataIndex: 'range',align:'center',width: 80,
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					   if (value=='第二'){
						   var value='并列';
						   };       
						  return '<span >'+value+'</span>';
			}
            
            },
            {id: 'isthehosrowid', header: '发表论文时身份ID', width: 129, sortable: true, dataIndex: 'isthehosrowid',hidden:true},
            {header: '发表论文时身份', dataIndex: 'isthehos',align:'center',width: 100}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 280,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'添加',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////添加多个参加人员按钮////////////////
var addCorrParticipants  = new Ext.Button({
		text: '增加',
		iconCls: 'edit_add',
		handler: function(){
			var ParticipantsId;
			var RangeId;
			var IsTheHosId;
			var id = Ext.getCmp('CorrParticipantsss').getValue();
			var rangeid = Ext.getCmp('CorrAuthorRangeCombox').getValue();
			var isthehosid = Ext.getCmp('CorrIsTheHosCombox').getValue();
			var ParticipantsName = Ext.getCmp('CorrParticipantsss').getRawValue();
			var AuthorRange = Ext.getCmp('CorrAuthorRangeCombox').getRawValue();
			var IsTheHos = Ext.getCmp('CorrIsTheHosCombox').getRawValue();
			var corrauthor = CorrAuthor.getValue();
		
			var ptotal = CorrParticipantsGrid.getStore().getCount();
//			if(corrauthor==id)
//			{
//				Ext.Msg.show({title:'错误',msg:'不能再次选择第一通讯作者!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//			  return;
//			}
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = CorrParticipantsGrid.getStore().getAt(i).get('rowid');
					var tmprange = CorrParticipantsGrid.getStore().getAt(i).get('range');
					
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'错误',msg:'您选择了同一个人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
						    if((rangeid=="")&&((isthehosid=='0')||(isthehosid=='1')))
							{
							  Ext.Msg.show({title:'错误',msg:'请选择作者位次!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
							if((tmprange==AuthorRange)&&(AuthorRange=='第一'))
							{
								Ext.Msg.show({title:'错误',msg:'第一通讯作者只能选择一人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
							if(rangeid=='1'){
						       CorrAuthor.setValue(id);CorrAuthor.setRawValue(ParticipantsName);
					        }
						    ParticipantsId=id;
						    RangeId=rangeid;
						    IsTheHosId=isthehosid;
						  }
						  }
						}
					}else{
						Ext.Msg.show({title:'提示',msg:'请选择您要添加的通讯作者!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				
				if((AuthorRange=="")&&((isthehosid=='0')||(isthehosid=='1')))
							{
								Ext.Msg.show({title:'错误',msg:'请选择通讯作者位次!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							
							if(IsTheHos=="")
							{
								Ext.Msg.show({title:'错误',msg:'请选择论文发表时身份!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
				
				
				}
			}else{
				if(id==""){
					
					Ext.Msg.show({title:'提示',msg:'请选择您要添加的通讯作者!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				
					
				
				else{	
				
				
					
				       if(rangeid=='1'){
						CorrAuthor.setValue(id);CorrAuthor.setRawValue(ParticipantsName);
					   }
						ParticipantsId=id;
						RangeId=rangeid;
						IsTheHosId=isthehosid;			
				}	
			}
			var data = new Ext.data.Record({'rowid':ParticipantsId,'name':ParticipantsName,'rangerowid':RangeId,'isthehosrowid':IsTheHosId,'range':AuthorRange,'isthehos':IsTheHos});
			CorrParticipantsGrid.stopEditing(); 
			CorrParticipantsGrid.getStore().insert(ptotal,data);
			if(ptotal>0){
				prawValue = CorrParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = CorrParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  prawValue = prawValue+","+prow;
				}
			}
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delCorrParticipants = new Ext.Button({
		text:'删除',
		iconCls: 'edit_remove',
		handler: function() {  
			var rows = CorrParticipantsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = CorrParticipantsGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				//获得行号为rRowid的rangerowidrowid
				var temprangerowid = CorrParticipantsGrid.getStore().getAt(rRowid).get('rangerowid') 
				//alert("temprangerowid:"+temprangerowid);
				if(temprangerowid=='1'){CorrAuthor.setValue("");CorrAuthor.setRawValue("");}
				CorrParticipantsGrid.getStore().removeAt(rRowid);//移除所选中的一行
			}

			var ptotal = CorrParticipantsGrid.getStore().getCount();
			//alert(total);
			if(ptotal>0){
				prawValue = CorrParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = CorrParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  prawValue = prawValue+","+prow;
				}
			}
			
		}
	});
////*************通讯作者ID、排名、是否本院**************////////

///////////////////年/////////////////////////////  

var YearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetYear&str='+encodeURIComponent(YearField.getRawValue()),method:'POST'});
});

var YearField = new Ext.form.ComboBox({
	id: 'YearField',
	fieldLabel: '年',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	anchor: '95%',
	name: 'YearField',
	value:tmpyearid,
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});
		
///////////////////卷/////////////////////////////  
var Roll = new Ext.form.TextField({
				fieldLabel: '卷',
				width:180,
				//allowBlank : true, 
				regex:/[0-9]*[1-9][0-9]*$/,
				regexText:"请填写数字!",
				anchor: '95%',
        ////emptyText: '科目名称......',
				selectOnFocus:'true',
				labelSeparator:''

			});
					
			
///////////////////期/////////////////////////////  
var Period = new Ext.form.TextField({
				fieldLabel: '期',
				width:180,
				//allowBlank : true, 
				regex:/[0-9]*[1-9][0-9]*$/,
				regexText:"请填写数字!",
				anchor: '95%',
        ////emptyText: '科目名称......',
				selectOnFocus:'true',
				labelSeparator:''

			});		
			
			
			
///////////////////起始页/////////////////////////////  
var StartPage = new Ext.form.TextField({
				fieldLabel: '起始页',
				width:180,
				allowBlank : true,
				regex:/[0-9]*[1-9][0-9]*$/,
				regexText:"请填写数字!", 
				anchor: '95%',
        ////emptyText: '科目名称......',
				selectOnFocus:'true',
				labelSeparator:''

			});
					
			
///////////////////终止页/////////////////////////////  
var EndPage = new Ext.form.TextField({
				fieldLabel: '终止页',
				width:180,
				allowBlank : true, 
				regex:/[0-9]*[1-9][0-9]*$/,
				regexText:"请填写数字!",
				anchor: '95%',
        ////emptyText: '科目名称......',
				selectOnFocus:'true',
				labelSeparator:''

			});			
	
///////////////////影响因子/////////////////////////////  
var IF = new Ext.form.NumberField({
				id:'IF',
				fieldLabel: '影响因子',
				width:180,
				allowBlank : true, 
				disabled:false,
				anchor: '95%',
				regex:/^\d+(\.\d+)?$/,
				regexText:"请填写数字!",
				name:'IF',
				selectOnFocus:'true',
				editable:true,
				labelSeparator:''

								
});			
///////////////////版面费/////////////////////////////  
var PageChargeField = new Ext.form.NumberField({
				fieldLabel: '申请版面费(元)',
				width:180,
				allowBlank : true, 
				disabled:false,
				regex:/^\d+(\.\d+)?$/,
				regexText:"请填写数字!",
				anchor: '95%',
				selectOnFocus:'true',
				editable:true,
				labelSeparator:''

});
////////////////////货币单位/////////////////////////////

var UnitMoneyStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['R','人民币'],['D','美元'],['E','欧元'],['P','英镑']]
});

var UnitMoneyField = new Ext.form.ComboBox({
	id: 'UnitMoneyField',
	fieldLabel: '货币单位',
	width:180,
	anchor: '95%',
	listWidth : 180,
	allowBlank: true,
	store:UnitMoneyStore,
	valueField: 'key',
	displayField: 'keyvalue',
	value:'R',
	triggerAction: 'all',
	//emptyText:'请选择货币单位...',
	mode : 'local',
	name: 'UnitMoneyField',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	labelSeparator:''

});


///////////////////发票代码/////////////////////////////  
var InvoiceCodeField = new Ext.form.NumberField({
				fieldLabel: '发票代码',
				width:180,
				allowBlank : true, 
				disabled:false,
				anchor: '95%',
				selectOnFocus:'true',
				editable:true,
				labelSeparator:''

});	
///////////////////发票号码/////////////////////////////  
var InvoiceNoField = new Ext.form.NumberField({
				fieldLabel: '发票号码',
				width:180,
				allowBlank : true, 
				disabled:false,
				anchor: '95%',
				selectOnFocus:'true',
				editable:true,
				labelSeparator:''

});				
/////////////////我院单位位次///////////////////////////
var CompleteUnitStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','第一完成单位'],['2','第二完成单位'],['3','第三完成单位'],['4','第四完成单位'],['5','第五完成单位'],['6','第六完成单位'],['7','第七完成单位'],['8','第八完成单位']]
});

var CompleteUnitField = new Ext.form.ComboBox({
	id: 'CompleteUnitField',
	fieldLabel: '我院单位位次',
	width:180,
	anchor: '95%',
	listWidth : 180,
	allowBlank: true,
	store:CompleteUnitStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	////emptyText:'请选择我院单位位次...',
	mode : 'local',
	name: 'CompleteUnitField',
	minChars: 1,
	//pageSize: 10,
	value:tmpcompunitid,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	labelSeparator:''

});
/////////////////是否ESI高被引///////////////////////////
var ESICitedStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','是'],['0','否']]
});

var ESICitedField = new Ext.form.ComboBox({
	id: 'ESICitedField',
	disabled:true,
	fieldLabel: '是否ESI高被引',
	width:180,
	anchor: '95%',
	listWidth : 180,
	allowBlank: true,
	store:ESICitedStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	////emptyText:'请选择是否ESI高被引...',
	mode : 'local',
	name: 'ESICitedField',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	//hidden:true,
	labelSeparator:''

});
///////////////////类型/////////////////////////////  
var eTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '科研'],['2', '教学']]
	});		
		
var eTypeCombox = new Ext.form.ComboBox({
	                   id : 'eTypeCombox',
		           fieldLabel : '类型',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : eTypeDs,
		           anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           value:tmptypeid,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:''

						  });	
////课题名称
var ePrjNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
ePrjNameDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=GetPrjName&str='+encodeURIComponent(Ext.getCmp('ePrjNameField').getRawValue()),
						method : 'POST'
					});
		});
var ePrjNameField = new Ext.form.ComboBox({
	        id:'ePrjNameField',
			fieldLabel : '依托项目',
			width : 180,
			listWidth : 260,
			selectOnFocus : true,
			//allowBlank : false,
			store : ePrjNameDs,
			anchor : '95%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			//emptyText : '',
			//mode : 'local', // 本地模式
			name:'ePrjNameField',
			editable : true,
			pageSize : 10,
			minChars : 1,
			value:tmpprjdr,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''

		});

///院外依托课题
var eOutPrjNameField = new Ext.form.TextField({
	fieldLabel:'依托项目(院外)',
	width : 180,
	anchor : '95%',
	allowBlank : true,
	selectOnFocus : true,
	labelSeparator:''

});

var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.5',
							bodyStyle:'padding:0px 0px 0',
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
										columnWidth : .03
									}, */
									eTypeCombox,
									 eJNameField,   
								   JourLevel,
								    eRecordTypeField,
								   EnPaperType, 
								   Title, 	 
                                   //ESICitedField,								   
								   CompleteUnitField,
									 YearField,
								   Roll,
								   Period,
								   StartPage,
								   EndPage,
									 IF	,
									 PageChargeField,
									 UnitMoneyField,
								   InvoiceCodeField,
								   InvoiceNoField	
								   					   
								]	 
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								   /* {
										xtype : 'displayfield',
										value : '',
										columnWidth : .03
									}, */
									FristAuthor, 
								   ParticipantsGrid,
					         ParticipantsFields,
							 IsTheHosCombox,
					         AuthorRangeCombox,
					        {
						         columnWidth : 1,
						         xtype : 'panel',
						         layout : "column",
						         items : [{
							       xtype : 'displayfield',
							       columnWidth : .05
							    },addParticipants,
							    {
							       xtype : 'displayfield',
							       columnWidth : .07
							    },delParticipants]
						      },
								   CorrAuthor,
								   CorrParticipantsGrid,
					         CorrParticipantsFields,
							 CorrIsTheHosCombox,
					         CorrAuthorRangeCombox,
					        {
						         columnWidth : 1,
						         xtype : 'panel',
						         layout : "column",
						         items : [{
							       xtype : 'displayfield',
							       columnWidth : .05
							    },addCorrParticipants,
							    {
							       xtype : 'displayfield',
							       columnWidth : .07
							    },delCorrParticipants]
						      }	,
								ePrjNameField,	
								eOutPrjNameField
								]
							 }]
					}
				]			
			
var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 100,
				labelAlign:'right',
				//layout: 'form',
				frame: true,
				items: colItems
			});

formPanel.on('afterlayout', function(panel, layout) {
			var rowObj=itemGrid.getSelectionModel().getSelections(); 
			this.getForm().loadRecord(rowObj[0]);
			//"rowid^RecordType^DeptDr^Title^JName^PType^FristAuthor^CorrAuthor^CNPaperType^PageCharge^SubUser^
			//SubDate^DataStatus^CheckDesc^CheckState^RegInfo^PubYear^Roll^Period^StartPage^EndPage^TitleInfo"
			Title.setValue(rowObj[0].get("Title"));
			eJNameField.setRawValue(rowObj[0].get("JName"));
			//JName.setValue(rowObj[0].get("JournalDR"));
			eRecordTypeField.setRawValue(rowObj[0].get("RecordType"));//被收录数据库
			//RecordType.setValue(rowObj[0].get("RecordTypeID"));
			
			UnitMoneyField.setRawValue(rowObj[0].get("UnitMoney"));//货币单位
			
			JourLevel.setRawValue(rowObj[0].get("JourLevel"));   //刘小明
			EnPaperType.setRawValue(rowObj[0].get("PaperType"));	
			FristAuthor.setRawValue(rowObj[0].get("FristAuthor"));	
			CorrAuthor.setRawValue(rowObj[0].get("CorrAuthor"));	
			
			//FirstAuthorRangeCombox.setRawValue(rowObj[0].get("FristAuthorRange"));
			
			PageChargeField.setValue(rowObj[0].get("PageCharge"));			
			YearField.setRawValue(rowObj[0].get("PubYear"));
			Roll.setValue(rowObj[0].get("Roll"));
		    Period.setValue(rowObj[0].get("Period"));
			StartPage.setValue(rowObj[0].get("StartPage"));
			EndPage.setValue(rowObj[0].get("EndPage"));
			InvoiceCodeField.setValue(rowObj[0].get("InvoiceCode"));   //刘小明
			InvoiceNoField.setValue(rowObj[0].get("InvoiceNo"));
			
			CompleteUnitField.setRawValue(rowObj[0].get("CompleteUnit"));
			IF.setValue(rowObj[0].get("IF"));
			ESICitedField.setRawValue(rowObj[0].get("ESICited"));
			eTypeCombox.setRawValue(rowObj[0].get("Type"));
			
			ePrjNameField.setRawValue(rowObj[0].get("PrjName"));
			eOutPrjNameField.setValue(rowObj[0].get("OutPrjName"))
		});
	
			editButton = new Ext.Toolbar.Button({
				text:'保存',
				iconCls: 'save'
			});
var allauthorinfo = "";
var allcorrauthorinfo = "";

			editHandler = function(){
				var PrjDr = ePrjNameField.getValue(); 
				var OutPrjName = eOutPrjNameField.getValue();
				
				var JNameDr = eJNameField.getValue(); 
				
				var Titles = Title.getValue(); 
				var EnPaperTypes = EnPaperType.getValue();   //刘小明
				var FristAuthors = FristAuthor.getValue(); 
				//var FristAuthorsRange = FirstAuthorRangeCombox.getValue(); 
				var authorscount = ParticipantsGrid.getStore().getCount();
			  if(authorscount>0){
				var authorid = ParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorrangeid = ParticipantsGrid.getStore().getAt(0).get('rangerowid');
				var authoristhehosid = ParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
				allauthorinfo = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				for(var i=1;i<authorscount;i++){
				  var authorid = ParticipantsGrid.getStore().getAt(i).get('rowid');
				  var authorrangeid = ParticipantsGrid.getStore().getAt(i).get('rangerowid');
				  var authoristhehosid = ParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				  var authorinfo = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				  allauthorinfo = allauthorinfo+","+authorinfo;
				   };
			   }
				
				var CorrAuthors = CorrAuthor.getValue(); 
				//var CorrAuthorsRange = CorrAuthorRangeCombox.getValue(); 
				var corrauthorscount = CorrParticipantsGrid.getStore().getCount();
			  if(corrauthorscount>0){
				var corrauthorid = CorrParticipantsGrid.getStore().getAt(0).get('rowid');
				var corrauthorrangeid = CorrParticipantsGrid.getStore().getAt(0).get('rangerowid');
				var corrauthoristhehosid = CorrParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
				allcorrauthorinfo = corrauthorid+"-"+corrauthorrangeid+"-"+corrauthoristhehosid;
				for(var i=1;i<corrauthorscount;i++){
				  var corrauthorid = CorrParticipantsGrid.getStore().getAt(i).get('rowid');
				  var corrauthorrangeid = CorrParticipantsGrid.getStore().getAt(i).get('rangerowid');
				  var corrauthoristhehosid = CorrParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				  var corrauthorinfo = corrauthorid+"-"+corrauthorrangeid+"-"+corrauthoristhehosid;
				  allcorrauthorinfo = allcorrauthorinfo+","+corrauthorinfo;
				   };
			   }
			   
				var YearFields = YearField.getValue(); 
				var Rolls = Roll.getValue(); 			
				var Periods = Period.getValue(); 
        var StartPages = StartPage.getValue(); 
        var EndPages = EndPage.getValue();        
        var IFs = IF.getValue(); 
        var PageCharge = PageChargeField.getValue();
        var InvoiceCodes = InvoiceCodeField.getValue();  //刘小明
        var InvoiceNos = InvoiceNoField.getValue();
        var CompleteUnit = CompleteUnitField.getValue();
        var ESICited = ESICitedField.getValue();
        
        var RecordTypes = eRecordTypeField.getValue();//被收录数据库
        var UnitMoneys = UnitMoneyField.getValue(); //货币单位
        
        var Types = eTypeCombox.getValue(); //xm20150311
		
		if(eTypeCombox.getRawValue()=="")
		{
		Ext.Msg.show({title:'错误',msg:'类型不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
		}
		if(YearField.getRawValue()=="")
		{
		Ext.Msg.show({title:'错误',msg:'年度不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
		}
        if(((+StartPages)>(+EndPages))&(StartPages!="")&(EndPages!=""))
        {
        	Ext.Msg.show({title:'错误',msg:'起止页填写错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
        }
        if(Title.getRawValue()=="")
        {
        	Ext.Msg.show({title:'错误',msg:'论文题目不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
        }
        if(eJNameField.getRawValue()=="")
         {
        	Ext.Msg.show({title:'错误',msg:'期刊名称不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
        }
        if(eRecordTypeField.getRawValue()=="")
		{
		Ext.Msg.show({title:'错误',msg:'被收录数据库不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
		}
		if(allauthorinfo=="")
		{
			Ext.Msg.show({title:'错误',msg:'论文作者不能全部为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
		}
				if(formPanel.form.isValid()){
			   Ext.Ajax.request({
					url: projUrl+'?action=update&rowid='+editRowid+'&Titles='+encodeURIComponent(Titles)+'&FristAuthors='+encodeURIComponent(FristAuthors)
					+'&AuthorsInfo='+encodeURIComponent(allauthorinfo)+'&CorrAuthors='+encodeURIComponent(CorrAuthors)+'&CorrAuthorsInfo='+encodeURIComponent(allcorrauthorinfo)
					+'&PubYear='+encodeURIComponent(YearFields)+'&Rolls='+encodeURIComponent(Rolls)+'&Periods='+encodeURIComponent(Periods)+'&StartPages='+encodeURIComponent(StartPages)
					+'&EndPages='+encodeURIComponent(EndPages)+'&IFs='+encodeURIComponent(IFs)+'&JNameDr='+encodeURIComponent(JNameDr)+'&PageCharge='+PageCharge
					+'&PaperType='+encodeURIComponent(EnPaperTypes)+'&InvoiceCode='+encodeURIComponent(InvoiceCodes)+'&InvoiceNo='+encodeURIComponent(InvoiceNos)+'&CompleteUnit='+encodeURIComponent(CompleteUnit)+'&ESICited='+encodeURIComponent(ESICited)+'&RecordTypes='+encodeURIComponent(RecordTypes)+'&UnitMoneys='+encodeURIComponent(UnitMoneys)+'&Type='+encodeURIComponent(Types)+'&PrjDr='+encodeURIComponent(PrjDr)+'&OutPrjName='+encodeURIComponent(OutPrjName),
						waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );	
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!请再次查询查看修改结果',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});									
									editwin.close();
									
									var data = ''+"|"+''+"|"+''+"|"+''+"|"+''+"|"+''+"|"+''+"|"+userdr 
									itemGrid.load({params:{data:data,sortField:'', sortDir:'',start:0,limit:25}});  //20151221 hiddin 
								}
								else
								{	
									//RepTitles
									var message = "";
									if(jsonData.info=='RepTitles') message='论文名称重复!';
							    Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							    if(jsonData.info=='RepInvoice') message='发票信息重复!';
							    Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
						
						}else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后保存。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					} 
					editwin.close();
			}
			
			editButton.addListener('click',editHandler,false);
	
			cancelButton = new Ext.Toolbar.Button({
				text:'关闭',
				iconCls : 'cancel'
			});
			
			cancelHandler = function(){
				editwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			editwin = new Ext.Window({
				title: '修改论文报销与奖励信息',
				iconCls: 'pencil',
				width: 620,
				height: 620,
				//autoHeight: true,
				layout: 'fit',
				plain:true,
				modal:true,
				//bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items: formPanel,
				buttons: [
					editButton,
					cancelButton
				]
			});		
			editwin.show();			

		}
			
				
	
	


