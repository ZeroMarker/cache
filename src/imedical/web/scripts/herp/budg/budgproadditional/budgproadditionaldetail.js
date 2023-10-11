﻿
var BudgProAdditionalDetailUrl = '../csp/herp.budg.budgproadditionaldetailexe.csp';

var userid = session['LOGON.USERID'];
var uname = session['LOGON.USERNAME'];

//预算项名称
var BIDNameDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

BIDNameDs.on('beforeload', function(ds, o){
	var selectedRow = itemMain.getSelectionModel().getSelections();
	year=selectedRow[0].data['projyear'];
	deptdr=selectedRow[0].data['projdeptdr'];
	ds.proxy=new Ext.data.HttpProxy({
	
		url: 'herp.budg.budgprojestablishdetailexe.csp'+'?action=getitemname&year='+year+'&deptdr='+deptdr,method:'POST'});
		});
var BIDNameField = new Ext.form.ComboBox({
	id: 'BIDNameField',
	fieldLabel: '预算项名称',
	width:120,
	listWidth : 245,
	store: BIDNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'预算项名称...',
	name: 'BIDNameField',
	minChars: 1,
	pageSize: 10,
	editable:true,
	selectOnFocus:true,
	forceSelection:'true'
});

//////////////////// 追加预算 ///////////////////////
var budgvaluedetailField = new Ext.form.TextField({
	id: 'budgvaluedetailField',
	width:215,
	listWidth : 215,
	name: 'budgvaluedetailField',
	regex : /^(-?\d+)(\.\d+)?$/,
	regexText : "只能输入数字",
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var addeditStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['1','新增'],['2','更新']]
	});
	var addeditcomb = new Ext.form.ComboBox({
		id: 'isaddedit',
		fieldLabel: '新增-更新',
		width:200,
		listWidth : 250,
		store:addeditStore,
		displayField:'keyValue',
		valueField: 'key',
		mode:'local',
		triggerAction: 'all',
		emptyText:'请选择...',
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		allowBlank: false	//必选项
	});
	

var saveButton = new Ext.Toolbar.Button({
	text: '保存',
    tooltip:'保存',        
    iconCls:'option',
	handler:function(){
		AddFun1();
		//itemMain.store.on("load",function(){  
        //itemMain.getSelectionModel().selectRow(2,true);  
    	//});
    	//itemGrid.load({params:{start:0, limit:25,userid:userid}})
			}
});

