

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
					Ext.Msg.show({title:'错误',msg:'名称不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
	 Ext.Msg.show({title:'注意',msg:'导入成功！',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
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
			fieldLabel: '机构',
			width:150,
			listWidth : 230,
			allowBlank: false,
			store: orgaDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			emptyText : '请选择机构...',
			name: 'orgField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
	    	editable:true
});
//
*/





//文件名称
var excelUpload = new Ext.form.TextField({   
	id:'excelUpload', 
	name:'Excel',   
	anchor:'90%',   
	height:20,   
	inputType:'file',
	fieldLabel:'文件选择'
});
//数据项目选择
var upLoadFieldSet = new Ext.form.FieldSet({
	title:'文件选择',
	labelSeparator:'：',
	items:[excelUpload]
});
var importButton = new Ext.Toolbar.Button({
					text : '导入',
					tooltip : '导入',
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
		    
			title : '添加',
			width : 400,
			height : 350,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [{		 
				text : '保存',
				handler : function() {
					if (formPanel.form.isValid()) {
					//orgdr, copydr, code, name, desc, range, stop, date
					//var orgdr = orgdrField.getValue();
				
					//alert(mydata);
					//var copydr = copyField.getValue();
				
					//var mydata="lala,啦啦一号,01,撒地方,01,撒地方,阿斯蒂芬,0,1,1,2099-12-31";
					var myurl='dhc.bonus.module.bonusexpendcollectexe.csp?action=excel&mydata='+encodeURIComponent(mydata);

					Ext.Ajax.request({
					url:myurl,
					waitMsg:'保存中...',
					failure: function(result, request){	
						//alert("failure"+alert(result.responseText));	
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						//alert("success"+result.responseText);
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGrid.load({params:{start:0, limit:25}});
						}
						else
						{
							var message="重复添加";
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text : '取消',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
