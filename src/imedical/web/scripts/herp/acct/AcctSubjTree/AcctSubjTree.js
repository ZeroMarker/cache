var userid = session['LOGON.USERID'];
var acctbookid=GetAcctBookID();
var tmpNode=""; //定义结点变量
var projUrl='../csp/herp.acct.acctSubjTreeExe.csp';
var  mainUrl='../csp/herp.acct.acctSubjTreeExe.csp?action=list&acctbookid='+acctbookid;


//当前科目编码录入的规则显示
var ParamCode = new Ext.form.TextField({
            fieldLabel:'当前编码规则:',
            id:'ParamCode',
            width : 120,
            editable : false,
            columnWidth : .2,
            disabled:true,
            selectOnFocus : true
});
//获取编码规则
Ext.Ajax.request({
	url : 'herp.acct.acctbookparamexe.csp?action=list&acctbookid='+acctbookid,
	waitMsg : '保存中...',
	failure : function(result, request) {
			Ext.Msg.show({
				title : '错误',
				msg : '请检查网络连接!',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
			});
	},
	success : function(result,request) {
			var resultstr = result.responseText;
			var strs= new Array();
			strs=resultstr.split("|");
			if(strs.length!=1){
				var paramcode=ParamCode.setValue(strs[1].split("^")[2]);
			}
			// var paramcode1=document.getElementById("ParamCode").value; 
			// document.getElementById("paramcode1").style.color="red";
			// document.getElementById("ParamCode").style.font="red";
		},
			scope : this
		});                 
	
		
//============================查询面板相关信息Start==================================//

//科目编码--查询输入框
var sjcodeField = new Ext.form.TextField({
    id: 'sjcodeField',
    fieldLabel: '科目编码',
    width:180,
    listWidth : 245,
    triggerAction: 'all',
    emptyText:'编码模糊查询...',
    name: 'sjcodeField',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
});

//科目名称--查询输入框
var sjnameField = new Ext.form.TextField({
    id: 'sjnameField ',
    fieldLabel: '科目名称',
    width:180,
    listWidth : 245,
    triggerAction: 'all',
    emptyText:'名称模糊查询...',
    name: 'sjnameField',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
});
//科目类别
var sjtypeDs = new Ext.data.Store({
    proxy:"",
    reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
});

sjtypeDs.on('beforeload', function(ds, o){
    ds.proxy = new Ext.data.HttpProxy({
                        url : projUrl+'?action=sjtypelist&str',method:'POST'
    });
});

var sjtypeField = new Ext.form.ComboBox({
    id: 'sjtypeField',
    fieldLabel: '科目类别',
    width:200,
    listWidth : 200,
    allowBlank: true,
    store: sjtypeDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText:'请选择科目类型...',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true   
});


//科目性质--查询下拉框//
var sjnatureDs = new Ext.data.Store({
    proxy:"",
    reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
});

sjnatureDs.on('beforeload', function(ds, o){
    ds.proxy = new Ext.data.HttpProxy({
                        url : projUrl+'?action=sjnaturelist&str',method:'POST'
    });
});

var sjnatureField = new Ext.form.ComboBox({
    id: 'sjnatureField',
    fieldLabel: '科目性质',
    width:200,
    listWidth : 200,
    allowBlank: true,
    store: sjnatureDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText:'请选择科目性质...',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true   
});

//科目级别--查询下拉框//
var sjlevelDs = new Ext.data.SimpleStore({
        fields : ['key', 'keyValue'],
        data : [
                ['1','1'],['2','2'],['3','3'],['4','4'],
                ['5','5'],['6','6'],['7','7'],['8','8'],
                ['9','9'],['10','10'],['11','11'],['12','12']
            ]
        });

