/**
  *name:
  *author:Zhaoliguo
  *Date:2016-1-5
 */
 var userCode = session['LOGON.USERCODE'];
 var userName = session['LOGON.USERNAME'];
 var userID = session['LOGON.USERID'];
 
 //获得会计核算帐套  zhaoliguo 2016-1-7
 //var frm = dhcsys_getmenuform();  //主菜单，该方法在websys.js中
 var frm = dhcsys_getsidemenuform(); //侧菜单，该方法在websys.js中
 var currBookName= frm.AcctBookName.value ; 
 var currBooID= frm.AcctBookID.value ; 

var TargetTypeTabUrl = '../csp/herp.acct.acctbookidexe.csp';
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//配件数据源

var TargetTypeTabProxy= new Ext.data.HttpProxy({url:TargetTypeTabUrl + '?action=list&bookid='+currBooID});
var TargetTypeTabDs = new Ext.data.Store({
	proxy: TargetTypeTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'loginDesc'
		,'BookName',
		'Username',
		'LoginDate'

	]),
    // turn on remote sorting
    remoteSort: true
});

//设置默认排序字段和排序方向
TargetTypeTabDs.setDefaultSort('rowid', 'name');

//数据库数据模型 "rowid^BookName^Username^LoginDate"
var TargetTypeTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
    	header: '<div style="text-align:center">登录说明</div>',
        dataIndex: 'loginDesc',
        width: 100,		  
        sortable: true
    },{
    	header: '<div style="text-align:center">用户名称<div>',
        dataIndex: 'Username',
        width: 100,		  
        sortable: true
    },{
    	header: '<div style="text-align:center">会计账套<div>',
        dataIndex: 'BookName',
        width: 200,
        sortable: true
    },{
    	header: '<div style="text-align:center">登录时间</div>',
        dataIndex: 'LoginDate',
        width: 200,
        sortable: true
    }
    
]);

//初始化默认排序功能
TargetTypeTabCm.defaultSortable = true;


//初始化搜索字段
var TargetTypeSearchField ='name';

