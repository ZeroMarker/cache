/**
 * @author Qse
 */
 Ext.form.Field.prototype.msgTarget = 'under';
 var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCNurEprMenuMain&pClassQuery=GetMenuDetail";
 document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
 document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/Ext.BDP.FunLib.js"> </script>');
 document.write('<style type="text/css">')
 document.write('.x-grid3-cell{')
 document.write('-moz-user-select: none;')
 document.write('-khtml-user-select:none;')
 document.write('-webkit-user-select:ignore;')
 document.write('box-sizing: border-box;')
 document.write('}')
 document.write('</style>')
 var Height = document.body.offsetHeight;
 var Width = document.body.offsetWidth;
 var pagesize = Ext.BDP.FunLib.PageSize.Main;
 /****************************************电子病历列表树*********************/
   var mytree=new Ext.tree.TreePanel({
       animate:true,
       title:"护理病历关联电子病历",
       collapsible:true,
       enableDD:true,
       enableDrag:true,
       rootVisible:true,
       autoScroll:true,
      // autoHeight:true,
       width:250,
       lines:true
   });
   //根节点
   var root=new Ext.tree.TreeNode({
       id:"root",
       text:"",
       expanded:true,
	   singleClickExpand:true
   });
 
  cspRunServerMethod(GetFatherList,"NUR","addFather");
 
   function addFather(code,desc)
   {
   	 	var sub1=new Ext.tree.TreeNode({
       		id:code,
       		text:desc,
       		singleClickExpand:true
   		});
		addsubnod(sub1);
    	root.appendChild(sub1);
   }
   mytree.setRootNode(root);//设置根节点
    function addsubnod(node)
  {	  
    FATHERNODE=node;
	cspRunServerMethod(GetSonList,node.id,"addSon");
  }
    function addSon(code,desc)
  {
	    
   	 	var sub1=new Ext.tree.TreeNode({
       		id:code,
       		text:desc,
       		singleClickExpand:true
   		});
		FATHERNODE.appendChild(sub1); 
  }
   
mytree.on('click',function(node,event){  	
 
 	var wardid = node.id;
	var wardDesc=node.text;
    //frames['centerTab'].location.href="dhcmgwardpatlist.csp?Ward="+wardid+"&AttTyp=A"; 
	if(!(wardid.indexOf("root")>-1))
	{
	SetValue(wardid,wardDesc);
	}
	find();
	return ;
}); 
function SetValue(code,desc)
{
	Ext.getCmp("TextCode").setValue(code);
	Ext.getCmp("TextDesc").setValue(desc);
	
}

/******************************************查询信息**********************************/
var WardLoc=new Ext.form.ComboBox({
		name:'WardLoc',
		id:'WardLoc',
		store:new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"../csp/dhc.nurse.ext.common.getdata.csp"
			}),
			reader:new Ext.data.JsonReader({
				root:'rows',
				totalProperty:'results',
				fields:[{
					'name':'desc',
					'mapping':'id'
				},{
					'name':'desc',
					'mapping':'id'
				}]
			}),
			baseParams:{
				className:'web.DHCNurMgWardBedCount',
				methodName:'ctloclookup',
				type:'RecQuery'
			}
		}),
		tabIndex:'0',
		listWidth:220,
		height:18,
		width:150,
		colspan: 2,
		xtype:'combo',
		displayField:'desc',
		valueField:'id',
		hideTrigger:false,
		queryParam:'ward1',
		forceSelection:true,
		triggerAction:'all',
		minChars:1,
		pageSize:100,
		typeAhead:true,
		typeAheadDelay:1000,
		loadingText:'Searching...'
	});

