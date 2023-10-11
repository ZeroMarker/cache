var Print=function(){
var projUrl="../csp/herp.acct.acctvouchprintexe.csp"
var Servletflag="";
var URL="";
 Ext.Ajax.request({
        url:'../csp/herp.acct.acctcashflowitemmainexe.csp?action=GetURL&acctbookid='+ acctbookid,
        method: 'GET',
        success: function(result, request) {
        var jsonData = Ext.util.JSON.decode( result.responseText );
        if (jsonData.success=='true'){
			URL= jsonData.info;	
		
			//alert(URL);
                  }
             }
			 
});


var editButton=new Ext.Toolbar.Button({
	text:'调整模板',
	tooltip:'调整模板参数',
	iconCls: 'option',
	handler:function(){
		//调用保存函数
		saveTemp('edit');
		
		}
	});
	
	var print=new Ext.Toolbar.Button({
	text:'打印',
	tooltip:'凭证打印',
	iconCls: 'print',
	handler:function(){
		//调用保存函数
		VouchPrint(itemGridp);
		editWin.close();
		
		}
	});
	
	var AddButton=new Ext.Toolbar.Button({
	text:'添加模板',
	tooltip:'添加模板',
	iconCls: 'add',
	handler:function(){
		//调用保存函数
		saveTemp('add');
		
		}
	});
 var itemGridp = new dhc.herp.Gridp({
            width: 750,
            height:430,
			region: 'center',
			url : projUrl,	
			atLoad:true, 
			//forceFit:true,
			readerModel:'remote',
			tbar:[AddButton,editButton,print],
			fields:[
			new Ext.grid.CheckboxSelectionModel({editable:false}),
			{
				id:'rowid',
				header:'<div style="text-align:center">rowid</div>',
				width:120,
				editable : false,
				align:'left',
				hidden:true, 
				dataIndex : 'rowid'
				},{
				id:'Code',
				header:'<div style="text-align:center">编码</div>',
				width:120,
				editable : false,
				align:'left',				 
				dataIndex : 'Code'
					},{
				id:'Name',
				header:'<div style="text-align:center">模板名称</div>',
				width:120,
				renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline"><a target="_blank" href="../scripts/herp/acct/PrintFile/'+value+'.xls">'+value+'</a></span>'	
						},   
				editable : false,
				align:'left',				 
				dataIndex : 'Name'		
						},{
				id:'Title',
				header:'<div style="text-align:center">凭证标题</div>',
				width:120,
				editable : false,
				align:'left',				 
				dataIndex : 'Title'			
							}]
			
 });
 
  itemGridp.load({
	    params:{
		    start:0,
		    limit:25
		    }
		    });	
	itemGridp .btnAddHide();
    itemGridp.btnSaveHide();
    itemGridp.btnResetHide();
    //itemGridp.btnDeleteHide();
    itemGridp.btnPrintHide();	    
		    
	var editWin=new Ext.Window({
	 title:'套打参数设置',
	 id:'editWin',
	 width : 800,
	 height : 500,
	 minWidth : 200,
	 minHeight : 150,
	 buttonAlign:'center',
	 plain : true,
	 modal : true,
	 items:itemGridp,
	 
	// renderTo : Ext.getBody(),
	 buttons:[{
	 	xtype:'button',
	 	text:'关闭',
	 	handler:function(){editWin.close();}
	 
	 }]
		/*
	 	{
	 	xtype:'button',
	 	text:'打印',
	 	//iconCls:'print',
	 	listeners:{
	 	click:{
	 	scope : this,
		fn : print,
		buffer : 200
	 	}
	 	}
	 	},
	 	{
	 	xtype:'button',
	 	text:'查看所选模板',
	 	listeners:{
	 	click:{
	 	scope : this,
	 	fn:open
	 	}
	 	}
	 	}]
	 */
	});
	 editWin.show();

	  

