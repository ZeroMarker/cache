Ext.onReady(function(){
	
    Ext.QuickTips.init();
    
    var myData = [['3m Co', 71.72, 0.02, 0.03, '9/1 12:00am'], ['Alcoa Inc', 29.01, 0.42, 1.47, '9/1 12:00am'], ['Altria Group Inc', 83.81, 0.28, 0.34, '9/1 12:00am'], ['American Express Company', 52.55, 0.01, 0.02, '9/1 12:00am'], ['American International Group, Inc.', 64.13, 0.31, 0.49, '9/1 12:00am'], ['AT&T Inc.', 31.61, -0.48, -1.54, '9/1 12:00am'], ['Boeing Co.', 75.43, 0.53, 0.71, '9/1 12:00am'], ['Caterpillar Inc.', 67.27, 0.92, 1.39, '9/1 12:00am'], ['Citigroup, Inc.', 49.37, 0.02, 0.04, '9/1 12:00am'], ['E.I. du Pont de Nemours and Company', 40.48, 0.51, 1.28, '9/1 12:00am'], ['Exxon Mobil Corp', 68.1, -0.43, -0.64, '9/1 12:00am'], ['General Electric Company', 34.14, -0.08, -0.23, '9/1 12:00am'], ['General Motors Corporation', 30.27, 1.09, 3.74, '9/1 12:00am'], ['Hewlett-Packard Co.', 36.53, -0.03, -0.08, '9/1 12:00am'], ['Honeywell Intl Inc', 38.77, 0.05, 0.13, '9/1 12:00am'], ['Intel Corporation', 19.88, 0.31, 1.58, '9/1 12:00am'], ['International Business Machines', 81.41, 0.44, 0.54, '9/1 12:00am'], ['Johnson & Johnson', 64.72, 0.06, 0.09, '9/1 12:00am'], ['JP Morgan & Chase & Co', 45.73, 0.07, 0.15, '9/1 12:00am'], ['McDonald\'s Corporation', 36.76, 0.86, 2.40, '9/1 12:00am'], ['Merck & Co., Inc.', 40.96, 0.41, 1.01, '9/1 12:00am'], ['Microsoft Corporation', 25.84, 0.14, 0.54, '9/1 12:00am'], ['Pfizer Inc', 27.96, 0.4, 1.45, '9/1 12:00am'], ['The Coca-Cola Company', 45.07, 0.26, 0.58, '9/1 12:00am'], ['The Home Depot, Inc.', 34.64, 0.35, 1.02, '9/1 12:00am'], ['The Procter & Gamble Company', 61.91, 0.01, 0.02, '9/1 12:00am'], ['United Technologies Corporation', 63.26, 0.55, 0.88, '9/1 12:00am'], ['Verizon Communications', 35.57, 0.39, 1.11, '9/1 12:00am'], ['Wal-Mart Stores, Inc.', 45.45, 0.73, 1.63, '9/1 12:00am']];
    // create the data store
    var store = new Ext.data.Store({
        proxy: new Ext.data.PagingMemoryProxy(myData),
        
        // the return will be XML, so lets set up a reader
        reader: new Ext.data.ArrayReader({}, [{
            name: 'company'
        }, {
            name: 'price',
            type: 'float'
        }, {
            name: 'change',
            type: 'float'
        }, {
            name: 'pctChange',
            type: 'float'
        }, {
            name: 'lastChange',
            type: 'date',
            dateFormat: 'n/j h:ia'
        }])
    });
    // example of custom renderer function
    function change(val){
        if (val > 0) {
            return '<span style="color:green;">' + val + '</span>';
        }
        else 
            if (val < 0) {
                return '<span style="color:red;">' + val + '</span>';
            }
        return val;
    }
    
    // example of custom renderer function
    function pctChange(val){
        if (val > 0) {
            return '<span style="color:green;">' + val + '%</span>';
        }
        else 
            if (val < 0) {
                return '<span style="color:red;">' + val + '%</span>';
            }
        return val;
    }
    //取消原来点击选择行{handleMouseDown:Ext.emptyFn}
    var sm = new Ext.grid.CheckboxSelectionModel({
        handleMouseDown: Ext.emptyFn
    });
    var cm = new Ext.grid.ColumnModel([{
        id: 'company',
        header: "Company",
        width: 160,
        sortable: true,
        dataIndex: 'company'
    }, sm, {
        header: "Price",
        width: 75,
        sortable: true,
        renderer: 'usMoney',
        dataIndex: 'price'
    }, {
        header: "Change",
        width: 75,
        sortable: true,
        dataIndex: 'change',
        renderer: change
    }, {
        header: "% Change",
        width: 75,
        sortable: true,
        dataIndex: 'pctChange',
        renderer: pctChange
    }, {
        header: "Last Updated",
        width: 85,
        sortable: true,
        renderer: new Ext.util.Format.dateRenderer('y年m月d日'),
        dataIndex: 'lastChange'
    }]);
    // create the Grid
    var grid = new Ext.grid.GridPanel({
        store: store,
        cm: cm,
        sm: sm,
        stripeRows: true,
        autoExpandColumn: 'company',
        height: 550,
        width: 800,
        title: 'Array Grid',
        bbar: new Ext.PagingToolbar({
            pageSize: 10,
            store: store,
            displayInfo: true
        })
    });
    store.load({
        params: {
            start: 0,
            limit: 10
        }
    });
    
    var text = new Ext.form.TextField({
        id: 'text',
        fieldLabel: '代码',
        allowBlank: false,
        emptyText: '请输入代码',
        //anchor:'90%',
        width: 190,
        name: 'Hosp_Code'
    
    });
    var time = new Ext.form.TimeField({
        fieldLabel: '时间',
        name: 'time',
        width: 190,
        minValue: '8:00am',
        maxValue: '6:00pm'
    });
    var date = new Ext.form.DateField({
        fieldLabel: '日期',
        name: 'dob',
        width: 190,
        allowBlank: 'false'
    });
    var Hospital = [['1', '001', '友谊医院'], ['2', '002', '安贞医院'], ['3', '003', '复兴医院'], ['4', '004', '地坛医院']];
    var siStore = new Ext.data.SimpleStore({
        fields: ['RowID', 'Code', 'Name'],
        data: Hospital
    });
    var combo = new Ext.form.ComboBox({
        fieldLabel: '医院',
        store: siStore,
        valueField: 'Code',
        displayField: 'Name',
        mode: 'local',
        typeAhead: true,
        triggerAction: 'all',
        emptyText: '请选择医院',
        allowBlank: false,
        name: 'Name',
        width: 190,
        //anchor:'90%',
        forceSelection: true
    });
    
    var remoteStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: 'simple_from.xml',
            method: 'GET'
        }),
        reader: new Ext.data.XmlReader({
            totalRecords: 'results',
            record: 'row',
            id: 'WLSTAT_Rowid'
        }, [{
            name: 'The_Author',
            mapping: 'Author'
        }, {
            name: 'Manufacturer'
        }, {
            name: 'ProductGroup'
        }, {
            name: 'Title'
        }])
    });
    var remoteCombo = new Ext.form.ComboBox({
        fieldLabel: '名称',
        store: remoteStore,
        valueField: 'The_Author',
        displayField: 'Title',
        //mode:'local',
        typeAhead: true,
        triggerAction: 'all',
        emptyText: '请选择',
        allowBlank: false,
        name: 'Name1',
        //anchor:'90%',
        width: 190,
        forceSelection: true
    
    });
    
    
    var htmlEdit = new Ext.form.HtmlEditor({
        fieldLabel: 'html编辑器',
        height: 200,
        anchor: '80%'
    });
    var form = new Ext.FormPanel({
        labelWidth: 75,
        url: 'aa.csp',
        frame: true,
        title: 'Form',
        bodystyle: 'padding:5px 5px 0',
        width: 700,
        items: [text, time, date, combo, remoteCombo, htmlEdit],
        buttons: [{
            text: '保存'
        }, {
            text: '取消'
        }]
    });
    
    
    //confirm
    var confirmLabel = new Ext.form.Label({
        html: '<p>The example shows how to use the MessageBox class. Some of the buttons have animations, some are normal.<br><b>Confirm</b><br>Standard Yes/No dialog.</p>'
    });
    var confirmButton = new Ext.Button({
        text: 'confirm',
		minWidth:100,
        handler: function(){
            var result = Ext.MessageBox.confirm('Confirm', 'Are you sure you want to do that?', ReturnFn);
            
        }
    });
    var ReturnFn = function(o){
		Ext.MessageBox.alert('Return Info', "aaaaaa" + o);
		return
        if (o == 'yes') {
            Ext.MessageBox.alert('Return Info', "aaaaaa" + o);
        }
        else {
            Ext.MessageBox.alert('Return Info', "bbbbbbb" + o);
        }
    };
    
    //singleline prompt
    var promptLabel = new Ext.form.Label({
        html: '<p><b>Prompt</b><br>Standard prompt dialog.</p>'
    });
    var promptButton = new Ext.Button({
        text: 'prompt',
		minWidth:100,
        handler: function(){
            var promptRValue = Ext.MessageBox.prompt("prompt", "please input value:", promptRFN, "", false, "plase input value");
        }
    });
    var promptRFN = function(id, value){
        Ext.MessageBox.alert("promptReturn", id + "^" + value);
    };
    
    //multi prompt
    var multiPromptLabel = new Ext.form.Label({
        html: '<b>Multi-line Prompt</b><br>A multi-line prompt dialog.'
    });
    var multiPromptButton = new Ext.Button({
        text: 'multiPrompt',
		minWidth:100,
        handler: function(){
            Ext.MessageBox.show({
                title: 'Address',
                msg: 'Please enter your address:',
                width: 300,
                buttons: Ext.MessageBox.OKCANCEL,
                multiline: true,
                fn: promptRFN,
				value:'please in put'
            });
        }
    });
	
	// Yes/No/Cancel

	var yesNoLabel=new Ext.form.Label({
		html:'<b>Yes/No/Cancel</b><br>Standard Yes/No/Cancel dialog.'
	});
	var yesNoCancelButton=new Ext.Button({
		text:'yesNoCancel',
		minWidth:100,
		handler: function(){
			Ext.MessageBox.show({
				title: 'Save Changes',
				msg: 'You are closing a tab that has unsaved changes. <br />Would you like to save your changes?',
				buttons:Ext.MessageBox.YESNOCANCEL,
				fn:ReturnFn,
				icon:Ext.MessageBox.QUESTION
			});
		}
	});
	//Progress Dialog
	var progressLabel=new Ext.form.Label({
		html:'<b>Progress Dialog</b><br>Dialog with measured progress bar.'
	});
	var progressButton=new Ext.Button({
		text:'Progress Dialog',
		minWidth:100,
		handler:function(){
			Ext.MessageBox.show({
				title:'Progress Dialog',
				msg:'load Files',
				progressText:'Initializing...',
				progress:true,
				closable:false,
				width:300
			});
			// this hideous block creates the bogus progress
	       var f = function(v){
	            return function(){
	                if(v == 12){
	                    Ext.MessageBox.hide();
						
						//Other Code
						
	                }else{
	                    var i = v/11;
	                    Ext.MessageBox.updateProgress(i, Math.round(100*i)+'% completed');
	                }
	           };
	       };
	       for(var i = 1; i < 13; i++){
	           setTimeout(f(i), i*500);
	       }
		}
		
	});
	//wait dialog
	var waitLabel=new Ext.form.Label({
		html:'<b>Wait Dialog</b><br>Dialog with indefinite progress bar and custom icon (will close after 8 sec).'
	});
	var waitButton=new Ext.Button({
		text:'Wait Dialog',
		minWidth:100,
		handler:function(){
			Ext.MessageBox.show({
	           msg: 'Saving your data, please wait...',
	           progressText: 'Saving...',
	           width:300,
	           wait:true,
	           //animEl: 'mb7',
			   //icon:'ext-mb-download', //custom class in msg-box.html 
			   waitConfig: {interval:200}
	          
	           
	       });
		   setTimeout(function(){
            //This simulates a long-running operation like a database save or XHR call.
            //In real code, this would be in a callback function.
            Ext.MessageBox.hide();}, 8000);
		}
	});
	//alert dialog
	var alertLabel=new Ext.form.Label({
		html:'<b>Alert</b><br>Standard alert message dialog.'
	});
	var alertButton=new Ext.Button({
		text:'Alert Dialog',
		minWidth:100,
		handler:function(){
			Ext.MessageBox.alert('Status', 'Changes saved successfully.', ReturnFn);
		}
	})
	
    var formMsg = new Ext.FormPanel({
        labelWidth: 75,
        frame: true,
        title: 'MessageBox Dialogs',
        bodystyle: 'padding:5px 5px 0',
        width: 700,
        height: 800,
        items: [confirmLabel, confirmButton, promptLabel, promptButton, multiPromptLabel, multiPromptButton,yesNoLabel,yesNoCancelButton,progressLabel,progressButton,waitLabel,waitButton,alertLabel,alertButton]
    });
	//LayOut
	var layoutPanel=new Ext.FormPanel({
		title:'LayOut',
		layout:'border',
            items:[
                {
					region:'north',
                    split:true,
                    height: 50,
                    collapsible: true,
                    title:'North'
					
                },{
                    region:'south',
                    split:true,
                    height: 100,
                    minSize: 100,
                    maxSize: 200,
                    collapsible: true,
                    title:'South',
                    margins:'0 0 0 0'
                }, {
                    region:'east',
                    title: 'East Side',
                    collapsible: true,
                    split:true,
                    width: 225,
                    minSize: 175,
                    maxSize: 400,
                    layout:'fit',
                    margins:'0 5 0 0',
                    items:
                        new Ext.TabPanel({
                            border:false,
                            activeTab:1,
                            //tabPosition:'bottom',
							tabPosition:'top',
                            items:[{
                                html:'<p>A TabPanel component can be a region.</p>',
                                title: 'A Tab',
                                autoScroll:true
                            },{
								html: '<p>B TabPanel component can be a region.</p>',
								title: 'B Tab',
								autoScroll: true
							}
							]
                        })
                 },{
                    region:'west',
                    id:'west-panel',
                    title:'West',
                    split:true,
                    width: 200,
                    minSize: 175,
                    maxSize: 400,
                    collapsible: true,
                    margins:'0 0 0 5',
                    layout:'accordion',
                    layoutConfig:{
                        animate:true
                    },
                    items: [{
                        title:'Settings',
                        html:'<p>Some settings in here.</p>',
                        border:false
                    },{title:'Other Settings',
					html:'<p>哈哈</p>',
					border:false,
					href:'http://www.google.cn/ig/china?hl=zh-CN'}
					
					
					
					]
                },
                new Ext.TabPanel({
                    region:'center',
                    deferredRender:false,
                    activeTab:0,
                    items:[{
                        title:'Settings',
                        html:'<p>Some settings in here.</p>'
                    }]
                })
             ]
	});
	/*
	//Menu
	var menu=new Ext.menu.Menu({
		id:'mainMenu',
		items:[
			new Ext.menu.CheckItem({
				text:'I like Ext',
				checked:true,
				handler:checkHandler
			}),
			new Ext.menu.CheckItem({
				text:'Ext for JQuery',
				checked:true,
				handler:checkHandler
			}),{
				text: 'I donated!',
                checked:false,
                checkHandler: checkHandler
			},'-',{
				text:'radio Options',
				menu:{
					items:[
					'<b class="menu-title">Choose a Theme</b>',
					{
						text:'Aero Glass',
						checked:true,
						group:'theme',
						checkHandler:checkHandler
					},{
						text:'Vista Black',
						checked:false,
						group:'theme',
						checkHandler:checkHandler
					},{
						text: 'Gray Theme',
                        checked: false,
                        group: 'theme',
                        checkHandler: checkHandler
					},{
						text: 'Default Theme',
                        checked: false,
                        group: 'theme',
                        checkHandler: checkHandler
					}
					
					]
				}
			},{
				text:'chosse a date',
				iconCls: 'calendar',
				menu:dateMenu
			},{
				text:'choose a color',
				menu: colorMenu
			}
			
		]
	});
	var dateMenu=new Ext.menu.DateMenu({
		handler:function(dp,date){
			Ext.MessageBox.alert("DateSelect",date.format('M j, Y'));
		}
	});
	var colorMenu=new Ext.menu.ColorMenu({
		handler:function(dp,color){Ext.MessageBox.alert("DateSelect",color);}
	});
	function checkHandler() {
	    alert('Clicked on a menu item');
	}
	
	var tb = new Ext.Toolbar();

	
    tb.add({
            text:'Button w/ Menu',
            menu: menu  
        });

    tb.add('-', {
        text: 'Quick Tips',
        tooltip: '<b>Quick Tips</b><br/>Icon only button with tooltip'
    }, '-');
    
	*/
	//tree
	var json = [{"text":"分层套一",   
		   "id":"10\/1",   
		   "cls":"cmp",   
		   "leaf":false,   
		   "children":[{"text":"工资",   
		                "id":"10\/1\/favoris",   
		                "cls":"cmp",   
		                "leaf":false,   
		                "children":[{"text":"基本工资",   
		                              "id":"10\/1\/favoris\/idFiche",   
		                              "cls":"cmp",   
		                              "leaf":true  
		                            },   
		                            {"text":"津贴",   
		                              "id":"10\/1\/favoris\/sousDossier",   
		                              "cls":"cmp",   
		                              "leaf":false,    
		                              "children":[{"text":"奖金",   
		                                           "id":"10\/1\/favoris\/idFiche",   
		                                           "cls":"cmp",   
		                                           "leaf":true}]   
		                            }]   
		                },   
		                {"text":"电费",   
		                  "id":"10\/1\/poubelle",   
		                  "cls":"cmp",   
		                  "allowDrop":true,   
		                  "leaf":true
		                },   
		                {"text":"水费",   
		                  "id":"10\/1\/poubellewater",   
		                  "cls":"cmp",   
		                  "allowDrop":true,   
		                  "leaf":true}   
		                ]   
				},
				{"text":"分层套二",   
		                  "id":"10\/2",   
		                  "cls":"cmp",   
		                  "allowDrop":true,   
		                  "leaf":true}
		];
		
		var tree = new Ext.tree.TreePanel({
		title:'树结构',
        autoScroll:true,
        animate:true,
        enableDD:true,
        containerScroll: true, 
        loader: new Ext.tree.TreeLoader()
    });
		// set the root node
    var root = new Ext.tree.AsyncTreeNode({
        text: 'Ext JS',
        draggable:false,
        id:'source',
        children: json // JSON
    });
    tree.setRootNode(root);
	
	//Tabs
    var tabs = new Ext.TabPanel({
        region: 'center',
        activeTab: 1,
		//items:tb萎
        items: [formMsg, form, grid,layoutPanel,tree]
    });
    //root.expand();
	
    //显示
    var viewport = new Ext.Viewport({
        layout: 'border',
        items: tabs
    });
    //date.setWidth(300,true);
	date.highlight();
	
});