function comboLoadData(comBoBoxDepObj,className,methodName,inPut)
{
	comBoBoxDepObj.on('beforequery',function(){
	    comBoBoxDepObj.store.proxy=new Ext.data.HttpProxy({
			url : "../csp/dhc.nurse.ext.common.getdata.csp"
		});
		comBoBoxDepObj.store.reader =new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : 'results',
			fields : [{
				'name' : 'desc',
				'mapping' : 'desc'
			}, {
				'name' : 'id',
				'mapping' : 'id'
			}]
		});
		comBoBoxDepObj.store.baseParams.className =className;
		comBoBoxDepObj.store.baseParams.methodName = methodName;
		comBoBoxDepObj.store.baseParams.desc=comBoBoxDepObj.lastQuery;
		comBoBoxDepObj.store.baseParams.type = 'RecQuery';
		var comboboxDepStore=comBoBoxDepObj.getStore();
	    comboboxDepStore.load({
 		params:{start:0,limit:1000}
	    });	
   });	
}
/*****************************************增加修改界面**********************************/
//是否可用
var IfOnComBox = new Ext.form.ComboBox({
	fieldLabel :"是否可用",
	name : 'IfOnComBox',
	id : 'IfOnComBox',
	tabIndex : '0',
	height:18,
	width:150,
	xtype : 'combo',
	store : new Ext.data.JsonStore({
		data : [{
			desc : 'Y',
			id : 'Y'
		}, {
			desc : 'N',
			id : 'N'
		}],
		fields : ['desc', 'id']
	}),
	triggerAction:'all',
	displayField : 'desc',
	valueField : 'id',
	allowBlank : true,
	mode : 'local',
	value : ''
});
//分类
var nodeComBox=new Ext.form.ComboBox({
	    fieldLabel :"分类",
		name:'nodeComBox',
		id:'nodeComBox',
		store:new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"../csp/dhc.nurse.ext.common.getdata.csp"
			}),
			reader:new Ext.data.JsonReader({
				root:'rows',
				totalProperty:'results',
				fields:[{
					'name':'desc',
					'mapping':'id'
				},{
					'name':'desc',
					'mapping':'id'
				}]
			}),
			baseParams:{
				className:'web.DHCNurEprMenuMain',
				methodName:'NodeComBoBox',
				type:'RecQuery'
			}
		}),
		tabIndex:'0',
		listWidth:220,
		height:18,
		width:150,
		xtype:'combo',
		displayField:'desc',
		valueField:'id',
		hideTrigger:false,
		queryParam:'ward1',
		forceSelection:true,
		triggerAction:'all',
		minChars:1,
		pageSize:100,
		typeAhead:true,
		typeAheadDelay:1000,
		loadingText:'Searching...'
	});
function comboLoadData(comBoBoxDepObj,className,methodName,inPut)
{
	//comBoBoxDepObj.on('beforequery',function(){
	    comBoBoxDepObj.store.proxy=new Ext.data.HttpProxy({
			url : "../csp/dhc.nurse.ext.common.getdata.csp"
		});
		comBoBoxDepObj.store.reader =new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : 'results',
			fields : [{
				'name' : 'desc',
				'mapping' : 'desc'
			}, {
				'name' : 'id',
				'mapping' : 'id'
			}]
		});
		comBoBoxDepObj.store.baseParams.className =className;
		comBoBoxDepObj.store.baseParams.methodName = methodName;
		comBoBoxDepObj.store.baseParams.codedesc=comBoBoxDepObj.lastQuery;
		comBoBoxDepObj.store.baseParams.type = 'RecQuery';
		var comboboxDepStore=comBoBoxDepObj.getStore();
	    comboboxDepStore.load({
 		params:{start:0,limit:1000}
	    });	
   //});	
}
comboLoadData(nodeComBox,"web.DHCNurEprMenuMain","NodeComBoBox","");
// 增加修改的Form
	var WinForm = new Ext.FormPanel({
				id : 'form-save',
				title:'',
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 75,
				height : 400,
				split : true,
				frame : true,
				waitMsgTarget : true,
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				items : [{
							fieldLabel : '<font color=red>*</font>代码',
							xtype:'textfield',
							id:'code',
							maxLength:15,
							name : 'code',
							//allowBlank:false,
							//validationEvent : 'blur',  
							//enableKeyEvents:true, 
                            
                            invalidText : '该代码已经存在'
						}, {
							fieldLabel : '<font color=red>*</font>描述',
							xtype:'textfield',
							id:'name',
							maxLength:220,
							name : 'name',
							//allowBlank:false,
                            invalidText : '该描述已经存在'
						}
						,{
							id:'Method',
							xtype:'textfield',
							fieldLabel : '方法',
							name : 'Method'
						 }
						 ,{
							id:'Input1',
							xtype:'textfield',
							fieldLabel : '参数1',
							name : 'Input1'
						 }
						 ,{
							id:'Input2',
							xtype:'textfield',
							fieldLabel : '参数2',
							name : 'Input2'
						  },
						  nodeComBox
						 ,IfOnComBox
						 ,{
							id:'sort',
							xtype:'textfield',
							fieldLabel : '顺序',
							name : 'sort'
						  }
						]	
	});		

