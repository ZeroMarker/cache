function CreateActivePanel(obj, ID, Desc){
	//alert(ID)
	//alert(Desc)
		Ext.MessageBox.wait('Loadng...........', '载入中，请等待');
    Ext.MessageBox.updateProgress(1);
    
    var QuestionPanel = new Ext.form.FormPanel({
        title: Desc,
        labelAlign : 'right',
        frame: true,
        autoScroll: true,
        id: "P" + ID,
        items: [],
        //  layout : 'border',
	      closable:true
    
    });


    QuestionPanel.on('show', function(v){Ext.MessageBox.hide();}, obj);
    
    var Type = ID.substring(0, 1)
    var CurID = ID.substring(1)
    if (Type == "T") {
        CreateTisPanel(obj, CurID, QuestionPanel, ID);
        return;
    }
    else 
        if (Type == "Q") {
			
			CreateQuestionPanel(obj, CurID,ID);
			 return;
        }
        else {
            CreateEvaluationPanel(obj, CurID, QuestionPanel, ID);
           return;
        }
    
}

function CreateTisPanel(obj, CurID, QuestionPanel, ID){
    var hiddenField = new Ext.form.Hidden({
        value: CurID
    });
   // alert(CurID);
    var tipsGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
        url: ExtToolSetting.RunQueryPageURL
    }));
    var tipsGridStore = new Ext.data.Store({
        proxy: tipsGridStoreProxy,
        reader: new Ext.data.JsonReader({
            root: 'record',
            totalProperty: 'total',
            idProperty: 'ID'
        }, [{
            name: 'checked',
            mapping: 'checked'
        }, {
            name: 'ID',
            mapping: 'ID'
        }, {
            name: 'MTCode',
            mapping: 'MTCode'
        }, {
            name: 'MTDesc',
            mapping: 'MTDesc'
        }, {
            name: 'MTDetail',
            mapping: 'MTDetail'
        }, {
            name: 'MTRemark',
            mapping: 'MTRemark'
        }, {
            name: 'MTActive',
            mapping: 'MTActive'
        }])
    });
    var tipsGridCheckCol = new Ext.grid.CheckColumn({
        header: '',
        dataIndex: 'checked',
        width: 50
    });
    var tipsGrid = new Ext.grid.GridPanel({
        store: tipsGridStore,
		buttonAlign: 'center',
        columns: [new Ext.grid.RowNumberer(), {
            header: '代码',
            width: 100,
            dataIndex: 'MTCode',
            sortable: true
        }, {
            header: '描述',
            width: 100,
            dataIndex: 'MTDesc',
            sortable: true
        }, {
            header: '提示内容',
            width: 100,
            dataIndex: 'MTDetail',
            sortable: true,
            renderer:function(v, c, record, row){
            	return "点击查看详情"
        }
        }, {
            header: '备注',
            width: 100,
            dataIndex: 'MTRemark',
            sortable: true
        }],
        bbar: new Ext.PagingToolbar({
            pageSize: 10,
            store: tipsGridStore,
            displayMsg: '显示记录： {0} - {1} 合计： {2}',
            displayInfo: true,
            emptyMsg: '没有记录'
        }),
        height:320
        //autoHeight: true
    });
    var selectMenu = new Ext.menu.Menu({
        items: [tipsGrid],
		width: 500
    });
    var MTDesc = new Ext.form.TriggerField({
        id: ID + 'MTDesc',
        fieldLabel: '添加结论',
        labelAlign : 'right',
        name: 'MTDesc',
        onSelect: function(record){
        
        },
        onTriggerClick: function(){
            if (this.menu == null) {
                this.menu = selectMenu;
            };
            this.menu.show(this.el, "tl-bl?");
            tipsGridStore.load({
                params: {
                    start: 0,
                    limit: 10
                }
            });
        }
    });
 
  //  QuestionPanel.add(MTDesc);
    /*
     var MTDetail = new Ext.form.TextArea({
     id : ID+'MTDetail'
     ,width : 500
     ,fieldLabel : '内容'
     ,name:'MTDetail'
     });
     QuestionPanel.add(MTDetail);
     */
    var GridPanel1StoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
        url: ExtToolSetting.RunQueryPageURL
    }));
    var myRecord = new Ext.data.Record.create([{
        name: 'checked',
        mapping: 'checked'
    }, {
        name: 'ID',
        mapping: 'ID'
    }, {
        name: 'QMTCMedicalTipsDR',
        mapping: 'QMTCMedicalTipsDR' 
    }, {
        name: 'QMTDesc',
        mapping: 'QMTDesc'
    }, {
        name: 'QMTDetail',
        mapping: 'QMTDetail'
    }, {
        name: 'QMTType',
        mapping: 'QMTType'
    }, {
        name: 'QMTRemark',
        mapping: 'QMTRemark'
    }, {
        name: 'QMTUpdateDate',
        mapping: 'QMTUpdateDate'
    }, {
        name: 'QMTUpdateTime',
        mapping: 'QMTUpdateTime'
    }, {
        name: 'QMTUpdateUsr',
        mapping: 'QMTUpdateUsr'
    }, {
        name: 'SSUSRName',
        mapping: 'SSUSRName'
    }])
    var GridPanel1Store = new Ext.data.Store({
        proxy: GridPanel1StoreProxy,
        reader: new Ext.data.JsonReader({
            root: 'record',
            totalProperty: 'total',
            idProperty: 'ID'
        }, myRecord)
    });
    var GridPanel1CheckCol = new Ext.grid.CheckColumn({
        header: '',
        dataIndex: 'checked',
        width: 50
    });
    //var GridPanel1 = new Ext.grid.EditorGridPanel({
