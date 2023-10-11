
var userdr = session['LOGON.USERID'];
var EnglishName = new Ext.form.TextField({
	allowBlank : false,	
	anchor: '95%',
	selectOnFocus:'true'
             
});

///*************************添加资金流向********************************///
		
//获取科科目类别标识
			var deptDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
			});
			
			
			deptDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:'herp.acct.acctsubjvindicmainexe.csp'+'?action=GetSubjType&str='+encodeURIComponent(Ext.getCmp('dCodeField').getRawValue

()),method:'POST'});
			});
			
			var dCodeField = new Ext.form.ComboBox({
				id: 'dCodeField',
				fieldLabel: '科目类别标识',
				width:180,
				listWidth : 300,
				allowBlank: false,
				store: deptDs,
				valueField: 'code',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'选择...',
				name: 'dCodeField',
				minChars: 1,
				pageSize: 10,
				anchor: '95%',
				selectOnFocus:true,
				forceSelection:'true',
				editable:true
			});



//科目名称
var BSMnameDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

BSMnameDs.on('beforeload', function(ds, o){
  
	 var year =yearCombo.getValue();

          if(!year) 
          {
         	Ext.Msg.show({title:'注意',msg:'请先选择年度！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
         	return;
          }
});


var adjustnumber = new Ext.form.ComboBox({
	id: 'adjustnumber',
	fieldLabel: '调整序号',
	width:120,
	listWidth : 245,
	// allowBlank: false,
	store: BSMnameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请先选择年度....',
	name: 'adjustnumber',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.15,
	forceSelection:'true',
	editable:true
});



// 科目编码///////////////////////////////////
var smYearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

smYearDs.on('beforeload', function(ds, o) {
                     
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.vouctempivinitem.csp?action=Getcode',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '年度',
			store : smYearDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '年度...',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
                       listeners:{
                       select:{
                       fn:function(combo,record,index) { 
                    BSMnameDs.removeAll();     
				
                  BSMnameDs.proxy= new Ext.data.HttpProxy({url:'herp.acct.vouctempivinitem.csp?action=Getname&&accsubjID='+combo.value+'&start=0'+'&limit=10',method:'POST'});      
                  BSMnameDs.load({params:{start:0,limit:10}});   

                  
            }
             }
         }
,
			selectOnFocus : true
		});



var itemDetail = new dhc.herp.Gridwolf({
    title: '凭证临时明细表',
    region : 'center',
    layout:"fit",
    split : true,
    collapsible : true,
    xtype : 'grid',
    trackMouseOver : true,
    stripeRows : true,
    loadMask : true,
    atLoad: true,
    height : 250,
    trackMouseOver: true,
    stripeRows: true,
    atLoad : true, // 是否自动刷新
    edit:false,
    url: 'herp.acct.vouchtempdetail.csp',
    
    fields: [
    {
        id:'rowid',
        header: 'ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'SubjCode',
        header: '会计科目编码',
        dataIndex: 'SubjCode',
        width:100,
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'SubjName',
        header: ' 会计科目名称',
        dataIndex: 'SubjName',
        width:130,
        allowBlank: true,
	editable:true,
	hidden: false
    },{ 
        id:'VouchPage',
        header: ' 凭证页号',
        dataIndex: 'VouchPage',
        align:'right',
        width:60,
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'VouchRow',
        header: '凭证行号',
        dataIndex: 'VouchRow',
        align:'right',
        width:60,
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'Summary',
        header: '摘要',
        dataIndex: 'Summary',
        width:100,
        allowBlank: true,
	editable:true,
	hidden: false
     //   type:yearCombo
    },{
        id:'AmtDebit',
        header: '借方金额',
        dataIndex: 'AmtDebit',
        width:100,
        align:'right',
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'AmtCredit',
        header: '贷方金额',
        dataIndex: 'AmtCredit',
        width:100,
        align:'right',
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'NumDebit',
        header: '借方数量',
        dataIndex: 'NumDebit',
        width:70,
        align:'right',
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'NumCredit',
        header: '贷方数量',
        dataIndex: 'NumCredit',
        width:70,
        align:'right',
        allowBlank: true,
	editable:true,
	hidden: false
    },{ 
        id:'IsCheck',
        header: '是否辅助核算',
        dataIndex: 'IsCheck',
        //align:'right',
        width:90,
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'SubDept',
        header: '所属部门核算',
        dataIndex: 'SubDept',
        width:140,
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'SubSupplier',
        //header: '供应商核算',
        header: '业务分类汇总',
        dataIndex: 'SubSupplier',
        width:100,
        allowBlank: true,
	editable:true,
	hidden: false
    },{ 
        id:'ZjlxID',
        header: '资金流向',
        dataIndex: 'ZjlxID',
        //align:'right',
        width:90,
        allowBlank: true,
	editable:true,
	hidden: false
    },{
        id:'SubPerson',
        header: '个人往来核算',
        dataIndex: 'SubPerson',
        width:100,
        align:'right',
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubClient',
        header: '客户往来核算',
        dataIndex: 'SubClient',
        width:100,
        align:'right',
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubProject',
        header: '项目核算',
        dataIndex: 'SubProject',
        width:100,
        align:'right',
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubDefine1',
        header: '自定义核算1',
        dataIndex: 'SubDefine1',
        width:85,
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubDefine2',
        header: '自定义核算2',
        dataIndex: 'SubDefine2',
        width:85,
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubDefine3',
        header: '自定义核算3',
        dataIndex: 'SubDefine3',
        width:85,
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubDefine4',
        header: '自定义核算4',
        dataIndex: 'SubDefine4',
        width:85,
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubDefine5',
        header: '自定义核算5',
        dataIndex: 'SubDefine5',
        width:85,
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubDefine6',
        header: '自定义核算6',
        dataIndex: 'SubDefine6',
        width:85,
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubDefine7',
        header: '自定义核算7',
        dataIndex: 'SubDefine7',
        width:85,
        allowBlank: true,
	editable:true,
	hidden: true
    },{
        id:'SubDefine8',
        header: '自定义核算8',
        dataIndex: 'SubDefine8',
        width:85,
        allowBlank: true,
	editable:false,
	hidden: true
    },{
        id:'SubDefine9',
        header: '自定义核算9',
        dataIndex: 'SubDefine9',
        width:85,
        allowBlank: true,
	editable:false,
	hidden: true
    },{
        id:'SubDefine10',
        header: '自定义核算10',
        dataIndex: 'SubDefine10',
        width:85,
        allowBlank: true,
	editable:false,
	hidden: true
    }]
	

});

//itemDetail.btnPrintHide();  //隐藏打印按钮
///itemDetail.btnResetHide();  //隐藏重置按钮
itemDetail.btnAddHide();    //隐藏增加按钮
itemDetail.btnSaveHide();   //隐藏保存按钮
itemDetail.btnDeleteHide(); //隐藏删除按钮