// 增加修改时弹出窗口
	var win = new Ext.Window({
		title : '', 
		width : 580,
		layout : 'fit',
		closeAction : 'hide',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : WinForm,
		buttons : [{text : '保存',
			       id:'save_btn',
				   icon:'../images/uiimages/filesave.png',
	               handler : save}, 
				   {
			       text : '取消',
				   icon:'../images/uiimages/cancel.png',
			       handler : function() {
				   win.hide();
			       }
		          }]
	});
//保存前校验数据	
function dataChcek()
{
	var codeValue=Ext.getCmp("code").getValue();
	if(codeValue=="")
	{return "不能有空项目";}
	var nameValue=Ext.getCmp("name").getValue();
	if(nameValue=="")
	{return "不能有空项目";}
	var methodValue=Ext.getCmp("Method").getValue();
	if(methodValue="")
	{return "不能有空项目";}
	var input1Value=Ext.getCmp("Input1").getValue();
	if(input1Value=="")
	{return "不能有空项目";}
	var input2Value=Ext.getCmp("Input2").getValue();
	if(input2Value="")
	{return "不能有空项目";}
	var nodeComBoxValue=nodeComBox.getValue();
	if(nodeComBoxValue=="")
	{return "不能有空项目";}
	var ifOnComBoxValue=IfOnComBox.getValue();
	if(ifOnComBoxValue=="")
	{return "不能有空项目";}
    return "";
}	
function save()
{
   
	//------数据校验-------
	var message=dataChcek();
	if(message!="")
	{
	   alert(message);
	   return;   
	}
	//-------添加----------
	if (win.title == "添加")
	{	
  
	    var codeValue=Ext.getCmp("code").getValue();
	    var nameValue=Ext.getCmp("name").getValue();
	    var methodValue=Ext.getCmp("Method").getValue();
	    var input1Value=Ext.getCmp("Input1").getValue();
	    var input2Value=Ext.getCmp("Input2").getValue();
	    var nodeComBoxValue=nodeComBox.getValue();
	    var ifOnComBoxValue=IfOnComBox.getValue();
	    var sortValue=Ext.getCmp("sort").getValue();
		var parr="code|"+codeValue+"^"+"name|"+nameValue+"^"+"classMethod|"+methodValue+"^"+"InPutSyj|"+input1Value+"^"+"InPutSyjSub|"+input2Value+"^"+"fatherId|"+nodeComBoxValue+"^"+"ifon|"+ifOnComBoxValue+"^"+"sort|"+sortValue;	 	 	 	 	 	
		var ret=tkMakeServerCall("Nur.DHCNUREPRMenuDetail","Save",parr,"");
		if(ret!=0)
		{alert(ret);}
	    else
		{alert("添加成功！");win.hide();}	
	}
	 
	//---------修改-------
	if (win.title == "修改")			
	 {
		var codeValue=Ext.getCmp("code").getValue();
	    var nameValue=Ext.getCmp("name").getValue();
	    var methodValue=Ext.getCmp("Method").getValue();
	    var input1Value=Ext.getCmp("Input1").getValue();
	    var input2Value=Ext.getCmp("Input2").getValue();
	    var nodeComBoxValue=nodeComBox.getValue();
	    var ifOnComBoxValue=IfOnComBox.getValue();
	    var sortValue=Ext.getCmp("sort").getValue();
		var parr="code|"+codeValue+"^"+"name|"+nameValue+"^"+"classMethod|"+methodValue+"^"+"InPutSyj|"+input1Value+"^"+"InPutSyjSub|"+input2Value+"^"+"fatherId|"+nodeComBoxValue+"^"+"ifon|"+ifOnComBoxValue+"^"+"sort|"+sortValue;	 	 	 	 	 	
		var id=Ext.getCmp("mygrid").getSelectionModel().getSelections()[0].get("id");
		var ret=tkMakeServerCall("Nur.DHCNUREPRMenuDetail","Save",parr,id);
		if(ret!=0)
		{alert(ret);}
	    else
		{alert("保存成功！");win.hide();}	
	 }
	 find();
			
}
/*****************************************查询明细Grid**********************************/
function find()
{
	var parr=Ext.getCmp("TextCode").getValue();
	ds.proxy = new Ext.data.HttpProxy({url : ACTION_URL+"&parr="+parr});
	ds.load({
				params : { start : 0, limit : pagesize },
				callback : function(records, options, success) {
				}
	}); 
	
}
var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'code',
								mapping : 'code',
								type : 'string'
							}, {
								name : 'name',
								mapping : 'name',
								type : 'string'
							}, {
								name : 'classMethod',
								mapping : 'classMethod',
								type : 'string'
							}, {
								name : 'InPutSyj',
								mapping : 'InPutSyj',
								type : 'string'
							}, {
								name : 'InPutSyjSub',
								mapping : 'InPutSyjSub',
								type : 'string'
							}, {
								name : 'fatherId',
								mapping : 'fatherId',
								type : 'string'
							}, {
								name : 'ifon',
								mapping : 'ifon',
								type : 'string'
							}, {
								name : 'sort',
								mapping : 'sort',
								type : 'string'
							}, {
								name : 'id',
								mapping : 'id',
								type : 'number'
							}
						]),
				//remoteSort : true
				sortInfo: {field : "id",direction : "ASC"}
	});