var sjlevelField = new Ext.form.ComboBox({
    id: 'sjlevelField',
    fieldLabel: '科目级别',
    width:200,
    listWidth : 200,
    allowBlank: true,
    store: sjlevelDs,
    valueField: 'key',
    displayField: 'keyValue',
    triggerAction: 'all',
    emptyText:'请选择科目级别...',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    mode : 'local', // 本地模式
    editable:true   
});

//是否停用
var IsStopField = new Ext.form.Checkbox({
                    id : 'IsStopField',
                    labelSeparator : '是否停用:',
                    style:'padding-top:3px;',
                    allowBlank : false
                });

//外币核算
var IsFcField = new Ext.form.Checkbox({
                    id : 'IsFcField',
                    labelSeparator : '外币核算:',
                    allowBlank : false
                });
//数量核算            
var IsNumField = new Ext.form.Checkbox({
                    id : 'IsNumField',
                    labelSeparator : '数量核算:',
                    allowBlank : false
                });
//科室应用
var IsCheckField = new Ext.form.Checkbox({
                    id : 'IsCheckField',
                    labelSeparator : '科室应用:',
                    allowBlank : false
                });

var startDate = new Ext.form.DateField({
        id : 'startDate',
        format : 'Y-m',
        width : 120,
        emptyText : '',
        plugins: 'monthPickerPlugin'
    });


		
//============================查询面板相关信息==================================//

		
var addButton = new Ext.Toolbar.Button({
    text: '添加',
    tooltip:'添加',        
    iconCls:'add',
    handler:function(){        
            addFun();
    }   
});

var editButton = new Ext.Toolbar.Button({
    text: '修改',
    tooltip:'修改',        
    iconCls:'edit',
    handler:function(){
		//声明选择的行的rowid
		if(tmpNode!=""){
			var selectrowid=tmpNode.attributes["rowid"];
			editFun(); 
		}else{
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
            return;
		}
       
    }   
});


var delButton  = new Ext.Toolbar.Button({
    text: '删除',
    tooltip:'删除',        
    iconCls:'remove',
    handler:function(){     
            delFun();
    }   
});

var importButton = new Ext.Toolbar.Button({
    text: '导入Excel模板',
    tooltip:'导入',        
    iconCls:'in',
    handler:function(){        
           doimport();
    }   
});

var reloadButton  = new Ext.Toolbar.Button({
    text: '同步科目属性<span style="color:green;cursor:hand">(编辑或导入科目后请单击)</span>',
    tooltip:'用于编辑或导入功能后,同步科目相关属性',        
    iconCls:'reload',
    handler:function(){     
            reloadFun();
    }   
});
	
var expandAllButton = new Ext.Toolbar.Button({
	text: '全部展开',
    tooltip:'全部展开',        
    iconCls:'add',
	handler:function(){
		mainGrid.getRootNode().expand(true);
	}
});
	
