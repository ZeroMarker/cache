

excelindexdictimport = function() {
var mydata=new Array();
function ReadExcel()
{
     //var mydata=new Array();
     var filePath= excelUpload.getValue();
    
     var oXL = new ActiveXObject("Excel.application"); 
     var oWB = oXL.Workbooks.open(filePath);
     oWB.worksheets(1).select(); 
     var oSheet = oWB.ActiveSheet;
     try{
      for(var i=2;;i++)
      {
      			if (oSheet.Cells(i, 1).value == null)
				break;
				var base=new Array();
 				var deptcode = oSheet.Cells(i, 1).value;
				var deptname = oSheet.Cells(i, 2).value;
				var year = oSheet.Cells(i, 3).value;
				var period = oSheet.Cells(i, 4).value;
				var icode = oSheet.Cells(i, 5).value;
				var iname = oSheet.Cells(i, 6).value;
				var ivalue = oSheet.Cells(i, 7).value;
				var collectdate = oSheet.Cells(i, 8).value; 
				var operator = oSheet.Cells(i, 9).value;
				var checkdate = oSheet.Cells(i, 10).value;
				var checkman = oSheet.Cells(i, 11).value;
				var state = oSheet.Cells(i, 12).value; 
				if (name==null){
					Ext.Msg.show({title:'����',msg:'���Ʋ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					break;
				}
				// else if (range=0){} else{}
				//code,name,attr,desc,range,fcode,fdesc,period,industry,stop,date
				base.push(deptcode);
				base.push(deptname);
				base.push(year);
				base.push(period);
				base.push(icode);
				base.push(iname);
				base.push(ivalue);
				base.push(collectdate);
				base.push(operator);
				base.push(checkdate);
				base.push(checkman);
				base.push(state);
				mydata.push(base);
			

      }
     }catch(e)
     {
         // document.all.txtArea.value = tempStr;
     } 
    // document.all.txtArea.value = tempStr;
     //alert("mydata"+mydata);
	 Ext.Msg.show({title:'ע��',msg:'����ɹ���',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
     oXL.Quit();
     CollectGarbage();
}
/*
var orgaDs = new Ext.data.Store({
	      autoLoad:true,
	      proxy : "",
	      reader : new Ext.data.JsonReader({
	                 totalProperty : 'results',
	                 root : 'rows'
	              }, ['rowid','name'])
     });


orgaDs.on('beforeload', function(ds, o){
	     ds.proxy=new Ext.data.HttpProxy({
	               url: 'dhc.bonus.module.bonusexpendcollectexe.csp'
	                     +'?action=getWorkItem&str='
	                     + encodeURIComponent(Ext.getCmp('orgdrField').getRawValue()),
	               method:'POST'
	              });
     });

var orgdrField = new Ext.form.ComboBox({
			id: 'orgdrField',
			fieldLabel: '����',
			width:150,
			listWidth : 230,
			allowBlank: false,
			store: orgaDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			emptyText : '��ѡ�����...',
			name: 'orgField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
	    	editable:true
});
//
*/





//�ļ�����
var excelUpload = new Ext.form.TextField({   
	id:'excelUpload', 
	name:'Excel',   
	anchor:'90%',   
	height:20,   
	inputType:'file',
	fieldLabel:'�ļ�ѡ��'
});
//������Ŀѡ��
var upLoadFieldSet = new Ext.form.FieldSet({
	title:'�ļ�ѡ��',
	labelSeparator:'��',
	items:[excelUpload]
});
var importButton = new Ext.Toolbar.Button({
					text : '����',
					tooltip : '����',
					iconCls : 'option',
					handler : function() {
						ReadExcel();
					}
				});
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [ upLoadFieldSet,upLoadFieldSet,importButton]
		});
	
	var addWin = new Ext.Window({
		    
			title : '���',
			width : 400,
			height : 350,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [{		 
				text : '����',
				handler : function() {
					if (formPanel.form.isValid()) {
					//orgdr, copydr, code, name, desc, range, stop, date
					//var orgdr = orgdrField.getValue();
				
					//alert(mydata);
					//var copydr = copyField.getValue();
				
					//var mydata="lala,����һ��,01,���ط�,01,���ط�,��˹�ٷ�,0,1,1,2099-12-31";
					var myurl='dhc.bonus.module.bonusexpendcollectexe.csp?action=excel&mydata='+encodeURIComponent(mydata);

					Ext.Ajax.request({
					url:myurl,
					waitMsg:'������...',
					failure: function(result, request){	
						//alert("failure"+alert(result.responseText));	
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						//alert("success"+result.responseText);
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGrid.load({params:{start:0, limit:25}});
						}
						else
						{
							var message="�ظ����";
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text : 'ȡ��',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