// 加载数据
	ds.load({
				params : { start : 0, limit : pagesize },
				callback : function(records, options, success) {
				}
	}); 	
	
//分页工具条
function getbbar()
{
    
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : ds,
				//plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
				emptyMsg : "没有记录" 
	});
	return paging;
}
// 增加按钮
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				//iconCls : 'icon-add',
				icon:'../images/uiimages/edit_add.png',
				id:'add_btn',
				//disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function() {
					if(Ext.getCmp("TextCode").getValue()=="")
					{
						alert("请选择一种类型再添加！")
						return;
					}
					
					win.setTitle('添加');
					win.setIconClass('icon-add');
					
					win.show();
					WinForm.getForm().reset();
					
				    nodeComBox.setValue(Ext.getCmp("TextCode").getValue());
					IfOnComBox.setValue("Y");
				    Ext.getCmp("Method").setValue("EMRservice.BL.BLScatterData:GetNewStdDataByGlossaryCategory");
					
				},
				scope: this
	});
// 修改按钮
   var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				//iconCls : 'icon-update',
				icon:'../images/uiimages/updateinfo.png',
				id:'update_btn',
				handler : UpdateData=function() {
                    if(!(Ext.getCmp("mygrid").getSelectionModel().getSelected()))
					{
						alert("请选择一条记录！");
						return ;	
					}				                				
 					win.setTitle('修改');
					win.setIconClass('icon-update');
					win.show();
					WinForm.getForm().reset(); 					
					var retStr=tkMakeServerCall("Nur.DHCNUREPRMenuDetail","getVal",Ext.getCmp("mygrid").getSelectionModel().getSelections()[0].get("id"));
					var retStrArr=retStr.split("^");
					
					Ext.getCmp("code").setValue(getValueLocal(retStrArr[3]));
	                Ext.getCmp("name").setValue(getValueLocal(retStrArr[6]));
	                Ext.getCmp("Method").setValue(getValueLocal(retStrArr[2]));
	                Ext.getCmp("Input1").setValue(getValueLocal(retStrArr[0]));
	                Ext.getCmp("Input2").setValue(getValueLocal(retStrArr[1]));
	                Ext.getCmp("sort").setValue(getValueLocal(retStrArr[7]));
				    nodeComBox.setValue(getValueLocal(retStrArr[4]));
					IfOnComBox.setValue(getValueLocal(retStrArr[5]));
				},
				scope: this
	});