/*//搜索过滤器
var TargetTypeFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '编码',
			value: 'code',
			checked: false ,
			group: 'TargetTypeFilter',
			checkHandler: onTargetTypeItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '名称',
			value: 'name',
			checked: true,
			group: 'TargetTypeFilter',
			checkHandler: onTargetTypeItemCheck 
		})
	]}
});

//定义搜索响应函数
function onTargetTypeItemCheck (item, checked){
	if(checked) {
		TargetTypeSearchField = item.value;
		TargetTypeFilterItem.setText(item.text + ':');
	}
};

//查找按钮
var TargetTypeSearchBox = new Ext.form.TwinTriggerField({
	width: 180,
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	emptyText:'搜索...',
	listeners: {
		specialkey: {
			fn:function(field, e) {
				var key = e.getKey();
	      	  		if(e.ENTER === key) {
					this.onTrigger2Click();
				}
			}
		}
	},
	grid: this,
	onTrigger1Click: function() {
		if(this.getValue()) {
			this.setValue('');    
			TargetTypeTabDs.proxy = new Ext.data.HttpProxy({url:  TargetTypeTabUrl + '?action=list'});
			TargetTypeTabDs.load({params:{start:0, limit:TargetTypeTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
				TargetTypeTabDs.proxy = new Ext.data.HttpProxy({
				url: TargetTypeTabUrl + '?action=list&searchField=' + TargetTypeSearchField + '&searchValue=' + this.getValue()});
	        	TargetTypeTabDs.load({params:{start:0, limit:TargetTypeTabPagingToolbar.pageSize}});
	    	}
	}
});

*/
//添加按钮
var loginButton = new Ext.Button({
	text: '账套登录',
    tooltip:'账套登录',        
    iconCls:'add',
	handler:function(){
		
		

		var cField = new Ext.form.TextField({
			id:'cField',
			fieldLabel: '用户名称',
			allowBlank: false,
			width:180,
			listWidth : 180,
			valueNotFoundText:userName,
			// emptyText:userName,
			//disabled:true,
			readOnly:true,
			// anchor: '90%',
			selectOnFocus:'false', 
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(cField.getValue()!=""){
							nField.focus();
						}else{
							Handler = function(){cField.focus();}
							Ext.Msg.show({title:'错误',msg:'用户不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var nField = new Ext.form.TextField({
			id:'nField',
			fieldLabel: '账套名称',
			allowBlank: false,
			width:150,
			listWidth : 180,
			emptyText:'',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});
		
		
		// ----------帐套名称------------------------------

		var acctbookDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		acctbookDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/herp.acct.acctbookidexe.csp?action=getAcctBook&start=0&limit=25',
				method : 'POST'
			})
		});

		var acctbookField = new Ext.form.ComboBox({
					id : 'acctbookField',
					fieldLabel : '会计账套',
					width : 180,
					listWidth : 230,
					allowBlank : false,
					store : acctbookDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'acctbookField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButton.focus();
							}
						}
					}
				});


		//初始化面板
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			frame: true,
			labelWidth: 70,
			labelAlign: 'right',
			items: [
				
				cField,
				acctbookField
			]
		});
	
			//面板加载 zlg1
	
		formPanel.on('afterlayout', function(panel, layout){
			
			Ext.Ajax.request({
			url: '../csp/herp.acct.acctbookidexe.csp?action=getBookID&userID='+userID,
			waitMsg:'更新中...',
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode(result.responseText );
				if(jsonData.success=='true'){
					var CurBookInfo= jsonData.info; 
					var CurBookID=CurBookInfo.split("^")[0];
					var CurBookCode=CurBookInfo.split("^")[1];
					var CurBookName=CurBookInfo.split("^")[2];
					
					cField.setValue(userCode);
					acctbookField.setValue(CurBookID);
					acctbookField.setRawValue(CurBookName);
					
				}		
			},
			scope: this
			});
			
			// getCurAcctBook(userID)
			//n1Field.setValue(rowObj[0].get("name"));	
		});
		
		
		//初始化添加按钮
		addButton = new Ext.Toolbar.Button({
			text:'确 认',
			// cls:'x-btn-text',
			iconCls:'submit',
			minWidth: 75
		});
		
		//定义添加按钮响应函数
		addHandler = function(){
					
			var code = cField.getValue();
			var bookid = acctbookField.getValue();
			var bookName = acctbookField.getRawValue();
			bookid = trim(bookid);
			if(code==""){
				Ext.Msg.show({title:'错误',msg:'用户不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(bookid==""){
				Ext.Msg.show({title:'错误',msg:'账套不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			//添加会计核算帐套全局变量 zhaoliguo 2016-1-7
			//var frm = dhcsys_getmenuform();
			//frm.AcctBookID=bookid
			var frm =dhcsys_getsidemenuform(); 
			frm.AcctBookID.value=bookid
			frm.AcctBookName.value=bookName
			
			//encodeURI zlg4
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.acct.acctbookidexe.csp?action=add&useid='+code+'&bookid='+bookid),
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){nField.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){nField.focus();}
						Ext.Msg.show({title:'注意',msg:'登录成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					
						var frm = dhcsys_getsidemenuform(); //侧菜单，该方法在websys.js中
						var currBookName= frm.AcctBookName.value ; 
						var currBooID= frm.AcctBookID.value ; 
						//alert(currBooID)
						
						TargetTypeTabDs.load({params:{
						 start:0, 
						 limit:5,
						 bookid:currBooID
						}});
						addwin.close();
					}
					else
							{
								var message="";
								if(jsonData.info=='RepCode') message='输入的编码已经存在!';
								if(jsonData.info=='RepName') message='输入的名称已经存在!';
								Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
				},
				scope: this
			});
			
		}
	
		//添加保存按钮的监听事件
		addButton.addListener('click',addHandler,false);
	
		//初始化取消按钮
		cancelButton = new Ext.Toolbar.Button({
			text:'取 消'
		});
	
		//定义取消按钮的响应函数
		cancelHandler = function(){
			addwin.close();
		}
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//初始化窗口
		addwin = new Ext.Window({
			title: '账套选择',
			width: 320,
			height:180,
			minWidth: 290, 
			minHeight: 150,
			// closable:false,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:20px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton
			]
		});
	
		//窗口显示
		addwin.show();

	}
});


//查询刷新按钮
var FindButton = new Ext.Toolbar.Button({
	text: '刷新',
    tooltip:'刷新',        
    iconCls:'reload',
	handler:function(){

	//alert(GetAcctBookID());
	//AddAcctBook();
	
	var frm = dhcsys_getsidemenuform(); //侧菜单，该方法在websys.js中
	var currBookName= frm.AcctBookName.value ; 
	var currBooID= frm.AcctBookID.value ; 

						
	TargetTypeTabDs.load({params:{
						 start:0, 
						 limit:5,
						 bookid:currBooID
						}});
	}
});





//分页工具栏
var TargetTypeTabPagingToolbar = new Ext.PagingToolbar({
    store: TargetTypeTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录"
	//buttons: ['-',TargetTypeFilterItem,'-',TargetTypeSearchBox]
	
	
});


//表格
var TargetTypeTab = new Ext.grid.EditorGridPanel({
	title: '用户会计帐套登录管理',
	iconCls:'maintain',
	region: 'center',
	store: TargetTypeTabDs,
	cm: TargetTypeTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:['-',loginButton,'-',FindButton],
	bbar:TargetTypeTabPagingToolbar
});
TargetTypeTabDs.load({params:{start:0, limit:TargetTypeTabPagingToolbar.pageSize}});
if(currBookName==""){
	
	currBookName="未登录"
}
//TargetTypeTab.title="当前帐套信息："+"用户【"+userName+"】,帐套【"+currBookName+"】"