var itemDetail = new dhc.herp.Gridlyf({
    title: '',
    region : 'center',
    url: 'herp.budg.budgproadditionaldetailexe.csp',
    tbar:[saveButton],
    
    listeners:{
        'cellclick' : function(grid, rowIndex, columnIndex, e) {
	        var selectedRow = itemMain.getSelectionModel().getSelections();
	        //alert(selectedRow[0]);
	        var	checkstate=selectedRow[0].data['pachkstate'];
	        
	        var record = grid.getStore().getAt(rowIndex);
	       // alert(columnIndex);
               // 根据条件设置单元格点击编辑是否可用
               if ((record.get('rowid') !== '')&&(((columnIndex == 4)||(columnIndex == 6))||((checkstate!== '待提交')&&((columnIndex == 8)||(columnIndex == 9)||(columnIndex == 10))))) {   
                      //Ext.Msg.show({title:'注意',msg:'预算项名称不能修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING}); 
                      return false;
               } else 
                      {
                      return true;
                      }
        },        
        'celldblclick' : function(grid, rowIndex, columnIndex, e) {
            var record = grid.getStore().getAt(rowIndex);
            var selectedRow = itemMain.getSelectionModel().getSelections();
	        var	checkstate=selectedRow[0].data['pachkstate'];
            // 根据条件设置单元格点击编辑是否可用
            if ((record.get('rowid') !== '')&&(((columnIndex == 4)||(columnIndex == 6))||((checkstate!== '待提交')&&((columnIndex == 8)||(columnIndex == 9)||(columnIndex == 10))))) {      
                   return false;
            } else 
                   {
                   return true;
                   }
     }
 },
  
    fields: [
       new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: '明细ID',
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'projadjdr',
        header: '主表ID',
        dataIndex: 'projadjdr',
        width:90,
        allowBlank: true,
		hidden: true
    },{ 
        id:'itemcode',
        header: '预算项编码',
        dataIndex: 'itemcode',
        width:60,
        editable:false,
        hidden: true
    }, {
        id:'bidlevel',
        header: '预算级别',
        width:90,
        editable:true,
        dataIndex: 'bidlevel',
        hidden: true
		
    }, {
        id:'itemname',
        header: '预算项名称',
        width:120,
		//tip:true,
		allowBlank: false,
        dataIndex: 'itemname',
        type: BIDNameField
		
    },{
        id:'bidislast',
        header: '是否末级',
        width:100,
		//tip:true,
		allowBlank: true,
        dataIndex: 'bidislast',
        hidden: true
    },{
        id:'budgprice',
        header: '追加单价',
        align:'right',
        width:80,
	    allowBlank: true,
        dataIndex: 'budgprice',
        type:budgvaluedetailField
    },{
        id:'budgnum',
        header: '追加数量',
        width:80,       
        align:'right',
        dataIndex: 'budgnum'
    },{
        id:'budgvalue',
        header: '追加金额',
        width:100,       
        align:'right',
        editable:false,
        dataIndex: 'budgvalue'
    },{
    	id:'budgdesc',
        header: '设备名称备注',
        width:80,
        dataIndex: 'budgdesc'
    },{           
	    id:'isaddedit',
	    header: '新增/更新',
	    allowBlank: false,
	    width:60,
	    dataIndex: 'isaddedit',
	    type:addeditcomb
	},{           
	    id:'PerOrigin',
	    header: '人员资质-原有设备',
	    allowBlank: true,
	    width:120,
	    dataIndex: 'PerOrigin'
	},{
    	id:'FeeScale',
        header: '收费标准',
        width:80,
        allowBlank: true,
        dataIndex: 'FeeScale'
    },{
    	id:'AnnBenefit',
        header: '年效益预测',
        width:80,
        allowBlank: true,
        dataIndex: 'AnnBenefit'
    },{
    	id:'MatCharge',
        header: '耗材费',
        width:80,
        allowBlank: true,
        dataIndex: 'MatCharge'
    },{
    	id:'SupCondit',
        header: '配套条件',
        width:80,
        allowBlank: true,
        dataIndex: 'SupCondit'
    },{
    	id:'Remarks',
        header: '备注',
        width:80,
        allowBlank: true,
        dataIndex: 'Remarks'
    },{           
	         id:'brand1',
	         header: '推荐品牌1',
	         allowBlank: true,
	         width:60,
	         dataIndex: 'brand1'
	    },{           
	         id:'spec1',
	         header: '规格型号1',
	         allowBlank: true,
	         width:60,
	         dataIndex: 'spec1'
	    },{           
	         id:'brand2',
	         header: '推荐品牌2',
	         allowBlank: true,
	         width:60,
	         dataIndex: 'brand2'
	    },{           
	         id:'spec2',
	         header: '规格型号2',
	         allowBlank: true,
	         width:60,
	         dataIndex: 'spec2'
	    },{           
	         id:'brand3',
	         header: '推荐品牌3',
	         allowBlank: true,
	         width:60,
	         dataIndex: 'brand3'
	    },{           
	         id:'spec3',
	         header: '规格型号3',
	         allowBlank: true,
	         width:60,
	         dataIndex: 'spec3'
	    }],
    
					xtype : 'grid',				
					//viewConfig : {
						//forceFit : true
					//},
					height : 200
					
});