//删除按钮
   var btnDeletewin = new Ext.Toolbar.Button({
				text : '删除',
				tooltip : '删除',
				//iconCls : 'icon-delete',
				icon:'../images/websys/delete.gif',
				id:'delete_btn',
				handler : DeleteData=function() {
                    if(!(Ext.getCmp("mygrid").getSelectionModel().getSelected()))
					{
						alert("请选择一条记录！");
						return ;	
					}
                    Ext.Msg.confirm('系统提示','确定要删除吗？',
                    function(btn)
					{
                     if(btn=='yes')
					 {	
                       var ret=tkMakeServerCall("Nur.DHCNUREPRMenuDetail","QtDelete",Ext.getCmp("mygrid").getSelectionModel().getSelections()[0].get("id"));
				       alert("删除成功!");
					   find();					
                     }},this);	
					
				},
				scope: this
	});  
//维护父节点按钮
  var AddFatherNodebtn = new Ext.Toolbar.Button({
				text : '父节点维护',
				tooltip : '父节点维护',
				id:'FatherNode_btn',
				icon:'../images/uiimages/config.png',
				handler : FatherData=function() {
                var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNUREPRMenu&EpisodeID="  ;
	            var wind22455=window.open(lnk,"htm33444455",'left=300,top=200,toolbar=no,location=no,directories=no,resizable=yes,width=600,height=500');
				},
				scope: this
	}); 

//维护子节点按钮
  var AddSonNodebtn = new Ext.Toolbar.Button({
				text : '子节点维护',
				tooltip : '子节点维护',
				id:'SonNode_btn',
				icon:'../images/uiimages/config2.png',
				handler : FatherData=function() {
                var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNUREPRMenuSub&EpisodeID="  ;
	            var wind22455=window.open(lnk,"htm33444455",'left=300,top=200,toolbar=no,location=no,directories=no,resizable=yes,width=700,height=600');
				},
				scope: this
	}); 
	
// 搜索工具条
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				//disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				tooltip : '搜索',
				//iconCls : 'icon-search',
				icon:'../images/uiimages/search.png',
				text : '搜索',
				handler : function() {
				grid.getStore().baseParams={
						parr : 'aaa'				
				};
				grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize
					}
				});
			}
	});
function getValueLocal(value)
{
	if(value.indexOf("|")>-1)
	{
		var valueArr=value.split("|");
		return valueArr[1];
	}
	else
	{return value;}
}	
// 将工具条放到一起
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码：', {xtype : 'textfield',id : 'TextCode',disabled : true},'-',
						'描述：', {xtype : 'textfield',emptyText : '描述/别名',id : 'TextDesc',disabled : true},'-', 
						btnSearch,'-',btnAddwin,'-',btnEditwin,'-',btnDeletewin,'-',AddFatherNodebtn,'-',AddSonNodebtn,'->'
					],
				listeners : {
					render : function() {
						//tbbutton.render(grid.tbar)
					}
				}
	});

