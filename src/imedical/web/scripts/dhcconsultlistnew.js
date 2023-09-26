 var FINDConSultDoc_URL="dhcconsultrequest.csp?requestType=GetConSultDoc"
 var Doclistcombo=new Ext.data.ArrayStore({
			    id:"getDocList",
				fields: ['Docrowid','DocDesc'],
				baseParams: {act: 'GetDoclist'},
				url: "dhcconsultrequest.csp"			
			});
var DocListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));			
var DocListStore = new Ext.data.Store({
		proxy: DocListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctcpId'
		}, 
		[
			{name: 'ctcpDesc', mapping : 'ctcpDesc'}
			,{name: 'ctcpId', mapping: 'ctcpId'}
		])
	});
var ConSultItmLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var ConSultItmLocStore = new Ext.data.Store({
		proxy: ConSultItmLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ItmLocID'
		}, 
		[
			{name: 'ItmLocID', mapping : 'ItmLocID'}
			,{name: 'ItmLocDesc', mapping: 'ItmLocDesc'}
		])
	});	
 var comboData = [
        ['D','主任医师'],
        ['A','副主任医师'],
        ['C','主治医师'],
		['P','医师'],
		['E','住院医师']
    ];
var DocGradstore=new Ext.data.SimpleStore({
                fields:['disvalue','distext'],
                data: comboData
            });
var PatName = new Ext.form.TextField({
		id : 'PatName' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '姓名' 
	});
var PatSex = new Ext.form.TextField({
		id : 'PatSex' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '性别' 
	});
var PatAge = new Ext.form.TextField({
		id : 'PatAge' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '年龄' 
	});
var BedCode = new Ext.form.TextField({
		id : 'BedCode' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '床号' 
	});
var PatRegNo = new Ext.form.TextField({
		id : 'PatRegNo' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '病人ID' 
	});
var PatMedNo = new Ext.form.TextField({
		id : 'PatMedNo' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '住院号' 
	});
var PatWard = new Ext.form.TextField({
		id : 'PatWard' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '病房' 
	});
var PatDiag = new Ext.form.TextField({
		id : 'PatDiag' 
		,width : 900
		,anchor : '100%'
		,fieldLabel : '诊断' 
	});
//简要病历及会诊目的
var ConDestination = new Ext.form.TextArea({
		id : 'ConDestination' 
		,xtype: "textarea"
		,labelWidth: 60
        ,width: 230
		,anchor : '100%'
		,fieldLabel : '病情摘要' 
	});
//会诊目的、需解决的问题
var ConDestinationtwo = new Ext.form.TextArea({
		id : 'ConDestinationtwo' 
		,xtype: "textarea"
		,labelWidth: 60
        ,width: 230
		,anchor : '100%'
		,fieldLabel : '会诊目的、需解决的问题' 
	});
var pConditionChild1=new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .15
		,layout:'form'
		,items:[PatName]
	});
var pConditionChild2=new Ext.Panel({
		id : 'pConditionChild2'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .15
		,layout:'form'
		,items:[PatSex]
	});
var pConditionChild3=new Ext.Panel({
		id : 'pConditionChild3'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .15
		,layout:'form'
		,items:[PatAge]
	});
var pConditionChild4=new Ext.Panel({
		id : 'pConditionChild4'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .15
		,layout:'form'
		,items:[BedCode]
	});
var pConditionChild5=new Ext.Panel({
		id : 'pConditionChild5'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .15
		,layout:'form'
		,items:[PatRegNo]
	});
var pConditionChild6=new Ext.Panel({
		id : 'pConditionChild6'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .15
		,layout:'form'
		,items:[PatMedNo]
	});
var pConditionChild7=new Ext.Panel({
		id : 'pConditionChild7'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .15
		,layout:'form'
		,items:[PatWard]
	});
var pConditionChild8=new Ext.Panel({
		id : 'pConditionChild8'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .85
		,layout:'form'
		,items:[PatDiag]
	});
var pConditionChild9=new Ext.Panel({
		id : 'pConditionChild9'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .85
		,layout:'form'
		,items:[ConDestination]
	});	
var pConditionChild10=new Ext.Panel({
		id : 'pConditionChild10'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .85
		,layout:'form'
		,items:[ConDestinationtwo]
	});	