var GridPanel1 = new Ext.grid.GridPanel({

        id: ID + 'GridPanel1',
        store: GridPanel1Store,
        //clicksToEdit: '1',
        buttonAlign: 'center',
        region : 'center',
        height: 320,
        width: 800,
        columns: [new Ext.grid.RowNumberer(), {
            header: 'OID',
            width: 100,
            dataIndex: 'ID',
            hidden: true
        }, {
            header: 'QMTCMedicalTipsDR',
            width: 100,
            dataIndex: 'QMTCMedicalTipsDR',
            hidden: true
        }, {
            header: '结论',
            width: 100,
            dataIndex: 'QMTDesc',
            sortable: true,
            editor: new Ext.grid.GridEditor(new Ext.form.TextField({
                allowBlank: false
            }))
        }, {
            header: '内容',
            width: 140,
            dataIndex: 'QMTDetail',
            sortable: true
             ,renderer: function(v, c, record, row){ return "点击查看详情" ;}
        }, {
            header: '类型',
            width: 40,
            dataIndex: 'QMTType',
            sortable: true
        },  {
            header: '删除',
            width: 50,
            dataIndex: 'TipsDelete',
            renderer: function(v, c, record, row){
              return "<input type='button' value='删除'>" ;                
            }
        }],
        bbar: new Ext.PagingToolbar({
            pageSize: 25,
            store: GridPanel1Store,
            displayMsg: '显示记录： {0} - {1} 合计： {2}',
            displayInfo: true,
            emptyMsg: '没有记录'
        })
    
    });
    tipsGrid.on('rowclick', function(grid, rowIndex, e){
    	theID.setValue("");theID1.setValue("");
        selectMenu.hide();
        var record = grid.getStore().getAt(rowIndex);
        var MedicalTipsDR = record.get('ID');
        var MTStore = GridPanel1.getStore();
		    var Flag=0;  //是否已经存在提示
        MTStore.each(function(MTRecord){
            var MTipsDR = MTRecord.get('QMTCMedicalTipsDR');
            if (MTipsDR == MedicalTipsDR) {
                Flag = 1
				        ExtTool.alert('重复提示','相同的提示已经存在，请核实');
                return false;
            }
        });
        if (Flag == 1) return;
        
        var Desc = record.get('MTDesc');
        var Detail = record.get('MTDetail');
        
       
        //-----cxr--------------------------------------------
        theMTDesc.setValue(Desc);
        theMTDetail.setValue(Detail);
        theID.setValue(record.get('ID'));
        //-----cxr--------------------------------------------
     /*
        var p = new myRecord({
            checked: '',
            ID: '',
            QMTCMedicalTipsDR: MedicalTipsDR,
            QMTDesc: '',
            QMTDetail: '',
            QMTType: 'B',
            QMTRemark: '',
            QMTUpdateDate: '',
            QMTUpdateTime: '',
            QMTUpdateUsr: '',
            SSUSRName: ''
        });
        GridPanel1.stopEditing();
         
        MTStore.insert(0, p);
        GridPanel1.startEditing(0, 0);
        GridPanel1.getView().refresh();
        MTStore.getAt(0).set("QMTDesc", Desc)
        MTStore.getAt(0).set("QMTDetail", Detail)
        */
        MTDesc.setValue("");
    });
    //alert(MTDesc.getValue());
    tipsGridStoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.OEvaluationRecord';
        param.QueryName = 'CMedicalTips';
        param.Arg1 = MTDesc.getValue();
        param.Arg2 = hiddenField.getValue();  //cxr
        param.ArgCnt = 2;                     //cxr
    });
   //alert(hiddenField.getValue());
    GridPanel1StoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.OEvaluationRecord';
        param.QueryName = 'MedicalTips';
        param.Arg1 = hiddenField.getValue();
		    param.ArgCnt = 1;
    });
    
    
    GridPanel1.on("cellclick", function(g,row,col,e)
    {  var fieldName = g.getColumnModel().getDataIndex(col);
        if (fieldName != 'TipsDelete') return;
    	Ext.MessageBox.confirm("提示","您确定要删除这些信息吗?", function(button,text){   
    		
if(button=='yes'){

//-----------------------------------
        var store=g.getStore()
        var record = store.getAt(row);
        var ID = record.get("ID");
		    if (ID==""){
			     store.removeAt(row);
			     record.set("QMTCMedicalTipsDR",""); //删除后清空CMedicalTipsID
			     //record.reject(true) ;
		
	     		return;
		    }
       	var rStr=obj.Method.DeleteTipsByID(ID);
		    var rArray=rStr.split("^");
		    var flag=rArray[0];
		    if (flag==0)
		    {
			    store.removeAt(row);
			    record.set("QMTCMedicalTipsDR","");
			     //record.reject(true) ;
			    GridPanel1.getView().refresh();
		    }else{
			    ExtTool.alert("提示", "保存错误" + rArray[1]);
		    }
		    
		        
			obj.Clear_click();//cxr清空 FORM 
   
 
         GridPanel1Store.load({params: {start: 0,limit: 25}});
   //---------------------------------------------------


}
}); 
     
    });
    // alert(GridPanel1Store.getCount() +"--"+hiddenField.getValue());    \
      GridPanel1Store.load({params: {start: 0,limit: 25}});
    //---cxr-----------------------------------
    var theID = new Ext.form.Hidden({
		id : ID +'theID'
		,fieldLabel :'QueID'
	
});
  var theID1 = new Ext.form.Hidden({
		id :ID + 'theID1'
		,fieldLabel :'ID'
	
});
    var theMTDesc = new Ext.form.TextField({
		id : ID +'theMTDesc'
		,fieldLabel :'描述'
	
});
    var theMTDetail = new Ext.form.HtmlEditor({
		id : ID +'theMTDetail'
		,width : 500
    ,height:280
		,fieldLabel : '内容'
    });
    
    var theFormPanel= new Ext.Panel({
		id :ID + 'theFormPanel'
	 ,region : 'center'
				,layout : 'border'
				,height:330
	  });
	  var thePanel1= new Ext.Panel({
		id :ID + 'thePanel1'
				,labelAlign : 'right'
		    ,layout : 'form'
				 ,region : 'west'
				 ,width:620
				,height:200
	  });
	  thePanel1.add(MTDesc);
	  thePanel1.add(theID);
	  thePanel1.add(theID1);
	  thePanel1.add(theMTDesc);
	  thePanel1.add(theMTDetail);
	  theFormPanel.add(thePanel1);
	  theFormPanel.add(GridPanel1);
	
	     
	
	  GridPanel1.on("rowclick", function(g,row,e){
	  	
	      var store=g.getStore();
        var record = store.getAt(row);
        var ID = record.get('ID');
   //     alert(record.get('QMTDetail'));
       theID1.setValue(ID);
        theID.setValue(record.get('QMTCMedicalTipsDR'));
        theMTDesc.setValue(record.get('QMTDesc'));
        theMTDetail.setValue(record.get('QMTDetail'));
        
       
       
  		return;
		});
    //---cxr--------------------------------------
   // QuestionPanel.add(GridPanel1);
     QuestionPanel.add(theFormPanel);
    
    obj.FormPanel3.add(QuestionPanel);
    obj.FormPanel3.setActiveTab("P" + ID);
}