function initResultGrid()
{ 
   var paging= getbbar();

   //创建选择checkBox
   var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});
   // 创建Grid
   //code,name,classMethod,InPutSyj,InPutSyjSub,fatherId,ifon,sort,id
	var grid = new Ext.grid.GridPanel({
				title : '方法维护',
				id : 'mygrid',
				region : 'center',
				width : 900,
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				height : 500,
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns :[sm, {
							header : '代码',
							width : 50,
							sortable : true,
							dataIndex : 'code'
						}, {
							header : '描述',
							width : 80,
							sortable : true,
							dataIndex : 'name'
						}, {
							header : '方法',
							width : 80,
							sortable : true,
							dataIndex : 'classMethod'
						}, {
							header : '参数1',
							width : 30,
							sortable : true,
							dataIndex : 'InPutSyj'
						}, {
							header : '参数2',
							width : 30,
							sortable : true,
							dataIndex : 'InPutSyjSub'
						}, {
							header : '分类',
							width : 50,
							sortable : true,
							dataIndex : 'fatherId'
						}, {
							header : '是否可用',
							width : 30,
							sortable : true,
							dataIndex : 'ifon'
						}, {
							header : '顺序',
							width : 30,
							sortable : true,
							dataIndex : 'sort'
						}, {
							header : 'id',
							width : 30,
							sortable : true,
							dataIndex : 'id'
						}],
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				stateful : true, 
				viewConfig : {
					forceFit : true
				},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'
	});
	grid.on("rowdblclick", function(grid, rowIndex, e)
   {
		 if(!(Ext.getCmp("mygrid").getSelectionModel().getSelected()))
					{
						alert("请选择一条记录！");
						return ;	
					}				                				
 					win.setTitle('修改');
					win.setIconClass('icon-update');
					win.show();
					WinForm.getForm().reset(); 					
					var retStr=tkMakeServerCall("Nur.DHCNUREPRMenuDetail","getVal",Ext.getCmp("mygrid").getSelectionModel().getSelections()[0].get("id"));
					var retStrArr=retStr.split("^");
					
					Ext.getCmp("code").setValue(getValueLocal(retStrArr[3]));
	                Ext.getCmp("name").setValue(getValueLocal(retStrArr[6]));
	                Ext.getCmp("Method").setValue(getValueLocal(retStrArr[2]));
	                Ext.getCmp("Input1").setValue(getValueLocal(retStrArr[0]));
	                Ext.getCmp("Input2").setValue(getValueLocal(retStrArr[1]));
	                Ext.getCmp("sort").setValue(getValueLocal(retStrArr[7]));
				    nodeComBox.setValue(getValueLocal(retStrArr[4]));
					IfOnComBox.setValue(getValueLocal(retStrArr[5]));
   });
 return  grid;
} 

//取变量有效值
function getvalue(InPut)
{
	if((InPut!=null)&&(InPut!="undefine"))
	{
		return InPut;
	}
	else
	{
	    return "";
    }	
}
/****************************************Center部分panel*********************************/
if(window.ActiveXObject)
    {
    	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DeleteData);
    }
Ext.onReady(function(){
	var CenterPanel=initResultGrid();
	new Ext.Viewport({
	id: 'mainViewPort',
	shim: false,
	animCollapse: false,
	constrainHeader: true, 
	margins:'0 0 0 0',           
	layout: 'border',        
	border: false,             
	items: [{ 
		region: 'west', 
		layout: 'accordion',
		title: '功能菜单',
		width:250, 
		split: true, 
		autoScroll:true,
		collapsible: true, 
		bbar: null,
		titleCollapse: true,
		items: [mytree]
		},
		CenterPanel]
	})
	
})
