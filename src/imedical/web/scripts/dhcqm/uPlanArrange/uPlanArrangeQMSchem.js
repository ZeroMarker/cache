function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

QMSchem = function(dataStore,grid,pagingTool,addOrEdit) {
if(addOrEdit=="edit"){
	//�õ��Ѿ�ѡ�����Ŀid
	var rowObj=itemGrid.getSelectionModel().getSelections();
	var schemDr=rowObj[0].data.qmschemDr;
	
	}else{
		var schemDr="";
	}

//���年ѡ������
var selectArr=[];
	var nameUrl = '../csp/dhc.qm.uPlanArrangeexe.csp';
	var nameProxy= new Ext.data.HttpProxy({url:nameUrl + '?action=QMSchemList',method:'POST'});
	var nameDs = new Ext.data.Store({   //��������Դ
           
			proxy: nameProxy,
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'	
			},['grouRowid','grouName']),
			remoteSort: true	
});
var sm = new Ext.grid.CheckboxSelectionModel();
	//����Ĭ�������ֶκ�������
	nameDs.setDefaultSort('grouRowid', 'grouName');

	//���ݿ�����ģ��
	var nameCm = new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),
		{

            id:'grouName',
            header: '�����Ŀ',
            allowBlank: false,
            width:180,
            editable:false,
            dataIndex: 'grouName' ,
            renderer: function(value, metaData, record, rowIndex, colIndex, store){
	           var grouRowid=record.data.grouRowid;
	           var isExt=schemDr.indexOf(grouRowid);
	           if(isExt>-1){
					selectArr.push(rowIndex);
		       }
	        	return value;
	        }
           
       }
		
	]);
	
	var grid = new Ext.grid.GridPanel({
		store:nameDs,
		cm:nameCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:sm,
		loadMask: true
	});

	nameDs.load({
		params:{start:0,limit:10000},
		callback: function(records, operation, success) {
			if(addOrEdit=="edit"){
			sm.selectRows(selectArr);
			}
		}
	});

	var addButton = new Ext.Toolbar.Button({
		text:'ȷ��'
	});
			
	var jxUnitDrStr="";	
	var jxUnitDrStrl="";	
	//���尴ť��Ӧ����
	Handler = function(){
		var rowObj=grid.getSelections();
		var len = rowObj.length;
		var idStr="";
		var idStrl="";
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			for(var i=0;i<len;i++){
				name=rowObj[i].get("grouRowid");
				namel=rowObj[i].get("grouName");
				if(idStr==""){
					idStr=name;
					idStrl=namel;
				}else{
					idStr=idStr+","+name
					idStrl=idStrl+","+namel
				}
			}
			jxUnitDrStr=idStr;
			jxUnitDrStrl=idStrl;
			win.close();
		}
	}
		
	//��Ӵ�����
	var addHandler = function(){
		Handler();
		jxUnitDrStr = trim(jxUnitDrStr);
		jxUnitDrStrl = trim(jxUnitDrStrl);
		
		QMSchemField.setRawValue(jxUnitDrStrl);
		
      	QMSchemF=jxUnitDrStr;
      	//QMSchemFl=jxUnitDrStrl;
      	//alert(QMSchemF);
      	//alert(QMSchemFl);
      	//alert(QMSchemField);
	}	
		
	//��Ӱ�ť�ļ����¼�
	addButton.addListener('click',addHandler,false);
		
	//���岢��ʼ��ȡ���޸İ�ť
	var cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��'
	});
		
	//����ȡ���޸İ�ť����Ӧ����
	cancelHandler = function(){
		win.close();
	}
		
	//���ȡ����ť�ļ����¼�
	cancelButton.addListener('click',cancelHandler,false);
		
	var win = new Ext.Window({
		title:'�����Ŀ��Ϣ',
		width:460,
		height:300,
		minWidth: 460, 
		minHeight: 300,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:grid,
		buttons: [
			addButton,
			cancelButton
		]
	});

	//������ʾ
	win.show();
};