//树形结构		
var mainGrid=new Ext.ux.tree.TreeGrid({
	title:'会计科目字典',
	region:'center',
	height:'auto',
    width:750,
    atLoad : true,
	autoScroll: true,
	bodyStyle:'overflow-y:hidden;',
	enableDD:true, //可以拖拽
	enableSort:false,
	requestUrl:mainUrl,
	tbar:[addButton,'-',editButton,'-',delButton,'-',importButton,'-',expandAllButton,'-','<span style="color:red;cursor:hand">'+"当前编码规则:"+'&nbsp;'+'</span>',ParamCode,'-',reloadButton,""],
	// bbar:itemGridPagingToolbar,
	columns:[{
		header: '科目名称',
        dataIndex: 'SubjName',
        width: 220
	},{
		header: '科目编码',
        dataIndex: 'SubjCode',
        width:120 
	},{
		header: '科目全称',
        dataIndex: 'SubjNameAll',
        width: 240
	},{
		header: '<div style="text-align:center">科目级次</div>',
        dataIndex: 'SubjLevel',
        width:70
	},{
		header: '<div style="text-align:center">上级编码</div>',
        dataIndex: 'SuperSubjCode',
        width:70
	},{
		header: '<div style="text-align:center">是否末级</div>',
        dataIndex: 'IsLast',
        width: 70
	},{
		header: '<div style="text-align:center">借贷方向</div>',
        dataIndex: 'Direction',
        width: 70	
	},{
		header: '<div style="text-align:center">科目类型</div>',
        dataIndex: 'SubjTypeName',
		width: 90,
        align:'center'
	},{
		header: '<div style="text-align:center">科目性质</div>',
        dataIndex: 'SubjNatureName',
        width: 80
	},{
		header: '<div style="text-align:center">是否停用</div>',
         width:70,
         align:'center',
         dataIndex: 'IsStop'
	},{
		header: '<div style="text-align:center">辅助核算</div>',
         width:60,
         align:'center',
         dataIndex: 'IsCheck'
	},{
		header: '<div style="text-align:center">外币核算</div>',
         width:60,
         align:'center',
         dataIndex: 'IsFc'
	},{
		 header: '<div style="text-align:center">数量核算</div>',
         width:60,
         align:'center',
         dataIndex: 'IsNum'
	},{
		header: '<div style="text-align:center">拼音码</div>',
        dataIndex: 'Spell',
        width: 90
	},{
		header: '<div style="text-align:center">现金银行</div>',
        dataIndex: 'IsCash',
        width: 80,
        align:'center'
	},{
		header: '<div style="text-align:center">科目分组</div>',
         width:100,
         align:'center',
         dataIndex: 'subjGroup'
	},{
		header: '<div style="text-align:center">是否现金流量</div>',
         width:80,
         align:'center',
         // hidden: true,
         dataIndex: 'IsCashFlow'
	},{
		 header: '流量项',
         width:150,
         align:'center',
         dataIndex: 'CashItemName'
	}
	
	/*	以下信息隐藏，但并不影响树状结构 来获取他们的值
	,{
		header:'rowid',
		dataIndex:'rowid',
		width:30
	},{
		header:'账套ID',
		dataIndex:'BookID',
		width:30
	}
	,{
		header: '科目类型ID',
        dataIndex: 'SubjTypeID',
        width: 30
	},{
		header: '科目性质ID',
        dataIndex: 'SubjNatureID',
        width: 70
	},{
		header: '计量单位',
         width:60,
         align:'center',
         dataIndex: 'NumUnit'
	},{
		header: '开始时间',
         width:60,
         align:'center',
         dataIndex: 'StartYM'
	},{
		header: '结束时间',
         width:60,
         align:'center',
         dataIndex: 'EndYM'
	},{
		header: '流量项ID',
         width:100,
         align:'center',
         dataIndex: 'CashFlowID'
	},{
		header: '自定义编码',
        dataIndex: 'DefineCode',
        width: 60,
        align:'center'
       
	}*/
	
	],
	
	listeners:{
		'beforeload':function(node){
			if(node.isRoot){
				//是根节点
				this.loader.dataUrl=this.requestUrl+'&rootnode=';
			}else{
				var nodeText=node.attributes["SubjCode"];
				 var rqtUrl = this.requestUrl + '&rootnode=' + nodeText;
				 var LastFlag=node.attributes["IsLast"];
                if (node.attributes.loader.dataUrl) {
				//	alert(node.attributes.loader.dataUrl); 
                    this.loader.dataUrl = rqtUrl
					// alert(rqtUrl);
                }
			}
			//alert(this.root.attributes.loader); undefined
			 this.root.attributes.loader = null;
		},
		'click' : function(node,e) {
			tmpNode = node;
			var LastFlag=node.attributes["IsLast"];
			var rowid=node.attributes["rowid"];
			var IsCheck=node.attributes["IsCheck"];
			if(LastFlag="是"){
				if(IsCheck=="否"){
					CheckitemGrid.disable();
				}else{
					CheckitemGrid.enable();
				};
				CheckitemGrid.store.proxy=new Ext.data.HttpProxy({
				url : projUrl + '?action=listcheck&rowid='+rowid
				});
				
				CheckitemGrid.load({
					params : {
						start : 0,
						limit : 25
					}
				});		
			}
		}
	}
	
	});