itemDetail.hiddenButton(2);
AddFun1=function() {
		var records=itemDetail.store.getModifiedRecords();
		var o = {};
	    var tmpDate = itemDetail.dateFields;
	    var tmpstro = "";
	    var tmpstros="";
	    var data = [];
	    var rtn = 0;
	    var datad="";
	    //var rowObj=itemGrid.getSelectionModel().getSelections();
				
		Ext.each(records, function(r) {
			
			var rowObj=itemMain.getSelectionModel().getSelections();
			datad=rowObj[0].get("parowid")+'|'+rowObj[0].get("projyear");
			var chkstate = rowObj[0].get("pachkstate");
			//alert(chkstate);
			var o = {};
			var tmpstro = "&rowid=" + r.data['rowid'];
			var deleteFlag = r.data['delFlag'];// 删除标识，1：是该记录已经删除，0：未删除。
			
			// 数据完整性验证Beging
			for (var i = 0; i < itemDetail.fields.length; i++) {
				var indx = itemDetail.getColumnModel().getColumnId(i + 1)
				var tmobj = itemDetail.getColumnModel().getColumnById(indx)
				if (tmobj != null) {
					// 列增加update属性，true：该列数据没有变化也向后台提交数据，false：则不会强制提交数据
					var reValue = r.data[indx];
					if ((typeof(reValue) != "undefined") && (tmobj.update)) {
						tmpstro += "&" + indx + "=" + r.data[indx].toString();
					}
					if (tmobj.allowBlank == false) {
						var title = tmobj.header
						if ((r.data[indx].toString() == "")|| (parseInt(r.data[indx].toString()) == 0)) {
							var info = "[" + title + "]列为必填项，不能为空或零！"
							Ext.Msg.show({
										title : '错误',
										msg : info,
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							rtn = -1;
							return -1;

						}
					}
				}

			}
			// 数据完整性验证END

			if (r.isValid()) {
				if (deleteFlag == "-1") {
					return;
				}
			
			} else {
				Ext.Msg.show({
							title : '错误',
							msg : '请将数据添加完整后再试!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			}
			
			
			var recordType;
			if (r.data.newRecord) {
				recordType = "add";
			} else {
				recordType = "edit";
			}
			
			datad=datad+'|'+r.data['itemname']+'|'+r.data['budgnum']+'|'+r.data['budgprice'].replace(/,/g,'')+'|'+encodeURIComponent(r.data['budgdesc'])
			+'|'+r.data['FeeScale']+'|'+r.data['AnnBenefit']+'|'+r.data['MatCharge']+'|'+r.data['SupCondit']+'|'+r.data['Remarks']+'|'+r.data['budgprice']+'|'
			+r.data['brand1']+'|'+r.data['spec1']+'|'+r.data['brand2']+'|'+r.data['spec2']+'|'+r.data['brand3']+'|'+r.data['spec3']+'|'+r.data['isaddedit']+"|"+r.data['PerOrigin']
			+"|"+userid+'|'+uname;
			var saveUrl = itemDetail.url + '?action='+recordType+tmpstro+'&data='+encodeURIComponent(datad)+Ext.urlEncode(this.urlParam);
			//alert(saveUrl)
			p = {
				url : saveUrl,
				method : 'GET',
				waitMsg : '保存中...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					if (chkstate != 1){
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {

						var message = "";
						message = recordType == 'add' ? '添加成功!' : '保存成功!'
						Ext.Msg.show({
									title : '注意',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
						itemDetail.store.commitChanges();
						var store = itemMain.getStore();
						var dataindex = store.indexOf(rowObj[0]);//获取行号
						if (jsonData.refresh == 'true') {
							itemDetail.store.load({
								params : {
									start : Ext
											.isEmpty(itemDetail.getTopToolbar().cursor)
											? 0
											: itemDetail.getTopToolbar().cursor,
									limit : itemDetail.pageSize
								}
							});
							itemMain.load({params:{start:0, limit:25,userid:userid}});
							itemMain.store.on("load",function(){ 
					        itemMain.getSelectionModel().selectRow(dataindex,true);

					 });
						}
					} else {
						if (jsonData.refresh == 'true') {
							itemDetail.store.load({
								params : {
									start : Ext
											.isEmpty(itemDetail.getTopToolbar().cursor)
											? 0
											: itemDetail.getTopToolbar().cursor,
									limit : itemDetail.pageSize
								}
							});
							itemMain.load({params:{start:0, limit:25,userid:userid}});
							itemMain.store.on("load",function(){ 
					        itemMain.getSelectionModel().selectRow(dataindex,true);

					 });
						}
						var message = "";
						message = "SQLErr: " + jsonData.info;
						if (jsonData.info == 'EmptyName')
							message = '输入的名称为空!';
						if (jsonData.info == 'EmptyOrder')
							message = '输入的序号为空!';
						if (jsonData.info == 'RepCode')
							message = '输入的编码已经存在!';
						if (jsonData.info == 'RepName')
							message = '输入的名称已经存在!';
						if (jsonData.info == 'RepOrder')
							message = '输入的序号已经存在!';
						if (jsonData.info == 'RecordExist')
							message = '输入的记录已经存在!';
						Ext.Msg.show({
									title : '错误',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						itemDetail.store.rejectChanges();
					}
				}else{
					Ext.Msg.show({
									title : '数据已提交，不能再修改',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					
					}},
				scope : this
			};
			Ext.Ajax.request(p);
		}, this);
				
		return rtn;
	}