var pFieldSet1 = new Ext.form.FieldSet({
		id : 'pFieldSet1'
		,title : '病人基本信息'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,boxMinHeight : 100
		,height:230
		,layout : 'column'
		,border:true
		,frame:true
		,anchor:'100%'
		//,labelWidth:65 //label的宽度,此属性将会遗传到子容器。
		,items : [
		         pConditionChild1,
				 pConditionChild2,
				 pConditionChild3,
				 pConditionChild4,
				 pConditionChild5,
				 pConditionChild6,
				 pConditionChild7,
				 pConditionChild8,
				 pConditionChild9,
				  pConditionChild10
				]
	});

	
//*********************************************************************会诊申请信息
//增加按钮
var btnAdd = new Ext.Button({
		id : 'btnAdd'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 60
		,text : '添加'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
//审核按钮
var btnSend = new Ext.Button({
		id : 'btnSend'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		//,width : 80
		,text : '确认'
		,icon:'../images/uiimages/ok.png'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
//拒绝按钮
var btnRefuse = new Ext.Button({
		id : 'btnRefuse'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		//,width : 80
		,text : '拒绝'
		,icon:'../images/uiimages/undo.png'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
	
	//完成按钮
var btnEnd = new Ext.Button({
		id : 'btnEnd'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		//,width : 80		
		,text : '会诊完成'
		,icon:'../images/uiimages/permission.png'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
//申请医生
var PatDoc = new Ext.form.TextField({
		id : 'PatDoc' 
		,width : 100
		,anchor : 'anchor%'
		,fieldLabel : '申请医生' 
	});	
//会诊地点
var ConPlace = new Ext.form.TextField({
		id : 'ConPlace' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '会诊地点' 
	});	
//会诊时间
var ConTime=new Ext.form.TextField({
		id : 'ConTime' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '会诊时间' 
	});
var MoreLoc = new Ext.form.Checkbox(
	                    {  
                        boxLabel  : '多科',  
                        name      : 'MoreLoc',  
                        inputValue: '1',  
                        id        : 'MoreLoc'      // checked:'true'						
                        }  
	);		
var ConType_data = [['C', '普通'],['E','急' ],['M', '多科']];    //会诊类别
var ConType_store=new Ext.data.SimpleStore({ fields: ['value', 'text'], data: ConType_data });

var InOut_data=[['I', '院内'],['O','院外' ]];   //院内院外
var InOut_store=new Ext.data.SimpleStore({ fields: ['value', 'text'], data: InOut_data });

var AppDate=new Ext.form.DateField(
	            {
                    xtype: 'datefield',
                    fieldLabel: '申请日期',
					id:'AppDate',
					width:80,
					format:'Y-m-d',
					value:new Date(),
                    name: 'date',
					anchor:'100%'
                }
	);	
var AppTime=new Ext.form.TextField({
		id : 'AppTime' 
		,width : 100
		,anchor : '80%'
		,fieldLabel : '时间' 
	});
///会诊类别
var  ConType=new Ext.form.ComboBox({		  
			  xtype: "combo",
			         id:"ConType",
                     fieldLabel: "类别",
                     mode:"local", //直接定义写成local
                     triggerAction: 'all', //加载所有项
                     editable: false,
                     emptyText: "",
                     store: ConType_store,
                     displayField: 'text',//
					 valueField:'value'
                 });
var InOut=new Ext.form.ComboBox({		  
			  xtype: "combo",
			         id:"InOut",
                     fieldLabel: "院内院外",
                     mode:"local", //直接定义写成local
                     triggerAction: 'all', //加载所有项
                     editable: false,
                     emptyText: "",
                     store: InOut_store,
                     displayField: 'text',//
					 valueField:'value'
                 });
var ConsultDepStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var ConsultDepStore = new Ext.data.Store({
		proxy: ConsultDepStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
var ConsultDep = new Ext.form.ComboBox({
		id : 'ConsultDep'
		,width : 100
		,minChars : 1 //在自动完成和typeAhead 激活之前，用户必须输入的最少字符数
		,selectOnFocus : true //true 将会在获得焦点时理解选中表单项中所有存在的文本。 仅当editable = true 时应用(默认为false)。 
		,forceSelection : true //true 将会限定选择的值是列表中的值之一， false将会允许用户向表单项中设置任意值 (默认为false) 
		,store : ConsultDepStore
		,displayField : 'CTLocDesc'
		,fieldLabel : '会诊科室'
		,editable : true //false将阻止用户直接向表单项中输入文本，表单项将仅仅响应 在触发按钮上进行鼠标点击然后设置值。(默认为true)。 
		,triggerAction : 'all'  //当触发器被点击时需要执行的操作。
		,anchor : '100%'
		,valueField : 'CTLocID'
	});				 
ConsultDepStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCBedManager';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = ConsultDep.getRawValue();
			param.Arg2 = 'E';
			param.Arg3 = "";
			param.Arg4 = "";   //CTHos.getValue();
			param.ArgCnt = 4;
	});	
	
//申请日期
var pConditionChild20=new Ext.Panel({
		id : 'pConditionChild20'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .15
		,layout:'form'
		,items:[AppDate]
	});
//申请时间
var pConditionChild21=new Ext.Panel({
		id : 'pConditionChild21'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .2
		,layout:'form'
		,items:[AppTime]
	});
//会诊类别
var pConditionChild22=new Ext.Panel({
		id : 'pConditionChild22'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .25
		,layout:'form'
		,items:[ConType]
	});
//院内院外
var pConditionChild28=new Ext.Panel({
		id : 'pConditionChild28'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .25
		,layout:'form'
		,items:[InOut]
	});	
	
//申请医生
var  pConditionChild23=new Ext.Panel({
		id : 'pConditionChild23'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .25
		,layout:'form'
		,items:[PatDoc]
	});	
var  pConditionChild31=new Ext.Panel({
		id : 'pConditionChild31'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .2
		,layout:'form'
		,items:[ConPlace]
	});	
var  pConditionChild32=new Ext.Panel({
		id : 'pConditionChild32'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .2
		,layout:'form'
		,items:[ConTime]
	});	

//会诊科室
var  pConditionChild24=new Ext.Panel({
		id : 'pConditionChild24'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .2
		,layout:'form'
		,items:[ConsultDep]
	});	
//多科
var  pConditionChild26=new Ext.Panel({
		id : 'pConditionChild26'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:50
		,columnWidth : .25
		,layout:'form'
		,items:[MoreLoc]
	});	
//添加按钮 ---医务科不添加科室 ---屏蔽
var  pConditionChild25=new Ext.Panel({
		id : 'pConditionChild25'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:50
		,columnWidth : .15
		,layout:'form'
		,items:[btnAdd]
	});	
//医务科 审核 按钮
var  pConditionChild27=new Ext.Panel({
		id : 'pConditionChild27'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .10
		,layout:'form'
		,items:[btnSend]
	});	
//医务科 完成会诊 按钮
var  pConditionChild29=new Ext.Panel({
		id : 'pConditionChild29'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .15
		,layout:'column'
		,items:[btnEnd]
	});	
//医务科 拒绝申请 按钮
var  pConditionChild30=new Ext.Panel({
		id : 'pConditionChild30'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .15
		,layout:'column'
		,items:[btnRefuse]
	});	
//************************************************************************************************gridpanel

  
var gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	var gridResultStore = new Ext.data.Store({
		id: 'gridResultStoretore',
		proxy: gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ConsultAppID'
		}, 
		[
		    {name: 'ConsultLocID', mapping : 'ConsultLocID'}
			,{name: 'ConsultLoc', mapping : 'ConsultLoc'}
			,{name: 'ConsultItmLoc', mapping : 'ConsultItmLoc'}
			,{name: 'ConSultDoc', mapping: 'ConSultDoc'}
			,{name: 'ConSultDocGrade', mapping: 'ConSultDocGrade'}
			,{name: 'ConSultDocName', mapping: 'ConSultDocName'}
		])
	});
	var rowItemRecord = Ext.data.Record.create([
         {name: 'ConsultLocID', mapping : 'ConsultLocID'}
		,{name: 'ConsultLoc', mapping : 'ConsultLoc'}
		,{name: 'ConsultItmLoc', mapping : 'ConsultItmLoc'}
		,{name: 'ConSultDoc', mapping: 'ConSultDoc'}
		,{name: 'ConSultDocGrade', mapping: 'ConSultDocGrade'}
		,{name: 'ConSultDocName', mapping: 'ConSultDocName'}
    ]); 
	
	var gridResult = new Ext.grid.EditorGridPanel({
		id : 'gridResult'
		,store : gridResultStore
		,region : 'center'
		,clicksToEdit:1  //表示单击一次就可编辑，默认是双击才可编辑
		,buttonAlign : 'center'
		,height: 290
		,tbar: new Ext.Toolbar(['-', {  
                text: '添加会诊科室', 
				icon:'../images/uiimages/edit_add.png',
                handler: function() {  
					 //alert("hhah");
					 var rec = new rowItemRecord({  //实例化Record对象，并赋予各字段初始值
						'ConsultLocID': '',
						'ConsultLoc': '',
						'ConsultItmLoc': '',
						'ConSultDoc': '',
						'ConSultDocGrade': ''
					});
                     gridResult.stopEditing();  
                     gridResultStore.insert(gridResultStore.getCount() , rec);   
                     gridResult.startEditing(0, 0);  //激活该行的编辑状态  
                }  
            }, '-', {  
                text: '删除会诊科室',  
				id:'deleteLocBtn',
				icon:'../images/uiimages/edit_remove.png',
                handler: function() {  
                    Ext.Msg.confirm('信息', '确定要删除', function(btn) {  
                        if(btn == 'yes') {  
                            var sm = gridResult.getSelectionModel(); //得到表格的选择模型  
                            var cell = sm.getSelectedCell(); //通过选择模型得到选择的单元格						
							var record = gridResultStore.getAt(cell[0]); //得到store对应的Record  
								if(record.data.ConSultSubId){
								var ret = tkMakeServerCall("web.DHCConsultNew","deleteLoc",record.data.ConSultSubId);
								if(ret==1){
									gridResultStore.remove(record);
								}else{
									return;
								}
							}else{
								gridResultStore.remove(record);
							}						
                        }  
                    })  
                }  
            }])  
		,loadMask : { msg : '正在读取数据,请稍后...'} //一个 Ext.LoadMask 配置，或者为true以便在加载时遮罩grid。 默认为 false .
		//,plugins: expCtrlDetail //一个对象或者一个对象数组，为组件提供特殊的功能。 对一个合法的插件唯一的要求是它含有一个init()方法， 能接收一个Ext.Component型的参数。当组件被创建时，如果有可用的插件，组件将会调用每个插件的init方法，并将自身的引用作为方法参数传递给它。然后，每个插件就可以调用方法或者响应组件上的事件，就像需要的那样提供自己的功能。 
		,columns: [
			/*new Ext.grid.RowNumberer({header:"床号"	,width:60})*/
			{header: '科室id', width: 0, dataIndex: 'ConsultLocID', sortable: true,hidden:true}
			,{header: '科室', width: 150, dataIndex: 'ConsultLoc', sortable: true,hidden:true}
			,{header: '会诊科室', width: 250, dataIndex: 'ConsultItmLoc', sortable: false,
			
			editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({
            id: 'ItmCTLoc', 
			width: 250,
			store: ConSultItmLocStore, 
			minChars: 1, 
			displayField: 'ItmLocDesc',
			editable: true, triggerAction: 'all', 
			anchor: '100%',
			valueField: 'ItmLocID',
            autoSelect: true,
            forceSelection: true,
            invalidText: "请点击选择有效科室！", 
			listeners: {
				'beforequery': function (e) {
					var cell = gridResult.getSelectionModel().getSelectedCell();
					var id = gridResultStore.getAt(cell[0]).get('ConsultLocID'); //获取改行科室id，用于combobox查询
					var content = this.getRawValue();
					//alert(id+"#"+content)
					ConSultItmLocStoreProxy.on('beforeload', function (objProxy, param) {
						param.ClassName = 'web.DHCConsultNew';
						param.QueryName = 'GetListItemLoc';
						param.Arg1 = id;
						param.Arg2 = content;
						param.ArgCnt = 2;
					})
					ConSultItmLocStore.load({});
				},
				'focus':function(e){
					var cell = gridResult.getSelectionModel().getSelectedCell();
					var ConsultItmLoc = gridResultStore.getAt(cell[0]);//.get('ConsultItmLoc');
					//console.log(ConsultItmLoc.data.ConsultLoc);
					var ItmCTLoc = Ext.getCmp('ItmCTLoc');
					ItmCTLoc.setRawValue(ConsultItmLoc.data.ConsultLoc);
				}
				

			}
    })),renderer: GetConSultItmDep 
			
			
			}
			, {

				header: '要求会诊医生',
				width: 250,
				dataIndex: 'ConSultDoc',
				sortable: false,
				editor: new Ext.grid.GridEditor(new Ext.form.ComboBox({
						id: 'CTDoc',
						width: 250,
						store: DocListStore,
						minChars: 1,
						displayField: 'ctcpDesc',
						editable: true,
						triggerAction: 'all',
						anchor: '100%',
						valueField: 'ctcpId',
						listeners: {
							'beforequery': function (e) {

								//************
								//var id="";

								var cell = gridResult.getSelectionModel().getSelectedCell();

								var id = gridResultStore.getAt(cell[0]).get('ConsultLocID');
								//alert(id);
								//获取改行科室id，用于combobox查询
								//var thiscontent=gridResult.getStore().getAt(cell[0]).get('ConSultDoc');
								//alert(thiscontent)
								var ItmLocId = gridResultStore.getAt(cell[0]).get('ConsultItmLoc'); ///子科室id

								var gg = this.getRawValue();
								DocListStoreProxy.on('beforeload', function (objProxy, param) {

									param.ClassName = 'web.DHCConsultNew';
									param.QueryName = 'GetDocListByLoc';
									param.Arg1 = ItmLocId;
									param.Arg2 = gg;
									param.Arg3 = ItmLocId;
									param.ArgCnt = 3;
								})
								DocListStore.load({});
							},
							'select':function(e){
								var selectDoc=this.value;
								if(admdoc==selectDoc){
									alert("不允许选择病人主管医生！");
									this.clearValue();
									return;
								}
							},
							'focus': function (e) {
								var cell = gridResult.getSelectionModel().getSelectedCell();
								var ConsultItmLoc = gridResultStore.getAt(cell[0]); 	
								var CTDoc = Ext.getCmp('CTDoc');
								CTDoc.setRawValue(ConsultItmLoc.data.ConSultDocName);
								CTDoc.fireEvent('beforequery',this);
							}
						}
					})),
				renderer: GetConSultDoc
			},
			{
			header: '医师级别', 
			dataIndex:'ConSultDocGrade',
			width: 150,
			sortable: true,
			hidden:true,
			editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({
			id:'ConDocGrade',
            store:DocGradstore ,
            emptyText: '请选择',
            mode: 'local',
            triggerAction: 'all',
            valueField: 'disvalue', //disvalue 待研究
            displayField: 'distext',
            readOnly:false
			})),renderer: function(disvalue, cellmeta, record1)   
                     {  
                         //通过匹配value取得ds索引  
                         var index = DocGradstore.find(Ext.getCmp('ConDocGrade').valueField,disvalue);  
                         //通过索引取得记录ds中的记录集  
                         var record1 = DocGradstore.getAt(index);  
                         //返回记录集中的value字段的值  
                         var disvalue = "";  
                         if (record1)   
                         {  
                             disvalue = record1.data.distext;  
                         }  
						 
                         return disvalue;//注意这个地方的value是上面displayField中的value  
                      } 
			}
			
		],bbar: new Ext.PagingToolbar({
			pageSize : 1000,
			store : gridResultStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: ''
		})
	});
//*****************************************************************************************************
var pFieldSet2 = new Ext.form.FieldSet({
		id : 'pFieldSet1'
		,title : '申请信息'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,boxMinHeight : 100
		,height:100
		,layout : 'column'
		,border:true
		,frame:true
		,anchor:'100%'
		//,labelWidth:65 //label的宽度,此属性将会遗传到子容器。
		,items : [
		         pConditionChild23,
				 pConditionChild20,
				 pConditionChild21,
				 pConditionChild22,
				 pConditionChild28,
				 pConditionChild31,
				 pConditionChild32,
				 //pConditionChild24,
				 //pConditionChild25,
				 pConditionChild27,
				 pConditionChild29,
				 pConditionChild30
				]
	});	
/*/************
		   //var id="";
		   gridResult.on("cellclick",function(g,r,e) {
						var id=g.getStore().getAt(r).get("ConsultLocID");
						//alert(id)
						//*****
						DocListStoreProxy.on('beforeload', function(objProxy, param){
						//alert(this.getStore())
			param.ClassName = 'web.DHCConsultNew';
			param.QueryName = 'GetDocListByLoc';
			param.Arg1 = id;
			param.Arg2=g.getStore().getAt(r).get("ConSultDoc");
			param.ArgCnt = 2;})
						})
		   //*********************
		   */
var ConditionPanel = new Ext.form.FormPanel({
		id : 'ConditionPanel',
		buttonAlign : 'center', //添加到当前panel的所有 buttons 的对齐方式。 
		labelAlign : 'right', //该容器中可用的文本对齐值，合法值有 "left", "top" 和 "right" (默认为 "left").
		labelWidth : 60,
		bodyBorder : false,
		border : false,
		layout : 'form',
		region : 'center',
		frame : true,
		anchor:'100%',
		title : '病人信息',
		items : [
			pFieldSet1
			
		]
	});	
	
var ConditionPanel2 = new Ext.form.FormPanel({
		id : 'ConditionPanel2',
		buttonAlign : 'center', //添加到当前panel的所有 buttons 的对齐方式。 
		labelAlign : 'right', //该容器中可用的文本对齐值，合法值有 "left", "top" 和 "right" (默认为 "left").
		labelWidth : 60,
		bodyBorder : false,
		border : false,
		layout : 'form',
		region : 'center',
		frame : true,
		anchor:'100%',
		title : '申请信息',
		items : [
			pFieldSet2
			
		]
	});	
var pnScreen = new Ext.Panel({
		id : 'pnScreen'
		,buttonAlign : 'center'
		,frame : true
		,layout : 'form'
		,items:[
		
			ConditionPanel,
			ConditionPanel2,
			gridResult
		]
	});
/*医务科不允许删除会诊申请的相关信息  ---屏蔽
//***********************
var contextmenu =new Ext.menu.Menu({
        id: 'theContextMenu',
        items: [{
            text: '删除',
			id: 'DeleteHandle',
            handler:DeleteHandle
        }
		]
    });
grid=Ext.getCmp("gridResult");
grid.on("rowcontextmenu", function(grid1, rowIndex, e){
//debugger
        e.preventDefault();
        //grid1.getSelectionModel().selectRow(rowIndex);
        contextmenu.showAt(e.getXY());
    });	
//************************
*/
var init=function(){
new Ext.Viewport({
		id : 'viewScreen'
		,frame : true
		,layout : 'fit'
		,items:[
			pnScreen
			
		]
	}),
Ext.get('btnSend').on("click",btnSend_onclick);
Ext.get('btnEnd').on("click",btnEnd_onclick);
Ext.get('btnRefuse').on("click",btnRefuse_onclick);
//Ext.get('btnAdd').on("click",btnAdd_onclick);
AddConsultPlace()
AddPatinfo()
	
Ifhiddenelement()
}
Ext.onReady(init);
function Ifhiddenelement()
{
	var ret=tkMakeServerCall("web.DHCConsultNew","Ifhiddenelement",rowid);
	if ((ret=="W")||(ret=="V"))
	{
	document.getElementById('btnEnd').style.display="none";   ///隐藏完成按钮
	}
	if (ret=="E")
	{
	//document.getElementById('btnAdd').style.display="none";   ///隐藏添加按钮
	document.getElementById('btnSend').style.display="none";   ///隐藏确认按钮
	document.getElementById('btnRefuse').style.display="none";   ///隐藏拒绝按钮
	gridResult.getTopToolbar().hide(); ///隐藏删除会诊科室工具条
	// document.getElementById('deleteLocBtn').style.display="none";   ///隐藏删除会诊科室按钮
	}
	if ((ret=="R")||(ret=="C")||(ret=="F"))
	{
	//document.getElementById('btnAdd').style.display="none";   ///隐藏添加按钮
	document.getElementById('btnSend').style.display="none";   ///隐藏确认按钮
	document.getElementById('btnEnd').style.display="none";   ///隐藏完成按钮
	document.getElementById('btnRefuse').style.display="none";   ///隐藏拒绝按钮
	Ext.getCmp('gridResult').getTopToolbar().hide();
	}
	var ret1 = tkMakeServerCall('User.DHCConsultDepItm', 'GetConfig');
	var ifOpenMoreLocAuditExec = ret1.split("^")[3];
	if(ifOpenMoreLocAuditExec!="Y"){
		document.getElementById('btnEnd').style.display="none";   ///隐藏完成按钮
	}
}



function btnAdd_onclick()
{
	var dep=Ext.getCmp('ConsultDep');
	//alert(dep);
	addNewLineGrid(gridResultStore);
	if ((dep.value=="")||(dep.value==undefined)) return;
	//************************
	for (i=0;i<gridResultStore.getCount();i++)
	{
	var locid=gridResultStore.getAt(i).get('ConsultLocID');
	if(locid==dep.value) return;   //已经添加某个科室了，不允许再次添加上

}

//*****************************
var record = new Object();
record.ConsultLocID=dep.value;
record.ConsultLoc=dep.getRawValue();  //"外一科";
record.ConSultDoc="";
record.ConSultDocGrade="";
var records = new Ext.data.Record(record);
gridResultStore.add(records);
if(gridResultStore.getCount()>1)
{

ConType.setValue('M');
}

}
//添加病人基本信息
function AddPatinfo()
{
Ext.getCmp('InOut').disable();  
Ext.getCmp('ConType').disable();  
var ret=tkMakeServerCall("web.DHCConsultNew","GetPatinfobyId",rowid);
var infoArr=ret.split("^");
Ext.getCmp('PatName').setValue(infoArr[0]);
Ext.getCmp('PatSex').setValue(infoArr[1]);
Ext.getCmp('PatAge').setValue(infoArr[2]);
Ext.getCmp('BedCode').setValue(infoArr[3]);
Ext.getCmp('PatDiag').setValue(infoArr[7]);
Ext.getCmp('PatWard').setValue(infoArr[9]);
Ext.getCmp('PatRegNo').setValue(infoArr[8]);
Ext.getCmp('PatMedNo').setValue(infoArr[6]);
Ext.getCmp('PatDoc').setValue(infoArr[5]);
Ext.getCmp('AppTime').setValue(infoArr[10]);
Ext.getCmp('ConDestination').setValue(infoArr[14]);
Ext.getCmp('ConDestinationtwo').setValue(infoArr[15]);
Ext.getCmp('ConPlace').setValue(infoArr[16]);
Ext.getCmp('ConTime').setValue(infoArr[17]);
Ext.getCmp('AppDate').setValue(infoArr[18]);
InOut.setValue(infoArr[12]);
ConType.setValue(infoArr[13]);

var listdepArr=tkMakeServerCall("web.DHCConsultNew","GetConlistbyId",rowid);

var listdep=listdepArr.split("!");
//debugger
for (var r = 0;r < listdep.length; r++)
{
var listdepsult=listdep[r].split("^")
//alert(listdepsult)
var record = new Object();


//**********
//var ceshi_data=[[listdepsult[2], listdepsult[3]]];   //ceshishuj
//var ceshi_store=new Ext.data.SimpleStore({ fields: ['value', 'text'], data: ceshi_data });

//******************


record.ConsultLocID=listdepsult[0];
record.ConsultLoc=listdepsult[1];  //"外一科";
record.ConsultItmLoc=listdepsult[2];  //ceshi_store; 
record.ConSultDoc=listdepsult[4]; 
record.ConSultDocName=listdepsult[5]; 
record.ConSultSubId=listdepsult[6]; 
//record.ConSultDoc="";
//record.ConSultDocGrade="";
var records = new Ext.data.Record(record);
gridResultStore.add(records);

}



}
function AddConsultPlace()
{
var resultArr=tkMakeServerCall("web.DHCConsultNew","GetConPlace",rowid);
var result=resultArr.split("^");
Ext.getCmp("ConPlace").setValue(result[0]);
Ext.getCmp("ConTime").setValue(result[1]);

}
//删除列表中添加错的科室
function DeleteHandle()
{
var cell = gridResult.getSelectionModel().getSelectedCell();
var record = gridResultStore.getAt(cell[0]);
gridResultStore.remove(record);
if(gridResultStore.getCount()==1) ConType.setValue('');
}
//拒绝
function btnRefuse_onclick(){
	var result=tkMakeServerCall("User.DHCConSultationNew","Refuse",rowid);
	if (result=="0") 
	{
		alert("拒绝申请")
		window.close();
		Search_onclick();
	}
	else
	{
		//alert("ggg")
		alert(result)
		return;
	}
}
//审核
function btnSend_onclick() {
	var dish = tkMakeServerCall("web.DHCDischargeHistory", "GetDischargeDateTime", EpisodeId);
	var recallStatus = tkMakeServerCall("web.DHCDischargeHistory", "GetCurrentDischargeStatus", EpisodeId);
	
	if ((recallStatus!="B")&&(dish != '^')) {
		alert("病人已出院!");
		return;
	}
	var ret = "";
	var ConPlace = Ext.getCmp("ConPlace").getValue();
	var ConTime = Ext.getCmp("ConTime").getValue();
	if ((ConPlace == "") || (ConTime == "")) {
		alert("请选择会诊地点和时间!")
		return;
	}
	var count = gridResultStore.getCount(); //会诊条数
	for (var r = 0; r < count; r++) {

		var RItmLoc = gridResult.getStore().getAt(r).get('ConsultItmLoc'); //要求会诊子科室
		//alert(RItmLoc+"#"+r)
		if ((isNaN(RItmLoc)) || (RItmLoc == "")) {

			alert("请选择会诊子科室")
			return;
		}

		var gg = gridResult.getStore().getAt(r).get('ConSultDoc'); //会诊科室id
		//alert(gg+"#"+r)
		if ((isNaN(gg)) || (gg == "")) {

			alert("请选择要求会诊医生")
			return;
		}

	}
	for (var r = 0; r < count; r++) {
		var conlocid = gridResult.getStore().getAt(r).get('ConsultLocID'); //要求会诊科室
		var condoc = gridResult.getStore().getAt(r).get('ConSultDoc');
		var ItmConsultDep = gridResult.getStore().getAt(r).get('ConsultItmLoc');
		conlocid = ItmConsultDep;
		if (ret == "") {
			ret = conlocid + "^" + condoc + "^" + ItmConsultDep + "!"
		} else {
			ret = ret + conlocid + "^" + condoc + "^" + ItmConsultDep + "!"
		} //会诊科室与医生对应
	}
	//alert(count)
	//alert(ret+"^"+rowid+"^"+ConPlace+"^"+ConTime)
	var result = tkMakeServerCall("User.DHCConSultationNew", "Audit", ret, rowid, ConPlace, ConTime, "", count);
	if (result == "0") {
		alert("审核成功")
		window.close();
		window.opener.location.reload();
	} else {
		//alert("ggg")
		alert(result)
		return;
	}
	return;

	var ret = "",
	dep = ""
		var count = gridResultStore.getCount();
	if (count == 0) {
		Ext.Msg.alert("请添加会诊科室")
		return;
	}
	var appdate = Ext.getCmp("AppDate").value; //申请日期
	var apptime = Ext.getCmp("AppTime").getValue(); //申请时间
	var typ = Ext.getCmp("ConType").value; //会诊类别
	if ((typ == undefined) || (typ == "")) {
		alert("请选择会诊类别")
		rerun;
	}
	if ((count == 1) && (typ == "M")) {
		alert("非多科会诊")
		return;

	}
	var inout = InOut.value; //院内院外
	if (inout == undefined) {
		Ext.Msg.alert('提示', "请选择'院内院外'!");
		return;
	}

	var Diag = PatDiag.value; //诊断
	var destin = Ext.getCmp("ConDestination").getRawValue(); //会诊备注
	///alert(appdate+"#"+apptime+"#"+typ+"#"+inout+"#"+Diag+"#"+destin)
	for (var r = 0; r < count; r++) {
		var gg = gridResult.getStore().getAt(r).get('ConsultLocID'); //会诊科室id
		if (dep == "") {
			dep = gg;
		} else {
			dep = dep + "!" + gg;
		}
	}
	var dep = "ConsultDep|" + dep + "^";
	//*************************************************
	ret = ret + "AppDate|" + appdate + "^";
	ret = ret + "AppTime|" + apptime + "^";
	ret = ret + "ConType|" + typ + "^";
	ret = ret + "InOut|" + inout + "^";
	ret = ret + "ConDestination|" + destin + "^";
	ret = ret + "Diag|" + Diag + "^";
	ret = ret + "EpisdeID|" + EpisodeID + "^";
	ret = ret + "Status|V^";
	ret = ret + "AppDep|" + session['LOGON.CTLOCID'] + "^";
	ret = ret + "AppDoc|" + session['LOGON.USERID'] + "^";
	ret = ret + "Diag|" + PatDiag.value + "^"
		ret = ret + dep;
	var result = tkMakeServerCall("User.DHCConSultationNew", "Save", ret);
	if (result == "0") {
		alert("发送成功")
		window.close();
		window.opener.location.reload();
	} else {
		alert(result)
		return;
	}

}

///////这个方法现在不用了,通过新方法来实
function oldbak (ctcpId, cellmeta, record)   
                     {  
                         //通过匹配value取得ds索引  
                         var index = DocListStore.find(Ext.getCmp('CTLoc').valueField,ctcpId);  
                         //通过索引取得记录ds中的记录集  
                         var record = DocListStore.getAt(index);  
                         //返回记录集中的value字段的值  
                         var ctcpId = "";  
                         if (record)   
                         {  
                             ctcpId = record.data.ctcpDesc;  
                         } 
                         if (ctcpId=="")
                         {
						 return "请选择"
						 }	
                         else 
                         {						 
                         return ctcpId;//注意这个地方的value是上面displayField中的value  
						 }
                      } 

function GetConSultDoc(val)
{
var rtn=tkMakeServerCall("web.DHCConsultNew","GetConSultDoc",val);
return rtn;

}

function GetConSultItmDep(val)
{
var rtn=tkMakeServerCall("web.DHCConsultNew","GetConSultItmDep",val);
return rtn;

}
function btnEnd_onclick() {
	var dish = tkMakeServerCall("web.DHCDischargeHistory", "GetDischargeDateTime", EpisodeId);
	var recallStatus = tkMakeServerCall("web.DHCDischargeHistory", "GetCurrentDischargeStatus", EpisodeId);
	if((recallStatus!="B")&&(dish != '^')){
		alert("病人已出院!");
		return;
	}
	var userid = session['LOGON.USERID'];
	var loc = session['LOGON.CTLOCID'];
	//alert(rowid+"^"+userid+"^"+loc)
	var ret = tkMakeServerCall("web.DHCConsultNew", "ExcuteMoreConsult", rowid, userid, loc);
	if (ret == "0") {
		alert("操作成功")
		window.close();
		Search_onclick()
	} else {
		alert(ret)
		return;
	}

}