/*
	//查询按钮
var QueryButton = new Ext.Toolbar.Button({
    text: '查询', 
	tooltip:'查询',        
	iconCls:'find',
	width:55,
    handler:function(){ 
	var sjcode=sjcodeField.getValue();
    var sjname=sjnameField.getValue();
    var sjlevel=sjlevelField.getValue();
    var sjnature=sjnatureField.getValue();
    var sjtype=sjtypeField.getValue();
    var IsStop = (IsStopField.getValue() == true) ? '1' : '0';
    var IsCheck = (IsCheckField.getValue() == true) ? '1' : '0';
    var IsFc = (IsFcField.getValue() == true) ? '1' : '0';
    var IsNum = (IsNumField.getValue() == true) ? '1' : '0';
    var startTime= startDate.getValue();
    if (startTime!=="")
    {
       startTime=startTime.format ('Y-m');
    }
	var url=mainUrl + '&sjcode='+sjcode+'&sjname='+encodeURIComponent(sjname)+'&acctbookid='+acctbookid
    +'&sjlevel='+sjlevel+'&sjnature='+sjnature+'&sjtype='+sjtype+'&IsStop='+IsStop+'&IsCheck='+IsCheck+'&IsFc='+IsFc+'&IsNum='+IsNum+'&startDate='+startTime
    +'&rootnode=1002';
	mainGrid.requestUrl= url;
	alert(mainGrid.requestUrl);
	
	mainGrid.load(
	function(){
		mainGrid.syncScroll();
	mainGrid.loader.dataUrl=mainGrid.requestUrl+'&rootnode=';	
	mainGrid.render(Ext.getBody());
    mainGrid.expand(false,false);	
		}
	);
	
    }
}); 
*/


/*

//查询面板
var queryPanel = new Ext.FormPanel({
            height:67,
            region:'north',
            frame:true,
            defaults: {bodyStyle:'padding:2px'},
                items:[{
                columnWidth:1,
                xtype: 'panel',
                layout:"column",
                items: [{
                        xtype:'displayfield',
                        value:'科目编码:',
                        style:'line-height: 20px;',  
                        width:55
                    },
                    sjcodeField,
                    {
                        xtype:'displayfield',
                        value:'',
                        width:20
                    },{
                        xtype:'displayfield',
                        value:'科目类型:',
                        style:'line-height: 20px;',
                        width:55
                    },
                    sjtypeField,
                    {
                        xtype:'displayfield',
                        value:'',
                        width:20
                    },{
                        xtype:'displayfield',
                        value:' 科目级别:',
                        style:'line-height: 20px;',
                        width:55
                    },
                    sjlevelField,
                    {
                        xtype:'displayfield',
                        value:'',
                        width:20
                    },{
                        xtype:'displayfield',
                        value:'科目设立时间:',
                        style:'line-height: 20px;',
                        width:77
                    },
                    startDate
                    ]
                },{
                columnWidth:1,
                xtype: 'panel',
                layout:"column",
                items: [{
                        xtype:'displayfield',
                        value:'科目名称:',
                        style:'line-heigth:22px',
                        width:55
                    },
                    sjnameField,
                    {
                        xtype:'displayfield',
                        value:'',
                        width:20
                    },{
                        xtype:'displayfield',
                        value:'科目性质:',
                        style:'line-heigth:22px',
                        width:55
                    },
                    sjnatureField,
                    {
                        xtype:'displayfield',
                        value:'',
                        width:20
                    },
                    IsStopField,
                    {
                    xtype:'displayfield',
                        value:'科目停用 ',
                        style:'padding-top:5px;',
                        width:55
                    },{
                        xtype:'displayfield',
                        value:'',
                        width:20
                    },
                    IsCheckField,
                    {
                        xtype:'displayfield',
                        value:'辅助核算 ',
                        style:'padding-top:5px;',
                        width:55
                    },{
                        xtype:'displayfield',
                        value:'',
                        width:20
                    },
                    IsFcField,
                    {
                        xtype:'displayfield',
                        value:'外币核算 ',
                        style:'padding-top:5px;',
                        width:55
                    },{
                        xtype:'displayfield',
                        value:'',
                        width:20
                    },
                    IsNumField,
                    {
                        xtype:'displayfield',
                        value:'数量核算 ',
                        style:'padding-top:5px;',
                        width:55
                    },{
                        xtype:'displayfield',
                        value:'',
                        width:20
                    },{
                        xtype:'displayfield',
                        value:'',
                        width:20
                    },QueryButton
                ]   
            }]
        });

*/
		
	
		
		
//============================辅助核算项的相关信息==================================//