function CreateQuestionPanel(obj, CurID,ID){
	
    var SubjectStr = obj.Method.GetQuestionInfoById(CurID);
    if (SubjectStr == ""){
		ExtTool.alert("提示", "问卷没有内容")
		return;
	}
        
    Ext.Ajax.request({
            url: 'dhchm.dhchm.createquestion.csp?CurID='+CurID+'&ID='+ID, //在csp中执行业务逻辑，write数据
            method: 'post',
            waitMsg: '加载中...',
            success: function(response, opts){
				
				//alert(response.value+"response")
				//alert(responseText+"responseText")
                //对接收到的数据就行处理
                var fn = new Function("test", response.responseText);
                var panel = fn();
                
                Ext.MessageBox.hide();  

		obj.FormPanel3.add(panel);

    		obj.FormPanel3.setActiveTab("P" + ID);
		
		
            },
            failure: function(response, opts){
                console.log('server-side failure with status code ' + response.status);
                Ext.MessageBox.hide();  
            },
            scope: this
        });
    
}

function CreateEvaluationPanel(obj, CurID, QuestionPanel, ID){

    var EvaluationInfo = obj.Method.GetOEvaluationInfo(CurID);
    var Char1 = String.fromCharCode(1);
    var EvaluationArr = EvaluationInfo.split(Char1);
    var EvaluationLength = EvaluationArr.length;
    var EvaluationPanel = new Ext.Panel({
        //frame:true,
        autoHeight: true,
        layout: 'column',
        id: ID
    });
    for (i = 0; i < EvaluationLength; i++) {
        var OneEvaluation = EvaluationArr[i];
        var OneEvaluationArr = OneEvaluation.split("^");
        var EvaluationID = OneEvaluationArr[0];
        var EvaluationDesc = OneEvaluationArr[1];
        var EvaluationType = OneEvaluationArr[2];
        var Source = OneEvaluationArr[3];
        var Value = OneEvaluationArr[4];
        if (EvaluationType == 'T') {
            Field = new Ext.form.TextField({
                emptyText: obj.InputInfo,
                fieldLabel: EvaluationDesc,
                id: ID + "^" + EvaluationID,
                name: ID + "^" + EvaluationID,
                //vtypeText:'请输入',
                value: Value
            });
        }
        else 
            if (EvaluationType == 'N') {
            	Value=Math.round(Value*100+0.5)/100;
                Field = new Ext.form.NumberField({
                    emptyText: obj.InputInfo,
                    fieldLabel: EvaluationDesc,
                    id: ID + "^" + EvaluationID,
                    name: ID + "^" + EvaluationID,
                    value: Value
                });
            }
            else 
                if (EvaluationType == 'D') {
                    Field = new Ext.form.DateField({
                        emptyText: obj.InputInfo,
                        fieldLabel: EvaluationDesc,
                        format: ExtToolSetting.DateFormatString,
                        id: ID + "^" + EvaluationID,
                        name: ID + "^" + EvaluationID,
                        value: Value
                    });
                }
                else {
                
                    if (Source != "") {
                        var SourceArr = Source.split(",")
                        var cls = SourceArr[0];
                        var met = SourceArr[1];
                        var arg = SourceArr[2];
                        Field = ExtTool.CreateCombo(id + "^" + EvaluationID, EvaluationDesc, false, cls, met, arg);
                        Field.setValue(Value);
						//Ext.apply(Field,{allowBlank:false});
                    }
                    else {
                        Field = null;
                    }
                }
        var FieldPanel = new Ext.Panel({
            layout: 'form',
            items: Field,
            id: "P" + ID + "^" + EvaluationID,
            columnWidth: obj.ElementNum
        })
        EvaluationPanel.add(FieldPanel);
    }
    QuestionPanel.add(EvaluationPanel);
    obj.FormPanel3.add(QuestionPanel);
    obj.FormPanel3.setActiveTab("P" + ID);
    
    
}
                                                 