function saveTemp(flag){
   // alert(flag);
	 var name=new Ext.form.TextField({
	  fieldLabel:'模板名称',
	  id:'name',
	  //width:255,
	  columnWidth:.3,
	  emptyText:'请输入模板名称'  
	 	
	 });
	 
	 var Code=new Ext.form.TextField({
	  fieldLabel:'编码',
	  id:'Code',
	  //width:255,
	  columnWidth:.3,
	  emptyText:'请输入模板编码'  
	 	
	 });
	 
	 var RowData=new Ext.form.TextField({
	  fieldLabel:'每页显示数据行数',
	  id:'RowData',
	  //width:255,
	  columnWidth:.3,
	  emptyText:'请输入每页显示的数据行数'  
	 	
	 });
	 
	var columnData=new Ext.form.TextField({
	  fieldLabel:'每页显示数据列数',
	  id:'columnData',
	  //width:255,
	 // value:0,
	  columnWidth:.3,
	  emptyText:'请输入每页显示的数据列数'  
	 	
	 });
	 
	 var IfHasTitle = new Ext.form.Checkbox({

			//fieldLabel : '票据号',
			boxLabel : '是否打印表头',
			id : 'IfHasTitle',
			name : 'IfHasTitle',
			//checked:true,
			labelAlign : 'right'
		});
		
		var IfPrintLine = new Ext.form.Checkbox({

			//fieldLabel : '票据号',
			boxLabel : '是否打印边框',
			id : 'IfPrintLine',
			name : 'IfPrintLine',
			//checked:true,
			labelAlign : 'right'
		});
		
		 
	 var Title=new Ext.form.TextField({
	  fieldLabel:'标题',
	  id:'Title',
	  //width:255,
	  columnWidth:.3,
	  emptyText:'请输入标题显示内容'  
	 	
	 });
	 
	 	var NO1DS = new Ext.data.SimpleStore({
				fields : [ 'key', 'keyValue' ],
				data : [ [ 'Summary', '摘要' ], [ 'SubjName', '会计科目' ], [ 'AmtDebit', '借方金额' ],
						[ 'AmtCredit', '贷方金额' ] ,['VouchDate','凭证日期'],['VouchType','凭证类型']]
			});

			var NO1 = new Ext.form.ComboBox({
				id : 'NO1',
				fieldLabel : '第一列显示内容',
				width : 150,
				listWidth : 130,
				store : NO1DS,
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				mode : 'local', // 本地模式
				triggerAction : 'all',
				emptyText : '请选择...',
				columnWidth:.3,
				selectOnFocus : true,
				forceSelection : true

			});
			
		var NO2 = new Ext.form.ComboBox({
				id : 'NO2',
				fieldLabel : '第一列显示内容',
				width : 150,
				listWidth : 130,
				store : NO1DS,
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				mode : 'local', // 本地模式
				triggerAction : 'all',
				emptyText : '请选择...',
				columnWidth:.3,
				selectOnFocus : true,
				forceSelection : true

			});
   
			var NO3 = new Ext.form.ComboBox({
				id : 'NO3',
				fieldLabel : '第一列显示内容',
				width : 150,
				listWidth : 130,
				store : NO1DS,
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				mode : 'local', // 本地模式
				triggerAction : 'all',
				emptyText : '请选择...',
				columnWidth:.3,
				selectOnFocus : true,
				forceSelection : true

			});
		
			var NO4 = new Ext.form.ComboBox({
				id : 'NO4',
				fieldLabel : '第一列显示内容',
				width : 150,
				listWidth : 130,
				store : NO1DS,
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				mode : 'local', // 本地模式
				triggerAction : 'all',
				emptyText : '请选择...',
				columnWidth:.3,
				selectOnFocus : true,
				forceSelection : true

			});
			
			var NO5 = new Ext.form.ComboBox({
				id : 'NO5',
				fieldLabel : '第一列显示内容',
				width : 150,
				listWidth : 130,
				store : NO1DS,
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				mode : 'local', // 本地模式
				triggerAction : 'all',
				emptyText : '请选择...',
				columnWidth:.3,
				selectOnFocus : true,
				forceSelection : true

			});
			
			var NO6 = new Ext.form.ComboBox({
				id : 'NO6',
				fieldLabel : '第一列显示内容',
				width : 150,
				listWidth : 130,
				store : NO1DS,
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				mode : 'local', // 本地模式
				triggerAction : 'all',
				emptyText : '请选择...',
				columnWidth:.3,
				selectOnFocus : true,
				forceSelection : true

			});
			
			
	 var queryPanel = new Ext.form.FormPanel({
     		height : 400,
     		width : 510,
     		region : 'center',
     		frame : true,
     		//labelWidth : 80,
     		//style:'padding-top:15px',
     		defaults : {
     			bodyStyle : 'padding:5px;margin-top:5px;'
     		},
     		items:[
     		{
            columnWidth : 1,
            xtype : 'panel',
            layout:'column',
            items:[{
             xtype : 'displayfield',
                    value : '----------------------------------------模板信息设置----------------------------------------',
                    columnWidth : 1,
                    style:'padding-left:30px;line-height:20px;font-size:12px;align:"center"',
                    width:500
            }]
              },	
     				{
     		columnWidth : 1,
            xtype : 'panel',
             layout:'column',
     		items : [
     		{
                    xtype : 'displayfield',
                    value : ' ',
                    columnWidth : .05
                },{
                    xtype : 'displayfield',
                    value : '模板名称:',
                    columnWidth : .12
                },name,{
                    xtype : 'displayfield',
                    value : ' ',
                    columnWidth : .08
                },
                {
                    xtype : 'displayfield',
                    value : '模板编码:',
                    columnWidth : .12
                },Code]
     		},{
     		columnWidth : 1,
            xtype : 'panel',
            layout:'column',
     		items:[{
                    xtype : 'displayfield',
                    value : ' ',
                    columnWidth : .05
                },{
                    xtype : 'displayfield',
                    value : '数据行数:',
                    columnWidth : .12
                },RowData,{
                    xtype : 'displayfield',
                    value : ' ',
                    columnWidth : .08
                },
                {
                    xtype : 'displayfield',
                    value : '数据列数:',
                    columnWidth : .12
                },columnData]},
                {
               columnWidth : 1,
               xtype : 'panel',
               layout:'column',
               items:[{
                xtype : 'displayfield',
                value : ' ',
                columnWidth : .06
               },IfHasTitle,{
                xtype : 'displayfield',
                value : ' ',
                columnWidth : .06
               
               },IfPrintLine] },
           {
            columnWidth : 1,
            xtype : 'panel',
            layout:'column',
            items:[{
             xtype : 'displayfield',
                    value : '----------------------------------------打印内容设置----------------------------------------',
                    columnWidth : 1,
                    style:'padding-left:30px;line-height:20px;font-size:12px;align:"center"',
                    width:500
            }]
              },{
            columnWidth : 1,
            xtype : 'panel',
            layout:'column',
            items:[{
             xtype : 'displayfield',
             value : ' ',
             columnWidth : .3
            },{
             xtype : 'displayfield',
             value : '标题:',
             columnWidth : .12
            },Title]},{
            columnWidth : 1,
            xtype : 'panel',
            layout:'column',
            items:[{
             xtype : 'displayfield',
             value : ' ',
             columnWidth : .05
            },
            { xtype : 'displayfield',
              value : '第一列显示数据:',
              columnWidth : .12},
            NO1,{
            xtype : 'displayfield',
             value : ' ',
             columnWidth : .05
            },{
            xtype : 'displayfield',
            value : '第二列显示数据:',
            columnWidth : .12
            },NO2]},{
            columnWidth : 1,
            xtype : 'panel',
            layout:'column',
            items:[{
             xtype : 'displayfield',
             value : ' ',
             columnWidth : .05
            },
            { xtype : 'displayfield',
			  id:'NO3L',
              value : '第三列显示数据:',
              columnWidth : .12},
            NO3,{
            xtype : 'displayfield',
             value : ' ',
             columnWidth : .05
            },{
            xtype : 'displayfield',
            value : '第四列显示数据:',
            columnWidth : .12
            },NO4]},{
            columnWidth : 1,
            xtype : 'panel',
            layout:'column',
            items:[{
             xtype : 'displayfield',
             value : ' ',
             columnWidth : .05
            },
            { xtype : 'displayfield',
              value : '第五列显示数据:',
              columnWidth : .12},
            NO5,{
            xtype : 'displayfield',
             value : ' ',
             columnWidth : .05
            },{
            xtype : 'displayfield',
            value : '第六列显示数据:',
            columnWidth : .12
            },NO6]  } 
              ]
     	});
     	
	columnData.on('change',function(filed,newvalue,oldvalue,obj){
	 // alert(newvalue);
	 if(newvalue>6){
	   Ext.Msg.show({
	   title:'注意',
	   msg:'请输入小于7的数',
	   buttons : Ext.Msg.OK,
       icon : Ext.MessageBox.WARNING
	   });
	 	
	 }
	 if(newvalue==2){
	 NO1.enable();
	 NO2.enable();
	 NO3.disable();
	 // NO3.setVisible(false);
	
	 NO4.disable();
	 NO5.disable();
	 NO6.disable();
	 }else if(newvalue==3){
	  NO1.enable();
	 NO2.enable();
	 NO3.enable();
	 NO4.disable();
	 NO5.disable();
	 NO6.disable();
	 }else if(newvalue==4){
	 NO1.enable();
	 NO2.enable();
	 NO3.enable();
	 NO4.enable();
	 NO5.disable();
	 NO6.disable();
	 }else if(newvalue==5){
	 NO1.enable();
	 NO2.enable();
	 NO3.enable();
	 NO4.enable();
	 NO5.enable();
	 NO6.disable();
	 }else if(newvalue==6){
	 NO1.enable();
	 NO2.enable();
	 NO3.enable();
	 NO4.enable();
	 NO5.enable();
	 NO6.enable();
	 }
	
	});
	
	 var saveWin=new Ext.Window({
	  title:'设置套打模板',
	 id:'saveWin',
	 width : 520,
	 height : 500,
	 minWidth : 200,
	 minHeight : 150,
	 buttonAlign:'center',
	 plain : true,
	 modal : true,
	// layout:'table',
	 renderTo : Ext.getBody(),
	 items:[queryPanel],
	 buttons:[{xtype:'button',
	 text:'上一步',
	 handler:function(){saveWin.close();}
	 },
	 {xtype:'button',
	 text:'下一步',
	 listeners:{
	 click:{
	 	scope : this,
	 	fn:NextStep
	 	}
	 }
	 }
	 ]
	 });
	 var jsonData="";
	var rowid="";
	var Codet="";
	 if(flag=='edit'){
		var rowObj=itemGridp.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要调整的模板! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		} 
		  rowid=rowObj[0].get("rowid");
		  Codet=rowObj[0].get("Code");
	  
     Ext.Ajax.request({
        url:'../csp/herp.acct.acctvouchprintexe.csp?action=editinfo&rowid='+ rowid,
        method: 'GET',
        success: function(result, request) {
        jsonData = Ext.util.JSON.decode( result.responseText );
        if (jsonData.success=='true'){
			var rtndata= (jsonData.info);
           // alert(rtndata);			
			var data=rtndata.split("||");
			
		     Code.setValue(data[1]);
		     name.setValue(data[2]);
		     RowData.setValue(data[3]);
		     columnData.setValue(data[4]);
		     if(data[5]==1){
			    // alert("kk");
			     //IfHasTitle.checked=true;
				 document.getElementById('IfHasTitle').checked=true;
			     }
			  if(data[6]==1){
			     //IfPrintLine.checked=true;
				 document.getElementById('IfPrintLine').checked=true;
			     }
			   Title.setValue(data[7]);
			var columndata=data[8].split("#");
			//alert(columndata);
			for(var i=0;i<columndata.length;i++){
				//alert(columndata.length);
				var Column=columndata[i].split("^")[0];
				var Infodata=columndata[i].split("^")[1];
			 if(Column==1){
				 NO1.setValue(Infodata);
				 }else if(Column==2){
					 NO2.setValue(Infodata);
				 }else if(Column==3){
					 NO3.setValue(Infodata);
				 }else if(Column==4){
					 NO4.setValue(Infodata);
				 }else if(Column==5){
					 NO5.setValue(Infodata);
				 }else if(Column==6){
					 NO6.setValue(Infodata);
				 }					
			
				}
                  }
             }
			 
          });
		// alert(rowid+""+Code);
		 }
	 saveWin.show(); 
	 function NextStep(){
		// alert(jsonData.info);
	 	 var rownum=columnData.getValue();
	 	 //alert(rownum);
	 	var DirectionDS = new Ext.data.SimpleStore({
				fields : [ 'key', 'keyValue' ],
				data : [ [ '1', '纵向' ], [ '2', '横向' ]]
			});

			var Direction = new Ext.form.ComboBox({
				id : 'Direction',
				fieldLabel : '纸张方向',
				width : 150,
				listWidth : 130,
				store : DirectionDS,
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				mode : 'local', // 本地模式
				triggerAction : 'all',
				emptyText : '请选择...',
				columnWidth:.3,
				selectOnFocus : true,
				forceSelection : true

			});
	 	
			var PaperSizeDS = new Ext.data.SimpleStore({
				fields : [ 'key', 'keyValue' ],
				data : [ [ '8', 'A3' ], [ '9', 'A4' ], [ '11', 'A5' ], [ '12', 'B4' ]
				 , [ '13', 'B5' ], [ '29', 'Envelope C3' ],[ '30', 'Envelope C4' ],
				 [ '28', 'Envelope C5' ],[ '31', 'Envelope C6' ]]
			});

			var PaperSize = new Ext.form.ComboBox({
				id : 'PaperSize',
				fieldLabel : '纸张大小',
				width : 150,
				listWidth : 130,
				store : PaperSizeDS,
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				mode : 'local', // 本地模式
				triggerAction : 'all',
				emptyText : '请选择...',
				columnWidth:.3,
				selectOnFocus : true,
				forceSelection : true

			});
            
          var size1=new Ext.form.SpinnerField({
           fieldLabel: 'size1',
            name: 'size1',
            accelerate: true,
            incrementValue: 1.5,
            columnWidth:.25,
            disabled:false
       	    
          });
          
            var size2=new Ext.form.SpinnerField({
           fieldLabel: 'size2',
            name: 'size2',
            accelerate: true,
            columnWidth:.25,
            incrementValue: 1.5,
            disabled:false
       	    
          });
          
            var size3=new Ext.form.SpinnerField({
           fieldLabel: 'size3',
            name: 'size3',
            accelerate: true,
            columnWidth:.25,
            incrementValue: 1.5,
            disabled:false
       	    
          });
          
            var size4=new Ext.form.SpinnerField({
           fieldLabel: 'size4',
            name: 'size4',
            accelerate: true,
            incrementValue: 1.5,
            columnWidth:.25,
            disabled:false
       	    
          });
          
            var size5=new Ext.form.SpinnerField({
           fieldLabel: 'size5',
            name: 'size5',
            accelerate: true,
            columnWidth:.25,
            incrementValue: 1.5,
            disabled:false
       	    
          });
          
            var size6=new Ext.form.SpinnerField({
           fieldLabel: 'size6',
            name: 'size6',
            accelerate: true,
            incrementValue: 1.5,
            columnWidth:.25,
            disabled:false
       	    
          });
          
           var top=new Ext.form.SpinnerField({
           fieldLabel: 'top',
            name: 'top',
            accelerate: true,
            incrementValue: 0.5,
            columnWidth:.2,
            disabled:false
       	    
          });
          
            var left=new Ext.form.SpinnerField({
           fieldLabel: 'left',
            name: 'left',
            accelerate: true,
            incrementValue: 0.5,
            columnWidth:.2,
            disabled:false
       	    
          });
          
          var right=new Ext.form.SpinnerField({
           fieldLabel: 'right',
            name: 'right',
            accelerate: true,
            incrementValue: 0.5,
            columnWidth:.2,
            disabled:false
       	    
          });
          
          var bottom=new Ext.form.SpinnerField({
           fieldLabel: 'bottom',
            name: 'bottom',
            accelerate: true,
            incrementValue: 0.5,
            columnWidth:.2,
            disabled:false
       	    
          });
          
	 	 var PaperPanel = new Ext.form.FormPanel({
     		height : 400,
     		width : 510,
     		region : 'center',
     		frame : true,
     		//labelWidth : 80,
     		//style:'padding-top:15px',
     		defaults : {
     			bodyStyle : 'padding:5px;margin-top:5px;'
     		},
     		items:[
     		{
            columnWidth : 1,
            xtype : 'panel',
            layout:'column',
            items:[{
             xtype : 'displayfield',
                    value : '----------------------------------------打印格式设置----------------------------------------',
                    columnWidth : 1,
                    style:'padding-left:30px;line-height:20px;font-size:12px;align:"center"',
                    width:500
            }]
              },{
            columnWidth : 1,
            xtype : 'panel',
            layout:'column',  
            items:[{
            xtype : 'displayfield',
             value : ' ',
             columnWidth : .05
            },{
            xtype : 'displayfield',
            value : '纸张方向:',
            columnWidth : .12
            },Direction,{
             xtype : 'displayfield',
             value : ' ',
             columnWidth : .05
            },{
            xtype : 'displayfield',
            value : '纸张大小:',
            columnWidth : .12
            },PaperSize]},{
            columnWidth : 1,
            xtype : 'panel',
            layout:'column',
            items:[{
            xtype : 'displayfield',
             value : ' ',
             columnWidth : .05
            },{
            xtype : 'displayfield',
            value : '第一列宽:',
            columnWidth : .12
            },size1,{
             xtype : 'displayfield',
             value : '字符',
             columnWidth : .05
            },{
            xtype : 'displayfield',
             value : ' ',
             columnWidth : .05
            },{
            xtype : 'displayfield',
            value : '第二列宽:',
            columnWidth : .12
            },size2,{
             xtype : 'displayfield',
             value : '字符',
             columnWidth : .05
            }]},
           {
            columnWidth : 1,
            xtype : 'panel',
            layout:'column',
            items:[{
            xtype : 'displayfield',
             value : ' ',
             columnWidth : .05
            },{
            xtype : 'displayfield',
            value : '第三列宽:',
            columnWidth : .12
            },size3,{
             xtype : 'displayfield',
             value : '字符',
             columnWidth : .05
            },{
            xtype : 'displayfield',
             value : ' ',
             columnWidth : .05
            },{
            xtype : 'displayfield',
            value : '第四列宽:',
            columnWidth : .12
            },size4,{
             xtype : 'displayfield',
             value : '字符',
             columnWidth : .05
            }]},
            {
            columnWidth : 1,
            xtype : 'panel',
            layout:'column',
            items:[{
            xtype : 'displayfield',
             value : ' ',
             columnWidth : .05
            },{
            xtype : 'displayfield',
            value : '第五列宽:',
            columnWidth : .12
            },size5,{
             xtype : 'displayfield',
             value : '字符',
             columnWidth : .05
            },{
            xtype : 'displayfield',
             value : ' ',
             columnWidth : .05
            },{
            xtype : 'displayfield',
            value : '第六列宽:',
            columnWidth : .12
            },size6,{
             xtype : 'displayfield',
             value : '字符',
             columnWidth : .05
            }]},{
            columnWidth : 1,
            xtype : 'panel',
            layout:'column',
            items:[{
            xtype : 'displayfield',
             value : '页边距设置',
             columnWidth : 1,
             style:'font-size:12px;'
            }]
            },{
            columnWidth : 1,
            xtype : 'panel',
            layout:'column',
            items:[{
            xtype : 'displayfield',
             value : '',
             columnWidth : .33
            },{
            
            xtype : 'displayfield',
             value : '上边距',
             columnWidth : .1
            },top,{
             xtype : 'displayfield',
             value : '厘米',
             columnWidth : .05
            }]
            },{
            columnWidth : 1,
            xtype : 'panel',
            layout:'column',
            items:[{
            xtype : 'displayfield',
             value : '',
             columnWidth : .05
            },
       	{
            xtype : 'displayfield',
             value : '左边距',
             columnWidth : .1
            },left,{
            xtype : 'displayfield',
             value : '厘米',
             columnWidth : .05
            },{
            xtype : 'displayfield',
             value : ' ',
             columnWidth : .2
            },{
            xtype : 'displayfield',
            value : '右边距',
            columnWidth : .1
            },right,{
            xtype : 'displayfield',
             value : '厘米',
             columnWidth : .05
            }]},{
            
            columnWidth : 1,
            xtype : 'panel',
            layout:'column',
            items:[{
            xtype : 'displayfield',
             value : '',
             columnWidth : .33
            },{
            
            xtype : 'displayfield',
             value : '下边距',
             columnWidth : .1
            },bottom,{
             xtype : 'displayfield',
             value : '厘米',
             columnWidth : .05
            }]
            
            }
            
     		]
	 	 });
     		
     		
  var PaperWin=new Ext.Window({
	 title:'设置套打模板',
	 id:'PaperWin',
	 width : 520,
	 height : 500,
	 minWidth : 200,
	 minHeight : 150,
	 buttonAlign:'center',
	 plain : true,
	 modal : true,
	// layout:'table',
	 //renderTo : Ext.getBody(),
	 items:PaperPanel,
	 buttons:[{
	  xtype:'button',
	  text:'上一步', 
	  handler:function(){
		  PaperWin.close();
	  }
		 
	 },{
	  xtype:'button',
	  text:'保存模板',
	  type:'submit',
	  listeners:{
	  click:{
	 	scope : this,
	 	fn:save
	 	}
	 }
	 
	 }]
	 });
	 //alert(flag);
 if(flag=='edit'){  
   var rtn= jsonData.info;
   var data=rtn.split("||");
   Direction.setValue(data[9]);
   PaperSize.setValue(data[10]);
 
   var columnWidth=data[11].split("#");
			//alert(columnWidth);
			  
			for(var i=0;i<columnWidth.length;i++){
				var Column=columnWidth[i].split("^")[0];
				var Infodata=columnWidth[i].split("^")[1];
			 if(Column==1){
				 size1.setValue(Infodata);
				 }else if(Column==2){
					 size2.setValue(Infodata);
				 }else if(Column==3){
					 size3.setValue(Infodata);
				 }else if(Column==4){
					 size4.setValue(Infodata);
				 }else if(Column==5){
					 size5.setValue(Infodata);
				 }else if(Column==6){
					 size6.setValue(Infodata);
				 }					
			
				}
      var Dist=data[12].split("#");
         for(var i=0;i<Dist.length;i++){
				var Column=Dist[i].split("^")[0];
				var Infodata=Dist[i].split("^")[1];
			 if(Column==1){
				  top.setValue(Infodata);
				 }else if(Column==2){
					 right.setValue(Infodata);
				 }else if(Column==3){
					 bottom.setValue(Infodata);
				 }else if(Column==4){
					 left.setValue(Infodata);
				 }
		 }
 }
 // alert(data);
 PaperWin.show();	 
  if(rownum==2){
  size1.enable();
  size2.enable();
  size3.disable();
  size4.disable();
  size5.disable();
  size6.disable();
  }else if(rownum==3){
  size1.enable();
  size2.enable();
  size3.enable();
  size4.disable();
  size5.disable();
  size6.disable();
  }else if(rownum==4){
  size1.enable();
  size2.enable();
  size3.enable();
  size4.enable();
  size5.disable();
  size6.disable();
  
  }else if(rownum==5){
  size1.enable();
  size2.enable();
  size3.enable();
  size4.enable();
  size5.enable();
  size6.disable();
  }else if(rownum==6){
  size1.enable();
  size2.enable();
  size3.enable();
  size4.enable();
  size5.enable();
  size6.enable();
  
  }
  
  
   function save(){
   var TepName=encodeURIComponent(name.getValue());
   var TemCode=encodeURIComponent(Code.getValue());
   var RowNum=RowData.getValue();
   var columnNum=columnData.getValue();
   var ifPrintTitle=IfHasTitle.getValue();
   var ifLine=IfPrintLine.getValue();
   var title=encodeURIComponent(Title.getValue());
   var Row1=NO1.getValue();
   var Row2=NO2.getValue();
   var Row3=NO3.getValue();
   var Row4=NO4.getValue();
   var Row5=NO5.getValue();
   var Row6=NO6.getValue();
   
   var PaperDir=Direction.getValue();
   var paperSize=PaperSize.getValue();
   var CouSize1=size1.getValue();
   var CouSize2=size2.getValue();
   var CouSize3=size3.getValue();
   var CouSize4=size4.getValue();
   var CouSize5=size5.getValue(); 
   var CouSize6=size6.getValue(); 
   
   var topDis=top.getValue(); 
   var leftDis=left.getValue();
   var rightDis=right.getValue();
   var bottomDis=bottom.getValue();

   var ColumnData="1^"+Row1+"#"+"2^"+Row2+"#"+"3^"+Row3+"#"+"4^"+Row4+"#"+"5^"+Row5+"#"+"6^"+Row6;
   var ColumnWidth="1^"+CouSize1+"#2^"+CouSize2+"#3^"+CouSize3+"#4^"+CouSize4+"#5^"+CouSize5+"#6^"+CouSize6;
   var Distence="1^"+topDis+"#2^"+rightDis+"#3^"+bottomDis+"#4^"+leftDis;
   // alert(ColumnData);
   var actiond="";
   var str="";
   if(flag=='add'){
	   actiond="saveTemp";
	   }else if(flag=='edit'){
		 actiond="editTemp"; 
         str="&rowid="+rowid;		 
		   }
		 //  alert(str);
   Ext.Ajax.request({
		url:'../csp/herp.acct.acctvouchprintexe.csp?action='+actiond+'&TepName='+TepName+"&TemCode="+TemCode+"&RowNum="+RowNum+"&columnNum="
		+columnNum+"&ifPrintTitle="+ifPrintTitle+"&ifLine="+ifLine+"&title="+title+"&ColumnData="+ColumnData+"&PaperDir="+PaperDir+"&paperSize="+paperSize
		+"&ColumnWidth="+ColumnWidth+"&Distence="+Distence+str,
	   method : 'GET',					
	   failure: function(result, request){
									
		Ext.Msg.show({
		title:'错误',msg: '请检查网络连接! ',
		buttons: Ext.Msg.OK,
		icon : Ext.MessageBox.ERROR});
			},
		success: function(result, request){
		Servletflag=1;
		//alert(Servletflag);
		var jsonData = Ext.util.JSON.decode( result.responseText );
		//alert(jsonData);
		if(jsonData.success=='true'){
		Ext.Msg.show({
		title:'提示',msg: '保存成功  ',
		buttons: Ext.Msg.OK,
		icon : Ext.MessageBox.INFO});
		
		if (jsonData.refresh == 'true') {
	   	itemGridp.load({
	    params:{
		    start:0,
		    limit:25
		    }
		    });	
			}
		if(Servletflag==1){Servlet();}	
		saveWin.close();
		PaperWin.close();
	 
		 
     
		}else {
			
		 if(jsonData.info=="RepCode"){
		Ext.Msg.show({
		title:'提示',msg: '输入的编码已存在! ',
		buttons: Ext.Msg.OK,
		icon : Ext.MessageBox.WARNING});
		 	
		 }else if(jsonData.info=="RepName"){
		 Ext.Msg.show({
		title:'提示',msg: '输入的名称已存在! ',
		buttons: Ext.Msg.OK,
		icon : Ext.MessageBox.WARNING});
		 	
		 }else {
		 Ext.Msg.show({
		title:'提示',msg: '保存失败! ',
		buttons: Ext.Msg.OK,
		icon : Ext.MessageBox.ERROR});
		 	
		 };
		 
		 
		 }
		
		}
		});
	

	
// var Servlet=function(){
	
	// Ext.Ajax.request({   
       // url:'http://'+URL+'/herpAcctVouchPrint/VouchPrintServlet',
	   // dataType:'JSONP',
       // params:{
        // Code:TemCode
        // },
        // success: function(resp,opts) {
                            // alert("ssss");
                     // },
        // failure: function(resp,opts) {
                         
                             // Ext.Msg.alert('错误', 'lsjdfl');
                      // }  
      
       // });
// };		
//alert(Servletflag+" "+TemCode +URL);	

	var Servlet=function(){
		var upUrl="http://"+URL+"/herpAcctVouchPrint/VouchPrintServlet?Code="+TemCode;
				PaperPanel.getForm().submit({
					url:upUrl,
					method:'POST'
					//waitMsg:'数据导入中, 请稍等...',
					
				});		
	}
	
	};
  
	 };
	};

};