//删除按钮
var delButton1 = new Ext.Toolbar.Button({
            text : '删除',
            tooltip : '删除',
            iconCls : 'remove',
            handler :function( ) {
                CheckitemGrid.del();
            }
});

//增加按钮
var addButton1 = new Ext.Toolbar.Button({
    text: '增加',
    tooltip:'增加',        //悬停提示
    iconCls: 'add',
    handler:function(){
        CheckitemGrid.add();    
    }  
});

//保存按钮
var saveButton1 = new Ext.Toolbar.Button({
    text:'保存',
    tooltip:'保存更改',
    iconCls: 'save',
    handler:function(){
        //调用保存函数
        CheckitemGrid.save();
        }
    });

//===编辑条件

//核算类别
    var vCheckTypeDs = new Ext.data.Store({
        proxy:"",
        reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
    });
    vCheckTypeDs.on('beforeload', function(ds, o){
        ds.proxy = new Ext.data.HttpProxy({
            url : projUrl+'?action=sjchecktypelist&str',method:'POST'
        });
    });
    var CheckTypeName = new Ext.form.ComboBox({
        id: 'CheckTypeName',
        fieldLabel: '辅助核算类别',
        width:180, 
        listWidth : 265,
        allowBlank: true,
        store: vCheckTypeDs,
        valueField: 'rowid',
        displayField: 'name',
        triggerAction: 'all',
        emptyText:'请选择...',
        minChars: 1,
        pageSize: 10,
        selectOnFocus:true,
        forceSelection:'true',
        editable:true   
    });


    //启用年月
    var CheckSYear = new Ext.form.TextField({
    fieldLabel: '辅助项启用年',
    width:180,
	value:new Date().format('Y'),
    selectOnFocus:'true'
    }); 
	//new Date().format('Y');

    //启用月份
    var StartMonthStore = new Ext.data.SimpleStore({
        fields : ['key', 'keyValue'],
        data : [
                ["01",'1月'],["02",'2月'],['03','3月'],['04','4月'],
                ['05','5月'],['06','6月'],['07','7月'],['08','8月'],
                ['09','9月'],['10','10月'],['11','11月'],['12','12月']
            ]
        });
        var CheckSMonth= new Ext.form.ComboBox({
            id : 'CheckSMonth',
            fieldLabel : '辅助项启用月',
            width : 180,
            selectOnFocus : true,
            allowBlank : false,
            store : StartMonthStore,            
            displayField : 'keyValue',
            valueField : 'key',
            triggerAction : 'all',
            mode : 'local', // 本地模式
            editable : false,
            selectOnFocus : true,
            forceSelection : true
        }); 
    
    var IsStopStore = new Ext.data.SimpleStore({
        fields : ['key', 'keyValue'],
        data : [['1', '是'], ['0', '否']]
        });
        var CheckIsStop = new Ext.form.ComboBox({
            id : 'CheckIsStop',
            fieldLabel : '辅助账是否停用',
            width:180, 
            selectOnFocus : true,
            allowBlank : false,
            store : IsStopStore,            
            displayField : 'keyValue',
            valueField : 'key',
            triggerAction : 'all',
            mode : 'local', // 本地模式
            editable : false,
            value:0,
            selectOnFocus : true,
            forceSelection : true
        }); 
    
    var CheckEYear = new Ext.form.TextField({
        fieldLabel: '辅助项停用年',
        width:180, 
        selectOnFocus:true
    }); 
    
    //停用月份
    var vEndMonthStore = new Ext.data.SimpleStore({
        fields : ['key', 'keyValue'],
        data : [
                ['01','1月'],['02','2月'],['03','3月'],['04','4月'],
                ['05','5月'],['06','6月'],['07','7月'],['08','8月'],
                ['09','9月'],['10','10月'],['11','11月'],['12','12月']
            ]
        });
        var CheckEMonth= new Ext.form.ComboBox({
            id : 'CheckEMonth',
            fieldLabel : '辅助项停止月',
            width : 180,
            listWidth : 80,
            selectOnFocus : true,
            allowBlank : false,
            store : vEndMonthStore,
            //anchor : '95%',           
            displayField : 'keyValue',
            valueField : 'key',
            triggerAction : 'all',
            mode : 'local', // 本地模式
            editable : false,
            //value:01,
            selectOnFocus : true,
            forceSelection : true
        }); 


var projUrl='../csp/herp.acct.acctSubjTreeExe.csp';
//辅助核算维护
var CheckitemGrid = new dhc.herp.Grid({
        title: '相应辅助账维护',
        width: 430,
        region: 'east',
		collapsible:true,
		split:true,
		tbar:[addButton1,'-',saveButton1,'-',delButton1,'-'],
        url : projUrl,  
        atLoad:true,  
        fields : [
        new Ext.grid.CheckboxSelectionModel({editable:false}),
        {
            header : 'ID',
            dataIndex : 'CheckMaprowid',
            hidden : true
        },{
            id : 'CheckTypeID',
            header: '<div style="text-align:center">辅助类型ID</div>', 
            align:'center',
            dataIndex : 'CheckTypeID',
            hidden : true
        },{
            id : 'CheckTypeName',
            header: '<div style="text-align:center">辅助类型</div>', 
            width : 100,
            align:'center',
            type: CheckTypeName,
            dataIndex : 'CheckTypeName'
        },{
            id : 'CheckSYear',
            header: '<div style="text-align:center">启用年</div>', 
            width : 50,
            align:'center',
            dataIndex : 'CheckSYear'
        },{
            id : 'CheckSMonth',
            header: '<div style="text-align:center">启用月</div>', 
            width : 50,
            align:'center',
            type: CheckSMonth,
            dataIndex : 'CheckSMonth'
        },{
            id : 'CheckIsStop',
            header: '<div style="text-align:center">是否停用</div>', 
            width : 70,
            align:'center',
            type: CheckIsStop,
            dataIndex : 'CheckIsStop'
        },{
            id : 'CheckEYear',
            header: '<div style="text-align:center">停用年</div>', 
            width : 50,
            align:'center',
            dataIndex : 'CheckEYear'
        },{
            id : 'CheckEMonth',
            header: '<div style="text-align:center">停用月</div>', 
            width : 50,
            type: CheckEMonth,
            align:'center',
            dataIndex : 'CheckEMonth'
        }] 
});
		CheckitemGrid.btnResetHide() ;  //隐藏重置按钮
        CheckitemGrid.btnPrintHide() ;  //隐藏打印按钮
        CheckitemGrid.btnAddHide();         //隐藏按钮
        CheckitemGrid.btnSaveHide();    //隐藏按钮
        CheckitemGrid.btnDeleteHide();



 var acctbookid=IsExistAcctBook(); //判断当前账套是否存在
